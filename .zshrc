## ----------------------------------------
##  Prompt
## ----------------------------------------
function git_branch_name()
{
  branch=$(git symbolic-ref HEAD 2> /dev/null | awk 'BEGIN{FS="/"} {print $NF}')
  if [[ $branch == "" ]];
  then
    :
  else
    echo ' ('$branch')'
  fi
}
setopt prompt_subst

PROMPT='%F{green}%*%f: %F{blue}%1d%f%F{red}$(git_branch_name)%f $ '

## ----------------------------------------
##  History
## ----------------------------------------
HISTFILE=$HOME/.zsh-history
HISTSIZE=100000
SAVEHIST=1000000

setopt inc_append_history
setopt share_history

## ----------------------------------------
##  Peco
## ----------------------------------------
function peco-history-selection() {
    BUFFER=`history -n 1 | tail -r  | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N peco-history-selection
bindkey '^R' peco-history-selection


alias today='date "+%Y%m%d"'
alias personal='cd ~/Documents/personal'
alias work='cd ~/Documents/work'
alias pr='bash ~/dotfiles/utils/create-pr.sh'
alias ls='ls -F'

## ----------------------------------------
##  Git alias
## ----------------------------------------
alias -g lb='`git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'
alias -g gc='git checkout'
alias -g gclb='git checkout lb'
alias -g gst='git status'
alias -g gdiff='git diff'
alias -g gco='git commit'
alias -g gre='git reset --soft head^'
alias -g gfm='git fetch; gd master; gcb master origin/master'
alias -g gfmd='gfm; git branch | grep / |  while read branch ; do git branch -D ${branch} ; done ;'
alias -g gcom='git commit -m'
alias -g gr='git remote -v'
alias -g gm='git checkout master'
alias -g gcb='git checkout -b'
alias -g gl='git log'
alias -g gb='git branch'
alias -g gd='git branch -D'
alias -g ga='git add .'
alias -g gp='git push origin head'
alias gfmain='git fetch; gd main; gcb main origin/main'
alias gfmaind='gfmain; git branch | grep / |  while read branch ; do git branch -D ${branch} ; done ;'
alias hb='hub browse'
alias hbi='hub browse -- issues'

## ----------------------------------------
##  Ruby, Ruby on Rails
## ----------------------------------------
alias rubo='rubocop --auto-correct'
alias spec='bundle exec rspec'
alias mig='rails db:migrate'
alias ann='bundle exec annotate'
alias rc='bin/rails c'
alias rs='bin/rails s'

alias sz='source ~/.zshrc'
alias pathes='echo "${PATH//:/\n}"'
alias curlp='(){ curl $1 | json_pp }'

alias cl='clear'
alias ex='exit'

## ----------------------------------------
##  zsh-autosuggestions
## ----------------------------------------
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
