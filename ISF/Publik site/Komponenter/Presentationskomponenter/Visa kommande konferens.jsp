<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-management" prefix="management" %>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<page:pageContext id="pc"/>

<content:content id="conference" propertyName="Conference" />

<c:choose>
	<c:when test="${empty conference and pc.isDecorated}">
		<div class="adminMessage"><structure:componentLabel mapKeyName="NoConferenceSelected"/></div>
	</c:when>
	<c:otherwise>
		<content:contentAttribute id="shortDescription" attributeName="ShortDescription" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="startDate" attributeName="StartDate" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="place" attributeName="Place" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="title" attributeName="Title" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="ingress" attributeName="Ingress" contentId="${conference.id}" disableEditOnSight="true" />
		
		<%
			try
			{
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		        Date myDate = formatter.parse((String)pageContext.getAttribute("startDate"));
		        pageContext.setAttribute("startDate", myDate);
			}
			catch (Exception e)
			{
				//Do nothing. Use the original value.
			}
		%>
		
		<div class="textBox type2">
			<div class="innerContainer">
				<h2><c:out value="${shortDescription}" />, <common:formatter value="${startDate}" pattern="dd MMMM"/> <structure:componentLabel mapKeyName="In" /> <c:out value="${place}" /></h2>
				<h3><c:out value="${title}" /></h3>
				<p><c:out value="${ingress}" /></p>
				<ul>
					<structure:pageUrl id="detailUrl" propertyName="ConferenceDetailPage" contentId="${conference.contentId}" />
					<li><a href="<c:out value="${detailUrl}" escapeXml="false" />"><structure:componentLabel mapKeyName="ReadMore"/></a></li>
				</ul>
			</div>
		</div>
	</c:otherwise>
</c:choose>
