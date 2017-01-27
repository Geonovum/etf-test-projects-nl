2015-11-27 Johannes Echterhoff:

The XSL files represent the XSLT implementation for Schematron using an XSLT 1.0 processor. They have been downloaded from http://www.schematron.com end of November 2015 (exact link is http://www.schematron.com/tmp/iso-schematron-xslt1.zip) and include some extensions from interactive instruments (see files with 'ii_' prefix).

The .rnc and .rng files document SVRL, the output format for the XSL transformation that actually checks schematron against an XML file. They are not needed for processing schematron. They were used to develop the XQuery for schematron validation in ETF.

The validation process is split into several different XSLT stages which are executed by the evaluation XQuery.

