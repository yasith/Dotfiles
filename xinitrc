# set the cursor to a left arrow, default is an X
xsetroot -cursor_name left_ptr

# update Xresources from ~/.Xresources
xrdb -merge ~/.Xresources

# start xmonad
xmonad

# apply changes from xmodmap config files
xmodmap ~/.Xmodmap

# remove the system beep, it's annoying
xset -b

