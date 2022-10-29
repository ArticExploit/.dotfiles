#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

## Set env variables
export PATH="$PATH:/usr/sbin:/sbin:/bin:/usr/bin:/etc:/usr/ucb:/usr/local/bin:/usr/local/local_dfs/bin:/usr/bin/X11:/usr/local/sas:/home/artic/.local/bin"
export MANPATH="/usr/share/man:/usr/local/man:/usr/local/local_dfs/man"
export PAGER=less
export VISUAL=subl
export EDITOR=nvim
export DISPLAY=:0

## The maximum number of lines in your history file
export HISTFILESIZE=50

## Shell customization
PS1='\[\033[38;2;108;113;196m\]\u\[\033[38;2;181;137;0m\]@\[\033[38;2;108;113;196m\]\h \[\033[38;2;133;153;0m\]| \[\033[38;2;38;139;210m\]\w \[\033[38;2;42;161;152m\]$(git branch 2>/dev/null | grep '"'"'^*'"'"' | colrm 1 2) \n\[\033[38;2;211;54;130m\]λ \[\e[0m\]'
force_color_prompt=yes

## Aliases
alias cl='clear && fastfetch'
alias clp='sudo pacman -Scc --noconfirm && yay -Scc --noconfirm'
alias del='sudo rm -r'
alias inst='sudo pacman -S --noconfirm'
alias insty='yay -S --noconfirm'
alias ka='killall'
alias ls='ls -AhN --color=auto --group-directories-first --quoting-style=literal'
alias rem='sudo pacman -Rns --noconfirm'
alias remy='yay -Rns --noconfirm'
alias sdn='sudo shutdown -h now'
alias server='ssh artic@192.168.5.190'
alias syup='sudo pacman -Syu --noconfirm && yay -Syu --noconfirm'
alias x='startx'
alias yta='youtube-dl -x --audio-format mp3 -f bestaudio/best'
alias ytv='youtube-dl -f bestvideo+bestaudio'
alias cat='bat -pP --theme="Solarized (dark)"'
alias delss='ssh artic@192.168.5.190 "rm -r /var/www/html/images/*"'
alias cp='cp -r'
alias tree='tree -C --dirsfirst --noreport'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias vynil='pactl load-module module-loopback'
alias vim='nvim'
alias mkdir='mkdir -p'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias clo='sudo pacman -Rns $(pacman -Qtdq)'
alias drp='linux-discord-rich-presence -c ~/.config/linux-discord-rich-presencerc & disown'

## Function to extract any sort of archive
extract () {
     if [ -f $1 ] ; then
         case $1 in
             *.tar.bz2)   tar xjf $1     ;;
             *.tar.gz)    tar xzf $1     ;;
             *.bz2)       bunzip2 $1     ;;
             *.rar)       rar x $1       ;;
             *.gz)        gunzip $1      ;;
             *.tar)       tar xf $1      ;;
             *.tbz2)      tar xjf $1     ;;
             *.tgz)       tar xzf $1     ;;
             *.zip)       unzip $1       ;;
             *.Z)         uncompress $1  ;;
             *.7z)        7z x $1    ;;
             *)           echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

## startup commands

# SSH-agent start
if [ -z "$SSH_AUTH_SOCK" ] ; then
eval `ssh-agent -s`
ssh-add ~/.ssh/artic
fi

#aestheticc
clear && fastfetch
