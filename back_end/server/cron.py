from sqlalchemy.exc import SQLAlchemyError
from api.common import db, app
from models.user import User
from models.user_daily_activity import UserDailyActivity
from models.friend import Friend


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


def reset_activity_per_day():
    """
    매일 00시 cronjob 실행되는 함수
    모든 유저의 오늘 걷기, 방문을 통해 코인 교환했는지 여부를 0으로 초기화
    """
    with app.app_context():
        all_user_activity_data = UserDailyActivity.query.all()

        for user_activity_data in all_user_activity_data:
            user_activity_data.today_walked = 0
            user_activity_data.today_visited = 0
            
        try:
            db.session.commit()
        except SQLAlchemyError as e:
            db.session.rollback()
            raise e


def reset_friend_list_per_day():
    """
    매일 00시 cronjob 실행되는 함수
    모든 유저의 오늘 접촉한 친구 목록을 초기화
    """
    with app.app_context():            
        try:
            Friend.query.delete()
            db.session.commit()
        except SQLAlchemyError as e:
            db.session.rollback()
            raise e


def check_level_up():
    """
    매일 00시 cronjob 실행되는 함수
    유저의 코인 개수를 확인해 레벨(0~4)을 변경
    """
    with app.app_context():
        all_user_data = User.query.all()
        has_changes = False

        for user_data in all_user_data:
            if user_data.coin_count == 60:
                user_data.character_level = 4
                has_changes = True
            elif user_data.coin_count == 40:
                user_data.character_level = 3
                has_changes = True
            elif user_data.coin_count == 20:
                user_data.character_level = 2
                has_changes = True
            elif user_data.coin_count == 10:
                user_data.character_level = 1
                has_changes = True

        if has_changes:
            try:
                db.session.commit()
            except SQLAlchemyError as e:
                db.session.rollback()
                raise e


if __name__ == '__main__':
    reset_step_count_per_day()
    reset_activity_per_day()
    reset_friend_list_per_day()
    check_level_up()
