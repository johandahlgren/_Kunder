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

<page:pageContext id="pc"/>
<page:deliveryContext id="dc"/>

<%
	org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController controller = (org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");	
	String searchAjaxServiceSiteNodeId = controller.getRepositoryExtraProperty("searchAjaxServiceSiteNodeId");
	String numberOfResultsPerPage = controller.getRepositoryExtraProperty("numberOfResultsPerPage");
	String numberOfResultsPerPagePersonnel = controller.getRepositoryExtraProperty("numberOfResultsPerPagePersonnel");
	String site = controller.getRepositoryExtraProperty("site");
	String categoryAllWeb = controller.getRepositoryExtraProperty("categoryAllWeb");
	String categoryPersonnel = controller.getRepositoryExtraProperty("categoryPersonnel");
	String noCharactersInURL = controller.getRepositoryExtraProperty("noCharactersInURL");
	String limitToSiteUrl = controller.getRepositoryExtraProperty("limitToSiteUrl");
	
	pageContext.setAttribute("numberOfResultsPerPage", numberOfResultsPerPage);
	pageContext.setAttribute("numberOfResultsPerPagePersonnel", numberOfResultsPerPagePersonnel);
	pageContext.setAttribute("site", site);
	pageContext.setAttribute("categoryAllWeb", categoryAllWeb);
	pageContext.setAttribute("categoryPersonnel", categoryPersonnel);
	pageContext.setAttribute("noCharactersInURL", noCharactersInURL);

	pageContext.setAttribute("limitToUrl", limitToSiteUrl); // "http://www.cs.chalmers.se");// 
	pageContext.setAttribute("searchAjaxService", searchAjaxServiceSiteNodeId);
%>

<structure:pageUrl id="cssUrl" propertyName="CSS pages" useInheritance="true"/>

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
<c:if test="${empty categoryPersonnel}">
	<c:set var="categoryPersonnel" value="105"/>
</c:if>
<c:if test="${empty noCharactersInURL}">
	<c:set var="noCharactersInURL" value="97"/>
</c:if>

<structure:componentPropertyValue id="headerType" propertyName="HeaderType"/>
<c:if test="${empty headerType || headerType == 'false'}">
	<c:set var="headerType" value="standardGU"/>
</c:if>

<structure:componentLabel id="searchResultCompCloseTitle" mapKeyName="SearchResultCompCloseTitle"/>
<structure:componentLabel id="searchResultCompTitle" mapKeyName="SearchResultCompTitle"/>
<structure:componentLabel id="searchTextLabel" mapKeyName="SearchTextLabel"/>
<structure:componentLabel id="numberOfHitsTitle" mapKeyName="NumberOfHitsTitle" />
<structure:componentLabel id="titleResultAll" mapKeyName="TitleResultAll" />
<structure:componentLabel id="titleResultPersonnel" mapKeyName="TitleResultPersonnel" />
<structure:componentLabel id="searchLabel" mapKeyName="searchLabel" /> 
<c:if test="${empty site}">
	<c:set var="site" value="null"/>
</c:if>

<c:if test="${empty categoryAllWeb}">
	Inget v&auml;rde angivet f&ouml;r kategorin "Hela webben".<br/>
</c:if>
<c:if test="${empty categoryPersonnel}">
	Inget v&auml;rde angivet f&ouml;r kategorin "Personal".<br/>
</c:if>

<c:choose>
	<c:when test="${empty searchAjaxService}">
		<c:set var="serverName"><%= pageContext.getRequest().getServerName() %></c:set>
		<c:choose>
			<c:when test="${serverName == 'dev.cms.it.gu.se'}">
				<c:set var="searchAjaxService" value="111214" />
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

<c:if test="${empty searchAjaxService}">
	Ingen searchAjaxService utpekad.<br/>
</c:if>

<c:set var="selectedBatch" value="1"/>

<c:if test="${not empty param.batch}">
	<c:set var="selectedBatch" value="${param.batch}"/>
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
		float: left;
	}	
</style>

<div id="searchResultComp">
	<div class="col100">
		<a name="content"></a>
		<h1><c:out value="${searchResultCompTitle}" escapeXml="false"/></h1> 
		<form name="mainSearch" method="post" action="" onsubmit="performSearch(); return false;">
			<fieldset>
				<input name="siteSearch" type="hidden" value="true"/>
				<input name="isJavascriptSupported" type="hidden" value="false"/>
				<input type="hidden" id="sortOrder"/>
				<input type="hidden" name="categoryId" id="categoryId"/>
				<input type="hidden" name="categoryTitle" id="categoryTitle"/>
				<input type="hidden" name="searchDocumentType" id="0"/>

				<label for="searchText">
				<c:out value="${searchTextLabel}" escapeXml="false"/>:
				</label> 
				<br />
				<c:choose>
					<c:when test="${headerType == 'level3page'}">
						<input name="searchText" type="text" value="<c:out value="${param.searchText}"/>" id="searchText" title="<structure:componentLabel mapKeyName="searchWordLevel3Title"/>" class="searchfield" />&nbsp;
					</c:when>
					<c:otherwise>
						<input name="searchText" type="text" value="<c:out value="${param.searchText}"/>" id="searchText" title="<structure:componentLabel mapKeyName="searchWordTitle"/>" class="searchfield" />&nbsp;
					</c:otherwise>
				</c:choose>
						
				<input type="submit" value="<c:out value="${searchLabel}"/>" />

			</fieldset>
		</form>
		<p class="nomargin"><a href="http://katagu.gu.se/katagu.taf?lang=<c:out value="${pc.locale}"/>" title="<structure:componentLabel mapKeyName="kataGULinkTitle"/>"><structure:componentLabel mapKeyName="kataGULinkLabel"/></a></p>
	</div>		
	<div class="clr"></div>

	<structure:pageUrl id="searchAjaxServiceUrl" siteNodeId="${searchAjaxService}" languageId="${pc.languageId}"/>
	<div class="col75">
		<c:if test="${not empty param.searchText}">
			<common:urlBuilder id="queryUrlAll" baseURL="${searchAjaxServiceUrl}">
				<common:parameter name="languageId" value="${pc.languageId}"/>
				<common:parameter name="searchText" value="${param.searchText}"/>
				<common:parameter name="noCharactersInURL" value="${noCharactersInURL}"/>
				<common:parameter name="site" value="${site}"/>
				<common:parameter name="batch" value="${selectedBatch}"/>
				<common:parameter name="searchCategory" value="${categoryAllWeb}"/>
				<common:parameter name="hn" value="${numberOfResultsPerPage}"/>
				<common:parameter name="categoryName" value="${titleResultAll}"/>
				<common:parameter name="noAjax" value="true"/>
				<common:parameter name="cssUrl" value="${cssUrl}"/>
			</common:urlBuilder>
			
			<!-- queryUrlAll: <c:out value="${queryUrlAll}" />

			<iframe id="mainResults" src="<c:out value="${queryUrlAll}" escapeXml="true" />" style="border: 0px; width: 100%; height: 1550px;" frameborder="0">
			</iframe>
		</c:if>
	</div>
	<div class="col25">
		<c:if test="${not empty param.searchText}">
			<common:urlBuilder id="queryUrlPersonnel" baseURL="${searchAjaxServiceUrl}">
				<common:parameter name="languageId" value="${pc.languageId}"/>
				<common:parameter name="searchText" value="${param.searchText}"/>
				<common:parameter name="noCharactersInURL" value="${noCharactersInURL}"/>
				<common:parameter name="site" value="${site}"/>
				<common:parameter name="batch" value="${selectedBatch}"/>
				<common:parameter name="searchCategory" value="${categoryPersonnel}"/>
				<common:parameter name="hn" value="${numberOfResultsPerPagePersonnel}"/>
				<common:parameter name="categoryName" value="${titleResultPersonnel}"/>
				<common:parameter name="noAjax" value="true"/>
				<common:parameter name="cssUrl" value="${cssUrl}"/>
				<common:parameter name="divId" value="personnel"/>
			</common:urlBuilder>
		
			<!-- queryUrlPersonnel: <c:out value="${queryUrlPersonnel}" />
		
			<iframe id="personsResults" src="<c:out value="${queryUrlPersonnel}" escapeXml="true" />" style="border: 0px; width: 100%; height: 1550px;" frameborder="0">
			</iframe>
		</c:if>
	</div>
	<div class="clr"></div>
</div>