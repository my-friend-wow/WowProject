from api.common import db
from plugin.seoul_time import get_current_seoul_time


class User(db.Model):
    __table_args__ = {'schema': 'industry'}
    __tablename__ = 'users'

    user_id = db.Column(db.String(255), unique=True, nullable=False, primary_key=True)
    user_pw = db.Column(db.String(255), nullable=False)
    token = db.Column(db.String(255), nullable=False)
    coin_count = db.Column(db.Integer, nullable=False, default=0)
    step_count = db.Column(db.Integer, nullable=False, default=0)
    created_at = db.Column(
        db.TIMESTAMP(timezone=True),
        default=get_current_seoul_time,
        nullable=False
    )
