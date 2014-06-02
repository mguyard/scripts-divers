<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html"/>
	<xsl:template match="/network_objects">
		<html>
			<head>
				<title>Network Objects</title>
				<link rel="stylesheet" type="text/css" href="../web_interface.css"/>
			</head>
			<body class="WVTXMLPage">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr style="background: url(../icons/top_stretch.jpg) top;">
						<td height="39" align="right">
							<img src="../icons/top_logo.gif" align="left"/>
						</td>
						<td width="100%" height="39">
							&#160;
						</td>
						<td height="39" align="left">
							<img src="../icons/top_name.jpg" align="left"/>
						</td>
					</tr>
					<tr height="33" border="0" cellpadding="0" cellspacing="0" width="100%">
						<td height="33" colspan="3" align="left" style="background-image: url(../icons/toolbar_stretch.gif); FONT-SIZE: 16px; FONT-FAMILY: Arial;  COLOR: midnightblue;">
							<b>&#160;&#160;&#160;Network Objects</b>
						</td>
					</tr>
				</table>
				<br/>
				<div class="navlink">&#160;&#160;&#160;&#160;&#160;<a href="../index.xml">Back to index page</a>
				</div>
				<br/>
				<table>
					<tr>
						<td>&#160;&#160;&#160;</td>
						<td>
							<table border="0" cellpadding="0" cellspacing="0" width="800">
								<tr height="23">
									<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px ; BORDER-BOTTOM: #596080 1px solid; align: top">
										<img width="7" height="23" align="top" src="../icons/table_top_left_corner.gif"/>
									</td>
									<td height="23" width="100%" style="background-color: #C2D0D2; BORDER-LEFT: #C2D0D2 0px solid; BORDER-TOP: #596080 1px solid; BORDER-BOTTOM: #596080 1px solid;">&#160;&#160;&#160;</td>
									<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: #596080 1px solid; align: left;">
										<img width="7" height="23" align="top" src="../icons/table_top_right_corner.gif"/>
									</td>
								</tr>
								<tr style="background-color: #F7F8F3">
									<td valign="top" width="7" style="background-color: #F7F8F3; BORDER-LEFT: #596080 1px solid;">
										<div class="table_coloum_title_left"/>
									</td>
									<td>
										<table class="light_grid">
											<thead>
												<tr>
													<th class="objects_header"/>
													<th class="objects_header">Name</th>
													<th class="objects_header">Type</th>
													<th class="objects_header">IP</th>
													<th class="objects_header">Netmask</th>
													<th class="objects_header">
														<NOBR>Products installed</NOBR>
													</th>
													<th class="objects_header">
														<NOBR>NAT Address</NOBR>
													</th>
													<th class="objects_header">Members</th>
													<th class="objects_header">Version</th>
													<th class="objects_header">Comments</th>
												</tr>
											</thead>
											<xsl:for-each select="network_object[Class_Name != 'sofaware_profiles_security_level']">
												<xsl:sort case-order="upper-first" select="Name"/>
												<tr class="odd_row" style="page-break-after:always;">
													<!-- select the style of the row according to its position. -->
													<xsl:if test="position() mod 2 = 0">
														<xsl:attribute name="class">even_row</xsl:attribute>
													</xsl:if>
													<!--icon -->
													<td class="object_cell">
														<img height="16px" width="16px">
															<xsl:attribute name="src">
					../icons/<xsl:value-of select="Class_Name"/>.png
				</xsl:attribute>
															<xsl:attribute name="alt"><xsl:value-of select="Class_Name"/></xsl:attribute>
														</img>
													</td>
													<!--name -->
													<td class="object_cell">
														<a>
															<xsl:attribute name="name"><xsl:value-of select="Name"/></xsl:attribute>
															<xsl:value-of select="Name"/>
														</a>
													</td>
													<!--type -->
													<td class="object_cell">
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
													<xsl:call-template name="getIPAdress" />
													
													<!--Netmask -->
													<td class="object_cell">
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
													
													<!-- Installed Products Info -->
													<xsl:call-template name="getInstalledProductsInfo" />
													
													<!--NAT -->
													<td class="object_cell">
														<xsl:choose>
															<xsl:when test="NAT/the_firewalling_obj[Name] "><xsl:value-of select="NAT/the_firewalling_obj/Name"/></xsl:when>
															<xsl:when test="NAT/valid_ipaddr != ''">
																<xsl:value-of select="NAT/valid_ipaddr"/>
															</xsl:when>
															<xsl:otherwise>-</xsl:otherwise>
														</xsl:choose>
													</td>
													
													<!--Members -->
													<td class="object_cell">
														<xsl:choose>
															<xsl:when test="type = 'group'">
																<xsl:for-each select="./members/reference">
																	<a>
																		<xsl:attribute name="href">
								#<xsl:value-of select="Name"/></xsl:attribute>
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
													<td class="object_cell">
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
																	<xsl:when test="$versionStr = '[6.0][8]'"><xsl:attribute name="title">NGX R65</xsl:attribute>NGX R65</xsl:when>
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
																<xsl:attribute name="title">N/A</xsl:attribute>N/A</xsl:otherwise>
														</xsl:choose>
													</td>
													
													<!--comments -->
													<td class="object_cell_wide">
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
										</table>
									</td>
									<td valign="top" width="7" style="BORDER-RIGHT: #596080 1px solid;">
										<div class="table_coloum_title_right"/>
									</td>
								</tr>
								<tr>
									<td width="7">
										<img width="7" align="top" src="../icons/table_bottom_left_corner.gif"/>
									</td>
									<td height="23" style="background-color: #C2D0D2; BORDER-LEFT: #596080 0px solid; BORDER-TOP: #596080 1px solid; BORDER-BOTTOM: #596080 1px solid;">&#160;&#160;&#160;</td>
									<td width="7">
										<img align="top" src="../icons/table_bottom_right_corner.gif" width="7"/>
									</td>
								</tr>
							</table>
						</td>
						<td>&#160;&#160;&#160;</td>
					</tr>
				</table>
				<br/>
				<div class="navlink">&#160;&#160;&#160;&#160;&#160;<a href="../index.xml">Back to index page</a>
				</div>
				<br/>
				<div class="copyright">Copyright &#169; 1994-2012 <a href="http://www.checkpoint.com">Check Point Software Technologies Ltd</a>. All Rights Reserved.</div>
				<br/>
			</body>
		</html>
	</xsl:template>
	
	
<!-- ============= -->
<!--      IP Address      -->
<!-- ============= -->
<xsl:template name="getIPAdress">
	<td class="object_cell">
		<xsl:choose>
			<xsl:when test="ipaddr = '0.0.0.1'">N/A</xsl:when>
			<xsl:when test="ipaddr != ''"><xsl:value-of select="ipaddr"/><br/></xsl:when>
			<xsl:when test="ipaddr_first or ipaddr_last">
				<xsl:if test="ipaddr_first"><xsl:value-of select="ipaddr_first"/></xsl:if>
				<xsl:if test="ipaddr_first and ipaddr_last "> to </xsl:if>
				<xsl:if test="ipaddr_last"><xsl:value-of select="ipaddr_last"/></xsl:if>
			</xsl:when>
			<xsl:otherwise>-</xsl:otherwise>
		</xsl:choose>
		<!--  this code cause the ip address to appear twice under the ip adress column
		<xsl:for-each select="interfaces/interfaces">
			<xsl:value-of select="ipaddr"/>
		</xsl:for-each>
        -->
	</td>
</xsl:template>


<!-- ============= -->
<!-- Installed Products  -->
<!-- ============= -->
<xsl:template name="getInstalledProductsInfo">
	<td vAlign="top" nowrap="true">
		<xsl:choose>
			<xsl:when test="cp_products_installed = 'true' ">
				SVN Foundation<br/>
				<xsl:choose>
					<xsl:when test="management = 'true'">
						<xsl:choose>
							<xsl:when test="primary_management = 'true'">Primary Management Station</xsl:when>
							<xsl:otherwise>Secondary Management Station</xsl:otherwise>
						</xsl:choose>
						<br/>
					</xsl:when>
					<xsl:when test="log_server = 'true'">Log Server<br/></xsl:when>
					<xsl:when test="integrity_server = 'true'">Integrity Server<br/></xsl:when>
					<xsl:when test="firewall = 'installed'">FireWall-1<br/></xsl:when>
					<xsl:when test="VPN_1 = 'true'">VPN-1 Pro<br/></xsl:when>
					<xsl:when test="vpnddcate = 'true'">VPN-1 Net<br/></xsl:when>
					<xsl:when test="floodgate = 'installed'">FloodGate-1<br/></xsl:when>
					<xsl:when test="policy_server = 'installed'">SecureClient Policy Server<br/></xsl:when>
					<xsl:when test="SDS = 'installed'">SecureClient Software Distribution Server<br/></xsl:when>
					<xsl:when test="reporting_server = 'true'">SmartView Reporter<br/></xsl:when>
					<xsl:when test="real_time_monitor = 'true'">SmartView Monitor<br/></xsl:when>
					<xsl:when test="UA_server = 'true'">UserAuthority Server<br/></xsl:when>
					<xsl:when test="UA_WebAccess = 'true'">UserAuthority WebAccess<br/></xsl:when>
				</xsl:choose>
				<xsl:if test="sc_portal = 'true'">SmartPortal<br/></xsl:if>
				<xsl:if test="event_analyzer = 'true'">Eventia Anayzer Server<br/></xsl:if>
			</xsl:when>
			<xsl:otherwise>-
		</xsl:otherwise>
		</xsl:choose>
	</td>	
</xsl:template>
	
	
</xsl:stylesheet>
