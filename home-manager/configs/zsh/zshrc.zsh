# Completion
autoload -U compinit 
compinit

# Completion options from zsh lovers
zstyle ':completion:*' menu select

zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

zstyle ':completion:*:descriptions' format '%U%B%d%b%u'
zstyle ':completion:*:warnings' format '%BSorry, no matches for: %d%b' 

zstyle ':completion::complete:*' gain-privileges 1
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}

zstyle ':completion:*' completer _complete _match _approximate
zstyle ':completion:*:match:*' original only
zstyle ':completion:*:approximate:*' max-errors 1 numeric

# Host completion copied from grml
[[ -r ~/.ssh/config ]] && _ssh_config_hosts=(${${(s: :)${(ps:\t:)${${(@M)${(f)"$(<$HOME/.ssh/config)"}:#Host *}#Host }}}:#*[*?]*}) || _ssh_config_hosts=()
[[ -r ~/.ssh/known_hosts ]] && _ssh_hosts=(${${${${(f)"$(<$HOME/.ssh/known_hosts)"}:#[\|]*}%%\ *}%%,*}) || _ssh_hosts=()
[[ -r /etc/hosts ]] && : ${(A)_etc_hosts:=${(s: :)${(ps:\t:)${${(f)~~"$(</etc/hosts)"}%%\#*}##[:blank:]#[^[:blank:]]#}}} || _etc_hosts=()

hosts=(
	$(hostname)
	"$_ssh_config_hosts[@]"
	"$_ssh_hosts[@]"
	"$_etc_hosts[@]"
	localhost
       )

zstyle ':completion:*:hosts' hosts $hosts

# Glob settings
setopt extendedglob

# History
export HISTSIZE=2000
export HISTFILE="$HOME/.history" 
export SAVEHIST=$HISTSIZE
setopt hist_ignore_all_dups
setopt hist_ignore_space
setopt share_history

# Rationalize dot (... -> ../..)
rationalise-dot() {
  if [[ $LBUFFER = *.. ]]; then
    LBUFFER+=/..
  else
    LBUFFER+=.
  fi
}

# Automatically expand dots
zle -N rationalise-dot
bindkey . rationalise-dot

# Colored output in man pages
man() {
    LESS_TERMCAP_md=$'\e[01;31m' \
    LESS_TERMCAP_me=$'\e[0m' \
    LESS_TERMCAP_se=$'\e[0m' \
    LESS_TERMCAP_so=$'\e[01;44;33m' \
    LESS_TERMCAP_ue=$'\e[0m' \
    LESS_TERMCAP_us=$'\e[01;32m' \
    command man "$@"
}
# Edit current line with editor 
autoload edit-command-line
zle -N edit-command-line
bindkey '^x^e' edit-command-line

alias mkdir = "mkdir -pv";
alias hm = "home-manager";

# misc
alias space="du -Sh | sort -rh | head -10";
alias now="date +%s";
alias fzfp="fzf --preview 'bat --style=numbers --color=always {}'";