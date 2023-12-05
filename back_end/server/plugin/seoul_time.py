from datetime import datetime, timedelta


def get_current_seoul_time():
    """
    utc에 9를 더하여 서울 시간 반환하는 함수
    """
    return datetime.utcnow() + timedelta(hours=9)
