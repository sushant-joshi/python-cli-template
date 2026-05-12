# Manual Setup — Bare Minimum Python CLI

Use this when you can't use the template. Gets you to a running project in under 5 minutes.

---

## Step 1 — Create the project

```bash
mkdir my-app && cd my-app
```

```bash
poetry init --no-interaction
```

---

## Step 2 — Install dependencies

```bash
poetry add rich click python-dotenv pyyaml openai
```

---

## Step 3 — Create the file structure

```bash
mkdir src
```

```bash
touch src/__init__.py src/main.py src/app.py src/config.py src/logger.py
```

```bash
touch config.yaml .env
```

---

## Step 4 — Ask ChatGPT for boilerplate (~1 min)

Copy these prompts exactly:

**Prompt 1 — config.py:**
```
Give me a Python config.py that loads all keys from a config.yaml file using
pyyaml, with env var overrides using the uppercased key name and type coercion.
```

**Prompt 2 — logger.py:**
```
Give me a Python logger.py with a get_logger(name) factory that reads log level
from a config object and writes structured output to stderr.
```

Paste each response directly into `src/config.py` and `src/logger.py`.

---

## Step 5 — Write config.yaml

```bash
cat > config.yaml << 'EOF'
app_name: "my-app"
log_level: "INFO"
debug: false
min_score: 0.7
model: "gpt-4o-mini"
EOF
```

---

## Step 6 — Write src/main.py

```bash
cat > src/main.py << 'EOF'
import click
from src.app import App


@click.command()
@click.argument("text", required=False, default=None)
def cli(text: str | None) -> None:
    app = App()
    if text:
        print(app.process(text))
    else:
        while True:
            try:
                user_input = input("> ").strip()
                if user_input in ("quit", "q"):
                    break
                if user_input:
                    print(app.process(user_input))
            except (KeyboardInterrupt, EOFError):
                break


if __name__ == "__main__":
    cli()
EOF
```

---

## Step 7 — Write src/app.py

```bash
cat > src/app.py << 'EOF'
from src.config import config
from src.logger import get_logger

log = get_logger(__name__)


class App:

    def __init__(self) -> None:
        log.info("App initialised")

    def process(self, user_input: str) -> str:
        # Core logic
        if not user_input:
            raise ValueError("Input must not be empty")
        return f"Processed: {user_input}"
EOF
```

---

## Step 8 — Run

```bash
poetry run python src/main.py
```

```bash
poetry run python src/main.py "Hello"
```

---

## What You Now Have

| File | Purpose |
|------|---------|
| `config.yaml` | All config — add keys here, no code changes needed |
| `src/config.py` | Loads YAML, env vars override at runtime |
| `src/logger.py` | Structured logging to stderr |
| `src/app.py` | Core logic — edit `process()` with the interview solution |
| `src/main.py` | CLI entry — REPL mode or single-shot via argument |
