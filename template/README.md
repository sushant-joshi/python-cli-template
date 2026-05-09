# {{PROJECT_NAME}}

Generated from [python-cli-template](https://github.com/sushant-joshi/python-cli-template).

---

## What is Poetry?

Poetry is a Python dependency and packaging manager. It replaces `pip` + `virtualenv` + `requirements.txt` with a single tool.

| | pip + requirements.txt | Poetry |
|---|---|---|
| Dependency resolution | Manual | Automatic |
| Lock file | None | `poetry.lock` — exact versions pinned |
| Dev vs runtime deps | One flat file | Separate `[group.dev]` section |
| Add a package | Edit file, re-install | `poetry add <pkg>` |
| Virtual env management | Separate tool needed | Built-in |

---

## Getting Started

```bash
# Install Poetry
curl -sSL https://install.python-poetry.org | python3
export PATH="$HOME/.local/bin:$PATH"

# Install dependencies
poetry install
```

---

## Project Structure

```
{{PROJECT_NAME}}/
├── Dockerfile
├── pyproject.toml
├── poetry.lock
├── .env.example
├── .gitignore
├── README.md
├── scripts/
│   ├── run.sh
│   ├── deploy.sh
│   └── remove.sh
└── src/
    ├── __init__.py
    ├── main.py
    ├── app.py
    ├── config.py
    ├── logger.py
    └── tests/
        ├── __init__.py
        └── test_app.py
```

### File Purpose

| File | Purpose |
|------|---------|
| `Dockerfile` | Multistage build: `base` (deps), `dev` (run app), `test` (run pytest) |
| `pyproject.toml` | Dependencies, scripts entry point, black/isort config |
| `poetry.lock` | Pinned dependency versions — committed for reproducible builds |
| `.env.example` | Documents available environment variables with defaults |
| `scripts/run.sh` | Run the app locally via Poetry |
| `scripts/deploy.sh` | Install as a system-wide command in `/usr/local/bin` |
| `scripts/remove.sh` | Remove the system-wide command |
| `src/main.py` | Entry point — CLI parsing, terminal I/O loop |
| `src/app.py` | Core logic — I/O-free, fully unit-testable |
| `src/config.py` | Config driven by environment variables |
| `src/logger.py` | Structured logger — writes to stderr |
| `src/tests/test_app.py` | Unit tests for `app.py` |

---

## Running the App

### Run locally

```bash
# REPL mode
./scripts/run.sh

# Single-shot mode
./scripts/run.sh "Hello"
```

### Deploy as a system-wide command

```bash
./scripts/deploy.sh
```

Bakes the project path into a wrapper script and places it in `/usr/local/bin/{{PROJECT_NAME}}`. After this, from any terminal:

```bash
{{PROJECT_NAME}} "Hello"
{{PROJECT_NAME}}             # REPL mode
{{PROJECT_NAME}} --help

# Uninstall
./scripts/remove.sh
```

### Run via Docker

```bash
# REPL mode
docker run -it --rm -v "$(pwd)/src:/app/src" {{PROJECT_NAME}}:dev

# Single-shot
docker run --rm {{PROJECT_NAME}}:dev "Hello"
```

### Run tests

```bash
# Docker
docker run --rm {{PROJECT_NAME}}:test

# Locally
poetry run pytest src/tests/ -v
```

### Format and lint

```bash
poetry run isort src/ && poetry run black src/

# Check only
poetry run black --check src/
poetry run isort --check-only src/
```

### Add a dependency

```bash
poetry add httpx
docker build -t {{PROJECT_NAME}}:dev --target dev .
```

### Environment variables

```bash
cp .env.example .env
# edit .env

docker run -it --rm --env-file .env \
  -v "$(pwd)/src:/app/src" {{PROJECT_NAME}}:dev
```
