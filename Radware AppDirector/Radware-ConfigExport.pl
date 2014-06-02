#!/usr/bin/perl -w

# $Id: Radware-ConfigExport.pl 128 2013-08-26 15:28:46Z marc@mguyard.com $

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Data::Dumper;
use File::DirList;
use feature "switch";

###################
# Script Variable #
###################

my $script_name = 'Radware - Config Export';
my $author = 'Marc GUYARD <m.guyard@orange.com>';
my $version = '0.1';

#####################
# Default arguments #
#####################

my $configfile;
my $directory;
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

# Clear configuration
sub clean_config() {
	my ($configfile) = (@_);
	open(CONFIG, $configfile);
	my $config = do { local $/; <CONFIG> };;
	close CONFIG;
	$config =~ s/\\\R//g;
	return $config;
}

# Find last configuration in directory
sub last_config() {
	my ($configDir) = (@_);
	my @sorted_files = File::DirList::list($configDir, 'Mn', 1, 1, 0);
	my @newest = @{$sorted_files[0][0]};
	my $configfile = $configDir."/".$newest[13];
	return $configfile;
}

# Find L4PT configuration
sub find_all_L4PT() {
	my (@config) = (@_);
	my ($L4PT_IP,$L4PT_PROTO,$L4PT_PORT,$L4PT_SRC,$L4PT_NAME,$L4PT_FARM,$L4PT_L7PTNAME,$L4PT_APPLICATION,$L4PT_SSLPT);
	foreach my $line (@config) {
		if ($line =~ m/appdirector l4-policy table .*/i) {
			given($line) {
				when (/.* -fn .*/) {
					# Version appel direct vers une FARM
					print "Version Farm Direct HTTP : ".$line."\n" if $verbose;
					$line =~ m/appdirector l4-policy table create (\S+) (\S+) (\S+) (\S+) (\S+) -fn (\S+)/i;
					$L4PT_IP = $1;
					$L4PT_PROTO = $2;
					$L4PT_PORT = $3;
					$L4PT_SRC = $4;
					$L4PT_NAME = $5;
					$L4PT_FARM = $6;
				}
				when (/.* -fn .*/)
				when (/.* -ta HTTPS -sl .*/) {
					# Version L7 HTTPS
					print "Version HTTPS L7 : ".$line."\n" if $verbose;
					$line =~ m/appdirector l4-policy table create (\S+) (\S+) (\S+) (\S+) (\S+) -po (\S+) -ta (\S+) -sl (\S+)/i;
					$L4PT_IP = $1;
					$L4PT_PROTO = $2;
					$L4PT_PORT = $3;
					$L4PT_SRC = $4;
					$L4PT_NAME = $5;
					$L4PT_L7PTNAME = $6;
					$L4PT_APPLICATION = $7;
					$L4PT_SSLPT = $8;
				}
				when (/.* -po .*/) {
					# Version L7 HTTP
					print "Version HTTP L7 : ".$line."\n" if $verbose;
				}
				default {
					# Version Inconnu
					print "INCONNU : ".$line."\n" if $verbose;
				}
			}
		}
	}
}

# Generate L4PT Export
sub generate_L4PT_export() {
	my (@config) = (@_);
	&find_all_L4PT(@config);
}

# Generate Global Export
sub generate_global_export() {
	my (@config) = (@_);
	&generate_L4PT_export(@config);
}



##########
# Script #
##########

# Check If arguments are present
if ( @ARGV > 0 ) {
	# Parse Arguments
	GetOptions( 	
		"c|config=s" => \$configfile,
		"d|directory=s" => \$directory,
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
if ($directory) {
	$configfile = &last_config($directory);
}
my $config_clean = &clean_config($configfile);
my @config_tab = split(/\n/, $config_clean);
&generate_global_export(@config_tab);


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
		--directory <directory>
			specfy a directory where search the last configuration
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

Read configuration file specify in argument to generate export.
 
=item B<--directory>
 
Read directory to find the last configuration file and use it to generate export.

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

B<This program> is use to export radware configurations managed by the Orange NIS NSOC.

=head1 RETURN CODE

	Return Code :


=cut