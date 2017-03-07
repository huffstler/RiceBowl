#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]]  && return

# Arch specific aliases #
alias rmorphans='sudo pacman -Rns $(pacman -Qtdq)'
alias showall='pacman -Q'
alias ccache='sudo pacman -Sc'
# End Arch specific aliases #

alias ls='ls --color=auto'
alias lh='ls -d .*'
alias la='ls -a'
alias u='cd ..'
alias v='vim'
alias t='tmux'
alias w='weechat'
alias xmerge='xrdb -merge ~/.Xresources'
alias off='sudo shutdown -h now'
alias rst='sudo shutdown -r now'
alias ssh='TERM=xterm ssh'
alias acp='git add * && git commit -a && git push'
alias temp='curl wttr.in/Newark'

#BASH PROMPT
PS1='[\w] >> ' 

#This disables the Ctrl+S freeze in shell
stty -ixon
