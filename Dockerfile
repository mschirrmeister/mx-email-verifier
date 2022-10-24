FROM python:3.10.8-slim-bullseye

RUN pip install dnspython argparse

COPY MXEmailVerifier.py /app/MXEmailVerifier.py

ENTRYPOINT ["python", "/app/MXEmailVerifier.py"]
CMD [ "-e", "noreply@example.com" ]
