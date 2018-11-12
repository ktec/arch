# Adjust keyboard typematic delay and rate
xset r rate 250 60

# Start Xorg server at this DPI
# xrandr --setprovideroutputsource modesetting NVIDIA-0
# xrandr --auto
# xrandr --dpi 190
xrandr --auto

# Merge & load configuration from .Xresources
[[ -f ~/.Xresources ]] && xrdb -merge ~/.Xresources
[[ -f ~/.Xmodmap ]] && xmodmap ~/.Xmodmap

# https://bugs.archlinux.org/task/46374
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh

# Let QT and GTK autodetect retina screen and autoadjust
export QT_AUTO_SCREEN_SCALE_FACTOR=1
# Scale UI elements by a factor of 2
export GDK_SCALE=2
# Undo the scaling of text
export GDK_DPI_SCALE=0.5

# Start xbindkeys
xbindkeys &

autocutsel &

# Finally start i3wm
exec i3
# If you need to debug i3, uncomment this:
# exec i3 -V >> ~/.i3/i3log 2>&1
