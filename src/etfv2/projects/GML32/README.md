# Aanmaken validator XSD + schematron tests

# ISSUES GML Validator
1. in schematron staan separators met '|', wat lijkt te leiden tot issues:? Of iets anders?
```
System error in the Executable Test Suite. Please contact a system administrator. Error information:
[err:XPST0003] Expecting '}', found 'l'.
 (172/14)
```


## Goed te weten vooraf
1. de validator maakt gebruik van generieke XQuery-code (2 bestanden) voor de verwerking. De verwijzing hiernaar wordt autmatisch opgenomen, het is dus niet nodig hier nog iets voor te doen. Wel is het belangrijk dat deze code staat in de directory ../../projects/generic/. Het gaat om de bestanden:
  1. schematron-bsxets.xq
  1. schematron-query-prolog.xq
1. het aanmaken gebeurt met XSLTs. In onderstaande stappen worden de transformaties via een command-line tool uitgevoerd, een schil om de Java tool Saxon. Via een XML editor zijn deze transformaties ook uit te voeren.

## Stappen
Een nieuwe validator maken met geometrie en schematron validatie gaat volgens de volgende stappen:
1. kopieer de directorystructuur van dit template en geef de directory ```geometryschematron``` een logische naam van de validator. Gebruik bij voorkeur geen spaties.
1. Tip: maak een tekstdocument waarin je de UUIDs opslaat. Bijvoorbeeld het bestand UUID.md uit het template. Er komen er namelijk verschillende terug.
1. maak een Tag aan met de volgende stappen:
  1. ga naar de directory: ```include-metadata```
  1. genereer een UUID voor de bestandsnaam: https://www.uuidgenerator.net/version4. Bijvoorbeeld: ```XXX-XXX```
  1. hernoem het bestand dat begint met ```Tag-EID....xml``` naar: ```Tag-EIDXXX-XXX.xml```. Let op: laat dus ```Tag-EID``` staan in de bestandsnaam
  1. gebruik dezelfde UUID in het XML bestand ```Tag-EID...xml``` : geef dit op in het attribuut ```id="EID..."```, dus dat wordt dan ```id="EIDXXX-XXX"```
  1. pas de elementen voor label en description aan. Desgewenst ook de priority (voor volgorde van tests als een test object van hetzelfde resource type gebruikt wordt)
1. Maak een Translation Template Bundle o.b.v. de Schematron file:
  1. ga naar de directory: ```include-metadata```
  1. Translation Template Bundle (TTB) aanmaken (met zelf gegenereerde TTB id: een nieuwe UUID via https://www.uuidgenerator.net/version4, bijv 2c4eb556-265c-4bb6-982f-a5574ae3252b in het voorbeeld hieronder). Let op! gebruik een testObjectTypeId uit de lijst met IDs van http://docs.etf-validator.net/v2.0/Developer_manuals/Developing_Executable_Test_Suites.html#basex-test-object-types. Bijvoorbeeld voor GML: e1d4a306-7a78-4a3b-ae2d-cf5f0810853e (ZONDER EID in het script voor de TTB!)
    1. Let op de bestandsnaam: die moet dezelfde id bevatten als translationTemplateId bij het aanroepen van de XSL
    1. Code voor genereren TTB xml bestand:
    ```
    saxonb-xslt /home/thijs/code/Geonovum/ETF/github/etf-test-projects-nl/src/data/GML3.2\ SF2/schematron.sch /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/schematron_2_etf_translation_template_bundle.xsl testObjectTypeId=e1d4a306-7a78-4a3b-ae2d-cf5f0810853e translationTemplateId=2c4eb556-265c-4bb6-982f-a5574ae3252b > TranslationTemplateBundle-EID2c4eb556-265c-4bb6-982f-a5574ae3252b.xml
    ```
1. Geometrie test:
  1. ga naar de directory ```1_geometrytest```
  1. genereer obv Tag doc, TTB (NB: een adere UUID, namelijk: 245c67e5-6d28-493e-9dc6-a23de3d81cc0 voor geometrytests) en testObjectType een BSX ETS (let op de bestandsnaam):
  ```
  saxonb-xslt ../include-metadata/Tag-EID4ac4d44a-563f-43ec-80c2-f8a3d4e13776.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/tag_2_etf_geometry_ets.xsl translationTemplateId=245c67e5-6d28-493e-9dc6-a23de3d81cc0 testObjectTypeId=e1d4a306-7a78-4a3b-ae2d-cf5f0810853e >  geometrytest-bsxets.xml
  ```
1. Schematron,
  1. ga naar de directory ```2_schematrontest```
  1. genereer obv schematron, TagID, TTB en testObjectType een BSX ETS (let op de bestandsnaam, moet {NaamValidatorZonderSpaties}-bsxets.xml zijn):
  ```  
  saxonb-xslt /home/thijs/code/Geonovum/ETF/github/etf-test-projects-nl/src/data/GML3.2\ SF2/schematron.sch /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/schematron_2_etf_ets.xsl tagId=4ac4d44a-563f-43ec-80c2-f8a3d4e13776 translationTemplateId=2c4eb556-265c-4bb6-982f-a5574ae3252b testObjectTypeId=e1d4a306-7a78-4a3b-ae2d-cf5f0810853e etsId=b0e04e22-ef12-11e8-d219-09173f13e4c6 >  GML32-bsxets.xml
  ```
1. maak een bestand voor de validators samen. Genereer een all-bsxets.xml. Ga naar de directory ```3_all``` en gebruik de volgende UUIDs in de parameters:
  1. tagid
  1. translationtemplateid
  1. executableTestSuite 2 UUIDs van xsd en schematron
  1. (optioneel: testobjecttype)
  1. Voorbeeld commando:
  ```
  saxonb-xslt ../include-metadata/Tag-EID4ac4d44a-563f-43ec-80c2-f8a3d4e13776.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-all-geometry-schematron.xsl dependencyIdGeometry=6c675042-ef12-11e8-d217-09173f13e4c5 dependencyIdSchematron=b0e04e22-ef12-11e8-d219-09173f13e4c6 translationTemplateId=2c4eb556-265c-4bb6-982f-a5574ae3252b testObjectTypeId=e1d4a306-7a78-4a3b-ae2d-cf5f0810853e etsId=06fb92cc-ef13-11e8-1038-09173f13e4c5 > all-bsxets.xml
  ```
