# Python CLI Template

A project generator for production-ready Python terminal applications. One command scaffolds a new project with Poetry, Docker, structured logging, config management, and a test suite.

---

## Getting Started

### Prerequisites

```bash
# Install Poetry
curl -sSL https://install.python-poetry.org | python3
export PATH="$HOME/.local/bin:$PATH"
poetry --version
```

Docker Desktop must also be running.

### Generate a project

```bash
git clone https://github.com/sushant-joshi/python-cli-template.git
cd python-cli-template
./setup.sh my-app
```

---

## Scaffold Structure

```
python-cli-template/
├── setup.sh          ← project generator (run this once)
├── README.md
└── template/         ← never edited directly
    ├── Dockerfile
    ├── pyproject.toml
    ├── .env.example
    ├── .gitignore
    ├── README.md
    ├── scripts/
    │   ├── run.sh       ← run locally via Poetry
    │   ├── deploy.sh    ← install as system-wide command
    │   └── remove.sh    ← uninstall system-wide command
    └── src/
        ├── main.py
        ├── app.py
        ├── config.py
        ├── logger.py
        └── tests/
            └── test_app.py
```

## What `setup.sh` does

1. Copies `template/` into `./<project-name>/`
2. Substitutes `{{PROJECT_NAME}}` across all files
3. Runs `poetry lock` to generate a pinned lock file
4. Builds Docker images (`<name>:dev` and `<name>:test`)
5. Runs the test suite
6. Launches the app (with `src/` volume-mounted for live editing)
