#!/bin/bash --

################################################################################
# Script to do a platform-wide substitution of any string.
# Assumes : clearcase and cleartool, but could easily be modified for other scm
# Author  : Tyler Niles
# Created : 9/23/2012
# Updated : 9/25/2012
################################################################################

verNum=1.0

# code directory (where all platforms reside)
#codeDir="/src/proj/code/"
codeDir=""

if [ $# -lt 3 ]
then
    echo ""
    echo -e "Version\t:\t$verNum"
    echo ""
    echo -e "Usage\t:"
    echo ""
    echo -e "\tUse this to find and replace in a platform-wide search."
    echo -e "\tThis script stops short of checking in the files, "
    echo -e "\tbecause that would be dangerous. Please do the"
    echo -e "\tappropriate testing and manual review of diffs"
    echo -e "\tbefore checking in the files."
    echo ""
    echo -e "\t$0 <platform> <stringToReplace> <stringToInsert>"
    echo ""
    echo -e "\t<platform>: defined as relative to $codeDir"
    echo -e "\t            Example: to replace in common, use 'common'"
    echo ""
    echo -e "\tFuture Enhancements:"
    echo ""
    echo -e "\t\t\t1) add switches for the arguments"
    echo ""
    echo -e "\t\t\t2) add context for platform vs subsystem searches"
    echo ""
    echo -e "\t\t\t3) add graphical diff review for affected files"
    exit 0
fi

# root directory to search from
topDir=""$codeDir"/"$1""

echo "$topDir"
exit 0

# strings (if necessary, escape special characters)
toReplace="$1"
replaceWith="$2"

# find files with string to be replaced
cd $topDir ; #pwd   # with respect to {topDir}
filesToCo=`grep --binary-files=without-match -r -s -l $toReplace */*.{c,cpp,lsv}`

# verify the file is a clearcase element (strip the @@* junk for the compare)
for fName in $filesToCo ; do
    # 'cleartool ls -vob_only -short -directory *\/*'
    tempName=`cleartool ls -vob_only -short -directory $fName | awk -F @ '{print $1}'`
    if [ "$fName" = "$tempName" ] ; then
        echo "*IS* a file element: $fName"
        # co
        cleartool checkout -unr -nc "$fName" && echo "co'd "$fName""
        # now substitute
        sed -i 's/'$toReplace'/'$replaceWith'/g' "$fName" && echo ""$fName" substitution done..."
#   else
#       echo "^NOT^ a file element: $fName"
    fi
done

# Show resulting (all) checkouts
echo "Files checked out in this view:"
echo ""
cleartool lsco -avobs -cview -short | sort -k 5 | /bin/grep -v personalSubsystems

# CAUTION: do not automatically check the files back in. You have some manual 
# code review and testing to do!

echo "DONE!"

exit 0

