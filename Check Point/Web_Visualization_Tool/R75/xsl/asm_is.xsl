<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">
	<!--	=============================
			Common utility templates
			=========================-->
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
	<!--Attack First Row-->
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
		<tr class="odd_row" valign="top">
			<td class="object_cell_wide">
				<xsl:call-template name="nameResolve">
					<xsl:with-param name="name" select="$attackCategory"/>
				</xsl:call-template>
			</td>
			<td class="object_cell" valign="top">
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
			<td class="object_cell" valign="top">
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
			<td class="object_cell" valign="top">
				<xsl:choose>
					<xsl:when test="string($attackTrack) = '0'">None</xsl:when>
					<xsl:when test="string($attackTrack) = '1'">
						<img height="16px" width="16px" align="middle" style="border:none;" src="../icons/Log.png"/>&#160;Log<br/>
					</xsl:when>
					<xsl:when test="not(string($attackTrack)) or $attackTrack = ' ' or 
											 $attackTrack = '-' or 
											 $attackTrack = '_'  or $attackTrack = '.'">
						<xsl:call-template name="undefinedValue"/>
					</xsl:when>
					<xsl:when test="string($attackTrack) = 'useralert'">
						<nobr>
							<img height="16px" width="16px" align="middle" style="border:none;">
								<xsl:attribute name="src">../icons/UserDefined.png</xsl:attribute>
							</img>&#160;User Defined Alert</nobr>
						<br/>
					</xsl:when>
					<xsl:when test="string($attackTrack) = 'useralert2'">
						<nobr>
							<img height="16px" width="16px" align="middle" style="border:none;">
								<xsl:attribute name="src">../icons/UserDefined_2.png</xsl:attribute>
							</img>&#160;User Defined Alert no.2</nobr>
						<br/>
					</xsl:when>
					<xsl:when test="string($attackTrack) = 'useralert3'">
						<nobr>
							<img height="16px" width="16px" align="middle" style="border:none;">
								<xsl:attribute name="src">../icons/UserDefined_3.png</xsl:attribute>
							</img>&#160;User Defined Alert no.3</nobr>
						<br/>
					</xsl:when>
					<xsl:otherwise>
						<img height="16px" width="16px" align="middle" style="border:none;">
							<xsl:attribute name="src">../icons/<xsl:value-of select="translate($attackTrack,' ','_')"/>.png</xsl:attribute>
						</img>&#160;
						<nobr>
							<xsl:value-of select="$attackTrack"/>
						</nobr>
						<br/>
					</xsl:otherwise>
				</xsl:choose>
			</td>
			<td class="object_cell_wide" valign="top">
				<xsl:call-template name="nameResolve">
					<xsl:with-param name="name" select="$attackAttribName"/>
				</xsl:call-template>
			</td>
			<td class="object_cell_wide" valign="top">
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
	<!--Attack More Rows-->
	<xsl:template name="attackMoreRows">
		<xsl:param name="attackAttribName"/>
		<xsl:param name="attackAttribValue"/>
		<xsl:param name="attackMultiAttribValue"/>
		<tr class="odd_row" STYLE="display: none;">
			<td class="object_cell" ></td>
						<td class="object_cell" ></td>

			<td class="object_cell" ></td>

			<td class="object_cell" ></td>

			<td class="object_cell_wide" valign="top">
				<xsl:call-template name="nameResolve">
					<xsl:with-param name="name" select="$attackAttribName"/>
				</xsl:call-template>
			</td>
			<td class="object_cell_wide" valign="top">
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
	<!--Open Category-->
	<xsl:template name="attackNewCategory">
		<xsl:param name="attackCategory"/>
		<xsl:if test="string($attackCategory) != string('')">
			<tr class="odd_row" valign="top">
				<th class="objects_header_l2" valign="top">
					<xsl:call-template name="nameResolve">
						<xsl:with-param name="name" select="$attackCategory"/>
					</xsl:call-template>
				</th>
				<th class="objects_header_l2" valign="top">-</th>
				<th class="objects_header_l2" valign="top">-</th>
				<th class="objects_header_l2" valign="top">-</th>
				<th class="objects_header_l2" valign="top">-</th>
				<th class="objects_header_l2" valign="top" notag="CPCATEGORYMARKTAG">-</th>
			</tr>
		</xsl:if>
	</xsl:template>
	<!-- Dynamic updates -->
	<xsl:template name="dynamicUpdate">
		<xsl:param name="duCategoty"/>
		<xsl:param name="exclude1"/>
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
				<xsl:choose>
					<xsl:when test="string($exclude1) = ''">
						<xsl:for-each select="/asm/as/dynamic_attacks/dynamic_attacks[string (parent_name) = string ($duCategoty) and string (show_atk) = 'true']">
							<xsl:call-template name="dynamicUpdateEntry">
								<xsl:with-param name="attackCreateCategory" select="string ('NO_NEW_CATEGORY')"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:when>
					<xsl:otherwise>
						<xsl:for-each select="/asm/as/dynamic_attacks/dynamic_attacks[string (parent_name) = string ($duCategoty) 
																								     and string (show_atk) = 'true' 
																								     and string (Name) != string($exclude1)]">
							<xsl:call-template name="dynamicUpdateEntry">
								<xsl:with-param name="attackCreateCategory" select="string ('NO_NEW_CATEGORY')"/>
							</xsl:call-template>
						</xsl:for-each>
					</xsl:otherwise>
				</xsl:choose>
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
			<xsl:with-param name="attackIsActive">
			<xsl:choose>
				<xsl:when test="string($cn/attack_mode) = '0'">false</xsl:when>
				<xsl:when test="string($cn/attack_mode) = '1'">true</xsl:when>
				<xsl:when test="string($cn/attack_mode) = '2'">-</xsl:when>
				<xsl:otherwise>-</xsl:otherwise>								
			</xsl:choose>
			</xsl:with-param>						
			<xsl:with-param name="attackMonitorOnly" select="$cn/attribs/attribs[translate(attrib_desc, 'MONP', 'monp') = 'monitor only - no protection']/attrib_value"/>
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
			<xsl:with-param name="attackIsActive">
			<xsl:choose>
				<xsl:when test="string(./attack_mode) = '0'">false</xsl:when>
				<xsl:when test="string(./attack_mode) = '1'">true</xsl:when>
				<xsl:when test="string(./attack_mode) = '2'">-</xsl:when>
				<xsl:otherwise>-</xsl:otherwise>								
			</xsl:choose>
			</xsl:with-param>						
			<xsl:with-param name="attackMonitorOnly" select="attribs/attribs[translate(attrib_desc, 'MONP', 'monp') = 'monitor only - no protection']/attrib_value"/>
			 <xsl:with-param name="attackTrack" select="attribs/attribs[attrib_desc = 'Track:']/attrib_value"/>
			<xsl:with-param name="attackAttribName">-</xsl:with-param>
			<xsl:with-param name="attackAttribValue">-</xsl:with-param>
		</xsl:call-template>
		<xsl:for-each select="attribs/attribs[attrib_desc != 'Track:' and  translate(attrib_desc, 'MONP', 'monp') != 'monitor only - no protection' and show_attrib = 'true']">
			<xsl:call-template name="attackMoreRows">
				<xsl:with-param name="attackAttribName" select="attrib_desc"/>
				<xsl:with-param name="attackAttribValue" select="attrib_value"/>
			</xsl:call-template>
		</xsl:for-each>
	</xsl:template>

</xsl:stylesheet>
