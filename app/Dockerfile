# syntax=docker/dockerfile:1.7
FROM python:3.12-slim AS runtime

# 1) Basic hardening & reliable pip
ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    PIP_DISABLE_PIP_VERSION_CHECK=1 \
    PIP_NO_CACHE_DIR=1

WORKDIR /app

# 2) System deps (only if you need them) + curl for healthchecks
# If you don't need build tools, skip build-essential.
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl \
  && rm -rf /var/lib/apt/lists/*

# 3) Install deps first to leverage Docker layer caching
COPY requirements.txt .
RUN python -m pip install --upgrade pip \
 && pip install --no-cache-dir -r requirements.txt

# 4) Copy the app
COPY . .

# 5) Non-root user
RUN useradd -m -u 10001 appuser \
 && chown -R appuser:appuser /app
USER appuser

# 6) Use Gunicorn in production (app factory from the project I gave you)
EXPOSE 8000
HEALTHCHECK --interval=30s --timeout=3s --retries=3 CMD curl -f http://127.0.0.1:8000/ || exit 1

# Prefer CMD for overridability; ENTRYPOINT can stay the binary
ENTRYPOINT ["gunicorn"]
CMD ["-w","2","-b","0.0.0.0:80","app:create_app()"]
