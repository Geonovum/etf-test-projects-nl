# NL profiel metadata services v12 2016 INSPIRE

Dit bestand bevat logging informatie van het aanmaken van de validator.

Gebruikte XSLT tooling: command line saxonb-xslt (linux), een wrapper rondom de Saxon XSLT processor met Java.


Parameters:
```
tagId=293bc2ff-307c-428e-9538-35f4a06a8985
translationTemplateId=880b027c-181d-4a96-a801-07091528f9bf

xsd: eca698b3-0a5b-11e8-1863-09173f13e4c5
schematron: f21f2832-0a5b-11e8-d212-09173f13e4c5
```

Commando's:
```
cd ./include-metadata/

# TTB:

saxonb-xslt /home/thijs/code/Geonovum/ETF/github/etf-test-projects-nl/src/metadata/Nederlands\ profiel\ op\ ISO\ 19119\ v12\ INSPIRE\ 2016/schematron.sch /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/schematron_2_etf_translation_template_bundle.xsl testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e translationTemplateId=880b027c-181d-4a96-a801-07091528f9bf > TranslationTemplateBundle-EID880b027c-181d-4a96-a801-07091528f9bf.xml

# xsd validator
cd ../1_xsd/

saxonb-xslt ../include-metadata/Tag-EID293bc2ff-307c-428e-9538-35f4a06a8985.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-xsd-bsxets.xsl schemaURL=http://schemas.opengis.net/csw/2.0.2/profiles/apiso/1.0.0/apiso.xsd translationTemplateId=880b027c-181d-4a96-a801-07091528f9bf testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e > xsd-bsxets.xml

cd ../2_schematrontest/

saxonb-xslt /home/thijs/code/Geonovum/ETF/github/etf-test-projects-nl/src/metadata/Nederlands\ profiel\ op\ ISO\ 19119\ v12\ INSPIRE\ 2016/schematron.sch /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/schematron_2_etf_ets.xsl tagId=293bc2ff-307c-428e-9538-35f4a06a8985 translationTemplateId=880b027c-181d-4a96-a801-07091528f9bf testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e >  NederlandsprofielopISO19119v12-bsxets.xml
```

Noteer de UUIDs van de xsd en schematron ExecutableTestSuites. Gebruik ze voor 3_all:

```
cd ../3_all/

saxonb-xslt ../include-metadata/Tag-EID293bc2ff-307c-428e-9538-35f4a06a8985.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-all-xsd-schematron.xsl dependencyIdXsd=eca698b3-0a5b-11e8-1863-09173f13e4c5 dependencyIdSchematron=f21f2832-0a5b-11e8-d212-09173f13e4c5 translationTemplateId=880b027c-181d-4a96-a801-07091528f9bf testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e > all-bsxets.xml
```


## Voorbeelden opnieuw aanmaken validators, ivm fouten corrigeren
1. xsd

```
cd ../1_xsd/

saxonb-xslt ../include-metadata/Tag-EID293bc2ff-307c-428e-9538-35f4a06a8985.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-xsd-bsxets.xsl schemaURL=http://schemas.opengis.net/csw/2.0.2/profiles/apiso/1.0.0/apiso.xsd translationTemplateId=880b027c-181d-4a96-a801-07091528f9bf testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e etsId=eca698b3-0a5b-11e8-1863-09173f13e4c5 > xsd-bsxets.xml
```

1. Schematron, met dezelfde etsId de schematrontest genereren:

```
cd ../2_schematrontest/

saxonb-xslt /home/thijs/code/Geonovum/ETF/github/etf-test-projects-nl/src/metadata/Nederlands\ profiel\ op\ ISO\ 19119\ v12\ INSPIRE\ 2016/schematron.sch /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/schematron_2_etf_ets.xsl tagId=293bc2ff-307c-428e-9538-35f4a06a8985 translationTemplateId=880b027c-181d-4a96-a801-07091528f9bf testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e etsId=f21f2832-0a5b-11e8-d212-09173f13e4c5 >  NederlandsprofielopISO19119v12INSPIRE2016-bsxets.xml
```

1. all, verzameling:

```
cd ../3_all/

saxonb-xslt ../include-metadata/Tag-EID293bc2ff-307c-428e-9538-35f4a06a8985.xml /home/thijs/code/Geonovum/ETF/github/Geonovum_forks/etf-ets-repository/utils/etf-all-xsd-schematron.xsl dependencyIdXsd=eca698b3-0a5b-11e8-1863-09173f13e4c5 dependencyIdSchematron=f21f2832-0a5b-11e8-d212-09173f13e4c5 translationTemplateId=880b027c-181d-4a96-a801-07091528f9bf testObjectTypeId=5a60dded-0cb0-4977-9b06-16c6c2321d2e etsId=e994ea8c-0802-11e8-1038-09173f13e4c5 > all-bsxets.xml
```
