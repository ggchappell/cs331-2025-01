#!/usr/bin/env python3
# regex.py
# Glenn G. Chappell
# 2025-01-16
#
# For CS 331 Spring 2025
"""Demo of regular expressions in Python."""

import re   # For .search
import sys  # for .stdin, .exit


regexstr = r"ab*c"  # Our regular expression


def main():
    """Read stdin & print info on each line matched by above regex."""
    for line in (sys.stdin):
        line = line.rstrip("\r\n")  # Remove EOL chars

        mo = re.search(regexstr, line)
        if mo:
            print(line + ": MATCHED [" + mo[0] + "]")

    return 0


# Main program
# If this module is executed as a program (instead of being imported):
# run function main.
if __name__ == "__main__":
    sys.exit(main())

