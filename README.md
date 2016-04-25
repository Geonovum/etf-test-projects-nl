# ETF Test Projecten
Voor het testen van geo-webservices (als WMS, WFS, Atom) op INSPIRE eisen en Nederlandse profielen, is in Nederland het ETF in gebruik. Er is al enkele jaren een desktop versie van deze test software, die gebruik maakt van [SoapUI](http://www.soapui.org/). Zie [de Geonovum website voor meer informatie over het ETF](http://www.geonovum.nl/validator-inspire-view-en-downloadservices). Inmiddels is er ook een online ETF validator beschikbaar, momenteel in beta.

Deze repository bevat de SoapUI test projecten om services geautomatiseerd te testen op conformiteit aan Nederlandse profielen. Naast de automatisch te testen eisen, kunnen er nog handmatige tests nodig zijn. Deze staan beschreven in [Conformiteits toetsen van Geonovum](http://www.geonovum.nl/wegwijzer/validatie).

De documenten zijn Nederlandstalig, om het voor dataproviders makkelijker te maken.

## Online ETF validator
De online validator is via [http://validatie.geostandaarden.nl/](http://validatie.geostandaarden.nl/) te benaderen.

## De online validator gebruiken
Zie [de help pagina](./www/help/help-nl.md) voor instructies over het gebruik van de validator.

## Issues melden
Komt u een probleem tegen? Raadpleeg dan de [issue-lijst](https://github.com/Geonovum/etf-test-projects-nl/issues) voor de bekende problemen en voeg desgewenst informatie toe. Staat het issue er niet tussen, maak dan via de [issue-lijst](https://github.com/Geonovum/etf-test-projects-nl/issues) een nieuw issue aan. Issues en opmerkingen graag in het Nederlands of Engels.

## Eerste versie tests voor Nederlandse profielen via online ETF
Ook de validator voor de Nederlandse profielen voor WMS en WFS gaat op den duur via het online ETF draaien. De broncode van deze test projecten is in deze repository beschikbaar.

## Broncode INSPIRE testen
De INSPIRE tests zijn te vinden in een aparte repository: [https://github.com/Geonovum/etf-test-projects-inspire ](https://github.com/Geonovum/etf-test-projects-inspire)

## Aanmaken test projecten data / metadata validatie
Zie [src/template/README.md](src/template/README.md) voor instructies hoe nieuwe tests / validators aan te maken voor data validatie.
