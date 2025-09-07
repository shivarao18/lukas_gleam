#!/bin/bash

# A wrapper script to format the output of /usr/bin/time and calculate the CPU/Real time ratio.
# Usage: ./gtime.sh <command-to-run>

# Ensure a command is provided
if [ "$#" -eq 0 ]; then
    echo "Usage: $0 <command>"
    exit 1
fi

# Create a temporary file to store the verbose time output
TMPFILE=$(mktemp)

# Run the command with verbose timing, redirecting stderr (where time outputs) to the temp file.
# The command's own output will appear on the console as it runs.
/usr/bin/time -v "$@" 2> "$TMPFILE"

# Extract the required values from the verbose output
user_time=$(grep 'User time (seconds):' "$TMPFILE" | awk '{print $4}')
sys_time=$(grep 'System time (seconds):' "$TMPFILE" | awk '{print $4}')
elapsed_str=$(grep 'Elapsed (wall clock) time' "$TMPFILE" | awk '{print $NF}')
cpu_percent=$(grep 'Percent of CPU this job got:' "$TMPFILE" | awk '{print $7}')

# Clean up the temp file
rm "$TMPFILE"

# Convert elapsed time (which can be in M:SS.ss or H:MM:SS.ss format) to total seconds
elapsed_seconds=$(echo "$elapsed_str" | awk -F: '{
    if (NF == 3) { # H:M:S
        print ($1 * 3600) + ($2 * 60) + $3
    } else if (NF == 2) { # M:S
        print ($1 * 60) + $2
    } else { # S
        print $1
    }
}')

# Use awk to print the final formatted output and calculate the ratio
awk -v u="$user_time" -v s="$sys_time" -v e="$elapsed_seconds" -v p="$cpu_percent" '
BEGIN {
    printf "\n--- Time Statistics ---\n"
    printf "User time: %.2fs\n", u
    printf "System time: %.2fs\n", s
    printf "Elapsed (wall clock) time: %.2fs\n", e
    printf "Percent of CPU this job got: %s\n", p

    if (e > 0) {
        ratio = (u + s) / e
        printf "Ratio of CPU Time to Real Time: %.2f\n", ratio
    } else {
        printf "Elapsed time is zero, cannot calculate ratio.\n"
    }
}
'
