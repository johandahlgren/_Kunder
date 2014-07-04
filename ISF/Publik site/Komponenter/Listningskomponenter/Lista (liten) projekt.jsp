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

<!-- eri-no-index -->

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
<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="numberOfProjects" propertyName="NumberOfProjects" useInheritance="false"/>
<structure:componentPropertyValue id="readMoreText" propertyName="MorePageText" useInheritance="false"/>
<structure:componentPropertyValue id="listItemClass" propertyName="ListItemClass" useInheritance="false"/>
<structure:componentPropertyValue id="listType" propertyName="ListType" useInheritance="false"/>

<c:if test="${empty listType}">
	<c:set var="listType" value="LatestProjects"/>
</c:if>

<c:choose>
	<c:when test="${empty publicationCategory or publicationCategory eq 'all'}">
		<content:matchingContents id="projects" contentTypeDefinitionNames="ISF Projekt"/>
	</c:when>
	<c:otherwise>
		<content:matchingContents id="projects" contentTypeDefinitionNames="ISF Projekt" categoryCondition="Area=/ISFArea/${publicationCategory}"/>
	</c:otherwise>
</c:choose>

<c:if test="${empty readMoreText}">
	<structure:componentLabel id="readMoreText" mapKeyName="ReadMoreText" />
</c:if>

<div class="itemList <c:out value="${listItemClass}"/>">
	<div class="innerContainer">
		<h2 class="lista"><c:out value="${title}"/></h2>
		<ul>
			<c:choose>
				<c:when test="${listType eq 'ComingProjects'}">
					<%
						BasicTemplateController btc = (BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
						List unsorted =  (List)pageContext.getAttribute("projects");
						Collections.sort(unsorted, new ComingProjectsComparator(btc));
						pageContext.setAttribute("projects", unsorted);
					%>
				</c:when>
				<c:otherwise> <%-- LatestProjects --%>
					<content:contentSort id="projects" input="${projects}" >
						<content:sortContentProperty name="publishDateTime" ascending="false"/>
					</content:contentSort>
				</c:otherwise>
			</c:choose>
	
			<c:if test="${not empty projects}">
				<common:size id="itemCount" list="${projects}"/>
				
				<c:set var="counter" value="0" />
				
				<c:forEach var="project" items="${projects}">
					<c:remove var="hide"/>
					<c:if test="${listType eq 'ComingProjects'}">
						<content:contentAttribute id="plannedPublicationDate" attributeName="PlannedPublicationDate" contentId="${project.id}" disableEditOnSight="true"/>
						<%
							String plannedPublicationDate =  (String)pageContext.getAttribute("plannedPublicationDate");
							Date d = getDate(plannedPublicationDate);
							Date now = Calendar.getInstance().getTime();
							if (d == null)
							{
								ContentVO cvo = (ContentVO)pageContext.getAttribute("project");
								if (cvo.getPublishDateTime().before(now))
								{
									pageContext.setAttribute("hide", "true");
								}
							}
							else
							{
								if (d.before(now))
								{
									pageContext.setAttribute("hide", "true");
								}
							}
						%>
					</c:if>
					<c:if test="${hide ne 'true' and counter < numberOfProjects}">
						<content:contentAttribute id="title" attributeName="Title" contentId="${project.id}"/>
		
						<structure:pageUrl id="detailPageUrl" contentId="${project.contentId}" propertyName="ProjectDetailPage" useInheritance="true" />
						<li><a href="<c:out value="${detailPageUrl}" escapeXml="false"/>"><span><c:out value="${title}" escapeXml="false"/></span></a></li>
						
						<c:set var="counter" value="${counter + 1}" />
					</c:if>
				</c:forEach>
				
				<c:if test="${itemCount > numberOfProjects and not empty readMoreText}">
					<structure:pageUrl id="readMoreUrl" propertyName="MorePage" useInheritance="false"/>
					<div class="moreItems">
						<a href="<c:out value="${readMoreUrl}" escapeXml="false"/>"><c:out value="${readMoreText}" escapeXml="false"/></a>
					</div>
				</c:if>
			</c:if>
		</ul>
	</div>
</div>

<!-- /eri-no-index -->