# Claude Code session lookup helpers.
# Table: ~/.claude/sessions.tsv  (session_id TAB friendly_name TAB cwd TAB summary)
# Populated automatically by the SessionEnd hook in ~/.claude/settings.json.

_CLAUDE_SESSIONS="$HOME/.claude/sessions.tsv"

# cld [pattern]  — list sessions, optionally filtered
cld() {
    local pattern="${1:-}"
    if [ ! -f "$_CLAUDE_SESSIONS" ]; then
        echo "No sessions recorded yet (table not found: $_CLAUDE_SESSIONS)"
        return 0
    fi
    local rows
    if [ -n "$pattern" ]; then
        rows=$(grep "$pattern" "$_CLAUDE_SESSIONS")
    else
        rows=$(cat "$_CLAUDE_SESSIONS")
    fi
    if [ -z "$rows" ]; then
        echo "No sessions matching: $pattern"
        return 0
    fi
    # Number rows globally (line number in the full file) so cldr <#> works
    awk -F'\t' '{
        # find global line number for this row
        print NR "\t" $0
    }' "$_CLAUDE_SESSIONS" | grep -F "${pattern}" | \
    awk -F'\t' '{
        printf "#%-4s  %-36s  %-44s  %s\n", $1, $2, $3, $5
    }'
}

# cldr <#|session-id|pattern>  — resume a session
# Accepts: integer line # from cld output, full session UUID, or a text pattern
cldr() {
    local arg="${1:-}"
    if [ -z "$arg" ]; then
        echo "Usage: cldr <#|session-id|pattern>"
        cld
        return 1
    fi
    if [ ! -f "$_CLAUDE_SESSIONS" ]; then
        echo "No sessions recorded yet."
        return 1
    fi

    local match name

    if [[ "$arg" =~ ^[0-9]+$ ]]; then
        # Integer → global line number
        local line
        line=$(sed -n "${arg}p" "$_CLAUDE_SESSIONS")
        if [ -z "$line" ]; then
            echo "No session #$arg"
            return 1
        fi
        match=$(echo "$line" | cut -f1)
        name=$(echo "$line" | cut -f2)
    else
        # Full UUID or text pattern — take the last (most recent) match
        local hit
        hit=$(grep "$arg" "$_CLAUDE_SESSIONS" | tail -1)
        match=$(echo "$hit" | cut -f1)
        name=$(echo "$hit" | cut -f2)
    fi

    if [ -z "$match" ]; then
        echo "No session found matching: $arg"
        cld
        return 1
    fi

    echo "Resuming: $name ($match)"
    claude --resume "$match"
}

alias cldresume=cldr
