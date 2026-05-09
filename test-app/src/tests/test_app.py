import pytest
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
