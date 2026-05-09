# -------------------
# Base: deps only (cached layer — rebuilds only when pyproject.toml or poetry.lock changes)
# -------------------
FROM python:3.14-slim AS base

WORKDIR /app

RUN pip install --no-cache-dir poetry && \
    poetry config virtualenvs.create false

COPY pyproject.toml poetry.lock* ./
RUN poetry install --no-root --no-interaction

# -------------------
# Dev: install project + register CLI script
# -------------------
FROM base AS dev

COPY src/ ./src/
RUN poetry install --no-deps --no-interaction
CMD ["{{PROJECT_NAME}}"]

# -------------------
# Test: run pytest
# -------------------
FROM base AS test

COPY src/ ./src/
RUN poetry install --no-deps --no-interaction
CMD ["pytest", "src/tests/", "-v"]
