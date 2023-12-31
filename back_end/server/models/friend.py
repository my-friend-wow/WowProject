from api.common import db


class Friend(db.Model):
    __table_args__ = {'schema': 'industry'}
    __tablename__ = 'friends'

    user_id = db.Column(db.String(20), primary_key=True, nullable=False)
    friend_doll_id = db.Column(db.String(255), primary_key=True, nullable=False)
