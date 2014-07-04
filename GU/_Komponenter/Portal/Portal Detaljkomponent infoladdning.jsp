<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
<%@ taglib prefix="common" uri="infoglue-common"%>
<%@ taglib prefix="structure" uri="infoglue-structure"%>

<structure:componentPropertyValue id="scriptUrl" propertyName="ScriptUrl" />

<c:choose>
	<c:when test="${empty scriptUrl}" >
		<structure:componentLabel id="noScriptUrl" mapKeyName="NoScriptUrl" />
		<c:set var="scriptText" value="${noScriptUrl}" />
	</c:when>
	<c:otherwise>	
		<common:import id="scriptText" url="${scriptUrl}" />
	</c:otherwise>
</c:choose>

<div class="script_text_container">
	<p>
		<c:out value="${scriptText}" escapeXml="false" /> 
	</p>
</div>