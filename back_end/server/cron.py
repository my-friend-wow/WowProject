from sqlalchemy.exc import SQLAlchemyError
from api.common import db, app
from models.user import User


def reset_step_count_per_day():
    """
    매일 00시 cronjob 실행되는 함수
    모든 유저의 걸음 수를 0으로 초기화
    """
    with app.app_context():
        all_user_data = User.query.all()

        for user_data in all_user_data:
            user_data.step_count = 0
    
        try:
            db.session.commit()
        except SQLAlchemyError as e:
            db.session.rollback()
            raise e


if __name__ == '__main__':
    reset_step_count_per_day()
