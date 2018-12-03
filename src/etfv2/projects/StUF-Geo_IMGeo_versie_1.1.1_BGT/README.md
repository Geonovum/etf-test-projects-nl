# Template XSD + geometrie
Een nieuwe validator maken met XSD en geometrie validatie:
1. kopieer de directorystructuur van dit template en geef de directory ```xsdgeometry``` een logische naam van de validator. Gebruik bij voorkeur geen spaties.
1. Tip: maak een tekstdocument waarin je de UUIDs opslaat. Bijvoorbeeld het bestand UUID.md uit het template. Er komen er namelijk verschillende terug.
1. maak een Tag aan met de volgende stappen:
  1. ga naar de directory: ```include-metadata```
  1. genereer een UUID voor de bestandsnaam: https://www.uuidgenerator.net/version4. Bijvoorbeeld: ```XXX-XXX```
  1. hernoem het bestand dat begint met ```Tag-EID....xml``` naar: ```Tag-EIDXXX-XXX.xml```. Let op: laat dus ```Tag-EID``` staan in de bestandsnaam
  1. gebruik dezelfde UUID in het XML bestand ```Tag-EID...xml``` : geef dit op in het attribuut ```id="EID..."```, dus dat wordt dan ```id="EIDXXX-XXX"```
  1. pas de elementen voor label en description aan. Desgewenst ook de priority (voor volgorde van tests als een test object van hetzelfde resource type gebruikt wordt)

1. xsd + gml encoding validatie:
  1. ga naar de directory ```1_xsdgml```
  1. genereer een XSD + GML encoding BSX ETS bestand met XSLT, op basis van het eerder gegenereerde Tag-bestand en de TTB id:
  ```
  saxonb-xslt ../include-metadata/Tag-EIDee9c3a6e-c7e7-4171-98b2-6d42c887c3ea.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-xsdandgmlencoding-bsxets.xsl schemaURL=http://register.geostandaarden.nl/xmlschema/imgeo/1.1.1/imgeo0300/verticaal/imgeo0300_msg_verticaal.xsd translationTemplateId=245c67e5-6d28-493e-9dc6-a23de3d81cc0 testObjectTypeId=810fce18-4bf5-4c6c-a972-6962bbe3b76b > xsdgmlencoding-bsxets.xml
  ```
  1. noteer de UUID van de xsd validator, open het bestand xsdgmlencoding-bsxets.xml en noteer de id in het attribuut: /etf:ExecutableTestSuite@id (zonder EID)

1. GML3.2 SF test: EIDb0e04e22-ef12-11e8-d219-09173f13e4c6 (schematron)
1. GML geometrie test? of GML: 6c675042-ef12-11e8-d217-09173f13e4c5


1. maak een bestand voor de validators samen. Genereer een all-bsxets.xml. Ga naar de directory ```2_all``` en gebruik de volgende UUIDs in de parameters:
  1. tagid
  1. translationtemplateid: standaard TTB 2c4eb556-265c-4bb6-982f-a5574ae3252b
  1. executableTestSuite 2 UUIDs van xsd en geometrytest
  1. (optioneel: testobjecttype, als anders dan GML FeatureCollection)
  1. Voorbeeld script:
  ```
  saxonb-xslt ../include-metadata/Tag-EIDee9c3a6e-c7e7-4171-98b2-6d42c887c3ea.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-all-xsd-geometry.xsl dependencyIdXsd=a6ae2f3b-f70d-11e8-2116-09173f13e4c5 dependencyIdGeometry=6c675042-ef12-11e8-d217-09173f13e4c5 translationTemplateId=2c4eb556-265c-4bb6-982f-a5574ae3252b testObjectTypeId=810fce18-4bf5-4c6c-a972-6962bbe3b76b etsId=09dcab2c-f6ea-11e8-8136-09173f13e4c5 > all-bsxets.xml
  ```
