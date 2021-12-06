#!perl
# 2021-12-06 gbk

package gbk::advent2021::day6b;
use common::sense;
use Data::Dumper;

my($file,$days) = @ARGV;
die 'need $file' if !defined $file;
die 'need $days' if !defined $days;

my @lines;
{ local *FILE; open FILE, '<'.$file; @lines = <FILE>; close FILE }

# parse the input
#my @Lines;

my $line = shift @lines;
$line =~ s[\n][];

my @Fish = split /,/,$line;

# define buckets for counts of fish of each countdown value
my @fish = (0,0,0,0,0,0,0,0,0);
# initialize the buckets from our input data
foreach my $fish (@Fish) {
	$fish[$fish]++;
}

my $day = 0;

while(++$day <= $days) {
	my $zfish = $fish[0]; # fish with a zero timer get added to [6], but also assigned to [8] as "new" fish
	$fish[0] = $fish[1];
	$fish[1] = $fish[2];
	$fish[2] = $fish[3];
	$fish[3] = $fish[4];
	$fish[4] = $fish[5];
	$fish[5] = $fish[6];
	$fish[6] = $fish[7];
	$fish[7] = $fish[8];
	$fish[8] = $zfish;
	$fish[6] += $zfish;
	printf qq[[%s] %s\n], $day, join(',',@fish);
}

printf qq[%i fish in total\n], $fish[0]+$fish[1]+$fish[2]+$fish[3]+$fish[4]+$fish[5]+$fish[6]+$fish[7]+$fish[8]; 

