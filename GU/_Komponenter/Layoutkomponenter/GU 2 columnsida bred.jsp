<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<%@ page contentType="text/html; charset=UTF-8" %>

<page:pageContext id="pc"/>
<page:deliveryContext id="dc"/>

<common:urlBuilder id="currentUrl" fullBaseUrl="true"/>
<common:URLEncode id="curAddress" value="${currentUrl}"/>
<common:urlBuilder id="printUrl" fullBaseUrl="false" excludedQueryStringParameters="print">
	<common:parameter name="print" value="true"/>
</common:urlBuilder>

<c:set var="originalResponse" value="${dc.httpServletResponse}"/>

<structure:componentPropertyValue id="randImgs" propertyName="randomHeadLineImages" useInheritance="false"/>
<content:childContents id="headlineImages" propertyName="randomHeadLineImages" searchRecursive="true"/>
<c:set var="headlineImages" value="${headlineImages}" scope="request"/>

<script language="JavaScript" type="text/javascript">
<!--
	var headlines = new Array();
	<c:if test="${not empty randImgs && randImgs ne 'Undefined'}">
		<c:set var="count" value="0"/>
		<c:forEach var="headlineImage" items="${headlineImages}" varStatus="loopCount">
			<content:assetUrls id="assetUrls" contentId="${headlineImage.contentId}"/>
			<c:forEach var="assetUrl" items="${assetUrls}">
				headlines[<c:out value="${count}"/>] = '<c:out value="${assetUrl}" escapeXml="false"/>';
				<c:set var="count" value="${count + 1}"/>
			</c:forEach>
		</c:forEach>
	</c:if>

	var randIndex = -1;
	if(headlines.length>0) 
	{
		randIndex = Math.floor(headlines.length*Math.random());
	}	
-->
</script>

<div class="col25">
	<div id="menuComp">
		<!--eri-no-index-->
		<common:include relationAttributeName="RelatedComponents" contentName="GU Left Navigation 2.0"/>
		<!--/eri-no-index-->
	</div>
</div>

<div class="col75">
	<a name="content"></a>
	
	<c:choose>
		<%--
		<c:when test="${param.siteMap == 'true'}">
			<!-- SiteMap -->
			<common:include relationAttributeName="RelatedComponents" contentName="SiteMap"/>
			<!-- SiteMap End -->				
		</c:when>
		--%>
		
		<c:when test="${param.feedbackForm == 'true'}">
			<!-- Feedback form -->
		        <c:set var="oldDisableNiceUri" value="${dc.disableNiceUri}"/>
		        <page:deliveryContext id="dc" disableNiceUri="true"/>

			<structure:pageUrl id="contactFormPageUrl" propertyName="ContactFormPage"/>
			
			<common:urlBuilder id="contactFormPageUrl" baseURL="${contactFormPageUrl}" excludedQueryStringParameters="keepArticle,siteMap,adjust,recipientName,email,returnAddress,siteNodeId,languageId,contentId">
				<common:parameter name="languageId" value="${pc.languageId}"/>
				<common:parameter name="feedbackForm" value="true"/>
				<common:parameter name="originalAddress" value="${param.originalAddress}"/>
				<common:parameter name="recipientName" value="${param.recipientName}" encodeWithEncoding="iso-8859-1"/>
				<common:parameter name="email" value="${param.email}" encodeWithEncoding="iso-8859-1"/>
				<common:parameter name="subject" value="${param.subject}" encodeWithEncoding="iso-8859-1"/>
			</common:urlBuilder>

		        <%-- Restores the old nice uri setting --%>
		        <c:if test="${oldDisableNiceUri == 'false'}"><page:deliveryContext id="dc" disableNiceUri="false"/></c:if>		

			<iframe id="dialogIFrame" align="top" frameborder="0" width="460" height="400" scrolling="auto" src="<c:out value="${contactFormPageUrl}"/>"></iframe>
			<%--<common:include relationAttributeName="RelatedComponents" contentName="Feedback form"/>--%>
			<!-- Feedback form End -->
			<c:if test="${param.keepArticle == 'true'}">
				<!-- Article -->
				<common:include relationAttributeName="RelatedComponents" contentName="Article"/>
				<!-- Article End -->
			</c:if>
		</c:when>
		<c:when test="${param.tipFriend == 'true'}">
			<!-- tipFriend form -->
			<page:deliveryContext id="dc" disableNiceUri="true"/>
			<structure:pageUrl id="tipAFriendFormPageUrl" propertyName="TipAFriendFormPage" languageId="${pc.languageId}"/>
			<page:deliveryContext id="dc" disableNiceUri="false"/>
			<common:urlBuilder id="tipFriendUrl" baseURL="${tipAFriendFormPageUrl}" excludedQueryStringParameters="siteNodeId,languageId,contentId">
				<common:parameter name="languageId" value="${pc.languageId}"/>
				<common:parameter name="tipFriend" value="true"/>
				<common:URLEncode id="tipUrl" value="${currentUrl}"/>
				<common:parameter name="tipUrl" value="${tipUrl}"/>
			</common:urlBuilder>

			<iframe id="dialogIFrame" align="top" frameborder="0" width="460" height="400" scrolling="auto" src="<c:out value="${tipFriendUrl}"/>"></iframe>
			<!-- tipFriendUrl form End -->
		</c:when>

		<c:when test="${param.showMap == 'true'}">
			<!-- Map -->
			<c:set var="title">Karta - <c:out value="${param.mapTitle}"/></c:set>
			<c:if test="${pc.locale.language == 'en'}">
				<c:set var="title">Map - <c:out value="${param.mapTitle}"/></c:set>
			</c:if>
			<h1><c:out value="${title}" escapeXml="false"/></h1>
			<c:set var="mapAlias" value="${param.mapAlias}"/>
			<c:set var="mapUrl">http://www.kartena.se/content/viewer/Default.aspx?customerId=4&category=19,20,21,22,23,17,18,4&alias=<c:out value="${mapAlias}" escapeXml="false"/>&all=0&lang=<c:out value="${pc.locale.language}"/></c:set>
			<iframe frameborder="0" width="100%" height="900" id="mapFrame" name="mapFrame" src="<c:out value="${mapUrl}" escapeXml="false"/>"></iframe>
			<!-- Map End -->
		</c:when>

		<c:otherwise>
			<!-- Article -->
			<common:include relationAttributeName="RelatedComponents" contentName="Article"/>
			<!-- Article End -->
		</c:otherwise>
	</c:choose>
	
	<ig:slot id="middleUpperBottom" inherit="false" allowedComponentGroupNames="Single Content,Content Iterators,Other,Search,Form elements"></ig:slot> 
		
	<div class="clr"></div>
</div>

<!-- ContentEnd -->
<div class="clr"></div>

<c:if test="${contentVersion == null}">
	<content:content id="pageMetaInfoContent" contentId="${pc.metaInformationContentId}"/>
	<content:contentVersion id="contentVersion" content="${pageMetaInfoContent}"/>
</c:if>
		
<structure:pageAttribute id="responsibleName" attributeName="responsibleName" disableEditOnSight="true"/>
<structure:pageAttribute id="responsibleEmail" attributeName="responsibleEmail" disableEditOnSight="true"/>
<%--
<content:contentAttribute id="responsibleName" contentId="${pc.metaInformationContentId}" attributeName="responsibleName" disableEditOnSight="true" />
<content:contentAttribute id="responsibleEmail" contentId="${pc.metaInformationContentId}" attributeName="responsibleEmail" disableEditOnSight="true"/>
--%>
<c:choose>
	<c:when test="${not empty responsibleName}">
		<c:set var="pageResponsibleName" value="${responsibleName}"/>
		<c:set var="pageResponsibleEmail" value="${responsibleEmail}"/>
	</c:when> 
	<c:otherwise> 
		<management:principal id="principal" userName="${contentVersion.versionModifier}"/>
		<c:if test="${empty principal}"> <%-- In case the person who last modified the version has leaved use Administrator as default --%>
			<management:principal id="principal" userName="Administrator"/>	
		</c:if>
		<c:set var="pageResponsibleName" value="${principal.firstName} ${principal.lastName}"/>
		<c:set var="pageResponsibleEmail" value="${principal.email}"/>
	</c:otherwise> 
</c:choose>   

<common:encrypt id="encryptedEmail" value="${pageResponsibleEmail}"/>
<common:URLEncode id="encryptedEmail" value="${encryptedEmail}"/>
         
<common:urlBuilder id="currentUrl" fullBaseUrl="true"/>
<common:URLEncode id="returnAddress" value="${currentUrl}"/>

<common:URLEncode id="encodedPrincipalName" value="${pageResponsibleName}"/>
<content:contentAttribute id="technicalEmail" propertyName="siteLabels" attributeName="technicalEmail"/>

<%-- Disables the niceURI feature as the close javascript will not work if on --%>
<c:set var="oldDisableNiceUri" value="${dc.disableNiceUri}"/>
<page:deliveryContext id="dc" disableNiceUri="true"/>
        
<structure:pageUrl id="contactFormPageUrl" propertyName="ContactFormPage" languageId="${pc.languageId}"/>
<structure:pageUrl id="tipAFriendFormPageUrl" propertyName="TipAFriendFormPage" languageId="${pc.languageId}"/>
   
<common:urlBuilder id="contactFormPageUrl" baseURL="${contactFormPageUrl}" fullBaseUrl="true" excludedQueryStringParameters="siteMap,siteSearch,adjust,recipientName,email,returnAddress,siteNodeId,languageId,contentId">
	<common:parameter name="languageId" value="${pc.languageId}"/>
	<common:parameter name="feedbackForm" value="true"/>
	<common:parameter name="keepArticle" value="true"/>
	<common:parameter name="returnAddress" value="${returnAddress}"/>
	<common:parameter name="recipientName" value="${encodedPrincipalName}"/>
	<common:parameter name="email" value="${encryptedEmail}"/>
</common:urlBuilder>

<common:urlBuilder id="tipFriendUrl" baseURL="${tipAFriendFormPageUrl}" excludedQueryStringParameters="siteNodeId,languageId,contentId">
	<common:parameter name="languageId" value="${pc.languageId}"/>
	<common:parameter name="tipFriend" value="true"/>
	<common:URLEncode id="tipUrl" value="${currentUrl}"/>
	<common:parameter name="tipUrl" value="${tipUrl}"/>
</common:urlBuilder>

<%-- Restores the old nice uri setting --%>
<c:if test="${oldDisableNiceUri == 'false'}"><page:deliveryContext id="dc" disableNiceUri="false"/></c:if>		

<common:urlBuilder id="contactFormFallbackUrl" excludedQueryStringParameters="keepArticle,siteMap,adjust,recipientName,email,returnAddress">
	<common:parameter name="feedbackForm" value="true"/>
	<common:parameter name="returnAddress" value="${returnAddress}"/>
	<common:parameter name="recipientName" value="${encodedRecipientName}"/>
	<common:parameter name="email" value="${encryptedEmail}"/>
</common:urlBuilder>

<common:urlBuilder id="tipFriendFallbackUrl" excludedQueryStringParameters="keepArticle,siteSearch,siteMap,adjust,recipientName,email,returnAddress">
	<common:parameter name="tipFriend" value="true"/>
	<common:URLEncode id="tipUrl" value="${currentUrl}"/>
	<common:parameter name="tipUrl" value="${tipUrl}"/>
</common:urlBuilder>

<%-- PRINTER FRIENDLY URL --%>
<content:content id="content" propertyName="Article" useInheritance="false"/>

<common:urlBuilder id="printUrl"  >
	<common:parameter name="print" value="true"/>
	<c:if test="${not empty param.searchstring}">
		<common:URLEncode id="encodedSearchString" value="${param.searchstring}"/>
     	<common:parameter name="searchstring" value="${encodedSearchString}"/>
    </c:if>
</common:urlBuilder>
			
<structure:componentLabel id="dateTimeFormat" mapKeyName="dateTimeFormat"/>
	
<div id="contentEnd">
	<div class="col25"></div>
	<div class="col75">
		
		<a href="#top" id="uplink" title="<structure:componentLabel mapKeyName="toPageTopTitle"/>"><structure:componentLabel mapKeyName="toPageTopLabel"/></a>

		<div class="right">
		<script type="text/javascript">
			var addthis_config = {
	          services_compact: 'facebook, twitter, email, delicious, bloggy, myspace, more',
	          services_exclude: 'print'
			}
		</script>
			<!-- AddThis Button BEGIN -->
			<div class="addthis_toolbox addthis_default_style">
			<a href="http://addthis.com/bookmark.php?v=250&amp;username=guinfo" id="share" class="addthis_button"><structure:componentLabel mapKeyName="shareThisLabel"/></a>
			</div>
			<script type="text/javascript" src="http://s7.addthis.com/js/250/addthis_widget.js#username=guinfo"></script>
			<!-- AddThis Button END -->
		</div>
		
		<div class="clr"></div>
		
		<div id="byline">
			<!-- 
			<p class="left">
				<structure:componentLabel mapKeyName="pageResponsibleLabel"/>: 
			 -->	
				<script type="text/javascript">
				<!--
				var contactFormPageUrl = '<c:out value="${contactFormPageUrl}" escapeXml="false"/>';
				document.write("<p class=\"left\">");
				document.write("<structure:componentLabel mapKeyName="pageResponsibleLabel"/>: ");
				document.write("<a href=\"javascript:void(0);\" onclick=\"showFormDialog(event, contactFormPageUrl, 'dialogContact');\" title=\"<structure:componentLabel mapKeyName="pageResponsibleTitle"/>\"><c:out value="${pageResponsibleName}"/></a>");
				document.write("<br /><structure:componentLabel mapKeyName="pageLastUpdatedLabel"/>: <common:formatter value="${contentVersion.modifiedDateTime}" pattern="${dateTimeFormat}"/>");
				document.write("</p>");
				-->
				</script>
				<noscript>
					<p class="left">
						<structure:componentLabel mapKeyName="pageResponsibleLabel"/>: 
						<a rel="nofollow" href="<c:out value="${contactFormFallbackUrl}" escapeXml="true"/>" title="<structure:componentLabel mapKeyName="pageResponsibleTitle"/>"><c:out value="${pageResponsibleName}"/></a>
						<br /><structure:componentLabel mapKeyName="pageLastUpdatedLabel"/>: <common:formatter value="${contentVersion.modifiedDateTime}" pattern="${dateTimeFormat}"/>
					</p>
				</noscript>
			<!-- 
				<br /><structure:componentLabel mapKeyName="pageLastUpdatedLabel"/>: <common:formatter value="${contentVersion.modifiedDateTime}" pattern="${dateTimeFormat}"/>
			</p>
			-->
			<!-- 
			<p class="right">
			 -->
				<script type="text/javascript">
				<!--
				var tipFriendUrl = '<c:out value="${tipFriendUrl}" escapeXml="false"/>';
				document.write("<p class=\"right\">");
				document.write("<a href=\"javascript:void(0);\" onclick=\"showFormDialog(event, tipFriendUrl, 'dialogTip');\" title=\"<structure:componentLabel mapKeyName="tipAFriendTitle"/>\"><structure:componentLabel mapKeyName="tipAFriendLabel"/></a>");
				document.write("<br /><a href=\"<c:out value="${printUrl}" escapeXml="true"/>\" title=\"<structure:componentLabel mapKeyName="printPageTitle"/>\"><structure:componentLabel mapKeyName="printPageLabel"/></a>");
				document.write("</p>");
				-->
				</script>
				<noscript>
					<p class="right">
						<a rel="nofollow" href="<c:out value="${tipFriendFallbackUrl}" escapeXml="true"/>" title="<structure:componentLabel mapKeyName="tipAFriendTitle"/>"><structure:componentLabel mapKeyName="tipAFriendLabel"/></a>
						<br /><a href="<c:out value="${printUrl}" escapeXml="true"/>" title="<structure:componentLabel mapKeyName="printPageTitle"/>"><structure:componentLabel mapKeyName="printPageLabel"/></a>
					</p>
				</noscript>
		</div>
	</div>
	<div class="clr"></div>
</div>
<div class="clr"></div>
