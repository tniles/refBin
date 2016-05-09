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

use Scalar::Util qw(looks_like_number) ;


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
  if ( defined $varName && defined $varVal )
  {
    print "$varName = $varVal\n";
  }
  else
  {
    die "$0: malformed cfg file... require whitespace delimited key-value pair" ;
  }

  # parm checking on input vals
  if ( ! looks_like_number($varVal) || ! ($varVal =~ /^-?\d+\z/) )
  {
    # oops... alpha{numeric} or non-integer
    die "$0: Require numeric integer variable... $!" ;
  }
  elsif ( 0 > $varVal )
  {
    # oops... want a positive number
    die "$0: Require non-zero integer variable... $!" ;
  }

  # now assign expected parameters
  if ( $varName =~ /numDogs/ )
  {
    $numDogs = $varVal;
  }
  if ( $varName =~ /numBytes/ )
  {
    $numBytes = $varVal;
  }

}

# verify we collected everything we expected
if ( ! defined $numBytes || ! defined $numDogs )
{
  # oops... forgot to define something in our cfg file
  die "$0: Require variables 'numBytes' and 'numDogs' to be read from file 'varCfg.txt'" ;
}

# output results
say "We have $numBytes bytes, and we have $numDogs dogs." ;


###########
# cleanup #
###########
 
say "All Done!" ;
close CFG;
exit 0;
