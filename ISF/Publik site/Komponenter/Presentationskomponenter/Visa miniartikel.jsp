<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>

<page:pageContext id="pc"/>
<structure:componentPropertyValue id="encodeEmailLabel" propertyName="EmailProtectionLabel" useInheritance="true"/>
<structure:componentPropertyValue id="itemClass" propertyName="ItemClass" useInheritance="false"/>

<content:content id="miniArticle" propertyName="MiniArticle" useInheritance="false"/>

<content:contentAttribute id="title" attributeName="Title" contentId="${miniArticle.id}" disableEditOnSight="true"/>
<content:contentAttribute id="text" attributeName="Text" contentId="${miniArticle.id}" disableEditOnSight="true"/>

<c:choose>
	<c:when test="${empty miniArticle}">
		<c:if test="${pc.isDecorated}">
	    	<div class="textBox">
				<h2><structure:componentLabel mapKeyName="DefaultHeadline"/></h2>
				<div class="adminMessage">
					<structure:componentLabel mapKeyName="NoMiniArticleSelected"/>
				</div>
	    	</div>
		</c:if>
	</c:when>
	<c:otherwise>
		<div class="textBox <c:out value="${itemClass}" />">
			<div class="innerContainer">
				
				<%-------------------------------------%>
				<%--         Edit content links      --%>
				<%-------------------------------------%>
			
				<c:if test="${pc.isDecorated and not empty miniArticle}">
					<structure:componentLabel id="editContent" mapKeyName="EditContent"/>
					<content:editOnSight id="editOnSightHTML" contentId="${miniArticle.id}" attributeName="FullText" languageId="${pc.languageId}" html="${editContent}"/>
					<div class="igEditButton">
						<c:out value="${editOnSightHTML}" escapeXml="false"/>
					</div>
				</c:if>
		
				<%-------------------------------------%>
				<%--         Render text content     --%>
				<%-------------------------------------%>
		
				<c:if test="${not empty title}">
					<h2><c:out value="${title}" escapeXml="false" /></h2>
				</c:if>
		        <p><common:protectEmail prefix="${encodeEmailLabel}" value="${text}" /></p>
		    </div>
		</div>
	</c:otherwise>
</c:choose>