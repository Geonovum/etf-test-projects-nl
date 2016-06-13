<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" schemaVersion="2" queryBinding="xslt2">
    <ns uri="http://www.geostandaarden.nl/imgeo/2.1/stuf-imgeo/1.3" prefix="imgeo"/>
    <ns uri="http://www.geostandaarden.nl/imgeo/2.1/stuf-imgeo/1.3" prefix="stuf-geo"/>
    <ns uri="http://www.egem.nl/StUF/StUF0301" prefix="StUF"/>
    <ns uri="http://www.opengis.net/gml" prefix="gml"/>
    <ns uri="http://www.w3.org/2001/XMLSchema-instance" prefix="xsi"/>
    
    <pattern>
        
        <!--<rule context="imgeo:*/gml:*">
             GEOM2 
            <assert test="@srsName='urn:opengis:def:crs:EPSG::28992'">
                geometrie moet in Rijksdriehoekstelsel zijn.
            </assert>
            GEOM3
            <assert test="@srsDimension='2'">
                geometrie moet tweedimensionaal zijn
            </assert>
        </rule>-->
        
        <rule id="ControlesWijzigingKennisgeving" context="imgeo:object[1][../imgeo:parameters/StUF:mutatiesoort=('F')]">
            
            <!-- AMD1 -->
            <assert id="IdentificatieWASenWORDT" test="imgeo:identificatie/imgeo:lokaalID = following-sibling::imgeo:object/imgeo:identificatie/imgeo:lokaalID">
                Identificatie in WAS moet gelijk zijn aan identificatie in WORDT (lokaalID <value-of select="imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!-- ADM5 -->
            <assert test="StUF:tijdstipRegistratie &lt; following-sibling::imgeo:object/StUF:tijdstipRegistratie">
                tijdstipRegistratie WORDT moet later zijn dan tijdstipRegistratie WAS (lokaalID <value-of select="imgeo:identificatie/imgeo:lokaalID"/>). 
           </assert>
            
        </rule>
        
        <rule context="StUF:tijdstipRegistratie">
            <let name="date" value="concat(substring(., 1, 4), '-', substring(., 5, 2), '-', substring(., 7, 2))"/>
            <let name="time" value="concat(substring(., 9, 2), ':', substring(., 11, 2), ':', substring(., 13, 2), if (string-length() > 14) then concat('.', substring(., 15)) else())"/>
            <let name="dateTime" value="if ($time) then concat($date, 'T', $time) else()"/>
            
            <!-- ADM2 -->            
            <assert test="$dateTime castable as xs:dateTime? ">
                tijdstipRegistratie moet geldig formaat hebben (yyyymmddHHiissuuu) (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!-- ADM3 -->
            <assert test="if ($dateTime castable as xs:dateTime?) then xs:dateTime($dateTime) &lt; current-dateTime() else ($date)">
                tijdstipRegistratie moet in verleden liggen (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!-- ADM4 -->
            <assert test="if (../../imgeo:parameters/StUF:mutatiesoort = 'T' and $date castable as xs:date?) then xs:date($date) = xs:date(../imgeo:creationDate)
                            else ($date)">
                tijdstipRegistratie moet gelijk zijn aan objectBegintijd (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>). 
            </assert>
                   
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='WGD']">            
            <!--  ADM6 voor Wegdeel -->
            <assert test="not(imgeo:kruinlijnWegdeel/* and (imgeo:wegdeelOpTalud='0' or imgeo:wegdeelOpTalud='false'))">
                Als een object een kruinlijngeometrie heeft, moet het kenmerk ‘opTalud’ waarde “Ja” bevatten (lokaalID <value-of select="imgeo:identificatie/imgeo:lokaalID"/>). 
            </assert>
        </rule>        
        <rule context="imgeo:object[@StUF:entiteittype='OWG']">            
            <!--  ADM6 voor OndersteunendWegdeel  -->
            <assert test="not(imgeo:kruinlijnOndersteunendWegdeel/* and (imgeo:ondersteunendWegdeelOpTalud='0' or imgeo:ondersteunendWegdeelOpTalud='false'))">
                Als een object een kruinlijngeometrie heeft, moet het kenmerk ‘opTalud’ waarde “Ja” bevatten (lokaalID <value-of select="imgeo:identificatie/imgeo:lokaalID"/>). 
            </assert>
        </rule>        
        <rule context="imgeo:object[@StUF:entiteittype='OTD']">            
            <!--  ADM6 voor OnbegroeidTerreindeel -->
            <assert test="not(imgeo:kruinlijnOnbegroeidTerreindeel/* and (imgeo:onbegroeidTerreindeelOpTalud='0' or imgeo:onbegroeidTerreindeelOpTalud='false'))">
                Als een object een kruinlijngeometrie heeft, moet het kenmerk ‘opTalud’ waarde “Ja” bevatten (lokaalID <value-of select="imgeo:identificatie/imgeo:lokaalID"/>). 
            </assert>
        </rule>        
        <rule context="imgeo:object[@StUF:entiteittype='BTD']">            
            <!--  ADM6 voor BegroeidTerreindeel -->
            <assert test="not(imgeo:kruinlijnBegroeidTerreindeel/* and (imgeo:begroeidTerreindeelOpTalud='0' or imgeo:begroeidTerreindeelOpTalud='false'))">
                Als een object een kruinlijngeometrie heeft, moet het kenmerk ‘opTalud’ waarde “Ja” bevatten (lokaalID <value-of select="imgeo:identificatie/imgeo:lokaalID"/>). 
            </assert>
        </rule>
                
        <rule context="*[@xsi:nil='true']">
            <!-- ADM7 -->
            <assert test="normalize-space(@StUF:noValue)">
                als xsi:nil de waarde ‘true’ heeft moet StUF:noValue zijn ingevuld (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>            
    </pattern>
    
    <pattern id="codespaces" fpi="codespaces-fpi">
        <!-- BGT CODELIST VALIDATIE -->
        <let name="codelists" value="('http://www.geostandaarden.nl/imgeo/def/2.1#Status', 'http://www.geostandaarden.nl/imgeo/def/2.1#FunctieWeg', 'http://www.geostandaarden.nl/imgeo/def/2.1#FysiekVoorkomenWeg', 'http://www.geostandaarden.nl/imgeo/def/2.1#FunctieOndersteunendWegdeel', 'http://www.geostandaarden.nl/imgeo/def/2.1#FysiekVoorkomenOndersteunendWegdeel', 'http://www.geostandaarden.nl/imgeo/def/2.1#FunctieSpoor', 'http://www.geostandaarden.nl/imgeo/def/2.1#FysiekVoorkomenOnbegroeidTerrein', 'http://www.geostandaarden.nl/imgeo/def/2.1#FysiekVoorkomenBegroeidTerrein', 'http://www.geostandaarden.nl/imgeo/def/2.1#TypeWater', 'http://www.geostandaarden.nl/imgeo/def/2.1#TypeOndersteunendWaterdeel', 'http://www.geostandaarden.nl/imgeo/def/2.1#TypeOverigBouwwerk', 'http://www.geostandaarden.nl/imgeo/def/2.1#TypeKunstwerk', 'http://www.geostandaarden.nl/imgeo/def/2.1#TypeScheiding', 'http://www.geostandaarden.nl/imgeo/def/2.1#TypeOpenbareRuimte', 'http://www.geostandaarden.nl/imgeo/def/2.1#TypeFunctioneelGebied', 'http://www.geostandaarden.nl/imgeo/def/2.1#Inwinningsmethode')"/>
        
        <rule context="imgeo:object/imgeo:bgt-status">
            <let name="codelisturi" value="'http://www.geostandaarden.nl/imgeo/def/2.1#Status'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'bestaand' )">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='WGD']/imgeo:bgt-functie">
            <let name="codelisturi" value="'http://www.geostandaarden.nl/imgeo/def/2.1#FunctieWeg'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>). 
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'OV-baan' or normalize-space(.) = 'overweg' or normalize-space(.) = 'spoorbaan' or normalize-space(.) = 'baan voor vliegverkeer' or normalize-space(.) = 'rijbaan autosnelweg' or normalize-space(.) = 'rijbaan autoweg' or normalize-space(.) = 'rijbaan regionale weg' or normalize-space(.) = 'rijbaan lokale weg' or normalize-space(.) = 'fietspad' or normalize-space(.) = 'voetpad' or normalize-space(.) = 'voetpad op trap' or normalize-space(.) = 'ruiterpad' or normalize-space(.) = 'parkeervlak' or normalize-space(.) = 'voetgangersgebied' or normalize-space(.) = 'inrit' or normalize-space(.) = 'woonerf' or normalize-space(.) = 'transitie')">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='WGD']/imgeo:bgt-fysiekVoorkomen">
            <let name="codelisturi"
                value="'http://www.geostandaarden.nl/imgeo/def/2.1#FysiekVoorkomenWeg'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>            
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).  
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'gesloten verharding' or normalize-space(.) = 'open verharding' or normalize-space(.) = 'half verhard' or normalize-space(.) = 'onverhard' or normalize-space(.) = 'transitie')">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='OWG']/imgeo:bgt-functie">
            <let name="codelisturi"
                value="'http://www.geostandaarden.nl/imgeo/def/2.1#FunctieOndersteunendWegdeel'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).  
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'verkeerseiland' or normalize-space(.) = 'berm' or normalize-space(.) = 'transitie')">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='OWG']/imgeo:bgt-fysiekVoorkomen">
            <let name="codelisturi"
                value="'http://www.geostandaarden.nl/imgeo/def/2.1#FysiekVoorkomenOndersteunendWegdeel'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).  
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'gesloten verharding' or normalize-space(.) = 'open verharding' or normalize-space(.) = 'half verhard' or normalize-space(.) = 'onverhard' or normalize-space(.) = 'transitie')">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='SPR']/imgeo:bgt-functie">
            <let name="codelisturi"
                value="'http://www.geostandaarden.nl/imgeo/def/2.1#FunctieSpoor'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).  
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'trein' or normalize-space(.) = 'sneltram' or normalize-space(.) = 'tram' or normalize-space(.) = 'transitie')">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='OTD']/imgeo:bgt-fysiekVoorkomen">
            <let name="codelisturi"
                value="'http://www.geostandaarden.nl/imgeo/def/2.1#FysiekVoorkomenOnbegroeidTerrein'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).  
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'zand' or normalize-space(.) = 'gesloten verharding' or normalize-space(.) = 'open verharding' or normalize-space(.) = 'half verhard' or normalize-space(.) = 'onverhard' or normalize-space(.) = 'erf' or normalize-space(.) = 'transitie')">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='BTD']/imgeo:bgt-fysiekVoorkomen">
            <let name="codelisturi"
                value="'http://www.geostandaarden.nl/imgeo/def/2.1#FysiekVoorkomenBegroeidTerrein'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).  
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'loofbos' or normalize-space(.) = 'gemengd bos' or normalize-space(.) = 'naaldbos' or normalize-space(.) = 'heide' or normalize-space(.) = 'struiken' or normalize-space(.) = 'houtwal' or normalize-space(.) = 'duin' or normalize-space(.) = 'moeras' or normalize-space(.) = 'rietland' or normalize-space(.) = 'kwelder' or normalize-space(.) = 'fruitteelt' or normalize-space(.) = 'boomteelt' or normalize-space(.) = 'bouwland' or normalize-space(.) = 'grasland agrarisch' or normalize-space(.) = 'grasland overig' or normalize-space(.) = 'groenvoorziening' or normalize-space(.) = 'transitie')">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='WTD']/imgeo:bgt-type">
            <let name="codelisturi" value="'http://www.geostandaarden.nl/imgeo/def/2.1#TypeWater'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).  
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'zee' or normalize-space(.) = 'waterloop' or normalize-space(.) = 'watervlakte' or normalize-space(.) = 'greppel, droge sloot' or normalize-space(.) = 'transitie')">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='OWT']/imgeo:bgt-type">
             <let name="codelisturi"
                value="'http://www.geostandaarden.nl/imgeo/def/2.1#TypeOndersteunendWaterdeel'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).  
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'oever, slootkant' or normalize-space(.) = 'slik' or normalize-space(.) = 'transitie')">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='OBW']/imgeo:bgt-type">
            <let name="codelisturi"
                value="'http://www.geostandaarden.nl/imgeo/def/2.1#TypeOverigBouwwerk'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).  
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'overkapping' or normalize-space(.) = 'open loods' or normalize-space(.) = 'opslagtank' or normalize-space(.) = 'bezinkbak' or normalize-space(.) = 'windturbine' or normalize-space(.) = 'lage trafo' or normalize-space(.) = 'bassin' or normalize-space(.) = 'transitie' or normalize-space(.) = 'niet-bgt')">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>)
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='KWD']/imgeo:bgt-type">
            <let name="codelisturi"
                value="'http://www.geostandaarden.nl/imgeo/def/2.1#TypeKunstwerk'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).  
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'hoogspanningsmast' or normalize-space(.) = 'gemaal' or normalize-space(.) = 'perron' or normalize-space(.) = 'sluis' or normalize-space(.) = 'strekdam' or normalize-space(.) = 'steiger' or normalize-space(.) = 'stuw' or normalize-space(.) = 'transitie' or normalize-space(.) = 'niet-bgt')">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='SHD']/imgeo:bgt-type">
            <let name="codelisturi"
                value="'http://www.geostandaarden.nl/imgeo/def/2.1#TypeScheiding'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).  
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'muur' or normalize-space(.) = 'kademuur' or normalize-space(.) = 'geluidsscherm' or normalize-space(.) = 'damwand' or normalize-space(.) = 'walbescherming' or normalize-space(.) = 'hek' or normalize-space(.) = 'transitie' or normalize-space(.) = 'niet-bgt')">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='ORL']/imgeo:openbareRuimteType">
            <let name="codelisturi"
                value="'http://www.geostandaarden.nl/imgeo/def/2.1#TypeOpenbareRuimte'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).  
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and normalize-space(.) = 'Weg' or normalize-space(.) = 'Water' or normalize-space(.) = 'Spoorbaan' or normalize-space(.) = 'Terrein' or normalize-space(.) = 'Kunstwerk' or normalize-space(.) = 'Landschappelijk gebied' or normalize-space(.) = 'Administratief gebied')">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>
        
        <rule context="imgeo:object[@StUF:entiteittype='FUG']/imgeo:bgt-type">
            <let name="codelisturi"
                value="'http://www.geostandaarden.nl/imgeo/def/2.1#TypeFunctioneelGebied'"/>
            
            <!--DMW1-->
            <assert test="@codeSpace = $codelists">
                bgt-kenmerk moet een bestaande domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
            
            <!--DMW2-->
            <assert test="normalize-space(@codeSpace) = $codelisturi">
                bgt-kenmerk moet geldige domeinwaardenlijst voor dit kenmerk bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).  
            </assert>
            
            <!--DMW3-->
            <assert test="normalize-space(@codeSpace) != $codelisturi or (normalize-space(@codeSpace) = $codelisturi and (normalize-space(.) = 'kering' or  normalize-space(.) = 'niet-bgt'))">
                bgt-kenmerk moet waarde uit domeinwaardenlijst bevatten (lokaalID <value-of select="../imgeo:identificatie/imgeo:lokaalID"/>).
            </assert>
        </rule>

    </pattern>
</schema>