<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:strip-space elements="*"/>
	<!--link to objects -->
	<xsl:variable name="network_objects" select="document('network_objects.xml')/network_objects"/>
	<xsl:variable name="services" select="document('services.xml')/services"/>
	<xsl:variable name="communities" select="document('communities.xml')/communities"/>
	<xsl:variable name="users" select="document('users.xml')/users"/>
	<xsl:variable name="security_relebase" select="document('Security_Policy.xml')/fw_policies"/>
	<xsl:variable name="nat_rulebase" select="document('NAT_Policy.xml')/fw_policies"/>
	<!--xsl:variable name="smart_defense" select="document('asm.xml')/asm"/-->
	<!--Templates -->
	<xsl:template name="net_obj_ref">
		<xsl:param name="reference"/>
		<xsl:param name="negate"/>
		<div class="refObject" nowrap="true">
			<xsl:choose>
				<xsl:when test="$reference/Table = 'network_objects'">
					<xsl:if test="$negate">Not </xsl:if>
					<a>
						<xsl:attribute name="href">#network_object_<xsl:value-of select="$reference/Name"/></xsl:attribute>
						<xsl:value-of select="$reference/Name"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$reference/Name"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<xsl:template name="service_ref">
		<xsl:param name="reference"/>
		<xsl:param name="negate"/>
		<div class="refObject" nowrap="true">
			<xsl:choose>
				<xsl:when test="$reference/Table = 'services'">
					<xsl:if test="$negate">Not </xsl:if>
					<a>
						<xsl:attribute name="href">#service_<xsl:value-of select="$reference/Name"/></xsl:attribute>
						<xsl:value-of select="$reference/Name"/>
					</a>
				</xsl:when>
				<xsl:otherwise>
					<xsl:value-of select="$reference/Name"/>
				</xsl:otherwise>
			</xsl:choose>
		</div>
	</xsl:template>
	<!-- Security rulebase template -->
	<xsl:template name="security_policy_template">
		<xsl:param name="relebase"/>
		<br/>
		<!-- start table header -->
		<xsl:variable name="tableHeadLink">
			<xsl:value-of select="generate-id($relebase)"/>
		</xsl:variable>
		<a name="{$tableHeadLink}"/>
		<TABLE class="data" cellSpacing="0" cellPadding="0" width="90%" align="center" borders="none">
			<TBODY>
				<TR>
					<TD class="title">Security Policy: <xsl:value-of select="substring($relebase/Name,3)"/>
					</TD>
				</TR>
				<TR>
					<TD>
						<TABLE cellSpacing="0" cellPadding="1" width="100%" borders="0">
							<TBODY>
								<TR class="header">
									<td class="rule_header">NO.</td>
									<td class="rule_header">NAME</td>
									<td class="rule_header">SOURCE</td>
									<td class="rule_header">DESTINATION</td>
									<xsl:if test="$relebase/use_VPN_communities = 'true'">
										<td class="rule_header">VPN&#160;&#160;</td>
									</xsl:if>
									<td class="rule_header">SERVICE</td>
									<td class="rule_header">ACTION</td>
									<td class="rule_header">TRACK</td>
									<td class="rule_header">INSTALL ON</td>
									<td class="rule_header">TIME</td>
									<td class="rule_header">COMMENT</td>
								</TR>
								<!-- Start Iterator -->
								<xsl:for-each select="$relebase/rule/rule">
									<!-- writes the group header -->
									<xsl:choose>
										<xsl:when test="normalize-space(./header_text) != ''">
											<tr class="even_data_row">
												<td colspan="10" vAlign="top" class="sectionTitle">
													<xsl:value-of select="./header_text"/>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<!--writes the rule itself -->
											<tr class="odd_data_row">
												<xsl:if test="number(Rule_Number) mod 2 = 0">
													<xsl:attribute name="class">even_data_row</xsl:attribute>
												</xsl:if>
												<td class="numberCol" vAlign="top">
													<!--change the color of the rule number if the rule is disabled. -->
													<xsl:if test="./disabled = 'true'">
														<xsl:attribute name="style">color: FF0000;</xsl:attribute>
														<font size="1">Disabled</font>
														<br/>
													</xsl:if>
													<!-- rule number -->
													<xsl:value-of select="Rule_Number"/>
												</td>
												<td>
													<xsl:value-of select="name"/>
												</td>
												<!--source -->
												<td vAlign="top">
													<xsl:for-each select="./src/members/reference">
														<xsl:call-template name="net_obj_ref">
															<xsl:with-param name="reference" select="."/>
															<xsl:with-param name="negate" select="../../op='not in'"/>
														</xsl:call-template>
													</xsl:for-each>
													<xsl:for-each select="./src/compound/compound">
														<xsl:if test="../../op='not in'">Not </xsl:if>
														<a>
															<xsl:if test="Class_Name = 'rule_user_group'">
																<xsl:attribute name="href">#user_<xsl:value-of select="substring-before(Name,'@')"/></xsl:attribute>
															</xsl:if>
															<xsl:value-of select="substring-before(Name,'@')"/>
														</a>@<a>
															<xsl:if test="at/Table = 'network_objects'">
																<xsl:attribute name="href">#network_object_<xsl:value-of select="substring-after(Name,'@')"/></xsl:attribute>
															</xsl:if>
															<xsl:value-of select="substring-after(Name,'@')"/>
														</a>
														<br/>
													</xsl:for-each>
												</td>
												<!--destination -->
												<td vAlign="top">
													<xsl:for-each select="./dst/members/reference">
														<xsl:call-template name="net_obj_ref">
															<xsl:with-param name="reference" select="."/>
															<xsl:with-param name="negate" select="../../op='not in'"/>
														</xsl:call-template>
													</xsl:for-each>
												</td>
												<!--If via -->
												<xsl:if test="$relebase/use_VPN_communities = 'true'">
													<td vAlign="top">
														<xsl:for-each select="./through/through">
															<xsl:value-of select="Name"/>
														</xsl:for-each>
													</td>
												</xsl:if>
												<!--service -->
												<td vAlign="top">
													<xsl:for-each select="./services/members/reference">
														<xsl:call-template name="service_ref">
															<xsl:with-param name="reference" select="."/>
															<xsl:with-param name="negate" select="../../op='not in'"/>
														</xsl:call-template>
													</xsl:for-each>
													<xsl:for-each select="./services/compound/compound">
														<xsl:if test="../../op='not in'">Not </xsl:if>
														<xsl:value-of select="Name"/>
													</xsl:for-each>
												</td>
												<!--action -->
												<td vAlign="top">
													<xsl:for-each select="./action/action">
														<div class="refObject" nowrap="true">
															<xsl:choose>
																<xsl:when test="type = 'accept'">
																	<xsl:attribute name="style">color:green;</xsl:attribute>
																</xsl:when>
																<xsl:when test="type = 'drop' or type = 'reject'">
																	<xsl:attribute name="style">color:red;</xsl:attribute>
																</xsl:when>
																<xsl:when test="type = 'auth_client' or type = 'auth_session' or type = 'auth_user'">
																	<xsl:attribute name="style">color:blue;</xsl:attribute>
																</xsl:when>
																<xsl:when test="type = 'encrypt' or type = 'userc'">
																	<xsl:attribute name="style">color:purple;</xsl:attribute>
																</xsl:when>
															</xsl:choose>
															<xsl:value-of select="Name"/>
														</div>
													</xsl:for-each>
												</td>
												<!--track -->
												<td vAlign="top">
													<xsl:for-each select="./track/track">
														<xsl:value-of select="Name"/>
														<br/>
													</xsl:for-each>
												</td>
												<!--Install On -->
												<td vAlign="top">
													<xsl:for-each select="./install/members/reference">
														<xsl:call-template name="net_obj_ref">
															<xsl:with-param name="reference" select="."/>
														</xsl:call-template>
													</xsl:for-each>
												</td>
												<!--time -->
												<td vAlign="top">
													<xsl:for-each select="./time/time">
														<xsl:value-of select="Name"/>
														<br/>
													</xsl:for-each>
												</td>
												<!--comments -->
												<td vAlign="top" style="BORDER-RIGHT: #e5e5e5 1px solid;">
												     
													<xsl:value-of select="comments"/>&#160;
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
								<!-- End Iterator -->
								<TR>
									<TD class="last" align="right" colSpan="10">
										<DIV class="divStyle" align="center">
											<A class="back" href="#{$tableHeadLink}">Top of table</A> | <A class="back" href="#topOfPage">Top of page</A>
										</DIV>
									</TD>
								</TR>
							</TBODY>
						</TABLE>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
		<BR/>
		<BR/>
	</xsl:template>
	<!-- End new Rulebase -->
	<!-- Start new NAT policy -->
	<xsl:template name="nat_policy_template">
		<xsl:param name="relebase"/>
		<br/>
		<!-- start table header -->
		<xsl:variable name="NATtableHeadLink">
			<xsl:value-of select="generate-id($relebase)"/>
		</xsl:variable>
		<a name="{$NATtableHeadLink}"/>
		<TABLE class="data" cellSpacing="0" cellPadding="0" align="center" borders="none">
			<TBODY>
				<TR>
					<TD class="title">Address Translation Policy: <xsl:value-of select="substring($relebase/Name,3)"/>
					</TD>
				</TR>
				<TR>
					<TD>
						<TABLE cellSpacing="0" cellPadding="1" width="100%" borders="0">
							<TBODY>
								<tr class="header">
									<td vAlign="middle" class="rule_header" rowspan="2">NO.</td>
									<td class="rule_header" style="text-align:center;" colspan="3">ORIGINAL PACKET</td>
									<td class="rule_header" style="text-align:center;" colspan="3">TRANSLATED PACKET</td>
									<td valign="middle" class="rule_header" rowspan="2">INSTALL ON</td>
									<td valign="middle" class="rule_header" rowspan="2">COMMENT</td>
								</tr>
								<tr class="header">
									<td class="rule_header_nat">SOURCE</td>
									<td class="rule_header_nat">DESTINATION</td>
									<td class="rule_header_nat">SERVICE</td>
									<td class="rule_header_nat">SOURCE</td>
									<td class="rule_header_nat">DESTINATION</td>
									<td class="rule_header_nat">SERVICE</td>
								</tr>
								<!-- Start Iterator -->
								<xsl:for-each select="$relebase/rule_adtr/rule_adtr">
									<!-- writes the group header -->
									<xsl:choose>
										<xsl:when test="normalize-space(./header_text) != ''">
											<tr class="even_data_row">
												<td colspan="10" vAlign="top" class="sectionTitle">
													<xsl:value-of select="./header_text"/>
												</td>
											</tr>
										</xsl:when>
										<xsl:otherwise>
											<!--writes the rule itself -->
											<tr class="odd_data_row">
												<xsl:if test="position() mod 2 = 0">
													<xsl:attribute name="class">even_data_row</xsl:attribute>
												</xsl:if>
												<td class="numberCol" vAlign="top">
													<!--change the color of the rule number if the rule is disabled. -->
													<xsl:if test="./disabled = 'true'">
														<xsl:attribute name="style">color: FF0000;</xsl:attribute>
														<font size="1">Disabled</font>
														<br/>
													</xsl:if>
													<!-- rule number -->
													<xsl:value-of select="Rule_Number"/>
												</td>
												<!--original source -->
												<td vAlign="top">
													<xsl:for-each select="./src_adtr/src_adtr">
														<xsl:call-template name="net_obj_ref">
															<xsl:with-param name="reference" select="."/>
														</xsl:call-template>
													</xsl:for-each>
												</td>
												<!--original destination -->
												<td vAlign="top">
													<xsl:for-each select="./dst_adtr/dst_adtr">
														<xsl:call-template name="net_obj_ref">
															<xsl:with-param name="reference" select="."/>
														</xsl:call-template>
													</xsl:for-each>
												</td>
												<!--original service -->
												<td vAlign="top">
													<xsl:for-each select="./services_adtr/services_adtr">
														<xsl:call-template name="service_ref">
															<xsl:with-param name="reference" select="."/>
														</xsl:call-template>
													</xsl:for-each>
												</td>
												<!--translated source -->
												<td vAlign="top">
													<xsl:for-each select="./src_adtr_translated/reference">
														<xsl:call-template name="net_obj_ref">
															<xsl:with-param name="reference" select="."/>
														</xsl:call-template>
													</xsl:for-each>
												</td>
												<!--translated destination -->
												<td vAlign="top">
													<xsl:for-each select="./dst_adtr_translated/reference">
														<xsl:call-template name="net_obj_ref">
															<xsl:with-param name="reference" select="."/>
														</xsl:call-template>
													</xsl:for-each>
												</td>
												<!--translated service -->
												<td vAlign="top">
													<xsl:for-each select="./services_adtr_translated/reference">
														<xsl:call-template name="service_ref">
															<xsl:with-param name="reference" select="."/>
														</xsl:call-template>
													</xsl:for-each>
												</td>
												<!--Install On -->
												<td vAlign="top">
													<xsl:for-each select="./install/install">
														<xsl:call-template name="net_obj_ref">
															<xsl:with-param name="reference" select="."/>
														</xsl:call-template>
													</xsl:for-each>
												</td>
												<!--comments -->
												<td vAlign="top" style="BORDER-RIGHT: #e5e5e5 1px solid;">
													<xsl:value-of select="comments"/>&#160;
												</td>
											</tr>
										</xsl:otherwise>
									</xsl:choose>
								</xsl:for-each>
								<!-- End Iterator -->
								<TR>
									<TD class="last" align="right" colSpan="10">
										<DIV class="divStyle" align="center">
											<A class="back" href="#{$NATtableHeadLink}">Top of table</A> | <A class="back" href="#topOfPage">Top of page</A>
										</DIV>
									</TD>
								</TR>
							</TBODY>
						</TABLE>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
		<BR/>
		<BR/>
	</xsl:template>
	<!-- End new NAT -->
	<!-- Start New network objects table -->
	<xsl:template name="network_objects_template">
		<br/>
		<!-- start table header -->
		<xsl:variable name="NOtableHeadLink">
			<xsl:value-of select="generate-id(.)"/>
		</xsl:variable>
		<a name="NO{$NOtableHeadLink}"/>
		<TABLE class="data" cellSpacing="0" cellPadding="0" width="90%" align="center" borders="none">
			<TBODY>
				<TR>
					<TD class="title">Network Objects</TD>
				</TR>
				<TR>
					<TD>
						<TABLE cellSpacing="0" cellPadding="0" width="100%" borders="0">
							<TBODY>
								<tr class="header">
									<td class="rule_header">Name</td>
									<td class="rule_header">Type</td>
									<td class="rule_header">IP</td>
									<td class="rule_header">Netmask</td>
									<td class="rule_header">Products installed</td>
									<td class="rule_header">NAT Address</td>
									<td class="rule_header">Members</td>
									<td class="rule_header">Version</td>
									<td class="rule_header">Comments</td>
								</tr>
								<!-- Start Iterator -->
								<xsl:for-each select="$network_objects/network_object[Class_Name != 'sofaware_profiles_security_level']">
									<xsl:sort case-order="upper-first" select="Name"/>
									<tr class="odd_data_row">
										<xsl:if test="position() mod 2 = 0">
											<xsl:attribute name="class">even_data_row</xsl:attribute>
										</xsl:if>
										<!--name -->
										<td vAlign="top">
											<a>
												<xsl:attribute name="name">network_object_<xsl:value-of select="Name"/></xsl:attribute>
												<xsl:value-of select="Name"/>
											</a>
										</td>
										<!--type -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="Class_Name = 'host_plain'">
												Host Node
												</xsl:when>
												<xsl:when test="Class_Name = 'network'">
												Network
												</xsl:when>
												<xsl:when test="Class_Name = 'network_object_group'">
												Group
												</xsl:when>
												<xsl:when test="Class_Name = 'host_ckp'">
												Check Point Host
												</xsl:when>
												<xsl:when test="Class_Name = 'gateway_ckp'">
												Check Point Gateway
												</xsl:when>
												<xsl:when test="Class_Name = 'gateway_cluster'">
												Gateway Cluster
												</xsl:when>
												<xsl:when test="Class_Name = 'cluster_member'">
												Cluster Member
												</xsl:when>
												<xsl:when test="Class_Name = 'sofaware_gateway'">
												Safe@Gateway
												</xsl:when>
												<xsl:when test="Class_Name = 'sofaware_gateway_profile'">
												SofaWare Gateway Profile
												</xsl:when>
												<xsl:when test="Class_Name = 'address_range'">
												Address Range
												</xsl:when>
												<xsl:when test="Class_Name = 'embedded_device'">
												Embedded Device
												</xsl:when>
												<xsl:when test="Class_Name = 'OSE_device'">
												OSE Device
												</xsl:when>
												<xsl:when test="Class_Name = 'gateway_plain'">
												Interoperable Device
												</xsl:when>
												<xsl:when test="Class_Name = 'dynamic_object'">
												Dynamic Object
												</xsl:when>
												<xsl:when test="Class_Name = 'domain'">
												Domain
												</xsl:when>
												<xsl:when test="Class_Name = 'logical_server'">
												Logical Server
												</xsl:when>
												<xsl:when test="Class_Name = 'voip_SIP_domain'">
												VoIP Domain SIP
												</xsl:when>
												<xsl:when test="Class_Name = 'UAS_collection'">
												User Authority Servers Collection
												</xsl:when>
												<xsl:when test="Class_Name = 'group_with_exception'">
												Group With Exclusion
												</xsl:when>
												<xsl:when test="Class_Name = 'connectra'">
												Connectra
												</xsl:when>
												<xsl:when test="Class_Name = 'interspect'">
												InterSpect Gateway
												</xsl:when>
												<xsl:otherwise>
												Unknown Type
												</xsl:otherwise>
											</xsl:choose>
										</td>

                                        <!--IP -->
										<td vAlign="top">
                                            <xsl:choose>
                                            <!--  this code shows the object's ip address -->
                                                <xsl:when test="ipaddr = '0.0.0.1'">N/A</xsl:when>
                                                <xsl:when test="ipaddr != ''"><xsl:value-of select="ipaddr"/><br/></xsl:when>
                                                <xsl:when test="ipaddr_first or ipaddr_last">
                                                    <xsl:if test="ipaddr_first"><xsl:value-of select="ipaddr_first"/></xsl:if>
                                                    <xsl:if test="ipaddr_first and ipaddr_last "> to </xsl:if>
                                                    <xsl:if test="ipaddr_last"><xsl:value-of select="ipaddr_last"/></xsl:if>
                                                </xsl:when>
                                                <xsl:otherwise>-</xsl:otherwise>
                                            </xsl:choose>
                                            <!--  this code shows the ip addresses of the interfaces of the object -->
                                            <xsl:for-each select="interfaces/interfaces">
                                                <xsl:value-of select="ipaddr"/><br/>
                                            </xsl:for-each>
                                        </td>

                                        <!--Netmask -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="netmask != ''">
													<xsl:value-of select="netmask"/>
												</xsl:when>
												<xsl:otherwise>
												-
												</xsl:otherwise>
											</xsl:choose>
											<xsl:for-each select="interfaces/interfaces">
												<br/>
												<xsl:value-of select="netmask"/>
											</xsl:for-each>												
										</td>

                                        <!--Products installed -->
										<td vAlign="top" nowrap="true">
											<xsl:choose>
												<xsl:when test="cp_products_installed = 'true'">
												    SVN Foundation<br/>
													<xsl:choose>
														<xsl:when test="management = 'true'">
															<xsl:choose>
																<xsl:when test="primary_management = 'true'">
																Primary Management Station
																</xsl:when>
																<xsl:otherwise>
																Secondary Management Station
																</xsl:otherwise>
															</xsl:choose>
															<br/>
														</xsl:when>
														<xsl:when test="log_server = 'true'">
														Log Server<br/>
														</xsl:when>
														<xsl:when test="integrity_server = 'true'">
														Integrity Server<br/>
														</xsl:when>
														<xsl:when test="firewall = 'installed'">
														FireWall-1<br/>
														</xsl:when>
														<xsl:when test="VPN_1 = 'true'">
															VPN-1 Pro<br/>
														</xsl:when>
														<xsl:when test="vpnddcate = 'true'">
															VPN-1 Net<br/>
														</xsl:when>
														<xsl:when test="floodgate = 'installed'">
															FloodGate-1<br/>
														</xsl:when>
														<xsl:when test="policy_server = 'installed'">
															SecureClient Policy Server<br/>
														</xsl:when>
														<xsl:when test="SDS = 'installed'">
															SecureClient Software Distribution Server<br/>
														</xsl:when>
														<xsl:when test="reporting_server = 'true'">
														SmartView Reporter<br/>
														</xsl:when>
														<xsl:when test="real_time_monitor = 'true'">
														SmartView Monitor<br/>
														</xsl:when>
														<xsl:when test="UA_server = 'true'">
														UserAuthority Server<br/>
														</xsl:when>
														<xsl:when test="UA_WebAccess = 'true'">UserAuthority WebAccess<br/></xsl:when>
													</xsl:choose>
														<xsl:if test="sc_portal = 'true'">
															SmartPortal<br/>
														</xsl:if>
														<xsl:if test="event_analyzer = 'true'">
															Eventia Anayzer Server<br/>
														</xsl:if>
												</xsl:when>
												<xsl:otherwise>
												-
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<!--NAT -->
										<td vAlign="top">
											<xsl:choose>
                                                <xsl:when test="NAT/valid_ipaddr != '0.0.0.0'"><xsl:value-of select="NAT/valid_ipaddr"/></xsl:when>
                                                <xsl:when test="NAT/the_firewalling_obj[Name] "><xsl:value-of select="NAT/the_firewalling_obj/Name"/></xsl:when>
                                                <xsl:when test="NAT/valid_ipaddr != ''">
													<xsl:value-of select="NAT/valid_ipaddr"/>
												</xsl:when>
												<xsl:otherwise>
												-
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<!--Members -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="type = 'group'">
													<xsl:for-each select="./members/reference">
														<a>
															<xsl:attribute name="href">#network_object_<xsl:value-of select="Name"/></xsl:attribute>
															<xsl:value-of select="Name"/>
														</a>
														<br/>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
											-
											</xsl:otherwise>
											</xsl:choose>
										</td>
										<!--Version -->
										<td vAlign="top">
											<xsl:variable name="versionStr">[<xsl:value-of select="cpver"/>][<xsl:value-of select="option_pack"/>]</xsl:variable>
											<xsl:variable name="className">
												<xsl:value-of select="Class_Name"/>
											</xsl:variable>
											<xsl:variable name="vsxver">
												<xsl:value-of select="vsxver"/>
											</xsl:variable>
											<xsl:choose>
												<!-- Checkpoint host or gateway	-->
												<xsl:when test="$className = 'host_ckp' or $className = 'gateway_ckp' or $className = 'cluster_member' or $className = 'gateway_cluster'">
													<xsl:choose>
                                                        <xsl:when test="string(cpver) = '3.0'"><xsl:attribute name="title">3.x</xsl:attribute>3.x</xsl:when>
                                                        <xsl:when test="string(cpver) = '4.0'"><xsl:attribute name="title">4.0</xsl:attribute>4.0</xsl:when>
                                                        <xsl:when test="string(cpver) = '4.1'"><xsl:attribute name="title">4.1</xsl:attribute>4.1</xsl:when>
                                                        <xsl:when test="$versionStr = '[5.0][0]'"><xsl:attribute name="title">NG</xsl:attribute>NG</xsl:when>
                                                        <xsl:when test="$versionStr = '[5.0][1]'"><xsl:attribute name="title">NG Feature Pack 1</xsl:attribute>NG Feature Pack 1</xsl:when>
                                                        <xsl:when test="$versionStr = '[5.0][2]'"><xsl:attribute name="title">NG Feature Pack 2</xsl:attribute>NG Feature Pack 2</xsl:when>
                                                        <xsl:when test="$versionStr = '[5.0][3]'"><xsl:attribute name="title">NG Feature Pack 3</xsl:attribute>NG Feature Pack 3</xsl:when>
                                                        <xsl:when test="$versionStr = '[5.0][4]'"><xsl:attribute name="title">NG With Application Intelligence</xsl:attribute>NG With Application Intelligence</xsl:when>
                                                        <xsl:when test="$versionStr = '[5.0][5]'"><xsl:attribute name="title">NG With Application Intelligence - R55W</xsl:attribute>NG With Application Intelligence - R55W</xsl:when>
                                                        <xsl:when test="$versionStr = '[5.0][7]'"><xsl:attribute name="title">NG With Application Intelligence - R57</xsl:attribute>NG With Application Intelligence - R57</xsl:when>
                                                        <xsl:when test="$versionStr = '[6.0][0]'"><xsl:attribute name="title">NGX R60</xsl:attribute>NGX R60</xsl:when>
                                                        <xsl:when test="$versionStr = '[6.0][2]'"><xsl:attribute name="title">NGX R60A</xsl:attribute>NGX R60A</xsl:when>
                                                        <xsl:when test="$versionStr = '[6.0][3]'"><xsl:attribute name="title">NGX R61</xsl:attribute>NGX R61</xsl:when>
                                                        <xsl:when test="$versionStr = '[6.0][6]'"><xsl:attribute name="title">NGX R62</xsl:attribute>NGX R62</xsl:when>
                                                        <xsl:when test="$versionStr = '[6.0][5]'"><xsl:attribute name="title">NGX R63</xsl:attribute>NGX R63</xsl:when>
                                                        <xsl:when test="$versionStr = '[8.0][0]'"><xsl:attribute name="title">NGX R70</xsl:attribute>NGX R70</xsl:when>
                                                        
                                                        <xsl:otherwise><xsl:attribute name="title">N/A</xsl:attribute>N/A</xsl:otherwise>
                                                    </xsl:choose>
												</xsl:when>
												<!-- Connectra or Connectra cluster	-->
												<xsl:when test="$className = 'connectra' or $className = 'connectra_cluster'">
													<xsl:choose>
                                                        <xsl:when test="$versionStr = '[5.0][8]'"><xsl:attribute name="title">Connectra 2.0</xsl:attribute>Connectra 2.0</xsl:when>
                                                        <xsl:when test="$versionStr = '[5.0][9]'"><xsl:attribute name="title">Connectra NGX R60</xsl:attribute>Connectra NGX R60</xsl:when>
                                                        <xsl:when test="$versionStr = '[6.0][4]'"><xsl:attribute name="title">Connectra NGX R61-R62</xsl:attribute>Connectra NGX R61-R62</xsl:when>
                                                        <xsl:when test="$versionStr = '[6.0][6]'"><xsl:attribute name="title">Connectra NGX R62CM</xsl:attribute>Connectra NGX R62CM</xsl:when>
                                                        <xsl:otherwise><xsl:attribute name="title">N/A</xsl:attribute>N/A</xsl:otherwise>
                                                    </xsl:choose>
												</xsl:when>
												<!-- InterSpect(s) -->
												<xsl:when test="$className = 'interspect'">
													<xsl:choose>
                                                        <xsl:when test="$versionStr = '[1.0][0]'"><xsl:attribute name="title">InterSpect 1.0 / 1.1 / 1.5 </xsl:attribute>InterSpect 1.0 / 1.1 / 1.5 </xsl:when>
                                                        <xsl:when test="$versionStr = '[2.0][0]'"><xsl:attribute name="title">InterSpect 2.0</xsl:attribute>InterSpect 2.0</xsl:when>
                                                        <xsl:when test="$versionStr = '[6.0][0]'"><xsl:attribute name="title">InterSpect NGX R60</xsl:attribute>InterSpect NGX R60</xsl:when>
                                                        <xsl:otherwise><xsl:attribute name="title">N/A</xsl:attribute>N/A</xsl:otherwise>
                                                    </xsl:choose>
												</xsl:when>
												<!--  VSX(s) -->
												<xsl:when test="$className = 'vs_cluster_netobj' or $className = 'vsx_cluster_netobj' or $className = 'vsx_cluster_member' or $className = 'vs_cluster_member'">
													<xsl:choose>
                                                        <xsl:when test="$vsxver = ''"><xsl:attribute name="title">VSX 2.0.1</xsl:attribute>VSX 2.0.1</xsl:when>
                                                        <xsl:when test="$vsxver = '210'"><xsl:attribute name="title">VSX NG AI</xsl:attribute>VSX NG AI</xsl:when>
                                                        <xsl:when test="$vsxver = '300'"><xsl:attribute name="title">VSX NGX</xsl:attribute>VSX NGX</xsl:when>
                                                    </xsl:choose>
												</xsl:when>
												<xsl:otherwise>
													<xsl:attribute name="title">N/A</xsl:attribute>
	                                            </xsl:otherwise>
											</xsl:choose>
										</td>
										<!--comments -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="comments != ''">
													<xsl:value-of select="comments"/>
												</xsl:when>
												<xsl:otherwise>
												-
												</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</xsl:for-each>
								<!-- End Iterator -->
								<TR>
									<TD class="last" align="right" colSpan="10">
										<DIV class="divStyle" align="center">
											<A class="back" href="#NO{$NOtableHeadLink}">Top of table</A> | <A class="back" href="#topOfPage">Top of page</A>
										</DIV>
									</TD>
								</TR>
							</TBODY>
						</TABLE>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
		<BR/>
		<BR/>
	</xsl:template>
	<!-- End New network objects table -->
	<!-- Start New Users objects table -->
	<xsl:template name="users_template">
		<br/>
		<!-- start table header -->
		<xsl:variable name="UtableHeadLink">
			<xsl:value-of select="generate-id(.)"/>
		</xsl:variable>
		<a name="U{$UtableHeadLink}"/>
		<TABLE class="data" cellSpacing="0" cellPadding="0" width="90%" align="center" borders="none">
			<TBODY>
				<TR>
					<TD class="title">Users</TD>
				</TR>
				<TR>
					<TD>
						<TABLE cellSpacing="0" cellPadding="0" width="100%" borders="0">
							<TBODY>
								<tr class="header">
									<td class="rule_header">Name</td>
									<td class="rule_header">Type</td>
									<td class="rule_header">Expiration Date</td>
									<td class="rule_header">Member Of Groups</td>
									<td class="rule_header">Authentication Method</td>
									<td class="rule_header">Allow From</td>
									<td class="rule_header">Allow To</td>
									<td class="rule_header">Comments</td>
								</tr>
								<!-- Start Iterator -->
								<xsl:for-each select="$users/user">
								<xsl:sort case-order="upper-first" select="Name"/>									
									<tr class="odd_data_row">
										<xsl:if test="position() mod 2 = 0">
											<xsl:attribute name="class">even_data_row</xsl:attribute>
										</xsl:if>
										<!--Name -->
										<td vAlign="top">
                                            <a name="user_{Name}"><xsl:value-of select="Name"/></a>
										</td>
										<!--Type -->
										<td class="object_cell">
											<xsl:choose>
											      <xsl:when test="administrator ='true' and type='user' ">
											      		Administrator
											      </xsl:when>
											      <xsl:otherwise>
											<xsl:value-of select="type"/>
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<!--Expiration Date -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="expiration_date != ''">
													<xsl:value-of select="expiration_date"/>
												</xsl:when>
												<xsl:otherwise>
													-
												</xsl:otherwise>
											</xsl:choose>
										</td>
										<!--Member Of Groups -->
										<td vAlign="top">
                                            <xsl:choose>
                                                <xsl:when test="./groups/groups[Name]">
                                                    <xsl:for-each select="./groups/groups">
                                                        <a href="#user_{Name}"><xsl:value-of select="Name"/></a>
                                                        <br/>
                                                    </xsl:for-each>
                                                </xsl:when>
                                                <xsl:otherwise>-</xsl:otherwise>
                                            </xsl:choose>
                                        </td>
										<!--Authentication Method -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="auth_method != ''">
													<xsl:value-of select="auth_method"/>
												</xsl:when>
												<xsl:otherwise>
												-
											</xsl:otherwise>
											</xsl:choose>
										</td>
										<!--Allow From -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="sources != ''">
													<xsl:for-each select="sources/sources">
														<xsl:call-template name="net_obj_ref">
															<xsl:with-param name="reference" select="."/>
														</xsl:call-template>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
												-
											</xsl:otherwise>
											</xsl:choose>
										</td>
										<!--Allow To -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="destinations != ''">
													<xsl:for-each select="destinations/destinations">
														<xsl:call-template name="net_obj_ref">
															<xsl:with-param name="reference" select="."/>
														</xsl:call-template>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
												-
											</xsl:otherwise>
											</xsl:choose>
										</td>
										<!--Comment -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="comments != ''">
													<xsl:value-of select="comments"/>
												</xsl:when>
												<xsl:otherwise>
												-
											</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</xsl:for-each>
								<!-- End Iterator -->
								<TR>
									<TD class="last" align="right" colSpan="10">
										<DIV class="divStyle" align="center">
											<A class="back" href="#U{$UtableHeadLink}">Top of table</A> | <A class="back" href="#topOfPage">Top of page</A>
										</DIV>
									</TD>
								</TR>
							</TBODY>
						</TABLE>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
		<BR/>
		<BR/>
	</xsl:template>
	<!-- End New Users objects table -->
	<!-- Start New Services objects table -->
	<xsl:template name="services_template">
		<br/>
		<!-- start table header -->
		<xsl:variable name="StableHeadLink">
			<xsl:value-of select="generate-id(.)"/>
		</xsl:variable>
		<a name="S{$StableHeadLink}"/>
		<TABLE class="data" cellSpacing="0" cellPadding="0" width="90%" align="center" borders="none">
			<TBODY>
				<TR>
					<TD class="title">Services</TD>
				</TR>
				<TR>
					<TD>
						<TABLE cellSpacing="0" cellPadding="0" width="100%" borders="0">
							<TBODY>
								<tr class="header">
									<td class="rule_header">Name</td>
									<td class="rule_header">Type</td>
									<td class="rule_header">Port / Protocol</td>
									<td class="rule_header">Protocol Type</td>
									<td class="rule_header">Match For Any</td>
									<td class="rule_header">Source Port</td>
									<td class="rule_header">Members</td>
									<td class="rule_header">Comments</td>
								</tr>
								<!-- Start Iterator -->
								<xsl:for-each select="$services/service">
									<xsl:sort case-order="upper-first" select="Name"/>
									<tr class="odd_data_row">
										<xsl:if test="position() mod 2 = 0">
											<xsl:attribute name="class">even_data_row</xsl:attribute>
										</xsl:if>
										<!--Name -->
										<td vAlign="top">
											<a>
												<xsl:attribute name="name">service_<xsl:value-of select="Name"/></xsl:attribute>
												<xsl:value-of select="Name"/>
											</a>
										</td>
										<!--Type -->
										<td vAlign="top">
											<xsl:value-of select="type"/>
										</td>
										<!--Port / Protocol -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="protocol != ''">
													<xsl:value-of select="protocol"/>
												</xsl:when>
												<xsl:when test="port != ''">
													<xsl:value-of select="port"/>
												</xsl:when>
												<xsl:otherwise>
												-
											</xsl:otherwise>
											</xsl:choose>
										</td>
										<!--Protocol Type -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="proto_type/Name != ''">
													<xsl:value-of select="proto_type/Name"/>
												</xsl:when>
												<xsl:otherwise>
												-
											</xsl:otherwise>
											</xsl:choose>
										</td>
										<!--Match -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="include_in_any != ''">
													<xsl:value-of select="include_in_any"/>
												</xsl:when>
												<xsl:otherwise>
												-
											</xsl:otherwise>
											</xsl:choose>
										</td>
										<!--S-port -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="src_port != ''">
													<xsl:value-of select="src_port"/>
												</xsl:when>
												<xsl:otherwise>
												-
											</xsl:otherwise>
											</xsl:choose>
										</td>
										<!--Members -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="translate(type,'GROUP','group') = 'group'">
													<xsl:for-each select="./members/reference">
														<a>
															<xsl:attribute name="href">#service_<xsl:value-of select="Name"/></xsl:attribute>
															<xsl:value-of select="Name"/>
														</a>
														<br/>
													</xsl:for-each>
												</xsl:when>
												<xsl:otherwise>
												-
											</xsl:otherwise>
											</xsl:choose>
										</td>
										<!--Comments -->
										<td vAlign="top">
											<xsl:choose>
												<xsl:when test="comments != ''">
													<xsl:value-of select="comments"/>
												</xsl:when>
												<xsl:otherwise>
												-
											</xsl:otherwise>
											</xsl:choose>
										</td>
									</tr>
								</xsl:for-each>
								<!-- End Iterator -->
								<TR>
									<TD class="last" align="right" colSpan="10">
										<DIV class="divStyle" align="center">
											<A class="back" href="#S{$StableHeadLink}">Top of table</A> | <A class="back" href="#topOfPage">Top of page</A>
										</DIV>
									</TD>
								</TR>
							</TBODY>
						</TABLE>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
		<BR/>
		<BR/>
	</xsl:template>
	<!-- End New Services objects table -->
	<xsl:template match="/">
		<html>
			<head>
				<title>Check Point Web Visualization Tool</title>
				<script language="Javascript">
function convertCtimeElements () // Use id="idCTimeElement" inside tags.
{
	var theElement = document.getElementById ("idCTimeElement"); 
	while (theElement != null)
	{			
		var t = theElement.innerHTML;
		if ((t == "0") || (isNaN(t)) || (t == 0))
		{
			theElement.innerHTML = "-";
		}
		else 
		{
			t *= 1000;	
			var d = new Date (t);	
			theElement.innerHTML = d.toDateString();
		}
		theElement.id = "CTIME";
		theElement = document.getElementById ('idCTimeElement'); 
	}
}

function findFirstCellOfTR (TRElement)
{
	var colOfChildTds = TRElement.getElementsByTagName ("TD");
	if (colOfChildTds == null || colOfChildTds.length == 0)
		colOfChildTds = TRElement.getElementsByTagName ("TH");
						
	if (colOfChildTds == null || colOfChildTds.length==0)
		return null;
	else	
		return colOfChildTds.item(0);
}
				
function closeOrOpenCategory (btn)
{
	var openOrCloseString;
	var displayStyle;
	if (btn.value == "-") // Closing
	{ // Closing
		btn.value = "+";
		displayStyle = "none";
	}
	else 
	{	// Opening							
		btn.value = "-";
		displayStyle = "";
	}
	var theTD = btn.parentNode;
	var theTR = theTD.parentNode;
	var nextTR = theTR.nextSibling;
						  	
	// Make sure we got A TR here
	while (nextTR != null &amp;&amp; (nextTR.tagName == null  || nextTR.tagName != "TR"))
		nextTR = nextTR.nextSibling;
						  		
	if (nextTR == null) 
		return;
						  		
	var siblingTD = findFirstCellOfTR (nextTR);
	while (nextTR != null &amp;&amp; siblingTD.innerHTML == "")
	{									
		nextTR.style.display = displayStyle; 			
		nextTR = nextTR.nextSibling;
		// Make sure we got TR here
		while (nextTR != null &amp;&amp; (nextTR.tagName == null  || nextTR.tagName != "TR"))
		{
			nextTR = nextTR.nextSibling;			
		}
		if (nextTR == null)
			return					
		siblingTD = findFirstCellOfTR (nextTR);
	}																					
}
										
function expandCollapseAll (tblId, bOpen)
{
	var tbl = document.getElementById (tblId);
	if (null == tbl)
		return;
													
	var displayStyle;
	var buttonsValue;
	if (bOpen)
		buttonsValue = "+";
	else							
		buttonsValue = "-";							
																	
	var colOfNodes = tbl.getElementsByTagName("input");
	var index;
	for (index=0; index &lt; colOfNodes.length; index++)
	{
		colOfNodes[index].value = buttonsValue;
		closeOrOpenCategory (colOfNodes[index]); 
	}
}
				

										
function niceTable (t)
{
	var tbl = document.getElementById (t);
	if (null == tbl)
		return;
			
											
	var colOfNodes = tbl.getElementsByTagName("TR");
	var index;
	var currentStyle = "even_data_row";
	var lastCategory = "_KJHKJHKJH";
	for (index=1; index &lt; colOfNodes.length; index++) // index=1... skip headers
	{																																					
		var currentTR = colOfNodes.item(index);
		var firstCell = findFirstCellOfTR (currentTR);
		
	    if (currentTR .innerHTML.indexOf("SKIPTHISTR") != -1)
			continue;
							
		if (firstCell == null)
		{
			return;
		}
																					
		// Current Style Switcher
		if (firstCell.innerHTML != "")						
		{
			if (currentStyle == "odd_data_row") 
				currentStyle = "even_data_row";
			else
				currentStyle = "odd_data_row";
		}
				
		if ((currentTR.innerHTML.indexOf ("CPCATEGORYMARKTAG") == -1) &amp;&amp; (currentTR.className != 'SectionTitleASM'))
		    currentTR.className = currentStyle ;	
		
		
		// Handle buttons and categories
		if (firstCell.innerHTML == lastCategory )
		{ // Same category as above
			if (currentTR.innerHTML.indexOf ("CPCATEGORYMARKTAG") != -1)
			{										
				lastCategory  = firstCell.innerHTML;
				var theFather = currentTR.parentNode;
				theFather.removeChild (currentTR);
				index--;
				if (currentStyle == "odd_data_row") 
					currentStyle = "even_data_row";
				else
					currentStyle = "odd_data_row";
			}		
			else							
			{
				firstCell.innerHTML = "";
				currentTR.style.display = "none";
			}
		}
		else
		{ // new category
				if (firstCell.innerHTML != "")
				{
						
					lastCategory = firstCell.innerHTML;
					var newTDcontent = '&lt;INPUT type="submit" class="closeBtn" value="+" onclick="closeOrOpenCategory (this)"&gt;&#160;&#160;';
					newTDcontent  +=  	firstCell.innerHTML 						   
					firstCell.innerHTML = newTDcontent ;
					currentStyle = "even_data_row";								  
				}
				else
				{
					currentTR.display = "none";
				}
		}											
	}
}

function cleanHelpLinks (t)
{
	var table = document.getElementById (t)
	if (table == null)
	{
		alert ("No Table");
		return;
	}
	
		
	var colOflinks = table.getElementsByTagName("a");
	var index;
	for (index=0; index &lt; colOflinks.length; index++) 
	{																																					
		var theElement = colOflinks.item(index);
		var hrefstr = theElement.href + "";
			
		 if (hrefstr.indexOf("asm_help") != -1)
		 {										

			theElement.href = "javascript:void (0);"
			theElement.style.cursor="default";
			theElement.style.textDecoration	 = "none";			
			theElement.style.color="black"
		}
	}	
}

function startUp ()
{
   /*
    convertCtimeElements (); 
    
    niceTable('idTblOfNetworkSecurity'); 
    cleanHelpLinks ('idTblOfNetworkSecurity');    

    niceTable('idTblAI'); 
    cleanHelpLinks('idTblAI');

    niceTable ('idTblWI1'); 
    cleanHelpLinks('idTblWI1');
    
    niceTable ('idTblWI'); 
    cleanHelpLinks('idTblWI');
    */
}
</script>
				<STYLE>
A.navigation:link 
{
	COLOR: #7578ae; BOTTOM: 1px; POSITION: relative;
}
A.navigation:visited {
	COLOR: #7578ae; BOTTOM: 1px; POSITION: relative;
}
A.navigation:hover {
	COLOR: orange;
}
A.navigation:active {
	COLOR: orange;
}
TD.title {
	FONT-WEIGHT: bold; FONT-SIZE: 16pt; BORDER-BOTTOM: #c2c2c2 1px solid; FONT-STYLE: italic; FONT-FAMILY: times new roman;
}

span.title  
{
	FONT-WEIGHT: bold; FONT-SIZE: 16pt; BORDER-BOTTOM: #c2c2c2 1px solid; FONT-STYLE: italic; FONT-FAMILY: times new roman;
}

li.even_data_row
{
	FONT-SIZE: 8pt; PADDING-BOTTOM: 6px; COLOR: #575757; PADDING-TOP: 6px; BORDER-BOTTOM: #e5e5e5 1px solid; BORDER-RIGHT: #e5e5e5 1px solid; FONT-FAMILY: verdana;
}


TABLE.data TR.header TD {
	FONT-SIZE: 8pt; FONT-FAMILY: verdana; HEIGHT: 30px; BACKGROUND-COLOR: #d7d7d7;
}
TABLE.data TD {
	PADDING-LEFT: 10px;
}
TABLE.data TABLE {
	BORDER-LEFT: #c2c2c2 1px solid;
}
TD.numberCol {
	text-align: center; FONT-SIZE: 8pt; PADDING-LEFT: 3px; PADDING-RIGHT: 5px; PADDING-BOTTOM: 6px; COLOR: #575757; PADDING-TOP: 6px; BORDER-BOTTOM: #e5e5e5 1px solid; BORDER-RIGHT: #e5e5e5 1px solid; FONT-FAMILY: verdana;
}

TR.even_data_row TD
{
	FONT-SIZE: 8pt; PADDING-BOTTOM: 6px; COLOR: #575757; PADDING-TOP: 6px; BORDER-BOTTOM: #e5e5e5 1px solid; BORDER-RIGHT: #e5e5e5 1px solid; FONT-FAMILY: verdana;
}

TR.odd_data_row TD
{
    FONT-SIZE: 8pt; PADDING-BOTTOM: 6px; COLOR: #575757; PADDING-TOP: 6px; BORDER-BOTTOM: #e5e5e5 1px solid; BORDER-RIGHT: #e5e5e5 1px solid; FONT-FAMILY: verdana;	
    background-color: #eaeaea; 
}
A.back:link {
	COLOR: #7085af
}
A.back:visited {
	COLOR: #7085af
}
A.back:hover {
	COLOR: orange
}
A.back:active {
	COLOR: orange
}
TD DIV {
	BORDER-RIGHT: #d7d7d7 1px solid; PADDING-RIGHT: 5px; BORDER-TOP: medium none; PADDING-LEFT: 5px; BORDER-LEFT: #d7d7d7 1px solid; WIDTH: 185px; COLOR: #7085af; BORDER-BOTTOM: #d7d7d7 1px solid; HEIGHT: 24px;
}

TD.sectionTitle
{
	BORDER-RIGHT: #d7d7d7 1px solid; PADDING-RIGHT: 10px; BORDER-TOP: medium none; PADDING-LEFT: 10px; BORDER-LEFT: #d7d7d7 1px solid; WIDTH: 185px; COLOR: #7085af; BORDER-BOTTOM: #d7d7d7 1px solid; HEIGHT: 24px;
	BACKGROUND-COLOR: #FFFFFF; 
	FONT-SIZE: 8pt;
	FONT-FAMILY: verdana;	
	color: black;
}

TD.rule_header
{
    PADDING-RIGHT: 5px;    
    PADDING-LEFT: 5px;     
    TEXT-ALIGN: left;
    BORDER-RIGHT: #EEEEEE 1px solid;
}

TD.rule_header_nat
{
    TEXT-ALIGN: left;    
    BORDER-RIGHT: #EEEEEE 1px solid;
    BORDER-TOP:   #EEEEEE 1px solid;
}

TR.sectionTitleASM 
{
	BORDER-RIGHT: #d7d7d7 1px solid; PADDING-RIGHT: 10px; BORDER-TOP: medium none; PADDING-LEFT: 10px; BORDER-LEFT: #d7d7d7 1px solid; WIDTH: 185px; COLOR: #7085af; BORDER-BOTTOM: #d7d7d7 1px solid; HEIGHT: 24px;
	BACKGROUND-COLOR: #FFFFFF; 
}

DIV.refObject 
{
	BORDER-LEFT: 0px;
	BORDER-RIGHT: 0px;
	BORDER-TOP: 0px;
	BORDER-BOTTOM: 0px;
}

.closeBtn
{
	color: black;
	width: 16px;
	height: 16px;
	FONT-WEIGHT: bold; 
	FONT-FAMILY: verdana;
	FONT-SIZE: 8px;
}
</STYLE>
			</head>
			<body style="COLOR: #303030; BACKGROUND-COLOR: #eeeeee" leftMargin="0" topMargin="0" rightMargin="0" onload="startUp ()">
				<TABLE class="title" style="FONT-SIZE: 20pt; COLOR: #eeeeee; FONT-FAMILY: times; BACKGROUND-COLOR: #303030" height="80" cellSpacing="0" cellPadding="0" width="100%" borders="none">
					<TBODY>
						<TR>
							<TD style="PADDING-LEFT: 20px; FONT-SIZE: 18pt; BORDER-BOTTOM: black 1px solid; FONT-FAMILY: arial" align="LEFT">
								<a name="topOfPage"/>Check Point
		<SUP style="FONT-SIZE: 10px; BOTTOM: 3px; POSITION: relative;">TM</SUP>
							</TD>
							<TD style="PADDING-RIGHT: 20px; FONT-WEIGHT: bold; BORDER-BOTTOM: black 1px solid" align="right">Web 
      Visualization Tool</TD>
						</TR>
						<TR>
							<TD style="PADDING-LEFT: 20px; FONT-SIZE: 9pt; COLOR: #7578ae; FONT-FAMILY: verdana, arial; BACKGROUND-COLOR: white" align="left" colSpan="2" height="30">
								<A class="navigation" href="#pageSP">Security Policy</A> | 
								<A class="navigation" href="#pageNAT">Address Translation Policy</A> | 
								<!--A class="navigation" href="#pageSD">SmartDefense</A> |--> 
								<A class="navigation" href="#pageNO">Network Objects</A> | 
								<A class="navigation" href="#pageUSERS">Users</A> | 
								<A class="navigation" href="#pageSERVICES">Services</A>
							</TD>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #6b6b6b" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #767676" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #828282" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #8e8e8e" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #9c9c9c" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #a8a8a8" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #b4b4b4" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #bebebe" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #c9c9c9" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #d1d1d1" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #d8d8d8" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #dedede" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #e4e4e4" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #e7e7e7" colSpan="2" height="1"/>
						</TR>
						<TR>
							<TD style="BACKGROUND-COLOR: #eaeaea" colSpan="2" height="1"/>
						</TR>
					</TBODY>
				</TABLE>
				<BR/>
				<!-- end of header -->
				<!-- start call for segments -->
				<a name="pageSP"/>
				<xsl:call-template name="security_policy_template">
					<xsl:with-param name="relebase" select="$security_relebase/fw_policie"/>
				</xsl:call-template>
				<a name="pageNAT"/>
				<xsl:call-template name="nat_policy_template">
					<xsl:with-param name="relebase" select="$nat_rulebase/fw_policie"/>
				</xsl:call-template>
				<!--a name="pageSD"/>
				<xsl:apply-templates select="$smart_defense"/-->
				<a name="pageNO"/>
				<xsl:call-template name="network_objects_template"/>
				<a name="pageUSERS"/>
				<xsl:call-template name="users_template"/>
				<a name="pageSERVICES"/>
				<xsl:call-template name="services_template"/>
				<br/>
				<br/>
				<center>
					<address style="font-family:arial,system;font-style:normal;font-size:12;">Copyright &#169; 1994-2012 <a href="http://www.checkpoint.com">Check Point Software Technologies Ltd</a>. All Rights Reserved.</address>
				</center>
			</body>
		</html>
	</xsl:template>
	<!-- =============================== 
	     from here its all asm templates
	     =============================== -->
	<!--	=============================
			Common utility templates
			========================= -->
	<!--Positive Number -->
	<xsl:template name="positiveNumber">
		<xsl:param name="number"/>
		<xsl:choose>
			<xsl:when test="not (number ($number)) or string ($number) = ' ' or string ($number) = '-' or string ($number) = '' or $number &lt; 0">
				<xsl:call-template name="undefinedValue"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$number"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--convert bool to On or off -->
	<xsl:template name="boolToOnOff">
		<xsl:param name="bOnOff"/>
		<xsl:choose>
			<xsl:when test="string ($bOnOff) = 'true'">
				<span class="On">On</span>
			</xsl:when>
			<xsl:when test="string ($bOnOff) = 'false'">
				<span class="Off">Off</span>
			</xsl:when>
			<xsl:when test="string ($bOnOff) =''">
				<xsl:call-template name="undefinedValue"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$bOnOff"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--convert bool to Enabled or Disabled -->
	<xsl:template name="boolToEnabledDisabled">
		<xsl:param name="bEnOrDis"/>
		<xsl:choose>
			<xsl:when test="string ($bEnOrDis) ='true' or string ($bEnOrDis) ='1' or string ($bEnOrDis) ='2'">
				<span class="On">Enabled</span>
			</xsl:when>
			<xsl:when test="string ($bEnOrDis) ='false' or string ($bEnOrDis) ='0'">
				<span class="Off">Disabled</span>
			</xsl:when>
			<xsl:when test="string ($bEnOrDis) =''">
				<xsl:call-template name="undefinedValue"/>
			</xsl:when>
			<xsl:otherwise>
				<xsl:value-of select="$bEnOrDis"/>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!--defualt undefined value -->
	<xsl:template name="undefinedValue">
		-
	</xsl:template>
	<!--Attack First Row -->
	<xsl:template name="attackFirstRow">
		<xsl:param name="attackCategory"/>
		<xsl:param name="attackCreateCategory"/>
		<xsl:param name="attackName"/>
		<xsl:param name="attackInfoLink"/>
		<xsl:param name="attackIsActive"/>
		<xsl:param name="attackMonitorOnly"/>
		<xsl:param name="attackTrack"/>
		<xsl:param name="attackAttribName"/>
		<xsl:param name="attackAttribValue"/>
		<xsl:param name="attackMultiAttribValue"/>
		<xsl:if test="string ($attackCreateCategory) = 'CREATE_CATEGORY'">
			<xsl:call-template name="attackNewCategory">
				<xsl:with-param name="attackCategory" select="string ($attackCategory)"/>
			</xsl:call-template>
		</xsl:if>
		<tr class="odd_data_row">
			<td valign="top">
				<xsl:call-template name="nameResolve">
					<xsl:with-param name="name" select="$attackCategory"/>
				</xsl:call-template>
			</td>
			<td valign="top">
				<xsl:choose>
					<xsl:when test="string ($attackInfoLink) = ''">
						<xsl:call-template name="nameResolve">
							<xsl:with-param name="name" select="$attackName"/>
						</xsl:call-template>
					</xsl:when>
					<xsl:otherwise>
						<a>
							<xsl:attribute name="href">asm_help/<xsl:value-of select="$attackInfoLink"/></xsl:attribute>
							<xsl:value-of select="$attackName"/>
						</a>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td valign="top">
				<xsl:choose>
					<xsl:when test="string ($attackMonitorOnly) = 'true'">
						<nobr>
							<font color="orange">Monitor Only</font>
						</nobr>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="boolToEnabledDisabled">
							<xsl:with-param name="bEnOrDis" select="$attackIsActive"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td valign="top">
				<xsl:choose>
					<xsl:when test="string($attackTrack) = '0'">None</xsl:when>
					<xsl:when test="string($attackTrack) = '1'">
						&#160;Log<br/>
					</xsl:when>
					<xsl:when test="not(string($attackTrack)) or $attackTrack = ' ' or 
											 $attackTrack = '-' or 
											 $attackTrack = '_'  or $attackTrack = '.'">
						<xsl:call-template name="undefinedValue"/>
					</xsl:when>
					<xsl:when test="string($attackTrack) = 'useralert'">
						<nobr>
							&#160;User Defined Alert</nobr>
						<br/>
					</xsl:when>
					<xsl:when test="string($attackTrack) = 'useralert2'">
						<nobr>
							&#160;User Defined Alert no.2</nobr>
						<br/>
					</xsl:when>
					<xsl:when test="string($attackTrack) = 'useralert3'">
						<nobr>
							&#160;User Defined Alert no.3</nobr>
						<br/>
					</xsl:when>
					<xsl:otherwise>
						&#160;
						<nobr>
							<xsl:value-of select="$attackTrack"/>
						</nobr>
						<br/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td valign="top">
				<xsl:call-template name="nameResolve">
					<xsl:with-param name="name" select="$attackAttribName"/>
				</xsl:call-template>
			</td>
			<td valign="top">
				<xsl:choose>
					<xsl:when test="string ($attackAttribValue) = 'IGNORE_SINGLE_VALUE'">
						<xsl:for-each select="$attackMultiAttribValue">
							<nobr>
								<li>
									<xsl:value-of select="text()"/>
								</li>
							</nobr>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="boolToOnOff">
							<xsl:with-param name="bOnOff" select="$attackAttribValue"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>
	<!--Attack More Rows -->
	<xsl:template name="attackMoreRows">
		<xsl:param name="attackAttribName"/>
		<xsl:param name="attackAttribValue"/>
		<xsl:param name="attackMultiAttribValue"/>
		<tr class="odd_data_row" STYLE="display: none;">
			<td valign="top" colspan="4"/>
			<td valign="top">
				<xsl:call-template name="nameResolve">
					<xsl:with-param name="name" select="$attackAttribName"/>
				</xsl:call-template>
			</td>
			<td valign="top">
				<xsl:choose>
					<xsl:when test="string ($attackAttribValue) = 'IGNORE_SINGLE_VALUE'">
						<xsl:for-each select="$attackMultiAttribValue">
							<nobr>
								<li>
									<xsl:value-of select="text()"/>
								</li>
							</nobr>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="boolToOnOff">
							<xsl:with-param name="bOnOff" select="$attackAttribValue"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>	
	<!--Open Category -->
	<xsl:template name="attackNewCategory">
		<xsl:param name="attackCategory"/>
		<xsl:if test="string($attackCategory) != string('')">
			<tr class="sectionTitleASM">
				<td class="sectionTitle" valign="top" width="100">
					<xsl:call-template name="nameResolve">
						<xsl:with-param name="name" select="$attackCategory"/>
					</xsl:call-template>
				</td>
				<td class="sectionTitle" valign="top">-</td>
				<td class="sectionTitle" valign="top">-</td>
				<td class="sectionTitle" valign="top">-</td>
				<td class="sectionTitle" valign="top">-</td>
				<td class="sectionTitle" valign="top" notag="CPCATEGORYMARKTAG">-</td>
			</tr>
		</xsl:if>
	</xsl:template>

	<xsl:template name="serverMoreRows">
		<xsl:param name="attackAttribName"/>
		<xsl:param name="attackAttribValue"/>
		<xsl:param name="attackMultiAttribValue"/>
		<tr class="odd_data_row" STYLE="display: none;">
			<td valign="top" />
			<td valign="top">
				<xsl:call-template name="nameResolve">
					<xsl:with-param name="name" select="$attackAttribName"/>
				</xsl:call-template>
			</td>
			<td valign="top">
				<xsl:choose>
					<xsl:when test="string ($attackAttribValue) = 'IGNORE_SINGLE_VALUE'">
						<xsl:for-each select="$attackMultiAttribValue">
							<nobr>
								<li>
									<xsl:value-of select="text()"/>
								</li>
							</nobr>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:call-template name="boolToOnOff">
							<xsl:with-param name="bOnOff" select="$attackAttribValue"/>
						</xsl:call-template>
					</xsl:otherwise>
				</xsl:choose>
			</td>
		</tr>
	</xsl:template>

	
	<!-- Dynamic updates -->
	<xsl:template name="dynamicUpdate">
		<xsl:param name="duCategoty"/>
		<xsl:choose>
			<xsl:when test="string ($duCategoty) = string ('ALL_DU_WITH_NEW_CATEGORY')">
				<xsl:for-each select="/asm/as/dynamic_attacks/dynamic_attacks[string (show_atk) = 'true' 
												  and parent_name  != 'Microsoft Networks'
												  and parent_name  != 'IP and ICMP'
												  and parent_name  != 'Application Intelligence'
												  and parent_name  != 'Peer to Peer'
												  and parent_name  != 'DNS'
												  and parent_name  != 'Mail'
												  and parent_name  != 'VPN Protocols'
												  and parent_name  != 'SSH'
												  and parent_name  != 'Content Protection'
												  and parent_name  != 'MS-RPC'
												  and parent_name  != 'SUN-RPC'
												  and parent_name  != 'MS-SQL'																							            and parent_name  != 'Routing Protocols'
								            and parent_name  != 'Remote Control Applications'
								            and parent_name  != 'Remote Administrator'
								            and parent_name  != 'WebDefense;HTTP Protocol Inspection'
												  and parent_name  != 'SNMP']">
					<xsl:sort select="parent_name"/>
					<xsl:call-template name="dynamicUpdateEntry">
						<xsl:with-param name="attackCreateCategory" select="string ('CREATE_CATEGORY')"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:when>
			<xsl:otherwise>
				<xsl:for-each select="/asm/as[Name='AdvancedSecurityObject']/dynamic_attacks/dynamic_attacks[string (parent_name) = string ($duCategoty) and string (show_atk) = 'true']">
						<xsl:call-template name="dynamicUpdateEntry">
						<xsl:with-param name="attackCreateCategory" select="string ('NO_NEW_CATEGORY')"/>
					</xsl:call-template>
				</xsl:for-each>
			</xsl:otherwise>
		</xsl:choose>
	</xsl:template>
	<!-- dynamicUpdateByObjName -->
	<xsl:template name="dynamicUpdateByObjName">
		<xsl:param name="objName"/>
		<xsl:param name="parentName"/>
		<xsl:variable name="cn" select="/asm/as/dynamic_attacks/dynamic_attacks[string (parent_name) = string ($parentName) and string (Name) = string ($objName)]"/>
		<xsl:call-template name="attackFirstRow">
			<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
			<xsl:with-param name="attackCategory" select="string ($objName)"/>
			<xsl:with-param name="attackName" select="'-'"/>
			<xsl:with-param name="attackInfoLink" select="'-'"/>
			<xsl:with-param name="attackIsActive" select="$cn/attack_mode"/>
			<xsl:with-param name="attackMonitorOnly" select="$cn/attribs/attribs[attrib_desc = 'Monitor Only - no protection']/attrib_value"/>
			<xsl:with-param name="attackTrack" select="$cn/attribs/attribs[attrib_desc = 'Track:']/attrib_value"/>
			<xsl:with-param name="attackAttribName">-</xsl:with-param>
			<xsl:with-param name="attackAttribValue">-</xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="$cn/attribs/attribs[attrib_desc != 'Track:' and show_attrib = 'true']">
			<xsl:call-template name="attackMoreRows">
				<xsl:with-param name="attackAttribName" select="attrib_desc"/>
				<xsl:with-param name="attackAttribValue" select="attrib_value"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<!-- Dynamic updates Entry -->
	<xsl:template name="dynamicUpdateEntry">
		<xsl:param name="attackCreateCategory"/>
		<xsl:call-template name="attackFirstRow">
			<xsl:with-param name="attackCreateCategory" select="$attackCreateCategory"/>
			<xsl:with-param name="attackCategory" select="parent_name"/>
			<xsl:with-param name="attackName" select="name"/>
			<xsl:with-param name="attackInfoLink" select="desc_loc"/>
			<xsl:with-param name="attackIsActive" select="attack_mode"/>
			<xsl:with-param name="attackMonitorOnly" select="./attribs/attribs[attrib_desc = 'Monitor Only - no protection']/attrib_value"/>
			<xsl:with-param name="attackTrack" select="attribs/attribs[attrib_desc = 'Track:']/attrib_value"/>
			<xsl:with-param name="attackAttribName">-</xsl:with-param>
			<xsl:with-param name="attackAttribValue">-</xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="attribs/attribs[attrib_desc != 'Track:' and show_attrib = 'true']">
			<xsl:call-template name="attackMoreRows">
				<xsl:with-param name="attackAttribName" select="attrib_desc"/>
				<xsl:with-param name="attackAttribValue" select="attrib_value"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>
	<xsl:template match="/asm">
		<div id="idDivWholePage">
			<a name="#sd"/>
			<span class="title">&#160;&#160;SmartDefense&#160;&#160;</span>
			<ul>
				<li class="header">
					<a>
						<xsl:attribute name="href">#sd_gs</xsl:attribute>
							General Settings
					</a>
				</li>
				<li class="header">
					<a>
						<xsl:attribute name="href">#sd_ns</xsl:attribute>
							Network Security
					</a>
				</li>
				<li class="header">
					<a>
						<xsl:attribute name="href">#sd_ai</xsl:attribute>
							Application Intelligence
					</a>
				</li>
				<li class="header">
					<a>
						<xsl:attribute name="href">#sd_wi</xsl:attribute>
							Web Intelligence
					</a>
				</li>
			</ul>
			<xsl:call-template name="general_settings"/>
			<xsl:apply-templates select="as"/>
		</div>
	</xsl:template>
	<!-- main asm templtae -->
	<xsl:template match="as">
		<xsl:apply-templates select="asm_active_protection"/>
	</xsl:template>
	<!-- Start New General Settings -->
	<xsl:template name="general_settings">
		<br/>
		<!-- start table header -->
		<xsl:variable name="GStableHeadLink">
			<xsl:value-of select="generate-id(.)"/>
		</xsl:variable>
		<a name="sd_gs"/>
		<TABLE class="data" cellSpacing="0" cellPadding="0" width="90%" align="center" borders="none">
			<TBODY>
				<TR>
					<TD class="title">General Settings</TD>
				</TR>
				<TR>
					<TD>
						<TABLE cellSpacing="0" cellPadding="0" width="100%" borders="0">
							<TBODY>
								<tr class="header">
									<td class="rule_header">Attribute</td>
									<td class="rule_header">Value</td>
								</tr>
								<!-- Start Iterator -->
								<tr class="odd_data_row">
									<td valign="top">
										Last update
									</td>
									<td valign="top" id="idCTimeElement">
										<xsl:value-of select="./as/asm_last_update_time"/>
									</td>
								</tr>
								<tr class="even_data_row">
									<td valign="top">
										Update version
									</td>
									<td valign="top">
										<xsl:value-of select="./as/asm_update_version"/>
									</td>
								</tr>
								<tr class="odd_data_row">
									<td>Check for new updates when SmartDashboard is started</td>
									<td>
										<xsl:call-template name="boolToOnOff">
											<xsl:with-param name="bOnOff" select="./as/asm_check_for_update_frequently"/>
										</xsl:call-template>
									</td>
								</tr>
								<tr class="even_data_row">
									<td>Reference</td>
									<td valign="top">
										<a href="http://www.checkpoint.com/products/downloads/smartdefense_subscription_faq.pdf">SmartDefense subscription service FAQ (PDF)</a>
									</td>
								</tr>
								<!-- End Iterator -->
								<TR>
									<TD class="last" align="right" colSpan="10">
										<DIV class="divStyle" align="center">
											<A class="back" href="#sd_gs">Top of table</A> | <A class="back" href="#topOfPage">Top of page</A>
										</DIV>
									</TD>
								</TR>
							</TBODY>
						</TABLE>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
		<BR/>
		<BR/>
	</xsl:template>
	<!--End  New General Settings -->
	<!--	================
				Network security
				================= -->
	<!-- Active Protection -->
	<xsl:template name="attacks" match="asm_active_protection">
		<xsl:param name="duCategoty"/>
		<xsl:param name="attackCategory"/>
		<xsl:param name="attackCreateCategory"/>
		<xsl:param name="attackName"/>
		<xsl:param name="attackIsActive"/>
		<xsl:param name="attackTrack"/>
		<xsl:param name="attackAttribName"/>
		<xsl:param name="attackAttribValue"/>
		<a name="networksecurity"/>
		<p/>

		&#160;&#160;&#160;&#160;&#160;<INPUT type="submit" class="expandBtn" value="Expand all" onclick="expandCollapseAll ('idTblOfNetworkSecurity', true); expandCollapseAll ('idTblAI', true); expandCollapseAll ('idTblWI', true);"/>&#8194;
		&#160;&#160;&#160;&#160;&#160;<INPUT type="submit" class="expandBtn" value="Collapse all" onclick="expandCollapseAll ('idTblOfNetworkSecurity', false); expandCollapseAll ('idTblAI', false);expandCollapseAll ('idTblWI', false);"/>
		<p/>
		<a name="sd_ns"/>
		<TABLE class="data" cellSpacing="0" cellPadding="0" width="90%" align="center" borders="none">
			<TBODY>
				<TR>
					<TD class="title">Network Security
					</TD>
				</TR>
				<TR>
					<TD>
						<TABLE id="idTblOfNetworkSecurity" cellSpacing="0" cellPadding="0" width="100%" border="0">
							<TBODY>
								<tr class="header">
									<td class="objects_header">Attack Category</td>
									<td class="objects_header">Attack Name</td>
									<td class="objects_header">Enabled/Disabled</td>
									<td class="objects_header">Track</td>
									<td class="objects_header">Attribute</td>
									<td class="objects_header">Value</td>
								</tr>
								<xsl:if test="tear_drop_protection">
									<xsl:variable name="cn" select="tear_drop_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">Denial of Service</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="tear_drop_protection">
									<xsl:variable name="cn" select="tear_drop_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">Denial of Service</xsl:with-param>
										<xsl:with-param name="attackName">tear_drop_protection</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="tear_drop_protection/asm_teardrop"/>
										<xsl:with-param name="attackTrack" select="tear_drop_protection/asm_teardrop_log"/>
										<xsl:with-param name="attackAttribName">-</xsl:with-param>
										<xsl:with-param name="attackAttribValue">-</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="ping_of_death_protection">
									<xsl:variable name="cn" select="ping_of_death_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">Denial of Service</xsl:with-param>
										<xsl:with-param name="attackName">ping_of_death_protection</xsl:with-param>
										<xsl:with-param name="attackIsActive">
											<xsl:value-of select="$cn/asm_ping_of_death"/>
										</xsl:with-param>
										<xsl:with-param name="attackTrack">
											<xsl:value-of select="$cn/asm_ping_of_death_log"/>
										</xsl:with-param>
										<xsl:with-param name="attackAttribName">-</xsl:with-param>
										<xsl:with-param name="attackAttribValue">-</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="land_attack">
									<xsl:variable name="cn" select="land_attack"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">Denial of Service</xsl:with-param>
										<xsl:with-param name="attackName">land_attack</xsl:with-param>
										<xsl:with-param name="attackIsActive">
											<xsl:value-of select="$cn/asm_land"/>
										</xsl:with-param>
										<xsl:with-param name="attackMonitorOnly">
											<xsl:value-of select="$cn/asm_land_monitor_only"/>
										</xsl:with-param>
										<xsl:with-param name="attackTrack">
											<xsl:value-of select="$cn/asm_land_log"/>
										</xsl:with-param>
										<xsl:with-param name="attackAttribName">-</xsl:with-param>
										<xsl:with-param name="attackAttribValue">-</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="asm_non_tcp_quota">
									<xsl:variable name="cn" select="asm_non_tcp_quota"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">Denial of Service</xsl:with-param>
										<xsl:with-param name="attackName">non_tcp_flooding</xsl:with-param>
										<xsl:with-param name="attackIsActive">
											<xsl:value-of select="$cn/asm_non_tcp_quota_enable"/>
										</xsl:with-param>
										<xsl:with-param name="attackTrack">
											<xsl:value-of select="$cn/asm_non_tcp_quota_track"/>
										</xsl:with-param>
										<xsl:with-param name="attackAttribName">non_tcp_thrash hold</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/asm_non_tcp_quota_percentage"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<!-- IP and ICMP Attacks -->
								<xsl:if test="potential_layer4_DoS_protection">
									<xsl:variable name="cn" select="potential_layer4_DoS_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">IP and ICMP</xsl:with-param>
										<xsl:with-param name="attackName">potential_layer4_DoS_protection</xsl:with-param>
										<xsl:with-param name="attackIsActive">
											<xsl:value-of select="$cn/asm_packet_verify_enforce"/>
										</xsl:with-param>
										<xsl:with-param name="attackMonitorOnly">
											<xsl:value-of select="$cn/asm_packet_verify_monitor_only"/>
										</xsl:with-param>
										<xsl:with-param name="attackTrack">
											<xsl:value-of select="$cn/asm_packet_verify_log"/>
										</xsl:with-param>
										<xsl:with-param name="attackAttribName">asm_packet_verify_relaxed_udp</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/asm_packet_verify_relaxed_udp"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="asm_max_ping_limit">
									<xsl:variable name="cn" select="asm_max_ping_limit"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">IP and ICMP</xsl:with-param>
										<xsl:with-param name="attackName">asm_max_ping_limit</xsl:with-param>
										<xsl:with-param name="attackIsActive">
											<xsl:value-of select="$cn/asm_max_ping_limit"/>
										</xsl:with-param>
										<xsl:with-param name="attackMonitorOnly">
											<xsl:value-of select="$cn/asm_max_ping_limit_monitor_only"/>
										</xsl:with-param>
										<xsl:with-param name="attackTrack">
											<xsl:value-of select="$cn/asm_max_ping_limit_log"/>
										</xsl:with-param>
										<xsl:with-param name="attackAttribName">asm_max_ping_limit_size</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/asm_max_ping_limit_size"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="fw_virtual_defrag">
									<xsl:variable name="cn" select="fw_virtual_defrag"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">IP and ICMP</xsl:with-param>
										<xsl:with-param name="attackName">fw_virtual_defrag</xsl:with-param>
										<xsl:with-param name="attackIsActive">
											<xsl:value-of select="$cn/fwfrag_allow"/>
										</xsl:with-param>
										<xsl:with-param name="attackTrack">
											<xsl:value-of select="$cn/fw_virtual_defrag_log"/>
										</xsl:with-param>
										<xsl:with-param name="attackAttribName">fwfrag_allow</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/fwfrag_allow"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">fwfrag_limit</xsl:with-param>
										<xsl:with-param name="attackAttribValue"   select="$cn/fwfrag_limit" />
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">fwfrag_timeout</xsl:with-param>
										<xsl:with-param name="attackAttribValue"  select="$cn/fwfrag_timeout" />
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="net_quota_protection">
									<xsl:variable name="cn" select="net_quota_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">IP and ICMP</xsl:with-param>
										<xsl:with-param name="attackName">net_quota_protection</xsl:with-param>
										<xsl:with-param name="attackIsActive">
											<xsl:value-of select="$cn/net_quota_enabled"/>
										</xsl:with-param>
										<xsl:with-param name="attackMonitorOnly">
											<xsl:value-of select="not (string ($cn/net_quota_drop) ='true')"/>
										</xsl:with-param>
										<xsl:with-param name="attackTrack">
											<xsl:value-of select="$cn/net_quota_log"/>
										</xsl:with-param>
										<xsl:with-param name="attackAttribName">net_quota_limit</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/net_quota_limit"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">
											<xsl:choose>
												<xsl:when test="string ($cn/net_quota_drop) = 'true'">Drop all further connections from that source</xsl:when>
												<xsl:when test="string ($cn/net_quota_drop) = 'false'">Only track the event</xsl:when>
											</xsl:choose>
										</xsl:with-param>
										<xsl:with-param name="attackAttribValue">true</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">net_quota_timeout</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/net_quota_timeout"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">net_quota_exclusion_list</xsl:with-param>
										<xsl:with-param name="attackAttribValue">IGNORE_SINGLE_VALUE</xsl:with-param>
										<xsl:with-param name="attackMultiAttribValue" select="$cn/net_quota_exclusion_list/net_quota_exclusion_list/Name"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Dynamic updates for IP and ICMP -->
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">IP and ICMP</xsl:with-param>
								</xsl:call-template>
								<!-- TCP Attacks -->
								<xsl:if test="SYN_attack_protection">
									<xsl:variable name="cn" select="SYN_attack_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">TCP</xsl:with-param>
										<xsl:with-param name="attackName">SYN_attack_protection</xsl:with-param>
										<xsl:with-param name="attackIsActive">-</xsl:with-param>
										<xsl:with-param name="attackMonitorOnly">
											<xsl:value-of select="$cn/asm_synatk_monitor_only"/>
										</xsl:with-param>
										<xsl:with-param name="attackTrack" select="$cn/asm_synatk_log"/>
										<xsl:with-param name="attackAttribName">asm_synatk_log_level</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:choose>
												<xsl:when test="string ($cn/asm_synatk_log_level) = '0'">None</xsl:when>
												<xsl:when test="string ($cn/asm_synatk_log_level) = '1'">Attacks only</xsl:when>
												<xsl:when test="string ($cn/asm_synatk_log_level) = '2'">Individual SYN's</xsl:when>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">asm_synatk_global_override</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/asm_synatk_global_override"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">asm_synatk</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/asm_synatk"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">asm_synatk_timeout</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/asm_synatk_timeout"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">asm_synatk_external_only</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/asm_synatk_external_only"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">asm_synatk_threshold</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/asm_synatk_threshold"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">fwsynatk_method</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:choose>
												<xsl:when test="string ($cn/fwsynatk_method) = '0'">None</xsl:when>
												<xsl:when test="string ($cn/fwsynatk_method) = '2'">SYN gateway</xsl:when>
												<xsl:when test="string ($cn/fwsynatk_method) = '3'">Passive SYN gateway</xsl:when>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">fwsynatk_timeout</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/fwsynatk_timeout"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">fwsynatk_max</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/fwsynatk_max"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">fwsynatk_warning</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:choose>
												<xsl:when test="string ($cn/fwsynatk_warning) = '0'">false</xsl:when>
												<xsl:when test="string ($cn/fwsynatk_warning) = '1'">true</xsl:when>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<!-- Small PMTU -->
								<xsl:if test="small_PMTU_protection">
									<xsl:variable name="cn" select="small_PMTU_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">TCP</xsl:with-param>
										<xsl:with-param name="attackName">small_PMTU_protection</xsl:with-param>
										<xsl:with-param name="attackIsActive">
											<xsl:value-of select="$cn/asm_small_pmtu"/>
										</xsl:with-param>
										<xsl:with-param name="attackMonitorOnly">
											<xsl:value-of select="$cn/asm_small_pmtu_monitor_only"/>
										</xsl:with-param>
										<xsl:with-param name="attackTrack">
											<xsl:value-of select="$cn/asm_small_pmtu_log"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">asm_small_pmtu_size</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/asm_small_pmtu_size"/>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<!-- Spoofed reset protection -->
								<xsl:if test="tcp_rst_protection">
									<xsl:variable name="cn" select="tcp_rst_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">TCP</xsl:with-param>
										<xsl:with-param name="attackName">tcp_rst_protection</xsl:with-param>
										<xsl:with-param name="attackIsActive">
											<xsl:value-of select="$cn/asm_tcp_rst"/>
										</xsl:with-param>
										<xsl:with-param name="attackMonitorOnly">
											<xsl:value-of select="$cn/asm_tcp_rst_monitor_only"/>
										</xsl:with-param>
										<xsl:with-param name="attackTrack">
											<xsl:value-of select="$cn/asm_tcp_rst_log"/>
										</xsl:with-param>
										<xsl:with-param name="attackAttribName">asm_tcp_rst_packets_allowed</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/asm_tcp_rst_packets_allowed"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">asm_tcp_rst_duration_to_count</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/asm_tcp_rst_duration_to_count"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">asm_tcp_rst_duration_to_drop</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:value-of select="$cn/asm_tcp_rst_duration_to_drop"/>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">asm_tcp_rst_exclude</xsl:with-param>
										<xsl:with-param name="attackAttribValue">N/A</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<!-- sequence verifaier -->
								<xsl:if test="fw_tcp_seq">
									<xsl:variable name="cn" select="fw_tcp_seq"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">TCP</xsl:with-param>
										<xsl:with-param name="attackName">fw_tcp_seq</xsl:with-param>
										<xsl:with-param name="attackIsActive">
											<xsl:value-of select="$cn/fw_tcp_seq_verify"/>
										</xsl:with-param>
										<xsl:with-param name="attackMonitorOnly">
											<xsl:value-of select="$cn/fw_tcp_seq_verify_monitor_only"/>
										</xsl:with-param>
										<xsl:with-param name="attackTrack">
											<xsl:value-of select="$cn/fw_tcp_seq_verify_track_type"/>
										</xsl:with-param>
										<xsl:with-param name="attackAttribName">fw_tcp_seq_verify_log_level</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:choose>
												<xsl:when test="$cn/fw_tcp_seq_verify_log_level = 1">suspicious</xsl:when>
												<xsl:when test="$cn/fw_tcp_seq_verify_log_level = 4">anomalous</xsl:when>
												<xsl:when test="$cn/fw_tcp_seq_verify_log_level = 5">every</xsl:when>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<!-- Fingerprint Information -->
								<xsl:if test="fingerprint_spoofing">
									<xsl:variable name="cn" select="fingerprint_spoofing"/>
									<!--ISN Spoofing -->
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">Fingerprint Scrambling</xsl:with-param>
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackName">fingerprint_spoofing</xsl:with-param>
										<xsl:with-param name="attackTrack">-</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/asm_fp_isn">-</xsl:with-param>
										<xsl:with-param name="attackAttribName">asm_fp_isn_bits</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/asm_fp_isn_bits"/>
									</xsl:call-template>									
									<!-- TTL -->
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">Fingerprint Scrambling</xsl:with-param>
										<xsl:with-param name="attackName">TTL</xsl:with-param>
										<xsl:with-param name="attackTrack">-</xsl:with-param>
										<xsl:with-param name="attackIsActive">
											<xsl:value-of select="$cn/asm_fp_ttl"/>
										</xsl:with-param>
										<xsl:with-param name="attackAttribName">asm_fp_ttl_value</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/asm_fp_ttl_value"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">asm_fp_ttl_tracert</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/asm_fp_ttl_tracert"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">asm_fp_ttl_threshold</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/asm_fp_ttl_threshold"/>
									</xsl:call-template>
									<!-- IP ID -->
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">Fingerprint Scrambling</xsl:with-param>
										<xsl:with-param name="attackName">IP ID</xsl:with-param>
										<xsl:with-param name="attackTrack">-</xsl:with-param>
										<xsl:with-param name="attackAttribName">IP ID Sequence generation mode</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:choose>
												<xsl:when test="string ($cn/asm_fp_ipid_mode) = '1'">Incremental</xsl:when>
												<xsl:when test="string ($cn/asm_fp_ipid_mode) = '2'">Incremental LE</xsl:when>
												<xsl:when test="string ($cn/asm_fp_ipid_mode) = '3'">Random</xsl:when>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<!--Successive Events / Log Analysis -->
								<!--  log analysis patterns -->
								<xsl:call-template name="attackNewCategory">
									<xsl:with-param name="attackCategory">Successive Events</xsl:with-param>
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
								</xsl:call-template>
								<xsl:for-each select="/asm/as[Name='AdvancedSecurityObject']/cpmad_log_analysis_patterns/*">
									<xsl:if test="(name() != 'Name') and (name() != 'Class_Name') and (name() != 'land_attack' and (name() != 'login_failure') and (name() !='blocked_connection_port_scanning'))">
										<xsl:call-template name="attackFirstRow">
											<xsl:with-param name="attackCategory">Successive Events</xsl:with-param>
											<xsl:with-param name="attackCreateCategory" select="'NO'"/>
											<xsl:with-param name="attackName" select="name()"/>
											<xsl:with-param name="attackIsActive" select="mode"/>
											<xsl:with-param name="attackMonitorOnly">true</xsl:with-param>
											<xsl:with-param name="attackTrack" select="action"/>
											<xsl:with-param name="attackAttribName">-</xsl:with-param>
											<xsl:with-param name="attackAttribValue">-</xsl:with-param>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">number_of_repetitions</xsl:with-param>
											<xsl:with-param name="attackAttribValue">
												<xsl:value-of select="number_of_repetitions"/>
											</xsl:with-param>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">time_interval</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="time_interval"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:for-each>
								<!-- 	====================
							DShield Storm Center
							====================	 -->
								<!-- download stream -->
								<xsl:if test="storm_center_protection/storm_center_list/storm_center_list/storm_center_downstream">
									<xsl:variable name="cn" select="storm_center_protection/storm_center_list/storm_center_list/storm_center_downstream"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">DShield Storm Center</xsl:with-param>
										<xsl:with-param name="attackName">storm_center_downstream</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/enabled"/>
										<xsl:with-param name="attackTrack" select="$cn/track"/>
										<xsl:with-param name="attackAttribName">-</xsl:with-param>
										<xsl:with-param name="attackAttribValue">-</xsl:with-param>
									</xsl:call-template>
									<xsl:if test="string ($cn/block_all_gw) = 'true'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">Retrieve and block malicious IPs for all Gateways</xsl:with-param>
											<xsl:with-param name="attackAttribValue">true</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/block_all_gw) = 'false'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">Retrieve and block malicious IPs for specific Gateways</xsl:with-param>
											<xsl:with-param name="attackAttribValue">IGNORE_SINGLE_VALUE</xsl:with-param>
											<xsl:with-param name="attackMultiAttribValue" select="$cn/specific_blocked_gw/specific_blocked_gw/Name"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:if>
								<!-- upload stream -->
								<xsl:if test="./storm_center_protection/storm_center_list/storm_center_list/storm_center_upstream">
									<xsl:variable name="cn" select="storm_center_protection/storm_center_list/storm_center_list/storm_center_upstream"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">DShield Storm Center</xsl:with-param>
										<xsl:with-param name="attackName">storm_center_upstream</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/enabled"/>
										<xsl:with-param name="attackTrack" select="$cn/log_type_to_submit"/>
										<xsl:with-param name="attackAttribName">sd_upstream_user_name</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/user_name"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">sd_upstream_internal_net_hide</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/internal_net_hide"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">sd_upstream_internal_net_mask</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/internal_net_mask"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">sd_upstream_submission_day_interval</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/submission_day_interval"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">sd_upstream_submission_hour</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/submission_hour"/>
									</xsl:call-template>
								</xsl:if>
								<!-- 	=========
							Port Scan
							========= -->
								<!-- Host port scan -->
								<xsl:if test="//asm_kernel_port_scan_detection/vertical_port_scan">
									<xsl:variable name="cn" select="//asm_kernel_port_scan_detection/vertical_port_scan"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">Port Scan</xsl:with-param>
										<xsl:with-param name="attackName">vertical_port_scan</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/enabled"/>
										<xsl:with-param name="attackTrack" select="$cn/track"/>
										<xsl:with-param name="attackAttribName">-</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string($cn/use_predefined_sensitivity)='true'">
										<xsl:choose>
											<xsl:when test="$cn/predefined_sensitivity_val = 0">
												<xsl:call-template name="attackMoreRows">
													<xsl:with-param name="attackAttribName">port_scan_use_predefined_sensitivity</xsl:with-param>
													<xsl:with-param name="attackAttribValue" select="'Low'"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="$cn/predefined_sensitivity_val = 1">
												<xsl:call-template name="attackMoreRows">
													<xsl:with-param name="attackAttribName">port_scan_use_predefined_sensitivity</xsl:with-param>
													<xsl:with-param name="attackAttribValue" select="'Mediume'"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="$cn/predefined_sensitivity_val = 2">
												<xsl:call-template name="attackMoreRows">
													<xsl:with-param name="attackAttribName">port_scan_use_predefined_sensitivity</xsl:with-param>
													<xsl:with-param name="attackAttribValue" select="'High'"/>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="string($cn/use_predefined_sensitivity)='false'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">port_scan_use_predefined_sensitivity</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'Custom'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">port_scan_accessed_ports_threshold</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/sensitivity_settings/accessed_ports_threshold"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">port_scan_scan_time_frame</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/sensitivity_settings/scan_time_frame"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">port_scan_detect_external_only</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/detect_external_only"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/use_exclusion_list) = 'false'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">port_scan_vertical_use_exclusion_list</xsl:with-param>
											<xsl:with-param name="attackAttribValue">false</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/use_exclusion_list) = 'true'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">port_scan_vertical_use_exclusion_list</xsl:with-param>
											<xsl:with-param name="attackAttribValue">IGNORE_SINGLE_VALUE</xsl:with-param>
											<xsl:with-param name="attackMultiAttribValue" select="$cn/exclusion_list/exclusion_list/Name"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:if>
								<!-- Host port scan -->
								<xsl:if test="//asm_kernel_port_scan_detection/horizontal_port_scan">
									<xsl:variable name="cn" select="//asm_kernel_port_scan_detection/horizontal_port_scan"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">Port Scan</xsl:with-param>
										<xsl:with-param name="attackName">horizontal_port_scan</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/enabled"/>
										<xsl:with-param name="attackTrack" select="$cn/track"/>
										<xsl:with-param name="attackAttribName">-</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string($cn/use_predefined_sensitivity)='true'">
										<xsl:choose>
											<xsl:when test="$cn/predefined_sensitivity_val = 0">
												<xsl:call-template name="attackMoreRows">
													<xsl:with-param name="attackAttribName">port_scan_use_predefined_sensitivity</xsl:with-param>
													<xsl:with-param name="attackAttribValue" select="'Low'"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="$cn/predefined_sensitivity_val = 1">
												<xsl:call-template name="attackMoreRows">
													<xsl:with-param name="attackAttribName">port_scan_use_predefined_sensitivity</xsl:with-param>
													<xsl:with-param name="attackAttribValue" select="'Mediume'"/>
												</xsl:call-template>
											</xsl:when>
											<xsl:when test="$cn/predefined_sensitivity_val = 2">
												<xsl:call-template name="attackMoreRows">
													<xsl:with-param name="attackAttribName">port_scan_use_predefined_sensitivity</xsl:with-param>
													<xsl:with-param name="attackAttribValue" select="'High'"/>
												</xsl:call-template>
											</xsl:when>
										</xsl:choose>
									</xsl:if>
									<xsl:if test="string($cn/use_predefined_sensitivity)='false'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">port_scan_use_predefined_sensitivity</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'Custom'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">port_scan_accessed_ports_threshold</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/sensitivity_settings/accessed_ports_threshold"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">port_scan_time_frame</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/sensitivity_settings/scan_time_frame"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">port_scan_detect_external_only</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/detect_external_only"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/use_exclusion_list) = 'false'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">port_scan_vertical_use_exclusion_list</xsl:with-param>
											<xsl:with-param name="attackAttribValue">false</xsl:with-param>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/use_exclusion_list) = 'true'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">port_scan_horizontal_use_exclusion_list</xsl:with-param>
											<xsl:with-param name="attackAttribValue">IGNORE_SINGLE_VALUE</xsl:with-param>
											<xsl:with-param name="attackMultiAttribValue" select="$cn/exclusion_list/exclusion_list/Name"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:if>
								<!-- 	==============
							Dynamic Ports 
							===============	 -->
								<xsl:if test="dynamic_ports_check">
									<xsl:variable name="cn" select="dynamic_ports_check"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">Dynamic Ports</xsl:with-param>
										<xsl:with-param name="attackName">Dynamic Ports</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="not (string ($cn/ports_check_monitor_only)='true')"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/ports_check_monitor_only"/>
										<xsl:with-param name="attackTrack">-</xsl:with-param>
										<xsl:with-param name="attackAttribName">check_low_ports</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/check_low_ports"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">ports_check_type</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
											<xsl:choose>
												<xsl:when test="string ($cn/ports_check_type) = 'none'">Allow data connections to all defined services' ports</xsl:when>
												<xsl:when test="string ($cn/ports_check_type) = 'severe'">Block data connections to all defined services' ports</xsl:when>
												<xsl:when test="string ($cn/ports_check_type) = 'custom'">Block data connections to the following services' ports:</xsl:when>
											</xsl:choose>
										</xsl:with-param>
									</xsl:call-template>
									<xsl:if test="string ($cn/ports_check_type) = 'custom'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName"> </xsl:with-param>
											<xsl:with-param name="attackAttribValue">IGNORE_SINGLE_VALUE</xsl:with-param>
											<xsl:with-param name="attackMultiAttribValue" select="$cn/ports_to_check/ports_to_check/Name"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:if>
								<TR>
									<TD class="last" align="right" colSpan="10" notag="SKIPTHISTR">
										<DIV class="divStyle" align="center" notag="SKIPTHISTR">
											<A class="back" notag="SKIPTHISTR" href="#sd_ns">Top of table</A> | <A class="back" href="#topOfPage">Top of page</A>
										</DIV>
									</TD>
								</TR>
							</TBODY>
						</TABLE>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
		<!--
			Application Intelligence
			======================== -->
		<a name="ai"/>
		<p/>
		<a name="sd_ai"/>
		<TABLE class="data" cellSpacing="0" cellPadding="0" width="90%" align="center" border="0">
			<TBODY>
				<TR>
					<TD class="title">Application Intelligence
					</TD>
				</TR>
				<TR>
					<TD>
						<TABLE id="idTblAI" cellSpacing="0" cellPadding="0" width="100%" borders="0">
							<TBODY>
								<tr class="header">
									<td class="objects_header">Attack Category</td>
									<td class="objects_header">Attack Name</td>
									<td class="objects_header">Enabled/Disabled</td>
									<td class="objects_header">Track</td>
									<td class="objects_header">Attribute</td>
									<td class="objects_header">Value</td>
								</tr>
								<!-- MAIL -->
								<!-- POP3/Imap Sewcurity -->
								<xsl:if test="mail_servers_enforcement">
									<xsl:variable name="cn" select="mail_servers_enforcement"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">Mail</xsl:with-param>
										<xsl:with-param name="attackAttribName">Mail Servers</xsl:with-param>
										<xsl:with-param name="attackAttribValue">
										     <xsl:variable name="spacer" select="' '"/>	
										      <xsl:for-each select="$network_objects/network_object[additional_products/is_mail_server='true']">
										     		<xsl:value-of select="Name" /> <xsl:value-of select="$spacer" /> 										     		
											</xsl:for-each> 											
										</xsl:with-param>										    
									</xsl:call-template>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">Mail</xsl:with-param>
										<xsl:with-param name="attackName">mail_servers_enforcement</xsl:with-param>
										<xsl:with-param name="attackTrack" select="$cn/mail_servers_alert"></xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/enforce_mail_servers_protection"/>
										<xsl:with-param name="attackMonitorOnly"><xsl:value-of select="$cn/mail_servers_monitor_only"/></xsl:with-param>																			
									</xsl:call-template>									
									<xsl:choose>
										<xsl:when test="string ($cn/apply_mail_servers_enforcement_on) = 'all_defined_mail_servers'">
											<xsl:call-template name="attackMoreRows">
												<xsl:with-param name="attackAttribName">apply_mail_servers_enforcement_on_all</xsl:with-param>
												<xsl:with-param name="attackAttribValue" select="'true'"/>
											</xsl:call-template>
										</xsl:when>
										<xsl:when test="string ($cn/apply_mail_servers_enforcement_on) = 'specific_mail_servers'">
											<xsl:call-template name="attackMoreRows">
												<xsl:with-param name="attackAttribName">apply_mail_servers_enforcement_on_selected</xsl:with-param>
												<xsl:with-param name="attackAttribValue" select="'N/A'"/>
											</xsl:call-template>
										</xsl:when>
									</xsl:choose>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">block_identical_name_and_pass</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/block_identical_name_and_pass"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">mail_server_is_max_username_length</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/is_max_username_length"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">mail_server_max_username_length</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/max_username_length"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">mail_server_block_bin_data</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/block_bin_data"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">mail_server_is_max_noop_cmds</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/is_max_noop_cmds"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">mail_server_max_noop_cmds</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/max_noop_cmds"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">mail_server_allow_unknown_commands</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/allow_unknown_commands) ='true')"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Mail Security Server -->
								<xsl:if test="SMTP_security_server">
									<xsl:variable name="cn" select="SMTP_security_server"/>
									<xsl:if test="string ($cn/smtp_valid_on_all) = 'true'">
										<xsl:call-template name="attackFirstRow">
											<xsl:with-param name="attackCategory">Mail</xsl:with-param>
											<xsl:with-param name="attackName">SMTP_security_server_general_connections_apply</xsl:with-param>
											<xsl:with-param name="attackIsActive">-</xsl:with-param>
											<xsl:with-param name="attackTrack">-</xsl:with-param>
											<xsl:with-param name="attackAttribName">smtp_valid_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn//smtp_valid_on_all) = 'false'">
										<xsl:call-template name="attackFirstRow">
											<xsl:with-param name="attackCategory">Mail</xsl:with-param>
											<xsl:with-param name="attackName">SMTP_security_server_general_connections_apply</xsl:with-param>
											<xsl:with-param name="attackIsActive">-</xsl:with-param>
											<xsl:with-param name="attackTrack">-</xsl:with-param>
											<xsl:with-param name="attackAttribName">smtp_valid_on_rulebase</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<!--SMTP Contents -->
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">Mail</xsl:with-param>
										<xsl:with-param name="attackName">SMTP_security_server</xsl:with-param>
										<xsl:with-param name="attackIsActive">-</xsl:with-param>
										<xsl:with-param name="attackTrack">-</xsl:with-param>
										<xsl:with-param name="attackAttribName">-</xsl:with-param>
										<xsl:with-param name="attackAttribValue">-</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">smtp_add_received_header</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/smtp_add_received_header"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">smtp_log_unknown_commands</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/smtp_log_unknown_commands"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">smtp_check_bad_commands</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/smtp_check_bad_commands"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">smtp_max_allowed_nop_commands</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/smtp_max_allowed_nop_commands"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">smtp_max_allowed_err_commands</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/smtp_max_allowed_err_commands"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">smtp_log_too_many_commands</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/smtp_log_too_many_commands"/>
									</xsl:call-template>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">Mail</xsl:with-param>
										<xsl:with-param name="attackName">Mail and Recipient content</xsl:with-param>
										<xsl:with-param name="attackIsActive">-</xsl:with-param>
										<xsl:with-param name="attackTrack">-</xsl:with-param>
										<xsl:with-param name="attackAttribName">-</xsl:with-param>
										<xsl:with-param name="attackAttribValue">-</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">smtp_multi_cont_type</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/smtp_multi_cont_type) = 'true')"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">smtp_multi_encoding</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/smtp_multi_encoding) = 'true')"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">smtp_composite_encoding</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/smtp_composite_encoding) = 'true')"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">smtp_unknown_encoding</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/smtp_unknown_encoding) = 'true')"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">smtp_force_recipient_domain</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/smtp_force_recipient_domain"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">smtp_direct_mime_strip</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/smtp_direct_mime_strip"/>
									</xsl:call-template>
								</xsl:if>
								<!-- MAIL - Dynamic Updates -->
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">Mail</xsl:with-param>
								</xsl:call-template>
								<!-- FTP -->
								<xsl:if test="ftp_bounce_protection">
									<xsl:variable name="cn" select="ftp_bounce_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">FTP</xsl:with-param>
										<xsl:with-param name="attackName">ftp_bounce_protection</xsl:with-param>
										<xsl:with-param name="attackIsActive">-</xsl:with-param>
										<xsl:with-param name="attackMonitorOnly" select="$cn/asm_ftp_bounce_monitor_only"/>
										<xsl:with-param name="attackTrack" select="ftp_bounce_protection/asm_ftp_bounce_log"/>
										<xsl:with-param name="attackAttribName">-</xsl:with-param>
										<xsl:with-param name="attackAttribValue">-</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="FTP_security_server">
									<xsl:variable name="cn" select="FTP_security_server"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">FTP</xsl:with-param>
										<xsl:with-param name="attackName">FTP_Security_Server</xsl:with-param>
										<xsl:with-param name="attackIsActive"/>
										<xsl:with-param name="attackTrack">_</xsl:with-param>
										<xsl:with-param name="attackAttribName">
											<xsl:choose>
												<xsl:when test="string ($cn/ftp_valid_on_all) = 'true'">Configurations apply to all connections</xsl:when>
												<xsl:when test="string ($cn/ftp_valid_on_all) = 'false'">Configurations apply only to connections related to resources used in the Rule Base</xsl:when>
											</xsl:choose>
										</xsl:with-param>
										<xsl:with-param name="attackAttribValue">true</xsl:with-param>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">ftp_allowed_cmds</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="FTP_security_server/ftp_allowed_cmds"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">ftp_unallowed_cmds</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="FTP_security_server/ftp_unallowed_cmds"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">ftp_dont_check_cmd_vals</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="FTP_security_server/ftp_dont_check_cmd_vals"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">ftp_dont_check_random_port</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="FTP_security_server/ftp_dont_check_random_port"/>
									</xsl:call-template>
								</xsl:if>
								<!-- FTP - Dynamic Updates -->
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">FTP</xsl:with-param>
								</xsl:call-template>
								<!-- MS Networks -->
								<xsl:if test="ms_protocols_protection">
									<xsl:variable name="cn" select="ms_protocols_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">Microsoft Networks</xsl:with-param>
										<xsl:with-param name="attackName">-</xsl:with-param>
										<xsl:with-param name="attackIsActive">-</xsl:with-param>
										<xsl:with-param name="attackTrack">-</xsl:with-param>
										<xsl:with-param name="attackAttribName">asm_cifs_proto_verf_log_only</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/asm_cifs_proto_verf_log_only)='true')"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">ms_protocols_valid_on_all</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/ms_protocols_valid_on_all"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">ms_protocols_valid_on_all_not</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="not ($cn/ms_protocols_valid_on_all)"/>
									</xsl:call-template>
								</xsl:if>
								<!-- file and print sharing -->
								<xsl:if test="ms_protocols_protection">
									<xsl:variable name="cn" select="ms_protocols_protection/general_cifs_worm_catcher_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">Microsoft Networks</xsl:with-param>
										<xsl:with-param name="attackName">ms_file_and_print_sharing</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/asm_cifs_worm_catcher"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/asm_cifs_worm_catcher_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/asm_cifs_worm_catcher_log"/>
									</xsl:call-template>
									<xsl:for-each select="ms_protocols_protection/general_cifs_worm_catcher_protection/cifs_worm_patterns/*">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName" select="worm_name"/>
											<xsl:with-param name="attackAttribValue" select="mode"/>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:if>
								<!--  - Microsoft Networks - Dynamic updates -->
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">Microsoft Networks</xsl:with-param>
								</xsl:call-template>
								<!-- Peer to peer -->
								<xsl:if test="peer_to_peer_protection">
									<xsl:variable name="cn" select="peer_to_peer_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">Peer to Peer</xsl:with-param>
										<xsl:with-param name="attackName"/>
										<xsl:with-param name="attackIsActive"/>
										<xsl:with-param name="attackTrack"/>
										<xsl:with-param name="attackAttribName"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">p2p_exclude_ports</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/p2p_exclude_ports"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/p2p_exclude_ports) = 'true'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">Excluded services</xsl:with-param>
											<xsl:with-param name="attackAttribValue">IGNORE_SINGLE_VALUE</xsl:with-param>
											<xsl:with-param name="attackMultiAttribValue" select="$cn/p2p_ports_exclusion_list/p2p_ports_exclusion_list/Name"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">p2p_exclude_hosts</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/p2p_exclude_hosts"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/p2p_exclude_hosts) = 'true'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">Excluded network objects</xsl:with-param>
											<xsl:with-param name="attackAttribValue">IGNORE_SINGLE_VALUE</xsl:with-param>
											<xsl:with-param name="attackMultiAttribValue" select="$cn/p2p_hosts_exclusion_list/p2p_hosts_exclusion_list/Name"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:for-each select="$cn/p2p_applications/p2p_applications[p2p_application_parent='peer_to_peer_enforcement']">
										<xsl:call-template name="attackFirstRow">
											<xsl:with-param name="attackCreateCategory" select="'Peer to Peer'"/>
											<xsl:with-param name="attackCategory">Peer to Peer</xsl:with-param>
											<xsl:with-param name="attackName" select="./p2p_display_title"/>
											<xsl:with-param name="attackInfoLink" select="./p2p_display_title"/>
											<xsl:with-param name="attackIsActive" select="./p2p_enforce_application"/>
											<xsl:with-param name="attackMonitorOnly" select="./p2p_monitor_only"/>
											<xsl:with-param name="attackTrack" select="./p2p_track_options"/>
											<xsl:with-param name="attackAttribName" select="'-'"/>
											<xsl:with-param name="attackAttribValue"/>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">p2p_enforce_protocol</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="./p2p_enforce_protocol"/>
										</xsl:call-template>
										<xsl-if test="string (./p2p_enforce_http) = 'true'">
											<xsl:for-each select="./p2p_http_patterns/p2p_http_patterns">
												<xsl:call-template name="attackMoreRows">
													<xsl:with-param name="attackAttribName" select="./p2p_match_string"/>
													<xsl:with-param name="attackAttribValue" select="./p2p_enforce_pattern"/>
												</xsl:call-template>
											</xsl:for-each>
										</xsl-if>
									</xsl:for-each>
									<!--Peer to Peer - Dynamic updates -->
									<xsl:call-template name="dynamicUpdate">
										<xsl:with-param name="duCategoty">Peer to Peer</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<!-- Instant Messenger	 -->
								<xsl:if test="instant_messengers">
									<xsl:variable name="cn" select="instant_messengers"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">Instant Messengers</xsl:with-param>
										<xsl:with-param name="attackName"/>
										<xsl:with-param name="attackIsActive"/>
										<xsl:with-param name="attackTrack"/>
										<xsl:with-param name="attackAttribName"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">instant_msg_exclude_ports</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/instant_msg_exclude_ports"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/instant_msg_exclude_hosts) = 'true'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">Excluded ports</xsl:with-param>
											<xsl:with-param name="attackAttribValue">IGNORE_SINGLE_VALUE</xsl:with-param>
											<xsl:with-param name="attackMultiAttribValue" select="$cn/instant_msg_ports_exclusion_list/instant_msg_ports_exclusion_list/Name"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">instant_msg_exclude_hosts</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/instant_msg_exclude_hosts"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/instant_msg_exclude_hosts) = 'true'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">Excluded network objects</xsl:with-param>
											<xsl:with-param name="attackAttribValue">IGNORE_SINGLE_VALUE</xsl:with-param>
											<xsl:with-param name="attackMultiAttribValue" select="$cn/instant_msg_hosts_exclusion_list/instant_msg_hosts_exclusion_list/Name"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">Instant Messengers</xsl:with-param>
										<xsl:with-param name="attackName" select="'msn_msnms'"/>
										<xsl:with-param name="attackIsActive" select="$cn/msn_msnms/msnms_enabled"/>
										<xsl:with-param name="attackTrack"/>
										<xsl:with-param name="attackAttribName"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">msnms_block_video</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/msn_msnms/msnms_block_video"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">msnms_block_audio</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/msn_msnms/msnms_block_audio"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">msnms_block_file_transfer</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/msn_msnms/msnms_block_file_transfer"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">msnms_block_application_sharing</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/msn_msnms/msnms_block_application_sharing"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">msnms_block_white_board</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/msn_msnms/msnms_block_white_board"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">msnms_block_remote_assistant</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/msn_msnms/msnms_block_remote_assistant"/>
									</xsl:call-template>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">Instant Messengers</xsl:with-param>
										<xsl:with-param name="attackName" select="'msn_sip'"/>
										<xsl:with-param name="attackIsActive" select="$cn/msn_sip/sip_enabled"/>
										<xsl:with-param name="attackTrack"/>
										<xsl:with-param name="attackAttribName"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">sip_block_file_transfer</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/msn_sip/sip_block_file_transfer"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">sip_block_application_sharing</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/msn_sip/sip_block_application_sharing"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">sip_block_white_board</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/msn_sip/sip_block_white_board"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">sip_block_remote_assistant</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/msn_sip/sip_block_remote_assistant"/>
									</xsl:call-template>
									<xsl:for-each select="./peer_to_peer_protection/p2p_applications/p2p_applications[p2p_application_parent='instant_messengers']">
										<xsl:call-template name="attackFirstRow">
											<xsl:with-param name="attackCreateCategory" select="'Instant Messengers'"/>
											<xsl:with-param name="attackCategory">Instant Messengers</xsl:with-param>
											<xsl:with-param name="attackName" select="./p2p_display_title"/>
											<xsl:with-param name="attackInfoLink" select="./p2p_display_title"/>
											<xsl:with-param name="attackIsActive" select="./p2p_enforce_application"/>
											<xsl:with-param name="attackMonitorOnly" select="./p2p_monitor_only"/>
											<xsl:with-param name="attackTrack" select="./p2p_track_options"/>
											<xsl:with-param name="attackAttribName" select="'-'"/>
											<xsl:with-param name="attackAttribValue"/>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">p2p_enforce_protocol</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="./p2p_enforce_protocol"/>
										</xsl:call-template>
										<xsl-if test="string (./p2p_enforce_http) = 'true'">
											<xsl:for-each select="./p2p_http_patterns/p2p_http_patterns">
												<xsl:call-template name="attackMoreRows">
													<xsl:with-param name="attackAttribName" select="./p2p_match_string"/>
													<xsl:with-param name="attackAttribValue" select="./p2p_enforce_pattern"/>
												</xsl:call-template>
											</xsl:for-each>
										</xsl-if>
									</xsl:for-each>
									<!--instant_messengers - Dynamic updates -->
									<xsl:call-template name="dynamicUpdate">
										<xsl:with-param name="duCategoty">Instant Messengers</xsl:with-param>
									</xsl:call-template>
								</xsl:if>
								<!-- DNS -->
								<xsl:if test="fw_dns_enforcement">
									<xsl:variable name="cn" select="fw_dns_enforcement"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">DNS</xsl:with-param>
										<xsl:with-param name="attackName">-</xsl:with-param>
										<xsl:with-param name="attackIsActive">-</xsl:with-param>
										<xsl:with-param name="attackTrack" select="$cn/fw_dns_verification_track"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/fw_dns_verification_monitor_only"/>
										<xsl:with-param name="attackAttribName">-</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'fw_dns_verification'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/fw_dns_verification"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'fw_dns_tcp_verification'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/fw_dns_tcp_verification"/>
									</xsl:call-template>
								</xsl:if>
								<!-- domain blick list -->
								<xsl:if test="dns_black_list">
									<xsl:variable name="cn" select="dns_black_list"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">DNS</xsl:with-param>
										<xsl:with-param name="attackName">dns_black_list</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/enforce_dns_black_list"/>
										<xsl:with-param name="attackTrack" select="$cn/dns_black_list_track"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/dns_black_list_monitor_only"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">domains_black_list</xsl:with-param>
										<xsl:with-param name="attackAttribValue">IGNORE_SINGLE_VALUE</xsl:with-param>
										<xsl:with-param name="attackMultiAttribValue" select="$cn/domains_black_list/domains_black_list/Name"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Cache Poisoning -->
								<xsl:if test="dns_randomization">
									<xsl:variable name="cn" select="dns_black_list"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">DNS</xsl:with-param>
										<xsl:with-param name="attackName">Cache Poisoning</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="'-'"/>
										<xsl:with-param name="attackTrack" select="'-'"/>
										<xsl:with-param name="attackMonitorOnly" select="'-'"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Scrambling -->
								<xsl:if test="dns_randomization">
									<xsl:variable name="cn" select="dns_randomization"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">DNS</xsl:with-param>
										<xsl:with-param name="attackName">enforce_dns_randomization</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/enforce_dns_randomization"/>
										<xsl:with-param name="attackTrack" select="'-'"/>
										<xsl:with-param name="attackMonitorOnly" select="'-'"/>
										<xsl:with-param name="attackAttribName" select="$cn/apply_dns_randomization_on"/>
										<xsl:with-param name="attackAttribValue" select="'true'"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Drop inbound request -->
								<xsl:if test="dns_drop_external_domain_request">
									<xsl:variable name="cn" select="dns_drop_external_domain_request"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">DNS</xsl:with-param>
										<xsl:with-param name="attackName">dns_drop_external_domain_request</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/enforce_drop_dns_external_domain_request"/>
										<xsl:with-param name="attackTrack" select="$cn/dns_drop_ext_domain_req_track"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/dns_drop_ext_domain_req_monitor_only"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'dns_drop_external_domain_reques_which_servers'"/>
										<xsl:with-param name="attackAttribValue" select="'N/A'"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Mismatch replies -->
								<xsl:if test="dns_mismatched_replies">
									<xsl:variable name="cn" select="dns_mismatched_replies"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">DNS</xsl:with-param>
										<xsl:with-param name="attackName" select="'dns_mismatched_replies'"/>
										<xsl:with-param name="attackIsActive" select="$cn/enforce_dns_mismatched_replies"/>
										<xsl:with-param name="attackTrack" select="$cn/mismatched_replies_track"/>
										<xsl:with-param name="attackAttribName" select="'mismatched_replies_threshold'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/mismatched_replies_threshold"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'mismatched_replies_threshold_expiry'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/mismatched_replies_threshold_expiry"/>
									</xsl:call-template>
								</xsl:if>
								<!-- DNS Dynamic -->
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">DNS</xsl:with-param>
								</xsl:call-template>
								<!--	====
				   VoIP
				   ====	 -->
								<!-- voip general -->
								<xsl:if test="voip_dos_enforcement">
									<xsl:variable name="cn" select="voip_dos_enforcement"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">VoIP</xsl:with-param>
										<xsl:with-param name="attackName" select="'General Settings'"/>
										<xsl:with-param name="attackIsActive" select="'-'"/>
										<xsl:with-param name="attackTrack" select="'-'"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'voip_enforce_dos_protection'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/voip_enforce_dos_protection"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'voip_user_calls_per_minute'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/voip_user_calls_per_minute"/>
									</xsl:call-template>
								</xsl:if>
								<!-- H232 -->
								<xsl:if test="fw_h323_enforcement">
									<xsl:variable name="cn" select="fw_h323_enforcement"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">VoIP</xsl:with-param>
										<xsl:with-param name="attackName">fw_h323_enforcement</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="'-'"/>
										<xsl:with-param name="attackTrack" select="'-'"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'fwh323_allow_redirect'"/>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/fwh323_allow_redirect) = 'true')"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'fwh323_force_src_phone'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/fwh323_force_src_phone"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'allow_h323_t120'"/>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/allow_h323_t120) = 'true')"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'allow_h323_h245_tunneling'"/>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/allow_h323_h245_tunneling) = 'true')"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'allow_h323_through_ras'"/>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/allow_h323_through_ras) = 'true')"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'h323_enforce_setup'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/h323_enforce_setup"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'h323_t120_timeout'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/h323_t120_timeout"/>
									</xsl:call-template>
								</xsl:if>
								<!-- SIP -->
								<xsl:if test="fwsip_header_content_enforcement">
									<xsl:variable name="cn" select="fwsip_header_content_enforcement"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">VoIP</xsl:with-param>
										<xsl:with-param name="attackName">fwsip_header_content_enforcement</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="'-'"/>
										<xsl:with-param name="attackTrack" select="'-'"/>
										<xsl:with-param name="attackAttribName" select="'fwsip_header_content_verification'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/fwsip_header_content_verification"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'sip_allow_redirect'"/>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/sip_allow_redirect) = 'true')"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'sip_reg_default_expiration'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/sip_reg_default_expiration"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'sip_enforce_security_reinvite'"/>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/sip_enforce_security_reinvite) = 'true')"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'sip_max_reinvite'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/sip_max_reinvite"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'sip_block_video'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/sip_block_video"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'sip_allow_two_media_conns'"/>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/sip_allow_two_media_conns) = 'true')"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'sip_block_audio'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/sip_block_audio"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'sip_allow_instant_messages'"/>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/sip_allow_instant_messages) = 'true')"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'sip_accept_unknown_messages'"/>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/sip_accept_unknown_messages) = 'true')"/>
									</xsl:call-template>
								</xsl:if>
								<!-- MGCP -->
								<xsl:if test="fw_mgcp_enforcement">
									<xsl:variable name="cn" select="fw_mgcp_enforcement"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">VoIP</xsl:with-param>
										<xsl:with-param name="attackName">fw_mgcp_enforcement</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/mgcp_hdr_content_verifier"/>
										<xsl:with-param name="attackTrack" select="'-'"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">mgcp_command_accepted_true</xsl:with-param>
										<xsl:with-param name="attackAttribValue">IGNORE_SINGLE_VALUE</xsl:with-param>
										<xsl:with-param name="attackMultiAttribValue" select="$cn/mgcp_commands_list/mgcp_commands_list[mgcp_command_accepted='true']/mgcp_command_text"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">mgcp_command_accepted_false</xsl:with-param>
										<xsl:with-param name="attackAttribValue">IGNORE_SINGLE_VALUE</xsl:with-param>
										<xsl:with-param name="attackMultiAttribValue" select="$cn/mgcp_commands_list/mgcp_commands_list[mgcp_command_accepted='false']/mgcp_command_text"/>
									</xsl:call-template>
								</xsl:if>
								<!-- SCCP (Skinny) -->
								<xsl:if test="fw_skinny_enforcement">
									<xsl:variable name="cn" select="fw_skinny_enforcement"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">VoIP</xsl:with-param>
										<xsl:with-param name="attackName">fw_skinny_enforcement</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="'-'"/>
										<xsl:with-param name="attackTrack" select="'-'"/>
										<xsl:with-param name="attackAttribName" select="'skinny_hdr_content_verifier'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/skinny_hdr_content_verifier"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'fw_skinny_allow_multicast'"/>
										<xsl:with-param name="attackAttribValue" select="not (string ($cn/fw_skinny_allow_multicast) = 'true')"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Dynamic update for Voip -->
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">VoIP</xsl:with-param>
								</xsl:call-template>
								<!-- ======
					  SNMP 
					  ======= -->
								<xsl:if test="snmp_protection">
									<xsl:variable name="cn" select="snmp_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">SNMP</xsl:with-param>
										<xsl:with-param name="attackName">-</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="'-'"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/snmp_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/snmp_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/snmp_allow_only_snmpv3) = 'true'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName" select="'snmp_allow_only_snmpv3_false'"/>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/snmp_allow_only_snmpv3) = 'false'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName" select="'snmp_allow_only_snmpv3_true'"/>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
										<xsl:if test="string ($cn/snmp_drop_default_communities) = 'true'">
											<xsl:call-template name="attackMoreRows">
												<xsl:with-param name="attackAttribName">snmp_drop_default_communities</xsl:with-param>
												<xsl:with-param name="attackAttribValue">IGNORE_SINGLE_VALUE</xsl:with-param>
												<xsl:with-param name="attackMultiAttribValue" select="$cn/snmp_default_communities_list/snmp_default_communities_list"/>
											</xsl:call-template>
										</xsl:if>
									</xsl:if>
								</xsl:if>
								<!-- ==============
						        VPN Protocols 
					            ============== -->
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
									<xsl:with-param name="attackCategory">VPN Protocols</xsl:with-param>
									<xsl:with-param name="attackName">-</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="'-'"/>
									<xsl:with-param name="attackMonitorOnly" select="'-'"/>
									<xsl:with-param name="attackTrack" select="'-'"/>
									<xsl:with-param name="attackAttribName" select="'-'"/>
									<xsl:with-param name="attackAttribValue" select="'-'"/>
								</xsl:call-template>
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">VPN Protocols</xsl:with-param>
								</xsl:call-template>
								<!-- SSH -->
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
									<xsl:with-param name="attackCategory">SSH</xsl:with-param>
									<xsl:with-param name="attackName">-</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="'-'"/>
									<xsl:with-param name="attackMonitorOnly" select="'-'"/>
									<xsl:with-param name="attackTrack" select="'-'"/>
									<xsl:with-param name="attackAttribName" select="'-'"/>
									<xsl:with-param name="attackAttribValue" select="'-'"/>
								</xsl:call-template>
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">SSH</xsl:with-param>
								</xsl:call-template>
								<!-- Content Protection -->
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
									<xsl:with-param name="attackCategory">Content Protection</xsl:with-param>
									<xsl:with-param name="attackName">-</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="'-'"/>
									<xsl:with-param name="attackMonitorOnly" select="'-'"/>
									<xsl:with-param name="attackTrack" select="'-'"/>
									<xsl:with-param name="attackAttribName" select="'-'"/>
									<xsl:with-param name="attackAttribValue" select="'-'"/>
								</xsl:call-template>
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">Content Protection</xsl:with-param>
								</xsl:call-template>
								<!-- MS-RPC -->
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
									<xsl:with-param name="attackCategory">MS-RPC</xsl:with-param>
									<xsl:with-param name="attackName">-</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="'-'"/>
									<xsl:with-param name="attackMonitorOnly" select="'-'"/>
									<xsl:with-param name="attackTrack" select="'-'"/>
									<xsl:with-param name="attackAttribName" select="'-'"/>
									<xsl:with-param name="attackAttribValue" select="'-'"/>
								</xsl:call-template>
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">MS-RPC</xsl:with-param>
								</xsl:call-template>
								<!--MS-SQL -->
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
									<xsl:with-param name="attackCategory">MS-SQL</xsl:with-param>
									<xsl:with-param name="attackName">-</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="'-'"/>
									<xsl:with-param name="attackMonitorOnly" select="'-'"/>
									<xsl:with-param name="attackTrack" select="'-'"/>
									<xsl:with-param name="attackAttribName" select="'-'"/>
									<xsl:with-param name="attackAttribValue" select="'-'"/>
								</xsl:call-template>
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">MS-SQL</xsl:with-param>
								</xsl:call-template>
								<!--SOCKS -->
								<xsl:call-template name="dynamicUpdateByObjName">
									<xsl:with-param name="objName" select="'SOCKS'"/>
									<xsl:with-param name="parentName" select="'Application Intelligence'"/>
								</xsl:call-template>
								<!--Routing Protocols -->
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
									<xsl:with-param name="attackCategory">Routing Protocols</xsl:with-param>
									<xsl:with-param name="attackName">-</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="'-'"/>
									<xsl:with-param name="attackMonitorOnly" select="'-'"/>
									<xsl:with-param name="attackTrack" select="'-'"/>
									<xsl:with-param name="attackAttribName" select="'-'"/>
									<xsl:with-param name="attackAttribValue" select="'-'"/>
								</xsl:call-template>
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">Routing Protocols</xsl:with-param>
								</xsl:call-template>
								<!--SUN-RPC -->
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
									<xsl:with-param name="attackCategory">SUN-RPC</xsl:with-param>
									<xsl:with-param name="attackName">-</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="'-'"/>
									<xsl:with-param name="attackMonitorOnly" select="'-'"/>
									<xsl:with-param name="attackTrack" select="'-'"/>
									<xsl:with-param name="attackAttribName" select="'-'"/>
									<xsl:with-param name="attackAttribValue" select="'-'"/>
								</xsl:call-template>
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">SUN-RPC</xsl:with-param>
								</xsl:call-template>
								<!--DHCP -->
								<xsl:call-template name="dynamicUpdateByObjName">
									<xsl:with-param name="objName" select="'DHCP'"/>
									<xsl:with-param name="parentName" select="'Application Intelligence'"/>
								</xsl:call-template>
								<!--Remote Control Applications -->
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
									<xsl:with-param name="attackCategory">Remote Control Applications</xsl:with-param>
									<xsl:with-param name="attackName">-</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="'-'"/>
									<xsl:with-param name="attackMonitorOnly" select="'-'"/>
									<xsl:with-param name="attackTrack" select="'-'"/>
									<xsl:with-param name="attackAttribName" select="'-'"/>
									<xsl:with-param name="attackAttribValue" select="'-'"/>
								</xsl:call-template>
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">Remote Control Applications</xsl:with-param>
								</xsl:call-template>
								<!--Remote Administrator -->
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
									<xsl:with-param name="attackCategory">Remote Administrator</xsl:with-param>
									<xsl:with-param name="attackName">-</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="'-'"/>
									<xsl:with-param name="attackMonitorOnly" select="'-'"/>
									<xsl:with-param name="attackTrack" select="'-'"/>
									<xsl:with-param name="attackAttribName" select="'-'"/>
									<xsl:with-param name="attackAttribValue" select="'-'"/>
								</xsl:call-template>
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">Remote Administrator</xsl:with-param>
								</xsl:call-template>
								<!-- 	================================================
							Dynamic Updates: General all others goes here... 
							=================================================	 -->
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">ALL_DU_WITH_NEW_CATEGORY</xsl:with-param>
								</xsl:call-template>
								<TR>
									<TD class="last" align="right" colSpan="10" notag="SKIPTHISTR">
										<DIV class="divStyle" align="center" notag="SKIPTHISTR">
											<A class="back" notag="SKIPTHISTR" href="#sd_ai">Top of table</A> | <A class="back" href="#topOfPage">Top of page</A>
										</DIV>
									</TD>
								</TR>
							</TBODY>
						</TABLE>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
		<!--  
				===================
				Web Intelligence 
				===================
												 -->


												 
		<a name="sd_wi"/>
		<TABLE class="data" cellSpacing="0" cellPadding="0" width="90%" align="center" border="0">
			<TBODY>
				<TR>
					<TD class="title">Web Intelligence
					</TD>					
				</TR>
				<TR>
					<TD>
						<TABLE id="idTblWI1" cellSpacing="0" cellPadding="0" width="100%" border="0">
							<TBODY>
								<tr class="header">
									<td class="objects_header">Web Servers View </td>
									<td class="objects_header">Protection Name</td>
									<td class="objects_header">Value</td>
								</tr>

								<xsl:variable name="aso" select="HTTP_security_server"/>
								<!--Start Iterator -->									
								<xsl:for-each select="$network_objects/network_object[additional_products/is_web_server='true']">

								<tr class="sectionTitleASM">
									<td class="sectionTitle" valign="top" width="100">
										<a>	<xsl:attribute name="href">asm_help/http.html</xsl:attribute><xsl:value-of  select="Name"/></a>
									</td>
									<td class="sectionTitle" valign="top">-</td>									
									<td class="sectionTitle" valign="top" notag="CPCATEGORYMARKTAG">-</td>
								</tr>
										<xsl:call-template name="serverMoreRows">	
											<xsl:with-param name="attackAttribName">Worm Catcher</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="additional_products/web_server_prop/http_worm_catcher"/>
										</xsl:call-template>
										<xsl:call-template name="serverMoreRows">
											<xsl:with-param name="attackAttribName">Malicious Code Protector</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="additional_products/web_server_prop/http_buffer_overflow"/>
										</xsl:call-template>

										<xsl:call-template name="serverMoreRows">
											<xsl:with-param name="attackAttribName">LDAP</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="additional_products/web_server_prop/http_ldap_injection"/>
										</xsl:call-template>
										<xsl:call-template name="serverMoreRows">
											<xsl:with-param name="attackAttribName">SQL</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="additional_products/web_server_prop/http_sql_injection"/>
										</xsl:call-template>
										<xsl:call-template name="serverMoreRows">
											<xsl:with-param name="attackAttribName">Command</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="additional_products/web_server_prop/http_command_stealth"/>
										</xsl:call-template>
										<xsl:call-template name="serverMoreRows">
											<xsl:with-param name="attackAttribName">Directory</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="additional_products/web_server_prop/http_directory_listing"/>
										</xsl:call-template>
										<xsl:call-template name="serverMoreRows">
											<xsl:with-param name="attackAttribName">Spoofing</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="additional_products/web_server_prop/http_generic_header_spoofing"/>
										</xsl:call-template>
										<xsl:call-template name="serverMoreRows">
											<xsl:with-param name="attackAttribName">Error Concealming</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="additional_products/web_server_prop/http_error_concealment"/>
										</xsl:call-template>
										<xsl:call-template name="serverMoreRows">
											<xsl:with-param name="attackAttribName">Listing</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="additional_products/web_server_prop/http_directory_listing"/>
										</xsl:call-template>
										<xsl:call-template name="serverMoreRows">
											<xsl:with-param name="attackAttribName">Sizing</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="additional_products/web_server_prop/http_format_size"/>
										</xsl:call-template>
										<xsl:call-template name="serverMoreRows">
											<xsl:with-param name="attackAttribName">ASCII Only Request</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="additional_products/web_server_prop/http_request_validity"/>
										</xsl:call-template>
										<xsl:call-template name="serverMoreRows">
											<xsl:with-param name="attackAttribName">ASCII Only Response</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="$aso/http_check_response_validity"/>
										</xsl:call-template>
										<xsl:call-template name="serverMoreRows">
											<xsl:with-param name="attackAttribName">Rejection</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="additional_products/web_server_prop/http_header_rejection"/>
										</xsl:call-template>										
										<xsl:call-template name="serverMoreRows">
											<xsl:with-param name="attackAttribName">Methods</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="additional_products/web_server_prop/http_allow_methods"/>
										</xsl:call-template>								
									<!--End Iterator -->
									</xsl:for-each>
									<!--Web Servers View END-->								
							</TBODY>	
						</TABLE>
					</TD>	
				</TR>
				
				<TR>
					<TD>
						<TABLE id="idTblWI" cellSpacing="0" cellPadding="0" width="100%" border="0">
							<TBODY>
								<tr class="header">
									<td class="objects_header">Attack Category</td>
									<td class="objects_header">Attack Name</td>
									<td class="objects_header">Enabled/Disabled</td>
									<td class="objects_header">Track</td>
									<td class="objects_header">Attribute</td>
									<td class="objects_header">Value</td>
								</tr>
								
								<!-- === WEB === -->	

								<!-- General HTTP worn catcher -->
								<xsl:if test="general_http_worm_catcher_protection">
									<xsl:variable name="cn" select="general_http_worm_catcher_protection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">Malicious Code</xsl:with-param>
										<xsl:with-param name="attackName">general_http_worm_catcher_protection</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/asm_http_worm_catcher"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_worm_catcher_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/asm_http_worm_catcher_log"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_apply_worm_catcher_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_apply_worm_catcher_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">Enabled Worm Patterns</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="'IGNORE_SINGLE_VALUE'"/>
										<xsl:with-param name="attackMultiAttribValue" select="$cn/worm_patterns/worm_patterns[mode = 'true']/worm_name"/>
									</xsl:call-template>
								</xsl:if>
								<!-- error file configurations -->
								<xsl:if test="html_error_file">
									<xsl:variable name="cn" select="html_error_file"/>
									<xsl:if test="string ($cn/enable_redirect_url) = 'false'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">enable_redirect_url_false</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">enable_company_logo_url</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="$cn/enable_company_logo_url"/>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">company_logo_url</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="$cn/company_logo_url"/>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">show_error_id</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="$cn/show_error_id"/>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_enable_error_response_code</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="not (string ($cn/http_enable_error_response_code) = 'true')"/>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">description</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="$cn/description"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/enable_redirect_url) = 'true'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">enable_redirect_url_true</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">redirect_url</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="$cn/redirect_url"/>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">send_error_id</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="$cn/send_error_id"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:if>
								<!-- Malicious Code Protector -->
								<xsl:if test="HTTP_security_server/http_buffer_overflow">
									<xsl:variable name="cn" select="HTTP_security_server/http_buffer_overflow"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">Malicious Code</xsl:with-param>
										<xsl:with-param name="attackName">http_buffer_overflow</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_enforce_buffer_overflow"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_buffer_overflow_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/http_buffer_overflow_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_buffer_overflow_apply_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_buffer_overflow_apply_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">http_buffer_overflow_level</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/http_buffer_overflow_level"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">http_buffer_overflow_send_error</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/http_buffer_overflow_send_error"/>
									</xsl:call-template>
								</xsl:if>
								<!-- protector optimizations -->
								<xsl:if test="buffer_overflow_protection">
									<xsl:variable name="cn" select="buffer_overflow_protection"/>
									<xsl:if test="string ($cn/buffer_overflow_optimize_memory) = 'true'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">buffer_overflow_optimize_memory</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'Optimize memory'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/buffer_overflow_optimize_memory) = 'false'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">buffer_overflow_optimize_memory</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'Optimize speed'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/buffer_overflow_disasm_anchor) = 'every_byte'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">buffer_overflow_disasm_anchor</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'Optimize security'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/buffer_overflow_disasm_anchor) = 'os_based'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">buffer_overflow_disasm_anchor</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'Optimize performance'"/>
										</xsl:call-template>
									</xsl:if>
								</xsl:if>
								<!-- ===============
				     Application Layer 
				     =================		 -->
								<!-- cross site scripting -->
								<xsl:if test="web_servers_enforcement/http_enforce_cross_sites_scripting">
									<xsl:variable name="cn" select="web_servers_enforcement"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">Application Layer</xsl:with-param>
										<xsl:with-param name="attackName">http_enforce_cross_sites_scripting</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_enforce_cross_sites_scripting"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_cross_sites_scripting_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/web_servers_cross_sites_log"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_cross_sites_scripting_apply) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_cross_sites_scripting_apply) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_buffer_overflow_send_error'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_cross_sites_scripting_send_error"/>
									</xsl:call-template>
								</xsl:if>
								<!-- LDAP Injection -->
								<xsl:if test="HTTP_security_server/http_ldap_injection">
									<xsl:variable name="cn" select="HTTP_security_server/http_ldap_injection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">Application Layer</xsl:with-param>
										<xsl:with-param name="attackName">http_ldap_injection</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_enforce_ldap_injection"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_ldap_injection_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/http_ldap_injection_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_ldap_injection_apply_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_ldap_injection_apply_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">http_buffer_overflow_level</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/http_ldap_injection_level"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_buffer_overflow_send_error'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_ldap_injection_send_error"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">Relative Distinguished Names</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="'IGNORE_SINGLE_VALUE'"/>
										<xsl:with-param name="attackMultiAttribValue" select="/asm/as/words/words[ldap_keyword_enforce = 'true']/ldap_keyword_name"/>
									</xsl:call-template>
								</xsl:if>
								<!-- SQL Injection -->
								<xsl:if test="HTTP_security_server/http_sql_injection">
									<xsl:variable name="cn" select="HTTP_security_server/http_sql_injection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">Application Layer</xsl:with-param>
										<xsl:with-param name="attackName">http_sql_injection</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_enforce_sql_injection"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_sql_injection_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/http_sql_injection_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_sql_injection_apply_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_sql_injection_apply_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">http_buffer_overflow_level</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/http_sql_injection_level"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_buffer_overflow_send_error'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_sql_injection_send_error"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">SQL Injection Commands Configuration</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="'IGNORE_SINGLE_VALUE'"/>
										<xsl:with-param name="attackMultiAttribValue" select="/asm/as[Name = 'HttpSqlInjectionDistinctCommands']/patterns_actions/pattern_definition/pattern_name"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">Non-Distinct SQL Commands</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="'IGNORE_SINGLE_VALUE'"/>
										<xsl:with-param name="attackMultiAttribValue" select="/asm/as[Name='HttpSqlInjectionNonDistinctCommands']/words/words[sql_command_enforce = 'true']/sql_command_name"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Command Stealth -->
								<xsl:if test="HTTP_security_server/http_command_stealth">
									<xsl:variable name="cn" select="HTTP_security_server/http_command_stealth"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">Application Layer</xsl:with-param>
										<xsl:with-param name="attackName">http_command_stealth</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_enforce_command_stealth"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_command_stealth_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/http_command_stealth_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_command_stealth_apply_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_command_stealth_apply_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">http_buffer_overflow_level</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/http_command_stealth_level_default"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_buffer_overflow_send_error'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_command_stealth_send_error"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">Distinct Shell Commands</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="'IGNORE_SINGLE_VALUE'"/>
										<xsl:with-param name="attackMultiAttribValue" select="/asm/as[Name = 'HttpCommandStealthDistinctCommands']/words/words[command_stealth_command_enforce = 'true']/command_stealth_command_name"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">Non Distinct Shell Commands</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="'IGNORE_SINGLE_VALUE'"/>
										<xsl:with-param name="attackMultiAttribValue" select="/asm/as[Name='HttpCommandStealthNonDistinctCommands']/words/words[command_stealth_command_enforce = 'true']/command_stealth_command_name"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Directory Traversal -->
								<xsl:if test="HTTP_security_server/http_dir_traversal">
									<xsl:variable name="cn" select="HTTP_security_server/http_dir_traversal"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">Application Layer</xsl:with-param>
										<xsl:with-param name="attackName">http_dir_traversal</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_dir_traversal_blocke"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_dir_traversal_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/http_dir_traversal_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_dir_traversal_apply_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_dir_traversal_apply_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_buffer_overflow_send_error'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_dir_traversal_send_error"/>
									</xsl:call-template>
								</xsl:if>
								<!-- =======================
						Information Disclosure
						=======================		 -->
								<!-- Header Spoofing -->
								<xsl:if test="HTTP_security_server/http_generic_header_spoofing">
									<xsl:variable name="cn" select="HTTP_security_server/http_generic_header_spoofing"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">Information Disclosure</xsl:with-param>
										<xsl:with-param name="attackName">http_generic_header_spoofing</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_enforce_header_spoofing"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_header_spoofing_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/http_header_spoofing_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_header_spoofing_apply_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_header_spoofing_apply_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:for-each select="$cn/http_header_spoofing_patterns/http_header_spoofing_patterns[header_spoofing_pattern_enforce = 'true']">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName" select="header_spoofing_header_name"/>
											<xsl:with-param name="attackAttribValue">
							[<xsl:value-of select="header_spoofing_header_value"/>]
							[<xsl:value-of select="header_spoofing_pattern_action"/>]
							[<xsl:value-of select="header_spoofing_replace_value"/>]
							</xsl:with-param>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:if>
								<!-- Directory Listing -->
								<xsl:if test="HTTP_security_server/http_directory_listing">
									<xsl:variable name="cn" select="HTTP_security_server/http_directory_listing"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">Information Disclosure</xsl:with-param>
										<xsl:with-param name="attackName">http_directory_listing</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_enforce_directory_listing"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_directory_listing_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/http_directory_listing_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_directory_listing_apply_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_directory_listing_apply_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">http_buffer_overflow_level</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/http_directory_listing_level"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_buffer_overflow_send_error'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_directory_listing_send_error"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Error Concealment -->
								<xsl:if test="HTTP_security_server/http_error_concealment">
									<xsl:variable name="cn" select="HTTP_security_server/http_error_concealment"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">Information Disclosure</xsl:with-param>
										<xsl:with-param name="attackName">http_error_concealment</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_enforce_error_concealment"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_error_concealment_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/http_error_concealment_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_error_concealment_apply_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_error_concealment_apply_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_buffer_overflow_send_error'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_error_concealment_send_error"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:call-template name="attackMoreRows">
									<xsl:with-param name="attackAttribName" select="'Detection of HTTP response status codes'"/>
									<xsl:with-param name="attackAttribValue" select="''"/>
								</xsl:call-template>
								<xsl:for-each select="/asm/as/response_status_codes/response_status_codes">
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="''"/>
										<xsl:with-param name="attackAttribValue">
							[<xsl:value-of select="status_code_enforce"/>]
							[<xsl:value-of select="status_code_name"/>]
							[<xsl:value-of select="status_code_description"/>]
							</xsl:with-param>
									</xsl:call-template>
								</xsl:for-each>
								<xsl:call-template name="attackMoreRows">
									<xsl:with-param name="attackAttribName" select="'Detection of application engines'"/>
									<xsl:with-param name="attackAttribValue" select="''"/>
								</xsl:call-template>
								<xsl:for-each select="/asm/as/application_engines/application_engines">
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="''"/>
										<xsl:with-param name="attackAttribValue">
							[<xsl:value-of select="application_engine_name"/>]
							[<xsl:value-of select="application_engine_error_concealment/enforce_application_engine_patterns"/>]
							</xsl:with-param>
									</xsl:call-template>
								</xsl:for-each>
								<!-- ========================
				     HTTP Protocol Inspection 
				     ========================		 -->
								<!-- cross site scripting -->
								<xsl:if test="HTTP_security_server">
									<xsl:variable name="cn" select="HTTP_security_server"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
										<xsl:with-param name="attackCategory">HTTP Protocol Inspection</xsl:with-param>
										<xsl:with-param name="attackName">General Settings</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="'-'"/>
										<xsl:with-param name="attackMonitorOnly" select="'-'"/>
										<xsl:with-param name="attackTrack" select="'-'"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">http_valid_on_all_active</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/http_valid_on_all_active"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_valid_on_all_active) =  'true'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">
												<xsl:choose>
													<xsl:when test="string ($cn/http_valid_on_all) = 'true'">Configurations apply to all connections
										<xsl:choose>
															<xsl:when test="string ($cn/asm_http_kernel_verify) = 'true'"> 
												(Perform optimized protocol enforcement)
											</xsl:when>
															<xsl:when test="string ($cn/asm_http_kernel_verify) = 'false'"> 
											(Perform strict protocol enforcement)
										</xsl:when>
														</xsl:choose>
													</xsl:when>
													<xsl:when test="string ($cn/http_valid_on_all) = 'false'">
									Configurations apply only to connections related to resources used in the Rule Base
									</xsl:when>
												</xsl:choose>
											</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">http_strict_request_parsing</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/http_strict_request_parsing"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">http_strict_response_parsing</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/http_strict_response_parsing"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">http_split_query_fragment_section</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="$cn/http_split_query_fragment_section"/>
									</xsl:call-template>
								</xsl:if>
								<!-- HTTP Format Sizes -->
								<xsl:if test="HTTP_security_server">
									<xsl:variable name="cn" select="HTTP_security_server"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">HTTP Protocol Inspection</xsl:with-param>
										<xsl:with-param name="attackName">http_apply_format</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_enforce_max_url_length"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_format_size_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/http_format_size_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_apply_format_size_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_apply_format_size_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_apply_format_size_on) = 'only_uri_resources'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">Apply to connections related to URI resources</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_buffer_overflow_send_error'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_format_size_send_error"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_enforce_max_url_length'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_enforce_max_url_length"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_max_request_url_length'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_max_request_url_length"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_enforce_max_header_length'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_enforce_max_header_length"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_max_header_length'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_max_header_length"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_enforce_max_num_of_http_headers'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_enforce_max_num_of_http_headers"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_max_header_num'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_max_header_num"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_enforce_max_request_body_length'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_enforce_max_request_body_length"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_max_request_body_length'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_max_request_body_length"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'Specific Header Lengths'"/>
										<xsl:with-param name="attackAttribValue" select="'[Enabled][Name][Length]'"/>
									</xsl:call-template>
									<xsl:for-each select="$cn/http_max_header_fields_length/http_max_header_fields_length">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName" select="''"/>
											<xsl:with-param name="attackAttribValue">
							[<xsl:value-of select="header_field_length_enforce"/>]
							[<xsl:value-of select="header_field_name"/>]
							[<xsl:value-of select="header_field_value_length"/>]							
							</xsl:with-param>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:if>
								<!-- ASCII Only Request -->
								<xsl:if test="HTTP_security_server">
									<xsl:variable name="cn" select="HTTP_security_server"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">HTTP Protocol Inspection</xsl:with-param>
										<xsl:with-param name="attackName">http_check_request</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_check_request_enabled"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_request_validity_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/http_request_validity_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_apply_request_validity_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_apply_request_validity_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_apply_request_validity_on) = 'only_uri_resources'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">Apply to connections related to URI resources</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_buffer_overflow_send_error'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_request_validity_send_error"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_check_request_validity'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_check_request_validity"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_check_request_form_fields'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_check_request_form_fields"/>
									</xsl:call-template>
								</xsl:if>
								<!-- ASCII Only Response Headers -->
								<xsl:if test="HTTP_security_server">
									<xsl:variable name="cn" select="HTTP_security_server"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">HTTP Protocol Inspection</xsl:with-param>
										<xsl:with-param name="attackName">http_check_response</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_check_response_validity"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_response_validity_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/http_response_validity_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_apply_response_validity_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_apply_response_validity_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_buffer_overflow_send_error'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_response_validity_send_error"/>
									</xsl:call-template>
								</xsl:if>
								<!-- Headers Rejection -->
								<xsl:if test="HTTP_security_server/http_header_rejection">
									<xsl:variable name="cn" select="HTTP_security_server/http_header_rejection"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">HTTP Protocol Inspection</xsl:with-param>
										<xsl:with-param name="attackName">http_header_rejection</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_header_rejection_enforce"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_header_rejection_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/http_header_rejection_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_header_rejection_apply_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_header_rejection_apply_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_header_rejection_apply_on) = 'only_uri_resources'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">Apply to connections related to URI resources</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_buffer_overflow_send_error'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_header_rejection_send_error"/>
									</xsl:call-template>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'Header Rejection'"/>
										<xsl:with-param name="attackAttribValue" select="'[Active][Application Name][Header Name][Header Value]'"/>
									</xsl:call-template>
									<xsl:for-each select="$cn/http_header_rejection_patterns/http_header_rejection_patterns">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName" select="''"/>
											<xsl:with-param name="attackAttribValue">
							[<xsl:value-of select="pattern_mode"/>]
							[<xsl:value-of select="log_info"/>]
							[<xsl:value-of select="match_string"/>]
							[<xsl:value-of select="regular_exp"/>]								
							</xsl:with-param>
										</xsl:call-template>
									</xsl:for-each>
								</xsl:if>
								<!-- HTTP Methods	 -->
								<xsl:if test="HTTP_security_server/http_allowed_methods">
									<xsl:variable name="cn" select="HTTP_security_server/http_allowed_methods"/>
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCreateCategory" select="'-'"/>
										<xsl:with-param name="attackCategory">HTTP Protocol Inspection</xsl:with-param>
										<xsl:with-param name="attackName">http_allowed_method</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="$cn/http_allowed_method_enforce"/>
										<xsl:with-param name="attackMonitorOnly" select="$cn/http_allowed_methods_monitor_only"/>
										<xsl:with-param name="attackTrack" select="$cn/http_allowed_methods_track"/>
										<xsl:with-param name="attackAttribName" select="'-'"/>
										<xsl:with-param name="attackAttribValue" select="'-'"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_allowed_methods_apply_on) = 'all_http_con'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_all</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_allowed_methods_apply_on) = 'specific_web_servers'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">http_apply_worm_catcher_on_specific</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'N/A'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_allowed_methods_apply_on) = 'only_uri_resources'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName">Apply to connections related to URI resources</xsl:with-param>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName" select="'http_buffer_overflow_send_error'"/>
										<xsl:with-param name="attackAttribValue" select="$cn/http_allowed_methods_send_error"/>
									</xsl:call-template>
									<xsl:if test="string ($cn/http_allowed_methods_apply_default) = 'true'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName" select="'Block default HTTP Methods'"/>
											<xsl:with-param name="attackAttribValue" select="true"/>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName" select="'http_allowed_methods_apply_safe'"/>
											<xsl:with-param name="attackAttribValue" select="not (string ($cn/http_allowed_methods_apply_safe) = 'true')"/>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName" select="'http_allowed_methods_apply_unsafe'"/>
											<xsl:with-param name="attackAttribValue" select="not (string ($cn/http_allowed_methods_apply_unsafe) = 'true')"/>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName" select="'http_allowed_methods_apply_webdav'"/>
											<xsl:with-param name="attackAttribValue" select="not (string ($cn/http_allowed_methods_apply_webdav) = 'true')"/>
										</xsl:call-template>
									</xsl:if>
									<xsl:if test="string ($cn/http_allowed_methods_apply_default) = 'false'">
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName" select="'Block selected HTTP methods'"/>
											<xsl:with-param name="attackAttribValue" select="'true'"/>
										</xsl:call-template>
										<xsl:call-template name="attackMoreRows">
											<xsl:with-param name="attackAttribName" select="'Header Rejection'"/>
											<xsl:with-param name="attackAttribValue" select="'[Block][Name][Type]'"/>
										</xsl:call-template>
										<xsl:for-each select="$cn/http_allowed_methods_list/http_allowed_methods_list">
											<xsl:call-template name="attackMoreRows">
												<xsl:with-param name="attackAttribName" select="''"/>
												<xsl:with-param name="attackAttribValue">
							[<xsl:value-of select="http_method_enforce"/>]
							[<xsl:value-of select="http_method_name"/>]
							[<xsl:value-of select="http_method_type"/>]								
							</xsl:with-param>
											</xsl:call-template>
										</xsl:for-each>
									</xsl:if>
								</xsl:if>
								<!-- WebIntelligence updates -->
								<xsl:call-template name="dynamicUpdate">
									<xsl:with-param name="duCategoty">WebDefense;HTTP Protocol Inspection</xsl:with-param>
								</xsl:call-template>
								<TR>
									<TD class="last" align="right" colSpan="10" notag="SKIPTHISTR">
										<DIV class="divStyle" align="center" notag="SKIPTHISTR">
											<A class="back" notag="SKIPTHISTR" href="#sd_wi">Top of table</A> | <A class="back" href="#topOfPage">Top of page</A>
										</DIV>
									</TD>
								</TR>
							</TBODY>
						</TABLE>
					</TD>
				</TR>
			</TBODY>
		</TABLE>
	</xsl:template>
	<!-- Name resulution template -->
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
			<xsl:when test="string ($name) = 'fwfrag_limit'">Maximum number of incomplete Packets</xsl:when>
			<xsl:when test="string ($name) = 'fwfrag_timeout'">Discard incomplete packets after (seconds)</xsl:when>
			<xsl:when test="string ($name) = 'net_quota_protection'">
				<a>
					<xsl:attribute name="href">asm_help/net_quota.html</xsl:attribute>Network Quota</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'net_quota_enabled'">Enabled</xsl:when>
			<xsl:when test="string ($name) = 'net_quota_log_interval'">Track further exceeding connections every... (Seconds)</xsl:when>
			<xsl:when test="string ($name) = 'net_quota_limit'">When exceeding (count) connections per second from the same source</xsl:when>
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
			<xsl:when test="string ($name) = 'anti_spoofing'">
				<a>
					<xsl:attribute name="href">asm_help/suc_events_anti_spoof.html</xsl:attribute>Address spoofing</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'local_interface_spoofing'">
				<a>
					<xsl:attribute name="href">asm_help/suc_events_loc_int.html</xsl:attribute>Local Interface Spoofing</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'port_scanning'">
				<a>
					<xsl:attribute name="href">asm_help/suc_events_port_scan.html</xsl:attribute>Port Scanning</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'successive_alerts'">
				<a>
					<xsl:attribute name="href">asm_help/suc_events_suc_alerts.html</xsl:attribute>Successive alerts</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'successive_multiple_connections'">
				<a>
					<xsl:attribute name="href">asm_help/suc_events_multi_conn.html</xsl:attribute>Successive multiple connections</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'number_of_repetitions'">Number of events</xsl:when>
			<xsl:when test="string ($name) = 'time_interval'">Over a period of... (seconds)</xsl:when>
			<!-- DShield Storm Center -->
			<!-- downstream -->
			<xsl:when test="string ($name) = 'DShield Storm Center'">
				<a>
					<xsl:attribute name="href">asm_help/storm_center_general.html
			</xsl:attribute>DShield Storm Center</a>
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
			<!-- Port Scan	 -->
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
			<!-- General settings -->
			<xsl:when test="string ($name) = 'SMTP_security_server_general_connections_apply'">
				<a>
					<xsl:attribute name="href">asm_help/smtp_sec_server.html</xsl:attribute>Mail Security Server</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'smtp_valid_on_all'">Configurations apply to all connections</xsl:when>
			<xsl:when test="string ($name) = 'smtp_valid_on_rulebase'">Configurations apply only to connections related to resources used in the Rule base				</xsl:when>
			<!-- SMTP Contents -->
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
			<!-- MSN SIP	 -->
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
				   ====	 -->
			<!-- voip general -->
			<xsl:when test="string ($name) = 'VoIP'">
				<a>
					<xsl:attribute name="href">asm_help/voip.html</xsl:attribute>VoIP</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'voip_enforce_dos_protection'">Enable VoIP DoS Protection</xsl:when>
			<xsl:when test="string ($name) = 'voip_user_calls_per_minute'">Allow up (count) call attempts per IP (per minute)</xsl:when>
			<!-- H232 -->
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
			<!-- SIP -->
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
			<!-- MGCP -->
			<xsl:when test="string ($name) = 'fw_mgcp_enforcement'">
				<a>
					<xsl:attribute name="href">asm_help/mgcp.html</xsl:attribute>MGCP</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'mgcp_command_accepted_true'">Allowd Commands</xsl:when>
			<xsl:when test="string ($name) = 'mgcp_command_accepted_false'">Blocked Commands</xsl:when>
			<!-- SCCP (Skinny) -->
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
			<!-- Content Protection -->
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
			<!-- Remote Control Applications -->
			<xsl:when test="string ($name) = 'Remote Control Applications'">
				<a>
					<xsl:attribute name="href">asm_help/remote_control.html</xsl:attribute>Remote Control Applications</a>
			</xsl:when>
			<!-- Remote Administrator -->
			<xsl:when test="string ($name) = 'Remote Administrator'">
				<a>
					<xsl:attribute name="href">asm_help/remote_admin.html</xsl:attribute>Remote Administrator</a>
			</xsl:when>
			<!-- WEB INTELLIGENSE -->
			<!-- Web Servers View -->
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
			<!--  Directory Traversal -->
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
				   ========================== -->
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
			<!-- Ascii Only Request -->
			<xsl:when test="string ($name) = 'http_check_request'">
				<a>
					<xsl:attribute name="href">asm_help/http_sec_server1.html</xsl:attribute>ASCII Only Request</a>
			</xsl:when>
			<xsl:when test="string ($name) = 'http_check_request_form_fields'">Block non ASCII characters in form fields</xsl:when>
			<!-- Ascii Only Response Headers -->
			<xsl:when test="string ($name) = 'http_check_response'">
				<a>
					<xsl:attribute name="href">asm_help/http_sec_server2.html</xsl:attribute>ASCII Only Response Headers</a>
			</xsl:when>
			<!-- Headers Rejection -->
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
