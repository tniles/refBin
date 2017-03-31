#!/bin/bash --

########################################
# DESCRIPTION:
#   A script to quickly provide the desired environment setup from an archive. This saves time
#   in preparing new machines to have the anticipated environment. Key operation: making links
#   to files from ref* dirs to the appropriate system location (specified below in the LUT).
# ASSUMPTIONS:
#   This script will only look to sync files within ref* directories found by 'locate'.
#   Adding and removing files to be managed/held by the archive is a manual process.
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

cleanFlag=0
testFlag=0
until [[ -z "$1" ]] ; do
#   echo -e "$1\n"
    case $1 in
        -c | --clean)
            cleanFlag=1
            echo -e "\n## ENTERING CLEAN MODE (links will be removed) ##\n"
            ;;
        -t | --test)
            testFlag=1
            echo -e "\n## ENTERING TEST MODE (no data written/removed) ##\n"
            ;;
        -h | --help | *)
            echo "$0 usage:"
            echo "refDeploy [-cth]"
            echo " -c,--clean: clean system, removes all known links to archives"
            echo " -t, --test: test mode, no data will be written or deleted"
            echo " -h, --help: display this help"
            exit 0;
            ;;
    esac
    shift
done


####################################################
############### BEGIN MAIN EXECUTION ###############
####################################################

#lBin=`which locate`
#lVer=`locate --version`

SAVEIFS=$IFS                # backup IFS for later restore
IFS=$(echo -en "\n\b")      # set to newline for find command


# archive LUT, requires bash 4.0+ associative arrays
# whole array: ${!archiveLut[@]}
# "key": ${key}					# as part of for loop
# "value": ${archiveLut[${key}]}		# as part of for loop
declare -A archiveLut
archiveLut=( ["refBin"]="${HOME}/bin" )
archiveLut+=(
            ["refEnv"]="${HOME}"
            ["refReadme"]="${HOME}"
            )
#           ["refSrc"]="${HOME}/src"
#           ["refDocs"]="${HOME}/Documents"
#           ["refImages"]="${HOME}/Pictures"
#           ["refWallpapers"]="${HOME}/Pictures/wallpapers"

# Add more entries at the end of the list
#           ["refCkt"]="${HOME}/Downloads/ckt"
# But be sure '$locateCmd ref*' returns what you would expect.

#locateCmd="locate --limit 1"
#echo $locateCmd
#exit 0;

# Note 2015-11-25: the reason this check is necessary is because it can be a nightmare if
# things start linking random files to random places. Locate is usually a pretty good utility
# from what I've seen. On encrypted partitions, however, there are some issues. For one, it is
# necessary to remove all 'ecrypt*' references from /etc/updatedb.conf and rerun updatedb.
# There is a significant performance hit for this script by virtue of the decryption which
# needs to take place for locate to operate on the ecryptfs. Using this check and making sure
# locate can truly find the reference directories helps ensure correct operation.

# Confirm paths match the user's expectations:
echo -e "\nThese are the reported paths; PLEASE CONFIRM BEFORE PROCEEDING:\n"
echo "Paired entries in table: ${#archiveLut[@]}"
for key in ${!archiveLut[@]}; do
# allow full table: 'if -z/unset $locateCmd ; then ... '
    echo -e "Contents of `locate --limit 1 ${key}`\twill be linked to: "${archiveLut[${key}]}""
done
echo -e "\nWARNING! Do not proceed unless all pairs of paths are complete and correct."
echo -e "  e.g. \"Contents of /home/user/setupFiles/refBin  will be linked to: /home/user/someDir\""
# user input: continue or exit
userIn=" "
echo -en "\nContinue? "
while [[ "yes" != "$userIn" && "no" != "$userIn" ]] ; do
    echo -e "Please enter 'yes' or 'no' : "
    read userIn
    sleep 0.1
done
if [[ "no" == "$userIn" ]] ; then
    IFS=$SAVEIFS            # restore IFS
    exit 0
fi

# CLEAN option (clean out links, then exit)
if [[ 1 -eq $cleanFlag ]] ; then
    returnDir=`pwd`         # save so we can return before exit
    # loop and remove links
    for key in ${!archiveLut[@]}; do
        target=`locate --limit 1 ${key}`
        cd "$target"                # to generate file listing in the following loop
        linkList=`ls -A | grep -v -e "\.git*" -e ".*\.swp" -e "hiddenFilesHere" -e "tnilesProfile*" -e "README*"`
        cd "${archiveLut[${key}]}"  # critical! go to the usual dest dir
        pwd
        for fh in $linkList; do
            if [[ 1 -eq $testFlag ]] ; then
                echo "rm "${fh}""
            else
                rm "${fh}"
            fi
        done
        cd $returnDir
    done
    cd $returnDir           # make sure we come back to where we started
    IFS=$SAVEIFS            # restore IFS
    exit 0
fi
# remove all symlinks in a dir (caution: ls first!):
# find . -maxdepth 1 -lname '*' -exec rm {} \;
 

################################
############ DEPLOY ############
################################

# First, create system dirs
for key in ${!archiveLut[@]}; do
    #echo -e "key: ${key}\tvalue: ${archiveLut[${key}]}"
    if [[ ! -e "${archiveLut[${key}]}" ]] ; then
        mkdir -pv "${archiveLut[${key}]}"
    fi
done

returnDir=`pwd`         # save so we can return before exit

# Second, create links for all files not yet on the system
for key in ${!archiveLut[@]}; do
    target=`locate --limit 1 ${key}`
    cd "$target"                  # to generate file listing in the following loop
    for fh in `ls -A | grep -v  -e "\.git*" -e ".*\.swp" -e "hiddenFilesHere" -e "tnilesProfile*" -e "README*"`; do
        if [[ 1 -eq $testFlag ]] ; then
            echo "ln -s -n -v "${target}"/"${fh}" "${archiveLut[${key}]}"/"${fh}""
        else
            # -n required so dirs don't link recursively (i.e. on multiple invocations of this
            # script)! Don't use -f for data safety; let the screen fill with errors, or run 
            # the 'clean' option of this script first. You may have data/files of the same
            # name which you don't want to have overwritten!
            ln -s -n -v "${target}"/"${fh}" "${archiveLut[${key}]}"/"${fh}"
        fi
    done
    cd $returnDir
done

# Clean up and exit
cd $returnDir           # make sure we come back to where we started
IFS=$SAVEIFS            # restore IFS
exit 0
