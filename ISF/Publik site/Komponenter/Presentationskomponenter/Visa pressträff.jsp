<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="encodeEmailLabel" propertyName="EmailProtectionLabel" useInheritance="true"/>
<content:content id="presstraff" propertyName="Presstraff" useInheritance="false"/>

<c:if test="${not empty param.contentId && param.contentId != -1}">
	<content:content id="presstraff" contentId="${param.contentId}"/>
</c:if>

<content:contentAttribute id="title" attributeName="Title" contentId="${presstraff.id}" disableEditOnSight="true" />
<content:contentAttribute id="leadin" attributeName="Leadin" contentId="${presstraff.id}" disableEditOnSight="true" />
<content:contentAttribute id="text" attributeName="Text" contentId="${presstraff.id}" disableEditOnSight="true" />

<div id="pageIntro">
	<div class="innerContainer">
	
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

				<%-------------------------------------%>
				<%--         Edit content links      --%>
				<%-------------------------------------%>
			
				<c:if test="${pc.isDecorated and not empty presstraff}">
					<structure:componentLabel id="editContent" mapKeyName="EditContent"/>
					<content:editOnSight id="editOnSightHTML" contentId="${presstraff.id}" attributeName="FullText" languageId="${pc.languageId}" html="${editContent}"/>
					<div class="igEditButton">
						<c:out value="${editOnSightHTML}" escapeXml="false"/>
					</div>
				</c:if>
		
				<%-------------------------------------%>
				<%--         Render text content     --%>
				<%-------------------------------------%>
			
				<h1><c:out value="${title}" escapeXml="false" /></h1>
				<c:if test="${not empty leadin}">
					<p>
						<common:protectEmail prefix="${encodeEmailLabel}" value="${leadin}" />
					</p>
				</c:if>
			</c:otherwise>
		</c:choose>
	</div>
</div>
<div id="pageMainContent">
	<div class="innerContent">
		<p><common:protectEmail prefix="${encodeEmailLabel}" value="${text}" /></p>
	</div>
</div>
