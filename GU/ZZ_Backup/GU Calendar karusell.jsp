<%@page import="java.util.ArrayList"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.List"%>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ page contentType="text/html; charset=UTF-8" %>

<page:pageContext id="pc"/>
<page:deliveryContext id="deliveryContext" />

<c:set var="pageLocale" value="${pc.locale}"/> 
<structure:componentPropertyValue id="calendarId" propertyName="CalendarId" useInheritance="false"/>
<structure:pageUrl id="calendarPageUrl" propertyName="CarouselCalendarPage" useInheritance="false"/>
<structure:pageUrl id="eventDetailUrl" propertyName="CarouselEventDetailUrl" useInheritance="false"/>
<content:externalBindings id="topEvents" propertyName="TopEvents"/>
<common:urlBuilder id="baseUrlCalendarCarousel" fullBaseUrl="true" excludedQueryStringParameters="calendarMonth"/>

<structure:boundPage id="moreEventsPage" propertyName="MoreEventsPage" />
<structure:componentPropertyValue id="moreEventsLabel" propertyName="MoreEventsLabel" />
<c:if test="${empty moreEventsLabel || moreEventsLabel == 'Undefined'}">
	<structure:componentLabel id="moreEventsLabel" mapKeyName="MoreEventsLabel" />
</c:if>

<%-- Ids are stored as Integer in InfoGlue but calendar events have long-ids. --%>
<c:if test="${not empty topEvents}">
	<%
		List<Integer> topEvents = (List<Integer>)pageContext.getAttribute("topEvents");
		ArrayList<Long> newTopEvents = new ArrayList<Long>(topEvents.size());
		for (Integer i : topEvents)//int i = 0; i < topEvents.size(); i++
		{
			newTopEvents.add(new Long(i));
		}
		pageContext.setAttribute("topEvents", newTopEvents);
	%>
</c:if>

<div class="GUCalendarCarouselComponent">
	<div class="GUCarouselContainer">
		<div class="GUCarouselHead">
			<h1>
				<structure:componentLabel mapKeyName="componentTitle" />
			</h1>
			<h2>
				<a href="<c:out value="${moreEventsPage.url}"/>" title="<c:out value="${moreEventsLabel}"/>"><c:out value="${moreEventsLabel}"/></a>
			</h2>
		</div>
		<div class="clr"></div>
		<common:portlet portletName="infoglueCalendar.WebworkDispatcherPortlet" action="ViewEventList!topEventCalendarCarousel">
			<common:portletAttribute name="eventIds" value="${topEvents}" scope="attribute"/>
			<common:portletAttribute name="includedLanguages" value="${pc.locale.language}" scope="parameter"/>
			<common:portletAttribute name="siteNodeId" value="${pc.siteNodeId}" scope="attribute"/>
			<common:portletAttribute name="languageCode" value="${pc.locale.language}" scope="attribute"/>
			<common:portletAttribute name="baseUrlCalendarCarousel" value="${baseUrlCalendarCarousel}" scope="attribute"/>
			<common:portletAttribute name="eventDetailUrl" value="${eventDetailUrl}" scope="attribute"/>
			<c:if test="${not empty calendarId}">
				<common:portletAttribute name="calendarId" value="${calendarId}" scope="parameter"/>
			</c:if>
		</common:portlet>
		
		<common:portlet portletName="infoglueCalendar.WebworkDispatcherPortlet" action="ViewEventList!graphicalCalendarCarousel">
			<common:portletAttribute name="includedLanguages" value="${pc.locale.language}" scope="parameter"/>
			<common:portletAttribute name="siteNodeId" value="${pc.siteNodeId}" scope="attribute"/>
			<common:portletAttribute name="languageCode" value="${pc.locale.language}" scope="attribute"/>
			<common:portletAttribute name="baseUrlCalendarCarousel" value="${baseUrlCalendarCarousel}" scope="attribute"/>
			<common:portletAttribute name="eventDetailUrl" value="${eventDetailUrl}" scope="attribute"/>
			<common:portletAttribute name="calendarPageUrl" value="${calendarPageUrl}" scope="attribute"/>
			<c:if test="${not empty calendarId}">
				<common:portletAttribute name="calendarId" value="${calendarId}" scope="parameter"/>
			</c:if>
			<c:if test="${not empty param.calendarMonth}">
				<common:portletAttribute name="calendarMonth" value="${param.calendarMonth}" scope="attribute"/>
			</c:if>
		</common:portlet>
		<content:assetUrl id="arrowleft" assetKey="arrowleft" />
		<content:assetUrl id="arrowright" assetKey="arrowright" />
		<content:assetUrl id="greydot" assetKey="greydot" />
		<content:assetUrl id="bluedot" assetKey="bluedot" />
		<div class="carouselControls">
			<a class="prev" id="GUCarouselItemsPrev" href='<c:out value="${urlLeft}"/>'><span><img src="<c:out value="${arrowleft}"/>" /></span></a> 
			<a class="next" id="GUCarouselItemsNext" href='<c:out value="${urlRight}"/>'><span><img src="<c:out value="${arrowright}"/>" /></span></a>
			<div class="pagination" id="GUCarouselItemsPag"></div>
		</div>
	</div>
</div>
<div class="clr"></div>



<script type="text/javascript">
	// Using default configuration
	/*
	$("#GUNewsCarouselItems").carouFredSel();       
	 */
	console.log("Plopp!");
	// Using custom configuration
	$("#GUCarouselItems").carouFredSel({
		circular : true,
		infinite : true,
		items : {
			visible : 3
		},
		direction : "left",
		prev : {
			button : "#GUCarouselItemsPrev",
			key : "left"
		},
		next : {
			button : "#GUCarouselItemsNext",
			key : "right"
		},
		scroll : {
			items : "page",
			easing : "swing",
			duration : 700,
			wipe : true
		},
		pagination : {
			container : "#GUCarouselItemsPag"
		},
		auto : {
			play : false
		}
	});
</script>
