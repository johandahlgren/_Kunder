<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-page" prefix="tl" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib uri="http://jakarta.apache.org/taglibs/mailer-1.1" prefix="mt" %>

<%@ page contentType="text/html; charset=UTF-8" %>

<%@ page import="java.util.regex.Matcher" %>
<%@ page import="java.util.regex.Pattern" %>
<%@ page import="java.security.MessageDigest" %>
<%@ page import="java.util.Formatter" %>

<%@page import="java.net.URLDecoder"%>
<%@page import="java.net.URLEncoder"%>

<%@ page import="org.infoglue.cms.controllers.kernel.impl.simple.SiteNodeController" %>
<%@ page import="org.infoglue.cms.entities.structure.SiteNodeVO" %>

<page:pageContext id="pc"/>
<page:deliveryContext id="dc"/>

<%
org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController controller = (org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
String siteSeekerQcUrl 		=  controller.getRepositoryExtraProperty("siteSeekerQcUrl");
	
String numberOfResultsPerPage = controller.getRepositoryExtraProperty("numberOfResultsPerPage");
String numberOfResultsPerPagePersonnel = controller.getRepositoryExtraProperty("numberOfResultsPerPagePersonnel");
String site = controller.getRepositoryExtraProperty("site");
String categoryAllWeb = controller.getRepositoryExtraProperty("categoryAllWeb");
String categoryEducation = controller.getRepositoryExtraProperty("categoryEducation");
String categoryResearch = controller.getRepositoryExtraProperty("categoryResearch");
String categoryCooperation = controller.getRepositoryExtraProperty("categoryCooperation");
String categoryNews = controller.getRepositoryExtraProperty("categoryNews");
String categoryEvents = controller.getRepositoryExtraProperty("categoryEvents");
String categoryPersonnel = controller.getRepositoryExtraProperty("categoryPersonnel");
String noCharactersInURL = controller.getRepositoryExtraProperty("noCharactersInURL");
String alternativeSearchResultRepository = controller.getRepositoryExtraProperty("alternativeSearchResultRepository");

String showEducationTab = controller.getRepositoryExtraProperty("showEducationTab");
String showResearchTab = controller.getRepositoryExtraProperty("showResearchTab");
String showCooperationTab = controller.getRepositoryExtraProperty("showCooperationTab");
String showPersonnelTab = controller.getRepositoryExtraProperty("showPersonnelTab");

String limitToSiteUrl = controller.getRepositoryExtraProperty("limitToSiteUrl");

String searchAjaxServiceSiteNodeId = controller.getRepositoryExtraProperty("searchAjaxServiceSiteNodeId");

String searchDoClickSiteNodeId = controller.getRepositoryExtraProperty("searchDoClickSiteNodeId");

pageContext.setAttribute("numberOfResultsPerPage", numberOfResultsPerPage);
pageContext.setAttribute("siteSeekerQcUrl", siteSeekerQcUrl);
pageContext.setAttribute("numberOfResultsPerPagePersonnel", numberOfResultsPerPagePersonnel);
pageContext.setAttribute("site", site);
pageContext.setAttribute("categoryAllWeb", categoryAllWeb);
pageContext.setAttribute("categoryEducation", categoryEducation);
pageContext.setAttribute("categoryResearch", categoryResearch);
pageContext.setAttribute("categoryCooperation", categoryCooperation);
pageContext.setAttribute("categoryNews", categoryNews);
pageContext.setAttribute("categoryEvents", categoryEvents);
pageContext.setAttribute("categoryPersonnel", categoryPersonnel);
pageContext.setAttribute("noCharactersInURL", noCharactersInURL);
pageContext.setAttribute("alternativeSearchResultRepository", alternativeSearchResultRepository);

pageContext.setAttribute("showEducationTab", showEducationTab);
pageContext.setAttribute("showResearchTab", showResearchTab);
pageContext.setAttribute("showCooperationTab", showCooperationTab);
pageContext.setAttribute("showPersonnelTab", showPersonnelTab);

pageContext.setAttribute("limitToUrl", limitToSiteUrl); // "http://www.cs.chalmers.se");// 
pageContext.setAttribute("searchAjaxService", searchAjaxServiceSiteNodeId);
pageContext.setAttribute("searchDoClickSiteNodeId", searchDoClickSiteNodeId);

/*===================================================================
  Find the root site node of the alternative search result repository 
  (if it has ben set)
===================================================================*/

if (alternativeSearchResultRepository != null && !alternativeSearchResultRepository.trim().equals(""))
{
	try
	{
		Integer repositoryId = new Integer(alternativeSearchResultRepository);
		SiteNodeVO snvo = SiteNodeController.getController().getRootSiteNodeVO(repositoryId);
		pageContext.setAttribute("alternativeSearchResultSiteNodeId", snvo.getId());
	}
	catch (NumberFormatException nfe)
	{
		out.print("Repositoryegenskapen \"alternativeSearchResultRepository\" är ej numerisk. Värdet är: " + alternativeSearchResultRepository);
	}
	
}

%>

<c:if test="${not empty param.limitToUrl}">
	<c:set var="limitToUrl" value="${param.limitToUrl}" />
</c:if>

<%--
<structure:componentPropertyValue id="numberOfResultsPerPage" propertyName="NumberOfResultsPerPage"/>
<structure:componentPropertyValue id="numberOfResultsPerPagePersonnel" propertyName="NumberOfResultsPerPagePersonnel"/>
<structure:componentPropertyValue id="site" propertyName="Site"/>
<structure:componentPropertyValue id="categoryAllWeb" propertyName="CategoryAllWeb"/>
<structure:componentPropertyValue id="categoryEducation" propertyName="CategoryEducation"/>
<structure:componentPropertyValue id="categoryResearch" propertyName="CategoryResearch"/>
<structure:componentPropertyValue id="categoryCooperation" propertyName="CategoryCooperation"/>
<structure:componentPropertyValue id="categoryNews" propertyName="CategoryNews"/>
<structure:componentPropertyValue id="categoryEvents" propertyName="CategoryEvents"/>
<structure:componentPropertyValue id="categoryPersonnel" propertyName="CategoryPersonnel"/>
<structure:componentPropertyValue id="noCharactersInURL" propertyName="NoCharactersInURL"/>
--%>
<structure:componentLabel mapKeyName="searchTextFieldLabel" id="searchTextFieldLabel"/>
<%-- 
	<structure:siteNode id="searchAjaxService" propertyName="SearchAjaxService"/>
--%>
<c:if test="${empty numberOfResultsPerPage}">
	<c:set var="numberOfResultsPerPage" value="10"/>
</c:if>
<c:if test="${empty numberOfResultsPerPagePersonnel}">
	<c:set var="numberOfResultsPerPagePersonnel" value="5"/>
</c:if>
<c:if test="${empty site}">
	<c:set var="site" value="test"/>
</c:if>

<c:if test="${empty categoryAllWeb}">
	<c:set var="categoryAllWeb" value="126"/>
</c:if>
<c:if test="${empty categoryEducation}">
	<c:set var="categoryEducation" value="90"/>
</c:if>
<c:if test="${empty categoryResearch}">
	<c:set var="categoryResearch" value="122"/>
</c:if>
<c:if test="${empty categoryCooperation}">
	<c:set var="categoryCooperation" value="93"/>
</c:if>
<c:if test="${empty categoryNews}">
	<c:set var="categoryNews" value="125"/>
</c:if>
<c:if test="${empty categoryEvents}">
	<c:set var="categoryEvents" value="124"/>
</c:if>
<c:if test="${empty categoryPersonnel}">
	<c:set var="categoryPersonnel" value="105"/>
</c:if>
<c:if test="${empty noCharactersInURL}">
	<c:set var="noCharactersInURL" value="97"/>
</c:if>
<c:if test="${empty showEducationTab}">
	<c:set var="showEducationTab" value="true"/>
</c:if>
<c:if test="${empty showResearchTab}">
	<c:set var="showResearchTab" value="true"/>
</c:if>
<c:if test="${empty showCooperationTab}">
	<c:set var="showCooperationTab" value="true"/>
</c:if>
<c:if test="${empty showPersonnelTab}">
	<c:set var="showPersonnelTab" value="true"/>
</c:if>

<c:choose>
	<c:when test="${empty searchAjaxService}">
		<c:set var="serverName"><%=pageContext.getRequest().getServerName()%></c:set>
		<c:choose>
			<c:when test="${serverName == 'dev.cms.it.gu.se'}">
				<%-- <c:set var="searchAjaxService" value="111214" /> --%>
				<c:set var="searchAjaxService" value="112258" />
			</c:when>
			<c:otherwise>
				<c:set var="searchAjaxService" value="532604" />
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<c:set var="searchAjaxService" value="${searchAjaxService}" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${empty searchDoClickSiteNodeId}">
		<c:set var="serverName"><%=pageContext.getRequest().getServerName()%></c:set>
		<c:choose>
			<c:when test="${serverName == 'dev.cms.it.gu.se'}">
				<%-- <c:set var="searchAjaxService" value="111214" /> --%>
				<c:set var="searchDoClickSiteNodeId" value="112298" />
			</c:when>
			<c:otherwise>
				<c:set var="searchDoClickSiteNodeId" value="112298" />
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<c:set var="searchDoClickSiteNodeId" value="${searchDoClickSiteNodeId}" />
	</c:otherwise>
</c:choose>

<c:choose>
	<c:when test="${empty limitToUrl}">
		<c:set var="limitToUrl" value="false"/>
	</c:when>
	<c:otherwise>
		<c:if test="${limitToUrl eq 'true'}">
			<common:urlBuilder id="currentUrl" fullBaseUrl="true"/>
			<%
				try {
					String url = (String)pageContext.getAttribute("currentUrl");
					// String url = "http://dev.cms.it.gu.se/infoglueDeliverWorking/ViewPage!renderDecoratedPage.action?siteNodeId=111213&contentId=-1";
					String stringPattern = "http://[[\\w].]*[\\w]/";
					Pattern p = Pattern.compile(stringPattern);
					Matcher m = p.matcher(url);
					
					if(m.find()) {
						pageContext.setAttribute("currentUrl", url.substring(m.start(),m.end()));
					} else {
						pageContext.setAttribute("currentUrl", "false");
					}
				} catch(Exception e) {
					pageContext.setAttribute("currentUrl", "false");
				}
			%>
			<c:set var="limitToUrl" value='${currentUrl}'/>
		</c:if>	
	</c:otherwise>
</c:choose>

<structure:componentPropertyValue id="headerType" propertyName="HeaderType"/>
<c:if test="${empty headerType || headerType == 'false'}">
	<c:set var="headerType" value="standardGU"/>
</c:if>

<structure:componentLabel id="searchResultCompCloseTitle" mapKeyName="SearchResultCompCloseTitle"/>
<structure:componentLabel id="searchResultCompTitle" mapKeyName="SearchResultCompTitle"/>
<structure:componentLabel id="searchTextLabel" mapKeyName="SearchTextLabel"/>

<structure:componentLabel id="tabTitleAll" mapKeyName="TabTitleAll"/>
<structure:componentLabel id="tabTitleThisPage" mapKeyName="TabTitleThisPage"/>
<structure:componentLabel id="tabTitleResearch" mapKeyName="TabTitleResearch"/>
<structure:componentLabel id="tabTitleEducation" mapKeyName="TabTitleEducation"/>
<structure:componentLabel id="tabTitleCooperation" mapKeyName="TabTitleCooperation"/>
<structure:componentLabel id="tabTitlePersonnel" mapKeyName="TabTitlePersonnel"/>

<structure:componentLabel id="showOnlyTitle" mapKeyName="ShowOnlyTitle"/>
<structure:componentLabel id="showOnlyPages" mapKeyName="ShowOnlyPages"/>
<structure:componentLabel id="showOnlyDocument" mapKeyName="ShowOnlyDocument"/>
<structure:componentLabel id="showOnlyNews" mapKeyName="ShowOnlyNews"/>
<structure:componentLabel id="showOnlyEvents" mapKeyName="ShowOnlyEvents"/>
<structure:componentLabel id="showOnlyShowAll" mapKeyName="ShowOnlyShowAll"/>
<structure:componentLabel id="tabAltTitleAll" mapKeyName="TabAltTitleAll"/>
<structure:componentLabel id="tabAltTitleThisPage" mapKeyName="TabAltTitleThisPage"/>

<structure:componentLabel id="tabAltTitleResearch" mapKeyName="TabAltTitleResearch"/>
<structure:componentLabel id="tabAltTitleEducation" mapKeyName="TabAltTitleEducation"/>
<structure:componentLabel id="tabAltTitleCooperation" mapKeyName="TabAltTitleCooperation"/>
<structure:componentLabel id="numberOfHitsTitle" mapKeyName="NumberOfHitsTitle" />
<structure:componentLabel id="searchLabel" mapKeyName="searchLabel" /> 
<structure:componentLabel id="siteSeekerHelpLabel" mapKeyName="SiteSeekerHelpLabel" />

<structure:componentLabel id="sortOrderLabel" mapKeyName="SortOrderLabel" />
<structure:componentLabel id="sortOrderRelevanceLabel" mapKeyName="SortOrderRelevanceLabel" />
<structure:componentLabel id="sortOrderDateLabel" mapKeyName="SortOrderDateLabel" />
<structure:componentLabel id="sortOrderSiteLabel" mapKeyName="SortOrderSiteLabel" />
<structure:componentLabel id="sortSiteLabel" mapKeyName="SortSiteLabel" />
<structure:componentLabel id="removeSortSiteLabel" mapKeyName="RemoveSortSiteLabel" />

<structure:componentLabel id="noHitsLabel" mapKeyName="NoHitsLabel" />


<c:if test="${empty site}">
	<c:set var="site" value="null"/>
</c:if>

<c:if test="${empty categoryAllWeb}">
	Inget värde angivet för kategorin "Hela webben".<br/>
</c:if>
<c:if test="${empty categoryEducation}">
	Inget värde angivet för kategorin "Utbildning".<br/>
</c:if>
<c:if test="${empty categoryResearch}">
	Inget värde angivet för kategorin "Forskning".<br/>
</c:if>
<c:if test="${empty categoryCooperation}">
	Inget värde angivet för kategorin "Samverkan".<br/>
</c:if>
<c:if test="${empty categoryNews}">
	Inget värde angivet för subkategorin "Nyheter".<br/>
</c:if>
<c:if test="${empty categoryEvents}">
	Inget värde angivet för subkategorin "Evenemang".<br/>
</c:if>
<c:if test="${empty categoryPersonnel}">
	Inget värde angivet för kategorin "Personal".<br/>
</c:if>

<structure:componentPropertyValue id="searchOnAlternativeSiteText" propertyName="SearchOnAlternativeSiteText"/>
<c:if test="${empty searchOnAlternativeSiteText}">
	<structure:componentLabel id="searchOnAlternativeSiteText" mapKeyName="SearchAlternativeSite" />
</c:if>

<style type="text/css">
	#bodyContentWrapperSearch
	{
		min-height: 800px;
	}
	.displayLayer
	{
		display: block; 
		min-height: 150px; 
		min-width: 100px; 
		background-repeat: no-repeat;
	}
	#loadingLayer
	{
		background-image: url("<content:assetUrl propertyName="Mallbilder" assetKey="loadingImage"/>");
		background-repeat: no-repeat;
		width: 40px;
		height: 40px;
		display: block;
		margin: 0 auto;
		position: absolute;
		margin-left: 700px;
	}
	
	.sortOrderOption {
		font-family: Verdana,Arial,Helvetica,sans-serif; 
		font-size: 0.75em; 
		text-decoration: underline;
		color: #015497;
	}
	.sortOrderOption.selected {
		font-weight: bold; 
		text-decoration: none; 
		color: #484848;
	}
	
	.emptyResultlist a {
		font-weight: normal;
	}
</style>

<c:set var="categoryTitle" value="${param.categoryTitle}"/>
<c:if test="${empty categoryTitle}">
	<c:set var="categoryTitle" value="${tabTitleAll}" />
</c:if>

<c:set var="categoryId" value="${param.categoryId}"/>
<c:if test="${empty categoryId}">
	<c:set var="categoryId" value="${categoryAllWeb}" />
</c:if>


<!-- The Content starts here -->	
<c:if test="${pc.isDecorated == false}">
	<script type="text/javascript" src="script/jquery/jquery-1.2.6.min.js"></script>
</c:if>

<c:set var="javascript">

<SCRIPT LANGUAGE="JavaScript">
<!--
function processForm(form) {

var searchText = encodeURIComponent(form.searchText.value);

form.searchText.value = searchText;
}
 -->
</script>
</c:set>
<page:htmlHeadItem value="${javascript}"/>

<div id="searchResultComp">
	<div class="col100">
		<a name="content"></a>
		<h1><c:out value="${searchResultCompTitle}" escapeXml="false"/></h1>
		
		<common:urlBuilder id="newSearchUrl" excludedQueryStringParameters="categoryId, categoryTitle, activeTabName,site,siteName" />
		
		<div id="loadingLayer" style="display: none;"> </div>
		
		<form name="mainSearch" method="get" action="<c:out value="${newSearchUrl}" />" onsubmit="performNewSearch();">
			<fieldset>
				<input type="hidden" name="siteSearch" id="siteSearch" value="true" />
				
				<input type="hidden" name="categoryId" id="categoryId" value="<c:out value="${categoryId}" escapeXml="false"/>" />
				<input type="hidden" name="activeTabName" id="activeTabName"/>
				
				<input type="hidden" name="categoryTitle" id="categoryTitle" value="<c:out value="${categoryTitle}" escapeXml="false"/>"/>
				
				<input type="hidden" name="spellSuggestion" id="spellSuggestion" value="no"/>
				<input type="hidden" name="documentType" id="documentType"/>
				
				<input type="hidden" name="allWebDocType" id="allWebDocType"/>
				<input type="hidden" name="educationDocType" id="educationDocType"/>
				<input type="hidden" name="researchDocType" id="researchDocType"/>
				<input type="hidden" name="cooperationDocType" id="cooperationDocType"/>
				<input type="hidden" name="searchTextSent" id="searchTextSent"/>
				
				<label for="searchText">
				<c:out value="${searchTextLabel}" escapeXml="false"/>:
				</label> 
				<br />
				
				<c:set var="searchText" value="${param.searchText}" />
				
				<%
					URLDecoder dc = new URLDecoder();
					pageContext.setAttribute("searchText" , dc.decode((String)pageContext.getAttribute("searchText"), "utf-8"));
				 %>
				
				<c:choose>
					<c:when test="${headerType == 'level3page'}">
						<input name="searchText" type="text" value="<c:out value="${searchText}"/>" id="searchTextField" title="<structure:componentLabel mapKeyName="searchWordLevel3Title"/>" class="searchfield" onfocus="searchFieldSelected(); return;"/> 
					</c:when>
					<c:otherwise>
						<input name="searchText" type="text" value="<c:out value="${searchText}"/>" id="searchTextField" title="<structure:componentLabel mapKeyName="searchWordTitle"/>" class="searchfield" onfocus="searchFieldSelected(); return;"/> 
					</c:otherwise>
				</c:choose>
				<input type="submit" value="<c:out value="${searchLabel}" escapeXml="false"/>" class="largeSearchButton" id="searchInputButton" onClick="javascript:processForm(this.form);"/>
				
				<span style="margin-left: 10px;">
				<a href="http://katagu.gu.se/katagu.taf?lang=<c:out value="${pc.locale}"/>" title="<structure:componentLabel mapKeyName="kataGULinkTitle"/>" style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 0.6875em; color: #015497;"><structure:componentLabel mapKeyName="kataGULinkLabel"/></a>
				<a href="#" onclick="window.open('http://faq-search.siteseeker.se/?p=helppopup', '<c:out value="${siteSeekerHelpLabel}" escapeXml="false"/>','width=390,height=550,menubar=no,status=no,location=no,toolbar=no,scrollbars=yes')" title="<c:out value="${siteSeekerHelpLabel}" escapeXml="false"/>" style="font-family: Verdana,Arial,Helvetica,sans-serif; font-size: 0.6875em; color: #015497;"><c:out value="${siteSeekerHelpLabel}" escapeXml="false"/></a>
				</span>
		
				<br/>
				<%-- 
				<input type="radio" name="sortOrder" value="relevance" checked> 
				<input type="radio" name="sortOrder" value="date"> 
				--%>
				<input type="hidden" name="sortOrder" id="sortOrder" value="relevance"/>
				
				<div id="sortOrderSelection" style="display: none;">
					<label for="sortOrder"><c:out value="${sortOrderLabel}"/>:</label>
					<a id="relevanceSortOrderId" href="javascript: performSearchSorted('relevance');" class="sortOrderOption selected"><c:out value="${sortOrderRelevanceLabel}"/></a>
					<a id="dateSortOrderId" href="javascript: performSearchSorted('date');" class="sortOrderOption"><c:out value="${sortOrderDateLabel}"/></a>
				</div>
				<div>
					<c:choose>
						<c:when test="${empty param.specifiedSiteSearch}">
							<structure:pageUrl siteNodeId="${pc.repositoryRootSiteNode.siteNodeId}" id="baseUrl" />
								
							<c:set var="siteNodeIdToCheck" value="${pc.repositoryRootSiteNode.siteNodeId}" />
							<%
								org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController templateController = (org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
								Integer contentId 	= templateController.getMetaInformationContentId((Integer)pageContext.getAttribute("siteNodeIdToCheck"));
								
								String navigationTitle = templateController.getContentAttributeUsingLanguageFallback(contentId, "NavigationTitle", false);
								pageContext.setAttribute("navigationTitle", navigationTitle);
							%>
							<c:set var="rootSiteNodeNavigationTitle" value="${navigationTitle}" />				
							<common:URLEncode value="${baseUrl}" id="baseUrl"/>
							
							<%
							if(!((String)pageContext.getAttribute("baseUrl")).contains("www.gu.se")){
							%>
								<c:choose>
									<c:when test="${empty param.limitToUrl or param.limitToUrl == ''}">
										<common:urlBuilder id="sortUrl">
											<common:parameter name="limitToUrl" value="${baseUrl}"/>
										</common:urlBuilder>
										<label><c:out value="${sortSiteLabel}" escapeXml="false"/>:</label>
										<a id="siteSortOrderId" href="<c:out value="${sortUrl}"/>" class="sortOrderOption"><c:out value="${rootSiteNodeNavigationTitle}"/></a>
									</c:when>
									<c:otherwise>
										<common:urlBuilder id="sortUrl" excludedQueryStringParameters="limitToUrl" />
										<label><c:out value="${removeSortSiteLabel}" escapeXml="false"/>:</label>
										<a id="siteSortOrderId" href="<c:out value="${sortUrl}"/>" class="sortOrderOption"><c:out value="${rootSiteNodeNavigationTitle}"/></a>
									</c:otherwise>
								</c:choose>
							<%
							}
							else
							{
								out.println("www.gu.se!");
							}%>
						</c:when>
						<c:when test="${not empty param.specifiedSiteSearch}">
							<c:set var="searchFilterSiteName" value="${param.specifiedSiteSearch}" />
							<common:urlBuilder id="sortUrl" excludedQueryStringParameters="limitToUrl,specifiedSiteSearch" />
							<label><c:out value="${removeSortSiteLabel}" escapeXml="false"/>:</label>
							<a id="siteSortOrderId" href="<c:out value="${sortUrl}"/>" class="sortOrderOption"><c:out value="${searchFilterSiteName}"/></a>
						</c:when>
					</c:choose>
				</div>
			</fieldset>
		</form>
		
		<div class="clr"></div>

		<div id="resultHeaderDiv" style="display: none;">
		
			<%-----------------------------
				Alternative search page
			 ----------------------------%>
		
			<c:if test="${not empty alternativeSearchResultSiteNodeId}">
				<structure:pageUrl id="alternativeSearchResultPageUrl" siteNodeId="${alternativeSearchResultSiteNodeId}" />
				
				<common:urlBuilder id="alternativeSearchResultUrl" baseURL="${alternativeSearchResultPageUrl}" includeCurrentQueryString="false">
					<common:parameter name="siteSearch" value="true"/>
					<common:parameter name="isJavascriptSupported" value="${param.isJavascriptSupported}"/>
				</common:urlBuilder>
				<p>
					<a href="javascript: searchAlternativeSite('<c:out value="${alternativeSearchResultUrl}" />');" class="searchOnAlternativeSiteLink"><c:out value="${searchOnAlternativeSiteText}" />&nbsp;&raquo;</a>
				</p>
			</c:if>
		
			<div id="tabstrip">
				<ul>		
					<c:choose>
						<c:when test="${not empty param.limitToUrl}">
							<li id="tab_allWeb" class="current maintab" style="display: none;">
								<common:urlBuilder id="allWebLink" excludedQueryStringParameters="activeTabName">
									<common:parameter name="categoryTitle" value="${tabTitleAll}"/>
									<common:parameter name="categoryId" value="${categoryAllWeb}"/>
								</common:urlBuilder>
								
								<a href="<c:out value="${allWebLink}" escapeXml="false"/>" title="<c:out value="${tabAltTitleThisPage}" escapeXml="false"/>" ><c:out value="${tabTitleThisPage}" escapeXml="false"/> <span>(<span id="span_numberOfHits_allWeb"/></span> <c:out value="${numberOfHitsTitle}" escapeXml="false"/>)</span></a>
							</li>
						</c:when>
						<c:otherwise>
							<li id="tab_allWeb" class="current maintab" style="display: none;">
								<common:urlBuilder id="allWebLink" excludedQueryStringParameters="activeTabName">
									<common:parameter name="categoryTitle" value="${tabTitleAll}"/>
									<common:parameter name="categoryId" value="${categoryAllWeb}"/>
								</common:urlBuilder>
								
								<a href="<c:out value="${allWebLink}" escapeXml="false"/>" title="<c:out value="${tabAltTitleAll}" escapeXml="false"/>" ><c:out value="${tabTitleAll}" escapeXml="false"/> <span>(<span id="span_numberOfHits_allWeb"/></span> <c:out value="${numberOfHitsTitle}" escapeXml="false"/>)</span></a>
								
								<%-- <a href="javascript: displayTab('allWeb', '<c:out value="${categoryAllWeb}" escapeXml="false" />', '<c:out value="${tabTitleAll}" escapeXml="false"/>', null)" title="<c:out value="${tabAltTitleAll}" escapeXml="false"/>" ><c:out value="${tabTitleAll}" escapeXml="false"/> <span>(<span id="span_numberOfHits_allWeb"/></span> <c:out value="${numberOfHitsTitle}" escapeXml="false"/>)</span></a> --%> 
							</li>
						</c:otherwise>
					</c:choose>
					<li id="tab_allWeb" class="current maintab" style="display: none;">
						
						<common:urlBuilder id="allWebLink" excludedQueryStringParameters="activeTabName">
							<common:parameter name="categoryTitle" value="${tabTitleAll}"/>
							<common:parameter name="categoryId" value="${categoryAllWeb}"/>
						</common:urlBuilder>
						
						<a href="<c:out value="${allWebLink}" escapeXml="false"/>" title="<c:out value="${tabAltTitleAll}" escapeXml="false"/>" ><c:out value="${tabTitleAll}" escapeXml="false"/> <span>(<span id="span_numberOfHits_allWeb"/></span> <c:out value="${numberOfHitsTitle}" escapeXml="false"/>)</span></a>
						
						<%-- <a href="javascript: displayTab('allWeb', '<c:out value="${categoryAllWeb}" escapeXml="false" />', '<c:out value="${tabTitleAll}" escapeXml="false"/>', null)" title="<c:out value="${tabAltTitleAll}" escapeXml="false"/>" ><c:out value="${tabTitleAll}" escapeXml="false"/> <span>(<span id="span_numberOfHits_allWeb"/></span> <c:out value="${numberOfHitsTitle}" escapeXml="false"/>)</span></a> --%> 
					</li>
					<c:if test="${showEducationTab == 'true'}">
						<common:urlBuilder id="educationLink" excludedQueryStringParameters="activeTabName">
							<common:parameter name="categoryTitle" value="${tabTitleEducation}"/>
							<common:parameter name="categoryId" value="${categoryEducation}"/>
						</common:urlBuilder>
						<li id="tab_education" class="maintab" style="display: none;">
							<a href="<c:out value="${educationLink}" escapeXml="false"/>" title="<c:out value="${tabAltTitleEducation}" escapeXml="false"/>"><c:out value="${tabTitleEducation}" escapeXml="false"/> <span>(<span id="span_numberOfHits_education"/></span> <c:out value="${numberOfHitsTitle}" escapeXml="false"/>)</span></a>
							<%--<a href="javascript: displayTab('education', '<c:out value="${categoryEducation}" escapeXml="false" />', '<c:out value="${tabTitleEducation}" escapeXml="false"/>', null)" title="<c:out value="${tabAltTitleEducation}" escapeXml="false"/>"><c:out value="${tabTitleEducation}" escapeXml="false"/> <span>(<span id="span_numberOfHits_education"/></span> <c:out value="${numberOfHitsTitle}" escapeXml="false"/>)</span></a> --%> 
						</li>
					</c:if>
					<c:if test="${showResearchTab == 'true'}">
						<common:urlBuilder id="researchLink" excludedQueryStringParameters="activeTabName">
							<common:parameter name="categoryTitle" value="${tabTitleResearch}"/>
							<common:parameter name="categoryId" value="${categoryResearch}"/>
						</common:urlBuilder>
						<li id="tab_research" class="maintab" style="display: none;">
							<a href="<c:out value="${researchLink}" escapeXml="false"/>" title="<c:out value="${tabAltTitleResearch}" escapeXml="false"/>"><c:out value="${tabTitleResearch}" escapeXml="false"/> <span>(<span id="span_numberOfHits_research"/></span> <c:out value="${numberOfHitsTitle}" escapeXml="false"/>)</span></a>
							<%-- <a href="javascript: displayTab('research', '<c:out value="${categoryResearch}" escapeXml="false" />', '<c:out value="${tabTitleResearch}" escapeXml="false"/>', null)" title="<c:out value="${tabAltTitleResearch}" escapeXml="false"/>"><c:out value="${tabTitleResearch}" escapeXml="false"/> <span>(<span id="span_numberOfHits_research"/></span> <c:out value="${numberOfHitsTitle}" escapeXml="false"/>)</span></a> --%> 
						</li>
					</c:if>
					<c:if test="${showCooperationTab == 'true'}">
						<common:urlBuilder id="cooperationLink" excludedQueryStringParameters="activeTabName">
							<common:parameter name="categoryTitle" value="${tabTitleCooperation}"/>
							<common:parameter name="categoryId" value="${categoryCooperation}"/>
						</common:urlBuilder>
						<li id="tab_cooperation" class="maintab" style="display: none;">
							<a href="<c:out value="${cooperationLink}" escapeXml="false"/>" title="<c:out value="${tabAltTitleCooperation}" escapeXml="false"/>"><c:out value="${tabTitleCooperation}" escapeXml="false"/> <span>(<span id="span_numberOfHits_cooperation"/></span> <c:out value="${numberOfHitsTitle}" escapeXml="false"/>)</span></a>
							<%-- <a href="javascript: displayTab('cooperation', '<c:out value="${categoryCooperation}" escapeXml="false" />', '<c:out value="${tabTitleCooperation}" escapeXml="false"/>', null)" title="<c:out value="${tabAltTitleCooperation}" escapeXml="false"/>"><c:out value="${tabTitleCooperation}" escapeXml="false"/> <span>(<span id="span_numberOfHits_cooperation"/></span> <c:out value="${numberOfHitsTitle}" escapeXml="false"/>)</span></a> --%> 
						</li>
					</c:if>
				</ul>
				<div class="clr">
				</div>
			</div>
			<p>
				<c:out value="${showOnlyTitle}" escapeXml="false" />: 
				<a id="subSelectAll" href="javascript: displaySubSelection(0, '', 'subSelectAll');" class="subselection current" title=""><c:out value="${showOnlyShowAll}" escapeXml="false"/></a> 
				<a id="subSelectWebPages" href="javascript: displaySubSelection(1, '', 'subSelectWebPages');" class="subselection" title=""><c:out value="${showOnlyPages}" escapeXml="false"/></a> 
				<a id="subSelectDocuments" href="javascript: displaySubSelection(999, '', 'subSelectDocuments');" class="subselection" title=""><c:out value="${showOnlyDocument}" escapeXml="false"/></a> 
				<a id="subSelectNews" href="javascript: displaySubSelection(0, '<c:out value="${categoryNews}" escapeXml="false" />', 'subSelectNews');" class="subselection" title=""><c:out value="${showOnlyNews}" escapeXml="false"/></a>
				<a id="subSelectEvents" href="javascript: displaySubSelection(0, '<c:out value="${categoryEvents}" escapeXml="false" />', 'subSelectEvents');" class="subselection" title=""><c:out value="${showOnlyEvents}" escapeXml="false"/></a> 
			</p>
		</div>
	</div>
		
	<div id="div_allWeb" class="displayLayer col75" style="display: none"></div>
	<div id="div_education" class="displayLayer col75" style="display: none;"></div>
	<div id="div_research" class="displayLayer col75" style="display: none;"></div>
	<div id="div_cooperation" class="displayLayer col75" style="display: none;"></div>
	<div id="div_emptyResultSet" class="displayLayer col75" style="display: none;">
		<h1> </h1>
		<div class="resultlist">
			<h4 class="emptyResultlist"><c:out value="${noHitsLabel}"/><span id="spellingSuggestion"> </span></h4>
		</div>
	</div>
	
	<div id="div_personnel" class="col25">
	</div>
	<div class="clr"></div>
</div>

<%--
<script type="text/javascript">
	displayTab('allWeb_container', <c:out value="${categoryAllWeb}" escapeXml="false" />, '<c:out value="${tabTitleAll}" escapeXml="false"/>');
	tabSelected('allWeb', <c:out value="${categoryAllWeb}" escapeXml="false" />, '<c:out value="${tabTitleAll}" escapeXml="false"/>');
</script>
--%>
<script type="text/javascript">
<!--
	/* jQuery("#searchText").focus(); */
-->
</script>
<script type="text/javascript">
	<!--	
		var loadingCounter 	= 0;
		var numberOfQueries = 0;
		var searchTextFieldLabel = '<c:out value="${searchTextFieldLabel}" escapeXml="false"/>';
		
		var categoryIdDiv = [];
		categoryIdDiv[<c:out value="${categoryAllWeb}" escapeXml="false" />] = "allWeb";
		categoryIdDiv[<c:out value="${categoryEducation}" escapeXml="false" />] = "education";
		categoryIdDiv[<c:out value="${categoryResearch}" escapeXml="false" />] = "research";
		categoryIdDiv[<c:out value="${categoryCooperation}" escapeXml="false" />] = "cooperation";
		categoryIdDiv[<c:out value="${categoryPersonnel}" escapeXml="false" />] = "personnel";
		
		var categoriesResult = [];
		
		function performSearch()
		{
			var searchText 	= document.mainSearch.searchText.value;
			/* || searchText == 'Sök info, personal etc.'  */
			if( searchTextFieldLabel == searchText || searchText == '' )
				return;

			displayLoadingLayer();
			
			jQuery("#searchTextSent").attr("value", searchText);

			/*
			$("#resultHeaderDiv").css({"display" : "none"});
			$(".maintab").css({"display" : "none"});
			$("#div_personnel").css({"display" : "none"});
			*/
			$("#documentType").attr("value", 0);
			
			markSelected('subSelectAll');
			
			// Hide previous result
			/*
			for( var categoryId in categoryIdDiv ) {
				
				jQuery("#div_"+categoryIdDiv[categoryId]).html(""); //.append();
				jQuery("#span_numberOfHits_"+categoryIdDiv[categoryId]).html(""); //.append(); 
				hideTabOption( categoryId );
			}
			*/
			
			// Reset
			jQuery("#spellingSuggestion").css('display', 'none').html("");
			// Set that no tab has results 
			categoriesResult = [];
			
			var categories = "<c:out value="${categoryAllWeb}" escapeXml="false" />";
			numberOfQueries = 1;
			<c:if test="${showEducationTab == 'true'}">
				categories += ",<c:out value="${categoryEducation}" escapeXml="false" />";
			</c:if>
			<c:if test="${showResearchTab == 'true'}">
				categories += ",<c:out value="${categoryResearch}" escapeXml="false" />";
			</c:if>
			<c:if test="${showCooperationTab == 'true'}">
				categories += ",<c:out value="${categoryCooperation}" escapeXml="false" />";
			</c:if>
			
			searchAll(searchText, categories, "allWeb", 1, "<c:out value="${numberOfResultsPerPage}"/>");
			
			<c:if test="${(showPersonnelTab == 'true') or (limitToUrl ne 'false' and limitToUrl ne null)}">
				
				searchCategory(searchText, 1, "<c:out value="${categoryPersonnel}" escapeXml="false" />", 0, null, "<c:out value="${numberOfResultsPerPagePersonnel}"/>", "<c:out value="${tabTitlePersonnel}" escapeXml="false"/>");
				numberOfQueries++;
				
			</c:if>
			
			$('#allWebDocType').attr("value", 'subSelectAll');
			$('#educationDocType').attr("value", 'subSelectAll');
			$('#researchDocType').attr("value", 'subSelectAll');
			$('#cooperationDocType').attr("value", 'subSelectAll');
				
			$("#searchTextDisplay").text(searchText);
			$("#spellSuggestion").attr('value', 'no');
		}
		
		function performSearchSorted( sortOrder ) {
			
			if( $("#sortOrder").val() != sortOrder ) {
				$("#sortOrder").val(sortOrder);
				
				jQuery("#sortOrderSelection a").each(function() {
					jQuery(this).removeClass("selected");
				});
				
				jQuery("#"+sortOrder+"SortOrderId").addClass("selected");
			}
			
			performSearch();
		}
		
		function performNewSearch() {
			
			// Reset
			jQuery("#sortOrder").attr('value', 'relevance');
			//jQuery("#sortOrderSelection").css('display', 'none');
			
			jQuery("#sortOrderSelection a").each(function() {
				jQuery(this).removeClass("selected");
			});
			jQuery("#relevanceSortOrderId").addClass("selected");
			performSearch();
		}
		
		/**
		* Search all, retrive new tab values
		*/
		function searchAll(aSearchText, aCategories, aDivId, aSlotNumber, aPageSize) {
			var categories 		= aCategories.split(",");
			var sortOrder 		= $("#sortOrder").val();
			var currentDivId	= "#div_" + aDivId;
			/* var preferedId 		= null;  document.getElementById('categoryId').value; */
			var categoryTitle	= "<c:out value="${categoryTitle}" />";
			var spellSuggestion = $("#spellSuggestion").attr('value');
			/*
			// If none is selected then this is an initial search and categoryAllWeb should be "selected"
			if( preferedId == false ) {
				preferedId = <c:out value="${categoryAllWeb}" escapeXml="false" />;
			}
			*/
			// $("#resultHeaderDiv").css({"display" : "none"}); 
			// preferedId: preferedId,
			// Call search XML-service
			
			jQuery.ajax({url: 'ViewPage.action',
				type: 'POST',
    			dataType: 'xml',
    			traditional: true,
    			timeout: 60000,
			 	data: {languageId: '<c:out value="${pc.languageId}" />', categoryName: categoryTitle, searchText: aSearchText, noCharactersInURL: '<c:out value="${noCharactersInURL}"/>', site: '<c:out value="${site}"/>', batch: aSlotNumber, searchCategory: categories, isSubSelect: false, divId: aDivId, sortOrder: sortOrder, siteNodeId: '<c:out value="${searchAjaxService}" escapeXml="false" />', hn: aPageSize, limitToUrl: '<c:out value="${limitToUrl}"/>', all: true, searchDocumentType: 0, spellSuggestion: spellSuggestion, uid: '<c:out value="${uid}" />'},
			 	success: function(xml) { 
			 		jQuery("#spellingSuggestion").html("");
					hideLoadingLayer();
					searchCompleted(xml, categoryTitle); 
				}
			});
		}
		
		function searchAlternativeSite(aAlternativeUrl)
		{
			var searchUrl = aAlternativeUrl + "&searchText=" + $("#searchTextField").val();
			document.location = searchUrl;
		}
		
		function searchReturnedError(xml) {
		}

		/**
		* Called when search is completed
		*/
		function searchCompleted(xml, aCategoryName) {
			var result = jQuery(xml).find('result');
			if( result == null ) {
				// error handle
				return;
			}
			
			var activeId = document.getElementById('categoryId').value; //<c:out value="${categoryAllWeb}" escapeXml="false" />;
			activeId = "<c:out value="${categoryId}" />";
			var nHits = 0;
			var totalHits = 0;
			
			var subsearch = false;
				
			jQuery(result).find('categories').find('category').each(function() {
				
				var id = jQuery.trim(jQuery(this).find("id").text());
				
				if( categoriesResult[id] != true )
					categoriesResult[id] = false;
				
				if( jQuery.trim(jQuery(this).find('active').text()) == 'true' ) {
					activeId = id;
					var intCategoryId = parseInt(id);
					categoriesResult[intCategoryId] = true;
				}
				
				var nHitsResult = parseInt(jQuery.trim(jQuery(this).find('nhits').text()));
				
				if( isNaN(nHitsResult) ) {
					nHits = 0;
					subsearch = true;
				}
				else
					nHits = nHitsResult;

				totalHits += nHits;
				
				if( subsearch != true ) {
					if( nHits > 0 || activeId == id || id == <c:out value="${categoryAllWeb}" escapeXml="false" /> ) {
						showTabOption( categoryIdDiv[id] );
						//if( jQuery("#span_numberOfHits_"+categoryIdDiv[id]).html() == "" || jQuery("#span_numberOfHits_"+categoryIdDiv[id]).html() == "0" )  {
							$("#span_numberOfHits_"+categoryIdDiv[id]).html(""+nHits);
						//}
					}
				}
			});
			
			var hitsXml = jQuery(result).find('hits');

			jQuery(hitsXml).find('data').each(function() 
			{
				jQuery("#div_"+categoryIdDiv[activeId]).html("").append($(this).text());
			});
			
			if( activeId != <c:out value="${categoryPersonnel}" escapeXml="false" />) {
				
				if( totalHits > 0 ) {
					$("#sortOrderSelection").css('display', 'block'); 
				}
				
				if( totalHits > 0 || subsearch == true ) {
					$("#resultHeaderDiv").css('display', 'block');
					activeId = "<c:out value="${categoryId}" />";
					
					displayTab( categoryIdDiv[activeId], activeId, aCategoryName );
				} else if( totalHits == 0 ) {

					tabSelected( categoryIdDiv[<c:out value="${categoryAllWeb}" escapeXml="false" />], <c:out value="${categoryAllWeb}" escapeXml="false" />, '<c:out value="${tabTitleAll}" escapeXml="false"/>' );
					$(".displayLayer").css("display" , "none");
					
					jQuery("#div_emptyResultSet").css('display', 'block');
					var spells = jQuery(result).find("spells");
					jQuery("#spellingSuggestion").css('display', 'none').html("");
					
					
					if( spells != null ) {
						jQuery(spells).find('data').each(function() {
							jQuery("#spellingSuggestion").css('display', 'inline').append(' - '+$(this).text());
						});
					}
					
				}
			} else {
				if( nHits > 0 )
					showPersonal();
			}
		}
		
		function showPersonal() {
			$("#div_"+categoryIdDiv[<c:out value="${categoryPersonnel}" escapeXml="false" />]).css("display" , "block");
		}
		
		function searchCategory(searchText, aSlotNumber, aCategoryId, aSearchDocumentType, aIsSubSelect, aPageSize, aCategoryName, main)
		{
			var categories 		= aCategoryId.split(",");
			var divId = null;
			var spellSuggestion = $("#spellSuggestion").attr('value');
			var sortOrder = 'relevance';
			$("#searchTextField").val($("#searchTextSent").val());
			
			if( aCategoryId == <c:out value="${categoryPersonnel}" escapeXml="false" /> ){
				divId = 'personnel';
			}
			else {
				sortOrder = $("#sortOrder").val();
			}
			
			if( main == null )
				main = '';
				
			displayLoadingLayer();
			
			numberOfQueries=1;
			jQuery.ajax({url: 'ViewPage.action',
				type: 'POST',
    			dataType: 'xml',
    			traditional: true,
    			timeout: 60000,
			 	data: { languageId: '<c:out value="${pc.languageId}" />', categoryName: aCategoryName, searchText: searchText, noCharactersInURL: '<c:out value="${noCharactersInURL}"/>', site: '<c:out value="${site}"/>', batch: aSlotNumber, searchCategory: categories, isSubSelect: aIsSubSelect, siteNodeId: '<c:out value="${searchAjaxService}" escapeXml="false" />', hn: aPageSize, limitToUrl: '<c:out value="${limitToUrl}"/>', all: false, mainCategory: main, divId: divId, searchDocumentType: aSearchDocumentType, sortOrder: sortOrder, spellSuggestion: spellSuggestion, uid: '<c:out value="${uid}" />'},
			 	success: function(xml) { 
			 		hideLoadingLayer();
					searchCompleted(xml, aCategoryName);
				}
			});
		}
		
		function showTabOption( aSelection ) {
			$("#tab_" + aSelection).css("display", "block");	
		}
		
		function hideTabOption( aSelection ) {
			$("#tab_" + aSelection).css("display", "none");	
		}
		
		function tabSelected( aSelection, aCategoryId, aCategoryName ) {
			
			$(".maintab").removeClass("current");
			$(".displayLayer").css("display" , "none");
			
			$("#div_" + aSelection).css("display" , "block");
			$("#tab_" + aSelection).addClass("current");
			
			document.getElementById('activeTabName').value 	= aSelection;
			document.getElementById('categoryId').value 	= aCategoryId;
			document.getElementById('categoryTitle').value = aCategoryName;
			
			markSelected($('#'+aSelection+'DocType').attr("value"));
		}
		
		function displayTab(aSelection, aCategoryId, aCategoryTitle)
		{
			var intCategoryId = parseInt(aCategoryId);
			
			if( categoriesResult[aCategoryId] != true ) {
				var searchText 		= document.mainSearch.searchTextSent.value; 
				searchCategory(searchText, 1, aCategoryId, 0, null, "<c:out value="${numberOfResultsPerPage}"/>", aCategoryTitle);
			} 
			else {
				tabSelected( aSelection, aCategoryId, aCategoryTitle );
			}
		}
		
		function displayLoadingLayer()
		{
			loadingCounter = 0;
			$("#loadingLayer").css("display" , "block");
		}
		
		function hideLoadingLayer()
		{
			loadingCounter ++;
			
			if (loadingCounter == numberOfQueries)
			{
				$("#loadingLayer").css("display" , "none");
			}
		}
		
		function markSelected(aId)
		{
			$(".subselection").removeClass("current");
			$("#" + aId).addClass("current");
		}
		
		function displaySubSelection(aDocumentType, aAdditionalCategoryId, aSubSelectionId)
		{
			if( aSubSelectionId != false )
				markSelected(aSubSelectionId);
			
			var searchText 		= document.mainSearch.searchTextSent.value; 
			var categoryId 		= document.getElementById('categoryId').value;
			var activeTabName 	= document.getElementById('activeTabName').value;
			var categoryTitle 	= document.getElementById('categoryTitle').value;
			var categoryIds 	= categoryId;
			
			$('#'+activeTabName+'DocType').attr("value", aSubSelectionId);
			
			if (aAdditionalCategoryId != null && aAdditionalCategoryId != "")
			{
				if( activeTabName == 'allWeb' && (aAdditionalCategoryId == <c:out value="${categoryEvents}" escapeXml="false" /> || aAdditionalCategoryId == <c:out value="${categoryNews}" escapeXml="false" /> )) {
					categoryIds = aAdditionalCategoryId;
				}
				else {
					categoryIds = categoryId + "," + aAdditionalCategoryId;
				}
			}
			
			searchCategory(searchText, 1, categoryIds, aDocumentType, true, "<c:out value="${numberOfResultsPerPage}"/>", categoryTitle, categoryId);
		}
		
		function doClick(e, o, data) { // , isFrameset) {
			
			var url = "ViewPage.action?siteNodeId="+<c:out value="${searchDoClickSiteNodeId}"/>+"&"+ data;
			
			if (o.href) {
				o.href = url; 
			}
			return true;
		} 
		
		function triggerSpellingSuggestedSearch(searchText) {
			$("#spellSuggestion").attr('value', 'true');
			document.mainSearch.searchText.value = searchText;
			performSearch();
		}
		
		function searchFieldSelected() {
			var searchText 	= jQuery('#searchTextField').val();
			
			if( searchTextFieldLabel == searchText ) {
				jQuery("#searchTextField").attr("value", "");
			}
		}
	-->
</script>

<c:if test="${empty siteseekerUID}">
<% 
	// {}">
	String ip = request.getRemoteAddr();
	String timestamp= String.valueOf(System.currentTimeMillis());
	String siteseekerUID = timestamp+""+ip.hashCode();
	
	MessageDigest m = MessageDigest.getInstance("MD5");
	m.reset();
	m.update(siteseekerUID.getBytes());
	byte[] digest = m.digest();
	Formatter formatter = new Formatter();
	
    for ( int i=0; i<digest.length; i++ ) {
        formatter.format("%02x",digest[i]);
    }
    
	siteseekerUID = formatter.toString();
	
	pageContext.setAttribute("siteseekerUID", siteseekerUID);
%>
	<c:set scope="session" value="${siteseekerUID}" var="siteseekerUID"/>
	<common:URLEncode value="${siteseekerUID}" id="uid"/>
	<common:URLEncode value="start" id="session"/>
	
	<script type="text/javascript">
	<!--	
		function startSiteseekerSession() {
			var url = "ViewPage.action?siteNodeId=<c:out value="${searchDoClickSiteNodeId}"/>&mode=2&uid=<c:out value="${uid}"/>&session=<c:out value="${session}"/>";
			
			jQuery.ajax({url: url,
				type: 'GET',
				timeout: 10000,
				success: function(data) {
				}
			});
			
		}
		
		startSiteseekerSession();
	-->
	</script>
</c:if>


<%------------------------------------------------------
 Perform the search if a query is posted in the request
 i.e. someone has used the search field in the header
 -----------------------------------------------------%>
<c:if test="${not empty param.searchText and param.searchText != searchTextFieldLabel}">
<script type="text/javascript">	
		performNewSearch();
</script>
</c:if>
<management:language id="currentLanguage" languageId="${pc.languageId}"/> 

<script type="text/javascript">
<!--
	jQuery(document).ready(function() {
	    $('#searchTextField').autocomplete(
	      '<c:out value="${siteSeekerQcUrl}"/>', 
	      { 
	        cacheLength: 0,
	        extraParams: { ilang: '<c:out value="${currentLanguage.languageCode}"/>' },
	        delay: 200,
	        resultsClass: "ac_results center",
	        additionalHeight: 2,
	        minChars: 2,
	        selectFirst: false,
	        dataType: 'jsonp',
	        highlight: false,
	        scroll: false,
	        parse: function(data) {
			  var map =  jQuery.map(data, function(row) {
			  	return {data: row};
	          });
	          return map;
	        },
	        formatItem: function(item) {
	          if (item) {
	          	return '<a href="" class="html">'+item.suggestionHighlighted+'</a>';
	          }
	          return;
	        }
	      }
	    )
	    .result(function(event, item) {
	      jQuery('#searchTextField').val(item.suggestion);
	 		$('.ac_results').css("display", "none");
	 		performNewSearch();
	 	});
	});
//-->
</script>