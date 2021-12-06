#!perl
# 2021-12-06 gbk

package gbk::advent2021::day6a;
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

my @fish = split /,/,$line;

my $day = 0;

while(++$day <= $days) {
	printf qq[%s\n],$day;
	my @new;
	foreach my $fish (@fish) {
		if($fish==0) {
			$fish = 6;
			# Today's fish is "Trout A La Creme". Enjoy your meal!
			push @new, 8;
			next;
		}
		$fish--;

	}
	push @fish,@new;
	# printf qq[%s\n], join(',',@fish);
}

printf qq[\n%i fish\n], scalar(@fish);

