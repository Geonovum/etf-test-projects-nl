# ETF Test Projecten
Voor het testen van geo-webservices (als WMS, WFS, Atom) op INSPIRE eisen en Nederlandse profielen, is in Nederland het ETF in gebruik. Er is een desktop en online versie van deze test software, die gebruik maakt van [SoapUI](http://www.soapui.org/). Zie [de Geonovum website voor meer informatie over het ETF](http://www.geonovum.nl/validator-inspire-view-en-downloadservices)

Deze repository bevat de SoapUI test projecten om services geautomatiseerd te testen op conformiteit aan INSPIRE eisen en Nederlandse profielen. Naast de automatisch te testen eisen, kunnen er nog handmatige tests nodig zijn. Deze staan beschreven in [Conformiteits toetsen van Geonovum](http://www.geonovum.nl/wegwijzer/validatie).

## Online ETF validator
De online validator is via [http://validatie.geostandaarden.nl/](http://validatie.geostandaarden.nl/) te benaderen.

## De online validator gebruiken
Globaal gaat het testen van een service als volgt:

1) Maak een test object aan. Dit bestaat in ieder geval uit de service URL en een verplichte beschrijving en label voor de service. Optioneel kan een username/password opgegeven worden als de service HTTP Authenticatie vereist. Voor WMS en WFS is de service URL de GetCabilities URL, voor INSPIRE Download Services via Atom feeds is het de Service feed URL. Op dit moment worden de testobjecten opgeslagen in de online validator.

2) Start test. Kies de service uit de lijst met bestaande test objecten en kies op welke standaard getest moet worden via de test projecten. Indien gewenst, pas de beschrijving van de test aan en kies Start. Voor sommige tests zijn er nog geavanceerde opties beschikbaar via "Test sessie opties".

3) De test gaat draaien. In een scherm is de voortgang en log-informatie te zien. Een test kan enkele minuten duren. Na afronding, verschijnt het testrapport. Met per controle informatie over het slagen of falen ervan. Daarin zijn meer en minder details op te geven.

Via het menu (linksboven) zijn meer functies beschikbaar, zoals het raadplegen van oude test rapporten.

Er zijn wat beperkingen, zoals dat test rapporten momenteel altijd blijven bestaan (wel handmatig te verwijderen). Deze beperkingen staan in de issue-lijst.

## Eerste versie tests voor Nederlandse profielen via online ETF
Ook de validator voor de Nederlandse profielen voor WMS en WFS gaat op den duur via het online ETF draaien. De broncode van deze test projecten is in deze repository beschikbaar.

## Broncode INSPIRE testen
Volgt later. Zie [https://github.com/Geonovum/etf-test-projects/tree/master/src/inspire](https://github.com/Geonovum/etf-test-projects/tree/master/src/inspire)

## Issues melden
Komt u een probleem tegen? Raadpleeg dan de [issue-lijst](https://github.com/Geonovum/etf-test-projects/issues) voor de bekende problemen en voeg desgewenst informatie toe. Staat het issue er niet tussen, maak dan via [https://github.com/Geonovum/etf-test-projects/issues](https://github.com/Geonovum/etf-test-projects/issues) een nieuw issue aan.