import pytest
from unittest.mock import patch
from src.app import App


@pytest.fixture
def app() -> App:
    return App()


def test_process_returns_result(app: App) -> None:
    result = app.process("hello")
    assert result is not None
    assert isinstance(result, str)


def test_process_raises_on_empty_input(app: App) -> None:
    with pytest.raises(ValueError):
        app.process("")


def test_process_respects_max_input_length(app: App) -> None:
    with patch("src.app.config") as mock_config:
        mock_config.max_input_length = 5
        with pytest.raises(ValueError, match="max length"):
            app.process("toolonginput")
