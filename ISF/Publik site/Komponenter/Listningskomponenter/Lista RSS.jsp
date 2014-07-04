<%@ taglib prefix="c"         uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt"       uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="common"    uri="infoglue-common" %>
<%@ taglib prefix="content"   uri="infoglue-content" %>
<%@ taglib prefix="page"      uri="infoglue-page" %>
<%@ taglib prefix="structure" uri="infoglue-structure" %>
<%@ taglib prefix="management" uri="infoglue-management" %>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:boundPages id="rssPages" propertyName="RssPages" useInheritance="false"/>

<c:if test="${empty title}">
	<structure:componentLabel id="title" mapKeyName="DefaultHeadline"/>
</c:if>

<c:choose>
	<c:when test="${empty rssPages}">
		<h2><c:out value="${title}"/></h2>
		<div class="adminMessage">
			<structure:componentLabel mapKeyName="NoRssPagesSelected"/>
		</div>
	</c:when>
	<c:otherwise>
		<div class="rssList">
			<h2><c:out value="${title}"/></h2>
			
			<ul>
				<c:forEach var="rssPage" items="${rssPages}">		
					<common:urlBuilder id="rssUrl" baseURL="${rssPage.url}" query="" excludedQueryStringParameters="adjust,siteNodeId,repositoryName">
				    </common:urlBuilder>
				    <content:contentAttribute id="rssTitle" contentId="${rssPage.metaInfoContentId}" attributeName="Title"/> 		        
				    <li><a href="<c:out value="${rssUrl}" escapeXml="true"/>"><c:out value="${rssTitle}" escapeXml="false" /></a></li>	
				</c:forEach>
			</ul>
		</div>
	</c:otherwise>
</c:choose>