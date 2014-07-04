<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib prefix="common" uri="infoglue-common" %>

<page:pageContext id="pc"/>

<content:content id="banner" propertyName="Banner" useInheritance="false" />
<structure:boundPage id="detailPage" propertyName="DetailPage" useInheritance="false" />
<structure:componentPropertyValue id="maxTextLength" propertyName="MaxTextLength" useInheritance="false" />

<page:pageAttribute id="extraClass" name="extraClass" />
<page:pageAttribute id="bannerCounter" name="bannerCounter" />

<c:set var="slotName" value="${pc.componentLogic.infoGlueComponent.slotName}" />

<%
	String extraClass 	= "puff1";
	int counter 		= 1;
	
	if (pageContext.getAttribute("extraClass") != null)
	{
		extraClass = (String)pageContext.getAttribute("extraClass");
	}
	if (pageContext.getAttribute("bannerCounter") != null)
	{
		Integer temp = (Integer)pageContext.getAttribute("bannerCounter");
		counter = temp.intValue();
	}
	
	String slotName = (String)pageContext.getAttribute("slotName");
	
	if (slotName.equals("right"))
	{
		if (counter % 2 == 0)
		{
			extraClass = "banner2";
		}
		else
		{
			extraClass = "banner1";
		}
	}
	else
	{
		if (counter % 2 == 0)
		{
			if (extraClass.equals("banner1"))
			{
				extraClass = "banner2";
			}
			else
			{
				extraClass = "banner1";
			}
		}
	}
	
	pageContext.setAttribute("extraClass", extraClass);
	pageContext.setAttribute("bannerCounter", new Integer(counter + 1));
%>

<c:choose>
	<c:when test="${empty banner}">
		<c:if test="${pc.isDecorated}">
			<div class="banner <c:out value="${extraClass}"/>">
				<div class="innerContainer">
					<h2><structure:componentLabel mapKeyName="DefaultHeadline"/></h2>
					<div class="adminMessage">
						<structure:componentLabel mapKeyName="NoPuffSelected"/>
					</div>
				</div>
			</div>
		</c:if>
	</c:when>
	<c:otherwise>
		<content:contentAttribute id="title" attributeName="Title" contentId="${banner.contentId}" disableEditOnSight="true" />
		<content:contentAttribute id="text" attributeName="Text" contentId="${banner.contentId}" disableEditOnSight="true" />
		
		<div class="banner <c:out value="${extraClass}"/>">
			<div class="innerContainer">
				<h2><c:out value="${title}" escapeXml="false"/></h2>
				<p>
					<a href="<c:out value="${detailPage.url}"/>">
						<common:cropText id="croppedText" text="${text}" maxLength="${maxTextLength}" suffix="..." />
						<c:out value="${croppedText}" escapeXml="false" />
						<img class="puffArrow" src=""/>
					</a>
				</p>
			</div>
		</div>
		
		<page:pageAttribute name="extraClass" value="${extraClass}"/>
		<page:pageAttribute name="bannerCounter" value="${bannerCounter}"/>
	</c:otherwise>
</c:choose>