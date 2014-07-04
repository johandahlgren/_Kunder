<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>

<structure:componentPropertyValue id="siteseekerUrl" propertyName="SiteseekerUrl" useInheritance="true"/>
<structure:componentPropertyValue id="searchTimeout" propertyName="SearchTimeout" useInheritance="true"/>

<c:set var="query" value="${param.q}" />

<c:if test="${param.emptyQuery eq 'yes'}">
	<c:set var="query" value="" />
</c:if>

<common:transformText id="query" text="${query}" replaceString=" " replaceWithString="+" />

<common:urlBuilder id="searchUrl" baseURL="${siteseekerUrl}" fullBaseUrl="false" includeCurrentQueryString="true" excludedQueryStringParameters="q">
	<common:parameter name="q" value="${query}"/>
</common:urlBuilder>

<common:import id="searchResultHtml" url="${searchUrl}" timeout="${searchTimeout}" charEncoding="utf-8" /> 

<c:out value="${searchResultHtml}" escapeXml="false" />