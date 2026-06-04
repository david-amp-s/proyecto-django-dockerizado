FROM python:3.12-slim
WORKDIR /app
RUN apt-get update && apt-get install -y \
    gcc \
    g++ \
    libcairo2-dev \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY . .
RUN DATABASE_URL='' python manage.py collectstatic --noinput
CMD ["sh", "-c", "python manage.py migrate && python create_superuser.py && gunicorn config.wsgi:application --bind 0.0.0.0:$PORT"]