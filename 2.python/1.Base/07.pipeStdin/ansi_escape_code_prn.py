#!/usr/bin/python

# ANSI escape code: https://en.wikipedia.org/wiki/ANSI_escape_code

import time
import os

if __name__ == '__main__':
    os.system('')  # start VT-100 in windows console
    os.system('clear')

    print('start:')

    for i in range(5):
        time.sleep(0.2)
        print('line {}'.format(i))

    print('\033[5A', end='')  # cursor up 5 lines
    print('\033[1B', end='')  # cursor down 1 lines
    # print('\033[H', end='')  # cursor Home
    print('\r', end='')  # cursor back to start
    print('\033[2C', end='')  # cursor forward 2 lines
    print('\033[1D', end='')  # cursor back 1 lines
    # Moves the cursor to row n, column m. The values are 1-based, and default to 1 (top left corner) if omitted.
    print('\033[3;2H', end='')
    # print('\033[0J', end='')  # erase from cursor to end

    for i in range(5):
        time.sleep(0.2)
        print('new  {}'.format(i + 1))

    print('end')
