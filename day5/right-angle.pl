#!perl
# 2021-12-05 gbk

package gbk::advent2021::day5a;
use common::sense;
use Data::Dumper;

my($file) = @ARGV;
die 'need $file' if !defined $file;

my @lines;
{ local *FILE; open FILE, '<'.$file; @lines = <FILE>; close FILE }

# parse the input
my @Lines;
my ($minX,$maxX,$minY,$maxY)=(9999,0,9999,0);

foreach my $line (@lines) {
	$line =~ s[\n][];
	$line =~ m[(\d+),(\d+)\s+->\s+(\d+),(\d+)];
	
	push @Lines, {
		x1 => $1,
		y1 => $2,
		x2 => $3,
		y2 => $4
	};
	$minX = $1 if $1 < $minX;
	$minX = $3 if $3 < $minX;
	$maxX = $1 if $1 > $maxX;
	$maxX = $3 if $3 > $maxX;
	$minY = $2 if $2 < $minY;
	$minY = $4 if $4 < $minY;
	$maxY = $2 if $2 > $maxY;
	$maxY = $4 if $4 > $maxY;
}

#die Dumper \@Lines;

#die Dumper [$minX,$maxX,$minY,$maxY];

my @grid;
foreach my $y ($minY..$maxY) {
	my @x;
	foreach my $x ($minX..$maxX) {
		push @x, '.';
	}
	push @grid, [@x];
}

#die Dumper \@grid;

foreach my $Line (@Lines) {

	next if $Line->{x1} != $Line->{x2} && $Line->{y1} != $Line->{y2};
	# printf qq[%i,%i -> %i,%i\n],
	# 	$Line->{x1},
	# 	$Line->{y1},
	# 	$Line->{x2},
	# 	$Line->{y2};

	if($Line->{x1} == $Line->{x2}) {

		my $fromY= (($Line->{y1} > $Line->{y2}) ? $Line->{y2} : $Line->{y1});
		my $toY = (($Line->{y1} > $Line->{y2}) ? $Line->{y1} : $Line->{y2});

		# printf qq[ *** fromY=%i. toY=%i (y1=%i, y2=%i)***\n], $fromY,$toY,
		# 	$Line->{y1},
		# 	$Line->{y2};
		foreach my $y ($fromY..$toY) {
			$grid[$y]->[$Line->{x1}]++;
			# printf qq[ ** y=%i and x=%i ** \n], $y, $Line->{x1};
		}
	} elsif($Line->{y1} == $Line->{y2}) {
		my $fromX = (($Line->{x1} > $Line->{x2}) ? $Line->{x2} : $Line->{x1}); 
		my $toX = (($Line->{x1} > $Line->{x2}) ? $Line->{x1} : $Line->{x2});


		# printf qq[ *** fromX=%i. toX=%i ***\n], $fromX,$toX;
		foreach my $x ($fromX..$toX) {
			$grid[$Line->{y1}]->[$x]++;
			# printf qq[ ** y=%i and x=%i ** \n], $Line->{y1}, $x;
		}
	} else {
		die printf qq[%i,%i -> %i,%i\n],
		$Line->{x1},
		$Line->{y1},
		$Line->{x2},
		$Line->{y2};
	}
}

my $total = 0;
foreach my $x (@grid) {
	printf qq[%s\n], join('', @$x);
	foreach my $X (@$x) {
		next if $X < 2;
		$total++;
	}
}

die $total;



1;

