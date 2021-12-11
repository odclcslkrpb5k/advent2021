#!perl
# 2021-12-10 gbk

package gbk::advent2021::day10a;
use common::sense;
use Data::Dumper;
use List::Util qw{sum};

my($file) = @ARGV;
die 'need $file' if !defined $file;

my @lines;
{ local *FILE; open FILE, '<'.$file;
@lines = <FILE>;
close FILE;
}

my @openTokens = qw|( [ { <|;
my %closeTokens = ( '(' => ')',
	'[' => ']',
	'{' => '}',
	'<' => '>'
);
my $points = 0;

my %value = (
	')' => 3,
	']' => 57,
	'}' => 1197,
	'>' => 25137
);
my %value2 = (
	')' => 1,
	']' => 2,
	'}' => 3,
	'>' => 4
); 

my @missingScores;

my $c=0;
LINE:
foreach my $line (@lines) {
	# printf qq[%s], $line;
	$line =~ s[\n][];
	$c++;

	my @tokens = split //, $line;

	my @stack = ();

	foreach my $token (@tokens) {
		if($token ~~ @openTokens) {
			push @stack, $token;
			# printf(qq[[line %i] OPEN "%s"\n], $c, $token);
			next;
		}
		my $open = pop @stack;
		my $expected = $closeTokens{$open};
		if($token ne $expected) {
			#warn sprintf(qq[[line %i] syntax error: expected "%s" but got "%s"\n], $c, $expected,$token);
			$points += $value{$token};
			next LINE;
		}
		# printf(qq[[line %i] GOOD: got expected "%s"\n], $c, $expected);

	}
	next if !@stack;


	my @missing;

	my $missingScore = 0;
	foreach my $token (reverse @stack) {
		$missingScore = $missingScore * 5;
		$missingScore += $value2{$closeTokens{$token}};
		push @missing, $closeTokens{$token};
		# warn sprintf(qq[\tmissing: %s (%s) {%s}],$closeTokens{$token}, $value2{$closeTokens{$token}}, $missingScore);
	}

	warn sprintf(qq[%s - %i total points.\n], join('',@missing), $missingScore );

	push @missingScores, $missingScore;



}

warn $points;


my @ms = sort {$a <=> $b } @missingScores ;

die $ms[abs(scalar(@ms)/2)];


