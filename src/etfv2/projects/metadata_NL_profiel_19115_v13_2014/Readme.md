This directory contains subdirectories with four Executable Test Suites:
- **1_geometrytest** uses the [GmlGeoX library](http://docs.etf-validator.net/Developer_manuals/Developing_Executable_Test_Suites.html#spatial-tests) to test spatial aspects
- **2_xsdandgmlencoding** uses the internal Xerces validator to [validate against a schema file](https://github.com/interactive-instruments/etf-ets-repository/blob/master/example/2_xsdandgmlencoding/xsdandgmlencoding-bsxets.xml#L72)
- **3_schematrontest** has been transformed from a [schematron](https://github.com/interactive-instruments/etf-ets-repository/blob/master/example/3_schematrontest/schematron.sch) file using [this Stylesheet](https://github.com/interactive-instruments/etf-ets-repository/blob/master/utils/schematron_2_etf.xsl)
- **4_all** shows how other Executable Test Suites can be set as [dependencies](https://github.com/interactive-instruments/etf-ets-repository/blob/master/example/4_all/all-bsxets.xml#L40-L44)

The **include-metadata** directory contains a Translation Template Bundle, one Tag and a Statistical Report Table Types which are used by the Executable Test Suites.
