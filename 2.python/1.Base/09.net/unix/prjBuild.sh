#!/bin/bash
#########################################################################
# Unix domain socket tests
# Usage: bash prjBuild.sh [test_name]
#   all    - run all tests (default)
#   stream - stream socket test (byte-stream, like TCP)
#   dgram  - datagram socket test (message-based, like UDP)
#########################################################################

set -e
DIR="$(cd "$(dirname "$0")" && pwd)"

function cleanup_after()
{
    rm -f /tmp/unix_stream_demo.sock /tmp/unix_dgram_server.sock /tmp/unix_dgram_client.sock
}

function test_stream()
{
    echo "=== [stream] Unix stream echo test ==="
    python3 "$DIR/server_stream.py" &
    srv=$!
    sleep 0.3

    printf "hello unix stream\nquit\n" | timeout 3 python3 "$DIR/client_stream.py" || true

    kill $srv 2>/dev/null || true
    wait $srv 2>/dev/null || true
    cleanup_after
    echo "=== [stream] PASS ==="
}

function test_dgram()
{
    echo "=== [dgram] Unix datagram echo test ==="
    python3 "$DIR/server_dgram.py" &
    srv=$!
    sleep 0.3

    printf "hello unix dgram\nquit\n" | timeout 3 python3 "$DIR/client_dgram.py" || true

    wait $srv 2>/dev/null || true
    cleanup_after
    echo "=== [dgram] PASS ==="
}

case "${1:-all}" in
    stream)  test_stream ;;
    dgram)   test_dgram ;;
    all)     test_stream; test_dgram ;;
    *)       echo "Usage: $0 {all|stream|dgram}" ;;
esac
