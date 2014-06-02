#!/usr/bin/perl -w

# $Id$

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use POSIX;
use Data::Dumper;
use Config::IniFiles;
use MIME::Lite;
use Net::FTP::File;
use Env qw(@LD_LIBRARY_PATH);

###################
# Script Variable #
###################

my $script_name = 'Check Point - Web Visualization Tool Launcher';
my $author = 'Marc GUYARD <m.guyard@orange.com>';
my $version = '0.1';

#####################
# Default arguments #
#####################

my $today = strftime("%Y-%m-%d", localtime);
my $year = strftime("%Y", localtime);
my $month_letter = ucfirst(strftime("%B", localtime));
my $month = strftime("%m", localtime);
my $configvars;
my $configuration_file;
my $show_version;
my $show_help;
my $show_man;
my $verbose;
my $error = 0;
my @errormsg;

#############
# Functions #
#############

## Function to show the version
sub show_version {
	print "*** VERSION ***\n";
	print "Version : $version\n";
}

# Return ExitCode
sub return_code {
	my $code = $_[0];
	my $message = $_[1];
	print $message." - (Code : ".$code.")";
	exit $code;
}

# Parse the config ini file
sub parse_configvars {
	my $section = $_[0];
	my $parameter = $_[1];
	my $var = substr $configvars->val( $section, $parameter ), 1, - 1;
	return $var;
}

## Send report-email
sub reportemail {
	# Recuperation des variable
	my $customer_name = &parse_configvars('customer','customer.name');
	my $customer_project = &parse_configvars('customer','customer.project');
	my $customer_full = $customer_name;
	if ($customer_project ne "") {
		$customer_full = $customer_name." - ".$customer_project;
	}
	my $email_logo = &parse_configvars('report','report.logo');
	my $email_relay = &parse_configvars('email','email.relay.server');
	my $email_src = &parse_configvars('email','email.address.src');
	my $email_dst = &parse_configvars('email','email.address.dst');
	my $email_cc = &parse_configvars('email','email.address.cc');
	my $msg_html_errormsg;
	# Generation du contenu de l'email
	my $msg_html_header = "<img src='cid:Orange-small.png'><br><br><br>";
	my $msg_html_content= "<body>Bonjour,<br><br>Des problème ont étaient détectés lors de la génération de l' <b>Export des firewall Firewall CheckPoint de ".$customer_full."</b> du ".$today."<br>";
	foreach my $errormsg (@errormsg) {
		$msg_html_errormsg = $msg_html_errormsg."<br><br><br><i>".$errormsg."</i>";
	}
	my $message_html_full = $msg_html_header.$msg_html_content."<blockquote>".$msg_html_errormsg."</blockquote>";
	# Generation de l'email
	my $msg = MIME::Lite->build(
		From	=> 'Check Point Report <'.$email_src.'>',
		To		=> $email_dst,
		Cc		=> $email_cc,
		"Return-Path"	=> $email_src,
		Subject	=> '['.$customer_full.'] - Rapport incident Export Check Point '.$today,
		Type	=> 'multipart/mixed'
	) or &return_code(50, "Failed to create email");
	# Attachement de la première partie MIME, le texte du message
	$msg->attach(
		Type => 'text/html',
		Encoding => 'quoted-printable',
		Data => $message_html_full
	) or &return_code(50, "Failed to write html content in email core");
	$msg->attach(
		Type => 'image/png',
		Id   => 'Orange-small.png',
		Path => $email_logo
	) or &return_code(50, "Failed to attach Orange Logo");
	# Le message est en UTF-8
	$msg->attr("content-type.charset" => "utf-8");
	# Precision de parametres d'envoi
	MIME::Lite->send(
		'smtp',
		$email_relay,
		HELLO=> (POSIX::uname)[1],
		PORT=>'25',
		Debug => $verbose,
		Timeout => 60
	);
	# Envoi du message
	$msg->send || die "Failed to send email\n";
}

sub launch {
	my $checkpoint_binary_path = &parse_configvars('base','checkpoint.binary.path');
	my $checkpoint_binary_name = &parse_configvars('base','checkpoint.binary.name');
	my $customer_version = &parse_configvars('customer','customer.version');
	my $customer_smartcenter = &parse_configvars('customer','customer.smartcenter');
	my $customer_login = &parse_configvars('customer','customer.login');
	my $customer_password = &parse_configvars('customer','customer.password');
	my $customer_trigramme = &parse_configvars('customer','customer.trigramme');
	my $customer_storage_path = &parse_configvars('customer','customer.storage.path');
	print "******************** DEBUG Export ".$customer_smartcenter." ********************\n\n";
	if (@LD_LIBRARY_PATH) {
		push @LD_LIBRARY_PATH,$checkpoint_binary_path."/".$customer_version."/libs";
	} else {
		$ENV{LD_LIBRARY_PATH}= $checkpoint_binary_path."/".$customer_version."/libs";
	}
	if (! -e $customer_storage_path ) {
		mkdir $customer_storage_path;
	}
	rmdir $customer_storage_path."/*";
	chdir $checkpoint_binary_path."/".$customer_version or die "Failed to change directory to ".$checkpoint_binary_path."/".$customer_version.".";
	open LAUNCH, $checkpoint_binary_path."/".$customer_version."/".$checkpoint_binary_name." . ".$customer_storage_path." ".$customer_smartcenter." ".$customer_login." ".$customer_password." -o fwrules_".$customer_trigramme."_".$today.".html |";
	my $return= "";
	while( my $line = <LAUNCH> ) {
		$return = join("", $return, $line);
		print $line;
	}
	if ($return !~ m/Processing table/ig) {
		$error = $error+1;
		push(@errormsg, "Failed to execute with error : \n\n".$return);
	}
	close LAUNCH;
	sleep(10);
	rmdir $customer_storage_path."/temp";
	if ($error eq "0") {
		&send_ftp($customer_storage_path."/fwrules_".$customer_trigramme."_".$today.".html");
		print "******************** FIN Export ".$customer_smartcenter." ********************\n\n";
	}
	unlink($filename);
}

sub send_ftp() {
	my ($filename) = (@_);
	my $ftp_server = &parse_configvars('ftp','ftp.server');
	my $ftp_user = &parse_configvars('ftp','ftp.user');
	my $ftp_password = &parse_configvars('ftp','ftp.password');
	my $ftp_path = &parse_configvars('ftp','ftp.path');
	my $ftp = Net::FTP->new($ftp_server, Debug => $verbose)
		or die "Cannot connect to ".$ftp_server." : $@";
	$ftp->login($ftp_user,$ftp_password)
		or die "Cannot login ", $ftp->message;
	$ftp->cwd($ftp_path);
	if(! $ftp->isdir($year."/".$month."-".$month_letter)) {
		$ftp->mkdir($year."/".$month."-".$month_letter, 1);
	}
	$ftp->cwd($year."/".$month."-".$month_letter);
	$ftp->put($filename);
	unlink($filename);
}

##########
# Script #
##########

# Check If arguments are present
if ( @ARGV > 0 ) {
  # Parse Arguments
  GetOptions(   
    "c|configuration=s" => \$configuration_file,
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
$configvars = Config::IniFiles->new( -file => $configuration_file );
&launch;
# Si $error est > 1 alors on envoi un email avec le contenu de @errormsg
if ($error ne "0") {
	&reportemail;
}

__END__

=head1 NAME

Check Point - Web Visualization Tool Launcher

=head1 AUTHOR

Script written by Marc GUYARD for Orange AIS <m.guyard@orange.com>.

=head1 VERSION

0.1 BETA PERL

=head1 SYNOPSIS

B<launcher.pl> 

  Options:
    --configuration
      Specify the configuration file
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

=item B<--configuration>

Specify the configuration file

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

B<This program> is use to generate Check Point Web Visualization Tool for OTRS managed by the Orange AIS NSOC.

=head1 RETURN CODE

  Return Code :


=cut