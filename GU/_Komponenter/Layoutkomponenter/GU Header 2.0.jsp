<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>

<page:pageContext id="pc"/>

<structure:componentLabel id="listenLangCode" mapKeyName="listenLangCode"/>

<structure:boundPage id="leftLogoPage" propertyName="LeftLogoPage" useRepositoryInheritance="false"/>
<structure:boundPage id="rightLogoPage" propertyName="RightLogoPage" useRepositoryInheritance="false"/>
<content:contentAttribute id="leftLogoPageExternalUrl" attributeName="externalUrl" contentId="${leftLogoPage.metaInfoContentId}" disableEditOnSight="true"/>
<content:contentAttribute id="rightLogoPageExternalUrl" attributeName="externalUrl" contentId="${rightLogoPage.metaInfoContentId}" disableEditOnSight="true"/>
<c:set var="leftLogoPageUrl" value="${leftLogoPage.url}"/>
<c:if test="${not empty leftLogoPageExternalUrl}">
	<c:set var="leftLogoPageUrl" value="${leftLogoPageExternalUrl}"/>
</c:if>
<c:set var="rightLogoPageUrl" value="${rightLogoPage.url}"/>
<c:if test="${not empty rightLogoPageExternalUrl}">
	<c:set var="rightLogoPageUrl" value="${rightLogoPageExternalUrl}"/>
</c:if>

<structure:pageUrl id="siteStartPageUrl" propertyName="SiteStartPage" useRepositoryInheritance="false"/>
<c:if test="${empty siteStartPageUrl}">
	<structure:pageUrl id="siteStartPageUrl" propertyName="MenuBasePage" useRepositoryInheritance="false"/>
</c:if>

<structure:componentPropertyValue id="headerType" propertyName="HeaderType"/>
<c:if test="${empty headerType || headerType == 'false'}"><c:set var="headerType" value="standardGU"/></c:if>
<structure:componentPropertyValue id="level3PageAlternativeClass" propertyName="Level3PageAlternativeClass"/>
			
<div class="left">
	<a <c:if test="${siteStartPageUrl eq leftLogoPageUrl}">accesskey="1"</c:if> href="<c:out value="${leftLogoPageUrl}"/>" title="<structure:componentLabel mapKeyName="startPageLinkTitle"/> <c:out value="${leftLogoPage.navigationTitle}"/>">
		<img id="leftLogotype" src="<content:assetUrl propertyName="LeftLogotype" assetKey="webb"/>" alt="<c:out value="${leftLogoPage.navigationTitle}"/>"/>
	</a>
	<c:if test="${headerType == 'standardGU' && not empty rightLogoPage}">
		<img src="<content:assetUrl assetKey="logoDivider"/>" alt="divider"/>
		<a href="<c:out value="${rightLogoPageUrl}"/>" title="<structure:componentLabel mapKeyName="startPageLinkTitle"/> <c:out value="${rightLogoPage.navigationTitle}"/>">
			<img src="<content:assetUrl propertyName="RightLogotype" assetKey="webb"/>" alt="<c:out value="${rightLogoPage.navigationTitle}"/>"/>
		</a>
	</c:if>
</div>

<div class="right">
	<c:choose>
		<c:when test="${headerType == 'level3page'}">
			
			<content:content id="content" propertyName="Level3PageHeaderArticle" useInheritance="false"/>
			
		  	<c:choose>
				<c:when test="${level3PageAlternativeClass != '' and content != null}">
					<content:contentAttribute id="fullText" contentId="${content.id}" attributeName="FullText"/>
					<c:out value="${fullText}" escapeXml="false"/>
				</c:when>
				<c:otherwise>
				<a href="<c:out value="${rightLogoPageUrl}"/>" title="<content:contentAttribute propertyName="RightLogotype" attributeName="NavigationTitle" disableEditOnSight="true"/>">
					<img src="<content:assetUrl propertyName="RightLogotype" assetKey="webb"/>" alt="<content:contentAttribute propertyName="RightLogotype" attributeName="Alt" disableEditOnSight="true"/>"/>
				</a>
				</c:otherwise>
			</c:choose>
		</c:when>
		<c:otherwise>
		
			<%-- The alternative language is coming from the GU 3 columnsida through it's pretemplate --%>
			<structure:componentPropertyValue id="redirectToEnglish" propertyName="AlternateLanguagePageFirst" useInheritance="false"/>
			<structure:boundPage id="alternateLanguageStartPage" propertyName="AlternateLanguageStartPage"/>
			<c:set var="availableLanguages" value="${pc.availableLanguages}"/>
			<!--The alternative languages are <c:out value="${availableLanguages}"/>-->
			<c:forEach var="language" items="${availableLanguages}" varStatus="count">
				<c:if test="${language.id != pc.languageId}">
				  <c:set var="alternativeLanguage" value="${language}"/>
				</c:if>
			</c:forEach>
			
			<%-- Checking if the current content if any has the alternative language version also --%>
			<c:set var="hasAlternativeContentVersion" value="true"/>
			<c:if test="${pc.contentId > 0}">
				<c:set var="hasAlternativeContentVersion" value="false"/>
				<content:content id="currentContent" contentId="${pc.contentId}"/>
				<c:if test="${not empty currentContent}">
					<content:contentVersion id="alternativeContentVersion" content="${currentContent}" languageId="${alternativeLanguage.id}" useLanguageFallback="false"/>
					<c:if test="${not empty alternativeContentVersion}">
						<c:set var="hasAlternativeContentVersion" value="true"/>
					</c:if>
				</c:if>
			</c:if>

			<!--The alternative language is <c:out value="${alternativeLanguage.id}"/>-->
			<common:urlBuilder id="currentLangUrl" fullBaseUrl="true" excludedQueryStringParameters="disableRedirect,returnUrl"/>
			<common:URLEncode id="currentLangUrl" value="${currentLangUrl}"/>

			<c:set var="alternateLanguageStartPageTestUrl" value="${alternateLanguageStartPage.url}"/>	
			<%
			String alternateLanguageStartPageTestUrl = (String)pageContext.getAttribute("alternateLanguageStartPageTestUrl");
			boolean usesNiceURI = (alternateLanguageStartPageTestUrl.indexOf("ViewPage") > -1 ? false : true);
			pageContext.setAttribute("usesNiceURI", usesNiceURI);
			%>
			<c:choose>
				<c:when test="${usesNiceURI}">
					<structure:pageUrl id="alternateLanguageStartPageUrl" propertyName="AlternateLanguageStartPage" useRepositoryInheritance="false" languageId="${alternativeLanguage.id}"/>
                    <%-- FULLÖSNING FÖR ATT KOMMA RUNT ATT VISSA SIDOR HAR TOMMA PUBLICERADE METAINFO PÅ NUVARANDE SPRÅK --%>
                    <common:transformText id="alternateLanguageStartPageUrl" text="${alternateLanguageStartPageUrl}" replaceString="\?.*" replaceWithString=""/>
					<common:urlBuilder id="alternateLanguageStartPageUrl" baseURL="${alternateLanguageStartPageUrl}" excludedQueryStringParameters="siteNodeId,languageId,contentId,disableRedirect,returnUrl">
						<common:parameter name="languageId" value="${alternativeLanguage.id}"/>
						<common:parameter name="contentId" value="${pc.contentId}"/>
						<common:parameter name="disableRedirect" value="true"/>
						<common:parameter name="returnUrl" value="${currentLangUrl}"/>
					</common:urlBuilder>
				</c:when>
				<c:otherwise>
					<structure:pageUrl id="alternateLanguageStartPageUrl" propertyName="AlternateLanguageStartPage" languageId="${alternativeLanguage.id}" contentId="${pc.contentId}" useRepositoryInheritance="false"/>
					<common:urlBuilder id="alternateLanguageStartPageUrl" baseURL="${alternateLanguageStartPageUrl}" excludedQueryStringParameters="siteNodeId,languageId,contentId,disableRedirect,returnUrl">
						<common:parameter name="disableRedirect" value="true"/>
						<common:parameter name="returnUrl" value="${currentLangUrl}"/>
					</common:urlBuilder>
				</c:otherwise>
			</c:choose>
						
			<c:if test="${redirectToEnglish == 'true' && skipRedirect != true && param.disableRedirect != 'true'}">
				<c:set var="originalResponse" value="${dc.httpServletResponse}"/>
			  	<page:deliveryContext id="dc" useFullUrl="true" disablePageCache="true"/>
			  	<structure:boundPage id="redirectPage" propertyName="AlternateLanguageStartPage" useInheritance="false"/>
				<common:sendRedirect url="${redirectPage.url}"/>
			</c:if>
			
			<c:if test="${param.disableRedirect == 'true'}">
			  	<c:set var="skipRedirect" value="true" scope="session"/>
				<!--Skipping redirect from now on...-->
			</c:if>
			
			<c:if test="${redirectToEnglish == null || redirectToEnglish == ''}">
			  	<c:set var="skipRedirect" value="false" scope="session"/>
				<!--Using redirect from now on...-->
			</c:if>
			
			<!-- Kopia av Anpassagrejer -->
			<common:urlBuilder id="customizePage" excludedQueryStringParameters="adjust,returnAddress,returnUrl,saveAdjust,saveAndClose" fullBaseUrl="true">
				<common:parameter name="adjust" value="true"/>
				<%--<common:parameter name="refresh" value="true"/>--%>
			</common:urlBuilder>
			
			<common:URLEncode id="customizePage" value="${customizePage}"/>
					
			<c:set var="serverName"><%=pageContext.getRequest().getServerName()%></c:set>
			<c:choose>
				<c:when test="${serverName == 'dev.cms.it.gu.se' || serverName == 'cms.it.gu.se'}">
					<common:urlBuilder id="postUrl" baseURL="/infoglueDeliverWorking/jsp/retrieveAdjust.jsp" excludedQueryStringParameters="saveAndClose,textFontSize,letterSpace,fontFamily,textLineHeight,contrast,wordspace,textFontSize,letterSpace,fontFamily,textLineHeight,contrast,wordspace">
						<common:parameter name="returnAddress" value="${customizePage}"/>
					</common:urlBuilder>
				</c:when>
				<c:otherwise>
					<common:urlBuilder id="postUrl" baseURL="http://www.gu.se/jsp/retrieveAdjust.jsp" excludedQueryStringParameters="saveAndClose,textFontSize,letterSpace,fontFamily,textLineHeight,contrast,wordspace,textFontSize,letterSpace,fontFamily,textLineHeight,contrast,wordspace">
						<common:parameter name="returnAddress" value="${customizePage}"/>
					</common:urlBuilder>
				</c:otherwise>
			</c:choose>
			<!-- / Slut Kopia av Anpassagrejer -->
			
			<common:urlBuilder id="guListenUrl" fullBaseUrl="true"/>	
		
			<ul class="linklist">
				<li class="first"><a href="<c:out value="${postUrl}"/>" accesskey="8" title="<structure:componentLabel mapKeyName="adjustLinkTitle"/>" rel="nofollow"><structure:componentLabel mapKeyName="adjustLinkLabel"/></a></li>
				<c:choose>
					<c:when test="${not empty alternateLanguageStartPage && alternateLanguageStartPage != 'Undefined' && hasAlternativeContentVersion}">
					    <li><a href="http://spoxy4.insipio.com/generator/<c:out value="${listenLangCode}"/>/<c:out value="${guListenUrl}" escapeXml="true"/>"><structure:componentLabel mapKeyName="listenLabel"/></a></li>
						<li class="last"><span lang="<c:out value="${alternativeLanguage.languageCode}"/>"><a href="<c:out value="${alternateLanguageStartPageUrl}"/>" class="whitelink1" title="<structure:componentLabel mapKeyName="alternativeLanguageLinkTitle"/> <c:out value="${alternateLanguageStartPage.navigationTitle}"/>"><structure:componentLabel mapKeyName="languageChangePrefix"/>&nbsp;<c:out value="${alternativeLanguage.localizedDisplayLanguage}"/></a></span></li>
					</c:when>
					<c:otherwise>
                        <li class="last"><a href="http://spoxy4.insipio.com/generator/<c:out value="${listenLangCode}"/>/<c:out value="${guListenUrl}" escapeXml="false"/>"><structure:componentLabel mapKeyName="listenLabel"/></a></li>
					</c:otherwise>
				</c:choose>	
			</ul>
			<div class="left"></div>
			<div class="right"></div>
		</c:otherwise>
	</c:choose>
</div>
<div class="clr"></div>
						