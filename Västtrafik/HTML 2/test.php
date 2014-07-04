<?php include 'head.inc'; ?>
<style>
.toPortrait {
	display: none;
	visibility: hidden;
}
@media all and (orientation:landscape) {
	
	.toPortrait {
		position: fixed;
		width: 100%;
		height: 100%;
		top:0;bottom:0;left:0;right:0;
		display: table;
		visibility: visible;
		z-index: 9999;
		background-color: #0097CD;
	}
	header {display: none;}
	.toPortrait div {
		height: 5em;
		text-align: center;
		color:white;
		font-size: 1em;
		font-weight: bold;
		width:50%;margin:4em auto 0 auto;
	}
	.toPortrait div:before {
		color: white;
		content: url("img/standup-phone-plz.svg");
		position: absolute;
		width: 20%;
		font-size:5em;
		display: block;
		margin-top:-0.3em;
		margin-left:-1em;

		
		
	}
}

</style>
	<div class="toPortrait">
			<!-- //TODO: 	Fixa bättre icon, generisk telefon + snurr. + fixa script för att dismissa detta för alltid ... med cookie 
							Fixa också mediaqueryn så att den inte bråkar med browser ...
				
			-->
			<div>Denna mobilsajt fungerar bäst i landskapsläge.<br/>Vänd din telefon.</p>
		
	</div>

<?php include 'foot.inc'; ?>