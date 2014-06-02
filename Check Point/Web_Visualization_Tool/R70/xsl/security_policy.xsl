<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html"/>
	<!-- include outer xslt files -->
	<xsl:include href="outer_objects_templates.xsl"/>
	<!--link to objects-->
	<xsl:variable name="network_objects" select="document('xml/network_objects.xml')/network_objects"/>
	<xsl:variable name="services" select="document('xml/services.xml')/services"/>
	<xsl:variable name="communities" select="document('xml/communities.xml')/communities"/>
	<xsl:template match="/fw_policies/fw_policie">
		<xsl:variable name="simplified_mode" select="use_VPN_communities"/>
		<html>
			<head>
				<title>Security Policy</title>
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
							<b>&#160;&#160;&#160;Security Policy: <xsl:value-of select="substring(Name,3)"/>
							</b>
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
							<table border="0" cellpadding="0" cellspacing="0">
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
									<td valign="top" width="6" style="background-color: #F7F8F3; BORDER-LEFT: #596080 1px solid;">
										<div class="table_coloum_title_left"/>
									</td>
									<td>
										<table class="light_grid" border="0">
											<thead>
												<tr>
													<th class="objects_header">NO.</th>
													<th class="objects_header">NAME</th>
													<th class="objects_header">SOURCE</th>
													<th class="objects_header">DESTINATION</th>
													<xsl:if test="$simplified_mode = 'true'">
														<th class="objects_header">VPN</th>
													</xsl:if>
													<th class="objects_header">SERVICE</th>
													<th class="objects_header">ACTION</th>
													<th class="objects_header">TRACK</th>
													<th class="objects_header">
														<NOBR>INSTALL ON</NOBR>
													</th>
													<th class="objects_header">TIME</th>
													<th class="objects_header_last">COMMENT</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="rule/rule">
													<!-- writes the group header -->
													<xsl:choose>
														<xsl:when test="normalize-space(./header_text) != ''">
															<tr class="rule_group_title">
																<td colspan="10">&#160;&#160;<xsl:value-of select="./header_text"/>
																</td>
															</tr>
														</xsl:when>
														<xsl:otherwise>
															<!--writes the rule itself -->
															<tr class="odd_row">
																<!-- select the style of the row according to its position.-->
																<xsl:if test="number(Rule_Number) mod 2 = 0">
																	<xsl:attribute name="class">even_row</xsl:attribute>
																</xsl:if>
																<td class="object_cell_number">
																	<!--change the color of the rule number if the rule is disabled.-->
																	<xsl:if test="./disabled = 'true'">
																		<xsl:attribute name="style">color: #E40000;</xsl:attribute>
																		<font size="2" color="#E40000">Disabled</font>
																		<br/>
																	</xsl:if>
																	<!-- rule number-->
																	<xsl:value-of select="Rule_Number"/>
																</td>
																<td class="object_cell">
																	<xsl:value-of select="name"/>
																</td>
																<!--source-->
																<td class="object_cell">
																	<xsl:for-each select="./src/members/reference">
																		<xsl:call-template name="net_obj_img_template">
																			<xsl:with-param name="network_objects_set" select="$network_objects"/>
																			<xsl:with-param name="reference" select="."/>
																			<xsl:with-param name="negate" select="../../op='not in'"/>
																		</xsl:call-template>
																	</xsl:for-each>
																	<xsl:for-each select="./src/compound/compound">
																		<xsl:if test="Class_Name = 'rule_user_group'">
																			<img src="../icons/user_group.png" class="ImgOuterObject">
																				<xsl:if test="../../op='not in'">
																					<xsl:attribute name="src">../icons/user_group_X.png</xsl:attribute>
																					<xsl:attribute name="alt">Not</xsl:attribute>
																				</xsl:if>
																			</img>&#160;
</xsl:if>
																		<a>
																			<xsl:if test="Class_Name = 'rule_user_group'">
																				<xsl:attribute name="href">
users.xml#<xsl:value-of select="substring-before(Name,'@')"/></xsl:attribute>
																			</xsl:if>
																			<xsl:value-of select="substring-before(Name,'@')"/>
																		</a>@<a>
																			<xsl:if test="at/Table = 'network_objects'">
																				<xsl:attribute name="href">
network_objects.xml#<xsl:value-of select="substring-after(Name,'@')"/></xsl:attribute>
																			</xsl:if>
																			<xsl:value-of select="substring-after(Name,'@')"/>
																		</a>
																		<br/>
																	</xsl:for-each>
																</td>
																<!--destination -->
																<td class="object_cell">
																	<xsl:for-each select="./dst/members/reference">
																		<xsl:call-template name="net_obj_img_template">
																			<xsl:with-param name="network_objects_set" select="$network_objects"/>
																			<xsl:with-param name="reference" select="."/>
																			<xsl:with-param name="negate" select="../../op='not in'"/>
																		</xsl:call-template>
																	</xsl:for-each>
																</td>
																<!--If via-->
																<xsl:if test="$simplified_mode = 'true'">
																	<td class="object_cell">
																		<xsl:for-each select="./through/through">
																			<xsl:call-template name="community_link_template">
																				<xsl:with-param name="communities_set" select="$communities"/>
																				<xsl:with-param name="reference" select="."/>
																			</xsl:call-template>
																		</xsl:for-each>
																	</td>
																</xsl:if>
																<!--service-->
																<td class="object_cell">
																	<xsl:for-each select="./services/members/reference">
																		<xsl:call-template name="service_img_template">
																			<xsl:with-param name="services_set" select="$services"/>
																			<xsl:with-param name="reference" select="."/>
																			<xsl:with-param name="negate" select="../../op='not in'"/>
																		</xsl:call-template>
																	</xsl:for-each>
																	<xsl:for-each select="./services/compound/compound">
																		<xsl:call-template name="resource_link_template">
																			<xsl:with-param name="services_set" select="$services"/>
																			<xsl:with-param name="reference" select="."/>
																			<xsl:with-param name="negate" select="../../op='not in'"/>
																		</xsl:call-template>
																	</xsl:for-each>
																</td>
																<!--action-->
																<td class="object_cell">
																	<xsl:for-each select="./action/action">
																		<div nowrap="true">
																			<img height="16px" width="16px" class="ImgOuterObject">
																				<xsl:attribute name="src">
../icons/<xsl:value-of select="Class_Name"/>.png
</xsl:attribute>
																			</img>&#160;
<xsl:value-of select="Name"/>
																		</div>
																	</xsl:for-each>
																</td>
																<!--track-->
																<td class="object_cell">
																	<xsl:for-each select="./track/track">
																		<img height="16px" width="16px" class="ImgOuterObject">
																			<xsl:attribute name="src">
../icons/<xsl:value-of select="translate(Name,' ','_')"/>.png
</xsl:attribute>
																		</img>&#160;
<xsl:value-of select="Name"/>
																		<br/>
																	</xsl:for-each>
																</td>
																<!--Install On-->
																<td class="object_cell">
																	<xsl:for-each select="./install/members/reference">
																		<xsl:call-template name="net_obj_img_template">
																			<xsl:with-param name="network_objects_set" select="$network_objects"/>
																			<xsl:with-param name="reference" select="."/>
																		</xsl:call-template>
																	</xsl:for-each>
																</td>
																<!--time-->
																<td class="object_cell">
																	<xsl:for-each select="./time/time">
																		<img height="16px" width="16px" class="ImgOuterObject">
																			<xsl:attribute name="src">
../icons/
<xsl:choose><xsl:when test="Table = 'times'">
timeobject
</xsl:when><xsl:otherwise>
Any
</xsl:otherwise></xsl:choose>
.png
</xsl:attribute>
																		</img>&#160;
<xsl:value-of select="Name"/>
																		<br/>
																	</xsl:for-each>
																</td>
																<!--comments-->
																<td class="object_cell_last">
																	<xsl:value-of select="comments"/>
																</td>
															</tr>
														</xsl:otherwise>
													</xsl:choose>
												</xsl:for-each>
											</tbody>
										</table>
									</td>
									<td valign="top" width="6" style="BORDER-RIGHT: #596080 1px solid;">
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
				<div class="copyright">Copyright &#169; 1994-2008 <a href="http://www.checkpoint.com">Check Point Software Technologies Ltd</a>. All Rights Reserved.</div>
				<br/>
			</body>
		</html>
	</xsl:template>
</xsl:stylesheet>
