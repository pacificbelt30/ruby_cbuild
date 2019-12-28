#!/bin/bash
mkdir ~/.cbuild
mkdir ~/.cbuild/bin
cp ./* ~/.cbuild/
ln -s ~/.cbuild/cbuild.rb ~/.cbuild/bin/cbuild
cp ~/.bashrc ~/.bashrc.bak
echo "export CBPATH=~/.cbuild" >> ~/.bashrc
echo "export PATH=\$PATH:\$CBPATH/bin" >> ~/.bashrc
source .bashrc
rm $CBPATH/install.sh
