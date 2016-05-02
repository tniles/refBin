#!/usr/bin/perl --
##############################################################################################
# Example script of reading whitespace delimited variables from a config file.
#
# Input:  Expects to find a file "varCfg.txt" at the same level.
# Output: None, prints to standard out.
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

# Generic use vars
my $varName;
my $varVal;

# These should come from the input! :-)
my $numBytes;
my $numDogs;


###########
# program #
###########

# file with data only
if ( ! open CFG, "<", "varCfg.txt" )
{
  die "$0: Cannot open input file. $!"
}

# read lines from cfg file in
while (<CFG>)
{
  chomp ;

  # grab whitespace delimited words
  my ($varName, $varVal) = ( split /\s+/ , $_ );
  print "$varName = $varVal\n";

  # now assign expected parameters
  if ( $varName =~ /numFarms/ )
  {
    $numDogs = $varVal;
  }
  if ( $varName =~ /numBytes/ )
  {
    $numBytes = $varVal;
  }

}

say $numBytes ;
say $numDogs ;

say "All Done!" ;


###########
# cleanup #
###########
 
close CFG;
exit 0;
