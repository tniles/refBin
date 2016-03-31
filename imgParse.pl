#!/usr/bin/perl --
#############################################################################################
# Script to parse out a hexadecimal/binary file into transferrable chunks and reformatted to
# be packaged into a predetermined system command format.
#
# Input: binary image "new.bin" (passed as a command line argument)
# Output: Command batch file "dbgDownload.txt"
#
# Icky Details:
#     32-bit little endian command format
#     Break binary into block size chunks
#     Block by block, prepend:
#         System Command . Block Number . Data Chunk
#     Package into predetermined command format
#         {"Seq":1,"Src":255,"Dst":1,"Type":262,"Payload":"<<insertResultHere>>","Crc":0}
#     Write line to out file
#
#############################################################################################

###########
# modules #
###########

use 5.010;
use warnings;
#use strict;


###########
# vars    #
###########
 
my $blockSize = 32;
my $numBlocks = 4;

my $prefix = S31;
#my sysCmd = "0x1001"
#my blockNum = "0x0000"
#my dataChunk = ""


###########
# program #
###########

# Opting for the diamond operator, see below
#if ( ! open IMAGE, "<", "new.bin" )
#{
  #die "$0: Cannot open input file. $!"
#}
if ( @ARGV < 1 )
{
  die "Must supply input image file; exiting $!"
}

if ( ! open CMDS, ">", "dbgDownload.txt" )
{
  die "$0: Cannot open output file. $!"
}

print ("Program:\t$0\nInput:\t\t@ARGV\n\n");

# read lines from image file in
say "Processing File...";
#while (defined($line = <>))
#{
  #chomp($line);
  #say CMDS "Here's your line: $line";
#}
# Equivalently:
while (<>)
{
  next if $. == 1;        # skip first line (header of srec)
  chomp;
  s/^$prefix//g;          # remove srec prefix
  s/(...)$//g;            # remove two char checksum suffix
  say CMDS "$_";          # using default perl var
}

say "All Done!";


###########
# cleanup #
###########
 
#close IMAGE;
close CMDS;
exit 0
