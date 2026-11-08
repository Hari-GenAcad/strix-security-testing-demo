"""Optional historical launcher; Python must have strix-agent installed."""
import strix_terminal_fix  # noqa: F401
from importlib.metadata import distribution

if __name__ == "__main__":
    entry = next(ep for ep in distribution("strix-agent").entry_points
                 if ep.group == "console_scripts" and ep.name == "strix")
    raise SystemExit(entry.load()())
