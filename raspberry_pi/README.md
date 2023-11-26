## Usage

> [!Note]
> Make sure to create `.env` file inside the `/raspberry_pi` directory based on `.env.example`.

> [!Note]
> SW-18010P uses GPIO 17. The tact switch uses GPIO 16. And The reference for RFID RC522 is [here](https://www.youtube.com/watch?v=evRuZRxvPFI).

- Install Virtual Environment & Requirements

    ```bash
    python3 -m venv myenv &&
    source myenv/bin/activate &&
    pip3 install -r requirements.txt
    ```

- System Service Setting
  - English
    ```bash
    sudo cp communication_eng.service /etc/systemd/system/communication_eng.service &&
    sudo systemctl daemon-reload &&
    sudo systemctl enable pedometer rfid communication_eng &&
    sudo systemctl start pedometer rfid communication_eng
    ```

  - Korean
    ```bash
    sudo cp communication_kor.service /etc/systemd/system/communication_kor.service &&
    sudo systemctl daemon-reload &&
    sudo systemctl enable pedometer rfid communication_kor &&
    sudo systemctl start pedometer rfid communication_kor
    ```

## Hardware

> [!Important]
> Raspberry Pi may not find speaker and microphone, so please refer [here](https://askubuntu.com/questions/150851/how-do-i-select-a-default-sound-card-with-alsa) and set it up.

|Name|Use|
|:--:|:--:|
|Raspberry Pi 4GB Model B|-|
|SW-18010P|Pedometer|
|Tact Switch|Button|
|Speaker, Microphone(USB)|Having a conversation with a doll|
|RFID-RC522|Making friends|
