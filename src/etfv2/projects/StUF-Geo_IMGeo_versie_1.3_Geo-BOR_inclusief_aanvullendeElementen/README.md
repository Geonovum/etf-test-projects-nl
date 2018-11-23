# Openstaande punten

vraag over Stuf Imgeo:

2 schema's? --> 2 tests van maken?

https://register.geostandaarden.nl/xmlschema/imgeo/1.3/imgeo0302/geo-bor/geo-bor0100.xsd

https://register.geostandaarden.nl/xmlschema/imgeo/1.3/imgeo0302/horizontaal/imgeo0302_msg_horizontaal.xsd

2 XSD validators?
--> TODO: extra xsd validator erbij

Schema StUF-Geo IMGeo berichtschema (XSD) versie 1.3
Schema Geo-BOR StUF:aanvullendeElementen

--> ISSUES met xsd, later oplossen? Eerst maar GML SF2 proberen?
--> ander type om te valideren?
--> Standaard XMl? en hoe in XQuery hiermee omgaan?

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
  saxonb-xslt ../include-metadata/Tag-EID1f3b85ac-1e82-4ec1-af30-75f340037dab.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-xsdandgmlencoding-bsxets.xsl schemaURL=http://register.geostandaarden.nl/xmlschema/imgeo/1.3/imgeo0302/horizontaal/imgeo0302_ent_horizontaal.xsd translationTemplateId=245c67e5-6d28-493e-9dc6-a23de3d81cc0 testObjectTypeId=e1d4a306-7a78-4a3b-ae2d-cf5f0810853e > xsdgmlencoding-bsxets.xml
  ```
  1. noteer de UUID van de xsd validator, open het bestand xsdgmlencoding-bsxets.xml en noteer de id in het attribuut: /etf:ExecutableTestSuite@id (zonder EID)
1. Geometrie test:
  1. ga naar de directory ```2_geometrytest```
  1. genereer obv Tag doc, TTB en testObjectType een BSX ETS (let op de bestandsnaam):
  ```
  saxonb-xslt ../include-metadata/Tag-EID1f3b85ac-1e82-4ec1-af30-75f340037dab.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/tag_2_etf_geometry_ets.xsl translationTemplateId=245c67e5-6d28-493e-9dc6-a23de3d81cc0 testObjectTypeId=e1d4a306-7a78-4a3b-ae2d-cf5f0810853e >  geometrytest-bsxets.xml
  ```
1. maak een bestand voor de validators samen. Genereer een all-bsxets.xml. Ga naar de directory ```3_all``` en gebruik de volgende UUIDs in de parameters:
  1. tagid
  1. translationtemplateid
  1. executableTestSuite 2 UUIDs van xsd en geometrytest
  1. (optioneel: testobjecttype)
  1. Voorbeeld script:
  ```
  saxonb-xslt ../include-metadata/Tag-EID1f3b85ac-1e82-4ec1-af30-75f340037dab.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-all-xsd-geometry.xsl dependencyIdXsd=822a3f0c-25ef-11e8-4452-09173f13e4c5 dependencyIdGeometry=d0035192-25ef-11e8-d217-09173f13e4c5 translationTemplateId=245c67e5-6d28-493e-9dc6-a23de3d81cc0 testObjectTypeId=e1d4a306-7a78-4a3b-ae2d-cf5f0810853e > all-bsxets.xml
  ```
