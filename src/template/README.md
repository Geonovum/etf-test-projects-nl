# Aanmaken tests


Stel, de volgende standaard moet een XSD en Schematron validatie krijgen:

Naam: "Standaard X - versie 1.1"

Onderdeel van: "NL Data"


1. download de code van de test projecten en templates via Github [https://github.com/Geonovum/etf-test-projects-nl/](https://github.com/Geonovum/etf-test-projects-nl/), of als ZIP-bestand: [https://github.com/Geonovum/etf-test-projects-nl/archive/master.zip](https://github.com/Geonovum/etf-test-projects-nl/archive/master.zip). En pak dit bestand uit.
1. Voor een XSD + schematron test, kopieer de directory:
```
/etf-test-projects-nl/src/template/xsdschematrontest
```
1. verander de naam van de directory in de naam van de standaard / het profiel dat je wilt testen. Er mogen spaties in staan. Hier gebruiken we "Standaard X - versie 1.1". Andere voorbeelden:
 * INSPIRE Download Service: Atom (TG 3.1)
 * Nederlands profiel op ISO 19119 v12 2014
 * GML-2D Geometrie
1. verander in de directory de volgende bestandsnamen, waarbij je het deel 'xsdschematrontest' vervangt met de naam van je standaard:
 * xsdschematrontest.etftp.properties -> Standaard X - versie 1.1.etftp.properties
 * xsdschematrontest-basex.xq -> Standaard X - versie 1.1-basex.xq
 * xsdschematrontest-bsxpc.xq -> Standaard X - versie 1.1-bsxpc.xq
1. Schematron: vervang de inhoud van het bestand schematron.sch met de schematron regels van de standaard (**houd de naam van het bestand dus wel schematron.sch**)
1. XSD validatie:
 1. verwijder het bestand dummyschema.xsd en plaats je eigen schema, inclusief andere geimporteerde schema's. Deze mogen in een subdirectory staan.
 1. vervang de naam van het bestand "dummyschema.xsd" door de naam van het XML schema in deze twee bestanden (zie ook de beschrijving hieronder bij Details aanpassen schema locatie):
  * ...-basex.xq
  * ...-bsxpc.xq
1. werk het bestand ...1.1.etftp.properties (bijvoorbeeld Standaard X - versie 1.1.etftp.properties) bij, met de gewenste waardes:
 * etf.TestDomain = NL Data
 * etf.Author = Geonovum
 * etf.LastUpdateDate = 2016-04-25
 * etf.Version = 1.0.1
1. In principe is hiermee de validator gereed voor plaatsing in het ETF (in de directory ```{etf-data}/projects/bsx```)


## Nota bene:
1. bij wijzigingen in een bestaande validator / test project: voer eerst lokaal alle wijzigingen door. Daarna in 1 keer alles uploaden (dus bijv niet bestandsnaam op de server aanpassen, de ETF software pikt dit niet op). 
1.

## Details aanpassen schema locatie

"...-basex.xq" en "...-bsxpc.xq" bij de parameters:

 ```
 declare variable $Schema_file external := "dummyschema.xsd";
 ```

 Deze parameters zijn te vinden bij:
 ```
 (:===========================:)
 (: Parameters as strings :)
 (:===========================:)
 ```


 Bijvoorbeeld met een bestandsnaam gmd.xsd:

 ```
 (:===========================:)
 (: Parameters as strings :)
 (:===========================:)

 declare variable $Files_to_test external := ".*";
 (: ggfs. durch Auswahl der Schematron-Phase ersetzen declare variable $Tests_to_perform external := ".*"; :)
 declare variable $Maximum_number_of_error_messages_per_test external := "100";
 declare variable $Testsystem external := "unknown";
 declare variable $Tester external := "unknown";

 declare variable $Schema_file external := "dummyschema.xsd";

 ```

 **Let op:** zorg ervoor dat in de directory ook de schema's beschikbaar zijn. In dit geval moet er dus een bestand **dummyschema.xsd** in de directory staan, met de eventuele geïmporteerde schema's.
