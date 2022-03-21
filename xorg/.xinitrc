export LANG=en_US.UTF-8
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8
export SSDIR=$HOME/ss/
export QT_SCALE_FACTOR=1.5

# kill any redshifts lingering
killall -KILL redshift

xsetroot -name "dwm" -solid "#2E3440" &
feh --bg-tile ~/.wallpapers/nord.jpg &
#xmodmap $HOME/.Xmodmap &

# increase pointer speed
xinput set-prop "/dev/wsmouse" "Device Accel Constant Deceleration" 0.4

#enable dpms features (power saving)
xset +dpms
xset s off
xset b off

# enable xlock screensaver
xidle -timeout 180 -program "/home/derek/dotfiles/slock/slock-1.4/slock" &

# urxvt daemon
#urxvtd &

# dstat status bar
#~/bin/dstat/dstat iwm0 &

# slstatus
~/dotfiles/slstatus/slstatus &

# start the compositor
#compton -b

# auto adjust color temp
redshift -l 40.54:-96.57 &

# fire up the ol' dwm
exec ~/dotfiles/dwm/dwm
