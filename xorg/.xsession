export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export SSDIR=$HOME/ss/

# stop core dumps
ulimit -Sc 0

# kill any redshifts lingering
pkill redshift

xsetroot -name " " &
feh --bg-tile ~/.wallpapers/nord-pape.jpg &
#xmodmap $HOME/.Xmodmap &

# activate scroll wheel button
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation" 1
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Axes" 6 7 4 5
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Button" 2
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Timeout" 50
xinput set-prop "/dev/wsmouse" "WS Pointer Wheel Emulation Inertia" 3

# increase pointer speed
xinput set-prop "/dev/wsmouse" "Device Accel Constant Deceleration" 0.4

# deactivate touchpad
doas wsconsctl mouse0.tp.disable=1

#enable dpms features (power saving)
xset +dpms
xset s off
xset b off

# enable xlock screensaver
xidle -timeout 180 -program "/usr/X11R6/bin/xlock -description -mode blank -lockdelay 20 -dpmsoff 3" &

# urxvt daemon
urxvtd &

# dstat status bar
~/dotfiles/scripts/bin/dstat/dstat iwm0 &

# start the compositor
#compton -b

# auto adjust color temp
redshift -l 40.547974:-96.576218 &

# fire up the ol' dwm
exec ~/dotfiles/dwm/dwm
