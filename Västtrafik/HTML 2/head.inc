<!DOCTYPE html>
<!--[if IEMobile 7 ]>    <html class="no-js iem7"  lang="sv" dir="ltr"> <![endif]-->
<!--[if (gt IEMobile 7)|!(IEMobile)]><!--> <html class="no-js" lang="sv" dir="ltr"> <!--<![endif]-->
    <head>
        <meta charset="utf-8">
        <title>Västtrafik mobil</title>
        <meta name="description" content="">
        <meta name="HandheldFriendly" content="True">
        <meta name="MobileOptimized" content="320">
        <meta name="viewport" content="width=device-width, initial-scale=1, maximum-scale=1, user-scalable=no">
        
        <meta name="apple-mobile-web-app-capable" content="yes" />
        
        <meta http-equiv="cleartype" content="on">

        <link rel="apple-touch-icon-precomposed" sizes="144x144" href="img/touch/apple-touch-icon-144x144-precomposed.png">
        <link rel="apple-touch-icon-precomposed" sizes="114x114" href="img/touch/apple-touch-icon-114x114-precomposed.png">
        <link rel="apple-touch-icon-precomposed" sizes="72x72" href="img/touch/apple-touch-icon-72x72-precomposed.png">
        <link rel="apple-touch-icon-precomposed" href="img/touch/apple-touch-icon-57x57-precomposed.png">
        <link rel="shortcut icon" href="img/touch/apple-touch-icon.png">

		<link rel="sitemap" type="application/xml" title="Sitemap" href="sitemap.xml" />

        <!-- Tile icon for Win8 (144x144 + tile color) -->
        <meta name="msapplication-TileImage" content="img/touch/apple-touch-icon-144x144-precomposed.png">
        <meta name="msapplication-TileColor" content="#222222">


        <!-- For iOS web apps. Delete if not needed. https://github.com/h5bp/mobile-boilerplate/issues/94 -->
        <!--
        <meta name="apple-mobile-web-app-capable" content="yes">
        <meta name="apple-mobile-web-app-status-bar-style" content="black">
        <meta name="apple-mobile-web-app-title" content="">
        -->

        <!-- This script prevents links from opening in Mobile Safari. https://gist.github.com/1042026 -->
        <!--
        <script>(function(a,b,c){if(c in b&&b[c]){var d,e=a.location,f=/^(a|html)$/i;a.addEventListener("click",function(a){d=a.target;while(!f.test(d.nodeName))d=d.parentNode;"href"in d&&(d.href.indexOf("http")||~d.href.indexOf(e.host))&&(a.preventDefault(),e.href=d.href)},!1)}})(document,window.navigator,"standalone")</script>
        -->

        <link rel="stylesheet" href="css/normalize.css">
		<link rel="stylesheet" href="css/main.css">

        <script src="js/vendor/modernizr-2.6.2.min.js"></script>
        
		<script src="http://ajax.googleapis.com/ajax/libs/jquery/2.0.3/jquery.min.js"></script><!-- needs fix for http/https -->
		<script>window.jQuery || document.write('<script src="js/vendor/jquery-2.0.3.min.js"><\/script>')</script>
		<script src="js/jquery.touchSwipe.min.js"></script>
		<script src="js/jquery.carouFredSel-6.2.1-packed.js"></script>

        <!--script>
		// Safari reports success of list attribute, so doing ghetto detection instead
		yepnope({
		  test : (!Modernizr.input.list || (parseInt($.browser.version) > 400)),
		  yep : [
		      'js/jquery.relevant-dropdown.js',
					'js/load-fallbacks.js'
		  ]
		});
		</script-->
<!--style type="text/css">
			* {font-family: Arial,Helvetica,sans-serif;}
			body {margin: 0; padding: 0;}
			
			

					</style-->
</head> 
	<body>
	<a id="top"></a>
		<div id="vt-container" class="closeMenu">
			<div id="menuContainer">
				<div id="menuHeader">
					<div id="loggedInHeader">
						<div class="left userIcon">b</div>
						<div class="left">
							<span class="loggedInAs">Inloggad som:</span>
							<span class="userName">Kalle Karlsson</span>
						</div>
						<div class="right">
							<a href="#" class="button logout-button">Logga ut</a>
						</div>
					</div>
					<div id="loggedOutHeader">
						<div class="left userIcon">b</div>
						<div class="left">
							<a href="#" class="button logout-button">Logga in på mina sidor</a>
						</div>
					</div>
				</div>
				<nav id="vt-menu" style="display: none;">
					<ul id="menuTree">
						<li>
							<a href="index.php" class="homeLink" title="Till hemskärmen"><span class="linkText">Hem</span></a>
						</li>
						<li>
							<a href="#"><span class="expand">d</span><span class="divider"></span><span class="linkText">Exempelsidor med väldigt lång titel</span></a>
							<ul>
								<li><a href="vanilla.php"><span class="linkText">Standardsida med alla grafiska element</span></a></li>
								<li><a href="trafikstorningar.php"><span class="linkText">Trafikstörningar</span></a></li>
								<li><a href="trafikstorning.php"><span class="linkText">En trafikstörning</span></a></li>
								<li><a href="reseplaneraren.php"><span class="linkText">Reseplaneraren</span></a></li>
								<li><a href="news.php"><span class="linkText">Nyheter</span></a></li>
								<li><a href="test.php"><span class="linkText">Testsida</span></a></li>
							</ul>
						</li>
						<li><a href="#"><span class="linkText">Företag</span></a></li>
						<li>
							<a href="http://www.gp.se"><span class="expand">d</span><span class="divider"></span><span class="linkText">Reseinformation</span></a>
							<ul>
								<li><a href="infoTravleGuide.php"><span class="linkText">Kollektivtrafikguide</span></a></li>
								<li><a href="infoCardReader.php"><span class="linkText">Om kortläsaren</span></a></li>
								<li><a href="#"><span class="linkText">Level 2</span></a></li>
								<li><a href="#"><span class="linkText">Level 2</span></a></li>
							</ul>
						</li>
						<li><a href="trafikstorningar.php"><span class="linkText">Trafikstörningar</span></a></li>
						<li>
							<a href="http://www.gp.se"><span class="expand">d</span><span class="divider"></span><span class="linkText">Biljetter och priser</span></a>
							<ul>
								<li><a href="#"><span class="linkText">Level 2</span></a></li>
								<li><a href="#"><span class="linkText">Level 2</span></a></li>
								<li><a href="#"><span class="linkText">Level 2</span></a></li>
								<li><a href="#"><span class="linkText">Level 2</span></a></li>
							</ul>
						</li>
						<li>
							<a href="#"><span class="expand">d</span><span class="divider"></span><span class="linkText">Om Västtrafik</span></a>
							<ul>
								<li><a href="#"><span class="linkText">Kontakt</span></a></li>
								<li><a href="news.php"><span class="linkText">Nyheter</span></a></li>
								<li><a href="#"><span class="linkText">Det här är västtrafik</span></a></li>
								<li><a href="#"><span class="linkText">Miljö</span></a></li>
								<li><a href="#"><span class="linkText">Trygghetspolicy</span></a></li>
							</ul>
						</li>
							<!-- TODO: Stefan :) OM inloggad gå till mina kort ... om en inloggad kör inloggning -->
						<li><a href="minaSidor.php"><span class="expand">d</span><span class="divider"></span><span class="linkText">Mina sidor</span></a>
							<ul>
								<li><a href="minaSidor-loggain.php"><span class="linkText">Logga in</span></a></li>
								<li><a href="minaSidor-minkort.php"><span class="linkText">Mina kort</span></a></li>
								<li><a href="minaSidor-glomtpw.php"><span class="linkText">Glömt lösenord</span></a></li>
								<li><a href="minaSidor-glomtanvid.php"><span class="linkText">Glömt användarnamn</span></a></li>
								<li><a href="minaSidor-PUL.php"><span class="linkText">Personuppgiftslagen</span></a></li>
							</ul>
						</li>
			
						<li><a href="#"><span class="linkText">Företag</span></a></li>
					</ul>
				</nav>
			</div>
						
			<header id="mainMenu">
				<a href="javascript:void(0);" class="button menu-button" id="menu" title="Visa meny" role="button">Meny</a>
				<a href="javascript:void(0);" class="icon magglas" title="Sök på mobilsajten" role="button"></a>
				<a href="index.php" class="vtLogo" title="Till hemskärmen" role="button"></a>
			</header>
			<div id="searchForm">
				<form action="searchResult.php">
					<fieldset>
						<div class="searchContainer">
							<div id="clearButton"><span></span></div>
							<label for="searchField" class="waiHide">Ange sökord för att söka på mobilsajten</label>
							<input id="searchField" type="text" class="searchBox" placeholder="Sök på hemsidan" required spellcheck="false" autocomplete="off" />
							<div id="searchButton" role="button">
								<span>Sök</span>
							</div>
						</div>
					</fieldset>
				</form>
				<div class="searchInfo">
					<h4>Letar du efter resa?</h4>
					<p>
						<a href="reseplaneraren.php">Använd reseplaneraren</a>
					</p>
				</div>
			</div>
			<div id="vt-pusher">
				<div id="vt-overlay"></div>
				<div class="vt-content" id="mainContent"><!-- this is the wrapper for the content -->
					<?php if (stripos($_SERVER['REQUEST_URI'], 'index.php')){ 
						// php script to add this to the first page only
						// The link needs to be hooked to a javascript that sets a cookie and remembers what alert has been closed ...
						//add class perm to topAlert for permanet REDALERT 
							
						?>
						<div class="topAlert">
							<table id="topAlertTable">
								<tr>
									<td class="alertText">
										Avenyn är avstängd för spårvagnstrafik 2-22 september. Och det innebär en massa problem. Så tänkt inte ens tanken att åka spårvagn under den tiden. Avenyn är avstängd för spårvagnstrafik 2-22 september. Och det innebär en massa problem. Så tänkt inte ens tanken att åka spårvagn under den tiden. Avenyn är avstängd för spårvagnstrafik 2-22 september. Och det innebär en massa problem. Så tänkt inte ens tanken att åka spårvagn under den tiden.
									</td>
									<td class="alertClose">
										<a class="topAlertClose" href="#">g</a>
									</td>
								</tr>
							</table>
						</div>
					<?php } ?>
					<div id="contentWrapper">