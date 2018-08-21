FROM python:2.7.15-slim-stretch

COPY requirements.txt /
RUN pip install --no-cache-dir -r /requirements.txt

