<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="gup" prefix="gup" %>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="gupTimeout" propertyName="GUR_GUPTimeout" useInheritance="true"/>
<structure:componentPropertyValue id="gupCacheTime" propertyName="GUR_GUPCacheTimeout" useInheritance="true"/>
<structure:componentPropertyValue id="publicationUrl" propertyName="GUR_GUPSinglePublicationUrl" useInheritance="true"/>
<structure:componentPropertyValue id="publicationId" propertyName="PublicationId" useInheritance="true"/>

<c:if test="${not empty param.publicationId}">
	<c:set var="publicationId" value="${param.publicationId}" />
</c:if>

<c:if test="${not empty param.publicationId}">
<%--
	<c:set var="publicationUrl" value="${publicationUrl}?pubid=${publicationId}" /> --%>
	<common:urlBuilder id="publicationUrl" baseURL="${publicationUrl}" includeCurrentQueryString="false">
		<common:parameter name="pubid" value="${param.publicationId}"/>
	</common:urlBuilder>
	<common:import id="xmlPageXml" url="${publicationUrl}" timeout="${gupTimeout}" charEncoding="utf-8" useCache="true" cacheTimeout="${gupCacheTimeout}" useFileCacheFallback="true" fileCacheCharEncoding="utf-8"/>
	<c:set var="temp" value="${pc.locale}"/>
	<gup:getGUPData id="xmlPage" xmlData="${xmlPageXml}" language="${pc.locale}" />

	<c:choose>
		<c:when test="${not empty xmlPage.response.result.docs}">
			<c:set var="publication" value="${xmlPage.response.result.docs[0]}" scope="request" />
			
			<common:cropText id="croppedTitle" text="${publication.title}" maxLength="25" suffix="&hellip;"/>
			
			<page:pageAttribute name="pageTitlePrefix" value="${croppedTitle}" />
			<page:pageAttribute name="crumbtrailCurrentPageText" value="${croppedTitle}" />
		</c:when>
		<c:when test="${empty publication and pc.isDecorated}">
			<structure:componentLabel id="labelError" mapKeyName="NoPublicationFound" />
			<c:set var="publicationDetailError" value="${labelError}" scope="request" />
		</c:when>
	</c:choose>
</c:if>