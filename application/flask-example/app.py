import os
import time

import pymysql
from flask import Flask, jsonify

app = Flask(__name__)


def _db_config() -> dict:
    return {
        "host": os.getenv("DB_HOST", "localhost"),
        "port": int(os.getenv("DB_PORT", "3306")),
        "user": os.getenv("DB_USER", "flaskuser"),
        "password": os.getenv("DB_PASSWORD", "flaskpass"),
        "database": os.getenv("DB_NAME", "flaskdb"),
    }


def _connect():
    cfg = _db_config()
    return pymysql.connect(
        host=cfg["host"],
        port=cfg["port"],
        user=cfg["user"],
        password=cfg["password"],
        database=cfg["database"],
        autocommit=True,
        connect_timeout=5,
        read_timeout=5,
        write_timeout=5,
    )


def init_db(max_attempts: int = 30, sleep_seconds: float = 1.0) -> None:
    last_err: Exception | None = None
    for _ in range(max_attempts):
        try:
            with _connect() as conn:
                with conn.cursor() as cur:
                    cur.execute(
                        """
                        CREATE TABLE IF NOT EXISTS request_counts (
                            endpoint VARCHAR(64) PRIMARY KEY,
                            count BIGINT NOT NULL DEFAULT 0,
                            updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
                                ON UPDATE CURRENT_TIMESTAMP
                        )
                        """
                    )
            return
        except Exception as e:  # noqa: BLE001 (educational example)
            last_err = e
            time.sleep(sleep_seconds)
    raise RuntimeError(f"DB not ready after {max_attempts} attempts: {last_err}")


def increment(endpoint: str) -> None:
    with _connect() as conn:
        with conn.cursor() as cur:
            cur.execute(
                """
                INSERT INTO request_counts (endpoint, count)
                VALUES (%s, 1)
                ON DUPLICATE KEY UPDATE count = count + 1
                """,
                (endpoint,),
            )


def get_count(endpoint: str) -> int:
    with _connect() as conn:
        with conn.cursor() as cur:
            cur.execute("SELECT count FROM request_counts WHERE endpoint = %s", (endpoint,))
            row = cur.fetchone()
            if not row:
                return 0
            # pymysql returns tuples by default cursor
            return int(row[0])


@app.get("/ping")
def ping():
    try:
        increment("ping")
    except Exception as e:  # noqa: BLE001 (educational example)
        return jsonify({"error": "db_unavailable", "detail": str(e)}), 503
    return "pong", 200


@app.get("/stats")
def stats():
    try:
        count = get_count("ping")
    except Exception as e:  # noqa: BLE001 (educational example)
        return jsonify({"error": "db_unavailable", "detail": str(e)}), 503
    return jsonify({"ping": count}), 200


if __name__ == "__main__":
    init_db()
    app.run(host="0.0.0.0", port=8080, debug=False)

