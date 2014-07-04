<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>

<page:pageContext id="pc"/>

<!-- eri-no-index -->

<content:boundContents id="banners" propertyName="Banners" useInheritance="false" />
<structure:componentPropertyValue id="maxTextLength" propertyName="MaxTextLength" useInheritance="false" />
<structure:componentPropertyValue id="encodeEmailLabel" propertyName="EmailProtectionLabel" useInheritance="true"/>

<div class="bannerBlock">
	<div class="innerContainer">
		<c:choose>
			<c:when test="${empty banners}">
				<c:if test="${pc.isDecorated}">
					<div class="banner <c:out value="${extraClass}"/>">
						<div class="innerContainer">
							<h2><structure:componentLabel mapKeyName="DefaultHeadline"/></h2>
							<div class="adminMessage">
								<structure:componentLabel mapKeyName="NoBannerSelected"/>
							</div>
						</div>
					</div>
				</c:if>
			</c:when>
			<c:otherwise>
				<common:size id="numberOfItems" list="${banners}" />
				<%
					int counter = 0;
					int numberOfItems = (Integer)pageContext.getAttribute("numberOfItems");
				%>
				<c:forEach var="banner" items="${banners}" varStatus="loop">
					<%
						if (counter % 2 == 0)
						{
							if (pageContext.getAttribute("extraClass") != null && ((String)pageContext.getAttribute("extraClass")).equals("evenRow"))
							{
								pageContext.setAttribute("extraClass", "oddRow");
							}
							else
							{
								pageContext.setAttribute("extraClass", "evenRow");
							}
							%>
								<div class="bannerPair <c:out value="${extraClass}"/>">
							<%
						}
					%>
					
					<content:contentAttribute id="title" attributeName="Title" contentId="${banner.contentId}" disableEditOnSight="true" />
					<content:contentAttribute id="text" attributeName="Text" contentId="${banner.contentId}" disableEditOnSight="true" />
					
					<structure:relatedPages id="detailPages" attributeName="DetailPage" contentId="${banner.id}" />
		 	 	
			 	 	<c:if test="${not empty detailPages}">
			 	 		<c:set var="detailPage" value="${detailPages[0]}" />
			 	 	</c:if>
			 	 	
			 	 	<% pageContext.setAttribute("textLength", pageContext.getAttribute("text").toString().length()); %>
			 	 	<c:if test="${textLength gt maxTextLength}">
						<common:cropText id="text" text="${text}" maxLength="${maxTextLength}" suffix="..." />
					</c:if>
					
					<div class="banner">
						<div class="innerContainer">
							<h2><c:out value="${title}" escapeXml="false"/></h2>
							<p><a href="<c:out value="${detailPage.url}"/>"><common:protectEmail prefix="${encodeEmailLabel}" value="${text}" /></a></p>
						</div>
					</div>
					
					<%
						if (counter % 2 == 1 || counter == numberOfItems - 1)
						{
							%>
								</div>
							<%
						}
						counter ++;
					%>
				</c:forEach>
			</c:otherwise>
		</c:choose>
	</div>
</div>

<!-- /eri-no-index -->