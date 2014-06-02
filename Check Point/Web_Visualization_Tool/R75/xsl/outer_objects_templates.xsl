<?xml version="1.0" encoding="ISO-8859-1"?>
<xsl:stylesheet xmlns:xsl="http://www.w3.org/1999/XSL/Transform" version="1.0">

<xsl:template name="net_obj_img_template">
	<xsl:param name="network_objects_set" />
	<xsl:param name="reference" />
	<xsl:param name="negate" />
	<div nowrap="true">
	<xsl:choose>
		<xsl:when test="not($reference/Table = 'network_objects')">
			<img height="16px" width="16px" class="ImgOuterObject" src="../icons/{translate($reference/Name,' ','')}.png" />&#160;
			<xsl:value-of select="$reference/Name"/>
		</xsl:when>	
		<xsl:when test="not($network_objects_set/network_object[Name=$reference/Name]/Class_Name)">
			<img height="16px" width="16px" class="ImgOuterObject" src="../icons/global.png" />&#160;
			<xsl:value-of select="$reference/Name" />
		</xsl:when>
		<xsl:otherwise>
			<img class="ImgOuterObject">
				<xsl:attribute name="src">
					../icons/<xsl:value-of select="$network_objects_set/network_object[Name=$reference/Name]/Class_Name" /><xsl:if test="$negate">_X</xsl:if>.png
				</xsl:attribute>
				<xsl:if test="$negate">
					<xsl:attribute name="alt">Not</xsl:attribute>
				</xsl:if>
			</img>&#160;
			<a>
			<xsl:attribute name="href">
				network_objects.xml#<xsl:value-of select="$reference/Name"/>
			</xsl:attribute>
			<xsl:value-of select="$reference/Name"/>
			</a>
		</xsl:otherwise>
	</xsl:choose>
	</div>
</xsl:template>


<xsl:template name="service_img_template">
	<xsl:param name="services_set" />
	<xsl:param name="reference" />
	<xsl:param name="negate" />
	<div nowrap="true">
	<xsl:choose>
		<xsl:when test="not($reference/Table = 'services')">
			<img height="16px" width="16px" class="ImgOuterObject" src="../icons/{$reference/Name}.png" />&#160;
			<xsl:value-of select="$reference/Name"/>
		</xsl:when>	
		<xsl:when test="not($services_set/service[Name=$reference/Name]/Class_Name)">
			<img height="16px" width="16px" class="ImgOuterObject" src="../icons/global.png" />&#160;
			<xsl:value-of select="$reference/Name" />
		</xsl:when>
		<xsl:otherwise>
			<img class="ImgOuterObject">
				<xsl:attribute name="src">
					../icons/<xsl:value-of select="$services_set/service[Name=$reference/Name]/Class_Name" /><xsl:if test="$negate">_X</xsl:if>.png
				</xsl:attribute>
				<xsl:if test="$negate">
					<xsl:attribute name="alt">Not</xsl:attribute>
				</xsl:if>		
			</img>&#160;
			<a>
			<xsl:attribute name="href">
				services.xml#<xsl:value-of select="$reference/Name"/>
			</xsl:attribute>
			<xsl:value-of select="$reference/Name"/>
			</a>
		</xsl:otherwise>
	</xsl:choose>
	</div>
</xsl:template>

<xsl:template name="resource_link_template">
	<xsl:param name="services_set" />
	<xsl:param name="reference" />
	<xsl:param name="negate" />
	<xsl:if test="$reference/service/Table = 'services'">
		<div nowrap="true">
		<img class="ImgOuterObject">
			<xsl:attribute name="src">
				../icons/compound_<xsl:value-of select="$services_set/service[Name=$reference/service/Name]/Class_Name" /><xsl:if test="$negate">_X</xsl:if>.png
			</xsl:attribute>
			<xsl:if test="$negate">
				<xsl:attribute name="alt">Not</xsl:attribute>
			</xsl:if>		
		</img>&#160; 		
		<xsl:value-of select="$reference/Name"/>
		</div>
	</xsl:if>
</xsl:template>


<xsl:template name="community_link_template">
	<xsl:param name="communities_set" />
	<xsl:param name="reference" />
	<div nowrap="true">
	<xsl:choose>

		<xsl:when test="not($reference/Table = 'communities')">
			<img height="16px" width="16px" class="ImgOuterObject" src="../icons/{$reference/Name}.png" />&#160;
			<xsl:value-of select="$reference/Name"/>
		</xsl:when>
		<xsl:when test="not($communities_set/communitie[Name=$reference/Name]/Class_Name)">
			<img height="16px" width="16px" class="ImgOuterObject" src="../icons/global.png" />&#160;
			<xsl:value-of select="$reference/Name" />
		</xsl:when>
		<xsl:otherwise>
			<img height="16px" width="16px" class="ImgOuterObject">
				<xsl:attribute name="src">
				../icons/
					<xsl:choose>
						<xsl:when test="$communities_set/communitie[Name=$reference/Name]/Class_Name = 'intranet_community'">
							<xsl:value-of select="$communities_set/communitie[Name=$reference/Name]/topology" />
						</xsl:when>
						<xsl:otherwise>
							<xsl:value-of select="$communities_set/communitie[Name=$reference/Name]/Class_Name" />
						</xsl:otherwise>
					</xsl:choose>
					.png
				</xsl:attribute>
			</img>&#160;
			<a>
			<xsl:value-of select="$reference/Name"/>
			</a>
		</xsl:otherwise>
	</xsl:choose>
	</div>
</xsl:template>


</xsl:stylesheet>
