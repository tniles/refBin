#!/bin/bash --

################################################################################
# Tyler Niles
# 10/4/2012
################################################################################

commentString=""

while getopts ":hcm:?" Option ; do
  case $Option in
    h )
        echo "Usage:  $0 [-h | -c \"comment\"]"
        echo " "
        echo "         \"comment\" is an optional parameter, and if provided"
        echo "         will serve as a checkin string (ci -c \"string\")."
        echo "         Note: the double quotes are required."
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
    m ) 
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

#echo $commentString

# setup a temp file
fileName="tempABCxyzThisIsATempFile.txt"

# get files
cleartool lsco -avobs -me -cview -short | sed s^\\\\^/^g | sed s^.:^^ | sort -k 5 > $fileName

# comment provided?
if [ $# -gt 0 ] ; then

    # parse
    sed -i 's/\n/ /g' $fileName
    echo "file dump:" ; cat $fileName ; echo "$commentString"
    #cleartool ci -c "$commentString"

else

    # check-in one at a time
    while read myLine ; do
        echo "$myLine"
        #cleartool ci $myLine
    done < $fileName

fi

rm -f $fileName

exit 0
