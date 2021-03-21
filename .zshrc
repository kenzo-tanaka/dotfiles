# history
# pecoでhistory検索
# peco settings
# 過去に実行したコマンドを選択。ctrl-rにバインド
function peco-select-history() {
  BUFFER=$(\history -n -r 1 | peco --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle clear-screen
}
zle -N peco-select-history
bindkey '^r' peco-select-history

# search a destination from cdr list
function peco-get-destination-from-cdr() {
  cdr -l | \
  sed -e 's/^[[:digit:]]*[[:blank:]]*//' | \
  peco --query "$LBUFFER"
}


### 過去に移動したことのあるディレクトリを選択。ctrl-uにバインド
function peco-cdr() {
  local destination="$(peco-get-destination-from-cdr)"
  if [ -n "$destination" ]; then
    BUFFER="cd $destination"
    zle accept-line
  else
    zle reset-prompt
  fi
}
zle -N peco-cdr
bindkey '^u' peco-cdr

# ブランチを簡単切り替え。git checkout lbで実行できる
alias -g lb='`git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'

alias today='date "+%Y%m%d"'
alias personal='cd ~/Documents/personal'
alias work='cd ~/Documents/work'
# TODO: not foundになるので要対応
alias pr='bash ~/dotfiles/create-pr.sh'
alias ls='ls -F'

# Git関連
alias gst='git status'
alias gdiff='git diff'
alias gco='git commit'
alias gre='git reset --soft head^'
alias gfm='git fetch; gd master; gcb master origin/master'
alias gfmd='gfm; git branch | grep / |  while read branch ; do git branch -D ${branch} ; done ;'
alias gcom='git commit -m'
alias gr='git remote -v'
alias gc='git checkout'
alias gm='git checkout master'
alias gcb='git checkout -b'
alias gl='git log'
alias gb='git branch'
alias gac='git add .; git commit'
alias gpull='git pull origin master'
alias gd='git branch -D'
alias ga='git add .'
alias gp='git push origin head'
# main branch
alias gfmain='git fetch; gd main; gcb main origin/main'
alias gfmaind='gfmain; git branch | grep / |  while read branch ; do git branch -D ${branch} ; done ;'
# hub
alias hb='hub browse'
alias hbi='hub browse -- issues'

# Ruby, Ruby on Rails関連
alias rubo='rubocop --auto-correct'
alias spec='bundle exec rspec'
alias mig='rails db:migrate'
alias ann='bundle exec annotate'
alias rc='bin/rails c'
alias rs='bin/rails s'

# bash関連
alias sz='source ~/.zshrc'

# ターミナル操作
alias cl='clear'
alias ex='exit'

zle -N peco-select-history
bindkey '^r' peco-select-history

export PS1="%~ %n "
