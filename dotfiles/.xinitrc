# Adjust keyboard typematic delay and rate
xset r rate 270 30

# Start Xorg server at this DPI
xrandr --dpi 190

# Merge & load configuration from .Xresources
xrdb -merge ~/.Xresources

# Let QT and GTK autodetect retina screen and autoadjust
export QT_AUTO_SCREEN_SCALE_FACTOR=1
export GDK_SCALE=2
export GDK_DPI_SCALE=0.5

# Start xbindkeys
xbindkeys &

# Finally start i3wm
exec i3
# If you need to debug i3, uncomment this:
# exec i3 -V >> ~/.config/.i3/i3log 2>&1
