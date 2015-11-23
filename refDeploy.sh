#!/bin/bash --

########################################
# DESCRIPTION:
#   A script to quickly provide the desired environment setup from an archive. This saves time
#   in preparing new machines to have the anticipated environment. Key operation: making links
#   to files from ref* dirs to the appropriate system location (as specified here).
# ASSUMPTIONS:
#   This script will only look to sync files within ref* directories one level up.
#   Adding and removing files to be managed by the archive is a manual process.
#   Specifying locations to link with is a manual process (see LUT below).
#   System locations are typical of ubuntu linux installs.
#   Recommend: use source control in all ref* dirs to help prevent catastrophies. :-)
# WARNING:
#   Due to the intended nature of this script, existing files/links will be overwritten.
# INPUT:
#   clean -- remove any existing files/links corresponding to files currently in the archive
# OUTPUT:
#   Some verbose info on stdout as to what actions the script has done
# RETURNS:
#   Success or failure.
########################################

###################
# FOR DEBUG ONLY
# Find dirs managed by the archive
#archiveDirs=`find .. -maxdepth 1 -type d | grep [a-z].* | sed s#^.*/##`
#echo $archiveDirs
###################

SAVEIFS=$IFS                # backup IFS for later restore
IFS=$(echo -en "\n\b")      # set to newline for find command

# archive LUT, requires bash 4.0+ associative arrays
# whole array: ${!archiveLut[@]}
# "key": ${key}					# as part of for loop
# "value": ${archiveLut[${key}]}		# as part of for loop
declare -A archiveLut
archiveLut=( ["refBin"]="${HOME}/bin" )
archiveLut+=(
            ["refSrc"]="${HOME}/src"
            ["refEnv"]="${HOME}"
            ["refDocs"]="${HOME}/Documents"
            ["refImages"]="${HOME}/Pictures"
            ["refReadme"]="${HOME}"
            ["refWallpapers"]="${HOME}/Pictures/wallpapers"
            )
# Add more entries at the end of the list
#           ["refCkt"]="${HOME}/Downloads/ckt"
# But be sure 'locate -n 1 ref*' returns what you would expect.

# CLEAN option (clean out links, then exit)
if [[ $1 == "clean" ]] ; then
    returnDir=`pwd`         # save so we can return before exit
    # loop and remove links
    for key in ${!archiveLut[@]}; do
        target=`locate -n 1 ${key}`
        cd $target                  # to generate file listing in the following loop
        linkList=`ls -A | grep -v -e "\.git*" -e ".*\.swp" -e "hiddenFilesHere" -e "tnilesProfile*" -e "README*"`
        cd ${archiveLut[${key}]}    # critical! go to the usual dest dir
        pwd
        for fh in $linkList; do
            #if [[ "directory" == `file "${fh}" | awk '{print $2}'` ]] ; then
                #echo "dir detected: `pwd` ${fh}"
            #else
                #echo "rm "${fh}""
                rm "${fh}"
            #fi
        done
        cd $returnDir
    done
    cd $returnDir           # make sure we come back to where we started
    exit 0
fi
# remove all symlinks in a dir (caution: ls first!):
# find . -maxdepth 1 -lname '*' -exec rm {} \;
 
# First, create system dirs
for key in ${!archiveLut[@]}; do
    echo -e "key: ${key}\tvalue: ${archiveLut[${key}]}"
    if [[ ! -e "${archiveLut[${key}]}" ]] ; then
        mkdir -pv ${archiveLut[${key}]}
    fi
done

archiveNum=${#archiveLut[@]}
echo "Paired entries in table: $archiveNum"

returnDir=`pwd`         # save so we can return before exit

# Second, create links for all files not yet on the system
for key in ${!archiveLut[@]}; do
    target=`locate -n 1 ${key}`
    cd $target                  # to generate file listing in the following loop
    for fh in `ls -A | grep -v  -e "\.git*" -e ".*\.swp" -e "hiddenFilesHere" -e "tnilesProfile*" -e "README*"`; do
        # -n required so dirs don't link recursively (i.e. on multiple invocations of this
        # script)!
        ln -s -f -n -v $target/"${fh}" ${archiveLut[${key}]}/"${fh}"
    done
    cd $returnDir
done

cd $returnDir           # make sure we come back to where we started
IFS=$SAVEIFS            # restore IFS
exit 0
