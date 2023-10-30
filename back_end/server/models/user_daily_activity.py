from api.common import db


class UserDailyActivity(db.Model):
    __table_args__ = {'schema': 'industry'}
    __tablename__ = 'user_daily_activities'

    user_id = db.Column(db.String(20), unique=True, nullable=False, primary_key=True)
    today_walked = db.Column(db.Boolean, nullable=False, default=False)
    today_visited = db.Column(db.Boolean, nullable=False, default=False)
