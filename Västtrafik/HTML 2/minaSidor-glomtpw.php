<?php include 'head.inc'; ?>
<section>
	<h1>Glömt Lösenord</h1>
	<p class="ingress">
		Har du glömt ditt lösenord
	</p>
	<p>
		Ange användarnamn och den e-postadress som du har registrerat på Mina Sidor så skickar vi en länk för lösenordsåterställning till din e-post.
	</p>
	<p>
		Om du är osäker på ditt användarnamn, så klicka här:<br/><a href="minaSidor-glomtanvid.php">Glömt användarnamn</a>.
	</p>
	<form id="lostUserid" class="fullWidth">
		<label for="name">Epost</label>
		<input type="email" id="epost" name="epost" value="" placeholder="Skriv in e-postadress" required autofocus spellcheck="false" autocomplete="off"/>
		<label for="epost">Användarnamn</label>
		<input type="text" id="name" name="name" value="" placeholder="Skriv in användarnamn" required  spellcheck="false" autocomplete="off"/>		
		<input type="submit" name="send" value="skicka" id="skicka" class="nButton"/>
	</form>
</section>

<?php include 'foot.inc'; ?>