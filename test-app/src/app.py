from src.logger import get_logger

log = get_logger(__name__)


class App:

    def __init__(self) -> None:
        log.info("App initialised")

    def process(self, user_input: str) -> str:
        # Core logic
        log.debug("Processing input: %s", user_input)

        if not user_input:
            raise ValueError("Input must not be empty")

        result = f"Processed: {user_input}"

        log.debug("Result: %s", result)
        return result
