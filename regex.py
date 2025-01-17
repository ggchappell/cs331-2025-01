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
                    # (r"..." gives a "raw" string literal, without
                    # backslash escaping)


def main():
    """Read stdin & print info on each line matched by above regex."""
    for line in (sys.stdin):
        line = line.rstrip("\r\n")  # Remove EOL chars

        match_obj = re.search(regexstr, line)
        if match_obj:
            print(line + ": MATCHED [" + match_obj[0] + "]")

    return 0

# When a regex is used repeatedly, save time by "compiling" it to a
# regex object:
#   regex_obj = re.compile(r"ab*c")
#   ...
#   match_obj = regex_obj.search(line)


# Main program
# If this module is executed as a program (instead of being imported):
# run function main.
if __name__ == "__main__":
    sys.exit(main())

