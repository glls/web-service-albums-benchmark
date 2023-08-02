Install

```
python3 -m venv venv
. ./venv/bin/activate
pip install -r requirements.txt
```

Run with uvicorn without logging
```
uvicorn  app:app --log-level critical
```
