<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet version="1.0" xmlns:svrl="http://purl.oclc.org/dsdl/svrl"
  xmlns:svrlii="http://www.interactive-instruments.de/svrl"
  xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
  <xsl:output indent="yes" method="xml" omit-xml-declaration="yes"/>

  <xsl:strip-space elements="*"/>

  <xsl:template match="svrl:active-pattern">
    <svrl:active-pattern>
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates select="svrl:fired-rule">
        <xsl:with-param name="countActivePatternChildren" select="count(*)"/>
      </xsl:apply-templates>
    </svrl:active-pattern>
  </xsl:template>

  <xsl:template match="svrl:fired-rule">
    <xsl:param name="countActivePatternChildren"/>
    <svrl:fired-rule>
      <xsl:copy-of select="@*"/>
      <!-- identify the next sibling -->
      <xsl:variable name="nextSibling" select="following-sibling::*[1]"/>
      <!-- perform costly computations only if the next sibling exists and is not a 'fired-rule' -->
      <xsl:if test="boolean($nextSibling) and not(local-name($nextSibling) = 'fired-rule')">
        <xsl:variable name="posLowerExclusive" select="count(preceding-sibling::*) + 1"/>
        <xsl:variable name="posUpperInclusive">
          <xsl:choose>
            <xsl:when test="following-sibling::svrl:fired-rule">
              <xsl:value-of
                select="count(following-sibling::svrl:fired-rule[1]/preceding-sibling::*)"/>
            </xsl:when>
            <xsl:otherwise>
              <xsl:value-of select="$countActivePatternChildren"/>
            </xsl:otherwise>
          </xsl:choose>
        </xsl:variable>
        <xsl:apply-templates mode="copy-no-namespaces"
          select="../*[(position() > $posLowerExclusive) and ($posUpperInclusive >= position())]"
        > </xsl:apply-templates>
      </xsl:if>
    </svrl:fired-rule>
  </xsl:template>

  <!-- generate a new element in the same namespace as the matched element,
     copying its attributes, but without copying its unused namespace nodes,
     then continue processing content in the "copy-no-namepaces" mode -->

  <xsl:template match="svrl:text" mode="copy-no-namespaces">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:copy-of select="normalize-space(.)"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="*" mode="copy-no-namespaces">
    <xsl:element name="{name()}" namespace="{namespace-uri()}">
      <xsl:copy-of select="@*"/>
      <xsl:apply-templates mode="copy-no-namespaces" select="node()"/>
    </xsl:element>
  </xsl:template>

  <xsl:template match="comment() | processing-instruction()" mode="copy-no-namespaces">
    <xsl:copy/>
  </xsl:template>

  <!-- Identity transform for everything that is not covered by a specific template -->
  <xsl:template match="@* | node()">
    <xsl:copy>
      <xsl:apply-templates select="@* | node()"/>
    </xsl:copy>
  </xsl:template>

</xsl:stylesheet>
