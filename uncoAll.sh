#!/bin/bash --

################################################################################
# Tyler Niles
# 10/4/2012
################################################################################

while getopts "hc: " Option ; do
  case $Option in
#   h )
#       echo "Usage:  $0 [-h | -c \"comment\"]"
#       echo " "
#       echo "         \"comment\" is an optional parameter, and if provided"
#       echo "         will serve as a checkin string (ci -c \"string\")."
#       echo "         Note: the double quotes are required."
#       echo " "
#       echo "         NOTE: if you do not provide a string, a comment per"
#       echo "               file check-in will be requested of you."
#       echo " "
#       exit 0
#       ;;
#   c ) 
#       # grab comment string for multiple check-in
#       commentString="$OPTARG"
#       ;;
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

# setup a temp file
fileName="tempABCxyzThisIsATempFile.txt"

# get list of all co'd files
if [ `uname -o` != "Cygwin" ] ; then
    # linux clearcase
    cleartool lsco -avobs -cview -short | sort -k 5 > $fileName
else
    # windows clearcase
    cleartool lsco -avobs -me -cview -short | sed s^\\\\^/^g | sed s^.:^^ | sort -k 5 > $fileName
fi

echo "Files unco'd:"
# uncheckout one at a time, do not keep a backup copy
while read myLine ; do
    echo "$myLine"
    cleartool unco -rm $myLine
done < $fileName

rm -f $fileName

exit 0
