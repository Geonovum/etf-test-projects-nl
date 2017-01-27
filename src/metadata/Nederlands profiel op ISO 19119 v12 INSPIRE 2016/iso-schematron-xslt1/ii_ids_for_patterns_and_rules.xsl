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
<xsl:stylesheet version="1.0" xmlns:iso="http://purl.oclc.org/dsdl/schematron"
  xmlns:sch="http://www.ascc.net/xml/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">

  <!-- Purpose of this stylesheet: create @id or rename @name to @id if necessary -->

  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

  <!-- rewrite @name on patterns to @id -->
  <xsl:template match="iso:pattern/@name">
    <xsl:attribute name="id">
      <xsl:value-of select="."/>
    </xsl:attribute>
  </xsl:template>

  <!-- set @id for pattern elements that don't have it (or an @name) -->
  <xsl:template match="iso:pattern[not(@id or @name)]">
    <xsl:copy>
      <xsl:attribute name="id">
        <xsl:text>UnknownPattern-</xsl:text>
        <xsl:value-of select="count(preceding-sibling::iso:pattern) + 1"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <!-- set @id for rule elements that don't have it -->
  <xsl:template match="iso:rule[not(@id)]">
    <xsl:copy>
      <xsl:attribute name="id">
        <xsl:text>UnknownRule-</xsl:text>
        <xsl:value-of select="count(preceding::iso:rule) + 1"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <!-- set @id for assert elements that don't have it -->
  <xsl:template match="iso:assert[not(@id)]">
    <xsl:copy>
      <xsl:attribute name="id">
        <xsl:text>UnknownAssert-</xsl:text>
        <xsl:value-of select="count(preceding::*[local-name() = 'assert' or local-name() = 'report']) + 1"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
  <!-- set @id for assert elements that don't have it -->
  <xsl:template match="iso:report[not(@id)]">
    <xsl:copy>
      <xsl:attribute name="id">
        <xsl:text>UnknownReport-</xsl:text>
        <xsl:value-of select="count(preceding::*[local-name() = 'assert' or local-name() = 'report']) + 1"/>
      </xsl:attribute>
      <xsl:apply-templates select="@*|node()" />
    </xsl:copy>
  </xsl:template>
  
</xsl:stylesheet>
