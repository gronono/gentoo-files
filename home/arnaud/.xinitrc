#!/bin/sh

userresources=$HOME/.Xresources
usermodmap=$HOME/.Xmodmap
userinitrcd=$HOME/.xinitrc.d/
sysresources=/etc/X11/xinit/Xresources
sysmodmap=/etc/X11/xinit/Xmodmap
sysinitrcd=/etc/X11/xinit/xinitrc.d/

# merge in defaults and keymaps
if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"

fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

# start some nice programs

if [ -n "`/etc/X11/chooser.sh`" ]; then
 command="`/etc/X11/chooser.sh`"
else
 failsafe="yes"
fi

if [ -d "$sysinitrcd" ] ; then
 for f in $sysinitrcd/?* ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi

if [ -d "$userinitrcd" ] ; then
 for f in $userinitrcd/?* ; do
  [ -x "$f" ] && . "$f"
 done
 unset f
fi
echo "dqd $failsafe"
if [ -n "$failsafe" ]; then
 twm &
 xclock -geometry 50x50-1+1 &
 xterm -geometry 80x50+494+51 &
 xterm -geometry 80x20+494-0 &
 exec xterm -geometry 80x66+0+0 -name login
else
 echo "-------------------------------------------------------------------" >>  $HOME/.xsession-errors.log
 exec $command >> $HOME/.xsession-errors.log
fi
