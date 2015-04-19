#!/usr/bin/zsh
#### Antigen ####
source /usr/share/zsh/scripts/antigen/antigen.zsh
antigen bundle zsh-users/zsh-syntax-highlighting
antigen use oh-my-zsh
antigen bundle git
antigen bundle pip
antigen bundle archlinux
antigen bundle dirhistory
#antigen bundle common-aliases
antigen bundle encode64
antigen bundle jsontools
antigen bundle pylint
antigen bundle python
antigen theme bira
#antigen theme nfarrar/oh-my-powerline oh-my-powerline
antigen apply

#### VARS ####
EDITOR="vim"
PATH=${HOME}/.local/bin/:$PATH
HISTFILE=~/.zsh_history
HISTSIZE=100000000
SAVEHIST=$HISTSIZE
WORDCHARS="${WORDCHARS}._-()[]{}"
export PATH HISTFILE HISTSIZE SAVEHIST WORDCHARS
#. ${HOME}/.local/lib/python3.4/site-packages/powerline/bindings/zsh/powerline.zsh

# Loading programs
autoload zmv
autoload colors
colors
autoload edit-command-line
zle -N edit-command-line
zmodload zsh/mathfunc

#### Scripts ####
function cs () {
    cd "$@" && ls -A
}

function mkcd () {
    mkdir -pv "$@" && cd "$@" 
}

function vimcd () {
    cd "${@:h}" && vim "${@:t}"
}

function vnow () {
    vim "$(date '+%Y_%m_%d')_$@.md"
}

function insert_date () {
    echo -n "$(date '+%Y_%m_%d')"
}
zle -N insert_date

function gsearch () {
    find / -name "*$@*" 2> /dev/null
}

# FIXME
function man_open () {
    exec </dev/tty
    man "${BUFFER[(w)1]}"
}
zle -N man_open

function sudo_call () {
    BUFFER="sudo $BUFFER"
    CURSOR=$#BUFFER
}
zle -N sudo_call

# FIXME
function vim_cmd_edit () {
    TEMPFILE=$(mktemp)
    echo $BUFFER > $TEMPFILE
    vim $TEMPFILE
    rm $TEMPFILE
}
zle -N vim_cmd_edit

function rationalise-dot () {
    if [[ $LBUFFER = *.. ]]; then
        LBUFFER+=/..
    else
        LBUFFER+=.
    fi
}
zle -N rationalise-dot

# copy and deactivate mark
# http://unix.stackexchange.com/questions/19947/adding-more-emacs-like-bindings-to-zshs-line-editor-zle
function copy-region-as-kill-deactivate-mark () {
  zle copy-region-as-kill
  zle set-mark-command -n -1
}
zle -N copy-region-as-kill-deactivate-mark

function forward-path-segment () {
    SAVE=$WORDCHARS
    WORDCHARS="${SAVE}/"
    zle forward-word
    WORDCHARS=$SAVE
}
zle -N forward-path-segment

function backward-path-segment () {
    SAVE=$WORDCHARS
    WORDCHARS="${SAVE}/"
    zle backward-word
    WORDCHARS=$SAVE
}
zle -N backward-path-segment

#backward-word
#function backward_path () {
#    if [[ $LBUFFER in $WORDCHARS ]]; then
#        CUROSR=$CURSOR-1;
#    else
#        LBUFFER+=.
#    fi
#}

#### Bind keys ####
#
# Warning: Delete key sends ^[[3~ (not ^?)
#
# Warning: Backspace sends ^?
# source ~/.zkbd/$TERM-${${DISPLAY:t}:-$VENDOR-$OSTYPE}
[[ -n ${key[Left]} ]] && bindkey "${key[Left]}" backward-char
[[ -n ${key[Right]} ]] && bindkey "${key[Right]}" forward-char
    # etc.
# TODO: Move to keymap?
# KEY C-Z -> Zoom into window
bindkey '^[e' vi-forward-blank-word-end
bindkey '^[%' vi-match-bracket
bindkey '^[u' undo
bindkey '^[$' vi-kill-eol
bindkey '^[0' backward-kill-line
bindkey '^[B' backward-path-segment
bindkey '^[F' forward-path-segment
bindkey '^[r' history-incremental-pattern-search-backward
#bindkey '^[s' history-incremental-pattern-search-forward
bindkey '^[s' sudo_call
bindkey . rationalise-dot
#bindkey '^[p' vim_cmd_edit
bindkey '^[m' man_open
bindkey '^[o' insert_date
bindkey '^[p' edit-command-line
bindkey '^[Z' kill-region
#bindkey '\ew' copy-region-as-kill-deactivate-mark
bindkey '^[z' copy-region-as-kill-deactivate-mark
#bindkey '^[[1;3A' dirhistory_zle_dirhistory_future
#bindkey '^[[1;3B' dirhistory_zle_dirhistory_back
#
# COPY:
# - Always copy from marker (default: begin of line) to cursor
# - Set Marker with C-@
# - Copy with A-z
# - Cut with A-Z
#
# PASTE:
# - Uses a ring with previously copied/cut entries
# - Paste with C-y
# - (After paste:) Iterate through entries with A-y
#
# MOVE:
# C-A -> Begin of line
# C-K -> End of line
# C-<ARROW-BACKWARD/FORWARD> -> move through words
# A-B/F -> move through path segments
# A-<ARROW-BACKWARD/FORWARD> -> move through directory stack
#
# DELETE:
# A-D -> Delete next word
# A-<BACKSPACE> -> Delete last word
# A-$ -> Delete till end of line
# A-0 -> Delete till beginning of line
# C-U -> Delete all
#

#### Aliases ####
# start applications
alias -s tex=vim
alias -s pl=vim
alias -s pdf=zathura
alias -s bashrc=vim
alias -s zshrc=vim
alias -s txt=vim
alias -s html=chromium
alias -s htm=chromium
alias -s xcf=gimp

# set aliases
alias l='less'
alias v='vim'
alias vi='vim'
alias vd='vimdiff'
alias lt='ls -t | head -30'
alias mkdir='mkdir -pv'
alias cp='cp -v'
alias search='find . -name '

# end of line aliases
alias -g C='| wc -l'
alias -g N='2>/dev/null'
alias -g LL='2>&1 | less'
alias -g G='| grep -i'
alias -g PS='ps -ef | grep'
alias -g L='| less'
alias -g M='| more'
alias -g S='| sort'
alias -g SU='| sort -u'
alias -g H='| head'
alias -g T='| tail'

# Dots

#### Completion ####
# first test of completion
autoload -Uz compinit
compinit
setopt AUTO_LIST AUTO_MENU
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' menu select=10
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*' group-name ''
zstyle ':completion:*:descriptions' format '-- %d --'
zstyle ':completion:*:cd:*' ignore-parents parent pwd # never autocomplete parent dir
zstyle ':completion:*:kill:*' verbose yes # show description for kill

#### OPTIONS ####
# History
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt EXTENDED_HISTORY
setopt EXTENDEDGLOB NOTIFY

# Disable weird Behavior of C-s/q
setopt NO_FLOW_CONTROL
#stty -ixon

# go through dirs with <ENTER>
setopt AUTOCD AUTOPUSHD PUSHDIGNOREDUPS

#### Load local stuff ####
if [ -e ~/.zshrc_local ]; then
    source ~/.zshrc_local
fi

# For Terminator
export TERM=xterm-256color
