#!/usr/bin/perl --

use 5.010;        # restrict to running with v5.10 or newer
use warnings;     # print warnings
use strict;       # 


my $ii;
my $buildOutput;


say "Perl Version == $]";
say "Perl VString == $^V";
say "" ;

my $longTest = 1;
if ( $longTest )
{
#{{{
  # Using q to avoid escapes
  $buildOutput = q{
A         UnitTest\CUnit\Sources\Framework
A         UnitTest\CUnit\Sources\Framework\CUError.c
A         UnitTest\CUnit\Sources\Framework\MyMem.c
[...truncated 6 lines...]
A         UnitTest\CUnit\Headers\Basic.h
A         UnitTest\CUnit\Headers\CUError.h
A         UnitTest\CUnit\Headers\CUnit.h
[...truncated 912 lines...]
A         embOS\priv\src\RTOSInit_RL78_1.c
A         embOS\priv\src\OS_Error.c
A         embOS\pub
[...truncated 639 lines...]

Total number of errors: 0
Total number of warnings: 0
[...truncated 77 lines...]

Total number of errors: 0
Total number of warnings: 0
[...truncated 76 lines...]

Total number of errors: 0
Total number of warnings: 0
[...truncated 80 lines...]

Total number of errors: 0
Total number of warnings: 0
[...truncated 76 lines...]

Total number of errors: 0
Total number of warnings: 0
[...truncated 20 lines...]
crc_100s_test.c 
CUError.c 
main.cpp 
[...truncated 18 lines...]

Total number of errors: 0
Total number of warnings: 0
[...truncated 10 lines...]

Total number of errors: 1
Total number of warnings: 1
[...truncated 79 lines...]
Linking
Error[Li005]: no definition for "Factory_Initialize" [referenced from C:\Program Files (x86)\Jenkins\jobs\myProjAB CI\workspace\myProjAB\trunk\myProjAB\myProjAB Dev Rev1\Obj\Factory_dbg.o] Error while running Linker
Warning[myABC]: no definition for "Foo_Bar" ... Warn while running Linker

Total number of errors: 1
Total number of warnings: 1
[...truncated 76 lines...]
Linking
Error[Li005]: no definition for "Factory_Initialize" [referenced from C:\Program Files (x86)\Jenkins\jobs\myProjAB CI\workspace\myProjAB\trunk\myProjAB\Debug\Obj\Factory_dbg.o]
Error while running Linker

Total number of errors: 1
Total number of warnings: 1
[...truncated 20 lines...]
crc_100s_test.c
CUError.c
main.cpp
[...truncated 18 lines...]

Total number of errors: 0
Total number of warnings: 0
[...truncated 1 lines...]
####################################################################################################
Failed builds:  myProjAB.ewp-myProjAB Dev Rev1  myProjAB.ewp-myProjAB Rev1  myProjAB.ewp-Debug  myProjAB.ewp-myProjAB Dev Rev1  myProjAB.ewp-Debug ####################################################################################################
[...truncated 8 lines...]
} ;
#}}}
}
else
{
#{{{
  # Using a Here Document (multiline string)
  #$buildOutput = << "  MY_HERE_DOC";
  #A         unittest/cunit/sources/framework
  #B         unittest/cunit/sources/framework/cuerror.c
  #MY_HERE_DOC

  # Using qq
##$buildOutput = qq{
##A         unittest/cunit/sources/framework
##B         test/cunit/sources/framework/cuerror.c
##} ;
  #say $buildOutput ;
#}}}
}


print "## Regex Prints ##\n" ;

if ( $longTest )
{
  #say ( $buildOutput =~ /^.*(?i)failed.*|^.*(?i)error.*/gms ); 
  #say ( $buildOutput =~ /^(?i)fail.*|^(?i)err.*|^(?i)warn.*/gms ); 
  #say ( $buildOutput =~ /^(?i)fail.*|^(?i)err.*|^(?i)warn.*/gm ); 

  my @lines = split /\n/ , $buildOutput ;
  foreach (@lines)
  {
    if ( /^(?)fail.*|^(?)err.*|^(?)warn.*/gi )
    {
      print "$_\n\n";
    }
  }

  #say ( $buildOutput =~ /^(?)fail.*|^(?)err.*|^(?)warn.*/gmi ); 
}
else
{
#{{{
  $ii = 1 ; say ""; say "############################";
  say "Match " . $ii++ . ":" ; say ($buildOutput =~ /^B.*/gms );
  say "Match " . $ii++ . ":" ; say ($buildOutput =~ /^B.*/gms );
  say "Match " . $ii++ . ":" ; say ($buildOutput =~ /^A.*[u]/gm );
  say "Match " . $ii++ . ":" ; say ($buildOutput =~ /^A.*[u]/gms );
  say "Match " . $ii++ . ":" ; say ($buildOutput =~ /^A.*[t]/gm );

  $ii = 1 ; say ""; say "############################";
  say "Match " . $ii++ . ":" ; say ($buildOutput =~ /unit.*/gms );
  say "Match " . $ii++ . ":" ; say ($buildOutput =~ /unit+/gms );
  say "Match " . $ii++ . ":" ; say ($buildOutput =~ /cunit\/sources/gms );
  say "Match " . $ii++ . ":" ; say ($buildOutput =~ /cunit\/sources/gs );

  $ii = 1 ; say ""; say "############################";
  say "Match " . $ii++ . ":" ; say ($buildOutput =~ /cunit\/sources/gs );
  say "Match " . $ii++ . ":" ; say ($buildOutput =~ /^[A-Z].*sources.*cuerror/gs );
  say "Match " . $ii++ . ":" ; say ($buildOutput =~ /^[A-Z].*sources.*cuerror/gms );
  say "Match " . $ii++ . ":" ; say ($buildOutput =~ /framework.*cuerror/gms );
#}}}
}



########
# EXIT #
########
say ""; say "## Finished ##";
exit 0;
