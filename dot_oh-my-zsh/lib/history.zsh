## History wrapper
function omz_history {
  # parse arguments and remove from $@
  local clear list stamp REPLY
  zparseopts -E -D c=clear l=list f=stamp E=stamp i=stamp t:=stamp

  if [[ -n "$clear" ]]; then
    # if -c provided, clobber the history file

    # confirm action before deleting history
    print -nu2 "This action will irreversibly delete your command history. Are you sure? [y/N] "
    builtin read -E
    [[ "$REPLY" = [yY] ]] || return 0

    print -nu2 >| "$HISTFILE"
    fc -p "$HISTFILE"

    print -u2 History file deleted.
  elif [[ $# -eq 0 ]]; then
    # if no arguments provided, show full history starting from 1
    builtin fc $stamp -l 1
  else
    # otherwise, run `fc -l` with a custom format
    builtin fc $stamp -l "$@"
  fi
}

# Timestamp format
case ${HIST_STAMPS-} in
  "mm/dd/yyyy") alias history='omz_history -f' ;;
  "dd.mm.yyyy") alias history='omz_history -E' ;;
  "yyyy-mm-dd") alias history='omz_history -i' ;;
  "") alias history='omz_history' ;;
  *) alias history="omz_history -t '$HIST_STAMPS'" ;;
esac

## History file configuration
#[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
#[ "$HISTSIZE" -lt 50000 ] && HISTSIZE=50000
#[ "$SAVEHIST" -lt 10000 ] && SAVEHIST=10000
HISTFILE=/home/styroteqe/.zsh_history
SAVEHIST=1000000000
export HIST_STAMPS="mm/dd/yyyy"
export HISTSIZE=1000000000 
export HISTFILESIZE=1000000000 
export HISTTIMEFORMAT="[%F %T]"


## History command configuration
setopt extended_history       # record timestamp of command in HISTFILE
setopt hist_expire_dups_first # delete duplicates first when HISTFILE size exceeds HISTSIZE
unsetopt hist_ignore_dups       # ignore duplicated commands history list
unsetopt hist_ignore_space      # ignore commands that start with space
setopt hist_verify            # show command with history expansion to user before running it
unsetopt share_history          # share command history data
setopt inc_append_history
setopt hist_find_no_dups

