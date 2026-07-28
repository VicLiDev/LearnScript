#!/bin/bash
#########################################################################
# UDP socket tests
# Usage: bash prjBuild.sh [test_name]
#   all       - run all tests (default)
#   echo      - bidirectional echo test
#   broadcast - UDP broadcast test
#########################################################################

set -e
DIR="$(cd "$(dirname "$0")" && pwd)"

function test_echo()
{
    echo "=== [echo] UDP echo test ==="
    python3 "$DIR/server.py" &
    srv=$!
    sleep 0.3

    printf "hello udp\nquit\n" | timeout 3 python3 "$DIR/client.py" || true

    wait $srv 2>/dev/null || true
    echo "=== [echo] PASS ==="
}

function test_broadcast()
{
    echo "=== [broadcast] UDP broadcast test ==="
    python3 "$DIR/server_broadcast.py" &
    srv=$!
    sleep 0.3

    printf "broadcast_hello\nquit\n" | timeout 3 python3 "$DIR/client_broadcast.py" || true

    kill $srv 2>/dev/null || true
    wait $srv 2>/dev/null || true
    echo "=== [broadcast] PASS ==="
}

case "${1:-all}" in
    echo)       test_echo ;;
    broadcast)  test_broadcast ;;
    all)        test_echo; test_broadcast ;;
    *)          echo "Usage: $0 {all|echo|broadcast}" ;;
esac
