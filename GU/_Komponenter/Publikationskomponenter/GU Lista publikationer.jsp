<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>

<%@ taglib uri="gup" prefix="gup" %>


<%@page import="org.infoglue.deliver.util.Timer"%>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="departmentId" propertyName="DepartmentId" useStructureInheritance="false" useInheritance="false"/>
<structure:componentPropertyValue id="personId" propertyName="PersonId" useStructureInheritance="false" useInheritance="false"/>
<structure:componentPropertyValue id="lyear" propertyName="FromYear" useStructureInheritance="false" useInheritance="false"/>
<structure:componentPropertyValue id="hyear" propertyName="ToYear" useStructureInheritance="false" useInheritance="false"/>
<structure:componentPropertyValue id="gupTimeout" propertyName="GupTimeout" useStructureInheritance="false" useInheritance="false"/>
<structure:componentPropertyValue id="gupCacheTime" propertyName="GupCacheTime" useStructureInheritance="false" useInheritance="false"/>
<structure:pageUrl id="detailPageUrl" propertyName="DetailPageUrl" useStructureInheritance="false" useInheritance="false"/>

<c:set var="url" value="http://130.241.16.233:8080/gup-dev/lists/publications/guresearch/xml/index.xsql" />

<c:choose>
	<c:when test="${not empty personId}">
		<c:set var="url" value="${url}?userid=${personId}" />
	</c:when>
	<c:when test="${not empty departmentId}">
		<c:set var="url" value="${url}?deptid=${departmentId}" />
	</c:when>
</c:choose>

<c:if test="${not empty lyear}">
	<c:set var="url" value="${url}&lyear=${lyear}" />
</c:if>

<c:if test="${not empty hyear}">
	<c:set var="url" value="${url}&hyear=${hyear}" />
</c:if>

<common:import id="publicationsXml" url="${url}" timeout="${gupTimeout}" charEncoding="utf-8" useCache="true" cacheTimeout="${gupCacheTimeout}" useFileCacheFallback="true" fileCacheCharEncoding="utf-8"/>

<gup:getPublications id="publications" xmlData="${publicationsXml}" language="${pc.locale}" />

<table>
	<tr>
		<th><structure:componentLabel mapKeyName="Title"/></th>
		<th><structure:componentLabel mapKeyName="Authors"/></th>
		<th><structure:componentLabel mapKeyName="PublicationYear"/></th>
		<th><structure:componentLabel mapKeyName="ElectronicDocument"/></th>
	</tr>
<c:forEach var="publication" items="${publications}" varStatus="loop">
	<common:urlBuilder id="publicationUrl" baseURL="${detailPageUrl}" excludedQueryStringParameters="siteNodeId,sitenodeId,sitenodeid,contentId">
		<common:parameter name="publicationId" value="${publication.publicationId}" />
	</common:urlBuilder>
	<tr>
		<td>
			<a href="<c:out value="${publicationUrl}" />"><c:out value="${publication.title}" /></a><br/>
			<c:forEach var="publicationType" items="${publication.publicationTypes}" varStatus="loop">
				<c:if test="${loop.count > 1}">, </c:if><c:out value="${publicationType.name}" />
			</c:forEach>
		</td>
		<td>
			<c:forEach var="author" items="${publication.authors}" varStatus="loop">
				<c:if test="${loop.count > 1}">, </c:if><c:out value="${author.firstName}" /> <c:out value="${author.lastName}" /> 
			</c:forEach>
		</td>
		<td><c:out value="${publication.publicationYear}" /></td>
		<td>
			<c:forEach var="link" items="${publication.links}" varStatus="loop">
				<c:if test="${loop.count > 1}">, </c:if><a href="<c:out value="${link}" />" onclick="this.target='_blank';"><structure:componentLabel mapKeyName="ViewElectronicDocument"/></a>
			</c:forEach>
		</td>
</c:forEach>
</table>