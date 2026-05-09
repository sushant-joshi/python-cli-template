# -------------------
# Base: Poetry + deps (cached layer)
# -------------------
FROM python:3.14-slim AS base

WORKDIR /app

RUN pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false

# poetry.lock* — works with or without a committed lock file
COPY pyproject.toml poetry.lock* ./
RUN poetry install --no-root --no-interaction

# -------------------
# Dev: run the app
# -------------------
FROM base AS dev

COPY src/ ./src/
CMD ["python", "-m", "src.main"]

# -------------------
# Test: run pytest
# -------------------
FROM base AS test

COPY src/ ./src/
CMD ["pytest", "src/tests/", "-v"]
