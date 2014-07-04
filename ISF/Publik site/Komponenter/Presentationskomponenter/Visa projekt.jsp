<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib prefix="management" uri="infoglue-management" %>

<%@page import="java.util.List"%>
<%@page import="org.infoglue.cms.applications.databeans.ReferenceBean"%>
<%@page import="org.infoglue.cms.controllers.kernel.impl.simple.RegistryController"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.TemplateController"%>
<%@page import="org.infoglue.cms.entities.structure.SiteNodeVO"%>
<%@page import="org.infoglue.cms.entities.management.LanguageVO"%>

<page:pageContext id="pc"/>

<content:content id="project" propertyName="Project"/>

<structure:componentPropertyValue id="encodeEmailLabel" propertyName="EmailProtectionLabel" useInheritance="true"/>

<c:if test="${not empty param.contentId}">
	<content:content id="project" contentId="${param.contentId}" />
</c:if>

<c:if test="${empty project and pc.isDecorated}">
	<div class="adminMessage"><structure:componentLabel mapKeyName="NoProjectProvided"/></div>
</c:if>

<c:if test="${not empty project}">
	<content:contentAttribute id="title" attributeName="Title" contentId="${project.id}" disableEditOnSight="true" />
	<content:contentAttribute id="ingress" attributeName="Ingress" contentId="${project.id}" disableEditOnSight="true" />
	<content:contentAttribute id="brodtext" attributeName="Brodtext" contentId="${project.id}" disableEditOnSight="true" />
	
	<%-------------------------------------%>
	<%--         Edit content links      --%>
	<%-------------------------------------%>

	<c:if test="${pc.isDecorated and not empty project}">
		<structure:componentLabel id="editContent" mapKeyName="EditContent"/>
		<content:editOnSight id="editOnSightHTML" contentId="${project.id}" attributeName="FullText" languageId="${pc.languageId}" html="${editContent}"/>
		<div class="igEditButton">
			<c:out value="${editOnSightHTML}" escapeXml="false"/>
		</div>
	</c:if>

	<%-------------------------------------%>
	<%--         Render text content     --%>
	<%-------------------------------------%>
	
	<div id="pageIntro"><!-- OBS: nytt innehåll -->
		<div class="innerContainer">
			<h1><c:out value="${title}" escapeXml="false" /></h1>
			<p>
				<common:protectEmail prefix="${encodeEmailLabel}" value="${ingress}" />
			</p>
		</div>
	</div>
		
	<div id="pageMainContent"><!-- OBS: nytt innehåll -->
		<div class="innerContainer">
			<common:protectEmail prefix="${encodeEmailLabel}" value="${brodtext}" />
			
			<content:relatedContents id="relatedPublications" attributeName="RelatedPublications" contentId="${project.id}"/>
			<common:size id="size" list="${relatedPublications}" />
			
			<c:if test="${size gt 0}">
				<div id="relatedInfo">
					<div class="innerContainer"> 
						<h2><structure:componentLabel mapKeyName="RelatedPublications"/></h2>
						<ul>
							<c:forEach var="relatedPublication" items="${relatedPublications}">
								<content:contentAttribute id="title" attributeName="Title" contentId="${relatedPublication.id}" disableEditOnSight="true"/>
								
								<structure:pageUrl id="publicationUrl" propertyName="PublicationDetailPage" contentId="${relatedPublication.id}" />
										
								<li><a href="<c:out value="${publicationUrl}" />"><c:out value="${title}" /></a></li>
							</c:forEach>
						</ul>
					</div>
				</c:if>
			</div>
		</div>
	</div>
</c:if>