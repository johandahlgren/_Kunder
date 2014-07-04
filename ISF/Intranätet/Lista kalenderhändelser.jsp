<%@ taglib prefix="c"         uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt"       uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="common"    uri="infoglue-common" %>
<%@ taglib prefix="content"   uri="infoglue-content" %>
<%@ taglib prefix="page"      uri="infoglue-page" %>
<%@ taglib prefix="structure" uri="infoglue-structure" %>

<%@page import="java.util.*" %>
<%@page import="org.infoglue.cms.entities.content.ContentVO" %> 
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController" %>
 
<page:pageContext id="pc"/>
<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>
<fmt:setLocale scope="session" value="sv_SE"/> 

<structure:componentPropertyValue id="moreItemsLinkText" propertyName="MoreItemsLinkText" useInheritance="false"/>
<structure:componentPropertyValue id="numberOfItems" propertyName="NumberOfItems" useInheritance="false"/>
<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:boundPage id="moreItemsPage" propertyName="MoreItemsPage" useInheritance="false"/>
<content:content id="itemFolder" propertyName="ItemFolder" useInheritance="false" />
<structure:componentPropertyValue id="display" propertyName="Display" useInheritance="false"/>
<structure:componentPropertyValue id="sortOrder" propertyName="SortOrder" useInheritance="false"/>

<c:if test="${empty numberOfItems}">
	<c:set var="numberOfItems" value="3"/>
</c:if>

<content:childContents id="items" contentId="${itemFolder.id}" includeFolders="false"/>

<%
	java.text.SimpleDateFormat sdf 		= new java.text.SimpleDateFormat("yyyy-MM-dd hh:mm");
	java.text.SimpleDateFormat sdfShort = new java.text.SimpleDateFormat("yyyy-MM-dd");
%>

<content:contentSort id="sortedItemsUp" input="${items}">
	<content:sortContentVersionAttribute name="EventStartDate" className="java.lang.String" ascending="true"/>
</content:contentSort>

<content:contentSort id="sortedItemsDown" input="${items}">
	<content:sortContentVersionAttribute name="EventStartDate" className="java.lang.String" ascending="false"/>
</content:contentSort>

<c:if test="${display ne 'displayAll'}">
	<%
		// Plocka ut alla kommande evenemang
		// Kolla om de är >= antal att visa
		// Om de är färre
		//   Hämta alla passerade evenemang
		//   Sortera i fallande datumordning
		//   Plocka ut (antal att visa - antal framtida) och lägg till i listan
	
		int numberOfEventsToShow			= new Integer((String)pageContext.getAttribute("numberOfItems")).intValue();
		BasicTemplateController btc 		= (BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
		List<ContentVO> croppedItems			= new ArrayList<ContentVO>();
		ContentVO currentContent 			= null;
		String startDateString				= null;
		String endDateString				= null;
		Date eventStartDate					= null;
		Date eventEndDate					= null;
		Calendar now						= Calendar.getInstance();
		int startIndex						= 0;
		List<ContentVO> sortedItemsUp 		= (List<ContentVO>)pageContext.getAttribute("sortedItemsUp");
		String display						= (String)pageContext.getAttribute("display");
		
		try
		{
			Iterator<ContentVO> it 			= sortedItemsUp.iterator();
			GregorianCalendar todayStart	= new GregorianCalendar();
			todayStart.set(now.get(Calendar.YEAR), now.get(Calendar.MONTH), now.get(Calendar.DATE), 0, 0);
			
			
			while (it.hasNext())
			{
				eventStartDate		= null;
				eventEndDate		= null;
				currentContent 		= it.next();
				startDateString 	= btc.getContentAttribute(currentContent.getContentId(), "EventStartDate", true);
				if (startDateString.length() > 10)
				{
					eventStartDate		= sdf.parse(startDateString);
				}
				else
				{
					eventStartDate		= sdfShort.parse(startDateString);
				}
				endDateString 		= btc.getContentAttribute(currentContent.getContentId(), "EventEndDate", true);
				
				if (endDateString != null && !endDateString.trim().equals(""))
				{
					if (endDateString.length() > 10)
					{
						eventEndDate		= sdf.parse(endDateString);
					}
					else
					{
						eventEndDate		= sdfShort.parse(endDateString);
					}
				}
				else
				{
					eventEndDate		= eventStartDate;
				}
				
				if(eventStartDate.after(todayStart.getTime()) || eventEndDate.after(todayStart.getTime()))
				{
					break;
				}
				startIndex = startIndex + 1;
			}
		}
		catch (Exception e)
		{
			%>
				<structure:componentLabel mapKeyName="DateParseError"/>: <c:out value="${dateString}" escapeXml="false"/>
			<%
		}
				
		if (display.equals("displaySome"))
		{
			int numberOfComingEvents = sortedItemsUp.size() - startIndex;
			
			if (numberOfComingEvents < numberOfEventsToShow)
			{
				startIndex = startIndex - (numberOfEventsToShow - numberOfComingEvents);
				if (startIndex < 0)
				{
					startIndex = 0;
				}
			}
			else
			{
				// Gör ingenting. Startindex är redan satt korrekt.
			}
		}
		else if (display.equals("displayPassed"))
		{
			startIndex = startIndex - numberOfEventsToShow;
		}
		else if (display.equals("displayComing"))
		{
			// Gör ingenting. Startindex är redan satt korrekt.
		}
				
		int getIndex = 0;
		
		for (int i = 0; i < numberOfEventsToShow; i ++)
		{
			getIndex = i + startIndex;
			
			if (getIndex < sortedItemsUp.size())
			{
				croppedItems.add(sortedItemsUp.get(getIndex));
			}
			
			if (i > sortedItemsUp.size())
			{
				break;
			}
		}
			
		pageContext.setAttribute("croppedItems", croppedItems);
	%>
	<common:sublist id="items" list="${croppedItems}" startIndex="0" count="${numberOfItems}"/>
</c:if>

<content:contentSort id="items" input="${items}" >
	<c:choose>
		<c:when test="${sortOrder eq 'desc'}">
			<content:sortContentVersionAttribute name="EventStartDate" className="java.lang.String" ascending="false"/>
		</c:when>
		<c:otherwise>
			<content:sortContentVersionAttribute name="EventStartDate" className="java.lang.String" ascending="true"/>
		</c:otherwise>
	</c:choose>
</content:contentSort>

<c:choose>
	<c:when test="${empty itemFolder}">
		<c:if test="${pc.isDecorated}">
			<h2>
				<structure:componentLabel mapKeyName="DefaultHeadline"/>
			</h2>
			<div class="message">
				<structure:componentLabel mapKeyName="NoFolderSelected"/>
			</div>
		</c:if>
	</c:when>
	<c:otherwise>
		<c:if test="${not empty title}">
			<h2><c:out value="${title}" escapeXml="false"/></h2>
		</c:if>
		<div class="calendar-list">
			<ul>
				<c:forEach var="item" items="${items}" varStatus="count">  
					<c:if test="${not empty item}">
						<c:set var="publishDate" value="${item.publishDateTime}"/>					
						<content:contentAttribute id="title" contentId="${item.contentId}" attributeName="Title" disableEditOnSight="true"/>						
				 	 
						<structure:pageUrl id="url" propertyName="DetailPage" contentId="${item.id}" useInheritance="false"/>
						
						<li>
							<content:contentAttribute id="eventStartDate" contentId="${item.contentId}" attributeName="EventStartDate" disableEditOnSight="true"/> 
							<c:choose>
								<c:when test="${empty eventStartDate}">
									<a href="<c:out value="${url}" escapeXml="false"/>">
										<span class="date">	
											<span class="day">XX</span>
											<span class="month">YYY</span>
										</span>
										<span class="text"><c:out value="${title}" escapeXml="false"/></span>
									</a>
								</c:when>
								<c:otherwise>
									<%
										try
										{
											String eventDateString 			= (String)pageContext.getAttribute("eventStartDate");
											java.util.Date eventDateObject	= null;
											if(eventDateString.length() > 10)
											{
												eventDateObject 	= sdf.parse(eventDateString);
											}
											else
											{
												eventDateObject 	= sdfShort.parse(eventDateString);
											}
											pageContext.setAttribute("eventDateObject", eventDateObject);
											%>
												<a href="<c:out value="${url}" escapeXml="false"/>">
													<span class="date">	
														<span class="day"><fmt:formatDate value="${eventDateObject}" pattern="d"/></span>
														<span class="month"><fmt:formatDate value="${eventDateObject}" pattern="MMM"/></span>
													</span>
													<span class="text"><c:out value="${title}" escapeXml="false"/></span>
												</a>
											<%
										}
										catch (Exception e)
										{
											%>
												<structure:componentLabel mapKeyName="DateParseError"/>: <c:out value="${eventDate}" escapeXml="false"/>
											<%
										}
									%>
								</c:otherwise>
							</c:choose>
						</li>
					</c:if>
				</c:forEach>
			</ul>
		</div>
		
		<c:choose>
			<c:when test="${not empty moreItemsLinkText}">
				<c:set var="moreItemsLinkText" value="${moreItemsLinkText}"/>
			</c:when>
			<c:otherwise>
				<structure:componentLabel id="moreItemsLinkText" mapKeyName="MoreItemsLinkText"/>
			</c:otherwise>
		</c:choose>
		
		<c:if test="${not empty moreItemsPage}">
			<div class="more-events">
				<h3 class="structural">Fler kalenderhändelser</h3> 
				<p>	
					<a href="<c:out value="${moreItemsPage.url}" />" class="arkiv"><c:out value="${moreItemsLinkText}" escapeXml="false"/></a> 
				</p>
			</div>	
		</c:if>
	</c:otherwise>
</c:choose>