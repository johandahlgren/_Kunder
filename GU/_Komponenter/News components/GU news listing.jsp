<%@ taglib prefix="c"         uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt"       uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="common"    uri="infoglue-common" %>
<%@ taglib prefix="content"   uri="infoglue-content" %>
<%@ taglib prefix="page"      uri="infoglue-page" %>
<%@ taglib prefix="structure" uri="infoglue-structure" %>
<%@ taglib prefix="gu"        uri="guweb" %>

<%@ page contentType="text/html; charset=UTF-8" %>

<structure:boundPage id="rssNod" propertyName="rssNode" useInheritance="false" />
<structure:componentPropertyValue id="rssTit" propertyName="rssTitle" useInheritance="false" />
<page:pageContext id="pc"/>
<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>

<c:set var="dateFormat" value="yyyy-MM-dd"/>
<c:if test="${pc.locale.language == 'en'}">
	<c:set var="dateFormat" value="d MMM yyyy"/>
	<fmt:setLocale scope="session" value="en_UK"/>
</c:if>

<structure:componentPropertyValue id="CategoryName" propertyName="CategoryName"/>
<%
String categoryName = (String)pageContext.getAttribute("CategoryName");
if(categoryName != null)
{
    //System.out.println("CategoryName:" + categoryName);
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

<content:matchingContents id="unsortedNewsItems" contentTypeDefinitionNames="GUNyhet,GUInternNyhet,GUExternNyhet" categoryCondition="${CategoryName}" fromDate="${fromDate}" toDate="${toDate}" />
<common:size id="unsortedNewsItemsSize" list="${unsortedNewsItems}"/>
<c:if test="${unsortedNewsItemsSize < numberOfNews}">
	<content:matchingContents id="unsortedNewsItems" contentTypeDefinitionNames="GUNyhet,GUInternNyhet,GUExternNyhet" categoryCondition="${CategoryName}" fromDate="${secondFromDate}" toDate="${toDate}" cacheResult="false"/>			
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

<c:if test="${rssNod != null}"> 
	
	<c:if test="${empty rssTit}" >
		<structure:componentPropertyValue id="rssTit" propertyName="FeedTitle" siteNodeId="${rssNod.siteNodeId}"/>
	
		<c:if test="${rssTit == null or rssTit == ''}">
			<c:set var="rssTit" value="GU News Listing"/>
		</c:if>
	</c:if>
	  
	<common:URLEncode id="CategoryName" value="${CategoryName}"/>
	
	<common:urlBuilder id="rssNodeUrl" baseURL="${rssNod.url}" excludedQueryStringParameters="siteNodeId,sitenodeId,sitenodeid,contentId">
		<c:choose>
			<c:when test="${not empty CategoryName}">
				<common:parameter name="category" value="${CategoryName}" />
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

<structure:componentLabel id="dateTimeFormat" mapKeyName="dateTimeFormat"/>
	
<!-- News Start -->
<div class="newsPushComp">

	<structure:componentPropertyValue id="title" propertyName="Title"/>
	<h1>
		<c:choose>
			<c:when test="${title == '' || title == 'Undefined'}"><structure:componentLabel mapKeyName="title"/></c:when>
			<c:otherwise><c:out value="${title}"/></c:otherwise>
		</c:choose>
	</h1>

	<c:forEach var="newsItem" items="${newsItems}" varStatus="count">
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
					<c:set var="target" value=" target='_blank'"/>
				</c:when>
				<c:otherwise>
					<c:catch var="exception">
					<gu:groupForContent id="group" contentId="${content.contentId}" languageId="${pc.languageId}"/>
					<c:choose>
						<c:when test="${group != null}">
							<structure:pageUrl id="url"  contentId="${content.contentId}" languageId="${pc.languageId}" siteNodeId="${group.newsSiteNode.siteNodeId}"/>
						</c:when>
						<c:otherwise><c:set var="url" value=""/></c:otherwise>
					</c:choose>
					</c:catch>
					<c:if test="${exception != null}">
						<c:set var="url" value=""/>
						Error on: <c:out value="${content.name}"/>
					</c:if>
					<content:contentAttribute id="title" contentId="${content.contentId}" attributeName="NavigationTitle"/>
					<c:set var="target" value=""/>
				</c:otherwise>
			</c:choose>

			<content:contentAttribute id="linkTitle" contentId="${content.contentId}" attributeName="LinkTitle" disableEditOnSight="true"/>
			<content:contentAttribute id="leadIn"    contentId="${content.contentId}" attributeName="Leadin" disableEditOnSight="true"/>
	 	    <common:cropText id="leadIn" text="${leadIn}" maxLength="70"/>
			<h2><a href="<c:out value="${url}"/>" <c:out value="${target}"/> <c:if test="${linkTitle != title}">title="<c:out value="${linkTitle}"/>"</c:if>><c:out value="${title}" escapeXml="false"/></a></h2>
			<p>
				<!--<c:out value="${leadIn}" escapeXml="false"/>-->
				<span class="smallfont">&#91;<common:formatter value="${publishDate}" pattern="${dateTimeFormat}"/>&#93; </span>
			</p>
		</c:if>
	</c:forEach>
	<structure:boundPage id="moreNewsPage" propertyName="MoreNewsPage"/>
	<structure:componentPropertyValue id="moreNewsLabel" propertyName="MoreNewsLabel"/>
	<c:if test="${empty moreNewsLabel || moreNewsLabel == 'Undefined'}">
		<structure:componentLabel id="moreNewsLabel" mapKeyName="moreNewsLabel"/>
	</c:if>	
	<p><a href="<c:out value="${moreNewsPage.url}"/>" title="<structure:componentLabel mapKeyName="moreNewsTitle"/>"><c:out value="${moreNewsLabel}"/></a></p>
</div>