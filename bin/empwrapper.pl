#!/usr/bin/perl
use strict;
use warnings;

use UI::Dialog;
use Term::ReadKey;
use Term::ANSIScreen qw(cls);
use File::Fetch;

my $EmpireCommand = "/home/empire/empiremanager/bin/empire -r -s empiredirectory.net:6665";
my $BannerText = "logo.txt";
my $LESSCMD = "/bin/more";
my $WhatIsFile = "whatisempire.txt";
my $EmpireLinks = "empirelinks.txt";

###################################################
# No changes below here
###################################################


my $EMP_ver = "1.2.0";
my $url = 'http://empiredirectory.net/empusers.txt';

my $clear_screen = cls();

# Get file of active users
my $ff = File::Fetch->new(uri => $url);
my $file = $ff->fetch() or die $ff->error;

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
                                      '4', 'Empire Links',
                                      'q', 'Quit Empire' ] );
}

sub DisplayLogo
{
	# Display the logo file
	system("cat $BannerText");
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
		open(my $fh, '<:encoding(UTF-8)', $file)
			or die "Could not open file '$file' $!";
		while (my $row = <$fh>)
		{
			chomp $row;
			print "$row\n";
		}
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
		system("$LESSCMD $EmpireLinks");
	}
}

exit 0;
