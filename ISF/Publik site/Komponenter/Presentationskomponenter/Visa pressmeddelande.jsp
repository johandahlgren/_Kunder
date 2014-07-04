<%@page import="org.infoglue.cms.entities.content.DigitalAssetVO"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib prefix="management" uri="infoglue-management" %>

<%@page import="org.infoglue.cms.controllers.kernel.impl.simple.RegistryController"%>
<%@page import="org.infoglue.cms.applications.databeans.ReferenceBean"%>
<%@page import="org.infoglue.cms.entities.structure.SiteNodeVO"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.TemplateController"%>
<%@page import="org.infoglue.cms.entities.management.LanguageVO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<structure:componentPropertyValue id="encodeEmailLabel" propertyName="EmailProtectionLabel" useInheritance="true"/>

<page:pageContext id="pc"/>

<page:pageAttribute id="pressRelease" name="pressRelease" />

<c:if test="${empty pressRelease and pc.isDecorated}">
	<div class="adminMessage"><structure:componentLabel mapKeyName="NoPressReleaseProvided"/></div>
</c:if>

<c:if test="${not empty pressRelease}">
	<content:contentAttribute id="title" attributeName="Title" contentId="${pressRelease.id}" disableEditOnSight="true" />
	<content:contentAttribute id="ingress" attributeName="Ingress" contentId="${pressRelease.id}" disableEditOnSight="true"/>
	<content:contentAttribute id="text" attributeName="Text" contentId="${pressRelease.id}" disableEditOnSight="true"/>
	<content:contentAttribute id="date" attributeName="Date" contentId="${pressRelease.id}" disableEditOnSight="true"/>
		
	<%
		try
		{
			SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
	        Date myDate = formatter.parse((String)pageContext.getAttribute("date"));
	        pageContext.setAttribute("publishingDate", myDate);
		}
		catch (Exception e)
		{
			//Do nothing. Use the original value.
		}
	%>

	<div id="pageIntro">
		<div class="innerContainer">
			
			<%-------------------------------------%>
			<%--         Edit content links      --%>
			<%-------------------------------------%>
		
			<c:if test="${pc.isDecorated and not empty pressRelease}">
				<structure:componentLabel id="editContent" mapKeyName="EditContent"/>
				<content:editOnSight id="editOnSightHTML" contentId="${pressRelease.id}" attributeName="FullText" languageId="${pc.languageId}" html="${editContent}"/>
				<div class="igEditButton">
					<c:out value="${editOnSightHTML}" escapeXml="false"/>
				</div>
			</c:if>
	
			<%-------------------------------------%>
			<%--         Render text content     --%>
			<%-------------------------------------%>
			
			<h1><c:out value="${title}" escapeXml="false" /></h1>
			
			<div id="newsTypeInfo">
				<div class="innerContainer">
					<strong><structure:componentLabel mapKeyName="Pressmeddelande"/></strong>
					<c:choose>
						<c:when test="${not empty publishingDate}">
							<common:formatter value="${publishingDate}" pattern="d MMMM yyyy"/>
						</c:when>
						<c:otherwise>
							<c:out value="${publishingDate}" escapeXml="false"/>
						</c:otherwise>
					</c:choose>
				</div>
			</div>

			<p>
				<common:protectEmail prefix="${encodeEmailLabel}" value="${ingress}" />
			</p>
		</div>
	</div>
	<div id="pageMainContent">
		<div class="innnerContainer">
			<common:protectEmail prefix="${encodeEmailLabel}" value="${text}" />
		</div><%-- slut pageMainContent --%>
	</div>
</c:if>
