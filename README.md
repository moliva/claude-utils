# claude-utils

Utilities for working with [Claude Code](https://docs.anthropic.com/en/docs/claude-code) in tmux.

## What's included

### Hooks

**`commands/claude-notify.sh`** -- macOS notification hook (via `terminal-notifier`) that fires when Claude needs attention. Shows tmux session context and focuses WezTerm on click. Auto-dismisses after 10s.

**`commands/statusline-command.sh`** -- Status line showing the current working directory, git branch, and Linear ticket (extracted from branch name or session name).

### Tmux scripts

**`bin/tmux-fuzzy-find-claude`** -- Fuzzy finder (fzf) for jumping between Claude Code panes across all tmux sessions. Shows session, directory, branch, and ticket for each running instance.

**`bin/tmux-fuzzy-find-claude-help`** -- Help screen showing keybindings and CLI flags in a centered box. Invoked automatically with `?` from the picker.

Idle panes (waiting for user input) are marked with a yellow `i` prefix.

Flags:
- `--next` / `--prev` -- cycle through all Claude panes without opening the picker
- `--next-idle` / `--prev-idle` -- cycle through only idle Claude panes

Keybindings inside the picker:
- `enter` -- jump to pane
- `ctrl-s` -- send input to pane
- `ctrl-x` -- kill Claude process
- `ctrl-r` -- refresh list
- `ctrl-p` -- toggle preview
- `?` -- help

## Configuration

| Variable | Description | Default |
|---|---|---|
| `CLAUDE_UTILS_SHORT_PATH` | Base path shortened to `~~` in the fuzzy finder | `~/repos` |

## Setup

### Hooks

Copy `commands/` to `~/.claude/commands/` and merge the relevant sections from `settings.example.json` into your `~/.claude/settings.json`.

### Tmux scripts

Add `bin/` to your `$PATH` or symlink the scripts:

```bash
ln -s "$(pwd)/bin/tmux-fuzzy-find-claude" ~/bin/
ln -s "$(pwd)/bin/tmux-fuzzy-find-claude-help" ~/bin/
```

Bind it in your `tmux.conf`:

```
bind C-f run-shell "tmux-fuzzy-find-claude"
bind C-n run-shell "tmux-fuzzy-find-claude --next"
bind C-p run-shell "tmux-fuzzy-find-claude --prev"
bind C-i run-shell "tmux-fuzzy-find-claude --next-idle"
bind C-o run-shell "tmux-fuzzy-find-claude --prev-idle"
```

### Dependencies

- [fzf](https://github.com/junegunn/fzf)
- [terminal-notifier](https://github.com/julienXX/terminal-notifier) (for notifications)
- [jq](https://github.com/jqlang/jq) (for statusline)
- tmux
