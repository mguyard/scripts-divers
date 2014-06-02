<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<xsl:output method="html"/>
	<xsl:include href="asm_strings.xsl"/>
	<xsl:include href="asm_is.xsl"/>
	<!--	================
			Root templates
			================-->
	<xsl:template match="/asm">
		<html>
			<head>
				<title>SmartDefense</title>
				<link rel="stylesheet" type="text/css" href="../web_interface.css"/>
				<script language="Javascript">
				
				var isIE = (window.navigator.appName.indexOf("icrosoft") != -1) ? true : false;
				
				function initHrefClickEvents ()
				{		
					var ColOfLinks = document.links;	
					for (i=0; i &lt; ColOfLinks.length; ++i)
						ColOfLinks[i].onclick=trapLinkclickFunction ;
					
				}
				
				function trapLinkclickFunction (e)
				{
					var MyEvent;
					
					if (isIE)
						MyEvent = event;
					else
						MyEvent = e;	
						
					var linkUrl = (MyEvent.target) ? MyEvent.target : MyEvent.srcElement
					var linkUrlStr = linkUrl .toString();
					if (linkUrlStr .indexOf("asm_help/") != -1)
					{
							var modalH = 500;
							var modalW = 700;								
							var sh = screen.height;
							var sw = screen.width;
							if (isIE)
							{
								var winAttrbsIE = "status:no;center:yes;dialogheight:" + modalH + "px;dialogwidth:"+modalW +"px;titlebar=yes;status:no";								
								window.showModalDialog(linkUrlStr, "asmHelpWIn", winAttrbsIE );
							}
							else	
							{	
								var winAttrbsNS = "top=" + ((sh/2) - (modalH /2)) + ",left=" + ((sw/2) - (modalW /2)) + ",height=" + modalH  + ",width=" + modalW  + ",titlebar=yes;status=no,toolbar=no,menubar=no,location=no";
								var newWin = window.open(linkUrlStr, "asmHelpWIn", winAttrbsNS );
								newWin.focus();
							}
														
							return false;
					}
					else
						return true;	
				}
				
				
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
							theElement.innerHTML = d.toDateString() + "  " + d.getHours() + ":" + d.getMinutes();
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
					var currentStyle = "odd_row";
					var lastCategory = "_KJHKJHKJH";
					for (index=1; index &lt; colOfNodes.length; index++) // index=1... skip headers
					{																																					
						var currentTR = colOfNodes.item(index);
						var firstCell = findFirstCellOfTR (currentTR);
											
						if (firstCell == null)
						{
							return;
						}
																								
						if (firstCell.innerHTML != "")						
						{
							if (currentStyle == "odd_row") 
								currentStyle = "even_row";
							else
								currentStyle = "odd_row";
						}
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
								if (currentStyle == "odd_row") 
									currentStyle = "even_row";
								else
									currentStyle = "odd_row";
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
									var newTDcontent = '&lt;INPUT type="submit" class="closeBtn" value="+" onclick="closeOrOpenCategory (this)"&gt;&#8194;&#8194;';
									newTDcontent  +=  	firstCell.innerHTML 						   
									firstCell.innerHTML = newTDcontent ;
									currentStyle = "even_row";								  
								}
								else
								{
									currentTR.display = "none";
								}
						}											
					}
				}
				
				function showDoc ()
				{																
					var loadingDiv = document.getElementById ('idDivLoading');
					if (loadingDiv != null)
						loadingDiv.style.display = "none";
						
				var loadingDiv = document.getElementById ('idDivWholePage');
					if (loadingDiv != null)
						loadingDiv.style.display = "";						

				}
			</script>
			</head>
			<body class="WVTXMLPage" onload="convertCtimeElements (); niceTable('idTblOfNetworkSecurity'); niceTable('idTblAI');niceTable('idTblWI'); initHrefClickEvents (); showDoc ();">
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
							<b>&#160;&#160;&#160;SmartDefense</b>
						</td>
					</tr>
				</table>
				<div id="idDivLoading">
					<br/>
					<br/>
					<b>&#160;&#160;&#160;&#160;&#160;&#160;Loading  ...</b>
				</div>
				<div id="idDivWholePage" style="display: none;">
				<br/>
				<div class="navlink">&#160;&#160;&#160;&#160;&#160;<a href="../index.xml">Back to index page</a>
				</div>
				<br/>
					<a name="top"/>
					<!-- start content header -->
					<table>
						<tr>
							<td>&#160;&#160;&#160;</td>
							<td>
								<table border="0" cellpadding="0" cellspacing="0">
									<tr height="23">
										<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px ; BORDER-BOTTOM: #596080 1px solid; align: top">
											<img width="7" height="23" align="top" src="../icons/table_top_left_corner.gif"/>
										</td>
										<td height="23" width="100%" style="background-color: #C2D0D2; BORDER-LEFT: #C2D0D2 0px solid; BORDER-TOP: #596080 1px solid; BORDER-BOTTOM: #596080 1px solid;">
											<span class="table_title">&#160;&#160;Content</span>
										</td>
										<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: #596080 1px solid; align: left;">
											<img width="7" height="23" align="top" src="../icons/table_top_right_corner.gif"/>
										</td>
									</tr>
									<tr style="background-color: #F7F8F3">
										<td width="7" valign="top" style="background-color: #F7F8F3; BORDER-LEFT: #596080 1px solid;">&#160;</td>
										<td>
											<!-- Start Content -->
											<ul style="list-style-image:url(../icons/document_icon.gif);font-family:arial,system;font-size:13;">
												<li style="margin-top:10px;margin-bottom:10px;">
													<a>
														<xsl:attribute name="href">#generals</xsl:attribute>
							General Settings
					</a>
												</li>
												<li style="margin-top:10px;margin-bottom:10px;">
													<a>
														<xsl:attribute name="href">#networksecurity</xsl:attribute>
							Smart Defense: Network Security
					</a>
												</li>
												<li style="margin-top:10px;margin-bottom:10px;">
													<a>
														<xsl:attribute name="href">#ai</xsl:attribute>
							Smart Defense: Application Intelligence
					</a>
												</li>
												<li style="margin-top:10px;margin-bottom:10px;">
													<a>
														<xsl:attribute name="href">#wi</xsl:attribute>
							Web Intelligence
					</a>
												</li>
											</ul>
											<!-- Seperator  start -->
										</td>
										<td valign="top" width="7" style="BORDER-RIGHT: #596080 1px solid;">&#160;</td>
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
								<br/>
								<br/>
								<table border="0" cellpadding="0" cellspacing="0" width="100%">
									<tr height="23">
										<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px ; BORDER-BOTTOM: #596080 1px solid; align: top">
											<img width="7" height="23" align="top" src="../icons/table_top_left_corner.gif"/>
										</td>
										<td height="23" width="100%" style="background-color: #C2D0D2; BORDER-LEFT: #C2D0D2 0px solid; BORDER-TOP: #596080 1px solid; BORDER-BOTTOM: #596080 1px solid;">
											<span class="table_title">&#160;&#160;&#160;General Settings</span>
										</td>
										<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: #596080 1px solid; align: left;">
											<img width="7" height="23" align="top" src="../icons/table_top_right_corner.gif"/>
										</td>
									</tr>
									<tr style="background-color: #F7F8F3">
										<td valign="top" width="7" style="BORDER-LEFT: #596080 1px solid;">
											<div class="table_coloum_title_left"/>
										</td>
										<td>
											<!-- Seperator  End -->
											<xsl:call-template name="general_settings"/>
											<!-- Seperator  start -->
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
								<br/>
							
								<INPUT type="submit" class="expandBtn" value="Expand all" onclick="expandCollapseAll ('idTblOfNetworkSecurity', true); expandCollapseAll ('idTblAI', true); expandCollapseAll ('idTblWI', true);"/>&#8194;
							<INPUT type="submit" class="expandBtn" value="Collapse all" onclick="expandCollapseAll ('idTblOfNetworkSecurity', false); expandCollapseAll ('idTblAI', false);expandCollapseAll ('idTblWI', false);"/>
								<br/>
								<br/>
								<!-- Seperator  End -->
								<xsl:apply-templates select="as"/>
								<!-- start cotent footer -->
							</td>
							<td>&#160;&#160;&#160;</td>
						</tr>
					</table>
					<br/>
					<div class="navlink">&#160;&#160;&#160;&#160;&#160;<a href="#top">Top of this page</a>&#160;|&#160;<a href="../index.xml">Back to index page</a>
					</div>
					<br/>
					<br/>
					<div class="copyright">Copyright &#169; 1994-2008 <a href="http://www.checkpoint.com">Check Point Software Technologies Ltd</a>. All Rights Reserved.</div>
					<br/>
				</div>
			</body>
		</html>
	</xsl:template>
	<!-- main asm templtae -->
	<xsl:template match="as">
		<xsl:apply-templates select="asm_active_protection"/>
	</xsl:template>
	<!-- Global Settings -->
	<xsl:template name="general_settings">
		<a name="generals"/>
		<table class="light_grid" valign="top" width="100%">
			<thead>
				<tr>
					<th class="objects_header">Attribute</th>
					<th class="objects_header_last">Value</th>
				</tr>
			</thead>
			<tbody>
				<tr class="odd_row">
					<td class="object_cell_wide" valign="top">
						Last update
					</td>
					<td class="object_cell_wide" valign="top" id="idCTimeElement">
						<xsl:value-of select="./as/asm_last_update_time"/>
					</td>
				</tr>
				<tr class="even_row">
					<td class="object_cell_wide" valign="top">
						Update version
					</td>
					<td class="object_cell_wide" valign="top">
						<xsl:value-of select="./as/asm_update_version"/>
					</td>
				</tr>
				<tr class="odd_row">
					<td class="object_cell_wide">Check for new updates when SmartDashboard is started</td>
					<td class="object_cell_wide">
						<xsl:call-template name="boolToOnOff">
							<xsl:with-param name="bOnOff" select="./as/asm_check_for_update_frequently"/>
						</xsl:call-template>
					</td>
				</tr>
				<tr class="even_row" valign="top">
					<td class="object_cell_wide">Reference</td>
					<td class="object_cell_wide" valign="top">
						<a href="http://www.checkpoint.com/products/downloads/smartdefense_subscription_faq.pdf">SmartDefense subscription service FAQ (PDF)</a>
					</td>
				</tr>
			</tbody>
		</table>
	</xsl:template>
	<!--	================
				Network security
				=================-->
	<!-- Active Protection-->
	<xsl:template name="attacks" match="asm_active_protection">
		<xsl:param name="duCategoty"/>
		<xsl:param name="attackCategory"/>
		<xsl:param name="attackCreateCategory"/>
		<xsl:param name="attackName"/>
		<xsl:param name="attackIsActive"/>
		<xsl:param name="attackTrack"/>
		<xsl:param name="attackAttribName"/>
		<xsl:param name="attackAttribValue"/>
		<a name="networksecurity"/><br/>
		<!--start header -->
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr height="23">
				<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px ; BORDER-BOTTOM: #596080 1px solid; align: top">
					<img width="7" height="23" align="top" src="../icons/table_top_left_corner.gif"/>
				</td>
				<td height="23" width="100%" style="background-color: #C2D0D2; BORDER-LEFT: #C2D0D2 0px solid; BORDER-TOP: #596080 1px solid; BORDER-BOTTOM: #596080 1px solid;">
					<span class="table_title">&#160;&#160;&#160;Network Security</span>
				</td>
				<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: #596080 1px solid; align: left;">
					<img width="7" height="23" align="top" src="../icons/table_top_right_corner.gif"/>
				</td>
			</tr>
			<tr style="background-color: #F7F8F3">
				<td valign="top" width="7" style="BORDER-LEFT: #596080 1px solid;">
					<div class="table_coloum_title_left"/>
				</td>
				<td>
					<!--End header -->
					
					<table class="light_grid" border="0" id="idTblOfNetworkSecurity" width="100%">
						<thead>
							<tr>
								<th class="objects_header">
									<NOBR>Attack Category</NOBR>
								</th>
								<th class="objects_header">
									<NOBR>Attack Name</NOBR>
								</th>
								<th class="objects_header">
									<NOBR>Enabled/Disabled</NOBR>
								</th>
								<th class="objects_header">Track</th>
								<th class="objects_header">Attribute</th>
								<th class="objects_header_last">Value</th>
							</tr>
						</thead>
						<tbody>
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
										<xsl:value-of select="$cn/asm_packet_verify_relaxed_udp"/>
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
									<xsl:with-param name="attackAttribName">fw_virtual_defrag_max_incomplete_pks</xsl:with-param>
									<xsl:with-param name="attackAttribValue">N/A</xsl:with-param>
								</xsl:call-template>
								<xsl:call-template name="attackMoreRows">
									<xsl:with-param name="attackAttribName">fw_virtual_defrag_descard_packets_after</xsl:with-param>
									<xsl:with-param name="attackAttribValue">N/A</xsl:with-param>
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
							<!-- Small PMTU-->
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
							<!-- Spoofed reset protection-->
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
									<xsl:with-param name="attackAttribValue">
							N/A
						</xsl:with-param>
								</xsl:call-template>
							</xsl:if>
							<!-- sequence verifaier-->
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
							<!-- Fingerprint Information  -->
							<xsl:if test="fingerprint_spoofing">
								<xsl:variable name="cn" select="fingerprint_spoofing"/>
								<!--ISN Spoofing -->
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCategory">Fingerprint Scrambling</xsl:with-param>
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
									<xsl:with-param name="attackName">fingerprint_spoofing</xsl:with-param>
									<xsl:with-param name="attackTrack">-</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="$cn/asm_fp_isn"/>
									<xsl:with-param name="attackAttribName">Apply only to outgoing packets</xsl:with-param>
									<xsl:with-param name="attackAttribValue" select="$cn/asm_fp_inout"/>
								</xsl:call-template>
								<xsl:call-template name="attackMoreRows">
									<xsl:with-param name="attackAttribName">asm_fp_isn_bits</xsl:with-param>
									<xsl:with-param name="attackAttribValue" select="$cn/asm_fp_isn_bits"/>
								</xsl:call-template>
								<!-- TTL -->
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCategory">Fingerprint Scrambling</xsl:with-param>
									<xsl:with-param name="attackName">TTL</xsl:with-param>
									<xsl:with-param name="attackTrack">-</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="$cn/asm_fp_ttl"/>
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
									<xsl:with-param name="attackIsActive" select="$cn/asm_fp_ipid"/>
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
							<!--  log analysis patterns  -->
							<xsl:call-template name="attackNewCategory">
								<xsl:with-param name="attackCategory">Successive Events</xsl:with-param>
								<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
							</xsl:call-template>
							<xsl:for-each select="/asm/as/cpmad_log_analysis_patterns/*">
								<xsl:if test="(name() !=  'Name') 		and 
													  (name() != 'Class_Name') 		and 
													  (name() != 'port_scanning') 	and 													  
													  (name() != 'login_failure') 	and 
													  (name() != 'blocked_connection_port_scanning')">
									<xsl:call-template name="attackFirstRow">
										<xsl:with-param name="attackCategory">Successive Events</xsl:with-param>
										<xsl:with-param name="attackCreateCategory" select="'NO'"/>
										<xsl:with-param name="attackName">
											<xsl:value-of select="name()"/>_se</xsl:with-param>
										<xsl:with-param name="attackIsActive" select="'false'"/>
										<xsl:with-param name="attackMonitorOnly" select="mode"/>
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
							====================	-->
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
							=========   -->
							<!-- Host port scan-->
							<xsl:if test="//asm_kernel_port_scan_detection/vertical_port_scan">
								<xsl:variable name="cn" select="//asm_kernel_port_scan_detection/vertical_port_scan"/>
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
									<xsl:with-param name="attackCategory">Port Scan</xsl:with-param>
									<xsl:with-param name="attackName">vertical_port_scan</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="$cn/enabled"/>
									<xsl:with-param name="attackMonitorOnly" select="string ($cn/enabled) = 'true'"/>
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
												<xsl:with-param name="attackAttribValue" select="'Medume'"/>
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
							<!-- Host port scan-->
							<xsl:if test="//asm_kernel_port_scan_detection/horizontal_port_scan">
								<xsl:variable name="cn" select="//asm_kernel_port_scan_detection/horizontal_port_scan"/>
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
									<xsl:with-param name="attackCategory">Port Scan</xsl:with-param>
									<xsl:with-param name="attackName">horizontal_port_scan</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="$cn/enabled"/>
									<xsl:with-param name="attackMonitorOnly" select="string ($cn/enabled) = 'true'"/>
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
												<xsl:with-param name="attackAttribValue" select="'Medume'"/>
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
							===============	-->
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
						</tbody>
					</table>
					<!-- Seperator  start -->
				</td>
				<td valign="top" width="7" style="BORDER-RIGHT: #596080 1px solid;">
					<div class="table_coloum_title_right"/>
				</td>
			</tr>
			<tr>
				<td width="7">
					<img width="7" align="top" src="../icons/table_bottom_left_corner.gif"/>
				</td>
				<td height="23" style="background-color: #C2D0D2; BORDER-LEFT: #596080 0px solid; BORDER-TOP: #596080 1px solid; BORDER-BOTTOM: #596080 1px solid;">&#160;</td>
				<td width="7">
					<img align="top" src="../icons/table_bottom_right_corner.gif" width="7"/>
				</td>
			</tr>
		</table>
		<br/>
		<div class="navlink">&#160;&#160;&#160;&#160;&#160;<a href="#top">Top of this page</a>
		</div>
		<br/>
		<table border="0" cellpadding="0" cellspacing="0" width="100%">
			<tr height="23">
				<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px ; BORDER-BOTTOM: #596080 1px solid; align: top">
					<img width="7" height="23" align="top" src="../icons/table_top_left_corner.gif"/>
				</td>
				<td height="23" width="100%" style="background-color: #C2D0D2; BORDER-LEFT: #C2D0D2 0px solid; BORDER-TOP: #596080 1px solid; BORDER-BOTTOM: #596080 1px solid;">
					<span class="table_title">&#160;&#160;&#160;Application Intelligence</span>
				</td>
				<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: #596080 1px solid; align: left;">
					<img width="7" height="23" align="top" src="../icons/table_top_right_corner.gif"/>
				</td>
			</tr>
			<tr style="background-color: #F7F8F3">
				<td valign="top" width="7" style="BORDER-LEFT: #596080 1px solid;">
					<div class="table_coloum_title_left"/>
				</td>
				<td>
					<!-- Seperator  End -->
					<!--
			Application Intelligence
			========================-->
					<a name="ai"/>
					<table class="light_grid" id="idTblAI" width="100%">
						<thead>
							<tr>
								<th class="objects_header">
									<NOBR>Attack Category</NOBR>
								</th>
								<th class="objects_header">
									<NOBR>Attack Name</NOBR>
								</th>
								<th class="objects_header">
									<NOBR>Enabled/Disbaled</NOBR>
								</th>
								<th class="objects_header">Track</th>
								<th class="objects_header">Attribute</th>
								<th class="objects_header_last">Value</th>
							</tr>
						</thead>
						<tbody>
							<!-- MAIL -->
							<!-- POP3/Imap Sewcurity-->
							<xsl:if test="mail_servers_enforcement">
								<xsl:variable name="cn" select="mail_servers_enforcement"/>
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
									<xsl:with-param name="attackCategory">Mail</xsl:with-param>
									<xsl:with-param name="attackName">mail_servers_enforcement</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="$cn/enforce_mail_servers_protection"/>
									<xsl:with-param name="attackMonitorOnly">
										<xsl:value-of select="$cn/mail_servers_monitor_only"/>
									</xsl:with-param>
									<xsl:with-param name="attackTrack">-</xsl:with-param>
									<xsl:with-param name="attackAttribName">-</xsl:with-param>
									<xsl:with-param name="attackAttribValue">-</xsl:with-param>
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
							<!-- MAIL - Dynamic Updates-->
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
									<xsl:with-param name="attackIsActive">true</xsl:with-param>
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
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCategory">FTP</xsl:with-param>
									<xsl:with-param name="attackName">ftp_unallowed_cmds</xsl:with-param>
									<xsl:with-param name="attackAttribValue" select="FTP_security_server/ftp_unallowed_cmds"/>
								</xsl:call-template>
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCategory">FTP</xsl:with-param>
									<xsl:with-param name="attackName">ftp_dont_check_cmd_vals</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="FTP_security_server/ftp_dont_check_cmd_vals"/>
								</xsl:call-template>
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCategory">FTP</xsl:with-param>
									<xsl:with-param name="attackName">ftp_dont_check_random_port</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="string(FTP_security_server/ftp_dont_check_random_port) ='false'"/>
								</xsl:call-template>
							</xsl:if>
							<!-- FTP - Dynamic Updates-->
							<xsl:call-template name="dynamicUpdate">
								<xsl:with-param name="duCategoty">FTP</xsl:with-param>
							</xsl:call-template>
							<!-- MS Networks  -->
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
							<!--  - Microsoft Networks - Dynamic updates-->
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
							<!-- domain blick list-->
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
							<!-- Scrambling-->
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
				   ====	  -->
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
							<!-- H232-->
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
							<!-- SIP-->
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
							<!-- MGCP-->
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
							<!-- SCCP (Skinny)-->
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
					  =======   -->
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
					  ==============       -->
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
								<xsl:with-param name="exclude1">SSH</xsl:with-param>
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
							<!--MS-SQL-->
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
							<!--SOCKS-->
							<xsl:call-template name="dynamicUpdateByObjName">
								<xsl:with-param name="objName" select="'SOCKS'"/>
								<xsl:with-param name="parentName" select="'Application Intelligence'"/>
							</xsl:call-template>
							<!--Routing Protocols-->
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
							<!--SUN-RPC-->
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
							<!--DHCP-->
							<xsl:call-template name="dynamicUpdateByObjName">
								<xsl:with-param name="objName" select="'DHCP'"/>
								<xsl:with-param name="parentName" select="'Application Intelligence'"/>
							</xsl:call-template>
							<!--Remote Control Applications-->
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
								<xsl:with-param name="exclude1">Remote Administrator</xsl:with-param>
							</xsl:call-template>
							<!--Remote Administrator-->
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
							=================================================	-->
							<xsl:call-template name="dynamicUpdate">
								<xsl:with-param name="duCategoty">ALL_DU_WITH_NEW_CATEGORY</xsl:with-param>
							</xsl:call-template>
						</tbody>
					</table>
					<!-- Seperator  start -->
				</td>
				<td valign="top" width="7" style="BORDER-RIGHT: #596080 1px solid;">
					<div class="table_coloum_title_right"/>
				</td>
			</tr>
			<tr>
				<td width="7">
					<img width="7" align="top" src="../icons/table_bottom_left_corner.gif"/>
				</td>
				<td style="background-color: #C2D0D2; 
									 BORDER-LEFT: #596080 0px solid; 
									 BORDER-TOP: 	 #596080 1px solid;
									 BORDER-BOTTOM: #596080 1px solid;">&#160;</td>
				<td width="7">
					<img align="top" src="../icons/table_bottom_right_corner.gif" width="7"/>
				</td>
			</tr>
		</table>
		<br/>
		<div class="navlink">&#160;&#160;&#160;&#160;&#160;<a href="#top">Top of this page</a>
		</div>
		<br/>
		<table border="0" cellpadding="0" cellspacing="0">
			<tr height="23">
				<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px ; BORDER-BOTTOM: #596080 1px solid; align: top">
					<img width="7" height="23" align="top" src="../icons/table_top_left_corner.gif"/>
				</td>
				<td height="23" width="100%" style="background-color: #C2D0D2; BORDER-LEFT: #C2D0D2 0px solid; BORDER-TOP: #596080 1px solid; BORDER-BOTTOM: #596080 1px solid;">
					<span class="table_title">&#160;&#160;&#160;Web Intelligence</span>
				</td>
				<td height="23" width="7" style="BORDER-RIGHT: 0px; BORDER-LEFT: 0px; BORDER-BOTTOM: #596080 1px solid; align: left;">
					<img width="7" height="23" align="top" src="../icons/table_top_right_corner.gif"/>
				</td>
			</tr>
			<tr style="background-color: #F7F8F3">
				<td valign="top" width="7" style="BORDER-LEFT: #596080 1px solid;">
					<div class="table_coloum_title_left"/>
				</td>
				<td>
					<!-- Seperator  End -->
					<!--  
				===================
				Web Intelligence 
				===================
												-->
					<a name="wi"/>
					<table class="light_grid" id="idTblWI" width="100%">
						<thead>
							<tr>
								<th class="objects_header">
									<NOBR>Attack Category</NOBR>
								</th>
								<th class="objects_header">
									<NOBR>Attack Name</NOBR>
								</th>
								<th class="objects_header">
									<NOBR>Enabled/Disabled</NOBR>
								</th>
								<th class="objects_header">Track</th>
								<th class="objects_header">Attribute</th>
								<th class="objects_header_last">Value</th>
							</tr>
						</thead>
						<tbody>
							<!-- ===
						WEB
						=== -->
							<!--Web Servers View-->
							<xsl:call-template name="attackFirstRow">
								<xsl:with-param name="attackCreateCategory" select="'CREATE_CATEGORY'"/>
								<xsl:with-param name="attackCategory">Web Servers View</xsl:with-param>
								<xsl:with-param name="attackName">-</xsl:with-param>
								<xsl:with-param name="attackIsActive" select="'-'"/>
								<xsl:with-param name="attackMonitorOnly" select="'-'"/>
								<xsl:with-param name="attackTrack" select="'-'"/>
								<xsl:with-param name="attackAttribName" select="'-'"/>
								<xsl:with-param name="attackAttribValue" select="'N/A'"/>
							</xsl:call-template>
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
										<xsl:with-param name="attackAttribValue" select="'Optomize memory'"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="string ($cn/buffer_overflow_optimize_memory) = 'false'">
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">buffer_overflow_optimize_memory</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="'Optomize speed'"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="string ($cn/buffer_overflow_disasm_anchor) = 'every_byte'">
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">buffer_overflow_disasm_anchor</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="'Optomize security'"/>
									</xsl:call-template>
								</xsl:if>
								<xsl:if test="string ($cn/buffer_overflow_disasm_anchor) = 'os_based'">
									<xsl:call-template name="attackMoreRows">
										<xsl:with-param name="attackAttribName">buffer_overflow_disasm_anchor</xsl:with-param>
										<xsl:with-param name="attackAttribValue" select="'Optomize performance'"/>
									</xsl:call-template>
								</xsl:if>
							</xsl:if>
							<!-- ===============
				     Application Layer 
				     =================		-->
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
								<xsl:call-template name="attackMoreRows">
									<xsl:with-param name="attackAttribName">Script Command</xsl:with-param>
									<xsl:with-param name="attackAttribValue" select="'IGNORE_SINGLE_VALUE'"/>
									<xsl:with-param name="attackMultiAttribValue" select="/asm/as/words/words[http_cross_site_scripting_word_enforce = 'true']/http_cross_site_scripting_word_name"/>
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
									<xsl:with-param name="attackAttribName">Distinct Commands</xsl:with-param>
									<xsl:with-param name="attackAttribValue" select="'IGNORE_SINGLE_VALUE'"/>
									<xsl:with-param name="attackMultiAttribValue" select="/asm/as[Name != 'HttpSqlInjectionNonDistinctCommands']/words/words[sql_command_enforce = 'true']/sql_command_name"/>
								</xsl:call-template>
								<xsl:call-template name="attackMoreRows">
									<xsl:with-param name="attackAttribName">Non Distinct Commands</xsl:with-param>
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
									<xsl:with-param name="attackIsActive" select="$cn/http_dir_traversal_blocked"/>
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
						=======================		-->
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
				     ========================		-->
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
							<!-- HTTP Format Sizes-->
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
							<!-- Headers Rejection-->
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
							<!-- HTTP Methods	-->
							<xsl:if test="HTTP_security_server/http_allowed_methods">
								<xsl:variable name="cn" select="HTTP_security_server/http_allowed_methods"/>
								<xsl:call-template name="attackFirstRow">
									<xsl:with-param name="attackCreateCategory" select="'-'"/>
									<xsl:with-param name="attackCategory">HTTP Protocol Inspection</xsl:with-param>
									<xsl:with-param name="attackName">http_allowed_method</xsl:with-param>
									<xsl:with-param name="attackIsActive" select="$cn/http_enforce_allowed_methods"/>
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
						</tbody>
					</table>
				</td>
				<td valign="top" width="7" style="BORDER-RIGHT: #596080 1px solid;">
					<div class="table_coloum_title_RIGHT"/>
				</td>
			</tr>
			<tr>
				<td width="7">
					<img width="7" align="top" src="../icons/table_bottom_left_corner.gif"/>
				</td>
				<td height="23" style="background-color: #C2D0D2; BORDER-LEFT: #596080 0px solid; BORDER-TOP: #596080 1px solid; BORDER-BOTTOM: #596080 1px solid;">&#160;</td>
				<td width="7">
					<img align="top" src="../icons/table_bottom_right_corner.gif" width="7"/>
				</td>
			</tr>
		</table>
	</xsl:template>
</xsl:stylesheet>
