<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:etf="http://www.interactive-instruments.de/etf/1.0">

<!-- 
    (C) 2013-2015 interactive instruments GmbH
  
    @author herrmann at interactive-instruments.de
-->

    <xsl:import href="lang/current.xsl"/>
    <xsl:import href="UtilityTemplates.xsl"/>

    <xsl:variable name="defaultStyleResourcePath">
        <xsl:text>../resources/ii</xsl:text>
    </xsl:variable>
    <xsl:param name="stylePath" select="$defaultStyleResourcePath"></xsl:param>
    
    <xsl:variable name="defaultJqueryResourcePath">
        <xsl:text>../resources/ii</xsl:text>
    </xsl:variable>
    <xsl:param name="jqueryPath" select="$defaultJqueryResourcePath"></xsl:param>
    
    <xsl:variable name="defaultBaseUrl">
        <xsl:text>/</xsl:text>
    </xsl:variable>
    <xsl:param name="baseUrl" select="$defaultBaseUrl"></xsl:param>
    
    <xsl:variable name="defaultCssDirectInlcuding">
        <xsl:text>true</xsl:text>
    </xsl:variable>
    <xsl:param name="cssDirectInlcuding" select="$defaultCssDirectInlcuding"></xsl:param>

    <!-- JQuery Mobile and Styling includes-->
    <!-- ########################################################################################## -->
    <xsl:template name="jsfdeclAndCss">
        <meta charset="utf-8"/>
        
        <xsl:choose>
            <xsl:when test="$cssDirectInlcuding ='true'">
                <style type="text/css">
                    <xsl:value-of select="document('style/de.interactive-instruments.min.css')" disable-output-escaping="yes" />
                </style>
                
                <style type="text/css">
                    <xsl:value-of select="document('style/de.interactive-instruments.rep.css')" disable-output-escaping="yes" />
                </style>
            </xsl:when>
            <xsl:otherwise>
                <link rel="stylesheet" href="{$stylePath}/de.interactive-instruments.min.css"/>
                <link rel="stylesheet" href="{$stylePath}/de.interactive-instruments.rep.css"/>
            </xsl:otherwise>
        </xsl:choose>
        
        
        <link rel="stylesheet" href="http://ajax.googleapis.com/ajax/libs/jquerymobile/1.4.5/jquery.mobile.min.css" />
        <script src="http://ajax.aspnetcdn.com/ajax/jQuery/jquery-1.11.3.min.js"></script>
        <script>
            $(document).bind('mobileinit',function(){
            $.mobile.changePage.defaults.changeHash = false;
            $.mobile.hashListeningEnabled = false;
            $.mobile.pushStateEnabled = false;
            });
        </script>
        <script src="http://ajax.googleapis.com/ajax/libs/jquerymobile/1.4.5/jquery.mobile.js"></script>
        
    </xsl:template>
    <xsl:output method="html" indent="yes" encoding="UTF-8"/>

    <xsl:key name="tdKey1" match="/diff/statistics1/etf:Statistics/table/tr" use="td"/>
    <xsl:key name="tdKey2" match="/diff/statistics2/etf:Statistics/table/tr" use="td"/>

    <xsl:template match="diff">
        <html>
            <head>
                <title>Statistikvergleich</title>
                <xsl:call-template name="jsfdeclAndCss"/>
            </head>
            <body>
                <div data-role="page" id="comparison_page">
                    <div data-role="header">
                        <h1>Statistikvergleich</h1>
                        <a href="{$baseUrl}/reports" data-ajax="false" data-icon="back" data-iconpos="notext"/>
                        <a href="#configure" data-icon="gear" data-inline="true" data-role="button" data-mini="true" data-transition="pop" data-iconpos="notext"/>
                    </div>
                    <div data-role="content">
       
                        <div id="rprtAdditionalStatistics">
                            <xsl:apply-templates select="/diff/statistics1/etf:Statistics/table"/>
                        </div>
                    </div>
                    <script type="application/javascript">
                        $(document).ready(function() {
                        
                            $("#configure_ok").click(function() {
                               $('.highlight').each(function() {
                                    $(this).removeClass("highlight");
                               });
                            
                                $('.relative_changes').each(function() {
                                    if( parseFloat($(this).text()) > parseFloat($('#rel_changes_input').val()) ) {
                                        $(this).addClass("highlight");
                                    }
                                });
                            });
                            
                        });
                    </script>
                    <div data-role="footer">
                        <h1>ETF © 2013-2015 interactive instruments</h1>
                    </div>
                </div>

                <div data-role="page" data-dialog="true" id="configure">
                    <div data-role="header">
                        <h1>Hervorheben</h1>
                    </div>

                    <div data-role="main" class="ui-content">
                        <div data-role="fieldcontain" data-inline="true" data-mini="true">
                            <label for="rel_changes_input">Schwellwert für relative Änderungen</label>
                            <input type="number" data-highlight="true" name="rel_changes_input" id="rel_changes_input" value="0"  />
                        </div>	
                        <a id="configure_ok" data-inline="true" data-role="button" data-mini="true" href="#comparison_page">OK</a>
                    </div>
                </div>

            </body>
        </html>
    </xsl:template>

    <xsl:template match="/diff/statistics1/etf:Statistics/table">
        <table>
            <caption>
                <xsl:value-of select="caption"/>
            </caption>
            <tr>
                <th/>
                <th colspan="2" style="text-align: center !important;">
                    <xsl:value-of select="../../../statistics1/@label"/>
                </th>
                <th colspan="2" style="text-align: center !important;">
                    <xsl:value-of select="../../../statistics2/@label"/>
                </th>
                <th colspan="2" style="text-align: center !important;">Änderungen</th>
            </tr>
            <tr>
                <th>
                    <xsl:value-of select="tr[1]/th[1]"/>
                </th>
                <th>
                    <xsl:value-of select="tr[1]/th[2]"/>
                </th>
                <th>
                    <xsl:value-of select="tr[1]/th[3]"/>
                </th>
                <th>
                    <xsl:value-of select="tr[1]/th[2]"/>
                </th>
                <th>
                    <xsl:value-of select="tr[1]/th[3]"/>
                </th>
                <th>absolut</th>
                <th>relativ</th>
            </tr>
            <xsl:apply-templates select="/diff/statistics1/etf:Statistics/table/tr"/>
            <xsl:apply-templates select="/diff/statistics2/etf:Statistics/table/tr"/>
        </table>
    </xsl:template>

    <xsl:template match="/diff/statistics1/etf:Statistics/table/tr">
        <xsl:if test="not(th)">
            <tr>
                <td>
                    <xsl:value-of select="td[1]"/>
                </td>
                <td>
                    <xsl:value-of select="td[2]"/>
                </td>
                <td>
                    <xsl:value-of select="td[3]"/>
                </td>
                <xsl:choose>
                    <xsl:when test="key('tdKey2',td[1])">
                        <xsl:variable name="r1" select="key('tdKey2',td[1])/td[2]"/>
                        <xsl:variable name="r2" select="key('tdKey2',td[1])/td[3]"/>
                        <td>
                            <xsl:value-of select="$r1"/>
                        </td>
                        <td>
                            <xsl:value-of select="$r2"/>
                        </td>
                        <xsl:variable name="diff1" select="td[2]-$r1"/>
                        <xsl:variable name="diff2" select="td[3]-$r2"/>
                        <xsl:variable name="diff1_abs"
                            select="$diff1*($diff1 >=0) - $diff1*($diff1 &lt; 0)"/>
                        <xsl:variable name="diff2_abs"
                            select="$diff2*($diff2 >=0) - $diff2*($diff2 &lt; 0)"/>
                        <xsl:variable name="diff_abs" select="$diff1_abs+$diff2_abs"/>
                        <td>
                            <xsl:value-of select="$diff_abs"/>
                        </td>
                        <xsl:choose>
                            <xsl:when test="$diff_abs">
                                <td class="relative_changes">
                                    <xsl:value-of
                                        select="format-number($diff_abs div ($r1+$r2), '#%')"/>
                                </td>
                            </xsl:when>
                            <xsl:otherwise>
                                <td class="relative_changes">0</td>
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:when>
                    <xsl:otherwise>
                        <td>-</td>
                        <td>-</td>
                        <td>
                            <xsl:value-of select="td[2]+td[3]"/>
                        </td>
                        <td>-</td>
                    </xsl:otherwise>
                </xsl:choose>
            </tr>
        </xsl:if>
    </xsl:template>
    <xsl:template match="/diff/statistics2/etf:Statistics/table/tr">
        <xsl:if test="not(key('tdKey1',td[1]))">
            <xsl:if test="not(th)">
                <tr>
                    <td>
                        <xsl:value-of select="td[1]"/>
                    </td>
                    <td>-</td>
                    <td>-</td>
                    <td>
                        <xsl:value-of select="td[2]"/>
                    </td>
                    <td>
                        <xsl:value-of select="td[3]"/>
                    </td>
                    <td>
                        <xsl:value-of select="td[2]+td[3]"/>
                    </td>
                    <td>-</td>
                </tr>
            </xsl:if>
        </xsl:if>
    </xsl:template>

</xsl:stylesheet>
