from flask import request, jsonify
from sqlalchemy.exc import SQLAlchemyError

from api.common import app, db
from plugin.account_check import is_id_valid_input, is_pw_valid_input, generate_token
from models.user import User
from models.doll import Doll
from models.user_daily_activity import UserDailyActivity


@app.route('/signup', methods=['POST'])
def sign_up():
    """
    회원가입 API
    JSON 형식으로 user_id (str), user_pw(str) 넘기기
    """
    data = request.get_json()
    user_id = data.get('user_id')
    user_pw = data.get('user_pw')

    doll_name = data.get('doll_name')
    doll_id = data.get('doll_id')

    existing_user = User.query.filter_by(user_id=user_id).first()
    existing_doll = Doll.query.filter_by(user_id=user_id).first() 

    existing_doll_id = Doll.query.filter_by(doll_id=doll_id).first()

    if existing_user or existing_doll:
        return jsonify(message='이미 회원가입한 적이 있는 아이디입니다. 로그인하세요.'), 400

    if existing_doll_id:
        return jsonify(message='이미 다른 사람이 사용 중인 인형입니다. 다른 인형 id로 가입하세요.'), 400

    if len(user_id) == 0 or not is_id_valid_input(user_id):
        return jsonify(message='아이디는 알파벳 소문자와 숫자, 특수문자 _만 허용되며 5자 이상이어야만 합니다.'), 422

    if len(user_pw) == 0 or not is_pw_valid_input(user_pw):
        return jsonify(
            message='비밀번호는 알파벳 대소문자와 숫자, 특수문자 !, @, *, _만 허용되며, 8자 이상이어야만 합니다.'
            ), 422
    
    if len(user_id) > 20:
        return jsonify(message='아이디는 20자 이내로 해주세요.'), 422
    
    if len(user_pw) > 20:
        return jsonify(message='비밀번호는 20자 이내로 해주세요.'), 422

    if len(doll_name) == 0:
        return jsonify(message='인형 이름을 정하여 반드시 입력해주세요.'), 422

    if len(doll_name) > 6:
        return jsonify(message='인형 이름은 6자 이내로 해주세요.'), 422

    if len(doll_id) == 0:
        return jsonify(message='인형에 적힌 고유 id를 반드시 입력해야합니다.'), 422

    token = generate_token(user_id)

    try:
        new_user = User(user_id=user_id, user_pw=user_pw, token=token)
        new_user_daily_activities = UserDailyActivity(user_id=user_id)
        new_doll = Doll(user_id=user_id, doll_name=doll_name, doll_id=doll_id)

        db.session.add_all([new_user, new_user_daily_activities, new_doll])
        db.session.commit()

    except SQLAlchemyError:
        db.session.rollback()
        return jsonify(message='회원정보 저장 도중 에러가 발생했습니다. 다시 시도해주세요.'), 500

    return jsonify(message='회원가입이 완료되었습니다.'), 201


@app.route('/signin', methods=['POST'])
def sign_in():
    """
    로그인 API
    JSON 형식으로 user_id (str), user_pw(str) 넘기기
    """
    data = request.get_json()
    user_id = data.get('user_id')
    user_pw = data.get('user_pw')

    user = User.query.filter_by(user_id=user_id).first()
    if not user:
        return jsonify(message='아이디가 존재하지 않습니다.'), 404

    if user.user_id != user_id:
        return jsonify(message='아이디가 일치하지 않습니다.'), 401

    if user.user_pw != user_pw:
        return jsonify(message='비밀번호가 일치하지 않습니다.'), 401

    token = user.token

    return jsonify({"message": "로그인 되었습니다.", "token": token}), 200
