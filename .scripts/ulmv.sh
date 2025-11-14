#!/bin/bash
# revert_symlink.sh
# Reverts a directory move operation by moving the target back and deleting the symlink.
#
# Usage:
#   ./revert_symlink.sh <PATH_TO_SYMLINK>
#
# Example:
#   ./revert_symlink.sh ~/.config/appdata

# --- Configuration ---
set -e # Exit immediately if a command exits with a non-zero status.

# Define the symlink path from the first argument
SYMLINK_PATH=$1

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
if [ "$#" -ne 1 ]; then
    error_exit "Incorrect number of arguments.\n\nUsage: ./revert_symlink.sh <PATH_TO_SYMLINK>"
fi

# 2. Check if the provided path is a symbolic link
if ! is_symlink "$SYMLINK_PATH"; then
    error_exit "Path '$SYMLINK_PATH' is not a symbolic link (it must start with 'l' in 'ls -l'). Aborting."
fi

# --- Execution ---

echo -e "\033[33m--- Starting Symlink Reversion Operation ---\033[0m"

# 1. Determine the actual location of the data (the symlink's target)
# readlink -f resolves the final target and handles relative paths.
TARGET_PATH=$(readlink -f "$SYMLINK_PATH")

if [ -z "$TARGET_PATH" ] || ! [ -e "$TARGET_PATH" ]; then
    error_exit "Target path could not be resolved or does not exist. Target was: '$TARGET_PATH'."
fi

# 2. Move the target folder back to the symlink's original location (its parent directory)
#
# We need to move the contents of the target directory to the location where the
# symlink currently sits, effectively restoring the original file structure.
echo "1. Moving data from Target ('$TARGET_PATH') back to Origin ('$SYMLINK_PATH')..."

# The parent directory of the symlink is where the content must return.
# We first remove the symlink and then move the contents back.

# Remove the symlink first so we can move the data back into its place.
unlink "$SYMLINK_PATH"
echo -e "\033[32m[SUCCESS]\033[0m Symbolic link removed."

# Move the actual data back into the original location (now vacant)
mv "$TARGET_PATH" "$(dirname "$SYMLINK_PATH")"
MOVE_EXIT_CODE=$?

if [ "$MOVE_EXIT_CODE" -ne 0 ]; then
    error_exit "Data move failed with exit code $MOVE_EXIT_CODE. Please check filesystem."
fi

# The 'mv' command above will move the directory $TARGET_PATH inside the parent directory of $SYMLINK_PATH.
# Since the basename of $SYMLINK_PATH and $TARGET_PATH should be the same (the folder name),
# this effectively restores the original structure.

echo -e "\033[32m[SUCCESS]\033[0m Data successfully moved back to original path."
echo -e "\033[33m--- Operation Complete: Symlink Reverted ---\033[0m"
