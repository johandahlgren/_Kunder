<?php include 'head.inc'; ?>
<section id="minaSidor">
	<h3>
		Välkommen till mina sidor!
	</h3>
	<p>
		Maecenas faucibus mollis interdum. Donec id elit non mi porta gravida at eget metus. Donec ullamcorper nulla non metus auctor fringilla. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Aenean eu leo quam. Pellentesque ornare sem lacinia quam venenatis vestibulum.
	</p>
	<form id="login" class="fullWidth">
		<label for="userid">Logga in på mina sidor</label>
		<input type="text" name="userid" id="userid" placeholder="Användarnamn" required spellcheck="false" autocomplete="off" autocapitalize="off" />
		<input type="password" name="password" id="password" placeholder="Lösenord" required spellcheck="false" autocomplete="off" autocapitalize="off" />
		<input type="submit" name="login" id="login" class="nButton" value="Logga in"/>
		<div class="center">
			<a href="minaSidor-glomtanvid.php">Glömt användarnamn</a> | <a href="minaSidor-glomtpw.php">Glömt lösenord</a>
		</div>
	</form>
	<p>
		Information om att detta inte är hela mina sidor - Att registrera sig får man göra på en dator.
	</p>
	<p>
		Maecenas faucibus mollis interdum. Donec id elit non mi porta gravida at eget metus.
	</p>
</section>

<?php include 'foot.inc'; ?>