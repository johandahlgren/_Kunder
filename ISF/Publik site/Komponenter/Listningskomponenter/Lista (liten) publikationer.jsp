<%@page import="org.infoglue.cms.entities.content.DigitalAssetVO"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController" %>
<%@page import="org.infoglue.cms.entities.structure.SiteNodeVO" %>

<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>

<page:pageContext id="pc"/>
		
<!-- eri-no-index -->
		
<structure:componentPropertyValue id="publicationType" propertyName="PublicationType" useInheritance="false"/>
<structure:componentPropertyValue id="publicationCategory" propertyName="PublicationCategory" useInheritance="false"/>
<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="numberOfPublications" propertyName="NumberOfPublications" useInheritance="false"/>
<structure:componentPropertyValue id="readMoreText" propertyName="MorePageText" useInheritance="false"/>
<structure:componentPropertyValue id="listItemClass" propertyName="ListItemClass" useInheritance="false"/>

<c:if test="${not empty publicationCategory}">
	<c:set var="areaCondition" value="Area=/ISFArea/${publicationCategory}"/>
</c:if>

<c:if test="${empty readMoreText}">
	<structure:componentLabel id="readMoreText" mapKeyName="ReadMoreText" />
</c:if>

<c:choose>
	<c:when test="${publicationType eq 'Rapport'}">
		<content:matchingContents id="publications" contentTypeDefinitionNames="ISF Rapport" categoryCondition="${areaCondition}"/>
	</c:when>
	<c:when test="${publicationType eq 'Arbetsrapport'}">
		<content:matchingContents id="publications" contentTypeDefinitionNames="ISF Arbetsrapport" categoryCondition="${areaCondition}"/>
	</c:when>
	<c:when test="${publicationType eq 'Workingpaper'}">
		<content:matchingContents id="publications" contentTypeDefinitionNames="ISF Working Paper" categoryCondition="${areaCondition}"/>
	</c:when>
	<c:otherwise>
		<content:matchingContents id="publications" contentTypeDefinitionNames="ISF Rapport,ISF Arbetsrapport,ISF Working Paper" categoryCondition="${areaCondition}"/>
	</c:otherwise>
</c:choose>

<div class="itemList <c:out value="${listItemClass}"/>">
	<h2 class="lista"><c:out value="${title}"/></h2>
	<c:if test="${not empty publications}">
		<ul>
			<content:contentSort id="publications" input="${publications}" >	
				<content:sortContentProperty name="publishDateTime" ascending="false"/>
			</content:contentSort>
			
			<common:size id="itemCount" list="${publications}"/>
	
			<common:sublist id="publications" list="${publications}" startIndex="0" count="${numberOfPublications}"/>
			
			<c:forEach var="publication" items="${publications}">
				<content:contentAttribute id="title" attributeName="Title" contentId="${publication.id}"/>
	
				<%--<common:urlBuilder id="publicationDetailPage" baseURL="${detailPageUrl}" excludedQueryStringParameters="cid,contentId,siteNodeId,languageId">
					<common:parameter name="contentId" value="${publication.contentId}"/>
				</common:urlBuilder>--%>
				<structure:pageUrl id="detailPageUrl" contentId="${publication.contentId}" propertyName="PublicationDetailPage" useInheritance="true" />
				<li><a href="<c:out value="${detailPageUrl}" escapeXml="false"/>"><span><c:out value="${title}" escapeXml="false"/></span></a></li>
			</c:forEach>
			
			<c:if test="${itemCount > numberOfPublications}">
				<structure:pageUrl id="readMoreUrl" propertyName="MorePage" useInheritance="false"/>
				<div class="moreItems">
					<a href="<c:out value="${readMoreUrl}" escapeXml="false"/>"><c:out value="${readMoreText}" escapeXml="false"/></a>
				</div>
			</c:if>
		</ul>
	</c:if>
</div>

<!-- /eri-no-index -->