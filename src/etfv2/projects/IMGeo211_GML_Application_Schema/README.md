# ISSUES
1. detect the correct features, cityGML? is this the proper path: $db/cit:CityModel/cit:cityObjectMember ? add to string to match features in example-bsxets-imgeo.xq
  1. error:
  ```
  Stopped at ., 368/48:
  [bxerr:BXDB0002] Database 'etf-test-0' was not found.
  ```
  1. added multiple namespaces and change path for detecting features in xQuery doc
  1. change citygml model?? as objecttype? http://docs.etf-validator.net/v2.0/Developer_manuals/Developing_Executable_Test_Suites.html#basex-test-object-types


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
  saxonb-xslt ../include-metadata/Tag-EID4de87e98-7b9a-498a-95d8-1bcf46185f37.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-xsdandgmlencoding-bsxets.xsl schemaURL=https://register.geostandaarden.nl/gmlapplicatieschema/imgeo/2.1.1/imgeo.xsd translationTemplateId=245c67e5-6d28-493e-9dc6-a23de3d81cc0 testObjectTypeId=e1d4a306-7a78-4a3b-ae2d-cf5f0810853e > xsdgmlencoding-bsxets.xml
  ```
  1. noteer de UUID van de xsd validator, open het bestand xsdgmlencoding-bsxets.xml en noteer de id in het attribuut: /etf:ExecutableTestSuite@id (zonder EID)
1. Geometrie test:
  1. ga naar de directory ```2_geometrytest```
  1. genereer obv Tag doc, TTB en testObjectType een BSX ETS (let op de bestandsnaam ):
  ```
  saxonb-xslt ../include-metadata/Tag-EID4de87e98-7b9a-498a-95d8-1bcf46185f37.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/tag_2_etf_geometry_ets.xsl translationTemplateId=245c67e5-6d28-493e-9dc6-a23de3d81cc0 testObjectTypeId=e1d4a306-7a78-4a3b-ae2d-cf5f0810853e >  IMGeo211_GML_Application_Schema-bsxets.xml
  ```
1. maak een bestand voor de validators samen. Genereer een all-bsxets.xml. Ga naar de directory ```3_all``` en gebruik de volgende UUIDs in de parameters:
  1. tagid
  1. translationtemplateid: standaard TTB 245c67e5-6d28-493e-9dc6-a23de3d81cc0
  1. executableTestSuite 2 UUIDs van xsd en geometrytest
  1. (optioneel: testobjecttype, als anders dan GML FeatureCollection)
  1. Voorbeeld script:
  ```
  saxonb-xslt ../include-metadata/Tag-EID4de87e98-7b9a-498a-95d8-1bcf46185f37.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-all-xsd-geometry.xsl dependencyIdXsd=ef1bf1cc-ef2b-11e8-4452-09173f13e4c5 dependencyIdGeometry=2fe4bf82-ef2c-11e8-d217-09173f13e4c5 translationTemplateId=245c67e5-6d28-493e-9dc6-a23de3d81cc0 testObjectTypeId=e1d4a306-7a78-4a3b-ae2d-cf5f0810853e > all-bsxets.xml
  ```
