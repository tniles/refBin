#!/usr/bin/perl --
##############################################################################################
# Draft Picker. 
# Reads in a roster with the below specified fields and generates two teams.
#
# Player Name,Skill Level,Availability
#
# Input:  Expects to find a CSV file "roster.txt" at the same level.
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
my $varNameFirst;
my $varNameLast;
my $varSkill;
my $person;
my $team1skill = 0;
my $team2skill = 0;

# hash to cache player roster
my %players;

# arrays for team 1 and team 2
my @team1;
my @team2;


###########
# program #
###########

# file with data only
if ( ! open CFG, "<", "roster.txt" )
{
  die "$0: Cannot open input file. $!"
}

# read lines from cfg file in
while (<CFG>)
{
  chomp ;

  # grab whitespace delimited words
  #my ($varName, $varSkill) = ( split /\s+/ , $_ );
  my ($varNameFirst, $varNameLast, $varSkill) = ( split /,/ , $_ );
  if ( defined $varNameFirst && defined $varNameLast && defined $varSkill )
  {
    #say "$varNameFirst $varNameLast = $varSkill\n";
  }
  else
  {
    die "$0: malformed cfg file... require whitespace delimited key-value pair" ;
  }

  # parm checking on input vals
  if ( ! looks_like_number($varSkill) || ! ($varSkill =~ /^-?\d+\z/) )
  {
    # oops... alpha{numeric} or non-integer
    die "$0: Require numeric integer variable... $!" ;
  }
  elsif ( 0 > $varSkill )
  {
    # oops... want a positive number
    die "$0: Require non-zero integer variable... $!" ;
  }

  # now assign input to hash
  $players{ $varNameFirst . ' ' . $varNameLast } = $varSkill;

}

# Time to Generate two teams!!
# iterate over hash
for $person (keys %players)
{
    # print (debug)
    #say "$person has skill level of $players{$person}";

    # decide which team needs more skill and assign player
    if ($team1skill > $team2skill)
    {
        push @team2, $person;
        $team2skill += $players{$person};
    }
    else
    {
        push @team1, $person;
        $team1skill += $players{$person};
    }
}

# calculate average skill and output the teams
$team1skill = $team1skill / scalar @team1;
$team2skill = $team2skill / scalar @team2;
say "TEAM 1 (avg. skill level = $team1skill):";
foreach(@team1) { say "$_"; }
say " ";
say "TEAM 2 (avg. skill level = $team2skill):";
foreach(@team2) { say "$_"; }


###########
# cleanup #
###########
 
close CFG;
say "\nAll Done!" ;
exit 0;
