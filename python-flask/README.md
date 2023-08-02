Install

```
python3 -m venv venv
. ./venv/bin/activate
pip install -r requirements.txt
```

Run with gunicorn without logging
```
gunicorn app:app --workers=24 --log-level critical
```
