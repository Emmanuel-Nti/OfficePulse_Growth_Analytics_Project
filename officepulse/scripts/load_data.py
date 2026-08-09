from pathlib import Path
import re

import duckdb

# =====================================

# 1. Define project paths

# =====================================

PROJECT_ROOT = Path(__file__).resolve().parents[1]
SOURCE_DIR = PROJECT_ROOT / "data" / "source"
DB_PATH = PROJECT_ROOT / "data" / "officepulse.duckdb"

# =====================================

# 2. Convert filenames to table names

# =====================================

def create_table_name(file_path: Path) -> str:
    """
    Convert a CSV filename into a valid DuckDB raw table name.

    Example:
    product_usage_events.csv -> raw_product_usage_events
    """

    clean_name = re.sub(
        r"[^a-zA-Z0-9_]+",
        "_",
        file_path.stem.lower(),
    ).strip("_")

    return f"raw_{clean_name}"


# =====================================

# 3. Load all CSV files into DuckDB

# =====================================

def load_source_data() -> None:
    if not SOURCE_DIR.exists():
        raise FileNotFoundError(
            f"Source directory not found: {SOURCE_DIR}"
        )

    csv_files = sorted(SOURCE_DIR.glob("*.csv"))

    if not csv_files:
        raise FileNotFoundError(
            f"No CSV files found in: {SOURCE_DIR}"
        )

    print(f"Source directory: {SOURCE_DIR}")
    print(f"DuckDB database: {DB_PATH}")
    print(f"\nFound {len(csv_files)} CSV file(s).")

    with duckdb.connect(str(DB_PATH)) as conn:

        # Remove existing raw tables so DuckDB matches
        # the CSV files currently available in data/source.
        existing_raw_tables = conn.execute(
            """
            select table_name
            from information_schema.tables
            where table_schema = 'main'
              and table_name like 'raw_%'
            """
        ).fetchall()

        for (table_name,) in existing_raw_tables:
            conn.execute(
                f'drop table if exists "{table_name}"'
            )

        # Load each currently available CSV file.
        for file_path in csv_files:
            table_name = create_table_name(file_path)

            conn.execute(
                f"""
                create table "{table_name}" as
                select *
                from read_csv_auto(
                    ?,
                    header = true
                )
                """,
                [str(file_path)],
            )

            row_count = conn.execute(
                f"""
                select count(*)
                from "{table_name}"
                """
            ).fetchone()[0]

            print(
                f"Loaded {file_path.name} "
                f"into {table_name}: {row_count:,} rows"
            )

        print("\nRaw tables available:")

        raw_tables = conn.execute(
            """
            select
                table_schema,
                table_name
            from information_schema.tables
            where table_name like 'raw_%'
            order by table_name
            """
        ).fetchall()

        for schema_name, table_name in raw_tables:
            print(f"- {schema_name}.{table_name}")

    print("\nSource data loading completed successfully.")


if __name__ == "__main__":
    load_source_data()