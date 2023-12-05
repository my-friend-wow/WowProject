from dotenv import load_dotenv
import RPi.GPIO as GPIO
import requests
import logging
import time
import json
import os


load_dotenv()


def send_pedometer_post_request():
    """
    SW-18010P 모듈 사용,
    진동 감지될 때마다 실행되며 백엔드 서버로 걸음 수 + 1 POST 요청.
    """
    url = os.getenv('URL') + '/pedometer_post'
    doll_id = os.getenv('DOLL_ID')

    headers = {'Content-Type': 'application/json'}
    data = {'doll_id': doll_id}

    log_file = 'pedometer.log'
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
    SW18010P 모듈은 기본값이 `GPIO.HIGH`이고,
    충격이 감지될 때 `GPIO.LOW`로 바뀜
    """
    GPIO.setmode(GPIO.BCM)
    SENSOR_PIN = 17
    GPIO.setup(SENSOR_PIN, GPIO.IN)

    try:
        while True:
            if GPIO.input(SENSOR_PIN) == GPIO.LOW:
                send_pedometer_post_request()
            time.sleep(0.04)
    
    finally:
        GPIO.cleanup()


if __name__ == '__main__':
    sw18010p()
