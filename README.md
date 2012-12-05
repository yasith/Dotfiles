Configurations
==============

These are configuration files for my Linux system. Should work with any Unix-like environment

All the files in this directory should be sym-linked to a . file in the home dir

eg.

```
ln -s dotfiles/vimrc .vimrc
```

Other Software to Install
=========================

Install yaourt for easier package management

Place this code in /etc/pacman.conf

```
# For yaourt
[archlinuxfr]
Server = http://repo.archlinux.fr/x86_64
```

Install ntpd to keep system clock in sync


Theme Details - For Gnome Shell
===============================

gnome-tweak-tool to manage the themes

Themes installed from AUR

- Zukitwo for Gnome Shell Theme
- Faenza icon theme
- Faience GTK+ and window theme
- Droid Sans 10pt, and 9pt fonts
