<?xml version="1.0" encoding="iso-8859-1"?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:etf="http://www.interactive-instruments.de/etf/1.0"
 xmlns:ii="http://www.interactive-instruments.de/ii/1.0"
 xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:x="ii.exclude"
 exclude-result-prefixes="x">

 <!--
  (C) 2013-2016 interactive instruments GmbH

  This stylesheet can be used to transform a serialized TestReport
  (ETF-Model version 0.6.x) into a HTML Document.

  This stylesheet itself does not contain styling rules, but structeres
  the output with HTML5 data-rule attributes which are interpreted by
  the JQuery Mobile JavaScript Library. The styling can be modified in
  the corresponding css files.

  The XML-Report contains "fixed" data, like the name of a test case,
  the description, the input data, etc. and result data that are generated
  during the test execution. Every result data object references a "fixed"
  data object. For instance an AssertionResult references an Assertion.

  @author herrmann at interactive-instruments.de
 -->

 <xsl:import href="lang/current.xsl"/>
 <xsl:import href="jsAndCss.xsl"/>
 <xsl:import href="UtilityTemplates.xsl"/>
 <xsl:preserve-space elements="StrContainer"/>
 <xsl:output method="html" indent="yes" encoding="UTF-8"/>

 <!-- Translation -->
 <xsl:key name="translation" match="x:lang/x:e" use="@key"/>
 <xsl:variable name="lang" select="document('lang/current.xsl')/*/x:lang"/>
 <xsl:template match="x:lang">
  <xsl:param name="str"/>
  <xsl:variable name="result" select="key('translation', $str)"/>
  <xsl:choose>
   <xsl:when test="$result">
    <xsl:value-of select="$result"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$str"/>
   </xsl:otherwise>
  </xsl:choose>
 </xsl:template>

 <!-- Property Level of details -->
 <x:propertyVisibility>
  <!-- possible values:
   -not mapped -> show always
   -ReportDetail
   -DoNotShowInSimpleView
   -->
  <x:e key="DetailedDescription">DoNotShowInSimpleView</x:e>
  <x:e key="Reference">ReportDetail</x:e>
  <x:e key="SpecificationReference">DoNotShowInSimpleView</x:e>
 </x:propertyVisibility>
 <xsl:key name="propertyVisibility" match="x:propertyVisibility/x:e" use="@key"/>


 <!-- Create lookup tables for faster id lookups -->
 <xsl:key name="testStepKey" match="etf:TestStep" use="@id"/>
 <xsl:key name="testCaseKey" match="etf:TestCase" use="@id"/>
 <xsl:key name="testAssertionKey" match="etf:Assertion" use="@id"/>
 <xsl:key name="requirementKey" match="/etf:TestReport/etf:Requirements/etf:Requirement" use="@id"/>
 <xsl:key name="alternativeSubRequirementKey"
  match="/etf:TestReport/etf:Requirements/etf:Requirement" use="etf:Label"/>

 <!-- Test Report -->
 <!-- ########################################################################################## -->
 <xsl:template match="/etf:TestReport">
  <html>
   <head>
    <title>
     <xsl:value-of select="$lang/x:e[@key = 'Title']"/>
    </title>
    <!-- Include Styles and Javascript functions -->
    <xsl:call-template name="jsfdeclAndCss"/>
   </head>
   <body>
    <div data-role="header">
     <h1>
      <xsl:value-of select="/etf:TestReport/etf:Label"/>
     </h1>
     <a href="{$baseUrl}/reports" data-ajax="false" data-icon="back" data-iconpos="notext"/>
    </div>
    <div data-role="content">
     <div class="ui-grid-b">
      <div class="ui-block-a">
       <xsl:call-template name="reportInfo"/>
      </div>
      <div class="ui-block-b">
       <xsl:call-template name="statistics"/>
      </div>
      <div class="ui-block-c">
       <xsl:call-template name="controls"/>
      </div>
     </div>

     <!-- Test run properties -->
     <xsl:apply-templates select="/etf:TestReport/etf:TestRunProperties"/>

     <!-- Test object -->
     <xsl:apply-templates select="/etf:TestReport/etf:TestObject"/>

     <!-- Additional statistics provided by the test project -->
     <xsl:apply-templates select="/etf:TestReport/etf:Statistics"/>

     <!-- Test Suite Results -->
     <xsl:apply-templates select="/etf:TestReport/etf:TestSuiteResults"/>
    </div>
    <xsl:call-template name="footer"/>
   </body>
  </html>
 </xsl:template>

 <!-- General report information-->
 <!-- ########################################################################################## -->
 <xsl:template name="reportInfo">
  <div id="rprtInfo">
   <table>
    <tr class="ReportDetail">
     <td>
      <xsl:value-of select="$lang/x:e[@key = 'PublicationLocation']"/>
     </td>
     <td>
      <a href="../../reports/{@id}" data-ajax="false">
       <xsl:value-of select="/etf:TestReport/@id"/>
      </a>
     </td>
    </tr>

    <tr>
     <td>
      <xsl:value-of select="$lang/x:e[@key = 'Created']"/>
     </td>
     <td>
      <xsl:call-template name="formatDate">
       <xsl:with-param name="DateTime" select="/etf:TestReport/etf:StartTimestamp"/>
      </xsl:call-template>
     </td>
    </tr>
    <tr class="DoNotShowInSimpleView">
     <td>
      <xsl:value-of select="$lang/x:e[@key = 'Duration']"/>
     </td>
     <td>
      <xsl:value-of select="/etf:TestReport/etf:Duration"/> ms </td>
    </tr>

    <tr>
     <td>
      <xsl:value-of select="$lang/x:e[@key = 'TestMachine']"/>
     </td>
     <td>
      <xsl:value-of select="/etf:TestReport/etf:MachineName"/>
     </td>
    </tr>
    <tr>
     <td>
      <xsl:value-of select="$lang/x:e[@key = 'Account']"/>
     </td>
     <td>
      <xsl:value-of select="/etf:TestReport/etf:Account"/>
     </td>
    </tr>
    <tr class="ReportDetail">
     <td>
      <xsl:value-of select="$lang/x:e[@key = 'ReportCompleted']"/>
     </td>
     <td>
      <xsl:value-of select="/etf:TestReport/@finalized"/>
     </td>
    </tr>
    <tr class="ReportDetail">
     <td>
      <xsl:value-of select="$lang/x:e[@key = 'ReportVersion']"/>
     </td>
     <td>
      <xsl:choose>
       <xsl:when test="/etf:TestReport/@version">
        <xsl:value-of select="/etf:TestReport/@version"/>
       </xsl:when>
       <xsl:when test="/etf:TestReport/@mv">
        <xsl:value-of select="/etf:TestReport/@mv"/>
       </xsl:when>
      </xsl:choose>
     </td>
    </tr>
    <!--tr class="ReportDetail">
     <td>Report generator</td>
     <td>
      <xsl:value-of select="/etf:TestReport/@generator"/>
     </td>
    </tr-->
    <!--tr class="ReportDetail">
     <td>Testing tool</td>
     <td>
      <xsl:value-of select="/etf:TestReport/etf:TestingTool"/>
     </td>
    </tr-->
   </table>
  </div>
 </xsl:template>

 <!-- Short Statistics -->
 <!-- ########################################################################################## -->
 <xsl:template name="statistics">
  <div id="rprtStatistics">
   <table id="my-table">
    <thead>
     <tr>
      <th/>
      <th>
       <xsl:value-of select="$lang/x:e[@key = 'Count']"/>
      </th>
      <th>
       <xsl:value-of select="$lang/x:e[@key = 'Skipped']"/>
      </th>
      <th>
       <xsl:value-of select="$lang/x:e[@key = 'Failed']"/>
      </th>
      <th>
       <xsl:value-of select="$lang/x:e[@key = 'Warning']"/>
      </th>
     </tr>
    </thead>
    <tbody>
     <!-- TEST SUITES STATS-->
     <tr>
      <td>
       <xsl:value-of select="$lang/x:e[@key = 'TestSuites']"/>
      </td>
      <td>
       <xsl:value-of select="count(/etf:TestReport/etf:TestSuiteResults/*)"/>
      </td>
      <!-- Deactivated TestSuites will not be listed yet... -->
      <td>0</td>
      <td>
       <xsl:value-of
        select="count(/etf:TestReport/etf:TestSuiteResults[etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult/etf:ResultStatus = 'FAILED'])"
       />
      </td>
      <td>
       <xsl:value-of
        select="count(/etf:TestReport/etf:TestSuiteResults[etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult/etf:ResultStatus = 'WARNING'])"
       />
      </td>
     </tr>
     <tr>
      <!-- TEST CASES STATS-->
      <td>
       <xsl:value-of select="$lang/x:e[@key = 'TestCases']"/>
      </td>
      <xsl:variable name="testCaseCount"
       select="count(/etf:TestReport/etf:TestSuiteResults/etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult)"/>
      <td>
       <xsl:value-of select="$testCaseCount"/>
      </td>
      <!-- Deactivated Test cases will not be listed yet. -->
      <td>0</td>
      <td>
       <xsl:value-of
        select="count(/etf:TestReport/etf:TestSuiteResults/etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult[etf:ResultStatus = 'FAILED'])"
       />
      </td>
      <td>
       <xsl:value-of
        select="count(/etf:TestReport/etf:TestSuiteResults/etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult[etf:ResultStatus = 'WARNING'])"
       />
      </td>
     </tr>
     <tr>
      <!-- TEST STEPS STATS-->
      <td>
       <xsl:value-of select="$lang/x:e[@key = 'TestSteps']"/>
      </td>
      <td>
       <xsl:value-of
        select="count(/etf:TestReport/etf:TestSuiteResults/etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult/etf:TestStepResults/etf:TestStepResult)"
       />
      </td>
      <td>0</td>
      <td>
       <xsl:value-of
        select="count(/etf:TestReport/etf:TestSuiteResults/etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult/etf:TestStepResults/etf:TestStepResult[etf:ResultStatus = 'FAILED'])"
       />
      </td>
      <td>
       <xsl:value-of
        select="count(/etf:TestReport/etf:TestSuiteResults/etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult/etf:TestStepResults/etf:TestStepResult[etf:ResultStatus = 'WARNING'])"
       />
      </td>
     </tr>
     <tr>
      <!-- TEST ASSERTIONS STATS-->
      <td>
       <xsl:value-of select="$lang/x:e[@key = 'TestAssertions']"/>
      </td>
      <td>
       <xsl:value-of
        select="count(/etf:TestReport/etf:TestSuiteResults/etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult/etf:TestStepResults/etf:TestStepResult/etf:AssertionResults/etf:AssertionResult)"
       />
      </td>
      <td>
       <!-- SKIPPED -->
       <xsl:value-of
        select="count(/etf:TestReport/etf:TestSuiteResults/etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult/etf:TestStepResults/etf:TestStepResult/etf:AssertionResults/etf:AssertionResult[etf:ResultStatus = 'SKIPPED'])"
       />
      </td>
      <td>
       <xsl:value-of
        select="count(/etf:TestReport/etf:TestSuiteResults/etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult/etf:TestStepResults/etf:TestStepResult/etf:AssertionResults/etf:AssertionResult[etf:ResultStatus = 'FAILED'])"
       />
      </td>
      <td>
       <xsl:value-of
        select="count(/etf:TestReport/etf:TestSuiteResults/etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult/etf:TestStepResults/etf:TestStepResult/etf:AssertionResults/etf:AssertionResult[etf:ResultStatus = 'WARNING'])"
       />
      </td>
     </tr>
    </tbody>
   </table>
  </div>
 </xsl:template>

 <!-- Properties used in test run -->
 <!-- ########################################################################################## -->
 <xsl:template match="etf:TestRunProperties">
  <xsl:if test="ii:Items/ii:Item/ii:value">
   <div id="rprtParameters" data-role="collapsible" data-collapsed-icon="info" class="ReportDetail">
    <h3>
     <xsl:value-of select="$lang/x:e[@key = 'Parameters']"/>
    </h3>
    <table>
     <xsl:for-each select="ii:Items/ii:Item">
      <xsl:if test="normalize-space(./ii:value/text())">
       <tr>
        <td>
         <xsl:value-of select="./@name"/>
        </td>
        <td>
         <xsl:value-of select="./ii:value/text()"/>
        </td>
       </tr>
      </xsl:if>
     </xsl:for-each>
    </table>
   </div>
  </xsl:if>
 </xsl:template>

 <!-- TestObject -->
 <!-- ########################################################################################## -->
 <xsl:template match="etf:TestObject">
  <div id="rprtTestobject" data-role="collapsible" data-collapsed-icon="info" class="ReportDetail">
   <h3>
    <xsl:value-of select="$lang/x:e[@key = 'TestObject']"/>
   </h3>
   <table>
    <xsl:call-template name="itemData">
     <xsl:with-param name="Node" select="."/>
    </xsl:call-template>
   </table>
  </div>
 </xsl:template>

 <!-- Additional statistics provided by the test project -->
 <!-- ########################################################################################## -->
 <xsl:template match="etf:Statistics">
  <div id="rprtAdditionalStatistics" data-role="collapsible" data-collapsed-icon="info"
   class="DoNotShowInSimpleView">
   <h3>
    <xsl:value-of select="$lang/x:e[@key = 'Statistics']"/>
   </h3>
   <xsl:copy-of select="./*"/>
  </div>
 </xsl:template>

 <!-- Test suite result information -->
 <!-- ########################################################################################## -->
 <xsl:template match="etf:TestSuiteResults/*">
  <!-- Order by TestSuites -->
  <div class="TestSuite" data-role="collapsible" data-theme="e" data-content-theme="e">
   <xsl:variable name="FailedTestCaseCount"
    select="count(./etf:TestCaseResults/etf:TestCaseResult[etf:ResultStatus = 'FAILED'])"/>
   <h2>
    <xsl:value-of select="./etf:Label"/>

    <xsl:if test="count(./etf:TestCaseResults/etf:TestCaseResult) > 0">
     <div class="ui-li-count">
      <xsl:if test="$FailedTestCaseCount > 0"> Failed: <xsl:value-of select="$FailedTestCaseCount"/>
       / </xsl:if>
      <xsl:value-of select="count(./etf:TestCaseResults/etf:TestCaseResult)"/>
     </div>
    </xsl:if>

   </h2>
   <!-- TestCase result information -->
   <xsl:apply-templates select="./etf:TestCaseResults/etf:TestCaseResult"/>
  </div>
 </xsl:template>

 <!-- Test case result information -->
 <!-- ########################################################################################## -->
 <xsl:template
  match="/etf:TestReport/etf:TestSuiteResults/etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult">

  <div data-role="collapsible" data-theme="f" data-content-theme="f" data-inset="false"
   data-mini="true">

   <xsl:choose>
    <xsl:when test="./etf:ResultStatus = 'FAILED'">
     <xsl:attribute name="data-collapsed-icon">alert</xsl:attribute>
     <!--xsl:attribute name="data-theme">i</xsl:attribute-->
     <xsl:attribute name="class">TestCase FailedTestCase</xsl:attribute>
    </xsl:when>
    <xsl:otherwise>
     <xsl:attribute name="class">TestCase SuccessfulTestCase</xsl:attribute>
    </xsl:otherwise>
   </xsl:choose>

   <xsl:variable name="TestCase" select="key('testCaseKey', ./@testCaseRef)"/>
   <xsl:variable name="TestStepCount" select="count(./etf:TestStepResults/etf:TestStepResult)"/>
   <xsl:variable name="FailedTestStepCount"
    select="count(./etf:TestStepResults/etf:TestStepResult[etf:ResultStatus = 'FAILED'])"/>

   <h3>
    <xsl:variable name="label">
     <xsl:call-template name="string-replace">
      <xsl:with-param name="text" select="$TestCase/etf:Label"/>
      <xsl:with-param name="replace" select="'(disabled)'"/>
      <xsl:with-param name="by" select="''"/>
     </xsl:call-template>
    </xsl:variable>

    <xsl:value-of select="$label"/>

    <xsl:if test="$TestStepCount > 0">
     <div class="ui-li-count">
      <xsl:if test="$FailedTestStepCount > 0"> Failed: <xsl:value-of select="$FailedTestStepCount"/>
       / </xsl:if>
      <xsl:value-of select="$TestStepCount"/>
     </div>
    </xsl:if>

   </h3>

   <!-- General data about test result and test case -->
   <table>
    <tr class="ReportDetail">
     <td><xsl:value-of select="$lang/x:e[@key = 'TestCase']"/> ID</td>
     <td>
      <xsl:value-of select="$TestCase/@id"/>
     </td>
    </tr>
    <xsl:call-template name="itemData">
     <xsl:with-param name="Node" select="$TestCase"/>
    </xsl:call-template>

    <xsl:variable name="refReqId"
     select="$TestCase/etf:AssociatedRequirements/etf:Requirement/text()"/>
    <!-- TODO: for each requirement -->
    <xsl:if test="normalize-space($refReqId)">
     <xsl:choose>
      <xsl:when test="key('requirementKey', $refReqId)">
       <xsl:apply-templates select="key('requirementKey', $refReqId)"/>
      </xsl:when>
      <xsl:otherwise>
       <b>Lookup of referenced requirement <xsl:value-of select="$refReqId"/> failed. This might be
        a defect in the test project.</b>
      </xsl:otherwise>
     </xsl:choose>

    </xsl:if>

   </table>

   <!--Add test step results and information about the teststeps -->
   <xsl:apply-templates select="./etf:TestStepResults/etf:TestStepResult"/>

  </div>

 </xsl:template>

 <!-- Test Step Results -->
 <!-- ########################################################################################## -->
 <xsl:template
  match="/etf:TestReport/etf:TestSuiteResults/etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult/etf:TestStepResults/etf:TestStepResult">

  <!-- Information from referenced Test Step -->
  <xsl:variable name="TestStep" select="key('testStepKey', ./@testStepRef)"/>

  <!-- RunTestStep step results do not reference other steps -->
  <xsl:if test="$TestStep">
   <div data-role="collapsible" data-theme="g" data-content-theme="g" data-mini="true">
    <xsl:variable name="visbility">
     <xsl:if test="$TestStep/etf:Properties[1]/ii:Items[1]/ii:Item[@name='type'] and not($TestStep/etf:Properties[1]/ii:Items[1]/ii:Item[@name='type']/ii:value[1]='HttpTestRequestStep')">
      DoNotShowInSimpleView
      </xsl:if>
    </xsl:variable>

    <xsl:choose>
     <xsl:when test="./etf:ResultStatus = 'FAILED'">
      <xsl:attribute name="data-collapsed-icon">alert</xsl:attribute>
      <xsl:attribute name="data-theme">i</xsl:attribute>
      <!--xsl:attribute name="data-content-theme">i</xsl:attribute-->
      <xsl:attribute name="class">TestStep FailedTestStep</xsl:attribute>
     </xsl:when>
     <xsl:when test="./etf:ResultStatus = 'OK'">
      <xsl:attribute name="class"><xsl:value-of select="$visbility"/>TestStep SuccessfulTestStep</xsl:attribute>
     </xsl:when>
     <xsl:when test="./etf:ResultStatus = 'WARNING'">
      <!-- Thijs: don't use a different theming for Warnings, for schematron this is nicer (where reports are considered warnings in the ETF app, but considered differently by Geonovum )
		<xsl:attribute name="data-theme">j</xsl:attribute> -->
      <xsl:attribute name="class">TestStep WarningInTestStep</xsl:attribute>
     </xsl:when>
     <xsl:when test="./etf:ResultStatus = 'SKIPPED'">
      <xsl:attribute name="data-theme">j</xsl:attribute>
      <xsl:attribute name="class"><xsl:value-of select="$visbility"/>TestStep SkippedTestStep</xsl:attribute>
     </xsl:when>
     <xsl:otherwise>
      <!-- unknown status -->
      <xsl:attribute name="class">TestStep</xsl:attribute>
     </xsl:otherwise>
    </xsl:choose>

    <xsl:variable name="FailedAssertionCount"
     select="count(./etf:AssertionResults/etf:AssertionResult[etf:ResultStatus = 'FAILED'])"/>
    <h4>
     <xsl:variable name="label">
      <xsl:call-template name="string-replace">
       <xsl:with-param name="text" select="$TestStep/etf:Label"/>
       <xsl:with-param name="replace" select="'(disabled)'"/>
       <xsl:with-param name="by" select="''"/>
      </xsl:call-template>
     </xsl:variable>
     <xsl:value-of select="$label"/>

     <xsl:if test="count(./etf:AssertionResults/etf:AssertionResult) > 0">
      <div class="ui-li-count">
       <xsl:if test="$FailedAssertionCount > 0"> Failed: <xsl:value-of
         select="$FailedAssertionCount"/> / </xsl:if>
       <xsl:value-of select="count(./etf:AssertionResults/etf:AssertionResult)"/>
      </div>
     </xsl:if>

    </h4>

    <table class="TestStepMetadata">
     <tr class="ReportDetail">
      <td><xsl:value-of select="$lang/x:e[@key = 'TestStep']"/> ID</td>
      <td>
       <xsl:value-of select="$TestStep/@id"/>
      </td>
     </tr>
     <xsl:if test="$TestStep/etf:Description/text()">
      <tr>
       <td><xsl:value-of select="$lang/x:e[@key = 'Description']"/>: </td>
       <td>
        <xsl:value-of select="$TestStep/etf:Description"/>
       </td>
      </tr>
     </xsl:if>
     <tr>
      <td><xsl:value-of select="$lang/x:e[@key = 'Duration']"/>: </td>
      <td>
       <xsl:value-of select="./etf:Duration"/> ms </td>
     </tr>
     <tr class="DoNotShowInSimpleView">
      <td><xsl:value-of select="$lang/x:e[@key = 'Started']"/>: </td>
      <td>
       <xsl:call-template name="formatDate">
        <xsl:with-param name="DateTime" select="./etf:StartTimestamp"/>
       </xsl:call-template>
      </td>
     </tr>
     <xsl:if test="./etf:Resource">
      <tr>
       <td><xsl:value-of select="$lang/x:e[@key = 'Resource']"/>: </td>
       <td>
        <xsl:value-of select="./etf:Resource"/>
       </td>
      </tr>
     </xsl:if>
    </table>
    <br/>
    <!-- Request -->
    <xsl:if
     test="$TestStep/etf:TestObjectInput/text() or $TestStep/etf:TestObjectInput/@referenceURL">
     <div class="Request">
      <xsl:if test="$FailedAssertionCount=0">
       <xsl:attribute name="class">DoNotShowInSimpleView</xsl:attribute>
      </xsl:if>
      <xsl:apply-templates select="$TestStep/etf:TestObjectInput"/>
     </div>
    </xsl:if>


    <!-- Response -->
    <div class="Response">
     <xsl:if test="$FailedAssertionCount=0">
      <xsl:attribute name="class">DoNotShowInSimpleView</xsl:attribute>
     </xsl:if>
     <xsl:apply-templates select="./etf:TestObjectOutput"/>
    </div>

    <!-- Test step failure messages-->
    <xsl:if test="./etf:Messages/*">
     <xsl:apply-templates select="./etf:Messages"/>
    </xsl:if>

    <!-- Get Assertion results and SubRequirements -->
    <xsl:if test="./etf:AssertionResults/etf:AssertionResult">
     <div class="AssertionsContainer">
      <h4><xsl:value-of select="$lang/x:e[@key = 'TestAssertions']"/>:</h4>
      <xsl:apply-templates select="./etf:AssertionResults/etf:AssertionResult"/>
     </div>
    </xsl:if>

   </div>
  </xsl:if>

 </xsl:template>

 <!-- Assertion results -->
 <!-- ########################################################################################## -->
 <xsl:template
  match="/etf:TestReport/etf:TestSuiteResults/etf:TestSuiteResult/etf:TestCaseResults/etf:TestCaseResult/etf:TestStepResults/etf:TestStepResult/etf:AssertionResults/etf:AssertionResult">

  <div data-role="collapsible" data-mini="true">
   <!-- Assertion Styling: Set attributes do indicate the status -->
   <xsl:attribute name="data-theme">
    <xsl:choose>
     <xsl:when test="./etf:ResultStatus = 'OK'">h</xsl:when>
     <xsl:when test="./etf:ResultStatus = 'FAILED'">i</xsl:when>
     <xsl:when test="./etf:ResultStatus = 'WARNING'">j</xsl:when>
     <xsl:when test="./etf:ResultStatus = 'SKIPPED'"/>
     <xsl:otherwise>k</xsl:otherwise>
    </xsl:choose>
   </xsl:attribute>
   <xsl:attribute name="data-content-theme">
    <xsl:choose>
     <xsl:when test="./etf:ResultStatus = 'OK'">h</xsl:when>
     <xsl:when test="./etf:ResultStatus = 'FAILED'">i</xsl:when>
     <xsl:when test="./etf:ResultStatus = 'WARNING'">g</xsl:when>
     <xsl:when test="./etf:ResultStatus = 'SKIPPED'"/>
    </xsl:choose>
   </xsl:attribute>
   <xsl:attribute name="data-collapsed-icon">
    <xsl:choose>
     <xsl:when test="./etf:ResultStatus = 'OK'">check</xsl:when>
     <xsl:when test="./etf:ResultStatus = 'FAILED'">alert</xsl:when>
     <xsl:when test="./etf:ResultStatus = 'WARNING'">alert</xsl:when>
     <xsl:when test="./etf:ResultStatus = 'SKIPPED'">forbidden</xsl:when>
    </xsl:choose>
   </xsl:attribute>
   <xsl:attribute name="class">
    <xsl:choose>
     <xsl:when test="./etf:ResultStatus = 'OK'">Assertion SuccessfulAssertion</xsl:when>
     <xsl:when test="./etf:ResultStatus = 'FAILED'">Assertion FailedAssertion</xsl:when>
     <xsl:when test="./etf:ResultStatus = 'WARNING'">Assertion WarningAssertion</xsl:when>
     <xsl:when test="./etf:ResultStatus = 'SKIPPED'">Assertion SkippedAssertion
      DoNotShowInSimpleView</xsl:when>
    </xsl:choose>
   </xsl:attribute>

   <xsl:variable name="id" select="./@id"/>

   <!-- Information from referenced Assertion -->
   <xsl:variable name="TestAssertion" select="key('testAssertionKey', ./@testAssertionRef)"/>
   <h5>
    <xsl:value-of select="$TestAssertion/etf:Label"/>
   </h5>

   <table class="AssertionMetadata">
    <tr class="ReportDetail">
     <td><xsl:value-of select="$lang/x:e[@key = 'TestAssertion']"/> ID</td>
     <td>
      <xsl:value-of select="$TestAssertion/@id"/>
     </td>
    </tr>
    <xsl:if test="./etf:Duration">
     <tr>
      <td>
       <xsl:value-of select="$lang/x:e[@key = 'Duration']"/>
      </td>
      <td>
       <xsl:value-of select="./etf:Duration"/> ms </td>
     </tr>
    </xsl:if>
    <tr>
     <td>
      <xsl:value-of select="$lang/x:e[@key = 'AssertionType']"/>
     </td>
     <td>
      <xsl:value-of select="$TestAssertion/etf:Type"/>
     </td>
    </tr>
   </table>


   <!-- Add SubRequirements -->

   <xsl:variable name="refReqId"
    select="$TestAssertion/etf:Properties/ii:Items/ii:Item[@name = 'RequirementReference']/ii:value/text()"/>
   <xsl:variable name="SubRequirement" select="key('requirementKey', $refReqId)"/>
   <xsl:variable name="AlternativeSubRequirement"
    select="key('alternativeSubRequirementKey', $refReqId)"/>

   <xsl:if test="normalize-space($refReqId)">
    <xsl:choose>
     <xsl:when test="$SubRequirement">
      <!-- <br/> -->
      <br/>
      <xsl:choose>
       <xsl:when test="./etf:ResultStatus = 'OK'">
        <table class="DoNotShowInSimpleView">
         <xsl:apply-templates select="$SubRequirement"/>
        </table>
       </xsl:when>
       <!-- Always show the requirements when the assertion has failed -->
       <xsl:otherwise>
        <table>
         <xsl:apply-templates select="$SubRequirement"/>
        </table>
       </xsl:otherwise>
      </xsl:choose>
      <!-- <br/> -->
      <br/>
     </xsl:when>
     <!-- TODO: refactor -->
     <xsl:when test="$AlternativeSubRequirement">
      <!-- <br/> -->
      <br/>
      <xsl:choose>
       <xsl:when test="./etf:ResultStatus = 'OK'">
        <table class="DoNotShowInSimpleView">
         <xsl:apply-templates select="$AlternativeSubRequirement"/>
        </table>
       </xsl:when>
       <!-- Always show the requirements when the assertion has failed -->
       <xsl:otherwise>
        <table>
         <xsl:apply-templates select="$AlternativeSubRequirement"/>
        </table>
       </xsl:otherwise>
      </xsl:choose>
<!-- <br/> -->
      <br/>
     </xsl:when>
     <xsl:otherwise>
      <b>Lookup of referenced requirement <xsl:value-of select="$refReqId"/> failed. This might be a
       defect in the test project.</b>
     </xsl:otherwise>
    </xsl:choose>
   </xsl:if>

   <div class="DoNotShowInSimpleView Expression">
    <xsl:if test="$TestAssertion/etf:Expression">
    <label for="{$id}.expression"><xsl:value-of select="$lang/x:e[@key = 'Expression']"/>:</label>
    <textarea id="{$id}.expression" class="Expression" data-mini="true">
     <xsl:value-of select="$TestAssertion/etf:Expression"/>
    </textarea>
    </xsl:if>
   </div>

   <xsl:if test="$TestAssertion/etf:ExpectedResult/text()">
    <div class="ReportDetail ExpectedResult">
     <label for="{$id}.expectedResult"><xsl:value-of select="$lang/x:e[@key = 'ExpectedResult']"
      />:</label>
     <textarea id="{$id}.expectedResult" class="ExpectedResult" data-mini="true">
      <xsl:value-of select="$TestAssertion/etf:ExpectedResult"/>
     </textarea>
    </div>
   </xsl:if>

   <xsl:if test="etf:Messages/*">
    <xsl:apply-templates select="etf:Messages"/>
   </xsl:if>
  </div>

 </xsl:template>

 <!-- Output short description or description from etf:description element or etf:properties -->
 <!-- ########################################################################################## -->
 <xsl:template name="descriptionItem">
  <xsl:param name="Node"/>

  <!--
   Show an etf:Property named ShortDescription if there is one
   and hide Description in simple view
  -->
  <!-- Get description from etf:Description or as etf:Property -->
  <xsl:variable name="descriptionText">
   <xsl:choose>
    <xsl:when test="$Node/etf:Description/text()">
     <xsl:value-of select="$Node/etf:Description/text()"/>
    </xsl:when>
    <xsl:when test="$Node/etf:Properties/ii:Items/ii:Item[@name = 'Description']/ii:value/text()">
     <xsl:value-of
      select="$Node/etf:Properties/ii:Items/ii:Item[@name = 'Description']/ii:value/text()"/>
    </xsl:when>
   </xsl:choose>
  </xsl:variable>
  <xsl:choose>
   <xsl:when
    test="$Node/etf:Properties/ii:Items/ii:Item[@name = 'ShortDescription']/ii:value/text()">
    <!-- Show etf:Property shortDescription -->
    <tr>
     <td>
      <xsl:value-of select="$lang/x:e[@key = 'ShortDescription']"/>
     </td>
     <td>
      <xsl:value-of
       select="$Node/etf:Properties/ii:Items/ii:Item[@name = 'ShortDescription']/ii:value/text()"/>
     </td>
    </tr>
    <!-- and hide etf:description in simple view -->
    <xsl:if test="normalize-space($descriptionText) != ''">
     <tr class="DoNotShowInSimpleView">
      <td>
       <xsl:value-of select="$lang/x:e[@key = 'Description']"/>
      </td>
      <td>
       <xsl:value-of select="$descriptionText"/>
      </td>
     </tr>
    </xsl:if>
   </xsl:when>
   <!-- else show description-->
   <xsl:when test="normalize-space($descriptionText) != ''">
    <tr>
     <td>
      <xsl:value-of select="$lang/x:e[@key = 'Description']"/>
     </td>
     <td>
      <xsl:value-of select="$descriptionText"/>
     </td>
    </tr>
   </xsl:when>
  </xsl:choose>

 </xsl:template>

 <!-- Item data information without label -->
 <!-- ########################################################################################## -->
 <xsl:template name="itemData">
  <xsl:param name="Node"/>

  <xsl:if test="$Node/etf:StartTimestamp/text()">
   <tr class="ReportDetail">
    <td>
     <xsl:value-of select="$lang/x:e[@key = 'Started']"/>
    </td>
    <td>
     <xsl:call-template name="formatDate">
      <xsl:with-param name="DateTime" select="$Node/etf:StartTimestamp"/>
     </xsl:call-template>
    </td>
   </tr>
  </xsl:if>

  <xsl:if test="$Node/etf:Duration/text()">
   <tr>
    <td>
     <xsl:value-of select="$lang/x:e[@key = 'Duration']"/>
    </td>
    <td>
     <xsl:value-of select="$Node/etf:Duration"/>
    </td>
   </tr>
  </xsl:if>

  <xsl:call-template name="descriptionItem">
   <xsl:with-param name="Node" select="$Node"/>
  </xsl:call-template>

  <!-- Version Data -->
  <xsl:if test="$Node/etf:VersionData/etf:Author/text()">
   <tr class="ReportDetail">
    <td>
     <xsl:value-of select="$lang/x:e[@key = 'Author']"/>
    </td>
    <td>
     <xsl:value-of select="$Node/etf:VersionData/etf:Author"/>
    </td>
   </tr>
  </xsl:if>
  <xsl:if test="$Node/etf:VersionData/etf:CreationDate/text()">
   <tr class="ReportDetail">
    <td>
     <xsl:value-of select="$lang/x:e[@key = 'DateCreated']"/>
    </td>
    <td>
     <xsl:call-template name="formatDate">
      <xsl:with-param name="DateTime" select="$Node/etf:VersionData/etf:CreationDate"/>
     </xsl:call-template>
    </td>
   </tr>
  </xsl:if>
  <xsl:if test="$Node/etf:VersionData/etf:Version/text()">
   <tr class="ReportDetail">
    <td>
     <xsl:value-of select="$lang/x:e[@key = 'Version']"/>
    </td>
    <td>
     <xsl:value-of select="$Node/etf:VersionData/etf:Version"/>
    </td>
   </tr>
  </xsl:if>
  <xsl:if test="$Node/etf:VersionData/etf:LastEditor/text()">
   <tr class="ReportDetail">
    <td>
     <xsl:value-of select="$lang/x:e[@key = 'LastEditor']"/>
    </td>
    <td>
     <xsl:value-of select="$Node/etf:VersionData/etf:LastEditor"/>
    </td>
   </tr>
  </xsl:if>
  <xsl:if test="$Node/etf:VersionData/etf:LastUpdateDate/text()">
   <tr class="DoNotShowInSimpleView">
    <td>
     <xsl:value-of select="$lang/x:e[@key = 'LastUpdated']"/>
    </td>
    <td>
     <xsl:call-template name="formatDate">
      <xsl:with-param name="DateTime" select="$Node/etf:VersionData/etf:LastUpdateDate"/>
     </xsl:call-template>
    </td>
   </tr>
  </xsl:if>
  <xsl:if test="$Node/etf:VersionData/etf:Hash/text()">
   <tr class="DoNotShowInSimpleView">
    <td>
     <xsl:value-of select="$lang/x:e[@key = 'Hash']"/>
    </td>
    <td>
     <xsl:value-of select="$Node/etf:VersionData/etf:Hash"/>
    </td>
   </tr>
  </xsl:if>

  <!-- filter Description properties and passwords -->
  <xsl:for-each select="$Node/etf:Properties/ii:Items/ii:Item">
   <xsl:if
    test="normalize-space(./ii:value/text()) and not(./@name = 'ShortDescription') and not(./@name = 'Description') and not(./@name = 'password') and not(./@name = 'authPwd') and not(./@name = 'pwd')">
    <!-- Get visbility class -->
    <xsl:variable name="visibilityClassLookup" select="key('propertyVisibility', ./@name)"/>
    <xsl:variable name="visibilityClass">
     <xsl:choose>
      <xsl:when test="$visibilityClassLookup">
       <xsl:value-of select="$visibilityClassLookup"/>
      </xsl:when>
      <xsl:otherwise>ReportDetail</xsl:otherwise>
     </xsl:choose>
    </xsl:variable>
    <tr class="{$visibilityClass}">
     <td>
      <xsl:apply-templates select="$lang">
       <xsl:with-param name="str" select="@name"/>
      </xsl:apply-templates>
     </td>
     <td>
      <xsl:value-of select="ii:value"/>
     </td>
    </tr>
   </xsl:if>
  </xsl:for-each>

 </xsl:template>

 <!-- Messages -->
 <!-- ########################################################################################## -->
 <xsl:template match="etf:Messages">
  <div class="FailureMessage">
   <xsl:choose>
    <xsl:when test="./etf:Message/@xsi:type = 'stringDataContainer'">
     <xsl:variable name="id" select="generate-id(.)"/>
     <label for="{$id}">
      <xsl:value-of select="$lang/x:e[@key = 'Messages']"/>
     </label>
     <textarea id="{$id}.failureMessages" data-mini="true">
      <xsl:for-each select="etf:Message">
       <xsl:call-template name="ChangeFailureMessage">
        <xsl:with-param name="FailureMessageText" select="text()"/>
       </xsl:call-template>
      </xsl:for-each>
     </textarea>
    </xsl:when>
    <xsl:when test="./etf:Message/@xsi:type = 'urlReferenceContainer'">
     <!--p>Stored failure messages:</p-->
     <xsl:apply-templates select="./Message[@xsi:type = 'urlReferenceContainer']"/>
    </xsl:when>
   </xsl:choose>
  </div>
 </xsl:template>

 <!-- ChangeFailureMessage -->
 <!-- ########################################################################################## -->
 <xsl:template name="ChangeFailureMessage">
  <xsl:param name="FailureMessageText"/>

  <!--
   By default the whole expression of a XQuery will be written out in error messages.
   In this template function the error message will be "beautified".
   To use this functionality the xquery shall be in the following form:
   <result>AssertionFailures:
   {
     XQUERY Functions
     if( xyz=FAILURE ) then return 'failure message foo bar... '
     else ''
   </result>
  -->
  <xsl:variable name="AssertionFailuresText">AssertionFailures:</xsl:variable>
  <xsl:variable name="BeautifiedMessage">
   <xsl:call-template name="substring-after-last">
    <xsl:with-param name="input" select="$FailureMessageText"/>
    <xsl:with-param name="substr" select="$AssertionFailuresText"/>
   </xsl:call-template>
  </xsl:variable>
  <xsl:variable name="BeautifiedXqueryOutput"
   select="substring-before($BeautifiedMessage, '&lt;/result')"/>

  <xsl:choose>
   <xsl:when test="normalize-space($BeautifiedXqueryOutput)">
    <xsl:value-of select="$BeautifiedXqueryOutput"/>
   </xsl:when>
   <xsl:otherwise>
    <xsl:value-of select="$FailureMessageText"/>
   </xsl:otherwise>
  </xsl:choose>

 </xsl:template>

 <!-- StrContainer -->
 <!-- ########################################################################################## -->
 <xsl:template match="*[@xsi:type = 'stringDataContainer']">
  <div class="Container StrContainer">
   <xsl:variable name="id" select="generate-id(.)"/>
   <label for="{$id}">
    <xsl:value-of select="./@name"/>: </label>
   <textarea id="{$id}" data-mini="true">
    <xsl:value-of select="normalize-space(./text())"/>
   </textarea>
  </div>
 </xsl:template>

 <!-- UrlReferenceContainer -->
 <!-- ########################################################################################## -->
 <xsl:template match="*[@xsi:type = 'urlReferenceContainer']">
  <!--fieldset class="Container UrlReferenceContainer">
   <legend><xsl:value-of select="./@name"/>:</legend>
   <xsl:variable name="referenceURL" select="@referenceURL"/>
   <a href="{$referenceURL}" data-ajax="false" target="_blank">Open <xsl:value-of select="./@name"/></a>
  </fieldset-->
  <div class="Container UrlReferenceContainer">
   <xsl:variable name="sizeMb">
    <xsl:if test="./@size > 16384"> (<xsl:value-of select="format-number(./@size div 1048576, '0.00')"/>
     MB) </xsl:if>
   </xsl:variable>
   <xsl:variable name="referenceURL" select="@referenceURL"/>
   <a href="{$referenceURL}" data-ajax="false" target="_blank">Open <xsl:value-of select="./@name"/>
    <xsl:if test="./@size > 16384"><xsl:value-of select="$sizeMb"/></xsl:if>
   </a>
  </div>
 </xsl:template>

 <!-- Requirement information -->
 <!-- ########################################################################################## -->
 <!--xsl:template match="/*[type='etf:suiRequirement']"-->
 <xsl:template match="/etf:TestReport/etf:Requirements/etf:Requirement">

  <tr>
   <td colspan="2" class="RequirementTH">Requirement <xsl:value-of select="./etf:Label"/>
   </td>
  </tr>

  <xsl:call-template name="descriptionItem">
   <xsl:with-param name="Node" select="."/>
  </xsl:call-template>

  <xsl:for-each select="./etf:Properties/ii:Items/ii:Item">
   <xsl:if
    test="normalize-space(./ii:value/text()) and not(./@name = 'ShortDescription') and not(./@name = 'Description')">
    <tr>
     <td>
      <xsl:apply-templates select="$lang">
       <xsl:with-param name="str" select="@name"/>
      </xsl:apply-templates>
     </td>
     <td>
      <xsl:value-of select="ii:value"/>
     </td>
    </tr>
   </xsl:if>
  </xsl:for-each>

 </xsl:template>

 <!-- Footer -->
 <!-- ########################################################################################## -->
 <xsl:template name="footer">
  <div data-role="footer">
   <h1>ETF � 2013-2015 interactive instruments</h1>
  </div>
  <xsl:call-template name="footerScripts"/>
 </xsl:template>

</xsl:stylesheet>
