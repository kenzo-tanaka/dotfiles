# default:cyan / root:red
if [ $UID -eq 0 ]; then
    PS1="\[\033[31m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
else
    PS1="\[\033[36m\]\u@\h\[\033[00m\]:\[\033[01m\]\w\[\033[00m\]\\$ "
fi

# ターミナルの出力を変える
export PS1="\W \$ "

alias today='date "+%Y%m%d"'
alias personal='cd ~/Documents/personal'
alias work='cd ~/Documents/work'
alias ls='ls -F'
alias dockb='docker-compose build'
alias docku='docker-compose up'
alias dockd='docker-compose down'
alias gst='git status'
alias gdiff='git diff'
alias gco='git commit'
alias gre='git reset --soft head^'
alias gfm='git fetch; gd master; gcb master origin/master'
alias gfmd='gfm; git branch | grep / |  while read branch ; do git branch -D ${branch} ; done ;'
alias rubo='rubocop --auto-correct'
alias gcom='git commit -m'
alias gr='git remote -v'
alias gc='git checkout'
alias spec='bundle exec rspec'
alias mig='rails db:migrate'
alias ann='bundle exec annotate'
alias gd='git branch -D'
alias ga='git add .'
alias gp='git push origin head'
alias cl='clear'
alias rs='bin/rails s'
alias gm='git checkout master'
alias gcb='git checkout -b'
alias gl='git log'
alias gb='git branch'
alias gac='git add .; git commit'
alias vb='vi ~/.bashrc'
alias sb='source ~/.bashrc'
alias gpull='git pull origin master'
alias rc='bin/rails c'
alias ex='exit'
function find_cd() {
    cd "$(find . -type d | peco)"  
}
alias fc="find_cd"

PATH="$PATH:~/bin"
GOPATH=$HOME/go
