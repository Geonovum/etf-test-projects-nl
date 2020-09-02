<html>
<head><title>Herstart validator software aanvraag</title>
</head>
<body>
<?php
$secret=$_GET["secret"];
if ($secret=="XXXXX" ){
    // echo "Start draaien, heb geduld en keer terug naar de vorige pagina";
    // if ($csw=="inspire") {
    $output = shell_exec('/opt/etf-install/bin/removecorruptbsxdatabase.sh');
    // echo "<pre>$output</pre>";
    // print shell_exec( 'sudo whoami' );
    $content = "cleanup and restart";
    $fp = fopen($_SERVER['DOCUMENT_ROOT'] . "/restart/restart.txt","wb");
    fwrite($fp,$content);
    fclose($fp);
    //     header( 'Location: /' ) ; // TODO: set correct location for www
    print "Opschonen en herstart aangevraagd, het kan even duren voordat dit draait";
    ?>
    <a href="/etf-webapp/testprojects?testdomain=">naar de validator</a>
<?php
} else {
    header( 'Location: start.php?error=Wachtwoord ongeldig' ) ;
}
?>
<h2>Naar de validator</h2>
<a href="/etf-webapp/testprojects?testdomain=">Naar de validator</a>
</body>
