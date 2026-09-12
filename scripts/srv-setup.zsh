# Sourced inside the pty'd zsh, AFTER ~/.zshrc has run.
# Emits one TSV line per match:  <replace_len>\t<insert>\t<label>\t<description>
# replace_len is how many bytes before the cursor the insert replaces.

compadd() {
  emulate -L zsh
  setopt extendedglob
  local -a __hits __dscr
  local __i __d __p=''
  for (( __i = 1; __i <= $#; __i++ )); do
    case ${argv[__i]} in
      --|-) break ;;                          # end of options
      -[a-zA-Z]#d)                            # -d, or bundled e.g. -ld
        __d=${argv[__i+1]}
        if [[ $__d == '('* ]]; then __dscr=( ${=__d//[()]/} ); else __dscr=( ${(P)__d} ); fi ;;
      -[a-zA-Z]#p) __p=${argv[__i+1]} ;;      # hidden prefix (path completion)
    esac
  done

  builtin compadd -O __hits -D __dscr "$@"

  local __n=$(( ${#IPREFIX} + ${#PREFIX} ))
  for (( __i = 1; __i <= $#__hits; __i++ )); do
    builtin print -r -- "$__n"$'\t'"${IPREFIX}${__p}${__hits[__i]}"$'\t'"${__hits[__i]}"$'\t'"${__dscr[__i]:-}" \
      >> $CAPTURE_OUT
  done

  builtin compadd "$@"
}

_capture_complete() {
  _main_complete
  # Never insert or list. Listing 168 matches through the pty cost ~4s; and a
  # clean menu/oldlist state is what makes the *next* request re-run the
  # completers instead of cycling a stale menu.
  compstate[insert]=''
  compstate[list]=''
  _lastcomp=()
}
zle -C capture-complete complete-word _capture_complete

_capture_driver() {
  local -a req
  req=( "${(@f)$(<$CAPTURE_IN)}" )     # line 1: cwd, line 2: the buffer
  builtin cd -q -- ${req[1]} 2>/dev/null
  BUFFER=${req[2]:-}
  CURSOR=$#BUFFER
  zle capture-complete
  builtin print -r -- '@@END@@' >> $CAPTURE_OUT
  BUFFER=''; CURSOR=0
}
zle -N capture-driver _capture_driver
bindkey '^X^X' capture-driver
