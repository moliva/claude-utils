#!/usr/bin/env bash
# Claude Code statusline: shows cwd, git branch, and Linear ticket

input=$(cat)
cwd=$(echo "$input" | jq -r '.cwd')
session_name=$(echo "$input" | jq -r '.session_name // ""')

# Get the shortened directory path (replace $HOME with ~)
short_dir="${cwd/#$HOME/~}"

# Get the git branch for the cwd, skipping optional locks
branch=$(git -C "$cwd" --no-optional-locks symbolic-ref --short HEAD 2>/dev/null)

# Extract Linear ticket: prefer session_name, fall back to branch name
if [ -n "$session_name" ]; then
  ticket=$(echo "$session_name" | grep -oiE '[A-Z]+-[0-9]+' | head -1 | tr '[:lower:]' '[:upper:]')
  # If session_name doesn't look like a ticket, use it as-is
  [ -z "$ticket" ] && ticket="$session_name"
else
  ticket=$(echo "$branch" | grep -oiE '[A-Z]+-[0-9]+' | head -1 | tr '[:lower:]' '[:upper:]')
fi

DIM_GREEN='\033[2;32m'
DIM_CYAN='\033[2;36m'
RESET='\033[0m'

status="${DIM_GREEN}   ${short_dir}"
[ -n "$branch" ] && status+="   ${branch}"
[ -n "$ticket" ] && status+="${DIM_CYAN}    ${ticket}"
status+="${RESET}"

printf '%b' "$status"
