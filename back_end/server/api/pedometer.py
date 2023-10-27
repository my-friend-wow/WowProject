from flask import request, jsonify
from sqlalchemy.exc import SQLAlchemyError

from api.common import app, db
from plugin.token_check import verify_token
from models.user import User
from models.doll import Doll
from models.user_daily_activity import UserDailyActivity


@app.route('/pedometer_post', methods=['POST'])
def pedometer_post():
    """
    만보기 POST API
    Raspberry Pi에서 충격 신호가 올 때마다 이 API가 호출됨
    걸음 수 += 1
    매일 자정 걸음 수 초기화됨
    """
    data = request.get_json()
    doll_id = data.get('doll_id')

    doll_data = Doll.query.filter_by(doll_id=doll_id).first()

    if not doll_data:
        return jsonify(message='인형 id를 찾을 수 없습니다. 관리자에게 문의하세요.'), 404

    user_id = doll_data.user_id

    user_data = User.query.filter_by(user_id=user_id).first()
    
    user_data.step_count += 1

    try:
        db.session.commit()
    except SQLAlchemyError:
        db.session.rollback()
        return jsonify(message='유저 걸음 수 정보 저장 도중 에러가 발생했습니다.'), 500

    return jsonify(message="걸음 수+1 DB 저장을 완료했습니다."), 200


@app.route('/pedometer_get/<user_id>', methods=['GET'])
def pedometer_get(user_id):
    """
    만보기 GET API
    1. 프론트에서 만보기 페이지에 유저가 머무를 때, 5초마다 이 API를 호출할 예정
    2. 프론트에서 걸음 수 <-> 코인 교환 페이지에 접속할 때, 이 API를 호출할 예정
    User의 현재 걸음 수를 반환
    """
    token = request.headers.get('Authorization')
    payload = verify_token(token)
    if not payload:
        return jsonify(message='올바르지 않은 API 접근입니다. 관리자에게 문의하세요.'), 401

    user_data = User.query.filter_by(user_id=user_id).first()

    if not user_data:
        return jsonify(message='유저를 찾을 수 없습니다. 관리자에게 문의하세요.'), 404

    step_count = user_data.step_count

    return jsonify(step_count=step_count), 200


@app.route('/pedometer_coin_exchange', methods=['POST'])
def pedometer_coin_exchange():
    """
    걸음 수 <-> 코인 교환 API
    user_id, coin_amount를 받아 해당 유저의 코인 개수 증가
    """
    token = request.headers.get('Authorization')
    payload = verify_token(token)
    if not payload:
        return jsonify(message='올바르지 않은 API 접근입니다. 관리자에게 문의하세요.'), 401

    data = request.get_json()
    user_id = data.get('user_id')
    coin_amount = data.get('coin_amount')

    user_activity_data = UserDailyActivity.query.filter_by(user_id=user_id).first()
    
    if user_activity_data.today_walked:
        return jsonify(message='이미 오늘 코인을 교환하셨습니다.'), 422

    user_data = User.query.filter_by(user_id=user_id).first()
    user_data.coin_count += coin_amount

    user_activity_data.today_walked = 1

    try:
        db.session.commit()
    except SQLAlchemyError:
        db.session.rollback()
        return jsonify(message='유저에게 코인 지급 도중 에러가 발생했습니다.'), 500

    return jsonify(message="코인 지급이 완료됐습니다."), 200
