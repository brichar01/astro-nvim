#!/usr/bin/env zsh
# Long-lived zsh completion server.
#   stdin   <id>\t<cwd>\t<line>
#   stdout  <id>\t<match>\t<description>   ... then  <id>\t@@END@@
# Prints @@READY@@ once the pty is warm.
emulate -L zsh
zmodload zsh/zpty || { print -r -- '@@FATAL@@ no zsh/zpty'; exit 1 }

local setup=${0:A:h}/srv-setup.zsh
local out=$(mktemp) in=$(mktemp)
trap 'zpty -d Z 2>/dev/null; rm -f -- $out $in' EXIT INT TERM

zpty Z zsh -i                       # the user's real ~/.zshrc
zpty -w Z "CAPTURE_OUT=$out; CAPTURE_IN=$in"
zpty -w Z "source $setup"
zpty -w Z 'print -- SETUP${:-_}OK'

local buf; integer n=0
while (( ++n < 2000 )) && zpty -r Z buf; do
  [[ $buf == *SETUP_OK* ]] && break
done
print -r -- '@@READY@@'

local req id cwd line m
while IFS= read -r req; do
  id=${req%%$'\t'*}; req=${req#*$'\t'}
  cwd=${req%%$'\t'*}; line=${req#*$'\t'}

  : > $out
  print -rn -- "$cwd"$'\n'"$line" > $in
  zpty -w -n Z $'\C-x\C-x'

  integer i=0
  while (( ++i < 400 )); do
    zpty -r -t Z buf 2>/dev/null
    grep -q '@@END@@' -- $out 2>/dev/null && break
    sleep 0.005
  done

  while IFS= read -r m; do
    [[ $m == '@@END@@' ]] && continue
    print -r -- "$id"$'\t'"$m"
  done < $out
  print -r -- "$id"$'\t'"@@END@@"
done
