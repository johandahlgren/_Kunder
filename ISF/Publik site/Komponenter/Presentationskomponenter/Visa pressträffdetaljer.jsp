<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<%@page import="java.text.ParseException"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="encodeEmailLabel" propertyName="EmailProtectionLabel" useInheritance="true"/>
<content:content id="presstraff" propertyName="Presstraff" useInheritance="false"/>
<structure:componentPropertyValue id="encodeEmailLabel" propertyName="EmailProtectionLabel" useInheritance="true"/>

<c:if test="${not empty param.contentId && param.contentId != -1}">
	<content:content id="presstraff" contentId="${param.contentId}"/>
</c:if>

<content:contentAttribute id="date" attributeName="Date" contentId="${presstraff.id}" disableEditOnSight="true" />
<content:contentAttribute id="place" attributeName="Place" contentId="${presstraff.id}" disableEditOnSight="true" />
<content:contentAttribute id="city" attributeName="City" contentId="${presstraff.id}" disableEditOnSight="true" />
<content:contentAttribute id="contactEmail" attributeName="ContactEmail" contentId="${presstraff.id}" disableEditOnSight="true" />

<c:choose>
	<c:when test="${empty presstraff}">
		<c:if test="${pc.isDecorated}">
			<h1><structure:componentLabel mapKeyName="DefaultHeadline"/></h1>
			<div class="adminMessage">
				<structure:componentLabel mapKeyName="NoPresstraffSelected"/>
			</div>
		</c:if>
	</c:when>
	<c:otherwise>
		<div class="textBox"><!-- OBS: nytt innehåll -->
			<div class="innerContainer">
				<div id="conferenceDetails"><!-- OBS: nytt innehåll -->
				<h2><structure:componentLabel mapKeyName="DefaultHeadline"/></h2>
				<h3><structure:componentLabel mapKeyName="DateAndTime"/></h3>
				<p>
					<%
						String dateString = (String)pageContext.getAttribute("date");
						SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd hh:mm");
						if (dateString != null && !"".equals(dateString))
						{
							try
							{
								Date date = sdf.parse(dateString);
								pageContext.setAttribute("date", date);
							}
							catch (ParseException ex)
							{
								%><div class="adminMessage"><structure:componentLabel mapKeyName="DateParseError" />: <c:out value="${dateString}"/></div><%
							}
						}
					%>
					<span>
						<common:formatter value="${date}" pattern="dd MMMM yyyy"/>
					</span>
					<span>
						<common:formatter value="${date}" pattern="hh:mm"/>
					</span>
				</p>
				<h3><structure:componentLabel mapKeyName="Location"/></h3>
				<p>
					<span><c:out value="${place}"/>, <c:out value="${city}"/></span>
				</p>
				<h3><structure:componentLabel mapKeyName="Application"/></h3>
				<p>
					<structure:componentLabel mapKeyName="PleaseApplyInAdvance"/> 
					<a href="<common:protectEmail prefix="${encodeEmailLabel}" value="mailto:${contactEmail}" />"><common:protectEmail prefix="${encodeEmailLabel}" value="${contactEmail}" /></a>
				</p>
			</div>
		</div>
	</c:otherwise>
</c:choose>