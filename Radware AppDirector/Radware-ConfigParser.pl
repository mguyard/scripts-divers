#!/usr/bin/perl -w

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;

###################
# Script Variable #
###################

my $script_name = 'Radware - Config Parser';
my $author = 'Marc GUYARD <m.guyard@orange-ftgroup.com>';
my $version = '0.1';

#####################
# Default arguments #
#####################

my $configfile;
my $search_site;
my $parse_config;
my @configfile;
my $show_version;
my $show_help;
my $show_man;
my $verbose;

#############
# Functions #
#############

## Function to show the version
sub show_version {
	print "*** VERSION ***\n";
	print "Version : $version\n";
}

sub clean_config() {
	my ($configfile) = (@_);
	open(CONFIG, $configfile);
	my $config = do { local $/; <CONFIG> };;
	close CONFIG;
	$config =~ s/\\\R//g;
	return $config;
}

sub find_L7MT() {
	print "[find_L7MT] - Debug Website : ".$search_site."\n" if $verbose;
	my @L7MTList;
	foreach my $line (@configfile) {
		if ($line =~ m/appdirector l7 farm-selection method-table setCreate (\w+) .* -ma HN=$search_site/) {
			my $L7MT = $1;
			print "[find_L7MT] - Line : ".$line."\n" if $verbose;
			print "[find_L7MT] - L7MT = ".$L7MT."\n" if $verbose;
			push(@L7MTList, $L7MT)
		}
	}
	return @L7MTList;
}

sub find_L7PT() {
	my ($L7MT) = (@_);
	print "[find_L7PT] - L7MT : ".$L7MT."\n" if $verbose;
	my @L7PTList;
	my $L7PT;
	my $L7PTID;
	foreach my $line (@configfile) {
		if ($line =~ m/farm-selection policy-table setCreate (\w+) (\d+) -m1 $L7MT/) {
			$L7PT = $1;
			$L7PTID = $2;
			print "[find_L7PT] - Line : ".$line."\n" if $verbose;
			print "[find_L7PT] - L7PT = ".$L7PT."/ L7PT ID = ".$L7PTID."\n" if $verbose;
			push(@L7PTList, $L7PT." ".$L7PTID)
		}
	}
	return (@L7PTList);
}

sub find_L4PT() {
	my ($L7PT) = (@_);
	print "[find_L4PT] - L7PT : ".$L7PT."\n" if $verbose;
	my $L4PTName;
	my $L4PTIP;
	my $L4PTPort;
	foreach my $line (@configfile) {
		if ($line =~ m/appdirector l4-policy table create (\S+) \w+ (\d+) \S+ (\w+) -po $L7PT .*/) {
			$L4PTIP = $1;
			$L4PTPort = $2;
			$L4PTName = $3;
			print "[find_L4PT] - Line : ".$line."\n" if $verbose;
			print "[find_L4PT] - L4PT Name = ".$L4PTName." / L4PT IP = ".$L4PTIP." / L7PT Port = ".$L4PTPort."\n" if $verbose;
		}
	}
	return ($L4PTName,$L4PTIP,$L4PTPort);
}

sub search_farm() {
	my ($L7PTName,$L7PTID) = (@_);
	my $FarmName;
	foreach my $line (@configfile) {
		if ($line =~ m/appdirector l7 farm-selection policy-table setCreate $L7PTName $L7PTID .* -fn (\S+)/) {
			$FarmName = $1;
			print "[search_farm] - Line : ".$line."\n" if $verbose;
			print "[search_farm] - L7 FarmName = ".$FarmName."\n" if $verbose;
		}
	}
	return $FarmName;
}

sub search_website() {
	my ($configfile) = (@_);
	print "[DEBUG] - Website search : ".$search_site."\n" if $verbose;
	@configfile = split /\n/, $configfile;
	my @L7MTList = &find_L7MT(@configfile);
	print Dumper(@L7MTList) if $verbose;
	foreach my $L7MT (@L7MTList) {
		my @L7PTList = &find_L7PT($L7MT);
		foreach my $L7PT (@L7PTList) {
			my ($L7PTName,$L7PTID) = split(' ',$L7PT);
			my ($L4PTName,$L4PTIP,$L4PTPort) = &find_L4PT($L7PTName);
			my $FarmName = &search_farm($L7PTName,$L7PTID);
			print "Website : ".$search_site."\n";
			print " -----> L7MT : ".$L7MT."\n";
			print " -----> L7PT : ".$L7PTName."\n";
			print "        -----> L7PT ID : ".$L7PTID."\n";
			print " -----> L4PT : ".$L4PTName."\n";
			print "        -----> L4PTIP : ".$L4PTIP."\n";
			print "        -----> L4PTPort : ".$L4PTPort."\n";
			if (defined($FarmName)) {
				print " -----> Farm : ".$FarmName."\n";
			} else {
				print " -----> Farm : Aucune ferme sur la L7 - Regardez sur une L4\n";
			}
		}
	}
}

##########
# Script #
##########

# Check If arguments are present
if ( @ARGV > 0 ) {
	# Parse Arguments
	GetOptions(
		"c|config=s" => \$configfile,
		"s|search=s" => \$search_site,
		"p|parse-config" => \$parse_config,
		"version" => \&show_version,
		"v|verbose" => \$verbose,
		"q|quiet" => sub { $verbose = 0 },
		"man" => \$show_man,
		"h|help|?" => \$show_help
	)
	# Show usage if no argument match
	or pod2usage({-message => "Argument unknown\n", -exitval => 1});
} else {
	# Show usage if no argument specified
	pod2usage({-message => "No argument specify\n", -exitval => 2});
}

# Show help usage
pod2usage(1) if $show_help;
# Show man usage
pod2usage(-verbose => 2) if $show_man;

# Call functions
my $config_clean = &clean_config($configfile);
if ($parse_config) {
	print $config_clean;
} elsif ($search_site) {
	&search_website($config_clean,$search_site);
	#print $config_clean if $verbose;
}


__END__

=head1 NAME

Radware - Config Parser

=head1 AUTHOR

Script written by Marc GUYARD for Orange AIS <m.guyard@orange.com>.

=head1 VERSION

0.1 BETA PERL

=head1 SYNOPSIS

B<ABT.pl>

	Options:
		--config <configuration_file>
			use a configuration file specified
		--search <website>
			specfy a website to show the configuration for this website
		--parse_config
			only parse the configuration and show the parsed configuration
		--version
			show script version (need to be the first option)
		--verbose
			active script verbose
		--quiet
			active script quiet mode
		--man
			full documentation
		--help
			brief help message

=head1 OPTIONS

=over 8

=item B<--config>

Backup using a configuration file specify in argument.

=item B<--version>

Print script version and exit.

=item B<--verbose>

Activate verbose mode. Should be used with another argument.

=item B<--quiet>

Activate quiet mode. Should be used with another argument.

=item B<--help>

Print a brief help message and exits.

=item B<--man>

Prints the manual page and exits.

=back

=head1 DESCRIPTION

B<This program> is use to parse radware configurations managed by the Orange NIS NSOC.

=head1 RETURN CODE

	Return Code :


=cut