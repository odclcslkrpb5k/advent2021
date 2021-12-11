#!perl
# 2021-12-11 gbk

package gbk::advent2021::day11a;
use common::sense;
use Data::Dumper;
use List::Util qw{sum};
use Time::HiRes qw{usleep};

my($file) = @ARGV;
die 'need $file' if !defined $file;

my @grid;
{ local *FILE; open FILE, '<'.$file;
while(my $line = <FILE>) {
	$line =~ s[\n][];
	push @grid, [split //, $line];
}
close FILE;
}

sub increase {
	my($i,$ii) = @_;

	return if !defined($grid[$i]) || !defined($grid[$ii]);
	$grid[$i]->[$ii]++;

	if($grid[$i]->[$ii] == 10) {
		flash($i,$ii);
	}
}

my $fc = 0;
sub flash {
	my ($i,$ii) = @_;
	$fc++;

	increase($i-1,$ii-1) if $i && $ii;  # top-left
	increase($i-1,$ii) if $i;		    #top
	increase($i-1,$ii+1) if $i && scalar(@{$grid[$i-1]});  # top-right
	increase($i,$ii+1) if $ii < scalar(@{$grid[$i]}); # right
	increase($i+1,$ii+1) if $i < scalar(@grid) && $ii < scalar(@{$grid[$i+1]});  # bottom-right
	increase($i+1,$ii) if $i < scalar(@grid);		    # bottom
	increase($i+1,$ii-1) if $i < scalar(@grid) && $ii;  # bottom-left
	increase($i,$ii-1) if $ii;  # left

}

my $c=0;
while(1) {
	$c++;
	# print qq{\033[2J};
	for (my $i = 0; $i < scalar(@grid); $i++) {
		for (my $ii = 0; $ii < scalar(@{$grid[$i]}); $ii++) {
			increase($i,$ii);
		}
	}

	my $nf=0;

	for (my $i = 0; $i < scalar(@grid); $i++) {
		for (my $ii = 0; $ii < scalar(@{$grid[$i]}); $ii++) {

			if($grid[$i]->[$ii] > 9) {
				$grid[$i]->[$ii] = 0;
				printf qq{\e[1m0\e[0m};
			} else {
				$nf++;
				printf qq[%s], $grid[$i]->[$ii];
			}
		}
		print qq[\n];
	}
	if(!$nf) {
		die $c;
	}
	#usleep 1000*100;
	#sleep 2;
	print qq[\n\n];
	#last if $c == 100;
}

die $fc;
