#
# adapted from https://www.reddit.com/r/linux/comments/1pooe6/zsh_tip_notify_after_long_processes
#

autoload -U add-zsh-hook

add-zsh-hook preexec longterm-beep-preexec
function longterm-beep-preexec {
    # Note the date when the command started, in unix time.
    CMD_START_DATE=$(date +%s)
    # Store the command that we're running.
    CMD_NAME=$1
}

add-zsh-hook precmd longterm-beep-precmd
function longterm-beep-precmd {
    # Proceed only if we've ran a command in the current shell.
    if ! [[ -z $CMD_START_DATE ]]; then
        # Note current date in unix time
        CMD_END_DATE=$(date +%s)
        # Store the difference between the last command start date vs. current date.
        CMD_ELAPSED_TIME=$(($CMD_END_DATE - $CMD_START_DATE))
        # Store an arbitrary threshold, in seconds.
        CMD_NOTIFY_THRESHOLD=20

        if [[ $CMD_ELAPSED_TIME -gt $CMD_NOTIFY_THRESHOLD ]]; then
            # Beep or visual bell if the elapsed time (in seconds) is greater than threshold
            print -n '\a'
            # Send a notification
            notify-send 'Job finished' "The job \"$CMD_NAME\" has finished."
        fi
    fi
}
