<%@page import="java.util.Calendar"%>
<%@page import="java.util.List"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController"%>
<%@page import="java.util.Collections"%>
<%@page import="org.infoglue.cms.entities.content.ContentVO"%>
<%@page import="java.util.Comparator"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.TemplateController"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
<%@page import="java.awt.PageAttributes"%>
<%@ taglib prefix="c"         uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt"       uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="common"    uri="infoglue-common" %>
<%@ taglib prefix="content"   uri="infoglue-content" %>
<%@ taglib prefix="page"      uri="infoglue-page" %>
<%@ taglib prefix="structure" uri="infoglue-structure" %>

<page:pageContext id="pc"/>

<%!
SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm");
private Date getDate(String dateString) throws ParseException
{
	return sdf.parse(dateString);
}

class StartDateComparator implements Comparator<ContentVO>
{
	TemplateController tc;
	
	
	public StartDateComparator(TemplateController tc)
	{
		this.tc = tc;
	}

	public int compare(ContentVO self, ContentVO other)
	{
		//ContentVO self  = (ContentVO)o1;
		//ContentVO other = (ContentVO)o2;
		
		String startDateString1 = tc.getContentAttribute(self.getContentId(), "StartDate", true);
		String startDateString2 = tc.getContentAttribute(other.getContentId(), "StartDate", true);
		try
		{
			Long l = getDate(startDateString1).getTime() - getDate(startDateString2).getTime();
			if (l < 0L)
			{
				return 1;
			}
			else if (l > 0L)
			{
				return -1;
			}
			else
			{
				return -1 * (int)(other.getPublishDateTime().getTime() - self.getPublishDateTime().getTime());
			}
		}
		catch (ParseException ex)
		{
			return 0;
		}
	}
}
%>

<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>
<c:set var="dateFormat" value="yyyy-MM"/>
<fmt:setLocale scope="session" value="sv_SE"/> 

<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>

<c:if test="${empty title}">
	<structure:componentLabel id="title" mapKeyName="DefaultHeadline"/>
</c:if>

<content:matchingContents id="unsortedItems" contentTypeDefinitionNames="ISF Konferens" />

<!-- eri-no-index -->

<c:if test="${not empty unsortedItems}">
	<%
	BasicTemplateController btc = (BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
	List<ContentVO> unsortedItems = (List<ContentVO>)pageContext.getAttribute("unsortedItems");
	Collections.sort(unsortedItems, new StartDateComparator(btc));
	pageContext.setAttribute("sortedItems", unsortedItems);
	%>

	<div class="conferenceList">
		<div class="innerContainer">
			<c:if test="${not empty title}">
				<h2><c:out value="${title}"/></h2>
			</c:if>
			<table summary="<structure:componentLabel mapKeyName="Summary"/>">
				<tr>
					<th scope="col"><structure:componentLabel mapKeyName="Title"/></th>
					<th scope="col"><structure:componentLabel mapKeyName="Date"/></th>
				</tr>
				
				<c:forEach var="item" items="${sortedItems}">
					<c:if test="${item != null}">
						<content:contentAttribute id="title" contentId="${item.id}" attributeName="Title" disableEditOnSight="true"/>				
						<content:contentAttribute id="startDateString" contentId="${item.id}" attributeName="StartDate" disableEditOnSight="true"/>
						<%
						String startDateString = (String)pageContext.getAttribute("startDateString");
						Date startDate = sdf.parse(startDateString);
						pageContext.setAttribute("startDate", startDate);
						Date now = Calendar.getInstance().getTime();
						pageContext.setAttribute("isInFuture", startDate.after(now));
						%>
						
						<c:if test="${isInFuture ne true}">
					 	 	<structure:pageUrl id="detailUrl" propertyName="ConferenceDetailPage" contentId="${item.id}" />
							<tr>	
								<td><a href="<c:out value="${detailUrl}" escapeXml="false"/>"><c:out value="${title}"/></a></td>
								<td class="minimumWidthNoWrapColumn"><common:formatter value="${startDate}" pattern="yyyy-MM-dd" /></td>
							</tr>
						</c:if>
					</c:if>
				</c:forEach>
			</table>
		</div>	
	</div>
</c:if>
<!-- /eri-no-index -->
