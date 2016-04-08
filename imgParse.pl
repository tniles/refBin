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
 
my $blockSizeInBytes = 32;
my $blockSize = $blockSizeInBytes * 2;    # for srec, x2 because each char is a nibble

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

# file with data only (use for debug)
if ( ! open DATA, ">", "dbgData.txt" )
{
  die "$0: Cannot open output file. $!"
}

# file with data commands (use as batch file)
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
  if ( /^(?!$inPrefix)/ )     # negative lookahead to forgo any metadata in the srec
  {
    #say "found the last line $.";
    next;
  }
  chomp;
  s/^$inPrefix//g;        # srec: remove prefix
  s/(...)$//g;            # srec: remove two char checksum and carriage return suffix
  $data .= $_;            # grab all image data
}

my $numBlocks = ceil((length $data) / $blockSize) ;
say "     There are " . (length $data) .
    " number of bytes and " . $numBlocks .
    " blocks to be transferred.";

my $fmtBlockSize = sprintf "%04X", $blockSizeInBytes;   # swap bytes for little endian format
    $fmtBlockSize =~ s/(..)(..)/$2$1/ ;
my $fmtNumBlocks = sprintf "%04X", $numBlocks;          # swap bytes for little endian format
    $fmtNumBlocks =~ s/(..)(..)/$2$1/ ;

my $outBlockNum = 0;
my $fmtBlockNum = 0;
for ( my $ijk = 0; $ijk < (length $data); $ijk += $blockSize )
{
  $outPayload = substr ( $data, $ijk, $blockSize );
  if ( length $outPayload < $blockSize )
  {
    # pad with zeroes
    $outPayload .= (0 x $blockSize);
    $outPayload = substr ( $outPayload, 0, $blockSize );
  }
  say DATA $outPayload;      # good for debugging correct block size, padding, etc.
  # swap bytes for little endian format, and make it 1-based
  $fmtBlockNum = sprintf "%04X", ($outBlockNum++ + 1);
  $fmtBlockNum =~ s/(..)(..)/$2$1/ ;
  say CMDS $outPrefix . $outCommand . $fmtBlockNum . $outPayload . $outSuffix;
}

say "All Done!";


###########
# cleanup #
###########
 
close CMDS;
exit 0;
