#!/usr/bin/perl

use warnings;
use strict;
use Switch;

my @board = (
	[0,0,1,1,1,1,1,0],
	[1,1,1,1,1,1,1,1],
	[1,1,1,1,1,1,1,1],
	[0,1,1,1,1,1,0,0],
);

place_piece("p c2", @board);
place_piece("p d4", @board);
place_piece("p d1", @board);
place_piece("n d2", @board);
place_piece("n d3", @board);

process_move("m c2 c3", @board);
#move_piece("m d3 e3", @board);

board_display(@board);

#push_piece(2, 2, "s", @board);
#push_piece(3, 2, "e", @board);

push_command("p c3 e");

board_display(@board);

sub push_command {
    my ($str, @board) = @_;
    my $dir = substr($str, 5, 1);
    my $r = substr($str, 3, 1) - 1;
	my $c = ord(substr($str, 2, 1)) - 97;
    print "$dir, $r, $c";
    push_piece($r, $c, $dir, @board);
}

sub push_piece {
	my ($r, $c, $dir, @board) = @_;

	switch ($dir) {
		case "n"	{$r--}
		case "e"	{$c++}
		case "s"	{$r++}
		case "w"	{$c--};
	}

	# check bounds
	if ($c < 0 || $c > 7 || $r < 0 || $r > 3) {
		print "Went off board! Possible win\n";
		return 0;
	}
	if ($board[$r][$c] eq "1") {
		switch ($dir) {
			case "n"	{move_piece($r++, $c, $r, $c, @board)}
			case "e"	{move_piece($r, $c--, $r, $c, @board)}
			case "s"	{move_piece($r--, $c, $r, $c, @board)}
			case "w"	{move_piece($r, $c++, $r, $c, @board)}
		}
		return 1;
	} else {
		my $val = push_piece($r, $c, $dir, @board);
		print "val: $val\n";
		if ($val == 1) {
			switch ($dir) {
				case "n"	{move_piece($r++, $c, $r, $c, @board)}
				case "e"	{move_piece($r, $c--, $r, $c, @board)}
				case "s"	{move_piece($r--, $c, $r, $c, @board)}
				case "w"	{move_piece($r, $c++, $r, $c, @board)}
			}
			return 1;
		} else {
			return 0;
		}
	}
}

sub process_move {
	my ($move, @board) = @_;
	my $r1 = substr($move, 3, 1) - 1;
	my $c1 = ord(substr($move, 2, 1)) - 97;
	my $r2 = substr($move, 6, 1) - 1;
	my $c2 = ord(substr($move, 5, 1)) - 97;
	move_piece($r1, $c1, $r2, $c2, @board);
}

sub move_piece {
	my ($r1, $c1, $r2, $c2, @board) = @_;
	my $cell = $board[$r2][$c2];
	$board[$r2][$c2] = $board[$r1][$c1];
	$board[$r1][$c1] = $cell;
}


sub place_piece {
	my ($place, @board) = @_;
	my $r = substr($place, 3, 1) - 1;
	my $c = ord(substr($place, 2, 1)) - 97;
	my $piece = substr($place, 0, 1);

	if ($board[$r][$c] != 0) {
		$board[$r][$c] = $piece;
	} else {
		print "Could not place $place\n";
	}
}

sub board_display {
	@board = @_;
	for (my $r = 0; $r < 4; $r++) {
		print $r+1, " ";
		for (my $c = 0; $c < 8; $c++) {
			if ($c == 4) {
				print "|";
			}
			switch($board[$r][$c]) {
				case "0"	{print "#"}
				case "1"	{print "."}
				case "p"	{print "p"}
				case "n"	{print "n"}
			}
		}
		print "\n";
	}
	print "  abcd efgh\n";
}
