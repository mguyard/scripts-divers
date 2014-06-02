#!/usr/bin/perl
#----------------------------------------------------------------------------
# The contents of this file are subject to the iControl Public License
# Version 4.5 (the "License"); you may not use this file except in
# compliance with the License. You may obtain a copy of the License at
# http://www.f5.com/.
#
# Software distributed under the License is distributed on an "AS IS"
# basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
# the License for the specific language governing rights and limitations
# under the License.
#
# The Original Code is iControl Code and related documentation
# distributed by F5.
#
# The Initial Developer of the Original Code is F5 Networks,
# Inc. Seattle, WA, USA. Portions created by F5 are Copyright (C) 1996-2003 F5 Networks,
# Inc. All Rights Reserved.  iControl (TM) is a registered trademark of F5 Networks, Inc.
#
# Alternatively, the contents of this file may be used under the terms
# of the GNU General Public License (the "GPL"), in which case the
# provisions of GPL are applicable instead of those above.  If you wish
# to allow use of your version of this file only under the terms of the
# GPL and not to allow others to use your version of this file under the
# License, indicate your decision by deleting the provisions above and
# replace them with the notice and other provisions required by the GPL.
# If you do not delete the provisions above, a recipient may use your
# version of this file under either the License or the GPL.
#----------------------------------------------------------------------------

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use POSIX;
# use SOAP::Lite + trace => qw(method debug);
use SOAP::Lite;
use BigIP::iControl;
use Data::Dumper;
use Net::FTP::File;
use Config::IniFiles;

###################
# Script Variable #
###################

my $script_name = 'F5 LTM - Export HTML';
my $author = 'Marc GUYARD <m.guyard@orange.com>';
my $version = '0.1';

#####################
# Default arguments #
#####################

my $show_version;
my $show_help;
my $show_man;
my $verbose;
my $configvars;
my $configuration_file;
my $LocalLBVirtualServer;
my $LocalLBRule;
my $LocalLBPool;
my $LocalLBPoolMember;
my $soapResponse;
my $urnMap = {
    "{urn:iControl}LocalLB.LBMethod" => 1,
    "{urn:iControl}LocalLB.MonitorRuleType" => 1,
    "{urn:iControl}LocalLB.ProfileContextType" => 1,
    "{urn:iControl}LocalLB.ProfileType" => 1,
    "{urn:iControl}LocalLB.VirtualServer.VirtualServerType" => 1,
};
my $today = strftime("%Y-%m-%d", localtime);
my $year = strftime("%Y", localtime);
my $month_letter = ucfirst(strftime("%B", localtime));
my $month = strftime("%m", localtime);
my $host;
my $username;
my $password;
my $customer_name;
my $customer_project;
my $output;


#############
# Functions #
#############

## Function to show the version
sub show_version {
	print "*** VERSION ***\n";
	print "Version : $version\n";
}

# Parse the config ini file
sub parse_configvars {
	my $section = $_[0];
	my $parameter = $_[1];
	my $var = substr $configvars->val( $section, $parameter ), 1, - 1;
	return $var;
}

sub HTML_Header() {
	# my ($output) = (@_);
	if (!defined($output)) {
		print "You need to specify in which file write the report !\n";
		exit 10;
	} else {
		open(HTMLHEADER,">$output");
		print HTMLHEADER '<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd" />';
		print HTMLHEADER '<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="fr-FR">';
		print HTMLHEADER '<head>';
		print HTMLHEADER '<meta http-equiv="content-type" content="text/html; charset=UTF-8" />';
		print HTMLHEADER '<meta http-equiv="content-language" content="fr-FR" />';
		print HTMLHEADER '<title>Reporting F5 LTM</title>';
		print HTMLHEADER '<meta name="language" content="fr-FR" />';
		print HTMLHEADER '<meta name="robots" content="all" />';
		print HTMLHEADER '<meta name="description" content="Reporting Configuration F5 LTM" />';
		print HTMLHEADER '</head>';
		print HTMLHEADER '<div id="header" STYLE="width:100%;float:left;margin-top:20px;height:100px;">';
		print HTMLHEADER '<div id="logoOBS" STYLE="float:left;width:20%;text-align:center;"><img alt="" src="data:image/png;base64,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" /></div>';
		print HTMLHEADER '<div id="title" STYLE="float:left;width:60%;text-align:center;"><h1 style="color:#FF7900">'.$customer_name.' '.$customer_project.' - Configuration F5 LTM<h1></div>';
		print HTMLHEADER '<div id="logoF5" STYLE="float:left;width:20%;text-align:center;"><img alt="" width="30%" src="data:image/jpeg;base64,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" /></div>';
		print HTMLHEADER '</div>';
		close (HTMLHEADER); 
	}
}

sub HTML_Footer() {
	# my ($output) = (@_);
	open(HTMLFOOTER,">>$output");
	print HTMLFOOTER '</body>';
	print HTMLFOOTER '</html>';
	close (HTMLFOOTER);
}

## Transport Information
sub SOAP::Transport::HTTP::Client::get_basic_credentials {
	return "$username" => "$password";
}

## Deserializer SOAP
no warnings 'redefine'; 
sub SOAP::Deserializer::typecast { 
	my ($self, $value, $name, $attrs, $children, $type) = @_; 
	my $retval = undef; 
	if (!defined $type) { 
		return $retval; 
	}
	if (!defined $urnMap->{$type}) { 
		return $retval; 
	} 
	if (1 == $urnMap->{$type} ) { 
		$retval = $value; 
	} 
	return $retval; 
}

## Launch Icontrol Interface
sub SetIControl() {
	my ($module, $name) = @_;
  
	my $interface = SOAP::Lite
		-> uri("urn:iControl:$module/$name")
		-> readable(1)
		-> proxy("https://$host/iControl/iControlPortal.cgi");
	eval {
		$interface->transport->http_request->header( 'Authorization' => 'Basic ' . MIME::Base64::encode("$username:$password", '') );
		$interface->transport->ssl_opts( SSL_verify_mode => 'SSL_VERIFY_NONE' );
	};

	return $interface;
}

## Check Response
sub checkResponse() {
	my ($soapResponse) = (@_);
	if ( $soapResponse->fault )
	{
		print $soapResponse->faultcode, " ", $soapResponse->faultstring, "\n";
		exit();
	}
}

## Get Irule
sub getiRuleContent() {
	my($rulename) = (@_);
	my $RuleDefinition;
	
	if ( $rulename eq "" ) {
		print "WARNING : Rulename EMPTY\n"
	} else {
		$soapResponse = $LocalLBRule->query_rule(
			SOAP::Data->name(rule_names => [$rulename])
		);
		&checkResponse($soapResponse);
		my @RuleDefinitionList = @{$soapResponse->result};
		$RuleDefinition = $RuleDefinitionList[0];
	}
	my $rule_name = $RuleDefinition->{"rule_name"};
	my $rule_definition = $RuleDefinition->{"rule_definition"};
	return $rule_definition;
}

sub getVS() {
	my %VS = ();
	my $VSname;
	my $VSdestination;
	$soapResponse = $LocalLBVirtualServer->get_list();
	&checkResponse($soapResponse);
	my @vs_list = @{$soapResponse->result};
	foreach $VSname (@vs_list) {
		$soapResponse = $LocalLBVirtualServer->get_destination(
			SOAP::Data->name (virtual_servers => [$VSname])
		);
		&checkResponse($soapResponse);
		my @destination_list = @{$soapResponse->result};
		my $VSdestinationIP = $destination_list[0]->{'address'};
		my $VSdestinationPORT = $destination_list[0]->{'port'};
		my $VSdestination = $VSdestinationIP.":".$VSdestinationPORT;
		$VS{$VSname} = $VSdestination;
	}
	return %VS;
}

sub getIRULE() {
	my($VS) = (@_);
	$soapResponse = $LocalLBVirtualServer->get_rule(
		SOAP::Data->name (virtual_servers => [$VS])
	);
	&checkResponse($soapResponse);
	my @irule_list = @{$soapResponse->result};
	return @irule_list;
}

sub getALLIRULES() {
	$soapResponse = $LocalLBRule->get_list;
	&checkResponse($soapResponse);
	my @all_irule_list = @{$soapResponse->result};
	return @all_irule_list;
}

sub getPROFILE() {
	my($VS) = (@_);
	$soapResponse = $LocalLBVirtualServer->get_profile(
		SOAP::Data->name(virtual_servers => [$VS])
	);
	&checkResponse($soapResponse);
	my @profile_list = @{$soapResponse->result};
	return @profile_list;
}

sub getPOOL() {
	my($VS) = (@_);
	$soapResponse = $LocalLBVirtualServer->get_default_pool_name(
		SOAP::Data->name (virtual_servers => [$VS])
	);
	&checkResponse($soapResponse);
	my @pool_list = @{$soapResponse->result};
	return @pool_list;
}

sub getALLPOOL() {
	$soapResponse = $LocalLBPool->get_list;
	&checkResponse($soapResponse);
	my @all_pool_list = @{$soapResponse->result};
	return @all_pool_list;
}

sub getPOOLMEMBERS() {
	my($poolname) = (@_);
	$soapResponse = $LocalLBPool->get_member(
		SOAP::Data->name(pool_names => [$poolname])
	);
	&checkResponse($soapResponse);
	my @member_list = @{$soapResponse->result};
	return @member_list;
}

sub getLBMETHOD() {
	my($poolname) = (@_);
	my @lbmethod_list;
	if ( $poolname ne "") {
		$soapResponse = $LocalLBPool->get_lb_method(
			SOAP::Data->name(pool_names => [$poolname])
		);
		&checkResponse($soapResponse);
		@lbmethod_list = @{$soapResponse->result};
	}
	return @lbmethod_list;
}

## Request Informations
sub requestF5 {
	$LocalLBVirtualServer = &SetIControl("LocalLB", "VirtualServer");
	$LocalLBRule = &SetIControl("LocalLB", "Rule");
	$LocalLBPool = &SetIControl("LocalLB", "Pool");
	$LocalLBPoolMember = &SetIControl("LocalLB", "PoolMember");
	open(HTMLCONTENT,">>$output");
	print HTMLCONTENT "<div id='main' STYLE='width:100%;float:left;'>";
	print HTMLCONTENT "<h2 style='color:#FF7900;margin-left:5%;'><i>Liste des Virtual Servers<i></h2>";
	my %VS = &getVS;
	my @VS = sort keys(%VS);
	foreach my $VS (@VS) {
		my $VSname = $VS;
		my $VSaddress = $VS{$VS};
		print "VS=".$VSname." IP=".$VSaddress."\n" if ($verbose);
		print HTMLCONTENT "<h3 style='color:#444444;text-align:center;text-transform:uppercase;'>".$VSname.'</h3>';
		my @irule_list = &getIRULE($VSname);
		my @profile_list = &getPROFILE($VSname);
		my @pool_list = &getPOOL($VSname);
		my $poolname = $pool_list[0];
		# my @member_list = &getPOOLMEMBERS($poolname) if ($poolname ne "");
		my @lbmethod_list = &getLBMETHOD($poolname) if ($poolname ne "");
		# @member_list = @{$member_list[0]} if (@member_list);
		@irule_list = @{$irule_list[0]};
		@profile_list = @{$profile_list[0]};
		$lbmethod_list[0] = "" if ( !defined($lbmethod_list[0]) );
		# print Dumper(@member_list);
		print "Pool Name : ".$poolname." / LB Method : ".$lbmethod_list[0]."\n" if ($verbose);
		print HTMLCONTENT "<div id='VS'><center><table width='50%' STYLE='border:thin solid;border-collapse:collapse;'><caption><i>Informations Virtual Server</i></caption>";
		print HTMLCONTENT "<tr style='border: thin solid;'><th style='background-color: #FF7900;color: #fff;'>Nom : </th><td style='border: thin solid;text-align: center;'>".$VSname."</td></tr>";
		print HTMLCONTENT "<tr style='border: thin solid;'><th style='background-color: #FF7900;color: #fff;'>Adresse IP/Port : </th><td style='border: thin solid;text-align: center;'>".$VSaddress."</td></tr>";
		print HTMLCONTENT "<tr style='border: thin solid;'><th style='background-color: #FF7900;color: #fff;'>Pool Name : </th><td style='border: thin solid;text-align: center;'><a href=#pool_".$poolname.">".$poolname."</a></td></tr>";
		print HTMLCONTENT "<tr style='border: thin solid;'><th style='background-color: #FF7900;color: #fff;'>Load-Balancing Method : </th><td style='border: thin solid;text-align: center;'>".$lbmethod_list[0]."</a></td></tr>";
		print HTMLCONTENT "</table></center></div>";
		# foreach my $member (@member_list) {
			# print "Member IP : ".$member->{'address'}." / Member Port : ".$member->{'port'}."\n" if ($verbose);
		# }
		print HTMLCONTENT "<br\>";
		print HTMLCONTENT "<center><div id='irules-vs'><table width='50%' STYLE='border:thin solid;border-collapse:collapse;'><caption><i>Irules</i></caption>";
		print HTMLCONTENT "<tr style='border: thin solid;'><th style='border: thin solid #000;background-color: #FF7900;color: #fff;'>Nom</th><th style='border: thin solid #000;background-color: #FF7900;color: #fff;'>Priorit&eacute;</th></tr>";
		foreach my $irule (@irule_list) {
			print "Irule Name : ".$irule->{'rule_name'}." / Irule Priority : ".$irule->{'priority'}."\n" if ($verbose);
			print HTMLCONTENT "<tr style='border: thin solid;'><td style='border: thin solid;text-align: center;'><a href=#irule_".$irule->{'rule_name'}.">".$irule->{'rule_name'}."</a></td><td style='border: thin solid;text-align: center;'>".$irule->{'priority'}."</td></tr>";
		}
		print HTMLCONTENT "</table></div></center>";
		print HTMLCONTENT "<br\>";
		print HTMLCONTENT "<center><div id='profile-vs'><table width='50%' STYLE='border:thin solid;border-collapse:collapse;'><caption><i>Profils</i></caption>";
		print HTMLCONTENT "<tr style='border: thin solid;'><th style='background-color: #FF7900;color: #fff;'>Nom</th><th style='background-color: #FF7900;color: #fff;'>Contexte</th><th style='background-color: #FF7900;color: #fff;'>Type</th></tr>";
		foreach my $profile (@profile_list) {
			print "Profile Name : ".$profile->{'profile_name'}." / Profile contexte : ".$profile->{'profile_context'}." / Profile Type : ".$profile->{'profile_type'}."\n" if ($verbose);
			print HTMLCONTENT "<tr style='border: thin solid;'><td style='border: thin solid;text-align: center;'>".$profile->{'profile_name'}."</td><td style='border: thin solid;text-align: center;'>".$profile->{'profile_context'}."</td><td style='border: thin solid;text-align: center;'>".$profile->{'profile_type'}."</td></tr>";
		}
		print HTMLCONTENT "</table></div></center>";
		print HTMLCONTENT "<br\><br\>";
		print "*******************\n" if ($verbose);
	}
	print HTMLCONTENT "<h2 style='color:#FF7900;margin-left:5%;'><i>Liste des Pools<i></h2>";
	my @all_pool_list = &getALLPOOL;
	print HTMLCONTENT "<center><div id='pools'><table width='50%' STYLE='border:thin solid;border-collapse:collapse;'>";
	foreach my $poolname (@all_pool_list) {
		print HTMLCONTENT "<tr style='border: thin solid;'><th colspan='2' style='background-color: #FF7900;color: #fff;'><balise id='pool_".$poolname."'>".$poolname."</balise></td></tr>";
		my @member_list = &getPOOLMEMBERS($poolname);
		@member_list = @{$member_list[0]};
		foreach my $members (@member_list) {
			print HTMLCONTENT "<tr style='border: thin solid;'><td style='border: thin solid;text-align: center;'>".$members->{'address'}."</td><td style='border: thin solid;text-align: center;'>".$members->{'port'}."</td></tr>";
		}
	}
	print HTMLCONTENT "</table></div></center>";
	print HTMLCONTENT "<h2 style='color:#FF7900;margin-left:5%;'><i>Liste des Irules<i></h2>";
	my @all_irule_list = &getALLIRULES;
	print HTMLCONTENT "<center><div id='irules'><table width='50%' STYLE='border:thin solid;border-collapse:collapse;margin-bottom:20px'>";
	foreach my $irulename (@all_irule_list) {
		print HTMLCONTENT "<tr style='border: thin solid;'><th style='background-color: #FF7900;color: #fff;'><balise id='irule_".$irulename."'>".$irulename."</balise></td></tr>";
		my $irulecontent = &getiRuleContent($irulename);
		$irulecontent =~ s/\n/\n<br>/g;
		print HTMLCONTENT "<tr style='border: thin solid;'><td style='border: thin solid;text-align: left;padding-left: 20px'>".$irulecontent."</td></tr>";
	}
	print HTMLCONTENT "</table></div></center>";
	# print Dumper(@all_irule_list);
	print HTMLCONTENT "</div>";
	close (HTMLCONTENT);
}

sub send_ftp() {
	my($output) = (@_);
	my $ftp_server = &parse_configvars('ftp','ftp.server');
	my $ftp_username = &parse_configvars('ftp','ftp.user');
	my $ftp_password = &parse_configvars('ftp','ftp.password');
	my $ftp_path = &parse_configvars('ftp','ftp.path');
	my $debug = 0;
	$debug = 1 if ($verbose);
	my $ftp = Net::FTP->new($ftp_server, Debug => $verbose)
		or die "Cannot connect to ".$ftp_server." : $@";
	$ftp->login($ftp_username,$ftp_password)
		or die "Cannot login ", $ftp->message;
	$ftp->cwd($ftp_path) or die "Changement de repertoire impossible.";
	if(! $ftp->isdir($year."/".$month."-".$month_letter)) {
		$ftp->mkdir($year."/".$month."-".$month_letter, 1);
	}
	$ftp->cwd($year."/".$month."-".$month_letter);
	$ftp->put($output) or die "Upload impossible.";
	$ftp->quit;
	unlink($output);
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
		"help|?" => \$show_help
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
$host = &parse_configvars('device','device.ip');
$username = &parse_configvars('device','device.username');
$password = &parse_configvars('device','device.password');
$customer_name = &parse_configvars('customer','customer.name');
$customer_project = &parse_configvars('customer','customer.project');
$output = "/tmp/".$customer_name."_".$customer_project."_".$today.".html";
&HTML_Header;
&requestF5;
&HTML_Footer;
&send_ftp($output);

__END__

=head1 NAME
 
 F5 - LTM Report
 
 =head1 AUTHOR
 
 Script written by Marc GUYARD for Orange AIS <m.guyard@orange.com>.
 
 =head1 VERSION
 
 0.1 BETA PERL
 
 =head1 SYNOPSIS
 
 B<F5_LTM_Export.pl>
 
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
 
 B<This program> is use to generate F5 LTM Report for LTM managed by the Orange AIS NSOC.
 
 =head1 RETURN CODE
 
 Return Code :

=cut


