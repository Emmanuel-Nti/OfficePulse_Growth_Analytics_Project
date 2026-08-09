from __future__ import annotations

import os
import subprocess
import sys
from datetime import datetime
from pathlib import Path

# ---------------------------------------------------------------------------
# Project paths
# ---------------------------------------------------------------------------

PROJECT_ROOT = Path(__file__).resolve().parents[1]

LOAD_DATA_SCRIPT = PROJECT_ROOT / "scripts" / "load_data.py"

DBT_PROJECT_DIR = (
    PROJECT_ROOT
    / "dbt_project"
    / "officepulse_growth"
)

SOURCE_NOTEBOOK = (
    PROJECT_ROOT
    / "notebooks"
    / "officepulse_growth_analysis.ipynb"
)

JUPYTER_CONFIG_DIR = PROJECT_ROOT / ".jupyter_pipeline_config"

# ---------------------------------------------------------------------------
# Helper functions
# ---------------------------------------------------------------------------

def run_step(
    command: list[str],
    step_name: str,
    cwd: Path | None = None,
    env: dict[str, str] | None = None,
) -> None:
    """Run one pipeline step and stop immediately if it fails."""

    print("\n" + "=" * 80)
    print(step_name)
    print("=" * 80)

    try:
        subprocess.run(
            command,
            cwd=cwd,
            env=env,
            check=True,
        )
    except FileNotFoundError as error:
        print(f"\nPipeline failed during: {step_name}")
        print(f"Command not found: {command[0]}")
        print(error)
        sys.exit(1)
    except subprocess.CalledProcessError as error:
        print(f"\nPipeline failed during: {step_name}")
        print(f"Exit code: {error.returncode}")
        sys.exit(error.returncode)


def validate_paths() -> None:
    """Confirm that all required project files and folders exist."""

    required_paths = [
        LOAD_DATA_SCRIPT,
        DBT_PROJECT_DIR,
        SOURCE_NOTEBOOK,
    ]

    missing_paths = [
        path
        for path in required_paths
        if not path.exists()
    ]

    if missing_paths:
        print("The following required paths were not found:")

        for path in missing_paths:
            print(f"- {path}")

        sys.exit(1)


# ---------------------------------------------------------------------------
# Pipeline
# ---------------------------------------------------------------------------

def main() -> None:
    pipeline_start = datetime.now()

    print("=" * 80)
    print("OfficePulse Growth Analytics Pipeline")
    print(f"Started: {pipeline_start:%Y-%m-%d %H:%M:%S}")
    print("=" * 80)

    validate_paths()

    # Use an isolated Jupyter configuration directory so that global Jupyter
    # extensions and local user settings do not affect notebook execution.
    JUPYTER_CONFIG_DIR.mkdir(exist_ok=True)

    pipeline_env = os.environ.copy()
    pipeline_env["JUPYTER_CONFIG_DIR"] = str(JUPYTER_CONFIG_DIR)

    # 1. Load raw CSV files into DuckDB
    run_step(
        command=[
            sys.executable,
            str(LOAD_DATA_SCRIPT),
        ],
        step_name="1. Loading raw data",
        cwd=PROJECT_ROOT,
    )

    # 2. Build dbt models and execute tests in dependency order
    run_step(
        command=[
            sys.executable,
            "-m",
            "dbt.cli.main",
            "build",
        ],
        step_name="2. Building dbt project",
        cwd=DBT_PROJECT_DIR,
    )

    # 3. Execute the analysis notebook and update the source notebook in place
    run_step(
        command=[
            sys.executable,
            "-m",
            "nbconvert",
            "--to",
            "notebook",
            "--execute",
            "--inplace",
            "--ExecutePreprocessor.timeout=600",
            str(SOURCE_NOTEBOOK),
        ],
        step_name="3. Executing analysis notebook",
        cwd=PROJECT_ROOT,
        env=pipeline_env,
    )

    pipeline_end = datetime.now()
    duration = pipeline_end - pipeline_start

    print("\n" + "=" * 80)
    print("Pipeline completed successfully.")
    print(f"Started:  {pipeline_start:%Y-%m-%d %H:%M:%S}")
    print(f"Finished: {pipeline_end:%Y-%m-%d %H:%M:%S}")
    print(f"Duration: {duration}")
    print(f"Notebook: {SOURCE_NOTEBOOK}")
    print("=" * 80)


if __name__ == "__main__":
    main()