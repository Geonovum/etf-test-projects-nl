declare namespace cit='http://www.opengis.net/citygml/2.0';
declare namespace gml='http://www.opengis.net/gml';
declare namespace imgeo='http://www.geostandaarden.nl/imgeo/2.1';
declare namespace xsi='http://www.w3.org/2001/XMLSchema-instance';
declare namespace xlink='http://www.w3.org/1999/xlink';
declare namespace skos='http://www.w3.org/2004/02/skos/core#';
declare namespace rdf='http://www.w3.org/1999/02/22-rdf-syntax-ns#';
declare namespace etf='http://www.interactive-instruments.de/etf/1.0';
declare namespace ii='http://www.interactive-instruments.de/ii/1.0';

(: Parameters as strings :)
declare variable $files_to_test external := ".*";
declare variable $Schema_file external := "imgeo-2.1.1.xsd";

(: Default ETF parameters :)
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

declare variable $limitMessages := 100;
declare variable $limitErrors :=1000;
declare variable $paramerror := xs:QName("etf:ParameterError");

(: Parameter checks :)

try { let $x := matches('nas.gml',$files_to_test)
return ()
} catch * {
error($paramerror,concat("Parameter $files_to_test must be a valid regular expression. Found: '",data($files_to_test),"', error reported was:&#xa; '",data($err:description),"'&#xa;"))
}
