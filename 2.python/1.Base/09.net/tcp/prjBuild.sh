#!/bin/bash
#########################################################################
# TCP socket tests
# Usage: bash prjBuild.sh [test_name]
#   all       - run all tests (default)
#   basic     - single-client echo test
#   threading - threading multi-client test
#   select    - select-based multi-client test
#########################################################################

set -e
DIR="$(cd "$(dirname "$0")" && pwd)"

function test_basic()
{
    echo "=== [basic] Single-client echo test ==="
    python3 "$DIR/server.py" &
    srv=$!
    sleep 0.3

    printf "hello tcp\nquit\n" | timeout 3 python3 "$DIR/client.py" || true

    kill $srv 2>/dev/null || true
    wait $srv 2>/dev/null || true
    echo "=== [basic] PASS ==="
}

function test_threading()
{
    echo "=== [threading] Multi-client test ==="
    python3 "$DIR/server_threading.py" &
    srv=$!
    sleep 0.3

    printf "msg1\n" | timeout 2 python3 "$DIR/client.py" &
    p1=$!
    printf "msg2\n" | timeout 2 python3 "$DIR/client.py" &
    p2=$!
    wait $p1 $p2

    kill $srv 2>/dev/null || true
    wait $srv 2>/dev/null || true
    echo "=== [threading] PASS ==="
}

function test_select()
{
    echo "=== [select] Multi-client test ==="
    python3 "$DIR/server_select.py" &
    srv=$!
    sleep 0.3

    printf "msg3\n" | timeout 2 python3 "$DIR/client.py" &
    p1=$!
    printf "msg4\n" | timeout 2 python3 "$DIR/client.py" &
    p2=$!
    wait $p1 $p2

    kill $srv 2>/dev/null || true
    wait $srv 2>/dev/null || true
    echo "=== [select] PASS ==="
}

case "${1:-all}" in
    basic)      test_basic ;;
    threading)  test_threading ;;
    select)     test_select ;;
    all)        test_basic; test_threading; test_select ;;
    *)          echo "Usage: $0 {all|basic|threading|select}" ;;
esac
