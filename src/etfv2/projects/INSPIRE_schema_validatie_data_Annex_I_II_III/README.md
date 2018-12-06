# Aanmaken validator XSD + schematron tests
## Goed te weten vooraf
1. de validator maakt gebruik van generieke XQuery-code (2 bestanden) voor de verwerking. De verwijzing hiernaar wordt autmatisch opgenomen, het is dus niet nodig hier nog iets voor te doen. Wel is het belangrijk dat deze code staat in de directory ../../projects/generic/. Het gaat om de bestanden:
  1. schematron-bsxets.xq
  1. schematron-query-prolog.xq
1. het aanmaken gebeurt met XSLTs. In onderstaande stappen worden de transformaties via een command-line tool uitgevoerd, een schil om de Java tool Saxon. Via een XML editor zijn deze transformaties ook uit te voeren.

## Stappen
Een nieuwe validator maken met XSD en schematron validatie gaat volgens de volgende stappen:
1. kopieer de directorystructuur van dit template en geef de directory ```xsdschematron``` een logische naam van de validator. Gebruik bij voorkeur geen spaties.
1. Tip: maak een tekstdocument waarin je de UUIDs opslaat. Bijvoorbeeld het bestand UUID.md uit het template. Er komen er namelijk verschillende terug.
1. maak een Tag aan met de volgende stappen:
  1. ga naar de directory: ```include-metadata```
  1. genereer een UUID voor de bestandsnaam: https://www.uuidgenerator.net/version4. Bijvoorbeeld: ```XXX-XXX```
  1. hernoem het bestand dat begint met ```Tag-EID....xml``` naar: ```Tag-EIDXXX-XXX.xml```. Let op: laat dus ```Tag-EID``` staan in de bestandsnaam
  1. gebruik dezelfde UUID in het XML bestand ```Tag-EID...xml``` : geef dit op in het attribuut ```id="EID..."```, dus dat wordt dan ```id="EIDXXX-XXX"```
  1. pas de elementen voor label en description aan. Desgewenst ook de priority (voor volgorde van tests als een test object van hetzelfde resource type gebruikt wordt)

1. xsd validatie:
  1. ga naar de directory ```1_xsd```
  1. genereer een XSD BSX ETS bestand met XSLT, op basis van het eerder gegenereerde Tag-bestand en de TTB id:
  ```
  saxonb-xslt ../include-metadata/Tag-EID3fe7293c-7523-490e-9bba-fb958615d591.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-xsd-bsxets.xsl schemaURL=../inspire-annex-I-II-IIIv40-1.0.0_onlineschemas.xsd translationTemplateId=245c67e5-6d28-493e-9dc6-a23de3d81cc0 testObjectTypeId=e1d4a306-7a78-4a3b-ae2d-cf5f0810853e > xsd-bsxets.xml
  ```
  1. noteer de UUID van de xsd validator, open het bestand xsd-bsxets en noteer de id in het attribuut: /etf:ExecutableTestSuite@id (zonder EID)
1. maak een bestand voor de validators samen. Genereer een all-bsxets.xml. Ga naar de directory ```3_all``` en gebruik de volgende UUIDs in de parameters:
  1. tagid
  1. translationtemplateid
  1. executableTestSuite 2 UUIDs van xsd en schematron
  1. (optioneel: testobjecttype)
  1. Voorbeeld commando:
  ```
  saxonb-xslt ../include-metadata/Tag-EID3fe7293c-7523-490e-9bba-fb958615d591.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-all-xsd-schematron.xsl dependencyIdXsd=3f674143-fd27-11e7-1863-09173f13e4c5 dependencyIdSchematron=050e4572-fd28-11e7-d212-09173f13e4c5 translationTemplateId=245c67e5-6d28-493e-9dc6-a23de3d81cc0 testObjectTypeId=e1d4a306-7a78-4a3b-ae2d-cf5f0810853e > all-bsxets.xml
  ```
