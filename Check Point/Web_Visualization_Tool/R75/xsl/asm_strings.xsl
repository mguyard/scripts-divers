<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!-- Name resulution template-->
	<xsl:template name="nameResolve">
		<xsl:param name="name"/>
		<xsl:choose>
			<!-- Global or repetetive identifaiers -->
			<xsl:when test="string ($name) = 'Class_Name'">
				<xsl:call-template name="undefinedValue"/>
			</xsl:when>
			<!-- Denial of Service -->
			<xsl:when test="string ($name) = 'Denial of Service'">
				<a>
					<xsl:attribute name="href">asm_help/dos.html</xsl:attribute>Denial of Service</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'tear_drop_protection'">
				<a>
					<xsl:attribute name="href">asm_help/teardrop.html</xsl:attribute>Tear drop</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'tear_drop_protection_global_events_period'">Over a period of... (seconds)</xsl:when>
			<xsl:when test="string ($name) = 'tear_drop_protection_global_events_count'">Events Threshold (count)</xsl:when>
			<xsl:when test="string ($name) = 'ping_of_death_protection'">
				<a>
					<xsl:attribute name="href">asm_help/ping_of_death.html</xsl:attribute>Ping of death</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'land_attack'">
				<a>
					<xsl:attribute name="href">asm_help/land.html</xsl:attribute>LAND Attack</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'land_attack_se'">
				<a>
					<xsl:attribute name="href">asm_help/land.html</xsl:attribute>DoS</a>
			</xsl:when>			
			<xsl:when test="string ($name) = 'non_tcp_flooding'">
				<a>
					<xsl:attribute name="href">asm_help/non_tcp_flooding.html</xsl:attribute>Non TCP Flooding</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'non_tcp_thrash hold'">Events Threshold (percentage) to drop new connections</xsl:when>
			<!-- IP and ICMP -->
			<xsl:when test="string ($name) = 'IP and ICMP'">
				<a>
					<xsl:attribute name="href">asm_help/ip_icmp.html</xsl:attribute>IP and ICMP</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'potential_layer4_DoS_protection'">
				<a>
					<xsl:attribute name="href">asm_help/packet_sanity.html</xsl:attribute>Packet Sanity</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'asm_packet_verify_relaxed_udp'">Disable relaxed UDP length verification</xsl:when>
			<xsl:when test="string ($name) = 'asm_non_tcp_quota_percentage'">@@@</xsl:when>
			<xsl:when test="string ($name) = 'asm_max_ping_limit'">
				<a>
					<xsl:attribute name="href">asm_help/max_ping_size.html</xsl:attribute>Max Ping Size</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'asm_max_ping_limit_size'">Ping size</xsl:when>
			<xsl:when test="string ($name) = 'fw_virtual_defrag'">
				<a>
					<xsl:attribute name="href">asm_help/ip_fragments.html</xsl:attribute>IP Fragments</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'fwfrag_allow'">Forbid IP Fragments</xsl:when>
			<xsl:when test="string ($name) = 'fw_virtual_defrag_max_incomplete_pks'">Maximum number of incomplete Packets</xsl:when>
			<xsl:when test="string ($name) = 'fw_virtual_defrag_descard_packets_after'">Discard incomplete packets after (seconds)</xsl:when>
			<xsl:when test="string ($name) = 'net_quota_protection'">
				<a>
					<xsl:attribute name="href">asm_help/net_quota.html</xsl:attribute>Network Quota</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'net_quota_enabled'">Enabled</xsl:when>
			<xsl:when test="string ($name) = 'net_quota_log_interval'">Track further exceeding connections every... (Seconds)</xsl:when>
			<xsl:when test="string ($name) = 'net_quota_limit'">When exceeding (count) connections per second from the smae source</xsl:when>
			<xsl:when test="string ($name) = 'net_quota_exclusion_list'">Don't apply on the following sources</xsl:when>
			<xsl:when test="string ($name) = 'net_quota_log'">Log</xsl:when>
			<xsl:when test="string ($name) = 'net_quota_timeout'">Drop all further connections from the that source for... (seconds)</xsl:when>
			<!-- TCP -->
			<xsl:when test="string ($name) = 'TCP'">
				<a>
					<xsl:attribute name="href">asm_help/tcp.html</xsl:attribute>TCP</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'SYN_attack_protection'">
				<a>
					<xsl:attribute name="href">asm_help/syn_attack.html</xsl:attribute>Syn Attack Configuration</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'asm_synatk_override_method'">***</xsl:when>
			<xsl:when test="string ($name) = 'asm_synatk'">Activate SYN attack protection</xsl:when>
			<xsl:when test="string ($name) = 'asm_synatk_timeout'">Timeout for SYN attack identification (seconds)</xsl:when>
			<xsl:when test="string ($name) = 'asm_synatk_external_only'">Protect external interface only</xsl:when>
			<xsl:when test="string ($name) = 'asm_synatk_threshold'">Threshold (SYN packet per time out)</xsl:when>
			<xsl:when test="string ($name) = 'asm_synatk_log'">Track</xsl:when>
			<xsl:when test="string ($name) = 'asm_synatk_log_level'">Track level</xsl:when>
			<xsl:when test="string ($name) = 'asm_synatk_global_override'">Override modules' SYNDefender configuration</xsl:when>
			<xsl:when test="string ($name) = 'asm_synatk_override_sessions'">Override sessions</xsl:when>
			<xsl:when test="string ($name) = 'fwsynatk_max'">(Early version SYNDefender) Maximum sessions</xsl:when>
			<xsl:when test="string ($name) = 'fwsynatk_method'">(Early version SYNDefender) Method</xsl:when>
			<xsl:when test="string ($name) = 'fwsynatk_timeout'">(Early version SYNDefender) Timeout</xsl:when>
			<xsl:when test="string ($name) = 'fwsynatk_warning'">(Early version SYNDefender) Display warning messages</xsl:when>
			<xsl:when test="string ($name) = 'small_PMTU_protection'">
				<a>
					<xsl:attribute name="href">asm_help/small_PMTU.html</xsl:attribute>Small PMTU</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'asm_small_pmtu_size'">Minimal MTU size</xsl:when>
			<!-- Spoofed Reset Protection -->
			<xsl:when test="string ($name) = 'tcp_rst_protection'">
				<a>
					<xsl:attribute name="href">asm_help/SpoofedResetConnection.html</xsl:attribute>Spoofed Reset Protection</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'asm_tcp_rst_packets_allowed'">Allow up to RST packets (count)</xsl:when>
			<xsl:when test="string ($name) = 'asm_tcp_rst_duration_to_count'">In a period of (seconds)</xsl:when>
			<xsl:when test="string ($name) = 'asm_tcp_rst_duration_to_drop'">Block further RST packets for a period of (seconds)</xsl:when>
			<xsl:when test="string ($name) = 'asm_tcp_rst_exclude'">Excluded services</xsl:when>
			<!-- Sequence verifaier -->
			<xsl:when test="string ($name) = 'fw_tcp_seq'">
				<a>
					<xsl:attribute name="href">asm_help/seq_verifier.html</xsl:attribute>Sequence Verifier</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'fw_tcp_seq_verify_log_level'">Track out-of-state packets on</xsl:when>
			<!-- Fingerprint scrambling -->
			<xsl:when test="string ($name) = 'Fingerprint Scrambling'">
				<a>
					<xsl:attribute name="href">asm_help/fingerprint.html</xsl:attribute>Fingerprint Scrambling</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'fingerprint_spoofing'">
				<a>
					<xsl:attribute name="href">asm_help/isn.html</xsl:attribute>ISN Spoofing</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'TTL'">
				<a>
					<xsl:attribute name="href">asm_help/ttl.html</xsl:attribute>TTL</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'IP ID'">
				<a>
					<xsl:attribute name="href">asm_help/ipid.html</xsl:attribute>IP ID</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'asm_fp_ipid'">IP id</xsl:when>
			<xsl:when test="string ($name) = 'asm_fp_ipid_mode'">IP ID Sequence generation mode</xsl:when>
			<xsl:when test="string ($name) = 'asm_fp_isn'">ISN</xsl:when>
			<xsl:when test="string ($name) = 'asm_fp_isn_bits'">Minimal ISN entropy (bits)</xsl:when>
			<xsl:when test="string ($name) = 'asm_fp_ttl'">TTL</xsl:when>
			<xsl:when test="string ($name) = 'asm_fp_ttl_threshold'">Qualify packet as traceroute if TTL is under</xsl:when>
			<xsl:when test="string ($name) = 'asm_fp_ttl_tracert'">Do not scramble traceroute packets</xsl:when>
			<xsl:when test="string ($name) = 'asm_fp_ttl_value'">Set TTL to</xsl:when>
			<xsl:when test="string ($name) = 'asm_fp_vpn'">VPN</xsl:when>
			<!-- Successive Events -->
			<xsl:when test="string ($name) = 'Successive Events'">
				<a>
					<xsl:attribute name="href">asm_help/suc_events_global.html</xsl:attribute>Successive Events</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'anti_spoofing_se'">
				<a>
					<xsl:attribute name="href">asm_help/suc_events_anti_spoof.html</xsl:attribute>Address spoofing</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'local_interface_spoofing_se'">
				<a>
					<xsl:attribute name="href">asm_help/suc_events_loc_int.html</xsl:attribute>Local Interface Spoofing</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'successive_alerts_se'">
				<a>
					<xsl:attribute name="href">asm_help/suc_events_suc_alerts.html</xsl:attribute>Successive alerts</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'successive_multiple_connections_se'">
				<a>
					<xsl:attribute name="href">asm_help/suc_events_multi_conn.html</xsl:attribute>Successive multiple connections</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'number_of_repetitions'">Number of events</xsl:when>
			<xsl:when test="string ($name) = 'time_interval'">Over a period of... (seconds)</xsl:when>
			<!-- DShield Strom Cneter -->
			<!-- downstream -->
			<xsl:when test="string ($name) = 'DShield Strom Cneter'">
				<a>
					<xsl:attribute name="href">asm_help/storm_center_general.html
			</xsl:attribute>DShield Strom Cneter</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'storm_center_downstream'">
				<a>
					<xsl:attribute name="href">asm_help/storm_center_downstream.html</xsl:attribute>Retrieve and Block Malicious IPs</a>
			</xsl:when>
			<!-- upstream -->
			<xsl:when test="string ($name) = 'storm_center_upstream'">
				<a>
					<xsl:attribute name="href">asm_help/storm_center_upstream.html</xsl:attribute>Report to DShield</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'sd_upstream_user_name'">E-mail</xsl:when>
			<xsl:when test="string ($name) = 'sd_upstream_internal_net_hide'">Hide internal network</xsl:when>
			<xsl:when test="string ($name) = 'sd_upstream_internal_net_mask'">Using this mask</xsl:when>
			<xsl:when test="string ($name) = 'sd_upstream_submission_day_interval'">Submit logs every (days)</xsl:when>
			<xsl:when test="string ($name) = 'sd_upstream_submission_hour'">Submit logs at (hour)</xsl:when>
			<!-- Port Scan	-->
			<xsl:when test="string ($name) = 'Port Scan'">
				<a>
					<xsl:attribute name="href">asm_help/port_scan.html</xsl:attribute>Port Scan</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'vertical_port_scan'">
				<a>
					<xsl:attribute name="href">asm_help/vert_port_scan.html</xsl:attribute>Host Port Scan</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'horizontal_port_scan'">
				<a>
					<xsl:attribute name="href">asm_help/horizontal_port_scan.html</xsl:attribute>Sweep Scan</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'port_scan_use_predefined_sensitivity'">Detection sensitivity</xsl:when>
			<xsl:when test="string ($name) = 'port_scan_accessed_ports_threshold'">Scan is detected when more then (count) ports</xsl:when>
			<xsl:when test="string ($name) = 'port_scan_scan_time_frame'">are detected over a period of (seconds)</xsl:when>
			<xsl:when test="string ($name) = 'port_scan_detect_external_only'">Detect scans originated be external connection only</xsl:when>
			<xsl:when test="string ($name) = 'port_scan_vertical_use_exclusion_list'">Exclude network objects from detection</xsl:when>
			<xsl:when test="string ($name) = 'port_scan_horizontal_use_exclusion_list'">Exclude specific services from detection</xsl:when>
			<!-- dynamic ports -->
			<xsl:when test="string ($name) = 'Dynamic Ports'">
				<a>
					<xsl:attribute name="href">asm_help/dynamic_ports.html</xsl:attribute>Dynamic Ports</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'check_low_ports'">Block data connections to low ports</xsl:when>
			<xsl:when test="string ($name) = 'ports_check_type'">Dynamic ports protection mode</xsl:when>
			<!-- Application Inteligence - Web -->
			<xsl:when test="string ($name) = 'WEB'">
				<a>
					<xsl:attribute name="href">asm_help/http.html</xsl:attribute>Web</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'general_http_worm_catcher_protection'">
				<a>
					<xsl:attribute name="href">asm_help/http_worm_catcher.html</xsl:attribute>General HTTP worm catcher</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'asm_http_reverse_wc'">Protect reverse direction</xsl:when>
			<xsl:when test="string ($name) = 'web_servers_enforcement'">
				<a>
					<xsl:attribute name="href">asm_help/cross_sites_scripting.html</xsl:attribute>Cross Side Scripting</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'all_web_servers_strip'">Block method for all defined Web Servers</xsl:when>
			<xsl:when test="string ($name) = 'web_servers_cross_sites_log'">Log</xsl:when>
			<xsl:when test="string ($name) = 'HTTP_security_server'">
				<a>
					<xsl:attribute name="href">asm_help/http_sec_server.html</xsl:attribute>HTTP Protocol Inspection</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_valid_on_all'">Configurations apply to all connections</xsl:when>
			<xsl:when test="string ($name) = 'HTTP_security_server'">
				<a>
					<xsl:attribute name="href">asm_help/http_sec_server.html</xsl:attribute>HTTP Protocol Inspection</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_check_request_validity'">
				<a>
					<xsl:attribute name="href">asm_help/http_sec_server1.html</xsl:attribute>ASCII Only Request</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_check_response_validity'">
				<a>
					<xsl:attribute name="href">asm_help/http_sec_server2.html</xsl:attribute>ASCII Only Response</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_max_header_length'">
				<a>
					<xsl:attribute name="href">asm_help/http_format.html</xsl:attribute>Maximum HTTP header length</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_max_header_num'">
				<a>
					<xsl:attribute name="href">asm_help/http_format.html</xsl:attribute>Maximum number of HTTP headers</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_max_request_url_length'">
				<a>
					<xsl:attribute name="href">asm_help/http_format.html</xsl:attribute>Maximum URL length</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_peer_tp_peer'">
				<a>
					<xsl:attribute name="href">asm_help/peer_2_peer.html</xsl:attribute>Peer to peer</a>
			</xsl:when>
			<!-- Mail -->
			<xsl:when test="string ($name) = 'Mail'">
				<a>
					<xsl:attribute name="href">asm_help/smtp_sec_server.html</xsl:attribute>Mail</a>
			</xsl:when>
			<!-- POP3/Imap Security -->
			<xsl:when test="string ($name) = 'mail_servers_enforcement'">
				<a>
					<xsl:attribute name="href">asm_help/pop3_imap_content.html</xsl:attribute>POP3/Imap Security</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'apply_mail_servers_enforcement_on_all'">Apply to all defined mail servers</xsl:when>
			<xsl:when test="string ($name) = 'apply_mail_servers_enforcement_on_selected'">Apply to selected mail servers</xsl:when>
			<xsl:when test="string ($name) = 'block_identical_name_and_pass'">Block identical username and password</xsl:when>
			<xsl:when test="string ($name) = 'mail_server_is_max_username_length'">Enforce username/password maximal length</xsl:when>
			<xsl:when test="string ($name) = 'mail_server_max_username_length'">Username/password maximal length allowed (characters)</xsl:when>
			<xsl:when test="string ($name) = 'mail_server_block_bin_data'">Block binary data in parameters</xsl:when>
			<xsl:when test="string ($name) = 'mail_server_is_max_noop_cmds'">Enforce maximum NOOP commands</xsl:when>
			<xsl:when test="string ($name) = 'mail_server_max_noop_cmds'">Maximum NOOP commands (count)</xsl:when>
			<xsl:when test="string ($name) = 'mail_server_allow_unknown_commands'">Block POP3/IMAP unknown commands</xsl:when>
			<!-- General settings-->
			<xsl:when test="string ($name) = 'SMTP_security_server_general_connections_apply'">
				<a>
					<xsl:attribute name="href">asm_help/smtp_sec_server.html</xsl:attribute>Mail Security Server</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'smtp_valid_on_all'">Configurations apply to all connections</xsl:when>
			<xsl:when test="string ($name) = 'smtp_valid_on_rulebase'">Configurations apply only to connections related to resources used in the Rule base				</xsl:when>
			<!-- SMTP Contents-->
			<xsl:when test="string ($name) = 'smtp_add_received_header'">Add "received" header when forwarding</xsl:when>
			<xsl:when test="string ($name) = 'smtp_log_unknown_commands'">Send log for unknown SMTP commands</xsl:when>
			<xsl:when test="string ($name) = 'smtp_check_bad_commands'">Watch for bad SMTP commands</xsl:when>
			<xsl:when test="string ($name) = 'smtp_log_too_many_commands'">Send log when dropping connection</xsl:when>
			<xsl:when test="string ($name) = 'smtp_max_allowed_err_commands'">Maximum unknown commands</xsl:when>
			<xsl:when test="string ($name) = 'smtp_max_allowed_nop_commands'">Maximum no-effect commands</xsl:when>
			<xsl:when test="string ($name) = 'SMTP_security_server'">
				<a>
					<xsl:attribute name="href">asm_help/smtp_content.html</xsl:attribute>SMTP Content</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'smtp_multi_cont_type'">Block multiple "content-type" headers</xsl:when>
			<xsl:when test="string ($name) = 'smtp_multi_encoding'">Block multiple "encoding" headers</xsl:when>
			<xsl:when test="string ($name) = 'smtp_composite_encoding'">Block non-plain "encoding" headers</xsl:when>
			<xsl:when test="string ($name) = 'smtp_unknown_encoding'">Forbid unknown encoding</xsl:when>
			<xsl:when test="string ($name) = 'smtp_force_recipient_domain'">Force recipient to have domain name</xsl:when>
			<xsl:when test="string ($name) = 'smtp_direct_mime_strip'">Perform aggressive MIME type</xsl:when>
			<xsl:when test="string ($name) = 'Mail and Recipient content'">
				<a>
					<xsl:attribute name="href">asm_help/mail_content.html</xsl:attribute>Mail and Recipient content</a>
			</xsl:when>
			<!-- FTP -->
			<xsl:when test="string ($name) = 'FTP'">
				<a>
					<xsl:attribute name="href">asm_help/ftp.html</xsl:attribute>FTP</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'ftp_bounce_protection'">
				<a>
					<xsl:attribute name="href">asm_help/ftp_bounce.html</xsl:attribute>FTP Bounce</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'FTP_Security_Server'">
				<a>
					<xsl:attribute name="href">asm_help/ftp_sec_server.html</xsl:attribute>FTP Security Server</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'ftp_allowed_cmds'">
				<a>
					<xsl:attribute name="href">asm_help/ftp_cmds.html</xsl:attribute>Acceptable commands</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'ftp_unallowed_cmds'">
				<a>
					<xsl:attribute name="href">asm_help/ftp_cmds.html</xsl:attribute>Blocked commands</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'ftp_dont_check_cmd_vals'">
				<a>
					<xsl:attribute name="href">asm_help/ftp_sec_server1.html</xsl:attribute>Block Known Ports</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'ftp_dont_check_random_port'">
				<a>
					<xsl:attribute name="href">asm_help/ftp_sec_server2.html</xsl:attribute>Block Port Overflow</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'ftp_valid_on_all'">Valid on all</xsl:when>
			<!-- Microsoft Networks -->
			<xsl:when test="string ($name) = 'Microsoft Networks'">
				<a>
					<xsl:attribute name="href">asm_help/ms_protocols.html</xsl:attribute>Microsoft Networks</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'asm_cifs_proto_verf_log_only'">Strict CIFS protocol correctness enforcement</xsl:when>
			<xsl:when test="string ($name) = 'ms_protocols_valid_on_all'">Configuration apply to all connections</xsl:when>
			<xsl:when test="string ($name) = 'ms_protocols_valid_on_all_not'">Configuration apply only to connections related to resources used in the Rule Base</xsl:when>
			<xsl:when test="string ($name) = 'ms_file_and_print_sharing'">
				<a>
					<xsl:attribute name="href">asm_help/cifs_worm_catcher.html</xsl:attribute>File and Print Sharing</a>
			</xsl:when>
			<!--Peer to Peer -->
			<xsl:when test="string ($name) = 'Peer to Peer'">
				<a>
					<xsl:attribute name="href">asm_help/peertopeer.html</xsl:attribute>Peer to Peer</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'p2p_exclude_ports'">Exclude specific services from peer to peer detection</xsl:when>
			<xsl:when test="string ($name) = 'p2p_exclude_hosts'">Exclude network objects from peer to peer detection</xsl:when>
			<xsl:when test="string ($name) = 'p2p_enforce_protocol'">Block proprietary protocols on all ports</xsl:when>
			<!-- Instant Messengers -->
			<xsl:when test="string ($name) = 'Instant Messengers'">
				<a>
					<xsl:attribute name="href">asm_help/instant_messengers.html</xsl:attribute>Instant Messengers</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'instant_msg_exclude_ports'">Exclude specific services from Instant Messengers detection</xsl:when>
			<xsl:when test="string ($name) = 'instant_msg_exclude_hosts'">Exclude network objects from Instant Messengers detection</xsl:when>
			<!-- msn_msnms -->
			<xsl:when test="string ($name) = 'msn_msnms'">
				<a>
					<xsl:attribute name="href">asm_help/msn_msnms.html</xsl:attribute>MSN Messenger over MSNMS</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'msnms_block_video'">Block video</xsl:when>
			<xsl:when test="string ($name) = 'msnms_block_audio'">Block audio</xsl:when>
			<xsl:when test="string ($name) = 'msnms_block_file_transfer'">Block file transfer</xsl:when>
			<xsl:when test="string ($name) = 'msnms_block_application_sharing'">Block application sharing</xsl:when>
			<xsl:when test="string ($name) = 'msnms_block_white_board'">Block white board</xsl:when>
			<xsl:when test="string ($name) = 'msnms_block_remote_assistant'">Block remote assistant</xsl:when>
			<!-- MSN SIP	-->
			<xsl:when test="string ($name) = 'msn_sip'">
				<a>
					<xsl:attribute name="href">asm_help/msn_sip.html</xsl:attribute>MSN Messenger over SIP</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'sip_block_file_transfer'">Block file transfer</xsl:when>
			<xsl:when test="string ($name) = 'sip_block_application_sharing'">Block application sharing</xsl:when>
			<xsl:when test="string ($name) = 'sip_block_white_board'">Block white board</xsl:when>
			<xsl:when test="string ($name) = 'sip_block_remote_assistant'">Block remote assistant</xsl:when>
			<!-- ===
  				  DNS
			     === -->
			<xsl:when test="string ($name) = 'DNS'">
				<a>
					<xsl:attribute name="href">asm_help/dns_general.html</xsl:attribute>DNS</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'fw_dns_verification'">UDP Protocol enforcement</xsl:when>
			<xsl:when test="string ($name) = 'fw_dns_tcp_verification'">TCP protocol enforcement</xsl:when>
			<xsl:when test="string ($name) = 'DNS'">
				<a>
					<xsl:attribute name="href">asm_help/dns_general.html</xsl:attribute>DNS</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'dns_black_list'">
				<a>
					<xsl:attribute name="href">asm_help/dns_black_list.html</xsl:attribute>Domains block list</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'domains_black_list'">Drop all DNS requests for the following domains</xsl:when>
			<xsl:when test="string ($name) = 'Cache Poisoning'">
				<a>
					<xsl:attribute name="href">asm_help/dns_poisoning.html</xsl:attribute>Cache Poisoning</a>
			</xsl:when>
			<!-- Scrambling -->
			<xsl:when test="string ($name) = 'enforce_dns_randomization'">
				<a>
					<xsl:attribute name="href">asm_help/dns_randomization.html</xsl:attribute>Scrambling</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'specific_dns_servers'">Apply to selected DNS Servers</xsl:when>
			<xsl:when test="string ($name) = 'all_dns_traffic'">Apply to all DNS traffic</xsl:when>
			<!-- drop inbound request -->
			<xsl:when test="string ($name) = 'dns_drop_external_domain_request'">
				<a>
					<xsl:attribute name="href">asm_help/dns_drop_ext_req.html</xsl:attribute>Drop inbound requests</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'dns_drop_external_domain_reques_which_servers'">Apply to selected DNS Servers</xsl:when>
			<!-- Mismatched Replies -->
			<xsl:when test="string ($name) = 'dns_mismatched_replies'">
				<a>
					<xsl:attribute name="href">asm_help/dns_mismatched_replies.html</xsl:attribute>Mismatched Replies</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'mismatched_replies_threshold'">Detect mismatched replies when more then (count) mismatched replies were detected</xsl:when>
			<xsl:when test="string ($name) = 'mismatched_replies_threshold_expiry'">over a period of (seconds)</xsl:when>
			<!--	====
				   VoIP
				   ====	  -->
			<!-- voip general -->
			<xsl:when test="string ($name) = 'VoIP'">
				<a>
					<xsl:attribute name="href">asm_help/voip.html</xsl:attribute>VoIP</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'voip_enforce_dos_protection'">Enable VoIP DoS Protection</xsl:when>
			<xsl:when test="string ($name) = 'voip_user_calls_per_minute'">Allow up (count) call attempts per IP (per minute)</xsl:when>
			<!-- H232-->
			<xsl:when test="string ($name) = 'fw_h323_enforcement'">
				<a>
					<xsl:attribute name="href">asm_help/h323.html</xsl:attribute>H232</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'fwh323_allow_redirect'">Block connections re-direction</xsl:when>
			<xsl:when test="string ($name) = 'fwh323_force_src_phone'">Prevent blank phone numbers for gatekeeper connections</xsl:when>
			<xsl:when test="string ($name) = 'allow_h323_t120'">Disable dynamic T.120</xsl:when>
			<xsl:when test="string ($name) = 'allow_h323_h245_tunneling'">Block H.245 tunneling</xsl:when>
			<xsl:when test="string ($name) = 'allow_h323_through_ras'">Disable dynamic opening of H.232 connection from RAS messages</xsl:when>
			<xsl:when test="string ($name) = 'h323_enforce_setup '">Drop H.232 calls that do not start with a SETUP message</xsl:when>
			<xsl:when test="string ($name) = 'h323_t120_timeout'">T.120 timeout</xsl:when>
			<!-- SIP-->
			<xsl:when test="string ($name) = 'fwsip_header_content_enforcement'">
				<a>
					<xsl:attribute name="href">asm_help/sip.html</xsl:attribute>SIP</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'sip_allow_redirect Off'">Block calls using a proxy or a redirect server</xsl:when>
			<xsl:when test="string ($name) = 'sip_reg_default_expiration'">Default proxy registration expiration time period (seconds)</xsl:when>
			<xsl:when test="string ($name) = 'sip_enforce_security_reinvite'">Block the destination from re-inviting calls</xsl:when>
			<xsl:when test="string ($name) = 'sip_max_reinvite'">Maximum invitations per call (from both direction)</xsl:when>
			<xsl:when test="string ($name) = 'sip_block_video'">Block SIP-based video</xsl:when>
			<xsl:when test="string ($name) = 'sip_allow_two_media_conns'">Block SIP calls that use two different voice connections (RTP) for incoming audio and outgoing video</xsl:when>
			<xsl:when test="string ($name) = 'sip_block_audio'">Block SIP based audio</xsl:when>
			<xsl:when test="string ($name) = 'sip_allow_instant_messages'">Block SIP-based Instant Messaging</xsl:when>
			<xsl:when test="string ($name) = 'sip_accept_unknown_messages'">Drop unknown SIP messages</xsl:when>
			<!-- MGCP-->
			<xsl:when test="string ($name) = 'fw_mgcp_enforcement'">
				<a>
					<xsl:attribute name="href">asm_help/mgcp.html</xsl:attribute>MGCP</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'mgcp_command_accepted_true'">Allowd Commands</xsl:when>
			<xsl:when test="string ($name) = 'mgcp_command_accepted_false'">Blocked Commands</xsl:when>
			<!-- SCCP (Skinny)-->
			<xsl:when test="string ($name) = 'fw_skinny_enforcement'">
				<a>
					<xsl:attribute name="href">asm_help/skinny.html</xsl:attribute>SCCP (Skinny)</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'fwsip_header_content_verification'">Content verification</xsl:when>
			<!--=======
				  SNMP 
			    ======
			    -->
			<xsl:when test="string ($name) = 'SNMP'">
				<a>
					<xsl:attribute name="href">asm_help/snmp.html</xsl:attribute>SNMP</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'snmp_allow_only_snmpv3'">Content verification</xsl:when>
			<xsl:when test="string ($name) = 'snmp_allow_only_snmpv3_true'">Allow all SNMP traffic</xsl:when>
			<xsl:when test="string ($name) = 'snmp_allow_only_snmpv3_false'">Allow only SNMPv3 traffic</xsl:when>
			<xsl:when test="string ($name) = 'snmp_drop_default_communities'">Drop requests with default community strings for SNMPv1 and SNMPv2</xsl:when>
			<!-- VPN Protocols -->
			<xsl:when test="string ($name) = 'VPN Protocols'">
				<a>
					<xsl:attribute name="href">asm_help/vpn-prot.html</xsl:attribute>VPN Protocols</a>
			</xsl:when>
			<!-- SSH -->
			<xsl:when test="string ($name) = 'SSH'">
				<a>
					<xsl:attribute name="href">asm_help/ssh.html</xsl:attribute>SSH</a>
			</xsl:when>
			<!-- Content Protection-->
			<xsl:when test="string ($name) = 'Content Protection'">
				<a>
					<xsl:attribute name="href">asm_help/content_prot.html</xsl:attribute>Content Protection</a>
			</xsl:when>
			<!-- MS-RPC -->
			<xsl:when test="string ($name) = 'MS-RPC'">
				<a>
					<xsl:attribute name="href">asm_help/ms-rpc.html</xsl:attribute>MS-RPC</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'skinny_hdr_content_verifier'">Verify SCCP headers content</xsl:when>
			<xsl:when test="string ($name) = 'fw_skinny_allow_multicast'">Drop multicast RTP connection</xsl:when>
			<!-- MS-SQL -->
			<xsl:when test="string ($name) = 'MS-SQL'">
				<a>
					<xsl:attribute name="href">asm_help/ms-sql.html</xsl:attribute>MS-SQL</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'Application Intelligence'">Application Intelligence updates</xsl:when>
			<!--SOCKS -->
			<xsl:when test="string ($name) = 'SOCKS'">
				<a>
					<xsl:attribute name="href">asm_help/socks.html</xsl:attribute>SOCKS</a>
			</xsl:when>
			<!-- Routing Protocols -->
			<xsl:when test="string ($name) = 'Routing Protocols'">
				<a>
					<xsl:attribute name="href">asm_help/routing.html</xsl:attribute>Routing Protocols</a>
			</xsl:when>
			<!--DHCP -->
			<xsl:when test="string ($name) = 'DHCP'">
				<a>
					<xsl:attribute name="href">asm_help/dhcp.html</xsl:attribute>DHCP</a>
			</xsl:when>
			<!--SUN-RPC -->
			<xsl:when test="string ($name) = 'SUN-RPC'">
				<a>
					<xsl:attribute name="href">asm_help/routing.html</xsl:attribute>SUN-RPC</a>
			</xsl:when>
			<!-- Remote Control Applications  -->
			<xsl:when test="string ($name) = 'Remote Control Applications'">
				<a>
					<xsl:attribute name="href">asm_help/remote_control.html</xsl:attribute>Remote Control Applications</a>
			</xsl:when>
			<!-- Remote Administrator  -->
			<xsl:when test="string ($name) = 'Remote Administrator'">
				<a>
					<xsl:attribute name="href">asm_help/remote_admin.html</xsl:attribute>Remote Administrator</a>
			</xsl:when>
			<!-- WEB INTELLIGENSE -->
			<!-- Web Servers View  -->
			<xsl:when test="string ($name) = 'Web Servers View'">
				<a>
					<xsl:attribute name="href">asm_help/http.html</xsl:attribute>Web Servers View</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_apply_worm_catcher_on_all'">Apply to all HTTP traffic</xsl:when>
			<xsl:when test="string ($name) = 'http_apply_worm_catcher_on_specific'">Apply to selected web servers</xsl:when>
			<xsl:when test="string ($name) = 'Malicious Code'">
				<a>
					<xsl:attribute name="href">asm_help/http_worm_catcher.html</xsl:attribute>Malicious Code</a>
			</xsl:when>
			<!-- HTTP error code page -->
			<xsl:when test="string ($name) = 'enable_redirect_url_false'">Send a pre defined HTML error page</xsl:when>
			<xsl:when test="string ($name) = 'enable_company_logo_url'">Show Logo</xsl:when>
			<xsl:when test="string ($name) = 'company_logo_url'">Logo URL</xsl:when>
			<xsl:when test="string ($name) = 'show_error_id'">Show error code</xsl:when>
			<xsl:when test="string ($name) = 'http_enable_error_response_code'">Send detailed status code</xsl:when>
			<xsl:when test="string ($name) = 'description'">Description</xsl:when>
			<xsl:when test="string ($name) = 'enable_redirect_url_true'">Redirect to other URL</xsl:when>
			<xsl:when test="string ($name) = 'redirect_url'">URL for redirection</xsl:when>
			<xsl:when test="string ($name) = 'send_error_id'">Send error code</xsl:when>
			<!-- general code protector -->
			<xsl:when test="string ($name) = 'http_buffer_overflow'">
				<a>
					<xsl:attribute name="href">asm_help/malicious_code_protector.html</xsl:attribute>Malicious Code Protector</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_buffer_overflow_level'">Security Level</xsl:when>
			<xsl:when test="string ($name) = 'http_buffer_overflow_send_error'">Send error page</xsl:when>
			<xsl:when test="string ($name) = 'buffer_overflow_disasm_anchor'">Search Method</xsl:when>
			<xsl:when test="string ($name) = 'buffer_overflow_optimize_memory'">Memory Consumption and Speed</xsl:when>
			<!-- Application layer -->
			<xsl:when test="string ($name) = 'Application Layer'">
				<a>
					<xsl:attribute name="href">asm_help/app_layer.html</xsl:attribute>Application Layer</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_enforce_cross_sites_scripting'">
				<a>
					<xsl:attribute name="href">asm_help/cross_sites_scripting.html</xsl:attribute>Cross Site Scripting</a>
			</xsl:when>
			<!-- LDAP Injection -->
			<xsl:when test="string ($name) = 'http_ldap_injection'">
				<a>
					<xsl:attribute name="href">asm_help/ldapInjection.html</xsl:attribute>LDAP Injection</a>
			</xsl:when>
			<!-- SQL Injection -->
			<xsl:when test="string ($name) = 'http_sql_injection'">
				<a>
					<xsl:attribute name="href">asm_help/sqlInjection.html</xsl:attribute>SQL Injection</a>
			</xsl:when>
			<!-- command_stealth -->
			<xsl:when test="string ($name) = 'http_command_stealth'">
				<a>
					<xsl:attribute name="href">asm_help/command_stealth.html</xsl:attribute>Command Injection</a>
			</xsl:when>
			<!--  Directory Traversal-->
			<xsl:when test="string ($name) = 'http_dir_traversal'">
				<a>
					<xsl:attribute name="href">asm_help/directory_traversal.html</xsl:attribute>Directory Traversal</a>
			</xsl:when>
			<!-- 	======================
						Information Disclosure
						======================	 -->
			<xsl:when test="string ($name) = 'Information Disclosure'">
				<a>
					<xsl:attribute name="href">asm_help/info_disclosure.html</xsl:attribute>Information Disclosure</a>
			</xsl:when>
			<!-- Header Spoofing -->
			<xsl:when test="string ($name) = 'http_generic_header_spoofing'">
				<a>
					<xsl:attribute name="href">asm_help/header_spoofing.html</xsl:attribute>Header Spoofing</a>
			</xsl:when>
			<!-- directory listing -->
			<xsl:when test="string ($name) = 'http_directory_listing'">
				<a>
					<xsl:attribute name="href">asm_help/directorylisting.html</xsl:attribute>Directory Listing</a>
			</xsl:when>
			<!-- Error Concealment -->
			<xsl:when test="string ($name) = 'http_error_concealment'">
				<a>
					<xsl:attribute name="href">asm_help/errorconcealment.html</xsl:attribute>Error Concealment</a>
			</xsl:when>
			<!-- =========================
				   HTTP Protocol Inspection 
				   ==========================  -->
			<xsl:when test="string ($name) = 'HTTP Protocol Inspection'">
				<a>
					<xsl:attribute name="href">asm_help/http_sec_server.html</xsl:attribute>HTTP Protocol Inspection</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_valid_on_all_active'">Use Early Version Configuration (NG AI R55 and earlier)</xsl:when>
			<xsl:when test="string ($name) = 'http_strict_request_parsing'">Enforce strict HTTP request parsing</xsl:when>
			<xsl:when test="string ($name) = 'http_strict_response_parsing'">Enforce strict HTTP response parsing</xsl:when>
			<xsl:when test="string ($name) = 'http_split_query_fragment_section'">Split the URL between the query and fragment sections</xsl:when>
			<!-- HTTP Format Sizes -->
			<xsl:when test="string ($name) = 'http_apply_format'">
				<a>
					<xsl:attribute name="href">asm_help/http_format.html</xsl:attribute>HTTP Format Sizes</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_enforce_max_url_length'">Enforce Max URL Length</xsl:when>
			<xsl:when test="string ($name) = 'http_enforce_max_header_length'">Enforce Max Header Length</xsl:when>
			<xsl:when test="string ($name) = 'http_enforce_max_num_of_http_headers'">Enforce Max number of headres</xsl:when>
			<xsl:when test="string ($name) = 'http_enforce_max_request_body_length'">Enforce Max request body langthe</xsl:when>
			<xsl:when test="string ($name) = 'http_max_request_body_length'">Max request body length</xsl:when>
			<!-- Ascii Only Request-->
			<xsl:when test="string ($name) = 'http_check_request'">
				<a>
					<xsl:attribute name="href">asm_help/http_sec_server1.html</xsl:attribute>ASCII Only Request</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_check_request_form_fields'">Block non ASCII characters in form fields</xsl:when>
			<!-- Ascii Only Response Headers-->
			<xsl:when test="string ($name) = 'http_check_response'">
				<a>
					<xsl:attribute name="href">asm_help/http_sec_server2.html</xsl:attribute>ASCII Only Response Headers</a>
			</xsl:when>
			<!-- Headers Rejection-->
			<xsl:when test="string ($name) = 'http_header_rejection'">
				<a>
					<xsl:attribute name="href">asm_help/peer_2_peer.html</xsl:attribute>Headers Rejection</a>
			</xsl:when>
			<!-- HTTP Methods -->
			<xsl:when test="string ($name) = 'http_allowed_method'">
				<a>
					<xsl:attribute name="href">asm_help/httpmethods.html</xsl:attribute>HTTP Methods</a>
			</xsl:when>
			
			<xsl:when test="string ($name) = 'HTTP Protocol Inspection'">
				<a>
					<xsl:attribute name="href">asm_help/http_sec_server.html</xsl:attribute>HTTP Protocol Inspection</a>
			</xsl:when>
			<!-- Dynamic Methods -->
			<xsl:when test="string ($name) = 'WebDefense;HTTP Protocol Inspection'">
				<a>
					<xsl:attribute name="href">asm_help/http_sec_server.html</xsl:attribute>HTTP Protocol Inspection</a>
			</xsl:when>
			
			<!-- Not found... -->
			<xsl:otherwise>
				<xsl:value-of select="$name"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
</xsl:stylesheet>
