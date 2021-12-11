#!perl
# 2021-12-09 gbk

package gbk::advent2021::day9b;
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

my @colors = (
qq{\e[1;31m\e[47m},          # Red
qq{\e[1;32m\e[47m},        # Green
qq{\e[1;33m\e[47m},       # Yellow
qq{\e[1;34m\e[47m},         # Blue
qq{\e[1;35m\e[47m},       # Purple
qq{\e[1;36m\e[47m},         # Cyan
qq{\e[1;37m\e[47m}        # White
);


my $low = {};
my %basins;

for (my $i = 0; $i < scalar(@grid); $i++) {
	
	my @row = @{$grid[$i]};
	my @prev = @{(defined($grid[$i-1])) ? $grid[$i-1] : []};
	my @next = @{(defined($grid[$i+1])) ? $grid[$i+1] : []};

	for (my $ii = 0; $ii < scalar(@row); $ii++) {
		
		my $p = $row[$ii];
		

		my $c=0;
		$c++ if $ii && defined($row[$ii-1]) && $p < $row[$ii-1];
		$c++ if defined $row[$ii+1]  && $p < $row[$ii+1];
		$c++ if defined $prev[$ii]   && $p < $prev[$ii];
		$c++ if defined $next[$ii]   && $p < $next[$ii];
		next if !$c;

		$basins{$i.';'.$ii} = { size => 0, color => };#shift @colors};
		$low->{$i}->{$ii}=$basins{$i.';'.$ii};

		if($ii && defined($low->{$i}->{$ii-1})) {
			$low->{$i}->{$ii}=$low->{$i}->{$ii-1};
		
		} elsif(defined($low->{$i}->{$ii+1})) {
			$low->{$i}->{$ii}=$low->{$i}->{$ii+1};
		
		} elsif(defined($low->{$i-1}->{$ii})) {
			$low->{$i}->{$ii}=$low->{$i-1}->{$ii};

		} elsif(defined($low->{$i+1}->{$ii})) {
			$low->{$i}->{$ii}=$low->{$i+1}->{$ii};

		}
		$low->{$i}->{$ii}->{size}++;
		if(!$basins{$i.';'.$ii}->{size}) {
			unshift @colors, $basins{$i.';'.$ii}->{color};
			delete $basins{$i.';'.$ii};
		}


		warn qq[LOW POINT "$p" at $i;$ii\n];
			#$total += ($p+1);
		#}

	}


}
#die $total;
warn Dumper $low;
warn Dumper \%basins;

for (my $i = 0; $i < scalar(@grid); $i++) {
	
	my @row = @{$grid[$i]};
	for (my $ii = 0; $ii < scalar(@row); $ii++) {

		if(defined($low->{$i}->{$ii})) {
			#printf qq{%s%s\e[0m}, $low->{$i}->{$ii}->{color}, $row[$ii];
			printf qq{\e[1m%s\e[0m}, $row[$ii];
		} else {
			printf qq[%s], $row[$ii];
		}


	}
	print qq[\n];
}
