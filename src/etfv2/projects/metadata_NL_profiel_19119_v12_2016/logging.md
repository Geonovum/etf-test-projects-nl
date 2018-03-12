# NL profiel metadata services v12 2016
Params:
```
tagId=11351082-200a-4fc1-8c4f-733cb9137365
translationTemplateId=5f9f1c84-03cd-475b-9a1c-a1a04abca04e

xsd: ff0ad733-0800-11e8-1863-09173f13e4c5
schematron: 2d679502-0802-11e8-d212-09173f13e4c5


```

```
cd ./include-metadata/

# TTB:

saxonb-xslt /home/thijs/code/Geonovum/ETF/github/etf-test-projects-nl/src/metadata/Nederlands\ profiel\ op\ ISO\ 19119\ v12\ 2016/schematron.sch /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/schematron_2_etf_translation_template_bundle.xsl testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e translationTemplateId=5f9f1c84-03cd-475b-9a1c-a1a04abca04e > TranslationTemplateBundle-EID5f9f1c84-03cd-475b-9a1c-a1a04abca04e.xml

# xsd validator
cd ../1_xsd/

saxonb-xslt ../include-metadata/Tag-EID11351082-200a-4fc1-8c4f-733cb9137365.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-xsd-bsxets.xsl schemaURL=http://schemas.opengis.net/csw/2.0.2/profiles/apiso/1.0.0/apiso.xsd translationTemplateId=5f9f1c84-03cd-475b-9a1c-a1a04abca04e testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e > xsd-bsxets.xml

cd ../2_schematrontest/

saxonb-xslt /home/thijs/code/Geonovum/ETF/github/etf-test-projects-nl/src/metadata/Nederlands\ profiel\ op\ ISO\ 19119\ v12\ 2016/schematron.sch /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/schematron_2_etf_ets.xsl tagId=11351082-200a-4fc1-8c4f-733cb9137365 translationTemplateId=5f9f1c84-03cd-475b-9a1c-a1a04abca04e testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e >  NederlandsprofielopISO19119v12-bsxets.xml
```

Noteer de UUIDs van de xsd en schematron ExecutableTestSuites. Gebruik ze voor 3_all:

```
cd ../3_all/

saxonb-xslt ../include-metadata/Tag-EID11351082-200a-4fc1-8c4f-733cb9137365.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-all-xsd-schematron.xsl dependencyIdXsd=ff0ad733-0800-11e8-1863-09173f13e4c5 dependencyIdSchematron=2d679502-0802-11e8-d212-09173f13e4c5 translationTemplateId=5f9f1c84-03cd-475b-9a1c-a1a04abca04e testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e > all-bsxets.xml
```

## Opnieuw aanmaken bestaande validators
Bijvoorbeeld vanwege fouten of een update.

1. Schematron: met dezelfde etsId de schematrontest genereren

```
cd ../2_schematrontest/

saxonb-xslt /home/thijs/code/Geonovum/ETF/github/etf-test-projects-nl/src/metadata/Nederlands\ profiel\ op\ ISO\ 19119\ v12\ 2016/schematron.sch /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/schematron_2_etf_ets.xsl tagId=11351082-200a-4fc1-8c4f-733cb9137365 translationTemplateId=5f9f1c84-03cd-475b-9a1c-a1a04abca04e testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e etsId=2d679502-0802-11e8-d212-09173f13e4c5 >  NederlandsprofielopISO19119v12-bsxets.xml
```

1. xsd validator:

```
cd ../1_xsd/

saxonb-xslt ../include-metadata/Tag-EID11351082-200a-4fc1-8c4f-733cb9137365.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-xsd-bsxets.xsl schemaURL=http://schemas.opengis.net/csw/2.0.2/profiles/apiso/1.0.0/apiso.xsd translationTemplateId=5f9f1c84-03cd-475b-9a1c-a1a04abca04e testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e etsId=ff0ad733-0800-11e8-1863-09173f13e4c5 > xsd-bsxets.xml
```

1. all:

```
cd ../3_all/

saxonb-xslt ../include-metadata/Tag-EID11351082-200a-4fc1-8c4f-733cb9137365.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-all-xsd-schematron.xsl dependencyIdXsd=ff0ad733-0800-11e8-1863-09173f13e4c5 dependencyIdSchematron=2d679502-0802-11e8-d212-09173f13e4c5 translationTemplateId=5f9f1c84-03cd-475b-9a1c-a1a04abca04e testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e etsId=e994ea8c-0802-11e8-1038-09173f13e4c5 > all-bsxets.xml
```
