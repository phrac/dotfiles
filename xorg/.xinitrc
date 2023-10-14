export SSDIR="/home/derek/ss/"
xsetroot -name " " &
feh --bg-fill ~/.wallpapers/nord-pape.jpg &

#( sleep 3 && conky | dzen2 -xs 1 -x 900 -e '' -fg '#dcdccc' -bg '#2c2e2f' -ta r -fn 'Hack:size=8' -p ) &
#xmodmap $HOME/.Xmodmap &
#nvidia-settings -l
picom &
#mopidy &
#~/bin/mpd_fifo.sh &
dunst &
xrandr --output HDMI-1 --auto --right-of DP-3
xrandr --output DP-1 --auto --left-of DP-3
xbindkeys &
exec ~/dotfiles/dwm/dwm

#export DESKTOP_SESSION=plasma
#exec startplasma-x11
#exec dbus-launch $HOME/Downloads/dwm-6.1/dwm
#exec dbus-launch awesome
#exec nvidia-settings
