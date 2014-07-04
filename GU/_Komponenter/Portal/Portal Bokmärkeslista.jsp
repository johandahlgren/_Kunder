<%@page import="org.infoglue.cms.entities.management.LanguageVO"%>
<%@ page import="java.util.*,java.io.*,org.infoglue.cms.controllers.kernel.impl.simple.UserPropertiesController,org.infoglue.cms.entities.management.UserPropertiesVO"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
<%@ taglib prefix="common" uri="infoglue-common"%>
<%@ taglib prefix="content" uri="infoglue-content"%>
<%@ taglib prefix="page" uri="infoglue-page"%>
<%@ taglib prefix="structure" uri="infoglue-structure"%>
<%@ taglib uri="infoglue-management" prefix="management"%>

<page:pageContext id="pc" />
<%--
<content:content id="personFolder" propertyName="PersonFolder" />
 --%>
<h2>
	<structure:componentLabel mapKeyName="BMtitleLabel" />
</h2>

<content:contentTypeDefinition id="ctd"	contentTypeDefinitionName="GUPersonal" />
<common:urlBuilder id="currentPageUrl" excludedQueryStringParameters="userAction" />

<management:principalProperty id="bookmarks" principal="${pc.principal}" attributeName="Bookmarks" />
<%-- 
<c:set var="principal" value="${pc.principal.name}" />
<management:language id="langVO" languageCode="sv" />

<content:matchingContents id="personContents" freeText="Portal_${pc.principal.name}" freeTextAttributeNames="UserId" contentTypeDefinitionNames="GUPersonal" skipLanguageCheck="true" startNodeId="${personFolder.contentId}" />
<c:if test="${not empty personContents}">
	<c:set var="personContentId" value="${personContents[0].id}" />
	<content:contentAttribute id="bookmarks" attributeName="Bookmarks" contentId="${personContentId}" disableEditOnSight="true"/>
</c:if>
--%>
<% 
	String bookmarks = (String)pageContext.getAttribute("bookmarks"); 
%>

<c:if test="${param.refresh eq 'true'}">
	<page:deliveryContext id="dc" disablePageCache="true" />
</c:if>


<div class="portalBookmarks">
	<c:if test="${not empty bookmarks}">
		<ul class="portalLinks">
				<%
					if (bookmarks != null) 
					{
						StringTokenizer st = new StringTokenizer(bookmarks, "|");
						while (st.hasMoreTokens()) 
						{
							String token = st.nextToken();
							pageContext.setAttribute("bmSiteNode",token);
							%>
							<structure:pageUrl id="bmPageUrl" siteNodeId="${bmSiteNode}" />
							<structure:siteNode id="bmSiteNodeVO" siteNodeId="${bmSiteNode}" />
							<content:contentAttribute id="bmNavigation" contentId="${bmSiteNodeVO.metaInfoContentId}" attributeName="NavigationTitle" />
							
							<li>
								<a href="<c:out value="${bmPageUrl}" />" class="portalLink"><c:out value="${bmNavigation}" escapeXml="false" /></a>
								<%--<c:if test="${param.userAction eq 'editBookmarks'}">--%>
									<common:urlBuilder id="removeUrl" excludedQueryStringParameters="userAction,pageToUpdate" >
										<common:parameter name="userAction" value="saveBookmark" />
										<common:parameter name="pageToRemove" value="${bmSiteNode}" />
									</common:urlBuilder>
									<a href="<c:out value="${removeUrl}" />" class="removeLink" title="<structure:componentLabel mapKeyName="DeleteLinkTitleText" />">
										<img src="<content:assetUrl assetKey="cross_delete" propertyName="ImageAssets"/>" alt="<structure:componentLabel mapKeyName="DeleteLinkAltText" />" 
											onmouseover="this.src='<content:assetUrl assetKey="cross_delete_hover" propertyName="ImageAssets"/>'"
											onmouseout="this.src='<content:assetUrl assetKey="cross_delete" propertyName="ImageAssets"/>'"
											onmousedown="this.src='<content:assetUrl assetKey="cross_delete_active" propertyName="ImageAssets"/>'"
											onmouseup="this.src='<content:assetUrl assetKey="cross_delete" propertyName="ImageAssets"/>'"
										/>
									</a>
								<%--</c:if>--%>
							</li>
							<%
						}
					}												
				%>
		</ul>
	</c:if>
	<p class="bookmarksInfoText">
		<structure:componentLabel mapKeyName="BookmarksInfoText" />
	</p>
	<%--
	<div class="portalLinksForm">
		<c:choose>
			<c:when test="${param.userAction eq 'editBookmarks' and not empty bookmarks}">
				<form method="post" action="<c:out value="${currentPageUrl}" />" >
					<input type="hidden" name="userAction" value="displayLinks" />
					<input type="submit" class="portalButton" value="<structure:componentLabel mapKeyName="FinishedLabel" />" />
				</form>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${empty bookmarks}">
						<p>
							<structure:componentLabel mapKeyName="NoBookmarksCreateOne" />
						</p>
					</c:when>
					<c:otherwise>
						<structure:componentLabel id="buttonLabel" mapKeyName="EditBookmarks" />
						<form method="post" action="<c:out value="${currentPageUrl}" />">
							<fieldset>
								<input type="hidden" name="userAction" value="editBookmarks" />
								<input type="submit" class="portalButton" value="<c:out value="${buttonLabel}" />" />
							</fieldset>
						</form>
					</c:otherwise>
				</c:choose>
				
			</c:otherwise>
		</c:choose>
	</div>
	--%>
</div>