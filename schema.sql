-- SQLite database schema. The notebook applies this script on each run.
CREATE TABLE IF NOT EXISTS sales (
    transaction_id     TEXT PRIMARY KEY NOT NULL,
    customer_id        TEXT NOT NULL,
    product_id         TEXT NOT NULL,
    product_name       TEXT NOT NULL,
    product_category   TEXT NOT NULL,
    unit_price_cents   INTEGER NOT NULL CHECK (unit_price_cents >= 0),
    quantity           INTEGER NOT NULL CHECK (quantity > 0),
    discount_bps       INTEGER NOT NULL CHECK (discount_bps BETWEEN 0 AND 10000),
    transaction_at     TEXT NOT NULL,
    region             TEXT NOT NULL,
    gross_sales_cents  INTEGER NOT NULL CHECK (gross_sales_cents = unit_price_cents * quantity),
    net_sales_cents    INTEGER NOT NULL CHECK (net_sales_cents BETWEEN 0 AND gross_sales_cents),
    row_hash           TEXT NOT NULL CHECK (length(row_hash) = 64),
    created_at         TEXT NOT NULL,
    updated_at         TEXT NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_sales_transaction_at ON sales (transaction_at);
CREATE INDEX IF NOT EXISTS idx_sales_region ON sales (region);

CREATE TABLE IF NOT EXISTS etl_runs (
    run_id         INTEGER PRIMARY KEY,
    source_file    TEXT NOT NULL,
    started_at     TEXT NOT NULL,
    finished_at    TEXT NOT NULL,
    rows_read      INTEGER NOT NULL,
    inserted       INTEGER NOT NULL,
    updated        INTEGER NOT NULL,
    unchanged      INTEGER NOT NULL,
    duplicates     INTEGER NOT NULL,
    rejected       INTEGER NOT NULL,
    CHECK (rows_read = inserted + updated + unchanged + duplicates + rejected)
);
