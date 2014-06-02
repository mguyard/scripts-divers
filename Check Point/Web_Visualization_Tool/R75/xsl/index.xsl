<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--link to the index elements-->
	<xsl:variable name="index_elements" select="document('xml/index.xml')/elements"/>
	<xsl:output method="html"/>
	<xsl:template match="/">
		<html>
			<head>
				<title>Check Point Web Visualization Tool</title>
				<link rel="stylesheet" type="text/css" href="web_interface.css"/>
			</head>
			<body class="WVTXMLPage">
				<table width="100%" border="0" cellpadding="0" cellspacing="0">
					<tr style="background: url(icons/top_stretch.jpg) top;">
						<td height="39" align="right">
							<img src="icons/top_logo.gif" align="left"/>
						</td>
						<td width="100%" height="39">
							&#160;
						</td>
						<td height="39" align="left">
							<img src="icons/top_name.jpg" align="left"/>
						</td>
					</tr>
					<tr height="33" border="0" cellpadding="0" cellspacing="0" width="100%">
						<td height="33" colspan="3" align="left" style="background-image: url(icons/toolbar_stretch.gif); FONT-SIZE: 16px; FONT-FAMILY: Arial;  COLOR: midnightblue;">
							<b>&#160;&#160;&#160;Index</b>
						</td>
					</tr>
				</table>
				<!-- The list -->
				<p/>
				<p/>
				<table>
					<tr>
						<td>&#160;&#160;&#160;</td>
						<td>
							<table border="0" cellpadding="0" cellspacing="0" width="400">
								<tr height="23">
									<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px ; BORDER-BOTTOM: #596080 1px solid; align: top">
										<img width="7" height="23" align="top" src="icons/table_top_left_corner.gif"/>
									</td>
									<td height="23" width="100%" style="background-color: #C2D0D2; BORDER-LEFT: #C2D0D2 0px solid; BORDER-TOP: #596080 1px solid; BORDER-BOTTOM: #596080 1px solid;">&#160;&#160;&#160;</td>
									<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: #596080 1px solid; align: left;">
										<img width="7" height="23" align="top" src="icons/table_top_right_corner.gif"/>
									</td>
								</tr>
								<tr style="background-color: #F7F8F3">
									<td width="7" style="background-color: #F7F8F3; BORDER-LEFT: #596080 1px solid;">&#160;</td>
									<td>
										<ul style="list-style-image:url(icons/document_icon.gif);font-family:arial,system;font-size:13;">
											<xsl:for-each select="$index_elements/element[elements]">
												<xsl:call-template name="menuItemTemplate">
													<xsl:with-param name="menuItem" select="."/>
												</xsl:call-template>
											</xsl:for-each>
											<!--xsl:call-template name="menuItemTemplate">
												<xsl:with-param name="menuItem" select="$index_elements/element[reference = 'asm.xml']"/>
											</xsl:call-template-->
											<xsl:call-template name="menuItemTemplate">
												<xsl:with-param name="menuItem" select="$index_elements/element[reference = 'network_objects.xml']"/>
											</xsl:call-template>
											<xsl:call-template name="menuItemTemplate">
												<xsl:with-param name="menuItem" select="$index_elements/element[reference = 'services.xml']"/>
											</xsl:call-template>
											<xsl:call-template name="menuItemTemplate">
												<xsl:with-param name="menuItem" select="$index_elements/element[reference = 'users.xml']"/>
											</xsl:call-template>
										</ul>
									</td>
									<td width="7" style="background-color: #F7F8F3; BORDER-RIGHT: #596080 1px solid;">&#160;</td>
								</tr>
								<tr>
									<td width="7">
										<img width="7" align="top" src="icons/table_bottom_left_corner.gif"/>
									</td>
									<td height="24" style="background-color: #C2D0D2; 
																		BORDER-LEFT: #596080 0px solid; 
																		BORDER-TOP: #596080 1px solid; 
																		BORDER-BOTTOM: #596080 1px solid;">&#160;</td>
									<td width="7" >
										<img align="top" src="icons/table_bottom_right_corner.gif" width="7"/>
									</td>
								</tr>
							</table>
						</td>
					</tr>
				</table>
				<br/>
				<br/>
					<div class="copyright">Copyright &#169; 1994-2012 <a href="http://www.checkpoint.com">Check Point Software Technologies Ltd</a>. All Rights Reserved.</div>
				<br/>
			</body>
		</html>
	</xsl:template>
	<!-- Menu Item Template -->
	<xsl:template name="menuItemTemplate">
		<xsl:param name="menuItem"/>
		<xsl:if test="$menuItem">
			<li style="margin-top:8px; margin-bottom:8px;">
				<xsl:choose>
					<xsl:when test="string ($menuItem/reference) != ''">
						<xsl:choose>
							<xsl:when test="$menuItem/reference = 'asm.xml'">
								<xsl:call-template name="asm_template">
									<xsl:with-param name="menuItem" select="$menuItem"/>
								</xsl:call-template>
							</xsl:when>
							<xsl:otherwise>
								<a>
									<xsl:attribute name="href">xml/<xsl:value-of select="$menuItem/reference"/></xsl:attribute>
									<xsl:value-of select="$menuItem/title"/>
								</a>
							</xsl:otherwise>
						</xsl:choose>
					</xsl:when>
					<xsl:when test="$menuItem/elements">
						<xsl:value-of select="$menuItem/title"/>
						<ul style="list-style-image:url(icons/sub_document_icon.gif); font-family:arial,system;font-size:13;">
							<xsl:for-each select="$menuItem/elements/element">
								<li style="margin-top:10px;margin-bottom:10px;">
									<a>
										<xsl:attribute name="href">xml/<xsl:value-of select="reference"/></xsl:attribute>
										<xsl:value-of select="title"/>
									</a>
								</li>
							</xsl:for-each>
						</ul>
					</xsl:when>
				</xsl:choose>
			</li>
		</xsl:if>
	</xsl:template>
	<!-- Special template for SmartDefense  -->
	<xsl:template name="asm_template">
		<xsl:param name="menuItem"/>
		<xsl:value-of select="$menuItem/title"/>
		<ul style="list-style-image:url(icons/sub_document_icon.gif);font-family:arial,system;font-size:13;">
			<li style="margin-top:10px;margin-bottom:10px;">
				<a>
					<xsl:attribute name="href">xml/<xsl:value-of select="$menuItem/reference"/>#generals</xsl:attribute>
					General Settings
				</a>
			</li>
			<li style="margin-top:10px;margin-bottom:10px;">
				<a>
					<xsl:attribute name="href">xml/<xsl:value-of select="$menuItem/reference"/>#networksecurity</xsl:attribute>
					Network Security
				</a>
			</li>
			<li style="margin-top:10px;margin-bottom:10px;">
				<a>
					<xsl:attribute name="href">xml/<xsl:value-of select="$menuItem/reference"/>#ai</xsl:attribute>
					Application Intelligence
				</a>
			</li>
			<li style="margin-top:10px;margin-bottom:10px;">
				<a>
					<xsl:attribute name="href">xml/<xsl:value-of select="$menuItem/reference"/>#wi</xsl:attribute>
			Web Intelligence
		</a>
			</li>
		</ul>
	</xsl:template>
</xsl:stylesheet>
