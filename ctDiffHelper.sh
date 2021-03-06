#!/usr/bin/bash --

# Helper script for using an external diff program with Clearcase
# Specifically: Windows clearcase, Dynamic Views
# Adapted from stackoverflow/snip2code
#
# Intended usage: from parent dir of file to diff, type: ./ctDiffHelper.sh file.cpp
# Used with alias: ctdiff file.cpp  (alias: ctdiff='~/bin/ctDiffHelper.sh')

my_ccview=`cleartool pwv -short`
echo "Set view: $my_ccview"
fileA=""
fileB=""
# NOTE: on windows/cygwin, may need to add symbolic link for 'kdiff3-qt'.
my_difftool="/usr/bin/kdiff3"

# check clearcase view
if [ "$my_ccview" == "** NONE **" ] ; then
  echo "Error: ClearCase view not set, aborted."
  exit -1
fi

if [ "$1" == "" ] ; then
  echo "Error: missing 1st file argument!"
  echo "       (Expects linux-style file path)"
  echo "Eg: `basename $0` foo.txt -> This will diff foo.txt with its previous version"
  echo "Eg: `basename $0` foo.txt baz.txt -> This will diff foo.txt and baz.txt"
  exit -1
fi

if [ "$2" == "" ] ; then
  # No 2nd file passed, so find previous version
  fileB="$1"
  fileA="$fileB@@`cleartool descr -pred -short $fileB`"
  fileA=`echo "$fileA" | sed 's^\\\\^/^g'`
else
  fileA="$1"
  fileB="$2"
fi

echo "File A: $fileA"
echo "File B: $fileB"

${my_difftool} ${fileA} ${fileB}
