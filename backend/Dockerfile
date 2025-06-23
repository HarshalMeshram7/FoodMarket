FROM python:3.11-slim

EXPOSE 5003

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1

# ✅ Install system-level dependencies required to build Python packages like mysqlclient
RUN apt-get update && apt-get install -y \
    gcc \
    default-libmysqlclient-dev \
    build-essential \
    pkg-config \
    python3-dev \
    libssl-dev \
 && apt-get clean \
 && rm -rf /var/lib/apt/lists/*

# ✅ Install Python dependencies
COPY requirements.txt .
RUN pip install -r requirements.txt

# ✅ Copy your app code
WORKDIR /app
COPY . /app


CMD ["gunicorn", "--bind", "0.0.0.0:5003", "app:app"]
