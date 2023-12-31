from api.common import db


class Doll(db.Model):
    __table_args__ = {'schema': 'industry'}
    __tablename__ = 'dolls'

    user_id = db.Column(db.String(20), unique=True, nullable=False, primary_key=True)
    doll_name = db.Column(db.Unicode(6), nullable=False)
    doll_id = db.Column(db.String(255), nullable=False)
