FROM python:3.7.4 as builder

WORKDIR /app

COPY . /app

FROM python:3.7.4

WORKDIR /app

COPY --from=builder /app/api.py /app/

COPY --from=builder /app/requirements.txt  /app/

RUN pip install --no-cache-dir -r requirements.txt

CMD ["gunicorn", "--bind", "0.0.0.0:8000", "api:app"]
