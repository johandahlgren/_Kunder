<%@ taglib uri="infoglue-page" prefix="page" %>
<%@taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<page:deliveryContext id="dc" useFullUrl="false" disableNiceUri="false" trimResponse="true"/>
<page:pageContext id="pc"/>

<structure:componentPropertyValue id="feedTitle" propertyName="FeedTitle"/>
<structure:componentPropertyValue id="feedDescription" propertyName="FeedDescription"/>
<structure:componentPropertyValue id="feedType" propertyName="FeedType"/>
<structure:componentPropertyValue id="numberOfNews" propertyName="NumberOfNews"/>
<structure:componentPropertyValue id="contentType" propertyName="ContentType"/>
<structure:componentPropertyValue id="publicationType" propertyName="PublicationType"/>
<structure:componentPropertyValue id="area" propertyName="Area"/>

<common:urlBuilder id="currentFullUrl"/>

<c:if test="${empty numberOfNews}">
	<c:set var="numberOfNews" value="9999"/>
</c:if>

<c:set var="snid" value="${param.fromsitenodeid}"/>

<c:if test="${feedType == null || feedType == '' || feedType == 'Undefined'}">
	<c:set var="feedType" value="rss_2.0"/>
</c:if>

<%
	java.util.Date toDate = new java.util.Date();
	pageContext.setAttribute("toDate", toDate);
	/*java.util.Calendar calendar = java.util.Calendar.getInstance();
	calendar.add(java.util.Calendar.WEEK_OF_YEAR, -10);
	pageContext.setAttribute("fromDate", calendar.getTime());*/
%>

<c:if test="${not empty area and area ne 'all'}">
	<c:set var="areaCondition" value="Area=/ISFArea/${area}"/>
</c:if>

<c:choose>
	<c:when test="${contentType eq 'ISF Publik nyhet'}">
		<c:if test="${not empty area and area ne 'all'}">
			<c:set var="areaCondition" value="Area=/ISFNewsArea/${area}"/>
		</c:if>
		<content:matchingContents id="unsortedContents" contentTypeDefinitionNames="ISF Publik nyhet" toDate="${toDate}" categoryCondition="${areaCondition}"/>
		
		<content:contentSort id="sortedContents" input="${unsortedContents}">
			<content:sortContentProperty name="publishDateTime" ascending="false"/>
		</content:contentSort>
		
		<common:rssFeed id="rss" title="${feedTitle}" link="${currentFullUrl}" description="${feedDescription}" feedType="${feedType}" encoding="utf-8">
			<c:forEach var="content" items="${sortedContents}" varStatus="loop" end="${numberOfNews - 1}">
				<c:if test="${content != null}">
					<content:contentAttribute id="title" contentId="${content.contentId}" attributeName="Rubrik" disableEditOnSight="true"/>
					<content:contentAttribute id="leadIn" contentId="${content.contentId}" attributeName="Ingress" disableEditOnSight="true"/>
					<structure:relatedPages id="pages" attributeName="Page" contentId="${content.contentId}" />
			 	 	<content:relatedContents id="contents" attributeName="Content" contentId="${content.contentId}" />
			 	 	
			 	 	<c:if test="${not empty pages}">
			 	 		<c:set var="page" value="${pages[0]}" />
			 	 	</c:if>
			 	 	
			 	 	<c:if test="${not empty contents}">
			 	 		<c:set var="content" value="${contents[0]}" />
			 	 	</c:if>
			 	 	
			 	 	<c:if test="${not empty page}">
			 	 		<c:choose>
			 	 			<c:when test="${not empty content}">
			 	 				<structure:pageUrl id="url" siteNodeId="${page.siteNodeId}" contentId="${content.contentId}" />
			 	 			</c:when>
			 	 			<c:otherwise>
			 	 				<structure:pageUrl id="url" siteNodeId="${page.siteNodeId}" />
			 	 			</c:otherwise>
			 	 		</c:choose>
					</c:if>
		
					<common:rssFeedEntry title="${title}" link="${url}" description="${leadIn}" publishedDate="${content.publishDateTime}"/>
				</c:if>
			</c:forEach>
		</common:rssFeed>
	</c:when>
	<c:when test="${contentType eq 'ISF Projekt'}">
		<content:matchingContents id="unsortedContents" contentTypeDefinitionNames="ISF Projekt" toDate="${toDate}" categoryCondition="${areaCondition}"/>
		
		<content:contentSort id="sortedContents" input="${unsortedContents}">
			<content:sortContentProperty name="publishDateTime" ascending="false"/>
		</content:contentSort>
		
		<common:rssFeed id="rss" title="${feedTitle}" link="${currentFullUrl}" description="${feedDescription}" feedType="${feedType}" encoding="utf-8">
			<c:forEach var="content" items="${sortedContents}" varStatus="loop" end="${numberOfNews - 1}">
				<c:if test="${content != null}">
					<content:contentAttribute id="title" contentId="${content.contentId}" attributeName="Title" disableEditOnSight="true"/>
					<content:contentAttribute id="leadIn" contentId="${content.contentId}" attributeName="Ingress" disableEditOnSight="true"/>
					<structure:pageUrl id="url" propertyName="DetailPage" contentId="${content.id}" />
		
					<common:urlBuilder id="fullUrl" baseURL="${url}" fullBaseUrl="true" />
		
					<common:rssFeedEntry title="${title}" link="${fullUrl}" description="${leadIn}" publishedDate="${content.publishDateTime}"/>
				</c:if>
			</c:forEach>
		</common:rssFeed>
	</c:when>
	<c:otherwise>		
		<content:matchingContents id="unsortedContents" contentTypeDefinitionNames="${contentType}" toDate="${toDate}" categoryCondition="${areaCondition}"/>
		
		<content:contentSort id="sortedContents" input="${unsortedContents}">
			<content:sortContentProperty name="publishDateTime" ascending="false"/>
		</content:contentSort>
		
		<common:rssFeed id="rss" title="${feedTitle}" link="${currentFullUrl}" description="${feedDescription}" feedType="${feedType}" encoding="utf-8">
			<c:forEach var="content" items="${sortedContents}" varStatus="loop" end="${numberOfNews - 1}">
				<c:if test="${content != null}">
					<content:contentAttribute id="title" contentId="${content.contentId}" attributeName="Title" disableEditOnSight="true"/>
					<content:contentAttribute id="leadIn" contentId="${content.contentId}" attributeName="Ingress" disableEditOnSight="true"/>
					<structure:pageUrl id="url" propertyName="DetailPage" contentId="${content.id}"/>
		
					<common:rssFeedEntry title="${title}" link="${url}" description="${leadIn}" publishedDate="${content.publishDateTime}"/>
				</c:if>
			</c:forEach>
		</common:rssFeed>
	</c:otherwise>
</c:choose>

<c:out value="${rss}" escapeXml="false"/>