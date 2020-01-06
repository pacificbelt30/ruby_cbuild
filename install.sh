#!/bin/bash
mkdir ~/.cbuild
mkdir ~/.cbuild/bin
cp -r ./* ~/.cbuild/
ln -s ~/.cbuild/cbuild.rb ~/.cbuild/bin/sake
cp ~/.bashrc ~/.bashrc.bak
echo "export CBPATH=~/.cbuild" >> ~/.bashrc
echo "export PATH=\$PATH:\$CBPATH/bin" >> ~/.bashrc
echo "cat \$CBPATH/vimascii" >> ~/.bashrc
source ~/.bashrc
#rm $CBPATH/install.sh
