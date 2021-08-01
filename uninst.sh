#!/bin/sh
echo "This will uninstall all of CLUMSIER, except for any programs you"
echo "may have written with it."
echo "You will find those files in the directory ~/clumsier_prj, so you"
echo "can move them somewhere else where another IDE will find them."
echo
rm -f ~/.config/clumsier/src/*
rmdir ~/.config/clumsier/src
rm -f ~/.config/clumsier/fbkotd/*
rmdir ~/.config/clumsier/fbkotd
rm -f ~/.config/clumsier/*
sudo rm /usr/local/bin/clumsier
sudo rm /usr/local/bin/fbeauty
