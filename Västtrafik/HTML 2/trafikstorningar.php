<?php include 'head.inc'; ?>
		<!--style>
			.box-container form select {
				width: 90%;

	   border: 1px solid #555;
	   padding: 0.5em;
	   font-size: 15px;
     line-height: 1.2em;
     background: #fff;
     background: -webkit-gradient(linear, left top, left bottom, from(#fff), to(#ccc));
     -webkit-appearance: none;
 	   -webkit-box-shadow: 1px 1px 1px #fff;
 	   -webkit-border-radius: 0.5em;fff;
   -webkit-border-radius: 0.5em;
			}
		http://cssdeck.com/labs/styling-select-box-with-css3
		</style-->

<script language="javascript">
$(document).ready(function() {
	$('#switch').click(function(event){
		event.preventDefault();
		if(!$('#togglebtn').hasClass('kommande')){
			$('#btnMarker').animate(
				{ left: "50%" }, 200, function() {
				$('#togglebtn').addClass('kommande');
			});
		} else {
			$('#btnMarker').animate(
				{ left: "0%" }, 200, function() {
				$('#togglebtn').removeClass('kommande');
			});
		}
		$('#trafficSituation').toggle();
		$('#commingTrafficSituation').toggle();
	});
});
</script>
							<section id="tsList">
								<h1>Trafikstörningar</h1>
								<div class="box-container">
									<form><!-- //TODO: Behöver trigger för att filtrera på kommun -->
										<label for="location" class="waiHide">Filtrera ev störningar på kommun</label>
										<select id="location">
											<option value="0" selected="selected">Alla kommuner</option>
											<option value="37">Ale</option>
											<option value="6">Alingsås</option>
											<option value="58">Bengtsfors</option>
										</select>
									</form>
									<div id="togglebtn" role="button" title="Ändra mellan aktuella och kommande störnings-lista">
										<a href="#" id="switch"><span>Aktuella</span><span>Kommande</span><div id="btnMarker">&nbsp;</div></a>
									</div>
								</div>
	
								<ul class="trafficSituation" id="trafficSituation">
									<li>
										<div class="lines">
											<a href="#" class="BEXSVART">SVART</a><a href="#" class="TRAM6">6</a><a href="#" class="TRAM11">11</a>
										</div>
										<a href="trafikstorning.php" class="tsHeadline sNormal">På grund av ett spårarbete påverkas Brunnsparken från den 2 september</a>
									</li>
									<li>
										<div class="lines">
											<a href="#" class="BEXGRON">GRÖN</a><a href="#" class="TRAM1">1</a><a href="#" class="BUS">111</a>
										</div>
										<a href="trafikstorning.php" class="tsHeadline sSevere">På grund av ett spårarbete påverkas kollektivtrafiken mellan Brunnsparken och Korsvägen från den 2 september</a>				
									</li>
									<li>
										<div class="lines">
											<a href="#" class="BEXGRON">GRÖN</a><a href="#" class="TRAM6">6</a><a href="#" class="TRAM11">11</a>
										</div>
										<a href="trafikstorning.php" class="tsHeadline">På grund av ett spårarbete påverkas kollektivtrafiken mellan Brunnsparken och Korsvägen från den 2 september</a>				
									</li>
									<li>
										<div class="lines">
											<a href="#" class="BEXSVART">SVART</a><a href="#" class="TRAM6">6</a><a href="#" class="TRAM11">11</a>
										</div>
										<a href="trafikstorning.php" class="tsHeadline">På grund av ett spårarbete påverkas kollektivtrafiken mellan Brunnsparken och Korsvägen från den 2 september</a>				
									</li>
									<li>
										<div class="lines">
											<a href="#" class="BEXSVART">SVART</a><a href="#" class="TRAM6">6</a><a href="#" class="TRAM11">11</a>
										</div>
										<a href="trafikstorning.php" class="tsHeadline">På grund av ett spårarbete påverkas kollektivtrafiken mellan Brunnsparken och Korsvägen från den 2 september</a>				
									</li>
									<li>
										<div class="lines">
											<a href="#" class="FERRY">Färja</a>
											<a href="#" class="BUS">Buss generell</a>
											<a href="#" class="TRAIN">TÅG generell</a>
											<a href="#" class="TRAINNSB">Nsb regiontåg</a>
											<a href="#" class="TRAINPENDEL">Pendeltåg</a>
											<a href="#" class="TRAINSJREG">SJ regional</a>
											<a href="#" class="TRAINTAGAB">Tågab regiontåg</a>
											<a href="#" class="TRAINWEST">Västtågen</a>
											<a href="#" class="BEXBLA">BLÅ</a>
											<a href="#" class="BEXGUL">GUL</a>
											<a href="#" class="BEXLILA ">LILA</a>
											<a href="#" class="BEXORANGE ">ORANGE</a>
											<a href="#" class="BEXROSA ">ROSA</a>
											<a href="#" class="BEXROD">RÖD</a>
											<a href="#" class="BEXGRON">GRÖN</a>
											<a href="#" class="BEXLS">Lerum-snabben</a>
											<a href="#" class="BEXMARS">Marstrand express</a>
											<a href="#" class="BEXONSALA">Onsala-snabben</a>
											<a href="#" class="BEXERSTAG">Ersätter tåg</a>
											<a href="#" class="BEXORUST">Orust express</a>
											<a href="#" class="BEXSVART">SVART</a>
											<a href="#" class="TRAM1">1</a>
											<a href="#" class="TRAM2">2</a>
											<a href="#" class="TRAM3">3</a>
											<a href="#" class="TRAM4">4</a>
											<a href="#" class="TRAM5">5</a>
											<a href="#" class="TRAM6">6</a>
											<a href="#" class="TRAM7">7</a>
											<a href="#" class="TRAM8">8</a>
											<a href="#" class="TRAM9">9</a>
											<a href="#" class="TRAM10">10</a>
											<a href="#" class="TRAM11">11</a>
											<a href="#" class="TRAM13">13</a>
										</div>
										<a href="trafikstorning.php" class="tsHeadline">På grund av ett spårarbete påverkas kollektivtrafiken mellan Brunnsparken och Korsvägen från den 2 september</a>				
									</li>
								</ul>
								<ul class="trafficSituation" id="commingTrafficSituation" style="display:none;">
									<li>
										<div class="lines">
											<a href="#" class="TRAM10">10</a><a href="#" class="BEXSVART">SVART</a<a href="#" class="TRAM11">11</a><a href="#" class="BEXONSALA">Onsala-snabben</a>
										</div>
										<a href="trafikstorning.php" class="tsHeadline sNormal">Nästa vecka så kommer det att vara demonstration på redbergsplatsen. Detta medför att ...</a>
									</li>
									<li>
										<div class="lines">
											<a href="#" class="BEXGRON">GRÖN</a><a href="#" class="TRAM1">1</a><a href="#" class="BUS">111</a>
										</div>
										<a href="trafikstorning.php" class="tsHeadline sSevere">På grund av ett spårarbete påverkas kollektivtrafiken mellan Brunnsparken och Korsvägen från den 2 september</a>				
									</li>
									<li>
										<div class="lines">
											<a href="#" class="BEXGRON">GRÖN</a><a href="#" class="TRAM6">6</a><a href="#" class="TRAM11">11</a>
										</div>
										<a href="trafikstorning.php" class="tsHeadline">På grund av ett spårarbete påverkas kollektivtrafiken mellan Brunnsparken och Korsvägen från den 2 september</a>				
									</li>
									<li>
										<div class="lines">
											<a href="#" class="BEXSVART">SVART</a><a href="#" class="TRAM6">6</a><a href="#" class="TRAM11">11</a>
										</div>
										<a href="trafikstorning.php" class="tsHeadline">På grund av ett spårarbete påverkas kollektivtrafiken mellan Brunnsparken och Korsvägen från den 2 september</a>				
									</li>
									<li>
										<div class="lines">
											<a href="#" class="BEXSVART">SVART</a><a href="#" class="TRAM6">6</a><a href="#" class="TRAM11">11</a>
										</div>
										<a href="trafikstorning.php" class="tsHeadline">På grund av ett spårarbete påverkas kollektivtrafiken mellan Brunnsparken och Korsvägen från den 2 september</a>				
									</li>
									<li>
										<div class="lines">
											<a href="#" class="FERRY">Färja</a>
											<a href="#" class="BUS">Buss generell</a>
											<a href="#" class="TRAIN">TÅG generell</a>
											<a href="#" class="TRAINNSB">Nsb regiontåg</a>
											<a href="#" class="TRAINPENDEL">Pendeltåg</a>
											<a href="#" class="TRAINSJREG">SJ regional</a>
											<a href="#" class="TRAINTAGAB">Tågab regiontåg</a>
											<a href="#" class="TRAINWEST">Västtågen</a>
											<a href="#" class="BEXBLA">BLÅ</a>
											<a href="#" class="BEXGUL">GUL</a>
											<a href="#" class="BEXLILA ">LILA</a>
											<a href="#" class="BEXORANGE ">ORANGE</a>
											<a href="#" class="BEXROSA ">ROSA</a>
											<a href="#" class="BEXROD">RÖD</a>
											<a href="#" class="BEXGRON">GRÖN</a>
											<a href="#" class="BEXLS">Lerum-snabben</a>
											<a href="#" class="BEXMARS">Marstrand express</a>
											<a href="#" class="BEXONSALA">Onsala-snabben</a>
											<a href="#" class="BEXERSTAG">Ersätter tåg</a>
											<a href="#" class="BEXORUST">Orust express</a>
											<a href="#" class="BEXSVART">SVART</a>
											<a href="#" class="TRAM1">1</a>
											<a href="#" class="TRAM2">2</a>
											<a href="#" class="TRAM3">3</a>
											<a href="#" class="TRAM4">4</a>
											<a href="#" class="TRAM5">5</a>
											<a href="#" class="TRAM6">6</a>
											<a href="#" class="TRAM7">7</a>
											<a href="#" class="TRAM8">8</a>
											<a href="#" class="TRAM9">9</a>
											<a href="#" class="TRAM10">10</a>
											<a href="#" class="TRAM11">11</a>
											<a href="#" class="TRAM13">13</a>
										</div>
										<a href="trafikstorning.php" class="tsHeadline">På grund av ett spårarbete påverkas kollektivtrafiken mellan Brunnsparken och Korsvägen från den 2 september</a>				
									</li>
								</ul>
								<hr/>
								<a href="javascript:history.go(-1);">&laquo; Tillbaka</a>
							</section>
<?php include 'foot.inc'; ?>
