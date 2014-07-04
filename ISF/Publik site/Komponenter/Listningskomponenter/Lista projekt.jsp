<%@page import="java.util.Calendar"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.TemplateController"%>
<%@page import="org.infoglue.cms.entities.content.ContentVO"%>
<%@page import="java.util.Comparator"%>
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

<%!
SimpleDateFormat parserOnlyYear = new SimpleDateFormat("yyyy");
SimpleDateFormat parserYearMonth = new SimpleDateFormat("yyyy-MM");
SimpleDateFormat parserYearMonthDay = new SimpleDateFormat("yyyy-MM-dd");

private Date getDate(String dateString) throws ParseException
{
	if (dateString.length() == 4) // yyyy
	{
		Date d = parserOnlyYear.parse(dateString);
		Calendar c = Calendar.getInstance();
		c.setTime(d);
		c.set(Calendar.MONTH,c.getActualMaximum(Calendar.MONTH));
		c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
		return c.getTime();
	}
	if (dateString.length() == 7) // yyyy-mm
	{
		Date d = parserYearMonth.parse(dateString);
		Calendar c = Calendar.getInstance();
		c.setTime(d);
		c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
		return c.getTime();
	}
	if (dateString.length() == 10) // yyyy-mm-dd
	{
		return parserYearMonthDay.parse(dateString);
	}
	return null;
}

class ComingProjectsComparator implements Comparator
{
	TemplateController tc;
	
	
	public ComingProjectsComparator(TemplateController tc)
	{
		this.tc = tc;
	}

	public int compare(Object o1, Object o2)
	{
		ContentVO self  = (ContentVO)o1;
		ContentVO other = (ContentVO)o2;
		
		String plannedPublicationDateString1 = tc.getContentAttribute(self.getContentId(), "PlannedPublicationDate", true);
		if (plannedPublicationDateString1 != null && plannedPublicationDateString1.trim().length() == 0)
		{
			plannedPublicationDateString1 = null;
		}
		String plannedPublicationDateString2 = tc.getContentAttribute(other.getContentId(), "PlannedPublicationDate", true);
		if (plannedPublicationDateString2 != null && plannedPublicationDateString2.trim().length() == 0)
		{
			plannedPublicationDateString2 = null;
		}
		if (plannedPublicationDateString1 == null && plannedPublicationDateString2 == null)
		{
			return (int)(other.getPublishDateTime().getTime() - self.getPublishDateTime().getTime());
		} 
		else
		{
			if (plannedPublicationDateString1 == null && plannedPublicationDateString2 != null)
			{
				// If the first content does not have a date it should appear later in the list
				return 1;
			} 
			else if (plannedPublicationDateString1 != null && plannedPublicationDateString2 == null)
			{
				// If the first content does have a date it should appear earlier in the list
				return -1;
			}
			else // Both contents have planned publication dates
			{
				try
				{
					Long l = getDate(plannedPublicationDateString1).getTime() - getDate(plannedPublicationDateString2).getTime();
					if (l < 0L)
					{
						return -1;
					}
					else if (l > 0L)
					{
						return 1;
					}
					else
					{
						return (int)(other.getPublishDateTime().getTime() - self.getPublishDateTime().getTime());
					}
				}
				catch (ParseException ex)
				{
					return 0;
				}
			}
		}
	}
}
%>

<structure:componentPropertyValue id="publicationCategory" propertyName="PublicationCategory" useInheritance="false"/>
<structure:componentPropertyValue id="description" propertyName="Description" useInheritance="false"/>
<structure:componentPropertyValue id="titleProp" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="hideTypeText" propertyName="HideTypeText" useInheritance="false"/>
<structure:componentPropertyValue id="maxItems" propertyName="MaxItems" useInheritance="false"/>

<c:if test="${hideTypeText ne 'true' and not empty publicationCategory}">
	<structure:componentLabel id="publicationName" mapKeyName="${publicationCategory}" />

	<c:if test="${not empty publicationName}">
		<c:set var="title" value="${publicationName}" />
	</c:if>
</c:if>
<c:if test="${not empty titleProp}">
	<c:set var="title" value="${titleProp}" />
</c:if>

<c:choose>
	<c:when test="${not empty publicationCategory}">
		<content:matchingContents id="projects" contentTypeDefinitionNames="ISF Projekt" categoryCondition="Area=/ISFArea/${publicationCategory}"/>
	</c:when>
	<c:otherwise>
		<content:matchingContents id="projects" contentTypeDefinitionNames="ISF Projekt"/>
	</c:otherwise>
</c:choose>

<c:if test="${not empty projects}">
	<%
		BasicTemplateController btc = (BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
		List unsorted =  (List)pageContext.getAttribute("projects");
		Collections.sort(unsorted, new ComingProjectsComparator(btc));
		pageContext.setAttribute("projects", unsorted);
	%>
	
	<c:if test="${not empty maxItems}">
		<common:sublist id="projects" list="${projects}" count="${maxItems}" />
	</c:if>
</c:if>

<div class="projectList">
	<div class="innerContainer">
		<c:if test="${not empty title}">
			<h2><c:out value="${title}" escapeXml="false" /></h2>
		</c:if>
		<c:if test="${not empty description}">
			<p><c:out value="${description}" escapeXml="false" /></p>
		</c:if>
		<table summary="<structure:componentLabel mapKeyName="TableSummary"/>">
			<thead>
				<tr>
					<th><structure:componentLabel mapKeyName="Title"/></th>
					<th><structure:componentLabel mapKeyName="Published"/></th>
				</tr>
			</thead>
			<tbody>
				<%
					Date now = new Date();
				%>
				<c:forEach var="project" items="${projects}">
					<c:remove var="date"/>
					<content:contentAttribute id="title" attributeName="Title" contentId="${project.id}" disableEditOnSight="true"/>
					<content:contentAttribute id="plannedPublicationDate" attributeName="PlannedPublicationDate" contentId="${project.id}" disableEditOnSight="true"/>
					<%
						String plannedPublicationDate =  (String)pageContext.getAttribute("plannedPublicationDate");
						Date d = getDate(plannedPublicationDate);
						if (d != null && d.after(now))
						{
							pageContext.setAttribute("date", d);
							%>
								<tr>
									<td>
										<structure:pageUrl id="detailPageUrl" propertyName="ProjectDetailPage" contentId="${project.contentId}" useInheritance="true"/>
										
										<a href="<c:out value="${detailPageUrl}" escapeXml="false" />"><c:out value="${title}" escapeXml="false" /></a>
									</td>
									<td>
										<c:choose>
											<c:when test="${not empty date}">
												<common:formatter value="${date}" pattern="yyyy-MM"/>
											</c:when>
											<c:otherwise>
												<structure:componentLabel mapKeyName="NoPlannedDate"/>
											</c:otherwise>
										</c:choose>
									</td>
								</tr>
							<%
						}
					%>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>