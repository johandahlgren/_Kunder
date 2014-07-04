<?php include 'head.inc'; ?>

<section>
	<h1>Glömt Användarnamn</h1>
	<p class="ingress">Har du glömt ditt användarnamn?</p>
	<p>
	Fyll i ditt förnamn. Skriv sedan in den e-postadress du angav vid registreringen.
	Klicka på "Skicka" så kommer ett e-postbrev med ditt användarnamn att skickas till dig (under förutsättning att ditt förnamn och e-postadress är korrekta). Har du inte angett någon e-postadress kan du kontakta vår kundservice på tel <a href="tel:+46771414300">0771-41 43 00</a>, så skickar de nya uppgifter till dig via post. Om du får ett felmeddelande beror det troligen på att du bytt e-postadress. Kontakta då vår kundservice för att få hjälp.</p>
	<form id="lostUserid" class="fullWidth">
		<label for="name">Förnamn</label>
		<input type="text" id="name" name="name" placeholder="Skriv in förnamn" required spellcheck="false" autocomplete="off" autocapitalize="on"/>
		<label for="epost">E-post</label>
		<input type="email" id="epost" name="epost" placeholder="Skriv in e-postadress" required/>
		<input type="submit" name="send" value="Skicka" id="skicka" class="nButton" />
	</form>
</section>

<?php include 'foot.inc'; ?>