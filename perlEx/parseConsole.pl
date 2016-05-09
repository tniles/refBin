#!/usr/bin/perl --
##############################################################################################
# Script to isolate the data portion of a specified console output format.
# Intended to pair with parseImg.pl
#
# Input: raw console output "consoleRaw.txt" (passed as a command line argument)
# Output: Data file "consoleData.txt"
#
##############################################################################################

###########
# modules #
###########

use 5.010 ;
use warnings ;
use strict ;


###########
#  vars   #
###########

my $numBytes = 128 ;                    # expected bytes of data per readout/line
my $blockSizeInBytes = 32;              # for diff'ing original image/dbg format

my $inPrefix = "RX:" ;                  # lines with data have this
my $inPrefixTwo = "0x06" ;              # lines that look like data but are not have this

my $header  = 'Payload":"0x' ;          # data is preceded by this string
my $trailer = '","' ;                   # data terminates with this string


###########
# program #
###########

if ( @ARGV < 1 )
{
  die "Must supply input image file; exiting $!"
}

# file with data only
if ( ! open DATA, ">", "consoleData.txt" )
{
  die "$0: Cannot open output file. $!"
}

# read lines from image file in
say "Processing File..." ;

my $myData ;
my $line = 0 ;
my $numBytesHex = $numBytes * 2 ;       # num chars in hex format
while (<>)
{
  $line++;
  if ( ! /.*$inPrefix.*/ )    # negative match to forgo any lines w/o data (w/o inPrefix)
  {
    next ;
  }
  if ( /.*$inPrefixTwo.*/ )   # positive match to forgo any lines w/o data (w/ inPrefixTwo)
  {
    next ;
  }
  chomp ;

  s/.*$header//g ;      # remove remaining data prefix
  s/$trailer.*//g ;     # remove remaining data suffix

  ( (length $_) < $numBytesHex ) ? next : ($myData .= $_) ;

}

my $outPayload = 0;
my $blockSize = $blockSizeInBytes * 2;    # for hex, x2 because each char is a nibble
for ( my $ijk = 0; $ijk < (length $myData); $ijk += $blockSize )
{
  $outPayload = substr ( $myData, $ijk, $blockSize );
  if ( length $outPayload < $blockSize )
  {
    # pad with zeroes
    $outPayload .= (0 x $blockSize);
    $outPayload = substr ( $outPayload, 0, $blockSize );
  }
  say DATA $outPayload ;        # good for debugging correct block size, padding, etc.
}

say "All Done!" ;


###########
# cleanup #
###########
 
close DATA;
exit 0;
