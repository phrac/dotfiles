xsetroot -name " " &
feh --bg-tile ~/.wallpapers/rooflifters.jpg &

#feh --bg-scale ~/.wallpapers/FreeBSD-love.png &
( sleep 3 && conky | dzen2 -xs 1 -x 900 -e '' -fg '#dcdccc' -bg '#2c2e2f' -ta r -fn 'Hack:size=8' -p ) &
#xmodmap $HOME/.Xmodmap &
#nvidia-settings -l
#compton &
#mopidy &
#~/bin/mpd_fifo.sh &
exec ~/dotfiles/dwm/dwm
#exec dbus-launch $HOME/Downloads/dwm-6.1/dwm
#exec dbus-launch awesome
#exec nvidia-settings
