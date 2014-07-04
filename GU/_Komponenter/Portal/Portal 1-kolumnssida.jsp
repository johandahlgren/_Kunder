<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<%@ page contentType="text/html; charset=UTF-8" %>

<page:pageContext id="pc"/>
<page:deliveryContext id="dc"/>

<structure:componentLabel id="tipAFriendSubject" mapKeyName="tipAFriendSubject"/>
<structure:componentLabel id="tipAFriendTipText" mapKeyName="tipAFriendTipText"/>
<structure:componentLabel id="tipAFriendCommentHeader" mapKeyName="tipAFriendCommentHeader"/>
<structure:componentLabel id="tipAFriendFooter" mapKeyName="tipAFriendFooter"/>
<structure:componentLabel id="tipAFriendHeader" mapKeyName="tipAFriendHeader"/>

<common:urlBuilder id="currentUrl" fullBaseUrl="true"/>
<common:URLEncode id="curAddress" value="${currentUrl}"/>
<common:urlBuilder id="printUrl" fullBaseUrl="false" excludedQueryStringParameters="print">
	<common:parameter name="print" value="true"/>
</common:urlBuilder>

<c:set var="originalResponse" value="${dc.httpServletResponse}"/>

<structure:componentPropertyValue id="randImgs" propertyName="randomHeadLineImages" useInheritance="false"/>
<content:childContents id="headlineImages" propertyName="randomHeadLineImages" searchRecursive="true"/>
<c:set var="headlineImages" value="${headlineImages}" scope="request"/>

<script type="text/javascript">
	// This script is only here to prevent a javascript error in the article component whis has some kind of useless random image functionality.
	var randIndex = -1;
	//var headlines = new Array();
</script>

<div class="col100">
	<a name="content"></a>
	
	<c:choose>
		<c:when test="${param.feedbackForm == 'true'}">
			<common:decrypt id="decryptedEmail" value="${param.email}"/>

			<common:decrypt id="decryptedSubject" value="${param.subject}"/>
			<c:choose>
				<c:when test="${empty decryptedSubject}">
					<common:encrypt id="subject" value="Kontaktformulär"/>
				</c:when>
				<c:otherwise>
					<c:set var="subject" value="${param.subject}"/>
				</c:otherwise>
			</c:choose>
			
			<common:decrypt id="decryptedSubject" value="${subject}"/>
				   
			<common:transformText id="body" text="${param.body}" replaceLineBreaks="true" lineBreakReplacer="<br/>"/>
			<c:set var="message">
				<div><strong>Följande meddelande är skickat via GU:s webb:</strong><br /><br /></div>
		        <div><c:out value="${body}" escapeXml="false"/><br/><br /></div>
		        <div>Telefon: <c:out value="${param.phone}"/></div>
				<div>E-post: <a href="mailto:<c:out value="${param.senderEmail}"/>"><c:out value="${param.senderEmail}"/></a></div>
				<div><br /><hr>Meddelandet skickades från:</div>
				<div>Webbsida: <a href="<c:out value="${originalAddress}"/>"><c:out value="${originalAddress}"/></a></div>
				<div>IP-nummer: <%= request.getRemoteAddr() %></div>
				<div>Webbläsare: <%= request.getHeader("User-Agent") %></div>
			</c:set>
				
			<c:choose>
				<c:when test="${param.sendCopyToSender == 'ja' && not empty param.senderEmail}">
					<common:mail id="mailStatus" from="no-reply@gu.se" to="${decryptedEmail}" cc="${param.senderEmail}" bcc="kontaktform@gu.se" subject="${decryptedSubject}" type="text/html" charset="utf-8" message="${message}"/>
				</c:when>
				<c:otherwise>
					<common:mail id="mailStatus" from="no-reply@gu.se" to="${decryptedEmail}" bcc="kontaktform@gu.se" subject="${decryptedSubject}" type="text/html" charset="utf-8" message="${message}"/>
				</c:otherwise>
			</c:choose>

			<c:choose>
				<c:when test="${mailStatus}">
													
					<!-- Kontaktform - kvitto -->			  
					<h1><c:out value="${contactFormReceiptTitle}" escapeXml="false"/></h1>
					
					<h2><c:out value="${ContactFormReceiptSubTitle}" escapeXml="false"/></h2>
				
					<h3><c:out value="${contactFormReceiptReceiver}" escapeXml="false"/></h3>
					<p><c:out value="${recipientName}"/></p>
				
					<h3><c:out value="${contactFormReceiptYourEmail}" escapeXml="false"/></h3>
					<p><c:out value="${param.senderEmail}"/></p>
							
					<h3><c:out value="${contactFormReceiptPhone}" escapeXml="false"/></h3>
					<p><c:out value="${param.phone}"/></p>
				
					<h3><c:out value="${contactFormReceiptMessage}" escapeXml="false"/></h3>
					<p><c:out value="${param.body}"/></p>
				
					<c:if test="${param.sendCopyToSender == 'ja'}">
					<p><i>(<c:out value="${contactFormReceiptCopyToSender}" escapeXml="false"/> <c:out value="${param.senderEmail}"/>)</i></p><br />
					</c:if>

					<script type="text/javascript">
					<!--
						if(parent.hideFormDialog)
							document.write("<p><a href=\"javascript:parent.hideFormDialog();\" title=\"<c:out value="${contactFormReceiptCloseDialogTitle}"/>\"><c:out value="${contactFormReceiptCloseDialog}" escapeXml="false"/></a></p>");
						else
							document.write("<p><a href=\"javascript:parent.hideFormDialog();\" title=\"<c:out value="${contactFormReceiptReturnPageTitle}"/>\"><c:out value="${contactFormReceiptReturnPage}" escapeXml="false"/></a></p>");
					-->
					</script>
					<noscript>
					<!--
						<p><a href="javascript:parent.hideFormDialog();" title="<c:out value="${contactFormReceiptReturnPageTitle}"/>"><c:out value="${contactFormReceiptReturnPage}" escapeXml="false"/></a></p>
					-->
					</noscript>
					
					<!-- Kontaktform - kvitto Slut --> 
							
				</c:when>
				<c:otherwise>
					<c:choose>
						<c:when test="${commonMailTagException.class.name == 'javax.mail.internet.AddressException'}">
							<h1><c:out value="${commonMailTagException.message}"/></h1>
							<p><a href="javascript:history.go(-1);">Tillbaka</a></p>
						</c:when>
						<c:otherwise>
							<h1>Error sending mail / Fel vid skickande av mail</h1>
							<p>Meddelandet kunde inte skickas - var god kontakta oss per telefon (031-773 1000) och påtala felet. Felet som rapporterades var: <c:out value="${commonMailTagException.message}"/></p>
						</c:otherwise>
					</c:choose>
				</c:otherwise>
			</c:choose>
		  	<div class="clear"></div>
		</c:when>
		<c:when test="${param.tipFriend == 'true'}">
			<c:set var="messageSent" value="false"/>		
			<c:choose>
				<c:when test="${param.sendMail == 'true' && not empty param.receiverEmail && not empty param.senderEmail}">
					<c:set var="message">
						<div>
							<a href="mailto:"<c:out value="${param.senderEmail}"/>"><c:out value="${param.senderEmail}"/></a><br />
							<c:out value="${tipAFriendTipText}" escapeXml="false"/><br /><br />
							<a href="<c:out value="${param.tipUrl}"/>"><c:out value="${param.tipUrl}"/></a>
							<hr />
							<c:out value="${tipAFriendFooter}" escapeXml="false"/>
						</div>
					</c:set>
					<common:mail id="mailStatus" from="no-reply@gu.se" to="${param.receiverEmail}" cc="${param.senderEmail}" subject="${tipAFriendSubject}" type="text/html" charset="utf-8" message="${message}"/>
					<c:set var="messageSent" value="true"/>
				</c:when>
		
				<c:when test="${param.sendMail == 'true'}">
					<c:set var="tipFriendErrorMessage" value="${tipAFriendMessageError}"/>
				</c:when>
			</c:choose>
		</c:when>
		<c:otherwise>
			<!-- Article -->
			<page:pageAttribute id="skipArticleInclude" name="skipArticleInclude"/>
			<!-- If another component wants to take over the rendering of the page article it should set this page attribute -->
			<c:if test="${empty skipArticleInclude || skipArticleInclude == false}"> 
				<common:include relationAttributeName="RelatedComponents" contentName="Article"/>
			</c:if>
			<!-- Article End -->
		</c:otherwise>
	</c:choose>
	
	<c:if test="${param.siteMap != 'true' && param.feedbackForm != 'true' && param.adjust != 'true'}">
		<structure:childComponents id="childComponents" slotId="middle"/>
		<common:size id="size" list="${childComponents}"/>
		<c:if test="${size > 0 || pc.isInPageComponentMode}">
			<ig:slot id="middle" inherit="false" allowedComponentGroupNames="PortalMiddleColumn"></ig:slot>  
		</c:if>
	</c:if>
</div>

<!-- ContentEnd -->

<div class="clr"></div>

<c:if test="${contentVersion == null}">
	<content:content id="pageMetaInfoContent" contentId="${pc.metaInformationContentId}"/>
	<content:contentVersion id="contentVersion" content="${pageMetaInfoContent}"/>
</c:if>
		
<structure:pageAttribute id="responsibleName" attributeName="responsibleName" disableEditOnSight="true"/>
<structure:pageAttribute id="responsibleEmail" attributeName="responsibleEmail" disableEditOnSight="true"/>

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
	<div class="col100">
		<a href="#top" id="uplink" title="<structure:componentLabel mapKeyName="toPageTopTitle"/>"><structure:componentLabel mapKeyName="toPageTopLabel"/></a>
		
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
				document.write("<a href=\"javascript:void(0);\" onclick=\"showFormDialogInline(event, contactFormPageUrl, 'dialogContact');\" title=\"<structure:componentLabel mapKeyName="pageResponsibleTitle"/>\"><c:out value="${pageResponsibleName}"/></a>");
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
				document.write("<a href=\"javascript:void(0);\" onclick=\"showFormDialogInline(event, tipFriendUrl, 'dialogTip');\" title=\"<structure:componentLabel mapKeyName="tipAFriendTitle"/>\"><structure:componentLabel mapKeyName="tipAFriendLabel"/></a>");
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
