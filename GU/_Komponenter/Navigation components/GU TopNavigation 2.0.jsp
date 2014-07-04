<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController"%>
<%@ page import="org.infoglue.cms.controllers.kernel.impl.simple.RepositoryController"%>
<%@ page import="org.infoglue.deliver.controllers.kernel.impl.simple.TemplateController"%>

<page:pageContext id="pc"/>

	<%
		org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController templateController = (org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
		Integer contentId 	= templateController.getMetaInformationContentId(templateController.getSiteNodeId());
		
		String navigationTitle = templateController.getContentAttributeUsingLanguageFallback(contentId, "NavigationTitle", false);
		pageContext.setAttribute("navigationTitle", navigationTitle);
	%>

<page:pageAttribute id="InstutitionsTopNavigationName" name="InstutitionsTopNavigationName"/>
<page:pageAttribute id="ShowInstutitionsTopNavigation" name="ShowInstutitionsTopNavigation"/>

<c:if test="${ShowInstutitionsTopNavigation == 'yes'}">
<page:pageAttribute id="instutitionsTopNavigationLink" name="InstutitionsTopNavigationLink" />
<div id="space_modifications">
	<div class="sitename">
		<c:choose>
			<c:when test="${instutitionsTopNavigationName != ''}">
				<c:if test="${instutitionsTopNavigationLink != ''}"><a href="<c:out value="${instutitionsTopNavigationLink}" escapeXml="true"/>" ></c:if><c:out value="${InstutitionsTopNavigationName}" escapeXml="false" /><c:if test="${instutitionsTopNavigationLink != ''}"></a></c:if>
			</c:when>
			<c:otherwise>
				<c:if test="${instutitionsTopNavigationLink != ''}"><a href="<c:out value="${instutitionsTopNavigationLink}" escapeXml="true"/>"></c:if><c:out value="${navigationTitle}" escapeXml="false" /><c:if test="${instutitionsTopNavigationLink != ''}"></a></c:if>
			</c:otherwise>
		</c:choose>
	</div>
</c:if>

<structure:componentPropertyValue id="useTopMenu" propertyName="UseTopMenu" useRepositoryInheritance="false"/>
<structure:pageUrl id="siteStartPageUrl" propertyName="SiteStartPage" useRepositoryInheritance="false"/>
<c:if test="${empty siteStartPageUrl}">
	<structure:pageUrl id="siteStartPageUrl" propertyName="MenuBasePage" useRepositoryInheritance="false"/>
</c:if>

<c:choose>
	<c:when test="${empty useTopMenu || useTopMenu == 'false'}">

		<structure:componentPropertyValue id="facultyName" propertyName="FacultyName"/>
		<c:if test="${empty facultyName || facultyName == 'Undefined'}">
			<structure:componentPropertyValue id="facultyName" propertyName="Fakultet"/>
			<c:if test="${empty facultyName || facultyName == 'Undefined'}">
				<structure:boundPage id="menuBasePage" propertyName="MenuBasePage" useRepositoryInheritance="false"/>
				<c:set var="facultyName" value="${menuBasePage.navigationTitle}"/>
				<c:set var="siteStartPageUrl" value="${menuBasePage.url}"/>
			</c:if>
		</c:if>
		<c:if test="${not empty facultyName && facultyName != 'Undefined'}">
			<h1><a accesskey="1" href="<c:out value="${siteStartPageUrl}" escapeXml="false"/>" title="<structure:componentLabel mapKeyName="startPageLinkTitle"/> <c:out value="${facultyName}"/>"><c:out value="${facultyName}" escapeXml="false"/></a></h1>
		</c:if>
	</c:when>
	<c:otherwise>

		<structure:childPages id="childPages" propertyName="SiteStartPage"/>
		<structure:sortPages id="childPages" input="${childPages}"/>
		<structure:sortPages id="childPages" input="${childPages}" sortProperty="SortOrder" sortOrder="asc" namesInOrderString="Aktuellt,Utbildning,Forskarutbildning,Forskning,Samverkan"/>
		
		<ul class="linklist">
			<c:forEach var="childPage" items="${childPages}"> 
				<content:contentAttribute id="hideInNavigation" contentId="${childPage.metaInfoContentId}" attributeName="hideInNavigation" disableEditOnSight="true"/>
				<content:contentAttribute id="titleDebug" contentId="${childPage.metaInfoContentId}" attributeName="Title" disableEditOnSight="true"/>
			    <c:if test="${hideInNavigation != 'true' && titleDebug != ''}">
		        	<structure:isSiteNodeParentToCurrentSiteNode id="mark1" siteNodeId="${block1Page.siteNodeId}"/>
		            <content:contentAttribute id="desc" contentId="${childPage.metaInfoContentId}" attributeName="Description" disableEditOnSight="true"/>
					<structure:isCurrentSiteNode id="isCurrentNode" siteNodeId="${childPage.siteNodeId}"/>
					<structure:isSiteNodeParentToCurrentSiteNode id="mark" siteNodeId="${childPage.siteNodeId}"/>
					
					<c:set var="externalURL" value=""/>   
					<structure:relatedPages id="internalPages" contentId="${childPage.metaInfoContentId}" attributeName="internalPage" />
					<c:if test="${not empty internalPages}">
						<common:size id="internalPagesSize" list="${internalPages}"/>
						<c:if test="${internalPagesSize > 0}">
							<c:set var="externalURL" value="${internalPages[0].url}"/>
							<structure:siteNode id="internalSiteNodeVO" siteNodeId="${internalPages[0].siteNodeId}"/>
							<c:if test="${pc.repositoryId == internalSiteNodeVO.repositoryId}">
								<c:set var="mark" value="true"/>
							</c:if>
						</c:if>
					</c:if>
					<c:if test="${empty externalURL}">
						<content:contentAttribute id="externalURL" contentId="${childPage.metaInfoContentId}" attributeName="externalUrl" disableEditOnSight="true"/>
						<c:if test="${externalURL != null && externalURL != ''}">
						    <c:set var="externalURL" value="${externalURL}"/>                                          
						</c:if>  
					</c:if>
					
					<li <c:if test="${mark}">class="current"</c:if>><a href="<c:choose><c:when test="${not empty externalURL}"><c:out value="${externalURL}"/></c:when><c:otherwise><c:out value="${childPage.url}"/></c:otherwise></c:choose>"><c:out value="${childPage.navigationTitle}" escapeXml="false"/></a></li>
				</c:if>
			</c:forEach>
		</ul>
	
	</c:otherwise>
</c:choose>

<structure:componentPropertyValue id="showSearchField" propertyName="ShowSearchField" useRepositoryInheritance="false"/>
<c:if test="${showSearchField != 'false'}">

	<structure:boundPage id="resultPage" propertyName="ResultPage" useInheritance="false"/>
	<c:if test="${resultPage == null}">
		<structure:boundPage id="resultPage" propertyName="WebSearchResultPage"/>
	</c:if>
	
	<common:transformText id="searchPageNavigationTitle" text="${searchPage.navigationTitle}" replaceString="\\s" replaceWithString="&nbsp;"/>
	<content:contentAttribute id="searchPageTitle" contentId="${searchPage.metaInfoContentId}" attributeName="Description" disableEditOnSight="true"/>
	
	<common:urlBuilder id="searchPageUrl" excludedQueryStringParameters="siteMap,siteSearch" />
	
	<structure:componentPropertyValue id="useLocalA2OPage" propertyName="UseLocalA2OPage" useRepositoryInheritance="false"/>
	<c:choose>
		<c:when test="${empty useLocalA2OPage || useLocalA2OPage != 'true'}">
		
			<c:set var="serverName"><%=pageContext.getRequest().getServerName()%></c:set>
			<c:choose>
				<c:when test="${serverName == 'dev.cms.it.gu.se'}">
					<c:set var="A2OSiteNodeId" value="111635"/>
					<c:if test="${pc.locale == 'en'}">
						<c:set var="A2OSiteNodeId" value="111896"/>
					</c:if>					
				</c:when>
				<c:otherwise>
					<c:set var="A2OSiteNodeId" value="532551"/>
					<c:if test="${pc.locale == 'en'}">
						<c:set var="A2OSiteNodeId" value="532611"/>
					</c:if>					
				</c:otherwise>
			</c:choose>
			<structure:siteNode id="A2OSiteNode" siteNodeId="${A2OSiteNodeId}"/>
		</c:when>
		<c:otherwise>
			<structure:siteNode id="A2OSiteNode" propertyName="A2OPage"/>
		</c:otherwise>
	</c:choose>
	<structure:pageUrl id="A2OPageUrl" siteNodeId="${A2OSiteNode.siteNodeId}"/>
	<content:contentAttribute id="A2ONavigationTitle" contentId="${A2OSiteNode.metaInfoContentId}" attributeName="NavigationTitle" disableEditOnSight="true"/>
	
	<structure:componentPropertyValue id="headerType" propertyName="HeaderType"/>
	<c:if test="${empty headerType || headerType == 'false'}">
		<c:set var="headerType" value="standardGU"/>
	</c:if>
	<%
		BasicTemplateController btc = (BasicTemplateController) pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
		String siteSeekerQcUrl 		=  btc.getRepositoryExtraProperty("siteSeekerApplianceQcUrl");
if(siteSeekerQcUrl== null || siteSeekerQcUrl == "") {
		siteSeekerQcUrl 		= "http://goteborgsuniversitet.appliance.siteseeker.se/qc/webbindex/";
}
		pageContext.setAttribute("siteSeekerQcUrl", siteSeekerQcUrl);
	%>
	
	<script type="text/javascript">
	<!--
		jQuery(document).ready(function() {
		    $('#searchText').autocomplete(
		      '<c:out value="${siteSeekerQcUrl}"/>', 
		      { 
		        cacheLength: 0,
		        extraParams: { ilang: '<c:out value="${currentLanguage.languageCode}"/>' },
		        delay: 200,
	        	resultsClass: "ac_results",
	        	width: "20em",
	        	additionalHeight: 7,
	        	minChars: 2,
	        	additionalLeft: -140,
		        selectFirst: false,
		        dataType: 'jsonp',
		        highlight: false,
		        scroll: false,
		        parse: function(data) {
		          return jQuery.map(data, function(row) {
		            return {data: row};
		          });
		        },
		        formatItem: function(item) {
		          if (item) {
		          	/* var nHitString = "<span>" + item.nHits + "</span>"; */
		            return '<a href="" class="html">'+item.suggestionHighlighted+'</a>';
		          }
		          return;
		        }
		      }
		    )
		    .result(function(event, item) {
		      jQuery('#searchText').val(item.suggestion);
		      jQuery('#searchFormImageSubmit').click();
		 	});
		});
	//-->
	</script>

	<form method="get" name="searchForm" action="<c:out value='${searchPageUrl}'/>" class="search">
		<fieldset>
			<input name="siteNodeId" type="hidden" value="<c:out value="${pc.siteNodeId}" />" />
			<a href="<c:out value="${A2OPageUrl}" escapeXml="true"/>" title="<structure:componentLabel mapKeyName="contentAOTitle"/>" class="divider"><c:out value="${A2ONavigationTitle}" escapeXml="true"/></a>
			<label for="searchText" <c:if test="${not empty param.searchText}">class="current"</c:if>><structure:componentLabel mapKeyName="searchLabel"/></label>		
			<input name="siteSearch" type="hidden" value="true"/>
			<c:choose>
				<c:when test="${headerType == 'level3page'}">
					<input name="searchText" accesskey="4" type="text" value="" id="searchText" title="<structure:componentLabel mapKeyName="searchWordLevel3Title"/>" class="searchfield" />
				</c:when>
				<c:otherwise>
					<input name="searchText" accesskey="4" type="text" value="" id="searchText" title="<structure:componentLabel mapKeyName="searchWordTitle"/>" class="searchfield" />
				</c:otherwise>
			</c:choose>
			<input type="image" title="<structure:componentLabel mapKeyName="searchButtonTitle"/>" src="<content:assetUrl propertyName="Mallbilder" assetKey="submitWhite"/>" style="color:#fff;"/>
			<noscript>
				<input name="isJavascriptSupported" type="hidden" value="false"/>
			</noscript>
		</fieldset>
		<input name="b" type="hidden" value="1"/>
		<input name="da" type="hidden" value="0"/>
		<input name="hd" type="hidden" value="1"/>
		<input name="hn" type="hidden" value="10"/>
	</form>
	
</c:if>
<c:if test="${ShowInstutitionsTopNavigation == 'yes'}">
</div>
</c:if>

<div class="clr"></div>
