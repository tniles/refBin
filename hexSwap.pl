#!/usr/bin/perl --
#
# Script to print byte-swapped hex values
#

use 5.010;
use warnings;
use strict;

my $xData;
my @yData;

for ( my $ijk = 998; $ijk < 1001; $ijk++ )
{
  printf ( "\nDecimal %4d is hex " . (sprintf "0x%04X", $ijk) . "\n", $ijk );

  # with byte swap
  say "These numbers (bytes swapped) should match...";

  # do sprintf, match pattern and store to ($1)($2), now reverse them into ($2)($1). 
  # BindOp leaves $_ alone, match stuffs $_ & is then used as input for reverse, prints.
  say reverse ((sprintf "%04X", $ijk) =~ /(..)(..)/) ;        # from perlmonks' webpage

  @yData = reverse ((sprintf "%04X", $ijk) =~ /(..)(..)/) ;
  say @yData;                         # does NOT match if scalar ($yData), 
                                      # does match if list (@yData).

  $xData = sprintf "%04X", $ijk;
  $xData =~ s/(..)(..)/$2$1/ ;
  say $xData;                         # does match

  $_ = sprintf "%04X", $ijk;
  /(..)(..)/;
  $xData = $2 . $1 ;
  say $xData;                         # does match
}

exit 0;
