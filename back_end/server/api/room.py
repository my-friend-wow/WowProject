from flask import request, jsonify
from sqlalchemy.exc import SQLAlchemyError

from api.common import app, db
from plugin.token_check import verify_token
from models.user import User
from models.doll import Doll
from models.user_daily_activity import UserDailyActivity


@app.route('/my_room_get/<user_id>', methods=['GET'])
def my_room_get(user_id):
    """
    마이룸 GET
    프론트에서 이를 활용
    유저 본인의 레벨, 코인 개수를 반환
    """
    token = request.headers.get('Authorization')
    payload = verify_token(token)
    if not payload:
        return jsonify(message='올바르지 않은 API 접근입니다. 관리자에게 문의하세요.'), 401

    user_data = User.query.filter_by(user_id=user_id).first()

    if not user_data:
        return jsonify(message='유저가 존재하지 않습니다. 관리자에게 문의하세요.'), 404

    user_level = user_data.character_level
    user_coin = user_data.coin_count

    return jsonify(user_level=user_level, user_coin=user_coin), 200


@app.route('/friend_room_get/<user_id>/<friend_user_id>', methods=['GET'])
def friend_room_get(user_id, friend_user_id):
    """
    친구 마이룸 GET
    프론트에서 이를 활용
    1. 친구 유저의 레벨 반환
    2. 본인 유저의 레벨 반환 (친구 옆에 본인 캐릭터가 함께 화면에 나타날 수 있도록)
    3. 하루 한 번만 친구 집 방문 시 코인 += 1
    """
    token = request.headers.get('Authorization')
    payload = verify_token(token)
    if not payload:
        return jsonify(message='올바르지 않은 API 접근입니다. 관리자에게 문의하세요.'), 401

    doll_data = Doll.query.filter_by(user_id=user_id).first()
    user_data = User.query.filter_by(user_id=user_id).first()
    frined_user_data = User.query.filter_by(user_id=friend_user_id).first()

    if not doll_data:
        return jsonify(message='유저의 인형이 존재하지 않습니다. 관리자에게 문의하세요.'), 404

    if not user_data:
        return jsonify(message='유저가 존재하지 않습니다. 관리자에게 문의하세요.'), 404

    if not frined_user_data:
        return jsonify(message='친구 유저가 존재하지 않습니다. 관리자에게 문의하세요.'), 404

    user_activity_data = UserDailyActivity.query.filter_by(user_id=user_id).first()
    
    if not user_activity_data.today_visited:
        user_data.coin_count += 1
        user_activity_data.today_visited = 1

        try:
            db.session.commit()
        except SQLAlchemyError:
            db.session.rollback()
            return jsonify(message='유저에게 코인 지급 도중 에러가 발생했습니다.'), 500

    user_level = user_data.character_level
    my_doll_name = doll_data.doll_name
    friend_level = frined_user_data.character_level

    return jsonify(my_doll_name=my_doll_name, user_level=user_level, friend_level=friend_level), 200
