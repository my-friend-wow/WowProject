from dotenv import load_dotenv
import jwt
import os
import re

load_dotenv()


def is_id_valid_input(input_string):
    """
    아이디는 5자 이상, 특수문자(_)와 알파벳 대/소문자, 숫자만. 정규표현식으로 유효성 검사하는 함수
    """
    pattern = r'^[a-z0-9_]{5,}$'
    return re.match(pattern, input_string)


def is_pw_valid_input(input_string):
    """
    비밀번호는 8자리 이상, 특수문자(!, @, *, _)와 알파벳 대/소문자, 숫자만. 정규표현식으로 유효성 검사하는 함수
    """
    pattern = r'^[a-zA-Z0-9!@*_]{8,}$'
    return re.match(pattern, input_string)


def generate_token(user_id):
    """
    API 보안을 위한 개인 token 생성하는 함수
    """
    payload = { 'user_id': user_id }

    secret_key = os.getenv('SECRET_KEY')
    token = jwt.encode(payload, secret_key, algorithm='HS256')
    
    return token


def verify_token(token):
    """
    개인 token이 유효 상태인지 검사하는 함수
    """
    secret_key = os.getenv('SECRET_KEY')

    try:
        payload = jwt.decode(token, secret_key, algorithms=['HS256'])
        return payload
    except jwt.InvalidTokenError:
        return None
