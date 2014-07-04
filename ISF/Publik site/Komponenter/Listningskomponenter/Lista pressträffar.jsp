<%@ taglib prefix="c"         uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt"       uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="common"    uri="infoglue-common" %>
<%@ taglib prefix="content"   uri="infoglue-content" %>
<%@ taglib prefix="page"      uri="infoglue-page" %>
<%@ taglib prefix="structure" uri="infoglue-structure" %>
<%@ taglib prefix="management" uri="infoglue-management" %>

<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController" %>
<%@page import="org.infoglue.cms.entities.structure.SiteNodeVO" %>

<%@page import="java.util.*" %>
<%@page import="org.infoglue.cms.entities.content.ContentVO" %>
<%@page import="org.infoglue.cms.entities.content.ContentVersionVO" %>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.TemplateController" %>
<%@page import="org.infoglue.cms.controllers.kernel.impl.simple.ContentVersionController" %>
<%@page import="org.infoglue.cms.util.sorters.TemplateControllerAwareComparator" %>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="encodeEmailLabel" propertyName="EmailProtectionLabel" useInheritance="true"/>

<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>
<c:set var="dateFormat" value="yyyy-MM-dd"/>
<fmt:setLocale scope="session" value="sv_SE"/> 

<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="moreLinkText" propertyName="MoreLinkText" useInheritance="false"/>
<structure:componentPropertyValue id="numberOfItems" propertyName="NumberOfItems" useInheritance="false"/>
<structure:componentPropertyValue id="maxIntroLength" propertyName="MaxIntroLength" useInheritance="false"/>
<structure:boundPage id="detailPage" propertyName="DetailPage" useInheritance="false"/>

<c:if test="${empty title}">
	<structure:componentLabel id="title" mapKeyName="DefaultHeadline"/>
</c:if>

<c:if test="${empty numberOfItems}">
	<c:set var="numberOfItems" value="10"/>
</c:if>

<%
	Calendar cal = Calendar.getInstance();
	cal.set(Calendar.HOUR_OF_DAY, 0);
	cal.set(Calendar.MINUTE, 0);
	cal.set(Calendar.SECOND, 0);

	pageContext.setAttribute("today", cal.getTime());
%>

<content:matchingContents id="unsortedItems" contentTypeDefinitionNames="ISF Presstraff"/>

<content:contentSort id="sortedItems" input="${unsortedItems}">
	<content:sortContentProperty name="publishDateTime" ascending="true"/>
</content:contentSort>

<common:sublist id="croppedItems" list="${sortedItems}" startIndex="0" count="${numberOfItems}"/>

<common:size id="size" list="${croppedItems}" />

<c:if test="${size gt 0}">
	<!-- eri-no-index -->

	<div id="eventBlock">
		<div class="innerContainer">
			<h2><c:out value="${title}"/></h2>
	
			<c:if test="${empty detailPage && pc.isDecorated}">
				<div class="adminMessage">
					<structure:componentLabel mapKeyName="NoDetailPageSelected"/>
				</div>
			</c:if>
	
			<%
				Date todaysDate = new Date();
			%>
	
			<c:forEach var="item" items="${croppedItems}" varStatus="loop">
				<c:set var="showEvent" value="false" />
				<c:if test="${item != null}">
					<content:contentAttribute id="title" contentId="${item.contentId}" attributeName="Title" disableEditOnSight="true"/>				
					<content:contentAttribute id="leadIn" contentId="${item.contentId}" attributeName="Leadin" disableEditOnSight="true"/>
					<content:contentAttribute id="time" contentId="${item.contentId}" attributeName="Time" disableEditOnSight="true"/>
					<content:contentAttribute id="place" contentId="${item.contentId}" attributeName="Place" disableEditOnSight="true"/>
					<content:contentAttribute id="eventDateString" contentId="${item.contentId}" attributeName="Date" disableEditOnSight="true"/>
			 	 
			 	 	<structure:pageUrl id="detailUrl" siteNodeId="${detailPage.siteNodeId}" contentId="${item.contentId}" />
			 	 											
			 	 	<%
						try
						{
							SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
					        Date myDate = formatter.parse((String)pageContext.getAttribute("eventDateString"));
					        pageContext.setAttribute("eventDate", myDate);
					        
					        if (myDate.after(todaysDate))
					        {
					        	pageContext.setAttribute("showEvent", true);
					        }
						}
						catch (Exception e)
						{
							//Do nothing. Use the original value.
						}
					%>
			 	 	<c:if test="${showEvent eq true}">									
						<c:choose>
							<c:when test="${not empty maxIntroLength}">
								<common:transformText id="leadIn" text="${leadIn}" replaceString="<(.|\n)*?>" replaceWithString="" />
								<common:cropText id="croppedText" text="${leadIn}" maxLength="${maxIntroLength}" suffix="..." />								
								<c:set var="text" value="${croppedText}"/>
							</c:when>
							<c:otherwise>					
								<c:set var="text" value="${leadIn}"/>
							</c:otherwise>
						</c:choose>
		
						<div class="eventItem">	
							<h3><a href="<c:out value="${detailUrl}" escapeXml="false"/>"><c:out value="${title}"/></a></h3>
							<span class="eventFacts">
								<strong class="eventDate">
									<span class="innerDate">
										<span class="day"><fmt:formatDate value="${eventDate}" pattern="d"/></span>
										<span class="month"><fmt:formatDate value="${eventDate}" pattern="MMM"/></span>
										<span class="year"><fmt:formatDate value="${eventDate}" pattern="yyyy"/></span>
									</span>
								</strong>
								<content:assignedCategories id="categories" contentId="${newsItem.contentId}" categoryKey="Type"/> 
								<strong class="eventLabel">
									<c:out value="${time}" /> <c:out value="${place}" />
								</strong>
							</span>
							<p>
								<common:protectEmail prefix="${encodeEmailLabel}" value="${text}" />
							</p>
						</div>
					</c:if>
				</c:if>
			</c:forEach>
		</div>
		<structure:boundPage id="moreItemsPage" propertyName="MoreItemsPage" useInheritance="false"/>
	
		<c:if test="${not empty moreItemsPage}">
			<structure:componentLabel id="moreItemsLinkText" mapKeyName="MoreItemsLinkText"/>
		
			<div class="moreNews">
				<a href="<c:out value="${moreNewsPage.url}" />">
					<c:out value="${moreNewsLinkText}" escapeXml="false"/>
				</a> 
			</div>
		</c:if>
	</div>
	<!-- /eri-no-index -->
</c:if>
