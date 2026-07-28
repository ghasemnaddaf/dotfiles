# Claude Code session lookup helpers.
# Table: ~/.claude/sessions.tsv
#   Columns: session_id TAB friendly_name TAB cwd TAB summary TAB label
# Populated automatically by the SessionEnd hook via ~/.claude/scripts/record-session.sh.

_CLAUDE_SESSIONS="$HOME/.claude/sessions.tsv"

# _cld_transcript_exists <session_id>
# Returns 0 if the transcript file for this session still exists on disk.
_cld_transcript_exists() {
    local sid="$1"
    local projects_dir="$HOME/.claude/projects"
    [ -d "$projects_dir" ] || return 1
    find "$projects_dir" -name "${sid}.jsonl" -o -name "${sid}.json" 2>/dev/null | grep -q .
}

# cld [pattern]  — list sessions, optionally filtered
# Columns shown: #NR  label  friendly_name  summary
# Dead sessions (transcript gone) are marked with ✗.
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

    awk -F'\t' '{ print NR "\t" $0 }' "$_CLAUDE_SESSIONS" | grep -F "${pattern}" | \
    awk -F'\t' '{
        nr      = $1
        sid     = $2
        fname   = $3
        # TSV: session_id, friendly_name, cwd, summary, label
        # After NR prepend: $4=cwd, $5=summary, $6=label
        summary = (NF >= 5) ? $5 : ""
        label   = (NF >= 6) ? $6 : ""
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", summary)
        gsub(/^[[:space:]]+|[[:space:]]+$/, "", label)
        if (summary == "") summary = "(no summary)"
        if (length(summary) > 255) summary = substr(summary, 1, 252) "..."
        ldisp = (label != "") ? label : "-"
        printf "#%-4s  %-24s  %-36s  %-42s  %s\n", nr, ldisp, sid, fname, summary
    }'
}

# cldtag <#|session-id|pattern> <new-label>
# Rename a session's label in the TSV (5th column).
cldtag() {
    local arg="${1:-}" newlabel="${2:-}"
    if [ -z "$arg" ] || [ -z "$newlabel" ]; then
        echo "Usage: cldtag <#|session-id|pattern> <new-label>"
        return 1
    fi
    if [ ! -f "$_CLAUDE_SESSIONS" ]; then
        echo "No sessions recorded yet."
        return 1
    fi

    local sid
    if [[ "$arg" =~ ^[0-9]+$ ]]; then
        sid=$(sed -n "${arg}p" "$_CLAUDE_SESSIONS" | cut -f1)
    else
        sid=$(grep "$arg" "$_CLAUDE_SESSIONS" | tail -1 | cut -f1)
    fi
    if [ -z "$sid" ]; then
        echo "No session found matching: $arg"
        return 1
    fi

    # Replace or append the label (5th field) for this session_id
    awk -F'\t' -v sid="$sid" -v label="$newlabel" 'BEGIN{OFS="\t"} {
        if ($1 == sid) { $5 = label }
        print
    }' "$_CLAUDE_SESSIONS" > "${_CLAUDE_SESSIONS}.tmp" && mv "${_CLAUDE_SESSIONS}.tmp" "$_CLAUDE_SESSIONS"

    echo "Session $sid renamed to: $newlabel"
}

# cldd <#|session-id> [#|session-id ...]  — delete one or more sessions
# Removes rows from sessions.tsv and the transcript .jsonl from ~/.claude/projects/.
cldd() {
    if [ $# -eq 0 ]; then
        echo "Usage: cldd <#|session-id> [#|session-id ...]"
        return 1
    fi
    if [ ! -f "$_CLAUDE_SESSIONS" ]; then
        echo "No sessions recorded yet."
        return 1
    fi

    local sids_to_delete=()
    local labels=()
    for arg in "$@"; do
        local sid label line
        if [[ "$arg" =~ ^[0-9]+$ ]]; then
            line=$(sed -n "${arg}p" "$_CLAUDE_SESSIONS")
        else
            line=$(grep "^${arg}" "$_CLAUDE_SESSIONS" | head -1)
        fi
        if [ -z "$line" ]; then
            echo "No session found: $arg"
            return 1
        fi
        sid=$(echo "$line" | cut -f1)
        label=$(echo "$line" | cut -f5)
        [ -z "$label" ] && label=$(echo "$line" | cut -f2)
        sids_to_delete+=("$sid")
        labels+=("$label")
    done

    # Confirm
    echo "Will delete ${#sids_to_delete[@]} session(s):"
    for i in "${!sids_to_delete[@]}"; do
        echo "  ${sids_to_delete[$i]}  ${labels[$i]}"
    done
    printf "Confirm? [y/N] "
    read -r ans
    [[ "$ans" =~ ^[Yy] ]] || return 1

    local projects_dir="$HOME/.claude/projects"
    for sid in "${sids_to_delete[@]}"; do
        # Remove transcript files
        find "$projects_dir" -name "${sid}.jsonl" -o -name "${sid}.json" 2>/dev/null | xargs rm -f 2>/dev/null || true
        # Remove TSV row
        grep -v "^${sid}	" "$_CLAUDE_SESSIONS" > "${_CLAUDE_SESSIONS}.tmp" && mv "${_CLAUDE_SESSIONS}.tmp" "$_CLAUDE_SESSIONS"
    done

    echo "Deleted ${#sids_to_delete[@]} session(s)."
}

# cldr <#|session-id|pattern>  — resume a session
# Accepts: integer line # from cld output, full session UUID, or a text pattern.
# Warns if the transcript appears to be gone.
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

    local match name origdir label

    if [[ "$arg" =~ ^[0-9]+$ ]]; then
        local line
        line=$(sed -n "${arg}p" "$_CLAUDE_SESSIONS")
        if [ -z "$line" ]; then
            echo "No session #$arg"
            return 1
        fi
        match=$(echo "$line" | cut -f1)
        name=$(echo "$line" | cut -f2)
        origdir=$(echo "$line" | cut -f3)
        label=$(echo "$line" | cut -f5)
    else
        local hit
        hit=$(grep "$arg" "$_CLAUDE_SESSIONS" | tail -1)
        match=$(echo "$hit" | cut -f1)
        name=$(echo "$hit" | cut -f2)
        origdir=$(echo "$hit" | cut -f3)
        label=$(echo "$hit" | cut -f5)
    fi

    local display="${label:-$name}"

    if [ -z "$match" ]; then
        echo "No session found matching: $arg"
        cld
        return 1
    fi

    # Check actual filesystem — the cached summary can be stale.
    # Also prevents a failed resume from firing the SessionEnd hook and corrupting the TSV.
    if ! _cld_transcript_exists "$match"; then
        echo "⚠  Transcript file not found on disk for session: $display ($match)"
        printf "   Continue anyway? [y/N] "
        read -r ans
        [[ "$ans" =~ ^[Yy] ]] || return 1
    fi

    echo "Resuming: $display ($match)"

    # Claude stores transcripts keyed by the project cwd; resume must run from the
    # same directory the session was created in, otherwise Claude can't find the file.
    if [ -n "$origdir" ] && [ -d "$origdir" ]; then
        (cd "$origdir" && claude --resume "$match")
    else
        claude --resume "$match"
    fi
}

alias cldname=cldtag
alias cldresume=cldr
