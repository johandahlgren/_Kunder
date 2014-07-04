<?php include 'head.inc'; ?>
	
<section id="reseplaneraren">
	<div class="startPageTripFinder">
		<div class="tripFinderTop">Reseplaneraren</div>
		<div class="findTrip">Sök resa</div>
		<div class="nextTrip">Nästa tur</div>
	</div>
</section>

<section id="newsfeed">
	<div class="startPageSectionHeader">
		<span class="icon">a</span>
		<a href="#" class="title">Nyheter</a>
		<div class="cardSwiperPagination"></div>
	</div>
	<ul class="cardRoller">
		<li class="card" data-target="newsDetail.php">
			<div class="cardImage" style="background-image: url('http://lorempixel.com/200/150/nature');" alt="bild1" ></div>
			<span class="cardTitle">Lorem ipsum dolor sit amet, consectetur</span><br/>
			<p class="cardText">Nisl iaculis tincidunt penatibus ut&hellip; </p>
		</li>
		<li class="card" data-target="newsDetail.php">
			<div class="cardImage" style="background-image: url('http://lorempixel.com/100/200/nature');" alt="bild3" /></div>
			<span class="cardTitle">Instantum illuminaris abraxas</span>
			<p class="cardText">Nisl iaculis tincidunt.</p>
		</li>
		<li class="card" data-target="newsDetail.php">
			<div class="cardImage" style="background-image: url('http://lorempixel.com/300/120/nature');" alt="bild2" /></div>
			<span class="cardTitle">Dolor sit amet</span>
			<p class="cardText">Nisl iaculis tincidunt penatibus ut plopp&hellip; </p>
		</li>
		<li class="card" data-target="newsDetail.php">
			<div class="cardImage" style="background-image: url('http://lorempixel.com/150/150/nature');" alt="bild4" /></div>
			<span class="cardTitle">Lorem ipsum dolor sit</span>
			<p class="cardText">Nisl iaculis tincidunt.</p>
		</li>
	</ul>
	<a href="news.php" class="showAll">Se alla nyheter</a>
</section>

<section id="trafficSituations">
	<div class="startPageSectionHeader">
		<span class="icon">b</span>
		<a href="#" class="title">Trafikstörningar</a>
		<div class="cardSwiperPagination"></div>
	</div>
	<ul class="cardRoller">
		<li class="card cardPadding" data-target="trafikstorning.php">
			<div class="lines">
				<span class="BEXSVART">SVART</span><span class="TRAM6">6</span><span class="TRAM11">11</span>
			</div>
			<div class="cardLink warning">På grund av ett spårarbete påverkas kollektivtrafiken&hellip;</div>
		</li>
		<li class="card cardPadding" data-target="trafikstorning.php">
			<div class="lines">
				<span class="TRAM1">1</span><span class="TRAM2">2</span>
			</div>
			<div class="cardLink severe">Allt har pajjat&hellip;</div>
		</li>
		<li class="card cardPadding" data-target="trafikstorning.php">
			<div class="lines">
				<span class="BEXGRON">GRÖN</span>
			</div>
			<div class="cardLink">På grund av ett spårarbete påverkas kollektivtrafiken&hellip;</div>
		</li>
	</ul>
	<a href="trafikstorningar.php" class="showAll">Se alla trafikstörningar</a>
</section>

<section id="banner">
	<img alt="Kom igång med sms-biljett" src="http://www.vasttrafik.se/Global/Banners/smspuff.png">
</section>

<?php include 'foot.inc'; ?>