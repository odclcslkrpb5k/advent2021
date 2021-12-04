#!perl
# 2021-12-04 gbk

package gbk::advent2021::day3a::card;
use experimental 'smartmatch';

sub new {
	shift @_ if $_[0] eq __PACKAGE__;
	my($id,@lines) = @_;
	my $self = {
		id => $id,
		grid => [],
		matched => [],
		h => [],
		v => [],
		won => 0
	};

	foreach my $line (@lines) {
		$line =~ s[^\s+|\s+$][]g;
		push @{$self->{grid}}, [map {int($_)} split( /\s+/, $line)];
	}
	return bless($self, __PACKAGE__);
}

sub checkMatch {
	shift @_ if $_[0] eq __PACKAGE__;
	my($self, $number) = @_;
	
	for (my $v = 0; $v < scalar(@{$self->{grid}}); $v++) {
		my $row = $self->{grid}->[$v];
		next if !($number ~~ $row);
		push @{$self->{matched}}, $number;

		for (my $h = 0; $h < scalar(@$row); $h++) {
			if($row->[$h] == $number) {
				$self->{h}->[$h]++;
				$self->{v}->[$v]++;
			}
		}
		return 1;
	}
	
	return 0;
}

sub checkWin {
	shift @_ if $_[0] eq __PACKAGE__;
	my($self) = @_;

	if(5 ~~ $self->{h} || 5 ~~ $self->{v}) {
		$self->{won} = 1;
		return 1;
	}
	return 0;
}


sub p {
	shift @_ if $_[0] eq __PACKAGE__;
	my($self) = @_;

	foreach my $row (@{$self->{grid}}) {
		foreach my $number (@$row) {
			if($number ~~ $self->{matched}) {
				printf qq{\e[1m%2i\e[0m }, $number; 
			} else {
				printf qq{%2i }, $number; 
			}
		}
		print qq[\n];
	}
}

sub score {
	shift @_ if $_[0] eq __PACKAGE__;
	my($self) = @_;

	my $total = 0;
	foreach my $row (@{$self->{grid}}) {
		foreach my $number (@$row) {
			next if $number ~~ $self->{matched};
			$total += $number;
		}
	}
	return $total * $self->{matched}->[-1];
}



package main;
use common::sense;
use Data::Dumper;

my($file) = @ARGV;
die 'need $file' if !defined $file;

my @lines;
{ local *FILE; open FILE, '<'.$file; @lines = <FILE>; close FILE }


my (@cards,@cl);
my $calls = shift @lines;
$calls =~ s[\n][];
my @calls = split /,/,$calls;
shift @lines;

while(scalar(@lines) || scalar(@cl)) {
	my $line = shift @lines;

	$line =~ s[\n][];
	if(!$line) {
		push @cards, gbk::advent2021::day3a::card->new(scalar(@cards),@cl);
		@cl = ();
		next;
	}
	push @cl, $line;
}

foreach my $call (@calls) {
	foreach my $card (@cards) {
		next if $card->{won};
		my $matched = $card->checkMatch(int $call);
		if($matched) {
			printf qq[card %i matches "%s"\n], $card->{id}, $call;
			if($card->checkWin) {
				printf qq[** card %i wins with a score of %i **\n], $card->{id}, $card->score;
				$card->p;
				#exit;
			}
		}
	}
}



1;
