# Template XSD + schematron
Een nieuwe validator maken met XSD en schematron validatie:
1. kopieer de directorystructuur van dit template en geef de directory ```xsdschematron``` een logische naam van de validator. Gebruik bij voorkeur geen spaties.
1. maak een Tag aan:
  1. ga naar de directory: ```include-metadata```
  1. genereer een UUID voor de bestandsnaam: https://www.uuidgenerator.net/version4. Bijvoorbeeld: ```XXX-XXX```
  1. hernoem het bestand dat begint met ```Tag-....xml``` naar: ```Tag-EIDXXX-XXX.xml```. Let op: laat dus ```Tag-EID``` staan in de bestandsnaam
  1. gebruik dezelfde UUID in het XML bestand ```Tag-...xml``` : geef dit op in het attribuut ```id="EID..."```, dus dat wordt dan ```id="EIDXXX-XXX"```
  1. pas de elementen voor label en description aan. Desgewenst ook de priority (voor volgorde van tests als een test object van hetzelfde resource type gebruikt wordt)
1. Maak een Translation Template Bundle obv de Schematron file:
  1. ga naar de directory: ```include-metadata```
  1. Translation Template Bundle (TTB) (met zelf gegenereerde TTB id via https://www.uuidgenerator.net/version4, bijv abe7742e-9ef5-4700-ad3b-dd532a4cf0a9):
  ```
  saxonb-xslt /home/thijs/code/Geonovum/ETF/github/etf-test-projects-nl/src/metadata/Nederlands\ profiel\ op\ ISO\ 19115\ v13\ INSPIRE\ 2014/schematron.sch /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/schematron_2_etf_translation_template_bundle.xsl testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e translationTemplateId=abe7742e-9ef5-4700-ad3b-dd532a4cf0a9 > TranslationTemplateBundle-EIDabe7742e-9ef5-4700-ad3b-dd532a4cf0a9.xml
  ```
1. xsd validatie:
  1. ga naar de directory ```1_xsd```
  1. genereer een XSD BSX ETS bestand met XSLT, op basis van het Tag-bestand:
  ```
  saxonb-xslt ../include-metadata/Tag-EIDf969a29a-0c58-4738-af67-2e17e894ef4d.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-xsd-bsxets.xsl schemaURL=http://schemas.opengis.net/iso/19139/20060504/gmd/gmd.xsd translationTemplateId=abe7742e-9ef5-4700-ad3b-dd532a4cf0a9 testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e > xsd-bsxets.xml
  ```
1. Schematron,
  1. ga naar de directory ```2_schematron```
  1. genereer obv schematron, TagID, TTB en type een BSX ETS:
  ```  
  saxonb-xslt /home/thijs/code/Geonovum/ETF/github/etf-test-projects-nl/src/metadata/Nederlands\ profiel\ op\ ISO\ 19115\ v13\ INSPIRE\ 2014/schematron.sch /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/schematron_2_etf_ets.xsl tagId=f969a29a-0c58-4738-af67-2e17e894ef4d translationTemplateId=abe7742e-9ef5-4700-ad3b-dd532a4cf0a9 testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e >  NederlandsprofielopISO19115v13INSPIRE2014-bsxets.xml
  ```
1. all: TODO: maak hier ook een XSL voor
  1. tagid invoeren
  1. translationtemplateid invoeren  1.
  1. executableTestSuite 2 IDs
  1. (optioneel: testobjecttype)
