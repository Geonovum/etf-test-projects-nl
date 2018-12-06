# Template XSD + geometrie
## Goed te weten vooraf
1. de validator maakt gebruik van generieke XQuery-code (2 bestanden) voor de verwerking. De verwijzing hiernaar wordt autmatisch opgenomen, het is dus niet nodig hier nog iets voor te doen. Wel is het belangrijk dat deze code staat in de directory ../../projects/generic/. Het gaat om de bestanden:
  1. ets-generic-bsxets.xq
  1. testquery.xq
  1. schematron-bsxets.xq
  1. schematron-query-prolog.xq
1. het aanmaken gebeurt met XSLTs. In onderstaande stappen worden de transformaties via een command-line tool uitgevoerd, een schil om de Java tool Saxon. Via een XML editor zijn deze transformaties ook uit te voeren.
1. *Tip:* voor bepaalde modellen van Geonovum is geen standaard GML FeatureCollection of CityGML Model in gebruik. Zoals voor StUF modellen. Hiervoor zijn aparte TestObjectTypes gemaakt. Zie https://github.com/Geonovum/etf-stdtot/blob/master/Geonovum.md voor de TestObjectTypes.

Een nieuwe validator maken met XSD en geometrie validatie:
1. kopieer de directorystructuur van dit template en geef de directory ```xsdgeometry``` een logische naam van de validator. Gebruik bij voorkeur geen spaties.
1. Tip: maak een tekstdocument waarin je de UUIDs opslaat. Bijvoorbeeld het bestand UUID.md uit het template. Er komen er namelijk verschillende terug.
1. maak een Tag aan met de volgende stappen:
  1. ga naar de directory: ```include-metadata```
  1. genereer een UUID voor de bestandsnaam: https://www.uuidgenerator.net/version4. Bijvoorbeeld: ```7d4c58f3-e658-4b6c-9186-081ed4874302```
  1. hernoem het bestand dat begint met ```Tag-EID....xml``` naar: ```Tag-EID7d4c58f3-e658-4b6c-9186-081ed4874302.xml```. Let op: laat dus ```Tag-EID``` staan in de bestandsnaam
  1. gebruik dezelfde UUID in het XML bestand ```Tag-EID...xml``` : geef dit op in het attribuut ```id="EID..."```, dus dat wordt dan ```id="EID7d4c58f3-e658-4b6c-9186-081ed4874302"```
  1. pas de elementen voor label en description aan. Desgewenst ook de priority (voor volgorde van tests als een test object van hetzelfde resource type gebruikt wordt)

1. xsd + gml encoding validatie:
  1. ga naar de directory ```1_xsdgml```
  1. genereer een XSD + GML encoding BSX ETS bestand met XSLT, op basis van het eerder gegenereerde Tag-bestand en de TTB id:
  ```
  saxonb-xslt ../include-metadata/Tag-EID7d4c58f3-e658-4b6c-9186-081ed4874302.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-xsdandgmlencoding-bsxets.xsl schemaURL=http://register.geostandaarden.nl/xmlschema/imgeo/1.3/imgeo0302/horizontaal/imgeo0302_msg_horizontaal.xsd translationTemplateId=245c67e5-6d28-493e-9dc6-a23de3d81cc0 testObjectTypeId=14b4aa1d-6157-413d-8acc-f8a026d0d6dd > xsdgmlencoding-bsxets.xml  
  ```
  1. noteer de UUID van de xsd validator, open het bestand xsdgmlencoding-bsxets.xml en noteer de id in het attribuut: /etf:ExecutableTestSuite@id (zonder EID)
1. gebruik als uuid voor de standaard GML geometrie test: ```6c675042-ef12-11e8-d217-09173f13e4c5``` of GML geometrie + SF GML ```06fb92cc-ef13-11e8-1038-09173f13e4c5``` en verwijder de directory  ```2_geometrytest```
1. maak een bestand voor de validators samen. Genereer een all-bsxets.xml. Ga naar de directory ```3_all``` en gebruik de volgende UUIDs in de parameters:
  1. tagid
  1. translationtemplateid: standaard TTB 245c67e5-6d28-493e-9dc6-a23de3d81cc0
  1. executableTestSuite 2 UUIDs van xsd en geometrytest
  1. (optioneel: testobjecttype, als anders dan GML FeatureCollection)
  1. Voorbeeld script:
  ```
  saxonb-xslt ../include-metadata/Tag-EID7d4c58f3-e658-4b6c-9186-081ed4874302.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-all-xsd-geometry.xsl dependencyIdXsd=7b51107b-f963-11e8-2116-09173f13e4c5 dependencyIdGeometry=6c675042-ef12-11e8-d217-09173f13e4c5 translationTemplateId=245c67e5-6d28-493e-9dc6-a23de3d81cc0 testObjectTypeId=14b4aa1d-6157-413d-8acc-f8a026d0d6dd etsId=bb5d5e0c-f963-11e8-8136-09173f13e4c5 > all-bsxets.xml
  ```
