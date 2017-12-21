# Template XSD + schematron
Een nieuwe validator maken met XSD en schematron validatie:
1. kopieer de directorystructuur van dit template en geef de directory ```xsdschematron``` een logische naam van de validator. Gebruik bij voorkeur geen spaties.
1. maak een Tag aan:
  1. ga naar de directory: ```include-metadata```
  1. genereer een UUID voor de bestandsnaam: https://www.uuidgenerator.net/version4. Bijvoorbeeld: ```XXX-XXX```
  1. hernoem het bestand dat begint met ```Tag-....xml``` naar: ```Tag-EIDXXX-XXX.xml```. Let op: laat dus ```Tag-EID``` staan in de bestandsnaam
  1. gebruik dezelfde UUID in het XML bestand ```Tag-...xml``` : geef dit op in het attribuut ```id="EID..."```, dus dat wordt dan ```id="EIDXXX-XXX"```
  1. pas de elementen voor label en description aan. Desgewenst ook de priority (voor volgorde van tests als een test object van hetzelfde resource type gebruikt wordt)
1. xsd validatie:
  1. ga naar de directory ```1_xsd```  1.
  1. open het XML bestand en verander:
    1. het <testItemType ref="EIDf0edc596-49d2-48d6-a1a1-1ac581dcde0a"/> indien nodig. Zie
    1. de URL van het schema: ```let $infos := validate:xsd-info($file, 'http://schemas.opengis.net/iso/19139/20060504/gmd/gmd.xsd' )```

1. schematron
1. all:
  1. testprojecten
  1. translationtemplateid
  1.
