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
alias airpods='bash ~/dotfiles/utils/connect-airpods.sh'
alias cv-img='bash ~/dotfiles/utils/convert-img.sh'
alias ls='ls -F'

## ----------------------------------------
##  Git alias
## ----------------------------------------
alias -g lb='`git branch | peco --prompt "GIT BRANCH>" | head -n 1 | sed -e "s/^\*\s*//g"`'
alias -g gc='git checkout'
alias -g gclb='git checkout lb'
alias -g gst='git status'
alias -g gdiff='git diff'

# https://speakerdeck.com/koic/tdd-with-git-long-live-engineering?slide=62
alias -g ga='git add .'
alias -g gco='ga;git commit'
alias -g gcf='ga;git commit -v --fixup=HEAD'
alias -g gri='(){git rebase -i --autosquash HEAD~$1}'

alias -g gre='git reset --soft head^'
alias -g gfm='git fetch; gd master; gcb master origin/master'
alias -g gfmd='gfm; git branch | grep / |  while read branch ; do git branch -D ${branch} ; done ;'
alias -g gr='git remote -v'
alias -g gm='git checkout master'
alias -g gcb='git checkout -b'
alias -g gl='git log'
alias -g glo='git log --oneline'
alias -g gb='git branch'
alias -g gd='git branch -D'
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
alias b='bundle exec'
alias rspec='rbenv exec bundle exec rspec'
alias rails='rbenv exec bundle exec rails'
alias rubocop='rbenv exec bundle exec rubocop'

## ----------------------------------------
##  Python3
## ----------------------------------------

alias p3='python3'

alias sz='source ~/.zshrc'
alias pathes='echo "${PATH//:/\n}"'
alias curlp='(){ curl $1 | json_pp }'

alias cl='clear'
alias ex='exit'

## ----------------------------------------
##  zsh-autosuggestions
## ----------------------------------------
source ~/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh

export PATH="$HOME/.cargo/bin:$PATH"

# npm install -g でインストールしたものを動かす
export PATH=~/.npm-global/bin:$PATH

# curl実行時にno matches found解消のため
# @see https://unix.stackexchange.com/a/310553 
setopt +o nomatch

export PATH="$PATH:/opt/homebrew/bin"

export PATH="$HOME/.rbenv/bin:$PATH"
eval "$(rbenv init - zsh)"

# GOPATH
export GOPATH=$HOME/.go

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion


# M1 homebrew
typeset -U path PATH
path=(
	/opt/homebrew/bin(N-/)
	/usr/local/bin(N-/)
	$path
)

# switch-arch command
if (( $+commands[sw_vers] )) && (( $+commands[arch] )); then
	[[ -x /usr/local/bin/brew ]] && alias brew="arch -arch x86_64 /usr/local/bin/brew"
	alias x64='exec arch -x86_64 /bin/zsh'
	alias a64='exec arch -arm64e /bin/zsh'
	switch-arch() {
		if  [[ "$(uname -m)" == arm64 ]]; then
			arch=x86_64
		elif [[ "$(uname -m)" == x86_64 ]]; then
			arch=arm64e
		fi
		exec arch -arch $arch /bin/zsh
	}
fi
export PATH="$HOME/.anyenv/bin:$PATH"
