from src.config import config
from src.logger import get_logger

log = get_logger(__name__)


class App:

    def __init__(self) -> None:
        log.info("App initialised (max_input_length=%d)", config.max_input_length)

    def process(self, user_input: str) -> str:
        # Core logic
        log.debug("Processing input: %s", user_input)

        if not user_input:
            raise ValueError("Input must not be empty")

        if len(user_input) > config.max_input_length:
            raise ValueError(f"Input exceeds max length of {config.max_input_length} characters")

        result = f"Processed: {user_input}"

        log.debug("Result: %s", result)
        return result
