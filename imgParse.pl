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
#     Package into predetermined command format (see OUTPUT FORM, below)
#     Write line to out file
#
#############################################################################################

###########
# modules #
###########

use 5.010;
use warnings;
use strict;

use POSIX qw(ceil floor);

# See perldoc.perlport for more on cross-platform line ending handling.
#$/ = "\r\n";        # chomp: account for windows eol


###########
# vars    #
###########
 
my $blockSize = 32;

my $inPrefix = "S31";

# OUTPUT FORM: $outPrefix . $outCommand . ($outBlockNum . $outPayload) . $outSuffix
my $outPrefix   = "CMD = ";
my $outSuffix   = " ==";
my $outCommand  = "0x1001 ";
my $outPayload;

my $data;

###########
# program #
###########

if ( @ARGV < 1 )
{
  die "Must supply input image file; exiting $!"
}

if ( ! open CMDS, ">", "dbgDownload.txt" )
{
  die "$0: Cannot open output file. $!"
}

#print ("Program:\t$0\nInput:\t\t@ARGV\n\n");

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
  next if $. == 1;        # srec: skip first line (header of srec)
  chomp;
  s/^$inPrefix//g;        # srec: remove prefix
  s/(...)$//g;            # srec: remove two char checksum and carriage return suffix
  $data .= $_;            # grab all image data
}

say "     There are " . (length $data) .
    " number of bytes and " . ceil((length $data) / $blockSize) .
    " blocks to be transferred.";

my $outBlockNum = 0;
my $fmtBlockNum;
for ( my $ijk = 0; $ijk < (length $data); $ijk += $blockSize )
{
  $outPayload = substr ( $data, $ijk, $blockSize );
  if ( length $outPayload < 32 )
  {
    # pad with zeroes
    $outPayload .= (0 x 32);
    $outPayload = substr ( $outPayload, 0, $blockSize );
  }
  #say CMDS $outPayload;      # good for debugging correct block size, padding, etc.
  $fmtBlockNum = sprintf "%04X", $outBlockNum++;    # swap bytes for little endian format
  $fmtBlockNum =~ s/(..)(..)/$2$1/ ;
  say CMDS $outPrefix . $outCommand . $fmtBlockNum . $outPayload . $outSuffix;
}

say "All Done!";


###########
# cleanup #
###########
 
close CMDS;
exit 0;
