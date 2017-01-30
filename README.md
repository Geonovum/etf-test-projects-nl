# ETF Test Projecten: online validator Geonovum
Voor het testen van geo-webservices (als WMS, WFS, Atom) op INSPIRE eisen en Nederlandse profielen, is in Nederland het ETF in gebruik. Er is al enkele jaren een desktop versie van deze test software, die gebruik maakt van [SoapUI](http://www.soapui.org/). Zie [de Geonovum website voor meer informatie over het ETF](http://www.geonovum.nl/validator-inspire-view-en-downloadservices). Inmiddels is er ook een online ETF validator beschikbaar.

Voor data en metadata validatie bood Geonovum via de website ook al enkele jaren verscheidene validators aan. De online validator op [http://validatie.geostandaarden.nl/](http://validatie.geostandaarden.nl/) vervangt deze vorige validators.

Deze repository bevat de validatieregels en SoapUI test projecten om data, meatdata en services geautomatiseerd te testen op conformiteit aan Nederlandse profielen via de ETF-Webapp. De broncode vand e webapplicatie zelf is te vinden via [https://github.com/interactive-instruments/etf-webapp](https://github.com/interactive-instruments/etf-webapp) .

Naast de automatisch te testen eisen, kunnen er overigens ook nog handmatige tests nodig zijn. Deze staan beschreven in [Conformiteits toetsen van Geonovum](http://www.geonovum.nl/wegwijzer/validatie).
De documenten zijn Nederlandstalig, om het voor dataproviders makkelijker te maken.

## Online validator
De online validator is via [http://validatie.geostandaarden.nl/](http://validatie.geostandaarden.nl/) te benaderen.

## De online validator gebruiken
Zie [de help pagina](./www/help/help-nl.md) voor instructies over het gebruik van de validator.

## Issues melden
Komt u een probleem tegen? Raadpleeg dan de [issue-lijst](https://github.com/Geonovum/etf-test-projects-nl/issues) voor de bekende problemen en voeg desgewenst informatie toe. Staat het issue er niet tussen, maak dan via de [issue-lijst](https://github.com/Geonovum/etf-test-projects-nl/issues) een nieuw issue aan. Issues en opmerkingen graag in het Nederlands of Engels.

## Validatieregels hergebruiken: Schematron regels beschikbaar
De Schematron testregels van de test projecten zijn te gebruiken in andere implementaties.
In de testprojecten heten de schematron regels (indien in gebruik) altijd:

```
schematron.sch
```

Directe links naar schematron metadata:

* metadata dataset ISO 19115 v13 2014: [src/metadata/Nederlands%20profiel%20op%20ISO%2019115%20v13%202014/schematron.sch](src/metadata/Nederlands%20profiel%20op%20ISO%2019115%20v13%202014/schematron.sch)
* metadata dataset ISO 19115 v13 2014 plus INSPIRE: [src/metadata/Nederlands%20profiel%20op%20ISO%2019115%20v13%20INSPIRE%202014/schematron.sch](src/metadata/Nederlands%20profiel%20op%20ISO%2019115%20v13%20INSPIRE%202014/schematron.sch)
* metadata dataset ISO 19115 v13 2014 plus INSPIRE geharmoniseerd: [src/metadata/Nederlands%20profiel%20op%20ISO%2019115%20v13%20INSPIRE%20geharmoniseerd%202014/schematron.sch](src/metadata/Nederlands%20profiel%20op%20ISO%2019115%20v13%20INSPIRE%20geharmoniseerd%202014/schematron.sch)
* metadata services ISO 19119 v12 2014: [src/metadata/Nederlands%20profiel%20op%20ISO%2019119%20v12%202016/schematron.sch](src/metadata/Nederlands%20profiel%20op%20ISO%2019119%20v12%202016/schematron.sch)
* metadata services ISO 19119 v12 2014 INSPIRE: [src/metadata/Nederlands%20profiel%20op%20ISO%2019119%20v12%20INSPIRE%202016/schematron.sch](src/metadata/Nederlands%20profiel%20op%20ISO%2019119%20v12%20INSPIRE%202016/schematron.sch)

Directe links naar schematron data validatie:
* GML 3.2 Simple Features: [src/data/GML3.2%20SF2/schematron.sch](src/data/GML3.2%20SF2/schematron.sch)

## Eerste versie tests voor Nederlandse profielen via online ETF
Ook de validator voor de Nederlandse profielen voor WMS en WFS gaat via het online ETF draaien. De broncode van deze test projecten is in deze repository beschikbaar.

## Broncode INSPIRE test projecten services
De INSPIRE tests voor services (View Services, Download Services) zijn te vinden in een aparte repository: [https://github.com/Geonovum/etf-test-projects-inspire ](https://github.com/Geonovum/etf-test-projects-inspire)

## Aanmaken test projecten data / metadata validatie
Zie [src/template/README.md](src/template/README.md) voor instructies hoe nieuwe tests / validators aan te maken voor data validatie.
