#!/usr/bin/perl
use strict;
use warnings;

use UI::Dialog;
use Term::ReadKey;
use Term::ANSIScreen qw(cls);
use File::Fetch;

my $EmpireCommand = "/sbbs/doors/empire/bin/empire -r -s empiredirectory.net:6665";
my $EmpireFeverCommand = "/sbbs/doors/empire/bin/empire -r -s blitz.wolfpackempire.com:4567";
my $BannerText = "logo.txt";
my $LESSCMD = "/usr/bin/less";
my $WhatIsFile = "whatisempire.txt";
my $EmpireLinks = "empirelinks.txt";
my $OtherGamesFile = "OtherGames.csv";
my $SanctFile = "http://empiredirectory.net/empusers.txt";
my $FeverFile = "http://blitz.wolfpackempire.com/empusers.txt";

###################################################
# No changes below here
###################################################


my $EMP_ver = "1.2.0";
my $url = 'http://empiredirectory.net/empusers.txt';
my $GameSubsLink = "https://empiredirectory.net/index.php/game-hosting";

$ENV{'LESSSECURE'} = '1';
my $ContactUs = "newempiregame\@empiredirectory.net";

my $clear_screen = cls();

if (-f "empusers.txt")
{
	unlink("empusers.txt");
}
system("wget https://empiredirectory.net/empusers.txt > /dev/null 2>\&1");

my $d = new UI::Dialog ( backtitle => "Wolfpack Empire v$EMP_ver", height => 20, width => 65, listheight => 5,
	order => [ 'ascii', 'cdialog', 'xdialog' ]);

my $windowtitle = "Welcome to Wolfpack Empire!";
my $enjoyedtitle = "We hope you enjoyed Wolfpack Empire!";
my $introtext =
"Wolfpack Empire is the classic multiuser game of global conquest. Compete against other players in real-time...";

$d->msgbox( title => $windowtitle, text => $introtext );

if (($d->state() eq "ESC") || ($d->state() eq "CANCEL"))
{
	exit 0;
}

my $menuselection = "";


sub MainMenu
{
	$menuselection = $d->menu( title => "Empire Menu", text => "Select one:",
                            list => [ '1', 'Play Empire',
                                      '2', 'List Sanctuaries',
                                      '3', 'What is Empire',
                                      '4', 'Play Fever',
                                      '5', 'Fever Sanct.',
                                      '6', 'Empire Links',
                                      '7', 'Games List',
                                      'q', 'Quit Empire' ] );
}

sub DisplayLogo
{
	# Display the logo file
	system("cat $BannerText");
}

sub ShowOtherGames
{
	print "Available Games:\n";
	if (-f "$OtherGamesFile")
	{
		unlink("$OtherGamesFile");
	}
	system("wget https://empiredirectory.net/$OtherGamesFile > /dev/null 2>\&1");
	open(my $fh, '<:encoding(UTF-8)', $OtherGamesFile)
		or die "Could not open file '$OtherGamesFile' $!";
	while (my $row = <$fh>)
	{
		chomp $row;
		print "==========\n";
		(my $GameName, my $GameConnect, my $GameWebsite) = split('\t', $row);
		print "Game Name:\t\t$GameName\n";
		print "Game Connection:\t$GameConnect\n";
		print "Game Website:\t\t$GameWebsite\n";
	}
	close($fh);
	print "----------\nTo get your server listed here contact us at $ContactUs\n";
	print "Get a Empire server of your own for just \$7: $GameSubsLink\n";
}

print $clear_screen;

while (-1)
{
	MainMenu();
	if (($menuselection eq "CANCEL") || ($menuselection eq "ESC") || ($menuselection eq "") || ($menuselection eq "q") || ($menuselection eq "Q"))
	{
		exit 0;
	}
	if ($menuselection eq "1")
	{
		print $clear_screen;
		system("$EmpireCommand");
		print "--[ Press Enter To Continue ]--";
		my $usrword = <STDIN>;
	}
	elsif ($menuselection eq "2")
	{
		print $clear_screen;
		DisplayLogo();
		if (-f "empusers.txt")
		{
			unlink("empusers.txt");
		}
		system("wget \"$SanctFile\" > /dev/null 2>\&1");

		open(my $fh, '<:encoding(UTF-8)', "empusers.txt")
			or die "Could not open file '$SanctFile' $!";
		while (my $row = <$fh>)
		{
			chomp $row;
			print "$row\n";
		}
		close($fh);
		print "--[ Press Enter To Continue ]--";
		my $usrword = <STDIN>;
	}
	elsif ($menuselection eq "3")
	{
		print $clear_screen;
		system("$LESSCMD $WhatIsFile");
	}
	elsif ($menuselection eq "4")
	{
		print $clear_screen;
		system("$EmpireFeverCommand");
		print "--[ Press Enter To Continue ]--";
		my $usrword = <STDIN>;
	}
	elsif ($menuselection eq "5")
	{
		print $clear_screen;
		DisplayLogo();
		open(my $fh, '<:encoding(UTF-8)', $FeverFile)
			or die "Could not open file '$FeverFile' $!";
		while (my $row = <$fh>)
		{
			chomp $row;
			print "$row\n";
		}
		close($fh);
		print "--[ Press Enter To Continue ]--";
		my $usrword = <STDIN>;
	}
	elsif ($menuselection eq "6")
	{
		print $clear_screen;
		system("$LESSCMD $EmpireLinks");
	}
	elsif ($menuselection eq "7")
	{
		print $clear_screen;
		ShowOtherGames();
		print "--[ Press Enter To Continue ]--";
		my $usrword = <STDIN>;
	}
}

exit 0;
