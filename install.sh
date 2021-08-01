#!/bin/sh
echo creating directories ...
mkdir -vp ~/.config/clumsier/src
mkdir -vp ~/.config/clumsier/prj
mkdir -vp ~/.config/clumsier/fbkotd
if [ -L ~/clumsier_prj ] ; then
    echo Removing existing link to prj directory ... 
    rm -v ~/clumsier_prj
fi
echo Linking prj directory to home ...
ln -sv ~/.config/clumsier/prj ~/clumsier_prj
echo copying files ...
mv -fv clumsier clumsy.cfg  ~/.config/clumsier
cp -fv *.bas *.sh ~/.config/clumsier/src
cp -fv prj/* ~/.config/clumsier/prj
cp -fv fbkotd/* ~/.config/clumsier/fbkotd
echo Creating launcher script ...
CDIR="~/.config/clumsier"
touch clumsier.txt
echo "#!/bin/sh" > clumsier.txt
echo 'CLDIR=$(pwd)' >> clumsier.txt
echo "cd $CDIR" >> clumsier.txt
echo "./clumsier $1 $2 $3 $4 $5 $6 $7 $8 $9" >> clumsier.txt
echo 'cd $CLDIR'  >> clumsier.txt
echo switching to root and moving script to /usr/local/bin ...
sudo rm -fv /usr/local/bin/clumsier
sudo mv -v ./clumsier.txt /usr/local/bin/clumsier
sudo chmod -v +x /usr/local/bin/clumsier
sudo mv -f fbeauty /usr/local/bin/
sudo chmod -v +x /usr/local/bin/fbeauty

