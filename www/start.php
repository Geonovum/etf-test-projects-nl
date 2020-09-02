<html>
<head><title>Herstart validator software</title>
</head>
<body>
<h1>Herstart validator software</h1>
<p>
Via deze pagina kan de validator software van ETF opgeschoond worden (bij een corrupte XML database) en daarna herstart.
</p>

<form action="cleanup.php" method="get">
Voor het uitvoeren van de test, voer hieronder het wachtwoord in. Daarna wordt de herstart op de server aangevraagd en na enkele seconden uitgevoerd.
<br/>
<br/>
<em>Let op: bij een herstart is de validator mogelijk enkele minuten offline.</em>
</p>
<p>
Wachtwoord: <input type="password" size="20" name="secret"/> &nbsp; <input type="submit" value="Service herstarten"/>
</p>
<?php
$error=$_GET["error"];
if ($error) {
    echo "<h2>".$error."</h2>";
}
?>
</form>
<h2>Naar de validator</h2>
<a href="/etf-webapp/">Naar de validator</a>
</body>
