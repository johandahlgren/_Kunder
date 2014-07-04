<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>

<%@page import="javax.xml.parsers.DocumentBuilderFactory" %>
<%@page import="javax.xml.parsers.DocumentBuilder" %>
<%@page import="javax.xml.xpath.XPathFactory" %>
<%@page import="javax.xml.xpath.XPath" %>
<%@page import="javax.xml.xpath.XPathExpression" %>
<%@page import="javax.xml.xpath.XPathConstants" %>

<%@page import="org.xml.sax.InputSource" %>

<%@page import="org.w3c.dom.Document" %>
<%@page import="org.w3c.dom.NodeList" %>
<%@page import="org.w3c.dom.Node" %>
<%@page import="org.w3c.dom.Element" %>

<%@page import="javax.xml.transform.dom.DOMSource" %>
<%@page import="javax.xml.transform.TransformerFactory" %>
<%@page import="javax.xml.transform.Transformer" %>
<%@page import="javax.xml.transform.stream.StreamResult" %>
<%@page import="javax.xml.transform.TransformerException" %>
<%@page import="java.io.StringWriter" %>

<structure:componentPropertyValue id="encodeEmailLabel" propertyName="EmailProtectionLabel" useInheritance="true"/>
<structure:pageUrl id="readMorePageUrl" propertyName="ReadMorePage" useInheritance="false"/>
<structure:componentPropertyValue id="readMoreText" propertyName="ReadMoreText" useInheritance="false"/>

<c:if test="${empty readMoreText}">
	<structure:componentLabel id="readMoreText" mapKeyName="ReadMore"/>
</c:if>

<page:pageContext id="pc"/>

<content:content id="artikel" propertyName="Artikel" useInheritance="false"/>

<c:if test="${not empty param.contentId && param.contentId != -1}">
	<content:content id="artikel" contentId="${param.contentId}"/>
</c:if>

<content:contentAttribute id="title" attributeName="Rubrik" contentId="${artikel.id}" disableEditOnSight="true" />
<content:contentAttribute id="leadin" attributeName="Ingress" contentId="${artikel.id}" disableEditOnSight="true" />
<content:contentAttribute id="text" attributeName="Brödtext" contentId="${artikel.id}" />

<c:set var="publishDate" value="${artikel.publishDateTime}"/>

<c:choose>
	<c:when test="${empty artikel}">
		<c:if test="${pc.isDecorated}">
			<h1><structure:componentLabel mapKeyName="DefaultHeadline"/></h1>
			<div class="adminMessage">
				<structure:componentLabel mapKeyName="NoArticleSelected"/>
			</div>
		</c:if>
	</c:when>
	<c:otherwise>
	
		<%-------------------------------------%>
		<%--         Edit content links      --%>
		<%-------------------------------------%>
	
		<c:if test="${pc.isDecorated and not empty artikel}">
			<structure:componentLabel id="editContent" mapKeyName="EditContent"/>
			<content:editOnSight id="editOnSightHTML" contentId="${artikel.id}" attributeName="FullText" languageId="${pc.languageId}" html="${editContent}"/>
			<div class="igEditButton">
				<c:out value="${editOnSightHTML}" escapeXml="false"/>
			</div>
		</c:if>

		<%-------------------------------------%>
		<%--         Render text content     --%>
		<%-------------------------------------%>

		<div id="pageIntro">
			<div class="innerContainer">
				<h1><c:out value="${title}" escapeXml="false" /></h1>
				<common:transformText id="fixedText" text="${text}" replaceLineBreaks="true" />
				<c:if test="${not empty leadin}">
					<p><common:protectEmail prefix="${encodeEmailLabel}" value="${leadin}" /></p>
				</c:if>
				<c:if test="${not empty readMorePageUrl}">
					<p>
						<a href="<c:out value="${readMorePageUrl}" />"><c:out value="${readMoreText}" /></a>
					</p>
				</c:if>
			</div>
		</div>
		
		<div id="pageMainContent">
			<div class="innerContent">
				<content:assignedCategories id="categories" contentId="${artikel.id}" categoryKey="Type"/> 
				<c:forEach var="category" items="${categories}" varStatus="loop"> 
				    <management:categoryDisplayName id="displayName" categoryVO="${category}" /> 
				    <c:if test="${loop.count > 1}">
				    , 
				    </c:if>
				   	<c:out value="${displayName}" />
				</c:forEach>
					
				<content:assetUrl id="headlineImageUrl" contentId="${artikel.contentId}" assetKey="IngressBild" useInheritance="false"/>
				
				<c:if test="${not empty headlineImageUrl}">
					<img class="center-col-image" alt="" src="<c:out value="${headlineImageUrl}" escapeXml="false"/>" />
				</c:if>
				
				<common:protectEmail prefix="${encodeEmailLabel}" value="${text}" />
				
				<common:protectEmail prefix="${encodeEmailLabel}" value="${pdfedString}" />
			</div>
		</div>
	</c:otherwise>
</c:choose>