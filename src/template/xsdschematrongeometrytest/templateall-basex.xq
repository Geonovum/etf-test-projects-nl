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

declare namespace gml='http://www.opengis.net/gml';
declare namespace gml32='http://www.opengis.net/gml/3.2';
declare namespace xsi='http://www.w3.org/2001/XMLSchema-instance';
declare namespace xlink='http://www.w3.org/1999/xlink';
declare namespace etf='http://www.interactive-instruments.de/etf/1.0';
declare namespace ii='http://www.interactive-instruments.de/ii/1.0';
declare namespace iso='http://purl.oclc.org/dsdl/schematron';
declare namespace xsl='http://www.w3.org/1999/XSL/Transform';
declare namespace map='http://www.w3.org/2005/xpath-functions/map';
declare namespace svrl='http://purl.oclc.org/dsdl/svrl';
declare namespace svrlii='http://www.interactive-instruments.de/svrl';
declare namespace wfs='http://www.opengis.net/wfs/2.0';
declare namespace imgeo='http://www.geostandaarden.nl/imgeo/2.1';
declare namespace stufimgeo='http://www.geostandaarden.nl/imgeo/2.1/stuf-imgeo/1.3';
declare namespace skos='http://www.w3.org/2004/02/skos/core#';
declare namespace rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#';
declare namespace cit='http://www.opengis.net/citygml/2.0';

(:===========:)
(: FUNCTIONS :)
(:===========:)

(:===========:)
(: GEOMETRY  :)
(:===========:)
declare function local:disabled($id as xs:string, $enabled as xs:string) as xs:string?
{
   if ($enabled='false') then "deactivated"
   else ()
};


declare function local:execute($db as document-node()*, $nam as xs:string, $features as element()*, $query as xs:string, $disabled as xs:string?, $severity as xs:string?, $mode as xs:string?) as element()
{
let $start := prof:current-ms()
return
<etf:AssertionResult id="Result.{$nam}" testAssertionRef="{$nam}">
{
if ($disabled)
then
  (<etf:ResultStatus>SKIPPED</etf:ResultStatus>,
   <etf:Duration>{prof:current-ms()-$start}</etf:Duration>,
   <etf:Messages xsi:nil="true"/>)
else
  local:execquery($db, $features, $query, $severity, $mode, $start)
}
</etf:AssertionResult>
};


declare function local:finalMessage($errorCount as xs:integer) as xs:string?
{
  if ($errorCount>=$limitErrors) then '... and many additional messages&#xa;'
  else if ($errorCount>$limitMessages) then concat('... and additional ',data($errorCount)-data($limitMessages),' messages&#xa;')
  else ()
};


declare function local:execquery($db as document-node()*, $features as element()*, $query as xs:string, $severity as xs:string?, $mode as xs:string?, $start as xs:integer) as element()*
{
let $declarationsLocal := concat("declare namespace cit='http://www.opengis.net/citygml/2.0'; declare namespace imgeo='http://www.geostandaarden.nl/imgeo/2.1'; declare namespace skos='http://www.w3.org/2004/02/skos/core#'; declare namespace rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'; declare namespace gml='http://www.opengis.net/gml'; declare namespace xsi='http://www.w3.org/2001/XMLSchema-instance'; declare namespace xlink='http://www.w3.org/1999/xlink'; declare namespace wfs='http://www.opengis.net/wfs/2.0'; declare namespace gml32='http://www.opengis.net/gml/3.2'; declare namespace stufimgeo='http://www.geostandaarden.nl/imgeo/2.1/stuf-imgeo/1.3'; import module namespace functx = 'http://www.functx.com';
import module namespace ggeo='de.interactive_instruments.etf.bsxm.GmlGeoX'; declare variable $file external; declare variable $features external; declare variable $filename external; declare variable $projDir external; declare variable $limitErrors external := ", data($limitErrors), ";
declare function local:checkgeometry($feature as element()*, $mask as xs:string?) as xs:string?
{
  let $check := ggeo:validate($feature,$mask)
  return $check
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
declare function local:statistics-info($featuresWithErrors as element()*) as element()*
{
if ($featuresWithErrors) then
 <Message type='info' file='{data($filename)}' errors='{count($featuresWithErrors)}'/>
else ()
};
declare function local:type($feature as element()) as xs:string?
{
$feature/local-name()
};
declare function local:object-message($feature as element(), $text as xs:string) as element()
{
let $ohneid := '(no ID)'
return <Message type='obj' file='{data($filename)}' obj='{local:type($feature)}' oid='{if ($feature/@gml:id) then data($feature/@gml:id) else if ($feature/@gml32:id) then data($feature/@gml32:id) else data($ohneid)}' text='{data($text)}'/>
};
declare function local:object-messages($features as element()*, $text as xs:string) as element()*
{
for $feature in $features
 order by $feature/@gml:id
 return local:object-message($feature, $text)
};
declare function local:file-message($text as xs:string) as element()
{
<Message type='file' file='{data($filename)}' text='{data($text)}'/>
};")


let $declarationsGlobal := concat("declare namespace cit='http://www.opengis.net/citygml/2.0'; declare namespace imgeo='http://www.geostandaarden.nl/imgeo/2.1'; declare namespace skos='http://www.w3.org/2004/02/skos/core#'; declare namespace rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'; declare namespace gml='http://www.opengis.net/gml'; declare namespace gml32='http://www.opengis.net/gml/3.2'; declare namespace wfs='http://www.opengis.net/wfs/2.0'; declare namespace stufimgeo='http://www.geostandaarden.nl/imgeo/2.1/stuf-imgeo/1.3'; declare namespace xsi='http://www.w3.org/2001/XMLSchema-instance'; declare namespace xlink='http://www.w3.org/1999/xlink'; import module namespace functx = 'http://www.functx.com'; import module namespace ggeo='de.interactive_instruments.etf.bsxm.GmlGeoX'; declare variable $validationErrors external; declare variable $file external; declare variable $features external; declare variable $projDir external; declare variable $db external; declare variable $limitErrors external := ", data($limitErrors), ";
declare function local:checkgeometry($feature as element()*, $mask as xs:string?) as xs:string?
{
  let $check := ggeo:validate($feature,$mask)
  return $check
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
declare function local:statistics-info($featuresWithErrors as element()*) as element()*
{
if ($featuresWithErrors) then
 for $feature in $featuresWithErrors
  group by $filename := local:strippath(db:path($feature))
  order by $filename
  return
   <Message type='info' file='{data($filename)}' errors='{count($feature)}'/>
else ()
};
declare function local:file($feature as element()) as xs:string
{
local:strippath(db:path($feature))
};
declare function local:type($feature as element()) as xs:string?
{
$feature/local-name()
};
declare function local:object-message($feature as element(), $text as xs:string) as element()
{
let $ohneid := '(no ID)'
return <Message type='obj' file='{local:file($feature)}' obj='{local:type($feature)}' oid='{if ($feature/@gml:id) then data($feature/@gml:id) else if ($feature/@gml32:id) then data($feature/@gml32:id) else data($ohneid)}' text='{data($text)}'/>
};
declare function local:object-messages($features as element()*, $text as xs:string) as element()*
{
for $feature in $features
 order by $feature/@gml:id
 return local:object-message($feature, $text)
};
declare function local:file-message($file as element(), $text as xs:string) as element()
{
<Message type='file2' file='{local:file($file)}' text='{data($text)}'/>
};
declare function local:file-messages($files as element()*, $text as xs:string) as element()*
{
for $file in $files
 order by local:file($file)
 return local:file-message($file, $text)
};
declare function local:global-message($text as xs:string) as element()
{
<Message type='global' text='{data($text)}'/>
};")

let $result :=
	if ($mode eq 'global') then
		xquery:eval(concat($declarationsGlobal,$query), map {'features' := $features, 'validationErrors' := $validationErrors, 'db' := $db, 'projDir' := $projDir })
	else
		(for $file in $db return xquery:eval(concat($declarationsLocal,$query), map {'file' := $file, 'features' := $file//cit:cityObjectMember/*, 'filename' := local:strippath(db:path($file)), 'projDir' := $projDir}))[position() le 2*$limitErrors]

let $objectErrors := count($result[@type=('obj','file')])
let $fileErrors := count($result[@type='file2'])

let $messages :=
 (for $m in $result[@type='global']
  	return concat(data($m/@text),'&#xa;'),
  if ($fileErrors>=$limitErrors) then concat('Too many errors, only showing the first ',data($fileErrors),' errors and the first ',data($limitMessages),' messages.&#xa;&#xa;') else if ($fileErrors>0) then concat('Files with errors: ',data($fileErrors),'.&#xa;&#xa;') else (),
  for $m in $result[@type='file2'][position() le $limitMessages]
  	order by $m/@file
  	return
    concat('File ''',data($m/@file),''': ',data($m/@text),'&#xa;'),
  local:finalMessage($fileErrors),
  if ($objectErrors>=$limitErrors) then concat('Too many errors, only showing the first ',data($objectErrors),' errors and the first ',data($limitMessages),' messages.&#xa;&#xa;') else if ($objectErrors>0) then concat('Features with errors: ',data($objectErrors),'.&#xa;&#xa;') else (),
  for $m in $result[@type=('obj','file')][position() le $limitMessages]
  	group by $file := $m/@file
  	order by $file
  	return
  		(let $info := $result[@type eq 'info' and @file eq $file]
       let $zb := if (xs:int($info/@errors)>count($m)) then ', e.g.' else ()
  		 return concat('File ''',data($info/@file),''': ',data($info/@errors),' feature(s) with errors',data($zb),':&#xa;'),
 		 for $err in $m[@type='obj']
 		 return concat(data($err/@obj),' ''',data($err/@oid),''': ',data($err/@text),'&#xa;'),
 		 for $err in $m[@type='file']
 		 return concat('Without feature context: ',data($err/@text),'&#xa;'),
 		 '&#xa;'),
  local:finalMessage($objectErrors))

return
 if (count($messages)>0) then
   (<etf:Messages><etf:Message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:type="stringDataContainer" name="Meldungen">{$messages}</etf:Message></etf:Messages>,
    <etf:Duration>{prof:current-ms()-$start}</etf:Duration>,
    if ($severity='warning') then <etf:ResultStatus>WARNING</etf:ResultStatus> else <etf:ResultStatus>FAILED</etf:ResultStatus>)
 else
   (<etf:Messages xsi:nil='true'/>,
    <etf:Duration>{prof:current-ms()-$start}</etf:Duration>,
    <etf:ResultStatus>OK</etf:ResultStatus>)
};


declare function local:test-step($id as xs:string, $nam as xs:string, $def as element()*) as element()
{
<etf:TestStep id="{$id}">
<etf:Label>{$nam}</etf:Label>
<etf:Description></etf:Description>
<etf:Assertions>
{
  for $assertion in $def[starts-with(@id,concat($id,'.'))]
  let $nam := data($assertion/@id)
  let $disabled := local:disabled($assertion/@id, $assertion/@enabled)
  return
<etf:Assertion id="{$nam}">
<etf:Label>{concat($nam,': ', $assertion/name/text(), if ($disabled) then concat(' (inactive - ',$disabled,')') else ())}</etf:Label>
       <etf:Properties>
        <ii:Items>
         <ii:Item name="RequirementReference">
          <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
           xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
           >Req.{string($assertion/@id)}</ii:value>
         </ii:Item>
        </ii:Items>
       </etf:Properties>
       <etf:Type>XQuery</etf:Type>
<etf:Expression>{$assertion/expression/text()}</etf:Expression>
<etf:Status>{if ($disabled) then 'DEACTIVATED' else 'IMPLEMENTED'}</etf:Status>
</etf:Assertion>
}
</etf:Assertions>
</etf:TestStep>
};

declare function local:test-step-results($id as xs:string, $assertion-results as element()*, $duration as xs:integer) as element()
{
<etf:TestStepResult id="Result.{$id}" testStepRef="{$id}">
<etf:ResultStatus>{if ($assertion-results[etf:ResultStatus='FAILED']) then 'FAILED' else if ($assertion-results[etf:ResultStatus='WARNING']) then 'WARNING' else if ($assertion-results[etf:ResultStatus='OK']) then 'OK' else if ($assertion-results[etf:ResultStatus='INFO']) then 'INFO' else 'SKIPPED'}</etf:ResultStatus>
<etf:Duration>{$duration}</etf:Duration>
<etf:StartTimestamp>{fn:current-dateTime()}</etf:StartTimestamp>
<etf:Resource>database: '{$dbBaseName}'; files: '{$Files_to_test}'</etf:Resource>
<etf:AssertionResults>
{
  $assertion-results
}
</etf:AssertionResults>
</etf:TestStepResult>
};


declare function local:requirement($assertion as element()) as element()
{
<etf:Requirement id="Req.{$assertion/@id}">
<etf:VersionData/>
<etf:Label>IMGeo#{string($assertion/@id)}</etf:Label>
<etf:Properties>
    <ii:Items>
      <ii:Item name="Name">
      <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">{$assertion/name/text()}</ii:value>
     </ii:Item>
     <ii:Item name="ShortDescription">
        <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">{$assertion/shortDescription/text()}</ii:value>
     </ii:Item>
     <ii:Item name="Description">
      <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">{$assertion/description/text()}</ii:value>
     </ii:Item>
        <ii:Item name="Reference">
            <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">{$assertion/specReference/text()}</ii:value>
        </ii:Item>
    </ii:Items>
</etf:Properties>
<etf:SubRequirements/>
</etf:Requirement>
};

declare function local:ref_header() as element()
{
	<tr><th>File</th><th>Feature type</th><th>Count</th></tr>
};


declare function local:statistics_row($ft as xs:string, $count as xs:integer, $file as xs:string) as element()
{
	<tr><td>{$file}</td><td>{$ft}</td><td>{$count}</td></tr>
};

(: ===
declare function local:strippath($path as xs:string) as xs:string
{
  let $sep := file:dir-separator()
  return
  if (contains($path,$sep)) then
    local:strippath(substring-after($path,$sep))
  else
    replace($path,'\.[gGxX][mM][lL]','')
};

== duplicate declaration === :)


declare function local:file($node as node()) as xs:string
{
  local:strippath(db:path($node))
};

declare function local:statistics($db as document-node()*, $features as element()*) as element()*
{
  let $start := prof:current-ms()
  return
  (<p>Tested files: {count($db)}</p>,
   <table>
    <caption>Features</caption>
    { local:ref_header() }
    { local:statistics_row('All types',count($features),'All files') }
    { for $file in $db
    order by local:file($file)
    return
    	for $feature in $file//cit:cityObjectMember/*
      let $ft := $feature/local-name()
    		group by $ft
    		order by $ft
    	return local:statistics_row($ft,count($feature),local:file($file))}
  </table>,
  <p>Dauer: {prof:current-ms()-$start}ms</p>)
};


declare function local:test($db as document-node()*, $features as element()*, $def as element()*) as element()
{
<etf:TestReport id="{$reportId}" testObjectId="{$testObjectId}" version="0.4.0" generator="ETF-BaseX-xxx" finalized="true">
<etf:TestingTool>BaseX 7.9</etf:TestingTool>
<etf:StartTimestamp>{fn:current-dateTime()}</etf:StartTimestamp>
<etf:MachineName>unknown</etf:MachineName>
<etf:Account>unknown</etf:Account>
<etf:Label>{$reportLabel}</etf:Label>
	<etf:TestRunProperties>
		<ii:Items>
			<ii:Item name="Files to test">
				<ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">{$Files_to_test}</ii:value>
			</ii:Item>
		</ii:Items>
	</etf:TestRunProperties>

<etf:Statistics>
{
  prof:time(local:statistics($db, $features),false(),"Statistics: ")
}
</etf:Statistics>
<etf:TestSuiteResults>
<etf:TestSuiteResult id="Tests">
<etf:Duration>0</etf:Duration>
<etf:Label>GML test</etf:Label>
<etf:TestCaseResults>
{
  for $group in $def[local-name()='Group']
  let $test-step-results :=
    for $subgroup in $def[local-name()='Subgroup' and starts-with(@id,concat($group/@id,'.'))]
      let $start := prof:current-ms()
      let $assertion-results :=
        for $assertion in $def[local-name()='Assertion' and starts-with(@id,concat($subgroup/@id,'.'))]
        return
         prof:time(local:execute($db, $assertion/@id, $features, $assertion/expression, local:disabled($assertion/@id, $assertion/@enabled), $assertion/@severity, $assertion/@mode),false(),'Test ' || $assertion/@id || ": ")
      return
        local:test-step-results($subgroup/@id, $assertion-results, prof:current-ms()-$start)
  return
    <etf:TestCaseResult id="{generate-id($group)}" testCaseRef="{data($group/@id)}">
      <etf:ResultStatus>{if ($test-step-results[etf:ResultStatus='FAILED']) then 'FAILED' else if ($test-step-results[etf:ResultStatus='WARNING']) then 'WARNING' else if ($test-step-results[etf:ResultStatus='OK']) then 'OK' else 'SKIPPED'}</etf:ResultStatus>
      <etf:TestStepResults>{$test-step-results}</etf:TestStepResults>
    </etf:TestCaseResult>
}
</etf:TestCaseResults>
</etf:TestSuiteResult>
</etf:TestSuiteResults>
<etf:TestCases>
{
  for $group in $def[local-name()='Group']
  return
  <etf:TestCase id="{$group/@id}">
      <etf:Label>{$group/name/text()}</etf:Label>
      <etf:Description>{$group/description/text()}</etf:Description>
      <etf:VersionData>
        <etf:Version>{$group/version/text()}</etf:Version>
        <etf:CreationDate>{$group/creationDate/text()}</etf:CreationDate>
        <etf:LastUpdateDate>{$group/lastUpdateDate/text()}</etf:LastUpdateDate>
        <etf:Hash/>
        <etf:Author>{$group/author/text()}</etf:Author>
        <etf:LastEditor>{$group/lastEditor/text()}</etf:LastEditor>
      </etf:VersionData>
  <etf:AssociatedRequirements>
    <!--etf:Requirement>n/a</etf:Requirement-->
  </etf:AssociatedRequirements>
    <etf:Properties>
    <ii:Items>
     <ii:Item name="ShortDescription">
      <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">{$group/shortDescription/text()}</ii:value>
     </ii:Item>
     <ii:Item name="Reference">
      <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">3D</ii:value>
     </ii:Item>
    </ii:Items>
  </etf:Properties>
  <etf:TestSteps>
  {
    for $subgroup in $def[local-name()='Subgroup' and starts-with(@id,$group/@id)]
    return
    local:test-step($subgroup/@id, $subgroup/name, $def[local-name()='Assertion'])
  }
  </etf:TestSteps>
  <etf:status>IMPLEMENTED</etf:status>
  </etf:TestCase>
}
</etf:TestCases>
<etf:Requirements>
<etf:Requirement id="GML">
<etf:Label>GML 2D Geometry tests</etf:Label>
<etf:Description>GML 2D Geometry tests</etf:Description>
<etf:Properties>
    <ii:Items>
        <ii:Item name="SpecificationReference">
            <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">http://www.geonovum.nl/onderwerpen/bgt-imgeo-standaarden/</ii:value>
        </ii:Item>
    </ii:Items>
</etf:Properties>
<etf:SubRequirements>
{
  for $assertion in $def[local-name()='Assertion']
  return
  <etf:Requirement>{$assertion/name/text()}</etf:Requirement>
}
</etf:SubRequirements>
</etf:Requirement>
{
  for $assertion in $def[local-name()='Assertion']
  return
  local:requirement($assertion)
}
</etf:Requirements>

<etf:Duration>{prof:current-ms()-$reportStartTimestamp}</etf:Duration>,
</etf:TestReport>
};



(:===========:)
(: OTHER FUNCTIONS  :)
(:===========:)
declare function local:create-messages($failedAssertsOrReports as element()*, $svrlii as element(), $printExactLocationEvaluated as xs:boolean) as element() {

  let $idsOfFailedAssertsOrReports := distinct-values($failedAssertsOrReports/@id)
  let $resultsWithFailedAssertsOrReports := $svrlii/svrlii:result[exists(svrlii:activePattern/svrlii:firedRule/*[@id = $idsOfFailedAssertsOrReports])]
  let $fileErrors := count($resultsWithFailedAssertsOrReports)
  let $countElements := count($failedAssertsOrReports)
  let $messages := (
    if ($fileErrors>0) then concat('Files: ',data($fileErrors),'.&#xa;&#xa;') else (),
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
declare function local:evaluate($svrlii as element(), $sch as document-node(), $startTimeStamp as xs:dateTime, $printExactLocationEvaluated as xs:boolean,$db as document-node()*, $features as element()*, $def as element()*) as element() {

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
<etf:Statistics>
{
  prof:time(local:statistics($db, $features),false(),"Statistics: ")
}
</etf:Statistics>
<etf:TestSuiteResults>
<etf:TestSuiteResult id="Validation results">
  <etf:Duration>{$svrlii/svrlii:totalDuration/text()}</etf:Duration>
  <etf:Label>Validation results</etf:Label>
  <etf:TestCaseResults>
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
              <!-- <etf:AssertionResult id="Result.{$patternId}.{$ruleId}.{$reportId}" testAssertionRef="{$patternId}.{$ruleId}.{$reportId}">
                  {local:create-messages($successfulReports,$svrlii,$printExactLocationEvaluated)}
                 <etf:Duration/>
                 <etf:ResultStatus>OK</etf:ResultStatus>
               </etf:AssertionResult> -->
          }
          </etf:AssertionResults>
          </etf:TestStepResult>
      }
      </etf:TestStepResults>
    </etf:TestCaseResult>

}
{
  for $group in $def[local-name()='Group']
  let $test-step-results :=
    for $subgroup in $def[local-name()='Subgroup' and starts-with(@id,concat($group/@id,'.'))]
      let $start := prof:current-ms()
      let $assertion-results :=
        for $assertion in $def[local-name()='Assertion' and starts-with(@id,concat($subgroup/@id,'.'))]
        return
         prof:time(local:execute($db, $assertion/@id, $features, $assertion/expression, local:disabled($assertion/@id, $assertion/@enabled), $assertion/@severity, $assertion/@mode),false(),'Test ' || $assertion/@id || ": ")
      return
        local:test-step-results($subgroup/@id, $assertion-results, prof:current-ms()-$start)
  return
    <etf:TestCaseResult id="{generate-id($group)}" testCaseRef="{data($group/@id)}">
      <etf:ResultStatus>{if ($test-step-results[etf:ResultStatus='FAILED']) then 'FAILED' else if ($test-step-results[etf:ResultStatus='WARNING']) then 'WARNING' else if ($test-step-results[etf:ResultStatus='OK']) then 'OK' else 'SKIPPED'}</etf:ResultStatus>
      <etf:TestStepResults>{$test-step-results}</etf:TestStepResults>
    </etf:TestCaseResult>
}

    </etf:TestCaseResults>
  </etf:TestSuiteResult>
</etf:TestSuiteResults>

<etf:TestCases>

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
              <!-- <etf:Assertion id="{$patternId}.{$ruleId}.{$reportId}">
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
              </etf:Assertion> -->
          }
          </etf:Assertions>
          </etf:TestStep>
      }
      </etf:TestSteps>
      <etf:status>IMPLEMENTED</etf:status>
      </etf:TestCase>
}
{
  for $group in $def[local-name()='Group']
  return
  <etf:TestCase id="{$group/@id}">
      <etf:Label>{$group/name/text()}</etf:Label>
      <etf:Description>{$group/description/text()}</etf:Description>
      <etf:VersionData>
        <etf:Version>{$group/version/text()}</etf:Version>
        <etf:CreationDate>{$group/creationDate/text()}</etf:CreationDate>
        <etf:LastUpdateDate>{$group/lastUpdateDate/text()}</etf:LastUpdateDate>
        <etf:Hash/>
        <etf:Author>{$group/author/text()}</etf:Author>
        <etf:LastEditor>{$group/lastEditor/text()}</etf:LastEditor>
      </etf:VersionData>
  <etf:AssociatedRequirements>
    <!--etf:Requirement>n/a</etf:Requirement-->
  </etf:AssociatedRequirements>
    <etf:Properties>
    <ii:Items>
     <ii:Item name="ShortDescription">
      <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">{$group/shortDescription/text()}</ii:value>
     </ii:Item>
     <ii:Item name="Reference">
      <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
       xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">3D</ii:value>
     </ii:Item>
    </ii:Items>
  </etf:Properties>
  <etf:TestSteps>
  {
    for $subgroup in $def[local-name()='Subgroup' and starts-with(@id,$group/@id)]
    return
    local:test-step($subgroup/@id, $subgroup/name, $def[local-name()='Assertion'])
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
  <etf:Requirement id="GML">
  <etf:Label>GML 2D Geometry tests</etf:Label>
  <etf:Description>GML 2D Geometry tests</etf:Description>
  <etf:Properties>
      <ii:Items>
          <ii:Item name="SpecificationReference">
              <ii:value xsi:type="xs:string" xmlns:xs="http://www.w3.org/2001/XMLSchema"
                  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">http://www.geonovum.nl/onderwerpen/bgt-imgeo-standaarden/</ii:value>
          </ii:Item>
      </ii:Items>
  </etf:Properties>
  <etf:SubRequirements>
  {
    for $assertion in $def[local-name()='Assertion']
    return
    <etf:Requirement>{$assertion/name/text()}</etf:Requirement>
  }
  </etf:SubRequirements>
  </etf:Requirement>
  {
    for $assertion in $def[local-name()='Assertion']
    return
    local:requirement($assertion)
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

declare variable $Schema_file external := "dummyschema.xsd";

declare variable $printExactLocation external := "false"; (: if set to true - ignoring case and leading or trailing whitespace - the XPath of the element that caused an assertion to fail or a report to be generated will be included in messages:)


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
(: == Thijs: add the var for now == :)
declare variable $limitErrors := 1000;

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

let $xslIsoDsdlIncludeFile := concat($projDir, file:dir-separator(), "iso-schematron-xslt2", file:dir-separator(),"iso_dsdl_include.xsl")
let $xslIsoAbstractExpandFile := concat($projDir, file:dir-separator(), "iso-schematron-xslt2", file:dir-separator(), "iso_abstract_expand.xsl")

let $xslIIAbstractRuleExpandFile := concat($projDir, file:dir-separator(), "iso-schematron-xslt2", file:dir-separator(), "ii_abstract_rule_expand.xsl")
let $xslIdsForPatternsRulesAssertsFile := concat($projDir, file:dir-separator(), "iso-schematron-xslt2", file:dir-separator(), "ii_ids_for_patterns_and_rules.xsl")

let $xslSvrlForXsltFile := concat($projDir, file:dir-separator(), "iso-schematron-xslt2", file:dir-separator(), "iso_svrl_for_xslt2.xsl")

let $xslSvrlFormatting1File := concat($projDir, file:dir-separator(), "iso-schematron-xslt2", file:dir-separator(), "ii_svrl_formatting_1.xsl")
let $xslSvrlFormatting2File := concat($projDir, file:dir-separator(), "iso-schematron-xslt2", file:dir-separator(), "ii_svrl_formatting_2.xsl")

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

let $features := prof:time($db//cit:cityObjectMember/*|//wfs:member/*|//gml:member/*|//gml32:member/*|//gml32:featureMember/*|//stufimgeo:object,false(),'Features: ')
let $assertionsFile := concat($projDir, file:dir-separator(), "assertions.xml")
let $defAssertions :=
try{
	doc($assertionsFile)/Assertions/*
} catch * {
	error($paramerror,concat("System error: Assertions file '",data($assertionsFile),"' was not found.&#xa;"))
}

(: let $res := local:test($db, $features, $defAssertions) :)

let $res := prof:time(local:evaluate($svrlii,$sch2.2,$startTimeStamp, $printExactLocationEvaluated, $db, $features, $defAssertions), false(), 'Time to evaluate: ')
let $dummy := file:write($outputFile,$res)

(:============================:)
(: test all, write to the same file: TODO: 1 report :)
(:============================:)
(:
let $db := for $i in 0 to $count return db:open($dbBaseName || '-' || $i)[matches(db:path(.),$Files_to_test)]
let $dummy := file:write($outputFile,$res)
:)

return ($res)
