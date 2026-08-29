#!/bin/sh
# Route the pinentry prompt into a tmux popup.
#
# gpg-agent draws the prompt on whichever tty it last had (see
# updatestartuptty in zshrc). When signing is triggered from a
# non-interactive context - an agent, a script, cron - that tty either
# belongs to someone else or does not exist, so the prompt is never seen and
# the operation dies with "Timeout". Showing it as a popup puts it in front
# of whoever is attached to tmux, whatever started the signature.
#
# gpg-agent speaks the Assuan protocol to this process over stdin/stdout, so
# those fds must be left alone; only the prompt's *display* is redirected.

PINENTRY=/usr/bin/pinentry-curses
# Absolute: gpg-agent runs this with a minimal PATH.
TMUX_BIN=/usr/bin/tmux

# Nobody attached to show a popup to: behave exactly like plain pinentry.
if [ ! -x "$TMUX_BIN" ] \
   || [ -z "$("$TMUX_BIN" list-clients -F '#{client_tty}' 2>/dev/null)" ]; then
    exec "$PINENTRY" "$@"
fi

# pinentry-curses aborts with "Screen or window too small" if it cannot fit
# the prompt, and the card unlock prompt is several lines. Below that, a
# popup helps nobody, so use the plain prompt.
size=$("$TMUX_BIN" display -p '#{client_width}x#{client_height}' 2>/dev/null)
if [ "${size%x*}" -lt 60 ] 2>/dev/null || [ "${size#*x}" -lt 20 ] 2>/dev/null; then
    exec "$PINENTRY" "$@"
fi

dir=$(mktemp -d) || exec "$PINENTRY" "$@"
tty_file="$dir/tty"

cleanup() { rm -rf "$dir"; }
trap cleanup EXIT INT TERM

# The popup only holds a pty open for pinentry to draw on. It exits as soon
# as this process is gone - polling liveness rather than waiting for a
# sentinel file, so that a SIGKILL (which runs no trap) still releases it,
# and there is no race against cleanup removing the file first. The counter
# is a backstop so a popup can never outlive the session indefinitely.
"$TMUX_BIN" display-popup -d "$HOME" -w 90% -h 70% -E \
    "tty > '$tty_file'; n=0; while kill -0 $$ 2>/dev/null && [ \$n -lt 3000 ]; do sleep 0.1; n=\$((n+1)); done" \
    >/dev/null 2>&1 &

i=0
while [ ! -s "$tty_file" ] && [ "$i" -lt 50 ]; do
    sleep 0.1
    i=$((i + 1))
done

if [ ! -s "$tty_file" ]; then           # popup never came up
    cleanup
    trap - EXIT INT TERM
    exec "$PINENTRY" "$@"
fi

tty=$(cat "$tty_file")

# --ttyname covers the case where the agent sends no ttyname at all; the sed
# rewrite covers the usual case, where its OPTION would override the flag.
sed -u "s|^OPTION ttyname=.*|OPTION ttyname=$tty|" | "$PINENTRY" --ttyname "$tty" "$@"
