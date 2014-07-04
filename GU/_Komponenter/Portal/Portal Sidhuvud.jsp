<%@page import="org.infoglue.cms.security.AuthenticationModule"%>
<%@page import="org.infoglue.deliver.applications.databeans.DeliveryContext"%>
<%@page import="org.infoglue.cms.util.CmsPropertyHandler"%>
<%@ page import="java.util.*,java.io.*"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ taglib uri="infoglue-management" prefix="management"%>
<%@ taglib uri="infoglue-content" prefix="content"%>
<%@ taglib uri="infoglue-common" prefix="common"%>
<%@ taglib uri="infoglue-page" prefix="page"%>
<%@ taglib uri="infoglue-structure" prefix="structure"%>

<page:pageContext id="pc" />

<management:language id="saveLanguage" languageCode="sv"/>

<structure:componentLabel id="listenLangCode" mapKeyName="listenLangCode" />
<structure:pageUrl id="startPageUrl" propertyName="StartPage" useRepositoryInheritance="false" />

<management:principalProperty id="bookmarks" principal="${pc.principal}" attributeName="Bookmarks"/>
<c:set var="pageToUpdate" value="${pc.siteNodeId}" />

<c:if test="${not empty param.pageToRemove}">
	<%
		String temp = (String)request.getParameter("pageToRemove");
		Integer pageToRemove = new Integer(temp);
		pageContext.setAttribute("pageToUpdate", pageToRemove);
	%>
</c:if>

<%
 	String bookmarks = (String) pageContext.getAttribute("bookmarks");
 	Integer pageId = (Integer) pageContext.getAttribute("pageToUpdate");
 	boolean match = false;
 	if (bookmarks != null && pageId != null)
 	{
 		StringTokenizer st = new StringTokenizer(bookmarks, "|");
 		while (st.hasMoreTokens())
 		{
 			String token = st.nextToken();
 			if (token.equals(pageId.toString()))
 			{
 				match = true;
 			}
 		}
 	}
 	if (match)
 	{
 		pageContext.setAttribute("isMarked", true);
 	}
	%>

<div class="left">
	<a id="siteLogo" accesskey="1" href="<c:out value="${startPageUrl}"/>" title="<structure:componentLabel mapKeyName="logoLinkTitleText"/>">
		<img id="leftLogotype" src="<content:assetUrl propertyName="Resources" assetKey="logoWeb"/>" alt="<structure:componentLabel mapKeyName="logoLinkAltText"/>"/>
	</a>
</div>

<c:if test="${hasConfirmed}" >
<div class="bookmarkSwitch">
	<common:urlBuilder id="saveBookmarkLink" excludedQueryStringParameters="userAction" >
		<common:parameter name="userAction" value="saveBookmark" />
	</common:urlBuilder>
	<c:choose>			
		<c:when test="${isMarked}">
			<a href="<c:out value="${saveBookmarkLink}" />" title="<structure:componentLabel mapKeyName="RemoveBookmarkTitleText" />">
				<img src="<content:assetUrl assetKey="icon_bookmark_selected" propertyName="ImageAssets"/>" alt="<structure:componentLabel mapKeyName="RemoveBookmarkAltText" />" 
					onmouseover="this.src='<content:assetUrl assetKey="icon_bookmark_hover" propertyName="ImageAssets"/>'"
					onmouseout="this.src='<content:assetUrl assetKey="icon_bookmark_selected" propertyName="ImageAssets"/>'"
					onmousedown="this.src='<content:assetUrl assetKey="icon_bookmark_active" propertyName="ImageAssets"/>'"
					onmouseup="this.src='<content:assetUrl assetKey="icon_bookmark_selected" propertyName="ImageAssets"/>'"
				/>
			</a>
		</c:when>
		<c:otherwise>
			<a href="<c:out value="${saveBookmarkLink}" />" title="<structure:componentLabel mapKeyName="AddBookmarkTitleText" />">
				<img src="<content:assetUrl assetKey="icon_bookmark" propertyName="ImageAssets"/>" alt="<structure:componentLabel mapKeyName="AddBookmarkAltText" />" 
					onmouseover="this.src='<content:assetUrl assetKey="icon_bookmark_hover" propertyName="ImageAssets"/>'"
					onmouseout="this.src='<content:assetUrl assetKey="icon_bookmark" propertyName="ImageAssets"/>'"
					onmousedown="this.src='<content:assetUrl assetKey="icon_bookmark_active" propertyName="ImageAssets"/>'"
					onmouseup="this.src='<content:assetUrl assetKey="icon_bookmark" propertyName="ImageAssets"/>'"
				/>
			</a>
		</c:otherwise>
	</c:choose>
</div>
</c:if>

<div class="right">
	<%-- ####  Language handling ##################################  --%>
	<management:language id="currentLanguage" languageId="${pc.languageId}" />
	<structure:componentLabel id="changeLanguageLinkTitle" mapKeyName="ChangeLanguageLinkTitle" />
	<c:set var="newLanguage" value="en" />
	<c:set var="newLanguageTitle"><structure:componentLabel mapKeyName="ChangeLanguageTitleToEnglish" /></c:set>
	<c:if test="${currentLanguage.languageCode eq 'en'}">
		<c:set var="newLanguage" value="sv" />
		<c:set var="newLanguageTitle"><structure:componentLabel mapKeyName="ChangeLanguageTitleToSwedish" /></c:set>
	</c:if>
	<common:urlBuilder id="changeLanguageUrl">
		<common:parameter name="userAction" value="changeLanguage" />
		<common:parameter name="changeToLanguage" value="${newLanguage}" />
	</common:urlBuilder>
	
	 <%--	
	 	<li><a href="<c:out value="${postUrl}"/>" accesskey="8" title="<structure:componentLabel mapKeyName="adjustLinkTitle"/>" rel="nofollow"><structure:componentLabel mapKeyName="adjustLinkLabel"/></a> </li>
	 	<li><a href="#" onclick="insipio_setReferer()" title="<structure:componentLabel mapKeyName="listenTitle"/>"><structure:componentLabel mapKeyName="listenLabel"/></a></li> 
	 --%>

	<%-- TODO: fixfix --%>
	
	<common:urlBuilder id="customizePage" excludedQueryStringParameters="adjust,returnAddress,returnUrl,saveAdjust,saveAndClose" fullBaseUrl="true">
		<common:parameter name="userAction" value="adjust" />
	</common:urlBuilder>
	<common:URLEncode id="customizePage" value="${customizePage}" />
	<c:set var="serverName"><%=pageContext.getRequest().getServerName()%></c:set>
	<c:choose>
		<c:when test="${serverName == 'dev.cms.it.gu.se' || serverName == 'cms.it.gu.se'}">
			<common:urlBuilder id="postUrl" baseURL="/infoglueDeliverWorking/jsp/retrieveAdjust.jsp" excludedQueryStringParameters="saveAndClose,textFontSize,letterSpace,fontFamily,textLineHeight,contrast,wordspace,textFontSize,letterSpace,fontFamily,textLineHeight,contrast,wordspace">
				<common:parameter name="returnAddress" value="${customizePage}" />
			</common:urlBuilder>
		</c:when>
		<c:otherwise>
			<common:urlBuilder id="postUrl" baseURL="http://www.gu.se/jsp/retrieveAdjust.jsp" excludedQueryStringParameters="saveAndClose,textFontSize,letterSpace,fontFamily,textLineHeight,contrast,wordspace,textFontSize,letterSpace,fontFamily,textLineHeight,contrast,wordspace">
				<common:parameter name="returnAddress" value="${customizePage}" />
			</common:urlBuilder>
		</c:otherwise>
	</c:choose>
	
	<common:urlBuilder id="guListenUrl" fullBaseUrl="true" />
	<ul class="linklist">
		<%--
		<c:if test="${hasConfirmed}">
			<li class="first"><a href="<c:out value="${postUrl}"/>" accesskey="8" title="<structure:componentLabel mapKeyName="adjustLinkTitle"/>" rel="nofollow"><structure:componentLabel mapKeyName="adjustLinkLabel" /></a></li>
			<li><a href="http://spoxy4.insipio.com/generator/<c:out value="${listenLangCode}"/>/<c:out value="${guListenUrl}" escapeXml="true"/>"><structure:componentLabel mapKeyName="listenLabel" /></a></li>
		</c:if>
		<li class="<c:if test="${not hasConfirmed}">first </c:if>last"><a href="<c:out value="${changeLanguageUrl}"/>" class="whitelink1" title="<c:out value="${changeLanguageLinkTitle}"/>"><c:out value="${newLanguageTitle}" /></a></li>
		--%>
		<li class="first last"><a href="<c:out value="${changeLanguageUrl}"/>" class="whitelink1" title="<c:out value="${changeLanguageLinkTitle}"/>"><c:out value="${newLanguageTitle}" /></a></li>
	</ul>
	
	

	<common:urlBuilder id="currentPageUrl" excludedQueryStringParameters="userAction" />

	<c:if test="${param.userAction eq 'changeLanguage'}">
		<management:language id="newLanguage" languageCode="${param.changeToLanguage}" />
				
		<c:if test="${not empty newLanguage}">
			
			<content:contentTypeDefinition id="ctd" contentTypeDefinitionName="GUPersonal" />
			<management:remoteUserPropertiesService id="status" principal="${pc.principal}" languageId="${saveLanguage.languageId}" contentTypeDefinitionId="${ctd.contentTypeDefinitionId}" operationName="updateUserProperties" forcePublication="true" keepExistingAttributes="true">
				<management:userPropertiesAttributeParameter name="PreferredPortalLanguage" value="${param.changeToLanguage}" />
			</management:remoteUserPropertiesService>
			
			<c:if test="${status eq true}">
				<structure:pageUrlAfterLanguageChange id="newLanguageUrl" languageCode="${newLanguage.languageCode}" />
				<common:sendRedirect url="${newLanguageUrl}" />
			</c:if>
			status: <c:out value="${status}"/><br/>
		</c:if>
	</c:if>
 	
 	<c:if test="${param.userAction eq 'saveBookmark'}">
		<%
			if (match)
			{
				bookmarks = bookmarks.replace((pageId + "|"), "");
				pageContext.setAttribute("updateBookmarks", bookmarks);
			}
			else
			{
				bookmarks += pageId + "|";
				pageContext.setAttribute("updateBookmarks", bookmarks);
			}
		%>
		
		<management:remoteUserPropertiesService principal="${pc.principal}" id="result" contentTypeDefinitionId="${ctd.contentTypeDefinitionId}" operationName="updateUserProperties" forcePublication="true" languageId="${saveLanguage.languageId}" keepExistingAttributes="true">
			<management:userPropertiesAttributeParameter name="Bookmarks" value="${updateBookmarks}" />
		</management:remoteUserPropertiesService>
		<c:choose>
			<c:when test="${result ne true}">
			    result: <c:out value="${result}" /><br />
			</c:when>
			<c:otherwise>
				<common:urlBuilder id="url" excludedQueryStringParameters="userAction,refresh,pageToUpdate,pageToRemove" >
					<c:if test="${not empty param.pageToRemove}">
						<common:parameter name="userAction" value="editBookmarks" />
					</c:if>
					<common:parameter name="refresh" value="true" />
				</common:urlBuilder>
				<common:sendRedirect url="${url}" />
			</c:otherwise>
		</c:choose>
	</c:if>
	
	<div class="left"></div>
	<div class="right"></div>
</div>
<div class="clr"></div>
