<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html"/>
	<xsl:template match="/services">
		<html>
			<head>
				<title>Services</title>
				<link rel="stylesheet" type="text/css" href="../web_interface.css"/>
			</head>
			<body class="WVTXMLPage">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr style="background: url(../icons/top_stretch.jpg) top;" width="100%">
						<td height="39" align="right" width="500">
							<img src="../icons/top_logo.gif" align="left"/>
						</td>
						<td width="100%" height="39">
							&#160;
						</td>
						<td width="100%" height="39" align="left">
							<img src="../icons/top_name.jpg" align="left"/>
						</td>
					</tr>
					<tr height="33" border="0" cellpadding="0" cellspacing="0" width="100%">
						<td height="33" colspan="3" align="left" style="background-image: url(../icons/toolbar_stretch.gif); FONT-SIZE: 16px; FONT-FAMILY: Arial;  COLOR: midnightblue;">
							<b>&#160;&#160;&#160;Services</b>
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
							<table border="0" cellpadding="0" cellspacing="0" width="710">
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
										<table class="light_grid" width="700">
											<tr>
												<th class="objects_header"/>
												<th class="objects_header">Name</th>
												<th class="objects_header">Type</th>
												<th class="objects_header"><NOBR>Port/Protocol</NOBR></th>
												<th class="objects_header"><NOBR>Protocol Type</NOBR></th>
												<th class="objects_header"><NOBR>Match For Any</NOBR></th>
												<th class="objects_header"><NOBR>Source Port</NOBR></th>
												<th class="objects_header">Members</th>
												<th class="objects_header">Comments</th>
											</tr>
											<xsl:for-each select="service">
											<xsl:sort case-order="upper-first" select="Name"/>												
												<tr class="odd_row">
													<!-- select the style of the row according to its position.-->
													<xsl:if test="position() mod 2 = 0">
														<xsl:attribute name="class">even_row</xsl:attribute>
													</xsl:if>
													<!--icon-->
													<td class="object_cell">
														<img height="16px" width="16px">
															<xsl:attribute name="src">
					../icons/<xsl:value-of select="Class_Name"/>.png
				</xsl:attribute>
															<xsl:attribute name="alt"><xsl:value-of select="Class_Name"/></xsl:attribute>
														</img>
													</td>
													<!--Name-->
													<td class="object_cell">
														<a>
															<xsl:attribute name="name"><xsl:value-of select="Name"/></xsl:attribute>
															<xsl:value-of select="Name"/>
														</a>
													</td>
													<!--Type-->
													<td class="object_cell">
														<xsl:value-of select="type"/>
													</td>
													<!--Port / Protocol-->
													<td class="object_cell">
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
													<!--Protocol Type-->
													<td class="object_cell">
														<xsl:choose>
															<xsl:when test="proto_type/Name != ''">
																<xsl:value-of select="proto_type/Name"/>
															</xsl:when>
															<xsl:otherwise>
					-
				</xsl:otherwise>
														</xsl:choose>
													</td>
													<!--Match-->
													<td class="object_cell">
														<xsl:choose>
															<xsl:when test="include_in_any != ''">
																<xsl:value-of select="include_in_any"/>
															</xsl:when>
															<xsl:otherwise>
					-
				</xsl:otherwise>
														</xsl:choose>
													</td>
													<!--S-port-->
													<td class="object_cell">
														<xsl:choose>
															<xsl:when test="src_port != ''">
																<xsl:value-of select="src_port"/>
															</xsl:when>
															<xsl:otherwise>
					-
				</xsl:otherwise>
														</xsl:choose>
													</td>
													<!--Members-->
													<td class="object_cell">
														<xsl:choose>
															<xsl:when test="translate(type,'GROUP','group') = 'group'">
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
													<!--Comments-->
													<td class="object_cell">
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
								<tr><td width="7"><img width="7" align="top" src="../icons/table_bottom_left_corner.gif"/></td>
								<td height="23" style="background-color: #C2D0D2; BORDER-LEFT: #596080 0px solid; BORDER-TOP: #596080 1px solid; BORDER-BOTTOM: #596080 1px solid;">&#160;&#160;&#160;</td>
								<td width="7"><img align="top" src="../icons/table_bottom_right_corner.gif" width="7"/></td>
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
</xsl:stylesheet>
