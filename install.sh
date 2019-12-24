#!/bin/bash
mkdir ~/.cbuild
cp ./* ~/.cbuild/
ln -s ~/.cbuild/cbuild.rb ~/.cbuild/bin/cbuild
echo "export CBPATH=~/.cbuild" >> .bashrc
echo "export PATH=$PATH:$CBPATH/bin" >> .bashrc
rm $CBPATH/install.sh
