declare namespace cit='http://www.opengis.net/citygml/2.0';
declare namespace gml='http://www.opengis.net/gml';
declare namespace imgeo='http://www.geostandaarden.nl/imgeo/2.1';
declare namespace xsi='http://www.w3.org/2001/XMLSchema-instance';
declare namespace xlink='http://www.w3.org/1999/xlink';
declare namespace skos='http://www.w3.org/2004/02/skos/core#';
declare namespace rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#';
declare namespace etf='http://www.interactive-instruments.de/etf/1.0';
declare namespace ii='http://www.interactive-instruments.de/ii/1.0';

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
let $declarationsLocal := concat("declare namespace cit='http://www.opengis.net/citygml/2.0'; declare namespace imgeo='http://www.geostandaarden.nl/imgeo/2.1'; declare namespace skos='http://www.w3.org/2004/02/skos/core#'; declare namespace rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'; declare namespace gml='http://www.opengis.net/gml'; declare namespace xsi='http://www.w3.org/2001/XMLSchema-instance'; declare namespace xlink='http://www.w3.org/1999/xlink'; import module namespace functx = 'http://www.functx.com'; declare variable $file external; declare variable $features external; declare variable $filename external; declare variable $projDir external; declare variable $limitErrors external := ", data($limitErrors), ";
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
return <Message type='obj' file='{data($filename)}' obj='{local:type($feature)}' oid='{if ($feature/@gml:id) then data($feature/@gml:id) else data($ohneid)}' text='{data($text)}'/>
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

let $declarationsGlobal := concat("declare namespace cit='http://www.opengis.net/citygml/2.0'; declare namespace imgeo='http://www.geostandaarden.nl/imgeo/2.1'; declare namespace skos='http://www.w3.org/2004/02/skos/core#'; declare namespace rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#'; declare namespace gml='http://www.opengis.net/gml'; declare namespace xsi='http://www.w3.org/2001/XMLSchema-instance'; declare namespace xlink='http://www.w3.org/1999/xlink'; import module namespace functx = 'http://www.functx.com'; declare variable $validationErrors external; declare variable $file external; declare variable $features external; declare variable $projDir external; declare variable $db external; declare variable $limitErrors external := ", data($limitErrors), ";
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
return <Message type='obj' file='{local:file($feature)}' obj='{local:type($feature)}' oid='{if ($feature/@gml:id) then data($feature/@gml:id) else data($ohneid)}' text='{data($text)}'/>
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
<etf:Resource>database: '{$dbBaseName}'; files: '{$files_to_test}'</etf:Resource>
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

declare function local:strippath($path as xs:string) as xs:string
{
  let $sep := file:dir-separator()
  return
  if (contains($path,$sep)) then
    local:strippath(substring-after($path,$sep))
  else
    replace($path,'\.[gGxX][mM][lL]','')
};

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
					xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">{$files_to_test}</ii:value>
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
<etf:Label>IMGeo sample test</etf:Label>
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
<etf:Requirement id="IMGeo">
<etf:Label>...</etf:Label>
<etf:Description>...</etf:Description>
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

(: Parameters as strings :)
declare variable $files_to_test external := ".*";
declare variable $Schema_file external := "xsd/geoBAG0100/geoBAG0100_msg.xsd";

(: Default ETF parameters :)
declare variable $projDir external;
declare variable $outputFile external;
declare variable $dbBaseName external;
declare variable $dbCount external;
declare variable $dbDir external;
declare variable $reportLabel external;
declare variable $reportStartTimestamp external := prof:current-ms();
declare variable $reportId external;
declare variable $testObjectId external;
declare variable $validationErrors external;

declare variable $limitMessages := 100;
declare variable $limitErrors := 1000;
declare variable $paramerror := xs:QName("etf:ParameterError");

(: Parameter checks :)

declare variable $count :=
try { xs:int($dbCount - 1)
} catch * {
error($paramerror,concat("System error: Parameter $dbCount must be an integer. Found: '",data($dbCount),"'.&#xa;"))
};

if ($count ge 0) then () else error($paramerror,concat("System error: Parameter $dbCount must be a positive integer. Found: '",data($dbCount),"'&#xa;")),

try { let $x := matches('nas.gml',$files_to_test)
return ()
} catch * {
error($paramerror,concat("Parameter $files_to_test must be a valid regular expression. Found: '",data($files_to_test),"', error reported was:&#xa; '",data($err:description),"'&#xa;"))
},

if (file:exists($projDir)) then if (file:is-dir($projDir)) then () else error($paramerror,concat("System error:  Parameter $projDir must be a valid directory. Found '",data($projDir),"'&#xa;")) else error($paramerror,concat("Parameter $projDir must be an existing directory. Found: '",data($projDir),"'.&#xa;")),

if (file:exists($outputFile)) then if (file:is-file($outputFile)) then () else error($paramerror,concat("System error: Parameter $outputFile '",data($outputFile),"' references an existing directory, not a file.&#xa;")) else (),

for $i in 0 to $count return if (db:exists($dbBaseName || '-' || $i)) then () else error($paramerror,concat("System error: Data base '",concat($dbBaseName,"-",$i),"' was not found.&#xa;")),

let $db := for $i in 0 to $count return db:open($dbBaseName || '-' || $i)[matches(db:path(.),$files_to_test)]
let $features := prof:time($db//cit:cityObjectMember/*,false(),'Features: ')
let $assertionsFile := concat($projDir, file:dir-separator(), "assertions.xml")
let $def :=
try{
	doc($assertionsFile)/Assertions/*
} catch * {
	error($paramerror,concat("System error: Assertions file '",data($assertionsFile),"' was not found.&#xa;"))
}
let $res := local:test($db, $features, $def)
let $dummy := file:write($outputFile,$res)
return ($res)
