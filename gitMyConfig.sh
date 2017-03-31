#!/bin/sh
#
# A script to setup my gitconfig
#

# global
git config --global user.name "Tyler Niles"
# read line: grab email from user input
#git config --global user.email " "
# git2.0 specification (for cygwin warnings)
git config --global push.default simple

# core

# diff
# NOTE: on cygwin, you may have something like kdiff3-qt installed, and then git won't be able
# to find it since it is expecting 'kdiff3'. My workaround is to add a symbolic link next to
# the kdiff3-qt, e.g. ln -s kdiff3-qt kdiff3. 
git config --global diff.tool kdiff3
