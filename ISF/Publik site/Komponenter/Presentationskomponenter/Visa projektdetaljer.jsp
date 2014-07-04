<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib prefix="management" uri="infoglue-management" %>

<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.StringTokenizer"%>
<%@page import="org.infoglue.cms.entities.management.CategoryVO"%>

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
		else if (dateString.length() == 7) // yyyy-mm
		{
			Date d = parserYearMonth.parse(dateString);
			Calendar c = Calendar.getInstance();
			c.setTime(d);
			c.set(Calendar.DAY_OF_MONTH, c.getActualMaximum(Calendar.DAY_OF_MONTH));
			return c.getTime();
		}
		else if (dateString.length() == 10) // yyyy-mm-dd
		{
			return parserYearMonthDay.parse(dateString);
		}
		return null;
	}
%>

<page:pageContext id="pc"/>

<content:content id="project" propertyName="Project"/>

<c:if test="${not empty param.contentId}">
	<content:content id="project" contentId="${param.contentId}" />
</c:if>

<c:if test="${empty project and pc.isDecorated}">
	<div class="adminMessage"><structure:componentLabel mapKeyName="NoProjectProvided"/></div>
</c:if>

<c:if test="${not empty project}">
	<content:contentAttribute id="plannedPublicationDate" attributeName="PlannedPublicationDate" contentId="${project.id}" disableEditOnSight="true" />
	<content:contentAttribute id="governmentAssignment" attributeName="GovernmentAssignment" contentId="${project.id}" disableEditOnSight="true" />
	<content:contentAttribute id="contactPersonName" attributeName="ContactPersonName" contentId="${project.id}" disableEditOnSight="true" />
	<content:contentAttribute id="contactPersonPhone" attributeName="ContactPersonPhone" contentId="${project.id}" disableEditOnSight="true" />
	
	<%---------------------------------------------------%>
	<%-- Print the header meta info used by Siteseeker --%>
	<%---------------------------------------------------%>
	
	<content:assignedCategories id="areas" contentId="${project.id}" categoryKey="Area" />
		
	<c:forEach var="area" items="${areas}">
		<management:categoryDisplayName id="areaName" categoryVO="${area}" />
		<c:if test="${areaName ne 'Startsida'}">
			<page:htmlHeadItem value="<meta name='eri-cat' content='Ämnesområden;${areaName}' />" />
		</c:if>
	</c:forEach>
	
	<content:contentVersion id="contentVersion" content="${project}"/>
	
	<page:htmlHeadItem value="<meta name='eri-cat' content='Sidtyp;projekt' />" />
	<page:htmlHeadItem value="<meta name='last-modified' content='${contentVersion.modifiedDateTime}' />"/>
		
	<c:if test="${not foundCategory and pc.isDecorated}">
		<div class="adminMessage"><structure:componentLabel mapKeyName="NoCategoryProvided"/></div>
	</c:if>
	
	<c:if test="${foundCorruptCombo and pc.isDecorated}">
		<div class="adminMessage"><structure:componentLabel mapKeyName="BadCombo"/></div>
	</c:if>
		
	<%---------------------------------------------------%>
	<%--                  END Siteseeker               --%>
	<%---------------------------------------------------%>
	
	<div class="textBox">
		<div class="innerContainer">
			<div id="projectDetails">
				<h2><structure:componentLabel mapKeyName="ProjectDetails"/></h2>
				
				<c:if test="${not empty governmentAssignment}">
					<p class="governmentInitiative">
						<structure:componentLabel mapKeyName="GovernmentInitiative"/>
					</p>
				</c:if>
				
				<h3><structure:componentLabel mapKeyName="Areas"/></h3>
				<p>
					<content:assignedCategories id="categories" contentId="${project.id}" categoryKey="Area"/>
					
					<c:forEach var="category" items="${categories}">
						<structure:componentLabel mapKeyName="${category.name}"/><br/>
					</c:forEach>
				</p>
				
				<h3><structure:componentLabel mapKeyName="PlannedPublication"/></h3>
				<p>
					<%
						String plannedPublicationDate =  (String)pageContext.getAttribute("plannedPublicationDate");
						Date d = getDate(plannedPublicationDate);
						if (d != null)
						{
							pageContext.setAttribute("date", d);
						}
					%>
					
					<span style="text-transform:capitalize;"><common:formatter value="${date}" pattern="MMMM yyyy"/></span>
				</p>
				
				<h3><structure:componentLabel mapKeyName="ContactPerson"/></h3>
				<p>
					<span>
						<c:out value="${contactPersonName}" />    
					</span>
					<span>
						<structure:componentLabel mapKeyName="Phone"/>: <c:out value="${contactPersonPhone}" />
					</span>
				</p>
			</div>
		</div>
	</div>
</c:if>