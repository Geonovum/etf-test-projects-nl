<?xml version="1.0"?>
<!--

    Copyright 2016 interactive instruments GmbH

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.

-->
<xsl:stylesheet version="1.0" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
	xmlns:sch="http://www.ascc.net/xml/schematron"
    xmlns:iso="http://purl.oclc.org/dsdl/schematron">  

  <!-- Suppress declarations of abstract rules -->
  <xsl:template match="iso:rule[@abstract='true']">
    <xsl:comment>Suppressed abstract rule <xsl:value-of select="@id"/></xsl:comment>	
  </xsl:template> 
    
  <!-- Suppress uses of abstract rules -->
  <xsl:template match="iso:extends">  
    <xsl:comment>Replacing extends</xsl:comment>
    <xsl:variable name="id" select="./@rule"/>  
    <xsl:copy-of select="//iso:rule[@id=$id]/*" />
    <xsl:comment>done replacing extends</xsl:comment>
  </xsl:template>
  
  <!-- output everything else unchanged -->
  <xsl:template match="*" priority="-1">
    <xsl:copy>
      <xsl:copy-of select="@*" />
      <xsl:apply-templates/> 
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>



