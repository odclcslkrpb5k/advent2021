#!perl
# 2021-12-07 gbk

package gbk::advent2021::day7a;
use common::sense;
use Data::Dumper;
use List::Util qw{sum};

my($file,$days) = @ARGV;
die 'need $file' if !defined $file;

my @lines;
{ local *FILE; open FILE, '<'.$file; @lines = <FILE>; close FILE }

$lines[0] =~ s[\n][];
my @crabs = split /,/,$lines[0];

my @pos;
foreach my $pos (@crabs) {
	$pos[$pos]++;
}

my @fuel;
my $offset;
my $min = 99999999999;
for (my $i = 0; $i < scalar(@pos); $i++) {
	#next if !defined $pos[$i];

	my $fuel = 0;
	for (my $e = 0; $e < scalar(@pos); $e++) {
		$fuel += (abs($i - $e) * $pos[$e]);
	}

	$fuel[$i] = $fuel;
	if($fuel < $min) {
		$min = $fuel;
		$offset = $i;
	}
}

die sprintf(qq[offset %i = fuel %i\n], $offset,$min);

# printf qq[%s\n], join(qq[\t], @fuel);
# for (my $i = 0; $i < scalar(@fuel); $i++) {
# 	printf qq[pos %i: %s\n], $i, $fuel[$i];
# }

