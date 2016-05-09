#!/usr/bin/perl --

use 5.010;        # restrict to running with v5.10 or newer
use warnings;     # print warnings
use strict;       # 

print( "Hello, World!\n" );

say "Perl Version == $]";
say "Perl VString == $^V";

# 'my' to limit scope (strict), array var 'lines'; backticks for external command
my @lines = `perldoc -u File::Basename | tail`;

say ""; say "## Line Content: ##"; say "";
foreach (@lines)
{
  s/\w<([^>]+)>/\U$1/g;
  print;
}
say ""; say "## Finished ##";

exit 0;
