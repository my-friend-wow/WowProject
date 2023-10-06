from dotenv import load_dotenv
import os
import jwt

load_dotenv()


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
