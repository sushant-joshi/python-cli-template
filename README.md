# Python Terminal App Scaffold

A project generator for production-ready Python terminal applications. One command creates a fully wired project with Poetry, Docker, structured logging, config management, and a test suite.

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

The `poetry.lock` file is committed to version control so every environment — local, Docker, CI — installs the exact same versions. No "works on my machine" surprises.

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

### Generate a project

```bash
# Clone the scaffold
git clone <scaffold-repo-url>
cd scaffold

# Generate your project
./start.sh my-app
```

`start.sh` will:
1. Copy `template/` into `./my-app/`
2. Substitute the project name into `pyproject.toml`
3. Run `poetry lock` to generate a pinned lock file
4. Build Docker images (`my-app:dev` and `my-app:test`)
5. Run the test suite
6. Launch the app

---

## Generated Folder Structure

```
my-app/
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

### Via start.sh (first run)

```bash
./start.sh my-app
```

Builds everything from scratch and launches the app. Use this once at the start.

### Re-run without rebuilding

`src/` is volume-mounted into the container, so edits to local files take effect on the next run without a Docker rebuild.

```bash
docker run -it --rm -v "$(pwd)/src:/app/src" my-app:dev
```

### Run tests

```bash
docker run --rm my-app:test
```

### Run tests locally (faster feedback loop)

```bash
cd my-app
poetry install
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
cd my-app

# Runtime dependency
poetry add httpx

# Dev-only dependency
poetry add pytest-mock --group dev

# Rebuild Docker with updated deps
docker build -t my-app:dev --target dev .
```

### Environment variables

```bash
# Copy the example and set values
cp .env.example .env
```

```
# .env
APP_NAME=my-app
LOG_LEVEL=DEBUG
DEBUG=true
```

Pass `.env` into Docker at runtime:

```bash
docker run -it --rm \
  --env-file .env \
  -v "$(pwd)/src:/app/src" \
  my-app:dev
```
