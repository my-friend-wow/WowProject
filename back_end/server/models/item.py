from api.common import db


class Item(db.Model):
    __table_args__ = {'schema': 'industry'}
    __tablename__ = 'items'

    user_id = db.Column(db.String(20), primary_key=True, nullable=False)
    item_id = db.Column(db.String(255), primary_key=True, nullable=False)
    item_name = db.Column(db.String(255), nullable=False)
