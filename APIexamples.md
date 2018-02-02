# Voorbeelden gebruik van de API
ETF v2 is te gebruiken via een REST API. Hieronder volgen enkele voorbeelden van gebruik van deze API, momenteel op de Beta omgeving:

```
http://beta.validatie.geostandaarden.nl:8080/etf-webapp-2.0.0
```

## Documentatie
Zie http://docs.etf-validator.net/v2.0/Developer_manuals/WEB-API.html voor de API.

Nota bene: het verdient sterk aanbeveling om meer te weten over de concepten en gebruikte begrippen van het ETF. Zie o.a. http://docs.etf-validator.net/v2.0/Developer_manuals/Developing_Executable_Test_Suites.html#_information_and_concepts_used_by_all_executable_test_suites

## Swagger: documentatie van de API met live voorbeelden
De API is gespecifieerd via een Swagger document:
```
http://beta.validatie.geostandaarden.nl:8080/etf-webapp-2.0.0/swagger-ui.html
```
Het ETF biedt via Swagger de mogelijkheid direct operaties van de API te testen en de documentatie in te zien.

## Voorbeeld: valideer metadata document
Hier volgt een voorbeeld om een metadata document te valideren.
Het gaat om dit document, uit het NGR (metadata dataset)
http://nationaalgeoregister.nl/geonetwork/srv/dut/catalog.search#/metadata/8829e5dd-c861-4639-a6c8-fdbb6e3440d2

XML doc via NGR:
http://nationaalgeoregister.nl/geonetwork/srv/api/records/8829e5dd-c861-4639-a6c8-fdbb6e3440d2


1. Opvragen beschikbare validators met Curl:
```
curl -X GET --header 'Accept: application/json' 'http://beta.validatie.geostandaarden.nl:8080/etf-webapp-2.0.0/v2/ExecutableTestSuites.json?fields=*'
```
  Dit geeft erg veel informatie terug. Om de lijst te beperken, gebruik de fields-parameter, bijvoorbeeld:  
  ```
  curl -X GET --header 'Accept: application/json' 'http://beta.validatie.geostandaarden.nl:8080/etf-webapp-2.0.0/v2/ExecutableTestSuites.json?fields=id,label,description'
  ```

1. Haal uit het response de id van de ExecutableTestSuite (NB voorbeeld hieronder is geen volledig JSON document, maar toont alleen relevante delen):
```
{
  "id": "EID25266ccc-fd2e-11e7-1038-09173f13e4c5",
  "label": "Run all dependencies",
  "description": "Run XSD and Schematron tests for Nederlands profiel op ISO 19115 v13 INSPIRE geharmoniseerd 2014"
}
```
Nota bene: in de Beta versie ontbreken nog goede beschrijvingen en labels van bepaalde validators. De migratie van de validators uit ETF v1 is namelijk nog bezig.

1. gebruik de id om een test te draaien. via HTTP POST, verstuur de volgende data:
```
{
    "label": "Test run on 15:00 - 01.01.2018 with Conformance class Conformance Class: Metadata services NL profiel test API",
    "executableTestSuiteIds": ["EID25266ccc-fd2e-11e7-1038-09173f13e4c5"],
    "arguments": {
        "files_to_test": ".*",
        "tests_to_execute": ".*"
      },
      "testObject": {
        "resources": {
    			"data": "http://nationaalgeoregister.nl/geonetwork/srv/api/records/8829e5dd-c861-4639-a6c8-fdbb6e3440d2"
        }
      }
}
```
Naar:
```
http://beta.validatie.geostandaarden.nl:8080/etf-webapp-2.0.0/v2/TestRuns
```
1. Als het goed is draait de test nu. Het response geeft de ID en een URL (ref) van de testrun weer iom de status op te vragen:
```
...
"ref": "http://beta.validatie.geostandaarden.nl:8080/etf-webapp-2.0.0/v2/TestRuns/aaa57b47-0d8a-4d96-be97-8a713e6d7845.json",
    "testRuns": {
      "TestRun": {
        "id": "EIDaaa57b47-0d8a-4d96-be97-8a713e6d7845",
        "status": "UNDEFINED",
  ...
```    
1. Volg de status van de validatie:
http://beta.validatie.geostandaarden.nl:8080/etf-webapp-2.0.0/v2/TestRuns/aaa57b47-0d8a-4d96-be97-8a713e6d7845.json

1. als de test is afgerond volgt in JSON formaat de rapportage van de validatie. Dit rapport is een uitgebreid (JSON) document, met o.a. het overall resultaat, de gebruikte tests en teststappen en per teststap, tot op het laagste niveau de rapportage.
  1. tip: om een leesbaarder rapport te krijgen, kan het handig zijn de HTML versie op te vragen (verander de "extensie" van .json naar .html):
  http://beta.validatie.geostandaarden.nl:8080/etf-webapp-2.0.0/v2/TestRuns/aaa57b47-0d8a-4d96-be97-8a713e6d7845.html
