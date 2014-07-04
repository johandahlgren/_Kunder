<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<form method="post">
	<textarea name="xml"></textarea>
	<input type="submit" />
</form>

<c:set var="inputXml" value="${param.xml}" />

<%
	String inputXml = (String)pageContext.getAttribute("inputXml");

	if (inputXml != null && !inputXml.equals(""))
	{
		int startOfCategories = inputXml.indexOf("");
		if (startOfCategories > -1)
		{
			inputXml = inputXml.substring(0, startOfCategories);
		}
	}
%>