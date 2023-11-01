## Usage

> **Note**
> Make sure to create `.env` file inside the `/raspberry_pi` directory based on `.env.example`.

- Install Virtual Environment & Requirements

```bash
python3 -m venv myenv
source myenv/bin/activate
pip3 install -r requirements.txt
```

- System Service Setting

```bash
sudo cp industry.service /etc/systemd/system/industry.service
sudo systemctl daemon-reload
sudo systemctl enable industry
sudo systemctl start industry
```
