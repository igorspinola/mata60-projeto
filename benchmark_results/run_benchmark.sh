#!/usr/bin/env bash
# Benchmark: executa cada query (intermediario e avancado) 10x via EXPLAIN ANALYZE.
# Coleta o "Execution Time" e grava em CSV.
set -euo pipefail

CONTAINER="mata60-projeto-db-1"
DB_USER="admin"
DB_NAME="admin"
RUNS=10

OUT_DIR="$(dirname "$0")"
CSV="${OUT_DIR}/raw_times.csv"
echo "categoria,query,execucao,tempo_ms" > "$CSV"

run_query_set() {
    local categoria="$1"
    local dir="$2"
    local prefix="$3"
    for q in $(ls "$dir"/q*.sql | sort -V); do
        local name
        name="$(basename "$q" .sql)"
        local label="${prefix}${name#q}"
        # Pad with zero (Q01, Q02, ...)
        local num="${name#q}"
        printf -v label "%s%02d" "$prefix" "$num"

        # Read SQL, strip trailing semicolon for safe wrapping
        local sql
        sql="$(sed -e 's/;[[:space:]]*$//' "$q")"

        for i in $(seq 1 $RUNS); do
            # DISCARD ALL to clear session caches, then EXPLAIN ANALYZE
            local payload
            payload="DISCARD ALL; EXPLAIN (ANALYZE, TIMING ON, BUFFERS OFF, FORMAT TEXT) ${sql};"
            local time_ms
            time_ms=$(docker exec -i "$CONTAINER" psql -U "$DB_USER" -d "$DB_NAME" -q -A -t -X <<EOF | grep -oE 'Execution Time: [0-9.]+ ms' | awk '{print $3}'
${payload}
EOF
)
            if [ -z "$time_ms" ]; then
                echo "WARN: tempo vazio em $label execucao $i" >&2
                time_ms="NaN"
            fi
            echo "${categoria},${label},${i},${time_ms}" >> "$CSV"
            echo "[$categoria] $label run=$i -> ${time_ms} ms"
        done
    done
}

run_query_set "intermediario" "/Users/deiv/Documents/mata60-projeto/sql_intermediario" "QI"
run_query_set "avancado" "/Users/deiv/Documents/mata60-projeto/sql_avancado" "QA"

echo "OK: resultados em $CSV"
