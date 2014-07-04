<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-common" prefix="common" %>

<page:pageContext id="pc" />

<structure:componentPropertyValue id="defaultTitle" propertyName="DefaultTitle" useInheritance="false"/>

<page:pageAttribute id="pageTitlePrefix" name="pageTitlePrefix" />

<c:if test="${empty pageTitlePrefix}">
	<c:choose>
		<c:when test="${not empty defaultTitle}">
			<c:set var="pageTitlePrefix" value="${defaultTitle}" />
		</c:when>
		<c:otherwise>
			<structure:componentLabel id="pageTitlePrefix" mapKeyName="ResearchHeaderDefaultTitle" />
		</c:otherwise>
	</c:choose>
</c:if>

<c:if test="${empty researchHeaderSubtitle}">
	<structure:componentLabel id="researchHeaderSubtitle" mapKeyName="ResearchHeaderDefaultSubtitle" />
</c:if>

<div class="guResearchComp tabHeader">
	<c:choose>
		<c:when test="${pc.componentLogic.infoGlueComponent.positionInSlot eq 0}">
<common:transformText id="pageTitlePrefix" text="${pageTitlePrefix}" htmlEncode="true" />
			<h1><c:out value="${pageTitlePrefix}" escapeXml="false" /></h1>
		</c:when>
		<c:otherwise>
<common:transformText id="pageTitlePrefix" text="${pageTitlePrefix}" htmlEncode="true" />
			<h2><c:out value="${pageTitlePrefix}" escapeXml="false" /></h2>
		</c:otherwise>
	</c:choose>
	
	<p id="flilkhuvudSubtitle">
		<c:out value="${researchHeaderSubtitle}" escapeXml="false" />
	</p>
</div>