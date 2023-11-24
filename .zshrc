eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$HOME/.local/bin:$PATH"
export PATH=$HOME/.bin/node_modules/.bin:$PATH
export PATH="$HOME/.yarn/bin:$HOME/.config/yarn/global/node_modules/.bin:$PATH"

function git_info {
  ref=$(git symbolic-ref HEAD 2> /dev/null) || return;
  last_commit=$(git log --pretty=format:%at -1 2> /dev/null) || return;
  now=`date +%s`;
  sec=$((now-last_commit));
  min=$((sec/60)); hr=$((min/60)); day=$((hr/24)); yr=$((day/365));
  if [ $min -lt 60 ]; then
  	info="${min}m"
  elif [ $hr -lt 24 ]; then
  	info="${hr}h$((min%60))m"
  elif [ $day -lt 365 ]; then
  	info="${day}d$((hr%24))h"
  else
  	info="${yr}y$((day%365))d"
  fi
  echo "(${ref#refs/heads/} $info)";
}

# Set up the prompt (with git branch name)
setopt PROMPT_SUBST

# Load version control information
autoload -Uz vcs_info
precmd() { vcs_info }

# Format the vcs_info_msg_0_ variable
zstyle ':vcs_info:git:*' formats ' (%b)'

# color
PROMPT='%F{014}%n%f@%F{010}%m%f:%F{226}%~%f${vcs_info_msg_0_}$ '

# some more ls aliases
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

#Change color of username, server name, and path
alias ..='cd ..'
alias cls='clear'
alias cp='cp -i'
alias cd='venv_cd'
alias mv='mv -i'
alias vi='nvim'

#cd() { builtin cd "$@"; ls; }
alias cd..='cd ../'                         # Go back 1 directory level (for fast typers)
alias ..='cd ../'                           # Go back 1 directory level
alias ...='cd ../../'                       # Go back 2 directory levels
alias ....='cd ../../../'                   # Go back 3 directory levels

tmux(){
    if [[ $@ == "ls" ]]; then
        command tmux list-sessions
    elif [[ $@ == "a" ]]; then
	command tmux attach-session
    else
        command tmux "$@"
    fi
}

git(){
	if [[ $@ == "log" ]]; then
		command git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
	else
		command git "$@"
	fi
}

function venv_cd {
  \cd "$@" && venv_cwd
}
function venv_cwd {
  # Check that this is a Git repo
  unset ENV_NAME
  GIT_DIR=`git rev-parse --git-dir 2> /dev/null`
  if [ $? -eq 0 ]; then
    # Find the repo root and check for virtualenv name override
    GIT_DIR=`\cd $GIT_DIR; pwd`
    PROJECT_ROOT=`dirname "$GIT_DIR"`
    ENV_NAME=`basename "$PROJECT_ROOT"`
    if [ -d ".venv" ]; then
      . .venv/bin/activate && export CD_VIRTUAL_ENV="venv"
    fi
  elif [ $CD_VIRTUAL_ENV ]; then
    deactivate && unset CD_VIRTUAL_ENV
  fi
}

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

export PYENV_ROOT="$HOME/.pyenv"
command -v pyenv >/dev/null || export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
