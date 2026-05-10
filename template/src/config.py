import os
from dataclasses import dataclass
from pathlib import Path

import yaml
from dotenv import load_dotenv

load_dotenv()

_CONFIG_FILE = Path(__file__).parent.parent / "config.yaml"


def _load_yaml() -> dict:
    if _CONFIG_FILE.exists():
        with open(_CONFIG_FILE) as f:
            return yaml.safe_load(f) or {}
    return {}


_yaml = _load_yaml()


def _get(key: str, default) -> str:
    """Env var > config.yaml > hardcoded default."""
    return os.getenv(key.upper(), str(_yaml.get(key, default)))


@dataclass
class Config:
    app_name: str       = _get("app_name", "{{PROJECT_NAME}}")
    log_level: str      = _get("log_level", "INFO")
    debug: bool         = _get("debug", "false").lower() == "true"
    max_input_length: int = int(_get("max_input_length", 500))


config = Config()
