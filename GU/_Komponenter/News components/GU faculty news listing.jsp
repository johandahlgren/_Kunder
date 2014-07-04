<%@ taglib prefix="c"         uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="common"    uri="infoglue-common" %>
<%@ taglib prefix="content"   uri="infoglue-content" %>
<%@ taglib prefix="page"      uri="infoglue-page" %>
<%@ taglib prefix="structure" uri="infoglue-structure" %>
<%@ taglib prefix="gu"        uri="guweb" %>

<%@ page contentType="text/html; charset=UTF-8" %>

<page:pageContext id="pc"/>
<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>
<structure:componentPropertyValue id="CategoryName" propertyName="CategoryName" useInheritance="false" />
<structure:boundPage id="rssNod" propertyName="rssNode" useInheritance="false" />
<structure:componentPropertyValue id="rssTit" propertyName="rssTitle" useInheritance="false" />

<c:if test="${rssNod != null}">

	<c:if test="${empty rssTit}" >
		<structure:componentPropertyValue id="rssTit" propertyName="FeedTitle" siteNodeId="${rssNod.siteNodeId}"/>
	
		<c:if test="${rssTit == null or rssTit == ''}">
			 <c:set var="rssTit" value="GU Faculty News Listing"/>
		</c:if>
	</c:if>
  
	<common:URLEncode id="categoryParameter" value="${CategoryName}"/>

	<common:urlBuilder id="rssNodeUrl" baseURL="${rssNod.url}" excludedQueryStringParameters="siteNodeId,sitenodeId,sitenodeid,contentId">
		<c:choose>
			<c:when test="${not empty CategoryName}">
				<common:parameter name="category" value="${categoryParameter}" />
			</c:when>
			<c:otherwise>
				<common:parameter name="fromsitenodeid" value="${deliveryContext.siteNodeId}"/>
			</c:otherwise>
		</c:choose>
	</common:urlBuilder>
	
	<c:set var="rssLink">
		<link rel="alternate" type="application/rss+xml" title="<c:out value="${rssTit}"/>" href="<c:out value="${rssNodeUrl}"/>"/>
	</c:set>
	
  	<page:htmlHeadItem value="${rssLink}"/>

</c:if>

<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>

<%
String categoryName = (String)pageContext.getAttribute("CategoryName");
if(categoryName != null)
{
    categoryName = categoryName.replaceAll("Omrade", "Område");
    categoryName = categoryName.replaceAll("Samhallsvetenskapliga", "Samhällsvetenskapliga");
    categoryName = categoryName.replaceAll("Jamlikhet och jamstalldhet", "Jämlikhet och jämställdhet");

    //System.out.println("CategoryName:" + categoryName);
    pageContext.setAttribute("CategoryName", categoryName);
}

java.util.Date toDate = new java.util.Date();
pageContext.setAttribute("toDate", toDate);
java.util.Calendar calendar = java.util.Calendar.getInstance();
calendar.add(java.util.Calendar.WEEK_OF_YEAR, -4);
pageContext.setAttribute("fromDate", calendar.getTime());
calendar.add(java.util.Calendar.WEEK_OF_YEAR, -50);
pageContext.setAttribute("secondFromDate", calendar.getTime());
calendar.add(java.util.Calendar.WEEK_OF_YEAR, -50);
pageContext.setAttribute("thirdFromDate", calendar.getTime());
%>

<structure:componentPropertyValue id="numberOfNews" propertyName="NumberOfNews"/>

<content:matchingContents id="unsortedNewsItems" contentTypeDefinitionNames="GUNyhet,GUInternNyhet,GUExternNyhet" categoryCondition="${CategoryName}" fromDate="${fromDate}" toDate="${toDate}"/>
<common:size id="unsortedNewsItemsSize" list="${unsortedNewsItems}"/>
<c:if test="${unsortedNewsItemsSize < numberOfNews}">
	<content:matchingContents id="unsortedNewsItems" contentTypeDefinitionNames="GUNyhet,GUInternNyhet,GUExternNyhet" categoryCondition="${CategoryName}" fromDate="${secondFromDate}" toDate="${toDate}"/>			
	<common:size id="unsortedNewsItemsSize" list="${unsortedNewsItems}"/>
	<c:if test="${unsortedNewsItemsSize < numberOfNews}">
		<content:matchingContents id="unsortedNewsItems" contentTypeDefinitionNames="GUNyhet,GUInternNyhet,GUExternNyhet" categoryCondition="${CategoryName}" fromDate="${thirdFromDate}" toDate="${toDate}"/>			
		<common:size id="unsortedNewsItemsSize" list="${unsortedNewsItems}"/>
		<c:if test="${unsortedNewsItemsSize < numberOfNews}">
			<content:matchingContents id="unsortedNewsItems" contentTypeDefinitionNames="GUNyhet,GUInternNyhet,GUExternNyhet" categoryCondition="${CategoryName}"/>			
		</c:if>
	</c:if>
</c:if>

<content:contentSort id="allNewsItems" input="${unsortedNewsItems}" comparatorClass="se.gu.infoglue.util.sorters.TopNewsTimeComparator">
	<content:sortContentVersionAttribute name="TopNews" className="java.lang.Integer" ascending="false"/>
	<content:sortContentProperty name="publishDateTime" ascending="false"/>
</content:contentSort>

<common:sublist id="newsItems" list="${allNewsItems}" startIndex="0" count="${numberOfNews}"/>

<!-- News Start -->
<div class="newsListComp">

	<structure:componentPropertyValue id="title" propertyName="Title"/>
	<h1>
		<c:choose>
			<c:when test="${title == '' || title == 'Undefined'}"><structure:componentLabel mapKeyName="title"/></c:when>
			<c:otherwise><c:out value="${title}"/></c:otherwise>
		</c:choose>
	</h1>

	<c:forEach var="newsItem" items="${newsItems}" varStatus="count">
		<page:pageContext id="pc"/>
		<content:contentTypeDefinition id="ctd" contentId="${newsItem.contentId}"/>
  
 		<c:set var="publishDate" value="${newsItem.publishDateTime}"/>
 		
		<c:choose>
			<c:when test="${ctd.name eq \"GUInternNyhet\"}">
				<content:relatedContents id="content" contentId="${newsItem.contentId}" attributeName="LinkedNews" onlyFirst="true"/>
			</c:when>
			<c:otherwise>
				<c:set var="content" value="${newsItem}"/>
			</c:otherwise>
		</c:choose>

		<c:if test="${content != null}">
			<c:choose>
				<c:when test="${ctd.name eq \"GUExternNyhet\"}">
					<content:contentAttribute id="url"   contentId="${content.contentId}" attributeName="URL" disableEditOnSight="true"/>
					<content:contentAttribute id="title" contentId="${content.contentId}" attributeName="Title" disableEditOnSight="true"/>
					<c:set var="target" value="target='_blank'"/>
				</c:when>
				<c:otherwise>
					<gu:groupForContent id="group" contentId="${content.contentId}" languageId="${pc.languageId}"/>
										
					<c:choose>
						<c:when test="${group != null}">
							<structure:pageUrl id="url"  contentId="${content.contentId}" languageId="${pc.languageId}" siteNodeId="${group.newsSiteNode.siteNodeId}"/>
						</c:when>
						<c:otherwise><c:set var="url" value=""/></c:otherwise>
					</c:choose>
					<content:contentAttribute id="title" contentId="${content.contentId}" attributeName="NavigationTitle" disableEditOnSight="true"/>
					<c:set var="target" value=""/>
				</c:otherwise>
			</c:choose>

			<content:contentAttribute id="linkTitle" contentId="${content.contentId}" attributeName="LinkTitle" disableEditOnSight="true"/>
			<content:contentAttribute id="leadIn"    contentId="${content.contentId}" attributeName="Leadin"/>
			<structure:componentLabel id="dateTimeFormat" mapKeyName="dateTimeFormat"/>
			
			<h2>
				<a href="<c:out value="${url}" escapeXml="true"/>" <c:out value="${target}" escapeXml="false"/> <c:if test="${linkTitle != title}">title="<c:out value="${linkTitle}" escapeXml="false"/>"</c:if>><c:out value="${title}" escapeXml="false"/></a>
			</h2>
			<p>
				<span class="smallfont">&#91;<common:formatter value="${publishDate}" pattern="${dateTimeFormat}"/>&#93;</span>
				<c:out value="${leadIn}" escapeXml="false"/>
			</p>
		</c:if>
	</c:forEach>
	<structure:boundPage id="moreNewsPage" propertyName="MoreNewsPage"/>
	<structure:componentPropertyValue id="moreNewsLabel" propertyName="MoreNewsLabel"/>
	<c:if test="${empty moreNewsLabel || moreNewsLabel == 'Undefined'}">
		<structure:componentLabel id="moreNewsLabel" mapKeyName="moreNewsLabel"/>
	</c:if>	
	<p><a href="<c:out value="${moreNewsPage.url}"/>" title="<structure:componentLabel mapKeyName="moreNewsTitle"/>"><c:out value="${moreNewsLabel}"/></a></p>
<div class="clear"></div>
</div>