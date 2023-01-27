#!/bin/bash

# Get the current UTC time in the desired format
utc_time=$(date -u +"%d/%b/%Y %H:%M")

# Copy the time to the clipboard
echo $utc_time | xclip -selection clipboard
