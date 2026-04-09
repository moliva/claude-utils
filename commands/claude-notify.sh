#!/usr/bin/env bash
# Claude Code notification with tmux context + auto-dismiss

ICON=$(realpath "$HOME/.local/share/claude/icon.png" 2>/dev/null || echo "$HOME/.local/share/claude/icon.png")
GROUP="claude-code-notify"

# Build message and execute command with tmux context if available
if [ -n "$TMUX" ]; then
  SESSION=$(tmux display-message -p '#S' 2>/dev/null)
  WINDOW=$(tmux display-message -p '#W' 2>/dev/null)
  MSG="Needs attention — ${SESSION}:${WINDOW}"
  EXECUTE="/usr/bin/osascript -e 'tell application \"WezTerm\" to activate'; /opt/homebrew/bin/tmux switch-client -t '${SESSION}:${WINDOW}'"
else
  MSG="Claude needs your attention"
  EXECUTE="/usr/bin/osascript -e 'tell application \"WezTerm\" to activate'"
fi

# Send notification
if [ -f "$ICON" ]; then
  terminal-notifier \
    -title "Claude Code" \
    -message "$MSG" \
    -sound Glass \
    -group "$GROUP" \
    -appIcon "${ICON}" \
    -contentImage "${ICON}" \
    -execute "$EXECUTE"
else
  terminal-notifier \
    -title "Claude Code" \
    -message "$MSG" \
    -sound Glass \
    -group "$GROUP" \
    -sender "com.github.wez.wezterm" \
    -execute "$EXECUTE"
fi

# Auto-dismiss after 10 seconds
(sleep 10 && terminal-notifier -remove "$GROUP" 2>/dev/null) &
