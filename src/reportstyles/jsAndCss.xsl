<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:x="ii.exclude">
	
	<xsl:import href="lang/current.xsl"/>
	<xsl:variable name="lang" select="document('lang/current.xsl')/*/x:lang"/>
	
	<xsl:output method="html" indent="yes" encoding="UTF-8"/>
	
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
	
	<!-- Report controls-->
	<!-- ########################################################################################## -->
	<xsl:template name="controls">
		<div id="rprtControl">
			
			<fieldset id="controlgroupLOD" data-role="controlgroup" data-mini="true">
				<legend><xsl:value-of select="$lang/x:e[@key='LevelOfDetail']"/></legend>
				<input type="radio" name="radio-LOD" id="cntrlAllDetails" value="cntrlAllDetails"/>
				<label for="cntrlAllDetails"><xsl:value-of select="$lang/x:e[@key='AllDetails']"/></label>
				
				<input type="radio" name="radio-LOD" id="cntrlLessInformation"
					value="cntrlLessInformation"/>
				<label for="cntrlLessInformation"><xsl:value-of select="$lang/x:e[@key='LessInformation']"/></label>
				
				<input type="radio" name="radio-LOD" id="cntrlSimplified" value="cntrlSimplified"
					checked="checked"/>
				<label for="cntrlSimplified"><xsl:value-of select="$lang/x:e[@key='Simplified']"/></label>
			</fieldset>
			
			<fieldset id="controlgroupShow" data-role="controlgroup" data-mini="true">
				<legend><xsl:value-of select="$lang/x:e[@key='Show']"/></legend>
				<input type="radio" name="radio-Show" id="cntrlShowAlsoFailed"
					value="cntrlShowAlsoFailed"/>
				<label for="cntrlShowAlsoFailed"><xsl:value-of select="$lang/x:e[@key='All']"/></label>
				
				<input type="radio" name="radio-Show" id="cntrlShowOnlyFailed"
					value="cntrlShowOnlyFailed" checked="checked"/>
				<label for="cntrlShowOnlyFailed"><xsl:value-of select="$lang/x:e[@key='OnlyFailed']"/></label>
			</fieldset>
			
		</div>
	</xsl:template>
	
	<!-- Script tags in the footer-->
	<!-- ########################################################################################## -->
	<xsl:template name="footerScripts">
		<script>
			<!-- Controls for switching the level of detail -->
			
            function showFailed() {
			var cntrl = $( "input[name=radio-Show]:checked" ).val();
			if(cntrl=="cntrlShowOnlyFailed")
			    {
			    $('.TestSuite').collapsible('expand');
			    $( ".SuccessfulTestCase" ).hide('slow');
			    $('.FailedTestCase').collapsible('expand');
			    $('.SuccessfulTestStep').collapsible('collapse');
			    $('.FailedTestStep').collapsible('expand');
			    $( ".SuccessfulTestStep" ).hide('slow');
			    $('.FailedAssertion').collapsible('expand');
			    $('.SuccessfulAssertion').hide('slow');
			    }
			else if(cntrl=="cntrlShowAlsoFailed")
			    {
			    $( ".SuccessfulTestCase" ).show('fast');
			    $( ".SuccessfulTestStep" ).show('fast');
			    $('.SuccessfulAssertion').show('fast');
			    }
			}

            $( "input[name=radio-Show]" ).on( "click",
              showFailed
			);
            

			$( "input[name=radio-LOD]" ).on( "click",
			function() {
			var cntrl = $( "input[name=radio-LOD]:checked" ).val();
			if(cntrl=="cntrlSimplified")
			{
			$( ".ReportDetail" ).hide("slow");
			$('.DoNotShowInSimpleView').hide('slow');
			
			<!-- Cut text -->
			var assertionFailureMessage = 
			'Expected text value \'AssertionFailures:\' but was \'AssertionFailures:\'';
			$('.XQueryContainsAssertion').hide('slow');
			}
			else if(cntrl=="cntrlLessInformation")
			{
			$('.ReportDetail').hide('slow');
			$('.DoNotShowInSimpleView').show('slow');
			}
			else if(cntrl=="cntrlAllDetails")
			{
			$('.ReportDetail').show('slow');
			$('.DoNotShowInSimpleView').show('slow');
			}
			});
			
			$( document ).ready(function() {
			$( ".ReportDetail" ).hide();
			$('.DoNotShowInSimpleView').hide();
            // workaround for Geonovum: show failed after a while, because of a clash with the collapsible elements
            setTimeout(showFailed, 1000)
			});
			
		</script>
	</xsl:template>
	
</xsl:stylesheet>
