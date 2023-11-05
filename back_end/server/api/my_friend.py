from flask import request, jsonify
from sqlalchemy.exc import SQLAlchemyError

from api.common import app, db
from plugin.token_check import verify_token
from models.user import User
from models.friend import Friend
from models.doll import Doll


@app.route('/friend_post', methods=['POST'])
def my_friend_post():
    """
    친구 사귀기 POST API
    Raspberry Pi에서 RFID 모듈에 ID Card가 접촉했을 때 호출됨
    자신의 UID = doll_id
    doll_id를 기준으로 해당 User의 Friend 테이블에 친구 추가
    """
    data = request.get_json()
    doll_id = data.get('doll_id') # User 본인 UID(doll_id)
    friend_doll_id = data.get('friend_doll_id') # Friend UID(doll_id)
    
    if doll_id != friend_doll_id: # 본인 카드 접촉이 아닐 때만 수행
        user_data = Doll.query.filter_by(doll_id=doll_id).first()
        
        if user_data is None:
            return jsonify(message='유저의 doll_id로 서비스에 가입한 적이 없습니다. 관리자에게 문의해주세요.'), 404
        
        user_id = user_data.user_id

        existing_friend_doll_data = Doll.query.filter_by(doll_id=friend_doll_id).first()

        if existing_friend_doll_data is not None: # 친구의 doll_id를 통해 친구가 등록된 회원인지 우선 확인
            existing_friend = Friend.query.filter_by(user_id=user_id, friend_doll_id=friend_doll_id).first()

            if existing_friend is None: # 이미 친구 목록에 저장된 친구가 아닐 때만 수행
                try:
                    new_friend = Friend(user_id=user_id, friend_doll_id=friend_doll_id)
                    
                    db.session.add(new_friend)
                    db.session.commit()
                
                except SQLAlchemyError:
                    db.session.rollback()
                    return jsonify(message='친구 목록에 저장 도중 에러가 발생했습니다. 다시 시도해주세요.'), 500
            else:
                return jsonify(message='이미 친구 목록에 저장된 정보입니다.'), 400
        else:
            return jsonify(message='친구의 doll_id가 서비스에 가입된 적이 없습니다. 관리자에게 문의해주세요.'), 404
    else:
        return jsonify(message='본인 카드가 접촉되었으므로 무시되었습니다.'), 400

    return jsonify(message="친구 목록에 저장을 완료했습니다."), 200


@app.route('/friend_get/<user_id>', methods=['GET'])
def my_friend_get(user_id):
    """
    친구 사귀기 GET API
    해당 유저의 친구 목록을 반환
    """
    token = request.headers.get('Authorization')
    payload = verify_token(token)
    if not payload:
        return jsonify(message='올바르지 않은 API 접근입니다. 관리자에게 문의하세요.'), 401

    user_ids = [user.user_id for user in User.query.all()]
    if user_id not in user_ids:
        return jsonify(message='해당 유저가 존재하지 않습니다.'), 404

    friend_data = Friend.query.filter_by(user_id=user_id).all()

    if not friend_data:
        return jsonify([]), 200

    friend_doll_ids = [friend.friend_doll_id for friend in friend_data]
    
    friend_info = []

    if len(friend_doll_ids) > 0:
        for friend_doll_id in friend_doll_ids:
            doll_data = Doll.query.filter_by(doll_id=friend_doll_id).first()
            friend_info.append({
                'user_id': doll_data.user_id,
                'doll_name': doll_data.doll_name
            })

    return jsonify(friend_info), 200
