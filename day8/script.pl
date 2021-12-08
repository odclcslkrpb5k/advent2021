#!perl
# 2021-12-08 gbk

package gbk::advent2021::day8a;
use common::sense;
use Data::Dumper;
use List::Util qw{sum};

my($file) = @ARGV;
die 'need $file' if !defined $file;

my @lines;
{ local *FILE; open FILE, '<'.$file; @lines = <FILE>; close FILE }

my $glyphs = [undef,undef,1,7,4,undef,undef,8,undef,undef];
my %counts;

=pod

	a: 8 (via 7 interpolation)
	b: 6 (via frequency)
	c: 8 (via 1 extrapolation)
	d: 7 (via 4 extrapolation)
	e: 4 (via frequency)
	f: 9 (via frequency)
	g: 7 (because it's the only one left)


  0:      1:      2:      3:      4:
 aaaa    ....    aaaa    aaaa    ....
b    c  .    c  .    c  .    c  b    c
b    c  .    c  .    c  .    c  b    c
 ....    ....    dddd    dddd    dddd
e    f  .    f  e    .  .    f  .    f
e    f  .    f  e    .  .    f  .    f
 gggg    ....    gggg    gggg    ....

  5:      6:      7:      8:      9:
 aaaa    aaaa    aaaa    aaaa    aaaa
b    .  b    .  .    c  b    c  b    c
b    .  b    .  .    c  b    c  b    c
 dddd    dddd    ....    dddd    dddd
.    f  e    f  .    f  e    f  .    f
.    f  e    f  .    f  e    f  .    f
 gggg    gggg    ....    gggg    gggg


=cut

my %digits = (
	abcefg => 0,
	cf => 1,
	acdeg => 2,
	acdfg => 3,
	bcdf => 4,
	abdfg => 5,
	abdefg => 6,
	acf => 7,
	abcdefg => 8,
	abcdfg => 9
	);


my $total =0;
foreach my $line (@lines) {
	$line =~ s[\n][];

	my ($samples,$displayed) = split /\s+\|\s*/, $line;
	my @samples = split /\s+/, $samples;
	my @displayed = split /\s+/, $displayed;

	my %gs;

	foreach my $d (@displayed) {
		my $g = $glyphs->[length $d];
		$gs{$g} = $d;
	}


	# my %map;
	# foreach my $char ('a'..'g') {
	# 	$map{$char} = {
	# 		N=>0,
	# 		S=>0,
	# 		E=>0,
	# 		W=>0,
	# 		NW=>0,
	# 		SW=>0,
	# 		NE=>0,
	# 		SE=>0
	# 	};
	# }

	my %sigs;
	my %freq;
	my @ONE;
	my @FOUR;
	my @EIGHT;

	foreach my $sig (@samples) {

		my @s = split //, $sig;
		$freq{$_}++ foreach (@s);

		my $g = $glyphs->[length $sig];
		#warn $g;
		next if !defined $g;
		#next if(defined($gs{$g}));

		

		if($g == 1) { # "1"
			push @{$sigs{$_}}, "1" foreach (@s);
			@ONE = @s;
		
		} elsif($g == 7) {
			push @{$sigs{$_}}, "7" foreach (@s);

		} elsif($g == 4) {
			push @{$sigs{$_}}, "4" foreach (@s);
			@FOUR = @s;
		} elsif($g == 8) {
			@EIGHT = @s;
		}
	}

	#die Dumper \%freq;

	my %map;
	foreach my $sig (keys %freq) {
		if($freq{$sig} == 6) {
			$map{$sig} = 'b';
		} elsif($freq{$sig} == 4) {
			$map{$sig} = 'e';
		} elsif($freq{$sig} == 9) {
			$map{$sig} = 'f';
		}
	}

	foreach my $sig (keys %sigs) {
		my $g = $sigs{$sig};

		if(scalar(@$g)==1 & $g->[0] == '7') {
			$map{$sig} = 'a';
		}
	}


	foreach my $c (@ONE) {
		next if defined $map{$c};
		$map{$c} = 'c';
	}
	foreach my $c (@FOUR) {
		next if defined $map{$c};
		$map{$c} = 'd';
	}
	foreach my $c (@EIGHT) {
		next if defined $map{$c};
		$map{$c} = 'g';
	}



	#warn Dumper \%map;




	# foreach my $d (@displayed) {
	# 	my $g = $glyphs->[length $d];
	# 	$counts{$g}++;
	# }


	my $num = '';
	printf qq[%s -> ], $line;
	foreach my $dis (@displayed) {
		my @d = split //, $dis;
		printf qq["%s" -> ], join('',@d);
		printf qq["%s" -> ], join('',sort map {$map{$_}} @d);

		my $val = $digits{join('',sort map {$map{$_}} @d)};
		printf qq[{%s}], $val;
		$num .= $val;
	}
	$total += $num;
	print qq[\n];

}
die $total;
#warn Dumper \%counts;
#die $counts{1}+$counts{4}+$counts{7}+$counts{8};

