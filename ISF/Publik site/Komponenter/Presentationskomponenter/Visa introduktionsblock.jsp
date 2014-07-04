<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>

<structure:componentPropertyValue id="title" propertyName="Title" />
<structure:componentPropertyValue id="text" propertyName="Text" />

<div class="introBlock">
	<h2><c:out value="${title}" /></h2>
	<div class="splash-info"><c:out value="${text}" /></div>
</div>