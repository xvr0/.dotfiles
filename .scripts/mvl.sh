#!/bin/bash
# mvl.sh
# Automates moving a directory and creating a symbolic link back to the new location.
#
# Usage:
#   ./move_and_link.sh <ORIGINAL_PATH> <NEW_DESTINATION>
#
# Example:
#   ./move_and_link.sh ~/.config/appdata /mnt/data/appdata_storage/

# --- Configuration ---
# Set the trap to exit on error (e.g., if mv fails)
set -e

# Define variables based on script arguments
ORIGIN=$1
DESTINATION=$2

# --- Function Definitions ---

# Function to display error messages and exit
error_exit() {
    echo -e "\n\033[31m[ERROR]\033[0m $1" >&2
    exit 1
}

# Function to check if the target is a symlink
is_symlink() {
    [ -L "$1" ]
}

# --- Argument Validation ---

# 1. Check for required arguments
if [ "$#" -ne 2 ]; then
    error_exit "Incorrect number of arguments.\n\nUsage: ./move_and_link.sh <ORIGIN_PATH> <NEW_DESTINATION>"
fi

# 2. Check if the original path exists and is not already a symlink
if ! [ -e "$ORIGIN" ]; then
    error_exit "Origin path '$ORIGIN' does not exist."
fi

if is_symlink "$ORIGIN"; then
    error_exit "Origin path '$ORIGIN' is already a symbolic link. Aborting to prevent loss of data."
fi

# --- Execution ---

echo -e "\033[33m--- Starting Move and Link Operation ---\033[0m"

# 1. Move the original folder to the destination
echo "1. Moving '$ORIGIN' to '$DESTINATION'..."

# Use rsync for safety/verification before removal, but standard mv is faster and simpler here.
# If the destination directory doesn't exist, 'mv' will create it and move the origin inside,
# so we ensure the destination is the actual new name of the folder, not a directory to move into.
mv "$ORIGIN" "$DESTINATION"
MOVE_EXIT_CODE=$?

if [ "$MOVE_EXIT_CODE" -ne 0 ]; then
    error_exit "Move failed with exit code $MOVE_EXIT_CODE. Aborting."
fi

echo -e "\033[32m[SUCCESS]\033[0m Folder moved successfully."

# 2. Create the symbolic link at the original location pointing to the new destination
echo "2. Creating symbolic link at '$ORIGIN' pointing to '$DESTINATION'..."

# Note: The 'ln -s' command expects the first argument to be the target (where to go)
# and the second argument to be the link name (where to place the link).
ln -s "$DESTINATION" "$ORIGIN"
LINK_EXIT_CODE=$?

if [ "$LINK_EXIT_CODE" -ne 0 ]; then
    error_exit "Symbolic link creation failed with exit code $LINK_EXIT_CODE. Please check if '$ORIGIN' still exists."
fi

echo -e "\033[32m[SUCCESS]\033[0m Symbolic link created: '$ORIGIN -> $DESTINATION'"
echo -e "\033[33m--- Operation Complete ---\033[0m"
