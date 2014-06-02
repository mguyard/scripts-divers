#!/usr/bin/perl -w

# $Id$

use strict;
use warnings;
use Getopt::Long;
use Pod::Usage;
use Switch;
use Data::Dumper;
use POSIX;
use File::Basename;
use Config::IniFiles;
use DBI;
use Excel::Writer::XLSX;
use MIME::Lite;
use WWW::Mechanize;
use DateTime;
use Text::CSV;


###################
# Script Variable #
###################

my $script_name = 'OTRS - Reporting Excel';
my $author = 'Marc GUYARD <m.guyard@orange.com>';
my $version = '0.1';
my $database_host = 'dione.drs.local';
my $database_username = 'otrs';
my $database_password = 'dynetcom';
my $database_name = 'otrs2';
my $ticket_incident_ID = '1';
my $ticket_change_ID = '4,15,16';
my $ticket_other_ID = '3,13';
my $sql_request_tickets_open = "
SELECT ticket.id, ticket.tn AS TicketNumber, ticket.title AS TicketSubject, ticket.create_time AS TicketCreateTime, ticket.change_time AS TicketChangeTime, queue.name AS NSOCLevel, ticket_state.comments AS Status, ticket_priority.name AS Priority, ticket.customer_user_id AS Customer, ticket_type.name AS TicketType, users.first_name AS ReponsibleFirstName, users.last_name AS ReponsibleLastName, ticket.freetext1 AS DetectedBy, ticket.freetext2 AS ProblemOrigin, ticket.freetext6 AS Solution, ticket.freetime3 AS StartTime, ticket.freetime4 AS EndTime
FROM ticket,queue,users,ticket_state, ticket_priority, ticket_type
WHERE ticket.customer_id = ? AND ticket.ticket_state_id IN (1,4,6,10,11) AND ticket.type_id IN (?)
   AND ticket.queue_id = queue.id AND ticket.responsible_user_id = users.id AND ticket.ticket_state_id = ticket_state.id AND ticket.ticket_priority_id = ticket_priority.name AND ticket.type_id = ticket_type.id;";
my $sql_request_tickets_close = "
SELECT ticket.id, ticket.tn AS TicketNumber, ticket.title AS TicketSubject, ticket.create_time AS TicketCreateTime, ticket.freetime4 AS TicketCloseTime, users.first_name AS ReponsibleFirstName, users.last_name AS ReponsibleLastName, ticket.freetext1 AS DetectedBy, ticket.freetext2 AS ProblemOrigin, ticket.freetext6 AS Solution,ticket_type.name AS TicketType
FROM ticket,users,ticket_type
WHERE ticket.customer_id = ? AND ticket.ticket_state_id IN (2,3,7,8,12,13) AND ticket.type_id IN (?) AND ticket.freetime4 BETWEEN DATE_SUB(CURDATE(),INTERVAL 5 DAY) AND CURDATE()
   AND ticket.responsible_user_id = users.id AND ticket.type_id = ticket_type.id;";
my $sql_request_actionticket = "
SELECT article.id AS LastActionID, article.a_body AS LastAction, article.create_time AS LastActionDate
FROM article 
WHERE article_type_id = '12' and ticket_id = ? ORDER BY id DESC limit 1;
";
my $sql_request_ticket_count = "
SELECT ticket_type.id, ticket_type.name AS TicketType, sum(ticket.freetext7) AS Count
FROM ticket, ticket_type
WHERE customer_id = ? AND ticket_type.id IN (4,16) AND ticket.create_time BETWEEN ? AND CURDATE() AND ticket.type_id = ticket_type.id
GROUP BY TicketType;
";

#####################
# Default arguments #
#####################

my $today = strftime("%d-%m-%y", localtime);
my $configuration_file;
my $customer_name;
my $contract_start;
my $file_name;
my $configvars;
my $test_only = '0';
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
	my $customer_project = &parse_configvars('customer','customer.project');
	my $customer_full = $customer_name;
	if ($customer_project ne "") {
		$customer_full = $customer_name." - ".$customer_project;
	}
	my $email_logo = &parse_configvars('report','report.logo');
	my $procedure_link = &parse_configvars('procedure','procedure.url');
	my $email_relay = &parse_configvars('email','email.relay.server');
	my $email_src = &parse_configvars('email','email.address.src');
	my $email_dst = &parse_configvars('email','email.address.dst');
	my $email_cc = &parse_configvars('email','email.address.cc');
	# Generation du contenu de l'email
	my $msg_html_header = "<img src='cid:Orange-small.png'><br><br><br>";
	my $msg_html_content= "<body>Bonjour,<br><br>Veuillez trouver ci-joint le rapport <b>OTRS Quotidien ".$customer_full."</b> du ".$today."<br>";
	my $msg_html_footer = "<br><br>Pour g&eacute;n&eacute;rer le rapport, merci de suivre la proc&eacute;dure <a href='".$procedure_link."'>ici</a>";
	my $message_html_full = $msg_html_header.$msg_html_content.$msg_html_footer;
	# Generation de l'email
	my $msg = MIME::Lite->build(
		From	=> 'OTRS Report <'.$email_src.'>',
		To		=> $email_dst,
		Cc		=> $email_cc,
		"Return-Path"	=> $email_src,
		Subject	=> '['.$customer_full.'] - Rapport Quotidien OTRS du '.$today,
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
	$msg->attach(
		Type		=> 'application/vnd.ms-excel.sheet.macroEnabled.12',
		Disposition => 'attachment',
		Path		=> $file_name,
		Filename	=> basename($file_name)
	) or &return_code(50, "Failed to attach report in email");
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
	# Suppression du fichier Excel
	unlink($file_name)
}

# Function to generate the Excel
sub excel_generation {
	my ($test_only) = (@_);
	my $nb_change_minor = &parse_configvars('ticket','ticket.nb.change.minor');
	my $nb_change_major = &parse_configvars('ticket','ticket.nb.change.major');
	my $file_path = &parse_configvars('report','report.file.path');
	my $filename_prefix = &parse_configvars('report','report.file.prefix');
	$file_name = $file_path."/".$filename_prefix.'_'.$today.'.xlsm';
	my $protect_password = &parse_configvars('export','export.excel.password');
	my $vba_project = &parse_configvars('export','export.vba.project');
	my $Tickets_count = &mysql_select_count_ticket($sql_request_ticket_count, 'id');
	my $Tickets_Incidents_Ouverts = &mysql_select_all($sql_request_tickets_open, 'id', $ticket_incident_ID);
	my $Tickets_Incidents_Clos = &mysql_select_all($sql_request_tickets_close, 'id', $ticket_incident_ID);
	my $Tickets_Changements_Ouverts = &mysql_select_all($sql_request_tickets_open, 'id', $ticket_change_ID);
	my $Tickets_Changements_Clos = &mysql_select_all($sql_request_tickets_close, 'id', $ticket_change_ID);
	my $Tickets_Other_Ouverts = &mysql_select_all($sql_request_tickets_open, 'id', $ticket_other_ID);
	my $Tickets_Other_Clos = &mysql_select_all($sql_request_tickets_close, 'id', $ticket_other_ID);
	# Create a new Excel workbook
	my $workbook = Excel::Writer::XLSX->new( $file_name );
	# Add a VBA Project
	$workbook->add_vba_project( $vba_project );
	$workbook->set_properties(
		title    => 'Reporting OTRS '.$customer_name,
		author   => 'GUYARD Marc',
		company	 => 'NSOC AIS',
	);
	# Headers
	my @headers_open = ('Type','Ticket', 'Titre', 'Date Création', 'Date dernière mise à jour', 'Etat', 'Contact Client', 'Niveau NSOC', 'Responsable Ticket', 'Dernière Action', 'Date Dernière Action');
	my @headers_close = ('Type','Ticket', 'Titre', 'Date Création', 'Date Résolution', 'Incident Détecté par', 'Origine du problème', 'Résolution');
	my @col_open_size = ('15', '6.3', '48.3', '10', '10', '14.3', '13.5', '7.3', '12.3', '39.5', '10');
	my @col_close_size = ('15', '6.3', '48.3', '10', '10', '14.3', '13.5', '60');
	my $format_header = $workbook->add_format( bold => 1, color => 'white', bg_color => 'orange', valign => 'vcenter', align => 'center', border => 1, border_color => 'black', text_wrap => 1);
	my $format_content = $workbook->add_format( border => 1, border_color => 'black', text_wrap => 1, valign => 'vcenter', align => 'center');
	my $headers_ref_open = \@headers_open;
	my $headers_ref_close = \@headers_close;
	my @sql_colname_open = ('TicketType','TicketNumber','TicketSubject','TicketCreateTime','TicketChangeTime','Status','Customer','NSOCLevel','agent_name','LastAction','LastActionDate');
	my @sql_colname_close = ('TicketType','TicketNumber','TicketSubject','TicketCreateTime','TicketCloseTime','DetectedBy','ProblemOrigin','Solution');
	# Add a worksheet 'Traitement'
	##############################
	my $worksheet_traitement = $workbook->add_worksheet( 'Traitement' );
	$worksheet_traitement->insert_button( 'E15', { macro => 'Generation_Word', caption => 'Exporter Rapport', width => 600, height => 300 } );
	$worksheet_traitement->protect( $protect_password);
	# Add a worksheet 'Incident Ouvert'
	##############################
	my $worksheet_incident_open = $workbook->add_worksheet( 'Tickets_Incidents_Ouverts' );
		my $col = my $row = 0;
		foreach my $col_open_size (@col_open_size) {
			$worksheet_incident_open->set_column($col, $col, $col_open_size);
			$col = $col+1;
		}
		$col = 0;
		$worksheet_incident_open->write_row( 0, 0, $headers_ref_open, $format_header );	
		$row = $row+1;
		foreach my $tickets_id ( sort { $a <=> $b } keys %{$Tickets_Incidents_Ouverts} ) {
			my $last_action = &mysql_select_row($sql_request_actionticket, $Tickets_Incidents_Ouverts->{$tickets_id}->{id});
			$col = 0;
			foreach	my $colname (@sql_colname_open) {
				switch ($colname) {
					case "agent_name" {
						my $agent_name = $Tickets_Incidents_Ouverts->{$tickets_id}->{ReponsibleLastName}." ".$Tickets_Incidents_Ouverts->{$tickets_id}->{ReponsibleFirstName};
						$worksheet_incident_open->write($row, $col, $agent_name, $format_content);
					}
					case "LastAction" {
						$worksheet_incident_open->write($row, $col, $last_action->{LastAction}, $format_content);
					}
					case "LastActionDate" {
						$worksheet_incident_open->write($row, $col, $last_action->{LastActionDate}, $format_content);
					}
					else {
						$worksheet_incident_open->write($row, $col, $Tickets_Incidents_Ouverts->{$tickets_id}->{$colname}, $format_content);
					}
				}
				$col = $col+1;
			}
		$row = $row+1;
		}
		$worksheet_incident_open->protect( $protect_password);
	# Add a worksheet 'Incident Clos'
	##############################
	my $worksheet_incident_close = $workbook->add_worksheet( 'Tickets_Incidents_Fermés' );
		$col = $row = 0;
		foreach my $col_open_size (@col_close_size) {
			$worksheet_incident_close->set_column($col, $col, $col_open_size);
			$col = $col+1;
		}
		$col = 0;
		$worksheet_incident_close->write_row( 0, 0, $headers_ref_close, $format_header );	
		$row = $row+1;
		foreach my $tickets_id ( sort { $a <=> $b } keys %{$Tickets_Incidents_Clos} ) {
			my $last_action = &mysql_select_row($sql_request_actionticket, $Tickets_Incidents_Clos->{$tickets_id}->{id});
			$col = 0;
			foreach	my $colname (@sql_colname_close) {
				if ($colname eq 'agent_name') {
					my $agent_name = $Tickets_Incidents_Clos->{$tickets_id}->{ReponsibleLastName}." ".$Tickets_Incidents_Clos->{$tickets_id}->{ReponsibleFirstName};
					$worksheet_incident_close->write($row, $col, $agent_name, $format_content);
				} else {
					$worksheet_incident_close->write($row, $col, $Tickets_Incidents_Clos->{$tickets_id}->{$colname}, $format_content);
				}
				$col = $col+1;
			}
		$row = $row+1;
		}
		$worksheet_incident_close->protect( $protect_password);
	# Add a worksheet 'Tickets Changements Ouverts'
	##############################
	my $worksheet_change_open = $workbook->add_worksheet( 'Tickets_Changements_Ouverts' );
		$col = $row = 0;
		foreach my $col_open_size (@col_open_size) {
			$worksheet_change_open->set_column($col, $col, $col_open_size);
			$col = $col+1;
		}
		$col = 0;
		$worksheet_change_open->write_row( 0, 0, $headers_ref_open, $format_header );
		$row = $row+1;
		foreach my $tickets_id ( sort { $a <=> $b } keys %{$Tickets_Changements_Ouverts} ) {
			my $last_action = &mysql_select_row($sql_request_actionticket, $Tickets_Changements_Ouverts->{$tickets_id}->{id});
			$col = 0;
			foreach	my $colname (@sql_colname_open) {
				switch ($colname) {
					case "agent_name" {
						my $agent_name = $Tickets_Changements_Ouverts->{$tickets_id}->{ReponsibleLastName}." ".$Tickets_Changements_Ouverts->{$tickets_id}->{ReponsibleFirstName};
						$worksheet_change_open->write($row, $col, $agent_name, $format_content);
					}
					case "LastAction" {
						$worksheet_change_open->write($row, $col, $last_action->{LastAction}, $format_content);
					}
					case "LastActionDate" {
						$worksheet_change_open->write($row, $col, $last_action->{LastActionDate}, $format_content);
					}
					else {
						$worksheet_change_open->write($row, $col, $Tickets_Changements_Ouverts->{$tickets_id}->{$colname}, $format_content);
					}
				}
				$col = $col+1;
			}
		$row = $row+1;
		}
		$worksheet_change_open->protect( $protect_password);
	# Add a worksheet 'Tickets Changements Fermés'
	##############################
	my $worksheet_change_close = $workbook->add_worksheet( 'Tickets_Changements_Fermés' );
		$col = $row = 0;
		foreach my $col_open_size (@col_close_size) {
			$worksheet_change_close->set_column($col, $col, $col_open_size);
			$col = $col+1;
		}
		$col = 0;
		$worksheet_change_close->write_row( 0, 0, $headers_ref_close, $format_header );
		$row = $row+1;
		foreach my $tickets_id ( sort { $a <=> $b } keys %{$Tickets_Changements_Clos} ) {
			my $last_action = &mysql_select_row($sql_request_actionticket, $Tickets_Changements_Clos->{$tickets_id}->{id});
			$col = 0;
			foreach	my $colname (@sql_colname_close) {
				if ($colname eq 'agent_name') {
					my $agent_name = $Tickets_Changements_Clos->{$tickets_id}->{ReponsibleLastName}." ".$Tickets_Changements_Clos->{$tickets_id}->{ReponsibleFirstName};
					$worksheet_change_close->write($row, $col, $agent_name, $format_content);
				} else {
					$worksheet_change_close->write($row, $col, $Tickets_Changements_Clos->{$tickets_id}->{$colname}, $format_content);
				}
				$col = $col+1;
			}
		$row = $row+1;
		}
		$worksheet_change_close->protect( $protect_password);
	# Add a worksheet 'Tickets Autres Ouverts'
	##############################
	my $worksheet_other_open = $workbook->add_worksheet( 'Tickets_Autres_Ouverts' );
		$col = $row = 0;
		foreach my $col_open_size (@col_open_size) {
			$worksheet_other_open->set_column($col, $col, $col_open_size);
			$col = $col+1;
		}
		$col = 0;
		$worksheet_other_open->write_row( 0, 0, $headers_ref_open, $format_header );
		$row = $row+1;
		foreach my $tickets_id ( sort { $a <=> $b } keys %{$Tickets_Other_Ouverts} ) {
			my $last_action = &mysql_select_row($sql_request_actionticket, $Tickets_Other_Ouverts->{$tickets_id}->{id});
			$col = 0;
			foreach	my $colname (@sql_colname_open) {
				switch ($colname) {
					case "agent_name" {
						my $agent_name = $Tickets_Other_Ouverts->{$tickets_id}->{ReponsibleLastName}." ".$Tickets_Other_Ouverts->{$tickets_id}->{ReponsibleFirstName};
						$worksheet_other_open->write($row, $col, $agent_name, $format_content);
					}
					case "LastAction" {
						$worksheet_other_open->write($row, $col, $last_action->{LastAction}, $format_content);
					}
					case "LastActionDate" {
						$worksheet_other_open->write($row, $col, $last_action->{LastActionDate}, $format_content);
					}
					else {
						$worksheet_other_open->write($row, $col, $Tickets_Other_Ouverts->{$tickets_id}->{$colname}, $format_content);
					}
				}
				$col = $col+1;
			}
		$row = $row+1;
		}
		$worksheet_other_open->protect( $protect_password);
	# Add a worksheet 'Tickets Autres Fermés'
	##############################
	my $worksheet_other_close = $workbook->add_worksheet( 'Tickets_Autres_Fermés' );
		$col = $row = 0;
		foreach my $col_open_size (@col_close_size) {
			$worksheet_other_close->set_column($col, $col, $col_open_size);
			$col = $col+1;
		}
		$col = 0;
		$worksheet_other_close->write_row( 0, 0, $headers_ref_close, $format_header );
		$row = $row+1;
		foreach my $tickets_id ( sort { $a <=> $b } keys %{$Tickets_Other_Clos} ) {
			my $last_action = &mysql_select_row($sql_request_actionticket, $Tickets_Other_Clos->{$tickets_id}->{id});
			$col = 0;
			foreach	my $colname (@sql_colname_close) {
				$worksheet_other_close->write($row, $col, $Tickets_Other_Clos->{$tickets_id}->{$colname}, $format_content);
				$col = $col+1;
			}
		$row = $row+1;
		}
		$worksheet_other_close->protect( $protect_password);
	# Add a worksheet 'Tickets Autres Fermés'
	##############################
	my $worksheet_ticket_count = $workbook->add_worksheet( 'Decompte_Ticket' );
		$col = $row = 0;
		$worksheet_ticket_count->write($row, $col, "Type de changement", $format_header );
		$worksheet_ticket_count->write($row, $col+1, "IMAC consommés (depuis le début du contrat)", $format_header );
		$worksheet_ticket_count->write($row, $col+2, "Nombre d'IMAC restant", $format_header );		
		$worksheet_ticket_count->write($row, $col+3, "Nombre d'IMAC au marché", $format_header );
		$worksheet_ticket_count->set_column($col, $col, '35');
		$worksheet_ticket_count->set_column($col+1, $col+3, '17');
		$row = $row+1;
		print Dumper($Tickets_count);
		$worksheet_ticket_count->write($row, $col, "Changements Mineurs", $format_content);
		$worksheet_ticket_count->write($row, $col+1, $Tickets_count->{"4"}->{"Count"}, $format_content);
		$worksheet_ticket_count->write($row, $col+2, $nb_change_minor-$Tickets_count->{"4"}->{"Count"}, $format_content);
		$worksheet_ticket_count->write($row, $col+3, $nb_change_minor, $format_content);
		$worksheet_ticket_count->write($row+1, $col, "Changements Majeurs", $format_content);
		$worksheet_ticket_count->write($row+1, $col+1, $Tickets_count->{"16"}->{"Count"}, $format_content);
		$worksheet_ticket_count->write($row+1, $col+2, $nb_change_major-$Tickets_count->{"16"}->{"Count"}, $format_content);
		$worksheet_ticket_count->write($row+1, $col+3, $nb_change_major, $format_content);
		$worksheet_ticket_count->protect( $protect_password);
	# Add a worksheet 'CHART-Changements_Mineurs'
	##############################
	my $chart_change_minor = $workbook->add_chart( type => 'pie', name => "CHART-Changements_Mineurs");
	# Configure the series. Note the use of the array ref to define ranges:
	# [ $sheetname, $row_start, $row_end, $col_start, $col_end ].
	$chart_change_minor->add_series(
        name       => 'Changement Mineurs',
        categories => [ 'Decompte_Ticket', 0, 0, 1, 2 ],
        values     => [ 'Decompte_Ticket', 1, 1, 1, 2 ],
        data_labels => {
        	value		 => 1,
        	percentage   => 0,
           	leader_lines => 1,
           	position     => 'best_fit'
        },
        points => [
        	{ fill => { color => '#FF7900' } },
        	{ fill => { color => '#DDDDDD' } },
        ],
    );
    # Add a title.
    $chart_change_minor->set_title( 
        name => 'IMAC Mineurs Consommés',
        name_font => {
        	color => '#FF7900',
        },
    );
	# Add a worksheet 'CHART-Changements_Majeurs'
	##############################
	my $chart_change_major = $workbook->add_chart( type => 'pie', name => "CHART-Changements_Majeurs");
	# Configure the series. Note the use of the array ref to define ranges:
	# [ $sheetname, $row_start, $row_end, $col_start, $col_end ].
	$chart_change_major->add_series(
        name       => 'Changement Majeurs',
        categories => [ 'Decompte_Ticket', 0, 0, 1, 2 ],
        values     => [ 'Decompte_Ticket', 2, 2, 1, 2 ],
        data_labels => {
        	value		 => 1,
        	percentage   => 0,
           	leader_lines => 1,
           	position     => 'best_fit'
        },
        points => [
        	{ fill => { color => '#FF7900' } },
        	{ fill => { color => '#DDDDDD' } },
        ],
    );
    # Add a title.
    $chart_change_major->set_title( 
        name => 'IMAC Majeurs Consommés',
        name_font => {
        	color => '#FF7900',
        },
    );
    # Add a worksheet 'Supervision'
	##############################
	my ($DOWN,$UP,$UNREACHABLE,$UNDETERMINED) = &centreon_stats;
	my @HEADER = ('Statut', 'Temps Total en %', 'Nombre d\'alertes');
	my $headers_supervision = \@HEADER;
	my @DOWN = split(/;/, $DOWN);
	my @UP = split(/;/, $UP);
	my @UNREACHABLE = split(/;/, $UNREACHABLE);
	my @UNDETERMINED = split(/;/, $UNDETERMINED);
	my $worksheet_supervision = $workbook->add_worksheet( 'Supervision' );
	$worksheet_supervision->set_column(0, 2, "40");
	$worksheet_supervision->write_row( 0, 0, $headers_supervision, $format_header );	
	$worksheet_supervision->write(1, 0, "UP", $format_content );
	$worksheet_supervision->write(1, 1, $UP[1], $format_content );
	$worksheet_supervision->write(1, 2, $UP[3], $format_content );
	$worksheet_supervision->write(2, 0, "DOWN", $format_content );
	$worksheet_supervision->write(2, 1, $DOWN[1], $format_content );
	$worksheet_supervision->write(2, 2, $DOWN[3], $format_content );
	$worksheet_supervision->write(3, 0, "UNREACHABLE", $format_content );
	$worksheet_supervision->write(3, 1, $UNREACHABLE[1], $format_content );
	$worksheet_supervision->write(3, 2, $UNREACHABLE[3], $format_content );
	$worksheet_supervision->write(4, 0, "UNDETERMINED", $format_content );
	$worksheet_supervision->write(4, 1, $UNDETERMINED[1], $format_content );
	$worksheet_supervision->write(4, 2, $UNDETERMINED[3], $format_content );
	# Add a worksheet 'CHART-Changements_Majeurs'
	##############################
	my $chart_supervision = $workbook->add_chart( type => 'pie', name => "CHART-Supervision");
	# Configure the series. Note the use of the array ref to define ranges:
	# [ $sheetname, $row_start, $row_end, $col_start, $col_end ].
	$chart_supervision->add_series(
        name       => 'Supervision',
        categories => [ 'Supervision', 1, 4, 0, 0 ],
        values     => [ 'Supervision', 1, 4, 1, 1 ],
        data_labels => {
        	value		 => 0,
        	percentage   => 0,
           	leader_lines => 1,
           	position     => 'best_fit'
        },
        points => [
        	{ fill => { color => '#19EE11' } },
        	{ fill => { color => '#F91E05' } },
        	{ fill => { color => '#DF7401' } },
        	{ fill => { color => '#FFFF00' } },
        ],
    );
    # Add a title.
    $chart_supervision->set_title( 
        name => 'Supervision',
        name_font => {
        	color => '#FF7900',
        },
    );
	$worksheet_supervision->protect( $protect_password);
	# Close Excel File
	$workbook->close();
}

# Function to generate the report
sub generate_report {
	my ($customer_name,$test_only) = (@_);
	print "CustomerName = ".$customer_name."\n" if $verbose;
	print "Test Only = ".$test_only."\n" if $verbose;
	&excel_generation($test_only);
	#exit;
}

# Retreive Centreon Informations
sub centreon_stats {
	my $csv = Text::CSV->new();
	my @csvcontent;
	my $loginpage = &parse_configvars('centreon','centreon.url.login');
	my $username = &parse_configvars('centreon','centreon.username');
	my $password = &parse_configvars('centreon','centreon.password');
	my $csvurlbase = &parse_configvars('centreon','centreon.csv.urlbase');
	my $hostgroupid = &parse_configvars('centreon','centreon.hostgroup.id');
	my $start = DateTime->now(time_zone => 'Europe/Paris')->subtract(days => 1)->set(hour => 0, minute => 0, second => 0);
	my $end   = $start->clone()->add(days => 1);
	print "Start : ".$start->epoch." (".$start.") / End : ".$end->epoch." (".$end.")\n" if $verbose;
	my $SID;
	my ($DOWN,$UP,$UNREACHABLE,$UNDETERMINED);
	print "Login : ".$username." / Password : ".$password."\n";
	my $mech = WWW::Mechanize->new( 
		agent => 'OTRS Report' ,
		autocheck => 1
	);
	$mech->get ($loginpage);
	if ( $mech->success ) {
		print "... Success access login page \n" if $verbose;
		$mech->set_fields(
        	useralias => $username,
        	password => $password,
        );
        $mech->click;
        if ( $mech->content !~ /Invalid user/ ) {
			print "... Success login \n" if $verbose;
			my $cookie_jar = $mech->cookie_jar; # returns a HTTP::Cookies object
			$cookie_jar->scan(sub { $SID = $_[2] });
			print "SID = ".$SID."\n" if $verbose;
			my $csvurl = $csvurlbase."?sid=".$SID."&hostgroup=".$hostgroupid."&start=".$start->epoch."&end=".$end->epoch;
			$mech->get ($csvurl);
			my $output = $mech->content();
			my @lines = split /\n/, $output;
			my $countline = 0;
			foreach my $line (@lines) {
				my @fields = split(/;/, $line);
				switch($countline) {
					# DOWN
					case "4" {
						$DOWN = $line;
					}
					# UP
					case "5" {
						$UP = $line;
					}
					# UNREACHABLE
					case "6" {
						$UNREACHABLE = $line;
					}
					# UNDETERMINED
					case "7" {
						$UNDETERMINED = $line;
					}
				}
				#my @fields = split(/;/, $line);
				print $countline."\t".$line."\n";
				$countline++;
			}
			return($DOWN,$UP,$UNREACHABLE,$UNDETERMINED);
		} else {
			print "CRITICAL - Invalid user\n";
			exit(20);
		}
	}
}

# Retrieve multiple row
sub mysql_select_all {
	my $sql = $_[0];
	my $sqlid = $_[1];
	my $ticket_type = $_[2];
	$sql =~ s/in \(\?\)/in \($ticket_type\)/i;
	print "**************\n SQL DEBUG : ".$sql."\n********************\n" if $verbose;
	my $dbh = DBI->connect( "dbi:mysql:dbname=$database_name;host=$database_host;", $database_username, $database_password ) or &return_code(50,"Unable to access to database $database_name !");
	my $prep = $dbh->prepare($sql) or &return_code(50,$dbh->errstr);
	$prep->execute($customer_name) or &return_code(50,"Echec requête : $sql\n");
	my $sql_result = $prep->fetchall_hashref($sqlid);
	$prep->finish();
	$dbh->disconnect();
	return $sql_result;
}

# Retrieve one row
sub mysql_select_row {
	my $sql = $_[0];
	my $ticketID = $_[1];
	my $dbh = DBI->connect( "dbi:mysql:dbname=$database_name;host=$database_host;", $database_username, $database_password ) or &return_code(50,"Unable to access to database $database_name !");
	my $prep = $dbh->prepare($sql) or &return_code(50,$dbh->errstr);
	$prep->execute($ticketID) or &return_code(50,"Echec requête : ".$sql);
	my $sql_result = $prep->fetchrow_hashref;
	$prep->finish();
	$dbh->disconnect();
	return $sql_result;
}

# Retrieve multiple row
sub mysql_select_count_ticket {
	my $sql = $_[0];
	my $sqlid = $_[1];
	print "**************\n SQL DEBUG : ".$sql."\n********************\n" if $verbose;
	my $dbh = DBI->connect( "dbi:mysql:dbname=$database_name;host=$database_host;", $database_username, $database_password ) or &return_code(50,"Unable to access to database $database_name !");
	my $prep = $dbh->prepare($sql) or &return_code(50,$dbh->errstr);
	$prep->execute($customer_name,$contract_start) or &return_code(50,"Echec requête : $sql\n");
	my $sql_result = $prep->fetchall_hashref($sqlid);
	$prep->finish();
	$dbh->disconnect();
	return $sql_result;
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
$customer_name = &parse_configvars('customer','customer.name');
$contract_start = &parse_configvars('ticket','ticket.start.contract');
&generate_report($customer_name,$test_only) if $configuration_file;
&reportemail;


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
    --configuration
      Specify the customer name like in OTRS
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

=item B<--test>

Only test. No Excel file will be generate

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

B<This program> is use to generate Excel report for OTRS managed by the Orange AIS NSOC.

=head1 RETURN CODE

  Return Code :


=cut
