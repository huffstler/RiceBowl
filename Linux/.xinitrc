#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
 for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

#Auto merges Xresources, I think
[ -f ~/.Xresources ] && xrdb -merge ~/.Xresources

#apply arandr script for multimonitor
/home/patrick/.screenlayout/HomeLayout.sh

exec dbus-launch &

#Make sure that any scripts you want to run are executed before the next line!
#start i3
exec i3 &

#reads xmodmap and sets capslock to tab
xmodmap ~/.Xmodmap &

#set touchpad off during typing
syndaemon -i .75 -d -k &

#Start keybinds (sxhkd)
sxhkd -c $HOME/.config/sxhkd/sxhkdrc &

#set screen brightness to 50%
xbacklight -set 50 &

#Start Redshift
redshift &

#start compositing
compton &

#set background wallpaper
feh --bg-scale ~/media/pictures/walls/graph.png &

#start Yabar
yabar

#start mopidy server
#mopidy --config $HOME/.config/mopidy/mopidy.conf
