export ZSH_UTILS_VERSION='0.1.0'

# -----------------------------------------------------------------
# Alias
# -----------------------------------------------------------------

# System
alias .='cd .'
alias ..='cd ..'
alias ...='cd ...'
alias ....='cd ....'
alias .....='cd .....'
alias ......='cd ......'
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias ngrep='grep -n'
alias rgrep='grep -R'
alias grep='grep --color=auto'
alias wget='wget -c'
alias rmf='rm -f'
alias rmdf='rm -rf'

# Debian/Ubuntu
alias sudo='sudo ' # Pass aliases to sudo
alias install='sudo apt install'
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
#alias dist-upgrade='sudo apt dist-upgrade'

# Systemd
alias start='sudo systemctl start'
alias stop='sudo systemctl stop'
alias restart='sudo systemctl restart'
alias status='sudo systemctl status'
# alias enable='sudo systemctl enable'
alias disable='sudo systemctl disable'
alias ls-enabled='systemctl list-unit-files | grep enabled'
alias ls-failed='sudo systemctl --failed'

# Apps
alias trc='transmission-remote-cli'

# Misc
alias x='extract'
alias cls='clear'
alias glt='git describe --tags `git rev-list --tags --max-count=1`'
alias gclear='git branch | grep -v "master" | xargs git branch -D && git gc --aggressive'

# -----------------------------------------------------------------
# Functions
# -----------------------------------------------------------------
function calc () {
	echo "scale=3;$@" | bc -l
}

function mk () {
	dir="$*";
	mkdir -p "$dir";
}

function mkcd () {
	dir="$*";
	mkdir -p "$dir" && cd "$dir";
}

function psg () {
	ps aux | grep "$1" | grep -v "grep"
}

function bkp() {
	name=$1
	if [[ -e $name.bkp || -L $name.bkp ]] ; then
		i=0
		while [[ -e $name-$i.bkp || -L $name-$i.bkp ]] ; do
		let i++
		done
		name=$name-$i
	fi

	if [[ -d $1 ]] ; then
		cp -r "$1" $name.bkp
	else
		cp "$1" $name.bkp
	fi
	
}

function dotfiles () {
	/usr/bin/git --git-dir=$HOME/.dotfiles/ --work-tree=$HOME $@
}
alias dotf='dotfiles'

function sys-snapshot () {
	echo "Generating the lists of explicitly installed packages in ~/.backup"

	apt list --installed > ~/.backup/ubuntu_packages || echo "apt list failed"
	cat /etc/hosts > ~/.backup/hosts || echo "save hosts failed"
	cat /etc/fstab > ~/.backup/fstab || echo "save fstab failed"
	cat /etc/crypttab > ~/.backup/crypttab || echo "save crypttab failed"
	php -m > ~/.backup/php_modules || "php failed"
	#npm list -g --depth=0 > ~/.backup/npm_packages || echo "npm failed"
	#pip list > ~/.backup/pip_packages || echo "pip failed"
	composer global show | cut -d ' ' -f1 > ~/.backup/composer_packages || echo "composer failed"
	cat /etc/cron.d/crontab.work > ~/.backup/crontab-work
	cat /etc/cron.d/crontab.user > ~/.backup/crontab-user
}

function sys-backup () {
	sys-snapshot

	dotfiles add -f ~/.backup

	message="[WIP] BACKUP"
	if [[ -n $1 ]]; then
		message="$message by $1"
	else
		message="$message by $(whoami)"
	fi

	dotfiles commit -m "$message"
}

function top10() { 
	history | awk '{a[$2]++ } END{for(i in a){print a[i] " " i}}' | sort -rn | head; 
}

function compress() {
	if [[ -n "$1" ]]; then
    	FILE=$1
        case $FILE in
        	*.tar ) shift && tar cf $FILE $* ;;
    		*.tar.bz2 ) shift && tar cjf $FILE $* ;;
     		*.tar.gz ) shift && tar czf $FILE $* ;;
        	*.tgz ) shift && tar czf $FILE $* ;;
        	*.zip ) shift && zip $FILE $* ;;
        	*.rar ) shift && rar $FILE $* ;;
        esac
    else
    	echo "usage: compress <foo.tar.gz> ./foo ./bar"
    fi
}

function ff() { 
	find . -type f -iname '*'$*'*' -ls ; 
}

function fe() { 
	find . -type f -iname '*'$1'*' -exec "${2:-file}" {} \;  ; 
}


# -----------------------------------------------------------------
# Bindings
# -----------------------------------------------------------------
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word