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
1. Maak een Translation Template Bundle o.b.v. de Schematron file:
  1. ga naar de directory: ```include-metadata```
  1. Translation Template Bundle (TTB) aanmaken (met zelf gegenereerde TTB id: een nieuwe UUID via https://www.uuidgenerator.net/version4, bijv abe7742e-9ef5-4700-ad3b-dd532a4cf0a9 in het voorbeeld hieronder). Let op! gebruik een testObjectTypeId uit de lijst met IDs van http://docs.etf-validator.net/v2.0/Developer_manuals/Developing_Executable_Test_Suites.html#basex-test-object-types. Bijvoorbeeld voor metadata: 5a60dded-0cb0-4977-9b06-16c6c2321d2e (ZONDER EID in het script voor de TTB!) en voor GML: e1d4a306-7a78-4a3b-ae2d-cf5f0810853e
    1. Let op de bestandsnaam: die moet dezelfde id bevatten als translationTemplateId bij het aanroepen van de XSL
    1. Code voor genereren TTB xml bestand:
    ```
    saxonb-xslt /home/thijs/code/Geonovum/ETF/github/etf-test-projects-nl/src/metadata/Nederlands\ profiel\ op\ ISO\ 19115\ v13\ INSPIRE\ 2014/schematron.sch /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/schematron_2_etf_translation_template_bundle.xsl testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e translationTemplateId=abe7742e-9ef5-4700-ad3b-dd532a4cf0a9 > TranslationTemplateBundle-EIDabe7742e-9ef5-4700-ad3b-dd532a4cf0a9.xml
    ```
1. xsd validatie:
  1. ga naar de directory ```1_xsd```
  1. genereer een XSD BSX ETS bestand met XSLT, op basis van het eerder gegenereerde Tag-bestand en de TTB id:
  ```
  saxonb-xslt ../include-metadata/Tag-EIDf969a29a-0c58-4738-af67-2e17e894ef4d.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-xsd-bsxets.xsl schemaURL=http://schemas.opengis.net/iso/19139/20060504/gmd/gmd.xsd translationTemplateId=abe7742e-9ef5-4700-ad3b-dd532a4cf0a9 testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e > xsd-bsxets.xml
  ```
  1. noteer de UUID van de xsd validator, open het bestand xsd-bsxets en noteer de id in het attribuut: /etf:ExecutableTestSuite@id (zonder EID)
1. Schematron,
  1. ga naar de directory ```2_schematrontest```
  1. genereer obv schematron, TagID, TTB en testObjectType een BSX ETS (let op de bestandsnaam):
  ```  
  saxonb-xslt /home/thijs/code/Geonovum/ETF/github/etf-test-projects-nl/src/metadata/Nederlands\ profiel\ op\ ISO\ 19115\ v13\ INSPIRE\ 2014/schematron.sch /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/schematron_2_etf_ets.xsl tagId=f969a29a-0c58-4738-af67-2e17e894ef4d translationTemplateId=abe7742e-9ef5-4700-ad3b-dd532a4cf0a9 testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e >  NederlandsprofielopISO19115v13INSPIRE2014-bsxets.xml
  ```
1. maak een bestand voor de validators samen. Genereer een all-bsxets.xml. Ga naar de directory ```3_all``` en gebruik de volgende UUIDs in de parameters:
  1. tagid
  1. translationtemplateid
  1. executableTestSuite 2 UUIDs van xsd en schematron
  1. (optioneel: testobjecttype)
  1. Voorbeeld commando:
  ```
  saxonb-xslt ../include-metadata/Tag-EIDafe2f9f2-e603-42b4-bd6f-dfa52243752e.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-all-xsd-schematron.xsl dependencyIdXsd=3f674143-fd27-11e7-1863-09173f13e4c5 dependencyIdSchematron=050e4572-fd28-11e7-d212-09173f13e4c5 translationTemplateId=13837fe8-eb23-4421-b2cb-1e2704bf618b testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e > all-bsxets.xml
  ```
