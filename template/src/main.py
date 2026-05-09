import click
from rich.console import Console
from rich.panel import Panel
from rich.prompt import Prompt

from src.app import App
from src.config import config
from src.logger import get_logger

log = get_logger(__name__)
console = Console()


@click.command()
@click.argument("input", required=False, default=None)
def cli(input: str | None) -> None:
    app = App()
    if input is not None:
        _run_once(app, input)
    else:
        _repl(app)


def _run_once(app: App, input: str) -> None:
    try:
        result = app.process(input)
        console.print(f"[cyan]{result}[/cyan]")
    except ValueError as e:
        console.print(f"[red]Error:[/red] {e}")
        raise SystemExit(1)


def _repl(app: App) -> None:
    console.print(Panel(f"[bold blue]{config.app_name} is ready to use[/bold blue]", subtitle="quit to exit"))
    log.info("Session started (debug=%s)", config.debug)

    while True:
        try:
            user_input = Prompt.ask("\n[bold green]>[/bold green]").strip()
        except (KeyboardInterrupt, EOFError):
            break

        if not user_input:
            continue
        if user_input.lower() in ("quit", "exit", "q"):
            break

        try:
            result = app.process(user_input)
            console.print(f"[cyan]{result}[/cyan]")
        except ValueError as e:
            console.print(f"[red]Error:[/red] {e}")
        except Exception as e:
            log.exception("Unexpected error")
            console.print(f"[red]Unexpected error:[/red] {e}")

    console.print("\n[dim]Done.[/dim]")
    log.info("Session ended")


if __name__ == "__main__":
    cli()
