from dotenv import load_dotenv
from mfrc522 import SimpleMFRC522
import RPi.GPIO as GPIO
import requests
import logging
import time
import json
import os


load_dotenv()


def check_log_directory_existence():
    log_directory = '/var/log/industry'

    if not os.path.exists(log_directory):
        os.makedirs(log_directory)


def send_pedometer_post_request():
    """
    SW-18010P 모듈 사용,
    진동 감지될 때마다 실행되며 백엔드 서버로 걸음 수 + 1 POST 요청.
    """
    url = os.getenv('URL') + '/pedometer_post'
    doll_id = os.getenv('DOLL_ID')

    headers = {'Content-Type': 'application/json'}
    data = {'doll_id': doll_id}

    log_file = '/var/log/industry/pedometer.log'
    logging.basicConfig(filename=log_file, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

    try:
        response = requests.post(url, data=json.dumps(data), headers=headers)
        response.raise_for_status()

    except requests.exceptions.HTTPError as errh:
        logging.error("HTTP 오류 발생:", errh)

    except requests.exceptions.ConnectionError as errc:
        logging.error("에러 발생. 연결 확인해주세요:", errc)

    except requests.exceptions.Timeout as errt:
        logging.error("Timeout 에러:", errt)

    except requests.exceptions.RequestException as err:
        logging.error("에러가 발생했습니다.", err)


def sw18010p():
    """
    실시간으로 진동이 감지되는지 체크하는 함수
    """
    GPIO.setmode(GPIO.BCM)

    SENSOR_PIN = 17

    GPIO.setup(SENSOR_PIN, GPIO.IN)

    try:
        while True:
            sensor_value = GPIO.input(SENSOR_PIN)
            
            if sensor_value == GPIO.HIGH: #진동 감지됨
                send_pedometer_post_request()

            time.sleep(1)

    except KeyboardInterrupt:
        GPIO.cleanup()


def send_rfid_post_request(id, text):
    """
    RFID RC522 모듈 사용,
    NFC 감지될 때마다 실행되며 백엔드 서버로 친구 ID POST 요청.
    """
    url = os.getenv('URL') + '/friend_post'
    doll_id = os.getenv('DOLL_ID')
    friend_doll_id = id

    headers = {'Content-Type': 'application/json'}
    data = {'doll_id': doll_id, 'friend_doll_id': friend_doll_id}

    log_file = '/var/log/industry/friend.log'
    logging.basicConfig(filename=log_file, level=logging.INFO, format='%(asctime)s - %(levelname)s - %(message)s')

    ##
    # @SimpleCorini 여기 구현하기 !!
    ##


def rfid_rc522():
    reader = SimpleMFRC522()

    try:
        while True:
            id, text = reader.read()
            send_rfid_post_request(id, text)

            time.sleep(10)
    finally:
        GPIO.cleanup()


if __name__ == '__main__':
    check_log_directory_existence()
    sw18010p()
    rfid_rc522()
