# test-app

A Python terminal application built on the [python-terminal-scaffold](https://github.com/sushant-joshi/standalone-python-starter-kit).

---

## What is Poetry?

Poetry is a Python dependency and packaging manager. It replaces the combination of `pip`, `virtualenv`, and `requirements.txt` with a single tool that handles everything declaratively.

**Why Poetry over pip + requirements.txt:**

| | pip + requirements.txt | Poetry |
|---|---|---|
| Dependency resolution | Manual | Automatic |
| Lock file | None (non-reproducible) | `poetry.lock` — exact versions pinned |
| Dev vs runtime deps | One flat file | Separate `[group.dev]` section |
| Add a package | Edit file, re-install | `poetry add <pkg>` — done |
| Virtual env management | Separate tool needed | Built-in |

The `poetry.lock` file is committed to version control so every environment — local, Docker, CI — installs the exact same versions.

---

## Getting Started

### Prerequisites

```bash
# Install Poetry
curl -sSL https://install.python-poetry.org | python3

# Add to PATH (add this to your shell profile)
export PATH="$HOME/.local/bin:$PATH"

# Verify
poetry --version
```

Docker Desktop must also be running.

### Install dependencies locally

```bash
poetry install
```

---

## Folder Structure

```
test-app/
├── Dockerfile
├── pyproject.toml
├── poetry.lock
├── .env.example
├── .gitignore
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
| `pyproject.toml` | Project metadata, runtime and dev dependencies, black/isort config |
| `poetry.lock` | Pinned dependency versions — committed for reproducible builds |
| `.env.example` | Documents available environment variables with defaults |
| `.gitignore` | Excludes `__pycache__`, `.env`, `.venv`, build artifacts |
| `src/main.py` | Entry point — terminal I/O loop, rich rendering, error display |
| `src/app.py` | Core logic — I/O-free, fully unit-testable |
| `src/config.py` | All config in one place, driven by environment variables |
| `src/logger.py` | Structured logger factory — writes to stderr, reads level from config |
| `src/tests/test_app.py` | Unit tests for `app.py` |

---

## Running the App

### As a local CLI command

After `poetry install`, Poetry registers the project as a command on your PATH:

```bash
poetry install

# REPL mode (no arguments)
test-app

# Single-shot mode (pass input directly)
test-app "hello world"

# Built-in help
test-app --help
```

### Via Docker (REPL mode)

```bash
docker build -t test-app:dev --target dev .
docker run -it --rm -v "$(pwd)/src:/app/src" test-app:dev
```

### Via Docker (single-shot mode)

```bash
docker run --rm test-app:dev "hello world"
```

### Re-run without rebuilding

`src/` is volume-mounted — edits to local files take effect on the next run.

```bash
docker run -it --rm -v "$(pwd)/src:/app/src" test-app:dev
```

### Run tests

```bash
# In Docker
docker build -t test-app:test --target test .
docker run --rm test-app:test

# Locally
poetry run pytest src/tests/ -v
```

### Format and lint

```bash
# Format code
poetry run black src/

# Sort imports
poetry run isort src/

# Both together
poetry run isort src/ && poetry run black src/

# Check only — no file writes
poetry run black --check src/
poetry run isort --check-only src/
```

### Add a dependency

```bash
# Runtime dependency
poetry add httpx

# Dev-only dependency
poetry add pytest-mock --group dev

# Rebuild Docker with updated deps
docker build -t test-app:dev --target dev .
```

### Environment variables

```bash
cp .env.example .env
# edit .env as needed

docker run -it --rm \
  --env-file .env \
  -v "$(pwd)/src:/app/src" \
  test-app:dev
```
