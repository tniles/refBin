#!/bin/bash --

################################################################################
# Tyler Niles
# 10/24/2016
################################################################################

while getopts "hc: " Option ; do
  case $Option in
    h )
        echo "Usage:  $0 [-h | -c \"comment\"]"
        echo " "
        echo "         \"comment\" is an optional parameter, and if provided"
        echo "         will serve as a check-out string (co -c \"string\") and"
        echo "         later as a default check-in string."
        echo " "
        echo "         NOTE: the double quotes are required."
        echo " "
        echo "         NOTE: if you do not provide a string, a comment per"
        echo "               file check-in will be requested of you."
        echo " "
        exit 0
        ;;
    c ) 
        # grab comment string for multiple check-in
        commentString="$OPTARG"
        ;;
    \: )
        # missing arg when getopts silent
        #echo "$Option"
        echo "Missing/Invalid ARG $OPTARG"
        exit 0
        ;;
    \? )
        # missing arg when getopts not silent
        #echo "$Option"
        echo "Missing/Invalid ARG $OPTARG"
        exit 0
        ;;
  esac
  # shift $(($OPTIND - 1))
done

echo "Checking out all files in current directory..."
echo " "

# comment provided?
if [ $# -gt 0 ] ; then

    cleartool co -unr -c "$commentString" *

else

    cleartool co -unr -nc *

fi


exit 0
