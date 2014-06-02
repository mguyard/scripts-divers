<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html"/>
	<!-- include outer xslt files -->
	<xsl:include href="outer_objects_templates.xsl"/>
	<!--link to objects -->
	<xsl:variable name="network_objects" select="document('xml/network_objects.xml')/network_objects"/>
	<xsl:variable name="services" select="document('xml/services.xml')/services"/>
	<xsl:template match="/fw_policies/fw_policie">
		<html class="WVTXMLPage">
			<head>
				<title>Address Translation Policy</title>
				<link rel="stylesheet" type="text/css" href="../web_interface.css"/>
			</head>
			<body class="WVTXMLPage">
						<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr style="background-image: url(../icons/top_stretch.jpg);">
						<td height="39" width="402" style="width: 100px; border-left: 0px; padding-left: 0px; background-image: url(../icons/top_stretch.jpg);" >
								<img height="38" width="402" src="../icons/top_logo.gif" align="left"/>
						</td>
					
						<td width="50%" height="39" align="left">
							&#160;
						</td>
						<td height="39" align="bottom">
							<img src="../icons/top_name.jpg" align="left"/>
						</td>
					
					</tr>
					<tr height="33" border="0" cellpadding="0" cellspacing="0" width="100%">
						<td height="33" colspan="3" align="left" style="background-image: url(../icons/toolbar_stretch.gif); FONT-SIZE: 16px; FONT-FAMILY: Arial;  COLOR: midnightblue;">
							<b>&#160;&#160;&#160;Address Translation Policy: <xsl:value-of select="substring(Name,3)"/>
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
							<table border="0" cellpadding="0" cellspacing="0" >
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
									<td valign="top" width="7" style="BORDER-LEFT: #596080 1px solid;">
										<div class="table_coloum_nat_title_left"/>
									</td>
									<td>
										<!-- Start content table -->
										<table class="light_grid">
											<thead>
												<tr >
													<th class="objects_header_nat" rowspan="2" valign="middle">NO.</th>
													<th class="objects_header" valign="middle"  style="text-align:center;" colspan="3">ORIGINAL PACKET</th>
													<th class="objects_header" valign="middle" style="text-align:center;" colspan="3">TRANSLATED PACKET</th>
													<th class="objects_header_nat" rowspan="2" valign="middle">INSTALL ON</th>
													<th class="objects_header_nat_last" rowspan="2" valign="middle">COMMENT</th>
												</tr>
												<tr>
													<th class="objects_header" valign="middle">SOURCE</th>
													<th class="objects_header" valign="middle">DESTINATION</th>
													<th class="objects_header" valign="middle">SERVICE</th>
													<th class="objects_header" valign="middle">SOURCE</th>
													<th class="objects_header" valign="middle">DESTINATION</th>
													<th class="objects_header" valign="middle">SERVICE</th>
												</tr>
											</thead>
											<tbody>
												<xsl:for-each select="rule_adtr/rule_adtr">
													<!--writes the rule itself -->
													<tr class="odd_row">
														<!-- select the style of the row according to its position. -->
														<xsl:if test="position() mod 2 = 0">
															<xsl:attribute name="class">even_row</xsl:attribute>
														</xsl:if>
														<td class="object_cell_number">
															<!--change the color of the rule number if the rule is disabled. -->
															<xsl:if test="./disabled = 'true'">
																<xsl:attribute name="style">color: #E40000;</xsl:attribute>
																<font size="2" color="#E40000">Disabled</font>
																<br/>
															</xsl:if>
															<!-- rule number -->
															<xsl:value-of select="Rule_Number"/>
														</td>
														<!--original source -->
														<td class="object_cell">
															<xsl:for-each select="./src_adtr/src_adtr">
																<xsl:call-template name="net_obj_img_template">
																	<xsl:with-param name="network_objects_set" select="$network_objects"/>
																	<xsl:with-param name="reference" select="."/>
																</xsl:call-template>
															</xsl:for-each>
														</td>
														<!--original destination -->
														<td class="object_cell">
															<xsl:for-each select="./dst_adtr/dst_adtr">
																<xsl:call-template name="net_obj_img_template">
																	<xsl:with-param name="network_objects_set" select="$network_objects"/>
																	<xsl:with-param name="reference" select="."/>
																</xsl:call-template>
															</xsl:for-each>
														</td>
														<!--original service -->
														<td class="object_cell">
															<xsl:for-each select="./services_adtr/services_adtr">
																<xsl:call-template name="service_img_template">
																	<xsl:with-param name="services_set" select="$services"/>
																	<xsl:with-param name="reference" select="."/>
																</xsl:call-template>
															</xsl:for-each>
														</td>
														<!--translated source -->
														<td class="object_cell">
															<xsl:for-each select="./src_adtr_translated/reference">
																<xsl:call-template name="net_obj_img_template">
																	<xsl:with-param name="network_objects_set" select="$network_objects"/>
																	<xsl:with-param name="reference" select="."/>
																</xsl:call-template>
															</xsl:for-each>
														</td>
														<!--translated destination -->
														<td class="object_cell">
															<xsl:for-each select="./dst_adtr_translated/reference">
																<xsl:call-template name="net_obj_img_template">
																	<xsl:with-param name="network_objects_set" select="$network_objects"/>
																	<xsl:with-param name="reference" select="."/>
																</xsl:call-template>
															</xsl:for-each>
														</td>
														<!--translated service -->
														<td class="object_cell">
															<xsl:for-each select="./services_adtr_translated/reference">
																<xsl:call-template name="service_img_template">
																	<xsl:with-param name="services_set" select="$services"/>
																	<xsl:with-param name="reference" select="."/>
																</xsl:call-template>
															</xsl:for-each>
														</td>
														<!--Install On -->
														<td class="object_cell">
															<xsl:for-each select="./install/install">
																<xsl:call-template name="net_obj_img_template">
																	<xsl:with-param name="network_objects_set" select="$network_objects"/>
																	<xsl:with-param name="reference" select="."/>
																</xsl:call-template>
															</xsl:for-each>
														</td>
														<!--comments -->
														<td class="object_cell_last">
															<xsl:value-of select="comments"/>
														</td>
													</tr>
												</xsl:for-each>
											</tbody>
										</table>
										<!-- end content -->
									</td>
										<td valign="top" width="6" style="BORDER-RIGHT: #596080 1px solid;">
										<div class="table_coloum_nat_title_right"/>
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
