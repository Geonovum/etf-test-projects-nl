(:
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
:)

declare namespace gml='http://www.opengis.net/gml/3.2';
declare namespace xsi='http://www.w3.org/2001/XMLSchema-instance';
declare namespace xlink='http://www.w3.org/1999/xlink';
declare namespace etf='http://www.interactive-instruments.de/etf/1.0';
declare namespace ii='http://www.interactive-instruments.de/ii/1.0';
declare namespace iso='http://purl.oclc.org/dsdl/schematron';
declare namespace xsl='http://www.w3.org/1999/XSL/Transform';
declare namespace map='http://www.w3.org/2005/xpath-functions/map';
declare namespace svrl='http://purl.oclc.org/dsdl/svrl';
declare namespace svrlii='http://www.interactive-instruments.de/svrl';

(:===========:)
(: FUNCTIONS :)
(:===========:)


declare function local:create-messages($failedAssertsOrReports as element()*, $svrlii as element(), $printExactLocationEvaluated as xs:boolean) as element() {
  
  let $idsOfFailedAssertsOrReports := distinct-values($failedAssertsOrReports/@id)
  let $resultsWithFailedAssertsOrReports := $svrlii/svrlii:result[exists(svrlii:activePattern/svrlii:firedRule/*[@id = $idsOfFailedAssertsOrReports])]
  let $fileErrors := count($resultsWithFailedAssertsOrReports)
  let $countElements := count($failedAssertsOrReports)
  let $messages := (
    if ($fileErrors>0) then concat('Files with errors: ',data($fileErrors),'.&#xa;&#xa;') else (),
    for $result in $resultsWithFailedAssertsOrReports
    let $resultFileName := $result/svrlii:fileName/text()
    order by $resultFileName
    return
      let $failedAssertsOrReportsForResult := $failedAssertsOrReports[../../../svrlii:fileName/text() eq $resultFileName]
      let $countElementsForResult := count($failedAssertsOrReportsForResult)
      let $zb := if ($countElementsForResult > $limitMessages) then ', for example' else ()
      return
        (concat('File ''',$resultFileName,''': ',data($countElementsForResult),' messages',
        if ($countElementsForResult > $limitMessages) then concat(' (only the first ',data($limitMessages),' messages are reported)') else (),':&#xa;&#xa;'),
        for $element in $failedAssertsOrReportsForResult[position() le $limitMessages]
          let $textNodes := $element/svrl:text//text()[not(normalize-space(.)='')]
          return
            (string-join($textNodes,' '),
             if ($printExactLocationEvaluated) then (' | location: ',data($element/@location)) else (),
             '&#xa;'
            )
         ,'&#xa;'
        )    
  )
  
  return
   if ($countElements > 0) then
     <etf:Messages><etf:Message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="stringDataContainer" name="Meldungen">{$messages}</etf:Message></etf:Messages>     
   else
     <etf:Messages xsi:nil='true'/>
};

declare function local:strippath($path as xs:string) as xs:string
{
  let $sep := file:dir-separator()
  return
  if (contains($path,$sep)) then
    local:strippath(substring-after($path,$sep))
  else
    replace($path,'\.[gGxX][mM][lL]','')
};

declare function local:validateSingleFile($file as document-node(), $sch as document-node(), $schAsXslt as document-node(), $xslSvrlFormatting1 as document-node(), $xslSvrlFormatting2 as document-node()) as element() {
  
  <svrlii:result>
  {
  let $filename := local:strippath(db:path($file))
  let $startTime := prof:current-ms()
  let $svrl := prof:time(xslt:transform($file,$schAsXslt),false(),concat('ISO Schematron XSL transformation - perform validation for file ',$filename,': '))
  let $tmp := xslt:transform($svrl,$xslSvrlFormatting1)
  let $result := xslt:transform($tmp,$xslSvrlFormatting2)
  let $endTime := prof:current-ms()
  let $validationDuration := $endTime - $startTime
  return
  (: gather active patterns, the fired rules (including their id and context) per pattern, and then the failed asserts or successful reports per rule (including their details - just copy the whole thing) :)
    (<svrlii:fileName>{$filename}</svrlii:fileName>,
    for $activePattern in $result/*/svrl:active-pattern
    order by $activePattern/@id
    return 
      <svrlii:activePattern id="{string($activePattern/@id)}">
      {
        let $idsOfFiredRulesOfPattern := distinct-values($activePattern/svrl:fired-rule/string(@id))
        for $firedRuleId in $idsOfFiredRulesOfPattern
        order by $firedRuleId
        return
          <svrlii:firedRule id="{$firedRuleId}">
          {
            for $failedAssertOrSuccessfulReportForRule in $activePattern/svrl:fired-rule[@id = data($firedRuleId)]/*
            return
              (: NOTE: these elements use the svrl namespace:)
              $failedAssertOrSuccessfulReportForRule
          }
          </svrlii:firedRule>
      }
      </svrlii:activePattern>
    ,
    <svrlii:duration>{$validationDuration}</svrlii:duration>)
  }
  </svrlii:result>
};

declare function local:validateAndCombineSvrl($dbs as document-node()*, $sch as document-node(), $schAsXslt as document-node(), $xslSvrlFormatting1 as document-node(), $xslSvrlFormatting2 as document-node()) as element() {

   <svrlii:SvrlResults>
   {
    let $startTime := prof:current-ms()
    let $svrlii :=
        for$file in $dbs
        return
          prof:time(local:validateSingleFile($file,$sch,$schAsXslt,$xslSvrlFormatting1,$xslSvrlFormatting2),false(),'Time to validate and format: ')
    let $endTime := prof:current-ms()
    let $validationDuration := $endTime - $startTime
    return
      ($svrlii,
      <svrlii:totalDuration>{$validationDuration}</svrlii:totalDuration>)
  }
  </svrlii:SvrlResults>    
};

(: 
  $svrlii -> the processed svrl result(s)
  $sch -> the schematron to check with (must not contain abstract patterns or rules; all patterns, rules, asserts and reports shall have a unique id attribute)
  $startTimeStamp -> the date and time when the validation process was started
:)
declare function local:evaluate($svrlii as element(), $sch as document-node(), $startTimeStamp as xs:dateTime, $printExactLocationEvaluated as xs:boolean) as element() {
  
<etf:TestReport id="{$reportId}" testObjectId="{$testObjectId}" version="0.4.0" generator="ETF-BaseX-SCH-XQ-0.0.2" finalized="true">
<etf:TestingTool>BaseX 7.9</etf:TestingTool>
<etf:StartTimestamp>{$startTimeStamp}</etf:StartTimestamp>
<etf:MachineName>{$Testsystem}</etf:MachineName>
<etf:Account>{$Tester}</etf:Account>
<etf:Label>{$reportLabel}</etf:Label>
<etf:TestRunProperties>
  <ii:Items>
    <ii:Item name="Files to test">
      <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">{$Files_to_test}</ii:value>
    </ii:Item>
    <ii:Item name="Maximum number of error messages per test">
      <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">{$Maximum_number_of_error_messages_per_test}</ii:value>
    </ii:Item>
  </ii:Items>
</etf:TestRunProperties>
<etf:Statistics/>
<etf:TestSuiteResults>
<etf:TestSuiteResult id="Schematron Validation">
  <etf:Duration>{$svrlii/svrlii:totalDuration/text()}</etf:Duration>
  <etf:Label>Schematron Validation</etf:Label>
  <etf:TestCaseResults>
  
    <etf:TestCaseResult id="Result.Etf.Internal" testCaseRef="Etf.Internal">
      <etf:ResultStatus>{if($validationErrors) then 'FAILED' else 'OK'}</etf:ResultStatus>
      <etf:TestStepResults>
        <etf:TestStepResult id="Result.Etf.Internal.Validation" testStepRef="Etf.Internal.Validation">
          <etf:ResultStatus>{if($validationErrors) then 'FAILED' else 'OK'}</etf:ResultStatus>
          <etf:Duration/>
          <etf:StartTimestamp/>
          <etf:Resource>Database: '{$dbBaseName}'; Files: '{$Files_to_test}';</etf:Resource>
          <etf:AssertionResults>
            <etf:AssertionResult id="Result.Etf.Internal.Validation.Xml" testAssertionRef="Etf.Internal.Validation.Xml">
            {
              if($validationErrors) then
                <etf:Messages>
                  <etf:Message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="stringDataContainer" name="Meldungen">{$validationErrors}</etf:Message>
                </etf:Messages>
              else
                <etf:Messages xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:nil="true"/>
            }
              <etf:Duration/>
              <etf:ResultStatus>{if($validationErrors) then 'FAILED' else 'OK'}</etf:ResultStatus>
            </etf:AssertionResult>
          </etf:AssertionResults>
        </etf:TestStepResult>
      </etf:TestStepResults>
    </etf:TestCaseResult>
{
           
    for $pattern in $sch/*/iso:pattern
      let $patternId := $pattern/@id
      let $occurrencesOfActivePattern := $svrlii/svrlii:result/svrlii:activePattern[@id = $patternId]
      let $patternWasActive := exists($occurrencesOfActivePattern)
      let $failedAssertExists := if($patternWasActive) then exists($occurrencesOfActivePattern/*/svrl:failed-assert) else false()
      let $successfulReportExists := if($patternWasActive) then exists($occurrencesOfActivePattern/*/svrl:successful-report) else false()
    return
    <etf:TestCaseResult id="{generate-id($pattern)}" testCaseRef="{data($patternId)}">
      <etf:ResultStatus>{if ($failedAssertExists) then 'FAILED' else if ($successfulReportExists) then 'WARNING' else if ($patternWasActive) then 'OK' else 'SKIPPED'}</etf:ResultStatus>
      <etf:TestStepResults>
      {
        for $rule in $pattern/iso:rule
        let $ruleId := $rule/@id
        let $occurrencesOfFiredRule := $occurrencesOfActivePattern/svrlii:firedRule[@id = $ruleId]
        let $ruleFired := if ($patternWasActive) then exists($occurrencesOfFiredRule) else false()        
        let $failedAssertExistsInRule := if($ruleFired) then exists($occurrencesOfFiredRule/svrl:failed-assert) else false()
        let $successfulReportExistsInRule := if($ruleFired) then exists($occurrencesOfFiredRule/svrl:successful-report) else false()
        return
        <etf:TestStepResult id="Result.{$patternId}.{$ruleId}" testStepRef="{$patternId}.{$ruleId}">
          <etf:ResultStatus>{if ($failedAssertExistsInRule) then 'FAILED' else if ($successfulReportExistsInRule) then 'WARNING' else if ($ruleFired) then 'OK' else 'SKIPPED'}</etf:ResultStatus>
          <etf:Duration/>
          <etf:StartTimestamp/>
          <etf:Resource>Database: '{$dbBaseName}'; Files: '{$Files_to_test}';</etf:Resource>
          <etf:AssertionResults>
          {
            for $assert in $rule/iso:assert
              let $assertId := $assert/@id
              let $failedAsserts := $occurrencesOfFiredRule/svrl:failed-assert[@id = $assertId]
              return
               <etf:AssertionResult id="Result.{$patternId}.{$ruleId}.{$assertId}" testAssertionRef="{$patternId}.{$ruleId}.{$assertId}">
                  {local:create-messages($failedAsserts,$svrlii,$printExactLocationEvaluated)}
                 <etf:Duration/>
                 <etf:ResultStatus>{if ($failedAsserts) then 'FAILED' else 'OK'}</etf:ResultStatus>
               </etf:AssertionResult>
          }
           {
            for $report in $rule/iso:report
              let $reportId := $report/@id
              let $successfulReports := $occurrencesOfFiredRule/svrl:successful-report[@id = $reportId]
              return
               <etf:AssertionResult id="Result.{$patternId}.{$ruleId}.{$reportId}" testAssertionRef="{$patternId}.{$ruleId}.{$reportId}">
                  {local:create-messages($successfulReports,$svrlii,$printExactLocationEvaluated)}
                 <etf:Duration/>
                 <etf:ResultStatus>OK</etf:ResultStatus>
               </etf:AssertionResult>
          }
          </etf:AssertionResults>
          </etf:TestStepResult>
      }
      </etf:TestStepResults>
    </etf:TestCaseResult> 

}
    </etf:TestCaseResults>
  </etf:TestSuiteResult>
</etf:TestSuiteResults>

<etf:TestCases>

  <etf:TestCase id="Etf.Internal">
    <etf:Label>ETF standard checks</etf:Label>
    <etf:Description>Standard checks performed by ETF</etf:Description>
    <etf:VersionData>
      <etf:Version>0.1</etf:Version>
      <etf:CreationDate>2016-01-22T17:00:00+0100</etf:CreationDate>
      <etf:LastUpdateDate>2016-01-22T17:00:00+0100</etf:LastUpdateDate>
      <etf:Hash/>
      <etf:Author>interactive instruments GmbH</etf:Author>
      <etf:LastEditor>Johannes Echterhoff</etf:LastEditor>
    </etf:VersionData>
    <etf:AssociatedRequirements>
      <etf:Requirement>ETF</etf:Requirement>
    </etf:AssociatedRequirements>
    <etf:Properties>
      <ii:Items xmlns:ii="http://www.interactive-instruments.de/ii/1.0">
        <ii:Item name="ShortDescription">
          <ii:value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xsi:type="xs:string">Standard checks</ii:value>
        </ii:Item>
        <ii:Item name="Reference">
          <ii:value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xsi:type="xs:string">Standard ETF behavior</ii:value>
        </ii:Item>
      </ii:Items>
    </etf:Properties>
    <etf:TestSteps>
      <etf:TestStep id="Etf.Internal.Validation">
        <etf:Label>Validation</etf:Label>
        <etf:Description/>
        <etf:Assertions>
          <etf:Assertion id="Etf.Internal.Validation.Xml">
            <etf:Label>XML Validation</etf:Label>
            <etf:Properties>
              <ii:Items xmlns:ii="http://www.interactive-instruments.de/ii/1.0">
                <ii:Item name="RequirementReference">
                  <ii:value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xsi:type="xs:string">ETF#Etf.Internal.Validation.Xml</ii:value>
                </ii:Item>
              </ii:Items>
            </etf:Properties>
            <etf:Type>ETF internal XML processing</etf:Type>
            <etf:Expression/>
            <etf:Status>IMPLEMENTED</etf:Status>
          </etf:Assertion>
        </etf:Assertions>
      </etf:TestStep>
    </etf:TestSteps>
    <etf:status>IMPLEMENTED</etf:status>
  </etf:TestCase>

{
   for $pattern in $sch/*/iso:pattern
      let $patternId := $pattern/@id
      return
      <etf:TestCase id="{$patternId}">
          <etf:Label>{if ($pattern/iso:title) then data($pattern/iso:title) else data($patternId)}</etf:Label>
          <etf:Description/>
          <etf:VersionData/>
      <etf:AssociatedRequirements>
        <etf:Requirement>{$requirementsId}</etf:Requirement>
      </etf:AssociatedRequirements>
      <etf:Properties/>
      <etf:TestSteps>
      {
        for $rule in $pattern/iso:rule
          let $ruleId := $rule/@id        
          return
          <etf:TestStep id="{$patternId}.{$ruleId}">
          <etf:Label>{data($ruleId)}</etf:Label>
          <etf:Description/>
          <etf:Assertions>
          {
            for $assert in $rule/iso:assert
              let $assertId := $assert/@id            
              return
              <etf:Assertion id="{$patternId}.{$ruleId}.{$assertId}">
              <etf:Label>{data($assertId)}</etf:Label>
              <etf:Properties>
                <ii:Items>
                 <ii:Item name="RequirementReference">
                  <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   >{$requirementsId}#{string($assertId)}</ii:value>
                 </ii:Item>
                </ii:Items>
              </etf:Properties>
              <etf:Type>Schematron assertion</etf:Type>
              <etf:Expression>see schematron file</etf:Expression>
              <etf:Status>IMPLEMENTED</etf:Status>
              </etf:Assertion>
          }
          {
            for $report in $rule/iso:report
              let $reportId := $report/@id            
              return
              <etf:Assertion id="{$patternId}.{$ruleId}.{$reportId}">
              <etf:Label>{data($reportId)}</etf:Label>
              <etf:Properties>
                <ii:Items>
                 <ii:Item name="RequirementReference">
                  <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                   xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
                   >{$requirementsId}#{string($reportId)}</ii:value>
                 </ii:Item>
                </ii:Items>
              </etf:Properties>
              <etf:Type>Schematron report</etf:Type>
              <etf:Expression/>
              <etf:Status>IMPLEMENTED</etf:Status>
              </etf:Assertion>
          }
          </etf:Assertions>
          </etf:TestStep>
      }
      </etf:TestSteps>
      <etf:status>IMPLEMENTED</etf:status>
      </etf:TestCase>
}
</etf:TestCases>
<etf:Requirements>
  <etf:Requirement id="ETF">
    <etf:Label>ETF</etf:Label>
    <etf:Description/>
    <etf:Properties>
        <ii:Items>
            <ii:Item name="SpecificationReference">
                <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">Standard ETF behavior</ii:value>
            </ii:Item>
        </ii:Items>
    </etf:Properties>
    <etf:SubRequirements>
      <etf:Requirement>ETF#Etf.Internal.Validation.Xml</etf:Requirement>
    </etf:SubRequirements>
  </etf:Requirement>
  <etf:Requirement id="ETF#Etf.Internal.Validation.Xml">
    <etf:VersionData/>
    <etf:Label>ETF#Etf.Internal.Validation.Xml</etf:Label>
    <etf:Properties>
      <ii:Items xmlns:ii="http://www.interactive-instruments.de/ii/1.0">
        <ii:Item name="Name">
          <ii:value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xsi:type="xs:string">XML Validation</ii:value>
        </ii:Item>
        <ii:Item name="ShortDescription">
          <ii:value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xsi:type="xs:string">XML must be well-formed and - if so configured - XML Schema compliant</ii:value>
        </ii:Item>
        <ii:Item name="Description">
          <ii:value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xsi:type="xs:string">The well-formedness and - if configured for this test project - compliance with the XML Schema of all files is checked.</ii:value>
        </ii:Item>
        <ii:Item name="Reference">
          <ii:value xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xs="http://www.w3.org/2001/XMLSchema" xsi:type="xs:string">Standard ETF behavior</ii:value>
        </ii:Item>
      </ii:Items>
    </etf:Properties>
    <etf:SubRequirements/>
  </etf:Requirement>
  <etf:Requirement id="{$requirementsId}">
  <etf:Label>{$requirementsId}</etf:Label>
  <etf:Description/>
  <etf:Properties>
      <ii:Items>
          <ii:Item name="SpecificationReference">
              <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">Not available</ii:value>
          </ii:Item>
      </ii:Items>
  </etf:Properties>
  <etf:SubRequirements>    
  {
    for $assertOrReport in $sch//*[local-name() = 'assert' or local-name() = 'report']
      return
        <etf:Requirement>{$requirementsId}#{string($assertOrReport/@id)}</etf:Requirement>            
  }
  </etf:SubRequirements>
  </etf:Requirement>  
  {
     for $assertOrReport in $sch//*[local-name() = 'assert' or local-name() = 'report']
       let $assertOrReportId := string($assertOrReport/@id)
      return
              
      <etf:Requirement id="{$requirementsId}#{$assertOrReportId}">
        <etf:VersionData/>
        <etf:Label>{$assertOrReportId}</etf:Label>      
        <etf:Properties>
            <ii:Items>
              <ii:Item name="Name">
              <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">Not available</ii:value>
             </ii:Item>
             <ii:Item name="ShortDescription">
                <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">Not available</ii:value>
             </ii:Item>
             <ii:Item name="Description">
              <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
               xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">Not available</ii:value>
             </ii:Item>
                <ii:Item name="Reference">
                    <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                        xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">Not available</ii:value>
                </ii:Item>
            </ii:Items>
        </etf:Properties>
        <etf:SubRequirements/>
      </etf:Requirement>
  }
</etf:Requirements>
<etf:Duration>{$svrlii/svrlii:totalDuration/text()}</etf:Duration>
</etf:TestReport>
};


(:===========================:)
(: Parameters as strings :)
(:===========================:)

declare variable $Files_to_test external := ".*";
(: ggfs. durch Auswahl der Schematron-Phase ersetzen declare variable $Tests_to_perform external := ".*"; :)
declare variable $Maximum_number_of_error_messages_per_test external := "100";
declare variable $Testsystem external := "unknown";
declare variable $Tester external := "unknown";

declare variable $printExactLocation external := "true"; (: if set to true - ignoring case and leading or trailing whitespace - the XPath of the element that caused an assertion to fail or a report to be generated will be included in messages:)


(:===========================:)
(: Default ETF parameters :)
(:===========================:)
declare variable $projDir external;
declare variable $outputFile external;

declare variable $dbBaseName external;
declare variable $dbCount external;
declare variable $dbDir external;

declare variable $reportLabel external;
declare variable $reportStartTimestamp external;
declare variable $reportId external;
declare variable $testObjectId external;
declare variable $validationErrors external;

(:=============================:)
(: Other variable declarations :)
(:=============================:)

declare variable $requirementsId := "SCHEMATRON";

declare variable $limitMessages := xs:int( $Maximum_number_of_error_messages_per_test );
(: we cannot limit the number of identified errors in Schematron processing - declare variable $limitErrors :=1000; :)
declare variable $paramerror := xs:QName("etf:ParameterError");

declare variable $count :=
try { xs:int($dbCount - 1)
} catch * {
error($paramerror,concat("System error: parameter $dbCount must be an integer. Found '",data($dbCount),"'. Please contact the administrator.&#xa;"))
};

(:===========================:)
(: Parameter checks :)
(:===========================:)

if ($count ge 0) then () else error($paramerror,concat("System error: parameter $dbCount must be a positive integer. Found '",data($dbCount),"'&#xa;")),

try { let $x := matches('any.valid.regex',$Files_to_test) 
return ()
} catch * {
error($paramerror,concat("The value of parameter $Files_to_test must be a valid regular expression. Given value was '",data($Files_to_test),"', which leads to the following application error:&#xa; '",data($err:description),"'&#xa;"))
},

try { let $x := xs:int($Maximum_number_of_error_messages_per_test)
return ()
} catch * {
error($paramerror,concat("The parameter $Maximum_number_of_error_messages_per_test must be an integer. Found '",data($Maximum_number_of_error_messages_per_test),"'&#xa;"))
},

if (file:exists($projDir)) then if (file:is-dir($projDir)) then () else error($paramerror,concat("System error: parameter $projDir must be a valid directory. Found '",data($projDir),"'&#xa;")) else error($paramerror,concat("parameter $projDir must be an existing directory. Found '",data($projDir),"'. Please contact the administrator.&#xa;")),

if (file:exists($outputFile)) then if (file:is-file($outputFile)) then () else error($paramerror,concat("System error: parameter $outputFile points to an existing directory, not a file. Found '",data($outputFile),"'. Please contact the administrator.&#xa;")) else (),

for $i in 0 to $count return if (db:exists($dbBaseName || '-' || $i)) then () else error($paramerror,concat("System error: the database '",concat($dbBaseName,"-",$i),"' was not found. Please contact the administrator.&#xa;")),


let $printExactLocationEvaluated := if(matches($printExactLocation,"\s*[Tt][Rr][Uu][Ee]\s*")) then true() else false()

let $schFile := concat($projDir, file:dir-separator(),"schematron.sch")

let $xslIsoDsdlIncludeFile := concat($projDir, file:dir-separator(), "iso-schematron-xslt1", file:dir-separator(),"iso_dsdl_include.xsl")
let $xslIsoAbstractExpandFile := concat($projDir, file:dir-separator(), "iso-schematron-xslt1", file:dir-separator(), "iso_abstract_expand.xsl")

let $xslIIAbstractRuleExpandFile := concat($projDir, file:dir-separator(), "iso-schematron-xslt1", file:dir-separator(), "ii_abstract_rule_expand.xsl")
let $xslIdsForPatternsRulesAssertsFile := concat($projDir, file:dir-separator(), "iso-schematron-xslt1", file:dir-separator(), "ii_ids_for_patterns_and_rules.xsl")

let $xslSvrlForXsltFile := concat($projDir, file:dir-separator(), "iso-schematron-xslt1", file:dir-separator(), "iso_svrl_for_xslt1.xsl")

let $xslSvrlFormatting1File := concat($projDir, file:dir-separator(), "iso-schematron-xslt1", file:dir-separator(), "ii_svrl_formatting_1.xsl")
let $xslSvrlFormatting2File := concat($projDir, file:dir-separator(), "iso-schematron-xslt1", file:dir-separator(), "ii_svrl_formatting_2.xsl")

let $sch :=
try{
	doc($schFile)/iso:schema
} catch * {
	error($paramerror,concat("System error: the file with Schematron assertions '",data($schFile),"' was not found. Please contact the administrator.&#xa;"))
}

let $xslIsoDsdlInclude :=
try{
	doc($xslIsoDsdlIncludeFile)
} catch * {
	error($paramerror,concat("System error: the file with the XSL transformation to resolve includes '",data($xslIsoDsdlIncludeFile),"' was not found. Please contact the administrator.&#xa;"))
}

let $xslIsoAbstractExpand :=
try{
	doc($xslIsoAbstractExpandFile)
} catch * {
	error($paramerror,concat("System error: the file with the XSL transformation to expand abstract patterns '",data($xslIsoAbstractExpandFile),"' was not found. Please contact the administrator.&#xa;"))
}

let $xslIIAbstractRuleExpand :=
try{
	doc($xslIIAbstractRuleExpandFile)
} catch * {
	error($paramerror,concat("System error: the file with the XSL transformation to expand abstract rules '",data($xslIIAbstractRuleExpandFile),"' was not found. Please contact the administrator.&#xa;"))
}

let $xslIdsForPatternsRulesAsserts :=
try{
	doc($xslIdsForPatternsRulesAssertsFile)
} catch * {
	error($paramerror,concat("System error: the file with the XSL transformation to create ids for patterns, rules, asserts and reports '",data($xslIdsForPatternsRulesAssertsFile),"' was not found. Please contact the administrator.&#xa;"))
}

let $xslSvrlForXslt :=
try{
	doc($xslSvrlForXsltFile)
} catch * {
	error($paramerror,concat("System error: the file with the XSL transformation to derive the validation stylesheet '",data($xslSvrlForXsltFile),"' was not found. Please contact the administrator.&#xa;"))
}

let $xslSvrlFormatting1 :=
try{
	doc($xslSvrlFormatting1File)
} catch * {
	error($paramerror,concat("System error: the file with the first XSL transformation to format the SVRL output '",data($xslSvrlFormatting1File),"' was not found. Please contact the administrator.&#xa;"))
}

let $xslSvrlFormatting2 :=
try{
	doc($xslSvrlFormatting2File)
} catch * {
	error($paramerror,concat("System error: the file with the first XSL transformation to format the SVRL output '",data($xslSvrlFormatting2File),"' was not found. Please contact the administrator.&#xa;"))
}

(:===========================:)
(: Preprocessing using XSLTs :)
(:===========================:)
let $sch1 := prof:time(xslt:transform($sch,$xslIsoDsdlInclude),false(),'ISO Schematron XSL transformation - resolve includes: ')
let $sch2 := prof:time(xslt:transform($sch1,$xslIsoAbstractExpand),false(),'ISO Schematron XSL transformation - expand abstract patterns: ')

let $sch2.1 := prof:time(xslt:transform($sch2,$xslIIAbstractRuleExpand),false(),'ISO Schematron XSL transformation(ii) - expand abstract rules: ')
let $sch2.2 := prof:time(xslt:transform($sch2.1,$xslIdsForPatternsRulesAsserts),false(),'ISO Schematron XSL transformation(ii) - create ids for patterns, rules, asserts and reports: ')

let $schAsXslt := prof:time(xslt:transform($sch2.2,$xslSvrlForXslt),false(),'ISO Schematron XSL transformation - derive validation stylesheet: ')

(:===========================:)
(: Processing :)
(:===========================:)
let $db := for $i in 0 to $count return db:open($dbBaseName || '-' || $i)[matches(db:path(.),$Files_to_test)]
let $startTimeStamp := fn:current-dateTime()
let $svrlii := local:validateAndCombineSvrl($db,$sch2.2,$schAsXslt,$xslSvrlFormatting1,$xslSvrlFormatting2)
let $res := prof:time(local:evaluate($svrlii,$sch2.2,$startTimeStamp,$printExactLocationEvaluated), false(), 'Time to evaluate: ')
let $dummy := file:write($outputFile,$res)
return ($res)
