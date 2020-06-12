export ZSH_UTILS_VERSION='0.1.0'

# -----------------------------------------------------------------
# Alias
# -----------------------------------------------------------------
    
# System
alias cd..='cd ..'
alias ..='cd ..'
alias ...='cd ../../../'
alias ....='cd ../../../../'
alias .....='cd ../../../../'
alias .4='cd ../../../../'
alias .5='cd ../../../../..' 
alias ls='ls --color=auto'
alias ls='ls -hF --color=auto'
alias lr='ls -R'       
alias ll='ls -alh'
alias la='ll -A'
alias lm='la | less'
alias dir='dir --color=auto'
alias vdir='vdir --color=auto'
alias mkdir='mkdir -pv'
alias rm='rm -I --preserve-root'
alias mv='mv -i'
alias cp='cp -i'
alias ln='ln -i'
alias mkdir='mkdir -p -v'
alias rmf='rm -f'
alias rmdf='rm -rf'
alias more='less'
alias nano='nano -w'
alias wget='wget -c'
alias df='df -h'
alias diff='colordiff'
alias du='du -c -h'
alias free='free -m'
alias chown='chown --preserve-root'
alias chmod='chmod --preserve-root'
alias chgrp='chgrp --preserve-root'
alias grep='grep --color=auto'
alias ngrep='grep -n'
alias rgrep='grep -R'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# Debian/Ubuntu
alias sudo='sudo '
alias install='sudo apt install'
alias update='sudo apt update'
alias upgrade='sudo apt upgrade'
#alias dist-upgrade='sudo apt dist-upgrade'
alias scat='sudo cat'
alias root='sudo su'
alias reboot='sudo reboot'
alias halt='sudo halt'
alias poweroff='sudo poweroff'
alias shutdown='sudo shutdown'
alias root='sudo -i'
alias su='sudo -i'
alias meminfo='free -m -l -t'
alias psmem='ps auxf | sort -nr -k 4'
alias psmem10='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3'
alias pscpu10='ps auxf | sort -nr -k 3 | head -10'
alias cpuinfo='lscpu'
alias gpumeminfo='grep -i --color memory /var/log/Xorg.0.log'
#alias ping='ping -c 5'
alias fastping='ping -c 100 -s.2'
alias now='date +"%T"'
alias nowtime=now
alias nowdate='date +"%d-%m-%Y"'

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
alias edit='nano'

# Misc
alias x='extract'
alias cls='clear'
alias glt='git describe --tags `git rev-list --tags --max-count=1`'
alias gclear='git branch | grep -v "master" | xargs git branch -D && git gc --aggressive'
alias h='history'
alias j='jobs -l'
#alias backupNow='sh /path/to/my/backupscript.sh'
#alias openports='netstat -nape --inet'
#alias server1='ssh 192.168.1.102 -l pete'

# To Edit
alias zshrc="nano ~/.bashrc && source ~/.bashrc" 
alias fstab="sudo nano /etc/fstab"
alias crypttab="sudo nano /etc/crypttab"
alias hosts="sudo nano /etc/hosts"
alias grub="sudo nano /etc/default/grub"


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

function to_iso () {
	if [[ $# == 0 || $1 == "--help" || $1 == "-h" ]]; then
    echo -e "Converts raw, bin, cue, ccd, img, mdf, nrg cd/dvd image files to ISO image file.\nUsage: to_iso file1 file2..."
    fi
    
    for i in $*; do
    	if [[ ! -f "$i" ]]; then
          	echo "'$i' is not a valid file; jumping it"
        else
        	echo -n "converting $i..."
          	OUT=`echo $i | cut -d '.' -f 1`
          	case $i in
            		  *.raw ) bchunk -v $i $OUT.iso;; #raw=bin #*.cue #*.bin
          		*.bin|*.cue ) bin2iso $i $OUT.iso;;
          		*.ccd|*.img ) ccd2iso $i $OUT.iso;; #Clone CD images
                	  *.mdf ) mdf2iso $i $OUT.iso;; #Alcohol images
                	  *.nrg ) nrg2iso $i $OUT.iso;; #nero images
                    	  * ) echo "to_iso don't know de extension of '$i'";;
          	esac
        	if [[ $? != 0 ]]; then
        		echo -e "${R}ERROR!${W}"
        	else
        		echo -e "${G}done!${W}"
        	fi
        fi
    done
}

function up() {
	local d=""
    limit=$1
    for ((i=1 ; i <= limit ; i++)); do
    	d=$d/..
    done
    d=$(echo $d | sed 's/^\///')
    if [[ -z "$d" ]]; then
		d=..
    fi
    cd $d
}

# -----------------------------------------------------------------
# Bindings
# -----------------------------------------------------------------
bindkey "^[[1;5C" forward-word
bindkey "^[[1;5D" backward-word