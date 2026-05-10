import os
from pathlib import Path
from types import SimpleNamespace

import yaml
from dotenv import load_dotenv

load_dotenv()

_CONFIG_FILE = Path(__file__).parent.parent / "config.yaml"


def _load_yaml() -> dict:
    if _CONFIG_FILE.exists():
        with open(_CONFIG_FILE) as f:
            return yaml.safe_load(f) or {}
    return {}


def _coerce(value: str, reference) -> object:
    """Cast env var string to match the type of the YAML value."""
    if isinstance(reference, bool):
        return value.lower() == "true"
    if isinstance(reference, int):
        return int(value)
    if isinstance(reference, float):
        return float(value)
    return value


def _build(yaml_data: dict) -> SimpleNamespace:
    """Env var > config.yaml for every key. No manual wiring required."""
    resolved = {}
    for key, default in yaml_data.items():
        env_val = os.getenv(key.upper())
        resolved[key] = _coerce(env_val, default) if env_val is not None else default
    return SimpleNamespace(**resolved)


config = _build(_load_yaml())
