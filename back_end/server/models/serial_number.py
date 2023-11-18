from api.common import db


class SerialNumber(db.Model):
    __table_args__ = {'schema': 'industry'}
    __tablename__ = 'serial_numbers'

    doll_id = db.Column(db.String(255), unique=True, nullable=False, primary_key=True)
    is_active = db.Column(db.Boolean, nullable=False, default=False)
