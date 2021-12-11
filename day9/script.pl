#!perl
# 2021-12-09 gbk

package gbk::advent2021::day9a;
use common::sense;
use Data::Dumper;
use List::Util qw{sum};

my($file) = @ARGV;
die 'need $file' if !defined $file;

my @grid;
{ local *FILE; open FILE, '<'.$file;
while(my $line = <FILE>) {
	$line =~ s[\n][];
	my @d = split //, $line;
	push @grid, \@d;
}
close FILE }

my $total = 0;

for (my $i = 0; $i < scalar(@grid); $i++) {
	
	my @row = @{$grid[$i]};
	my @prev = @{(defined($grid[$i-1])) ? $grid[$i-1] : []};
	my @next = @{(defined($grid[$i+1])) ? $grid[$i+1] : []};

	for (my $ii = 0; $ii < scalar(@row); $ii++) {
		
		my $p = $row[$ii];
		#warn qq["$p" at $i;$ii\n];
		if(
			(!$ii || !defined $row[$ii-1]  || $p < $row[$ii-1]) &&
			(        !defined $row[$ii+1]  || $p < $row[$ii+1]) &&
			(        !defined $prev[$ii]   || $p < $prev[$ii]) &&
			(        !defined $next[$ii]   || $p < $next[$ii])) {
			warn qq[LOW POINT "$p" at $i;$ii\n];
			$total += ($p+1);
		}

	}


}
die $total;