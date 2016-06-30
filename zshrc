typeset -U path cdpath fpath manpath

fpath=(/usr/local/share/zsh-completions ${fpath})
autoload -Uz compinit; compinit -C
source ~/.zsh.d/zplugrc
source /usr/local/share/zsh/site-functions/_aws
zstyle ':completion:*' use-cache yes

export LANG=ja_JP.UTF-8
export EDITOR=/usr/local/bin/vim
bindkey -e

eval "$(direnv hook zsh)"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

setopt hist_ignore_alldups
setopt hist_find_no_dups
setopt hist_reduce_blanks
setopt hist_no_store
setopt extended_history
setopt inc_append_history
setopt share_history

alias tailf='tail -f'
alias bup='brew update; brew upgrade --all; brew cleanup'
alias -g ghome='$HOME/src/github.com/chiastolite'
alias -g gtesthome='$HOME/src/github.com/chiastolite-test'

alias pop='powder open'
alias vi=vim

[[ -s `brew --prefix`/etc/autojump.sh ]] && . `brew --prefix`/etc/autojump.sh


COMP_WORDBREAKS=${COMP_WORDBREAKS/=/}
COMP_WORDBREAKS=${COMP_WORDBREAKS/@/}
export COMP_WORDBREAKS

if type complete &>/dev/null; then
  _npm_completion () {
    local si="$IFS"
    IFS=$'\n' COMPREPLY=($(COMP_CWORD="$COMP_CWORD" \
                           COMP_LINE="$COMP_LINE" \
                           COMP_POINT="$COMP_POINT" \
                           npm completion -- "${COMP_WORDS[@]}" \
                           2>/dev/null)) || return $?
    IFS="$si"
  }
  complete -F _npm_completion npm
elif type compdef &>/dev/null; then
  _npm_completion() {
    si=$IFS
    compadd -- $(COMP_CWORD=$((CURRENT-1)) \
                 COMP_LINE=$BUFFER \
                 COMP_POINT=0 \
                 npm completion -- "${words[@]}" \
                 2>/dev/null)
    IFS=$si
  }
  compdef _npm_completion npm
elif type compctl &>/dev/null; then
  _npm_completion () {
    local cword line point words si
    read -Ac words
    read -cn cword
    let cword-=1
    read -l line
    read -ln point
    si="$IFS"
    IFS=$'\n' reply=($(COMP_CWORD="$cword" \
                       COMP_LINE="$line" \
                       COMP_POINT="$point" \
                       npm completion -- "${words[@]}" \
                       2>/dev/null)) || return $?
    IFS="$si"
  }
  compctl -K _npm_completion npm
fi
###-end-npm-completion-###

function exists { which $1 &> /dev/null }

# {{{ peco
if exists peco; then
  function peco-src () {
    local selected_dir=$(ghq list --full-path | sed s@${HOME}@~@ | peco --query "$LBUFFER" --prompt "GHQ>")
    if [ -n "$selected_dir" ]; then
      BUFFER="cd ${selected_dir}"
      zle accept-line
    fi
    zle clear-screen
  }
  zle -N peco-src
  bindkey '^G' peco-src

  function peco_select_history() {
    local tac
    exists gtac && tac="gtac" || { exists tac && tac="tac" || { tac="tail -r" } }
    BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER" --prompt "HISTORY>")
    CURSOR=$#BUFFER         # move cursor
    zle -R -c               # refresh
  }
  zle -N peco_select_history
  bindkey '^R' peco_select_history

  function peco_git_hashtag() {
    if [ -d .git ]; then
      BUFFER=$(git log --oneline | peco --query "$LBUFFER" --prompt "GIT_LOG >"| cut -f1 -d' ')
      if [ -n $BUFFER ]; then
        CURSOR=$#BUFFER
      fi
      zle clear-screen
    fi
  }
  zle -N peco_git_hashtag
  bindkey '^S' peco_git_hashtag
fi
# }}}


#

#case ${OSTYPE} in
#  darwin*) # Mac OS X
#    function macvim () {
#    if [ -d /Applications/MacVim.app ]
#    then
#      [ ! -f $1 ] && touch $1
#      open -a MacVim $1
#    else
#      vim $1
#    fi
#  }
#  alias vim='macvim'
#  ;;
#esac

# The next line updates PATH for the Google Cloud SDK.
source $HOME/google-cloud-sdk/path.zsh.inc

# The next line enables shell command completion for gcloud.
source $HOME/google-cloud-sdk/completion.zsh.inc

# for profile
# http://blog.uu59.org/2013-06-01-zsh-optimize.html
if (which zprof > /dev/null) ;then
  zprof | less
fi
