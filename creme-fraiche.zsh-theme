# -*- mode: sh; -*-

##
# Crème fraîche ZSH Theme
# https://github.com/koenwoortman/creme-fraiche-zsh-theme
#
# Credits to: https://github.com/tardypad/dotfiles
#
# Code licensed under the MIT license
##

## Init
setopt PROMPT_SUBST

## Options
VI_INS_MODE_SYMBOL=${VI_INS_MODE_SYMBOL:-'λ'}
VI_CMD_MODE_SYMBOL=${VI_CMD_MODE_SYMBOL:-'ᐅ'}

## Set symbol for the initial mode
VI_MODE_SYMBOL="${VI_INS_MODE_SYMBOL}"

# on keymap change, define the mode and redraw prompt
zle-keymap-select() {
  if [ "${KEYMAP}" = 'vicmd' ]; then
    VI_MODE_SYMBOL="${VI_CMD_MODE_SYMBOL}"
  else
    VI_MODE_SYMBOL="${VI_INS_MODE_SYMBOL}"
  fi
  zle reset-prompt
}
zle -N zle-keymap-select

# reset to default mode at the end of line input reading
zle-line-finish() {
  VI_MODE_SYMBOL="${VI_INS_MODE_SYMBOL}"
}
zle -N zle-line-finish

# Fix a bug when you C-c in CMD mode, you'd be prompted with CMD mode indicator
# while in fact you would be in INS mode.
# Fixed by catching SIGINT (C-c), set mode to INS and repropagate the SIGINT,
# so if anything else depends on it, we will not break it.
TRAPINT() {
  VI_MODE_SYMBOL="${VI_INS_MODE_SYMBOL}"
  return $(( 128 + $1 ))
}

PROMPT='%f%B%F{240}%1~%f%b %(?.%F{green}$VI_MODE_SYMBOL.%F{red}$VI_MODE_SYMBOL) '
