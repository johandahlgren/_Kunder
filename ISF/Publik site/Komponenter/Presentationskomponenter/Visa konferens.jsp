<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-management" prefix="management" %>

<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<page:pageContext id="pc"/>

<content:content id="conference" propertyName="Conference" useInheritance="false" />

<c:if test="${not empty param.contentId}">
	<content:content id="conference" contentId="${param.contentId}" />
</c:if>

<c:choose>
	<c:when test="${empty conference and pc.isDecorated}">
		<div class="adminMessage"><structure:componentLabel mapKeyName="NoConferenceSelected"/></div>
	</c:when>
	<c:otherwise>
		<content:contentAttribute id="title" attributeName="Title" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="ingress" attributeName="Ingress" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="text" attributeName="Text" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="conferenceProgrammeFileName" attributeName="ConferenceProgrammeFileName" contentId="${conference.id}" disableEditOnSight="true" />
		<content:assets id="assets" contentId="${conference.id}" />		
		
		<%-------------------------------------%>
		<%--         Edit content links      --%>
		<%-------------------------------------%>
	
		<c:if test="${pc.isDecorated and not empty conference}">
			<structure:componentLabel id="editContent" mapKeyName="EditContent"/>
			<content:editOnSight id="editOnSightHTML" contentId="${conference.id}" attributeName="FullText" languageId="${pc.languageId}" html="${editContent}"/>
			<div class="igEditButton">
				<c:out value="${editOnSightHTML}" escapeXml="false"/>
			</div>
		</c:if>

		<%-------------------------------------%>
		<%--         Render text content     --%>
		<%-------------------------------------%>
		
		
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
		
		<div id="pageIntro">
			<div class="innerContainer">
				<h1><c:out value="${title}" /></h1>
				<p><c:out value="${ingress}" /></p>
			</div>
		</div>
		
		<div id="pageMainContent">
			<div class="innerContainer">
				<c:out value="${text}" escapeXml="false"/>
				 <div id="conferenceMaterial">
					<div class="innerContainer">             
						<h2><structure:componentLabel mapKeyName="PresentationsTitle"/></h2>
						<c:choose>
							<c:when test="${empty assets}">
								<p><structure:componentLabel mapKeyName="NoPresentations"/></p>
							</c:when>
							<c:otherwise>
								<ul>
									<c:forEach var="asset" items="${assets}">
										<content:assetFilePath id="assetPath" digitalAssetId="${asset.id}" />
										<content:assetUrl id="assetUrl" digitalAssetId="${asset.id}" />
										<c:if test="${asset.assetKey ne conferenceProgrammeFileName}">
											<li><a href="<c:out value="${assetUrl}" />"><c:out value="${asset.assetKey}" /></a></li>
										</c:if>
									</c:forEach>
								</ul>
							</c:otherwise>
						</c:choose>
					</div>
				</div>

			</div>
		</div>
	</c:otherwise>
</c:choose>


		
