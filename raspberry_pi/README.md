## Usage

> **Note**
> Make sure to create `.env` file inside the `/raspberry_pi` directory based on `.env.example`.

> **Note**
> SW-18010P uses GPIO 17. The reference for RFID RC522 is [here](https://www.youtube.com/watch?v=evRuZRxvPFI).

- Install Virtual Environment & Requirements

```bash
python3 -m venv myenv
source myenv/bin/activate
pip3 install -r requirements.txt
```

- System Service Setting

```bash
sudo cp pedometer.service /etc/systemd/system/pedomter.service
sudo cp rfid.service /etc/systemd/system/rfid.service
sudo systemctl daemon-reload
sudo systemctl enable pedometer rfid
sudo systemctl start pedometer rfid
```
