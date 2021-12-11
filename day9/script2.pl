#!perl
# I apologize for the utter atrocity that follows. At least the output is nice.
# 2021-12-10 gbk

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
		next if $p==9;  # 9 is never a low point
		my $c=0;
		$c++ if $ii && defined($row[$ii-1]) && $p < $row[$ii-1];
		$c++ if defined $row[$ii+1]  && $p < $row[$ii+1];
		$c++ if defined $prev[$ii]   && $p < $prev[$ii];
		# $c++ if defined $prev[$ii-1]   && $p < $prev[$ii-1];
		# $c++ if defined $prev[$ii+1]   && $p < $prev[$ii+1];
		$c++ if defined $next[$ii]   && $p < $next[$ii];
		# $c++ if defined $next[$ii-1]   && $p < $next[$ii-1];
		# $c++ if defined $next[$ii+1]   && $p < $next[$ii+1];
		# silly rabbit, diagonals don't count

		#next if !$c;

		#$basins{$i.';'.$ii} = { size => 0 };#, color => };#shift @colors};
		$low->{$i}->{$ii}=1;#$basins{$i.';'.$ii};
		
		warn qq[LOW POINT "$p" at $i;$ii\n];
	}
}

sub isLow {
	my($i,$ii) = @_;
	return 0 if $i < 0;
	return 0 if $ii < 0;
	return 1 if defined $low->{$i}->{$ii};
	return 0;

}

my %inBasin;

sub mapBasin {
	my($i,$ii, $basin) = @_;
	return if defined $inBasin{$i.';'.$ii};

	$inBasin{$i.';'.$ii} = $basin;

	mapBasin($i-1,$ii,$basin) if isLow($i-1,$ii);
	# mapBasin($i-1,$ii-1,$basin) if isLow($i-1,$ii-1);
	# mapBasin($i-1,$ii+1,$basin) if isLow($i-1,$ii+1);
	mapBasin($i+1,$ii,$basin) if isLow($i+1,$ii);
	# mapBasin($i+1,$ii-1,$basin) if isLow($i+1,$ii-1);
	# mapBasin($i+1,$ii+1,$basin) if isLow($i+1,$ii+1);
	mapBasin($i,$ii-1,$basin) if isLow($i,$ii-1);
	mapBasin($i,$ii+1,$basin) if isLow($i,$ii+1);
}



my $basinCount = 0;
for (my $i = 0; $i < scalar(@grid); $i++) {
	
	my @row = @{$grid[$i]};

	for (my $ii = 0; $ii < scalar(@row); $ii++) {
		next if !defined $low->{$i}->{$ii};
		next if defined $inBasin{$i.';'.$ii};
		$basinCount++;

		mapBasin($i,$ii,$basinCount);

		
		# if($low->{$i}->{$ii}->{size}) {
		# 	warn qq[$i;$ii already claimed];
		# }
		# elsif($ii && defined($low->{$i}->{$ii-1})) {
		# 	$low->{$i}->{$ii}=$low->{$i}->{$ii-1};
		
		# } elsif(defined($low->{$i}->{$ii+1})) {
		# 	$low->{$i}->{$ii+1}=$low->{$i}->{$ii};
		
		# } elsif($i &&defined($low->{$i-1}->{$ii})) {
		# 	$low->{$i}->{$ii}=$low->{$i-1}->{$ii};

		# } elsif(defined($low->{$i+1}->{$ii})) {
		# 	$low->{$i+1}->{$ii}=$low->{$i}->{$ii};
		# }


		
		# $low->{$i}->{$ii}->{size}++;
		# if(!$basins{$i.';'.$ii}->{size}) {
		# 	#unshift @colors, $basins{$i.';'.$ii}->{color};
		# 	delete $basins{$i.';'.$ii};
		# }
	}
}

#die Dumper \%inBasin;


my %basinCounts;
foreach my $l (keys %inBasin) {
	$basinCounts{$inBasin{$l}}++;
}
#die Dumper \%basinCounts;
foreach my $basin (sort {$basinCounts{$b} <=> $basinCounts{$a}} keys %basinCounts) {
	printf qq[%s: %s\n], $basin,$basinCounts{$basin};
}

#die $total;
# warn Dumper $low;
# warn Dumper \%basins;

my $c=0;
sub getColor {
	my($i)=@_;
	return $colors[$i % scalar(@colors)];
}

for (my $i = 0; $i < scalar(@grid); $i++) {
	
	my @row = @{$grid[$i]};
	for (my $ii = 0; $ii < scalar(@row); $ii++) {

		if(defined($low->{$i}->{$ii})) {

			printf qq{\e[1m%s%s\e[0m}, getColor($inBasin{$i.';'.$ii}),$row[$ii];

			#printf qq{%s%s\e[0m}, $low->{$i}->{$ii}->{color}, $row[$ii];
			#printf qq{\e[1m%s\e[0m}, $row[$ii];
		} else {
			printf qq{\e[1m\e[1;37m\e[44m%s\e[0m}, $row[$ii];

		}


	}
	print qq[\n];
}
