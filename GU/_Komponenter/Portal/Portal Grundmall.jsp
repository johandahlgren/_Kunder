<%@page import="java.util.Date"%>
<%@page import="org.infoglue.cms.util.CmsPropertyHandler"%>
<%@page import="org.infoglue.cms.security.AuthenticationModule"%>
<%@page import="org.infoglue.deliver.util.HttpHelper"%>
<%@page import="javax.imageio.IIOException"%>
<%@page import="java.text.StringCharacterIterator"%>
<%@page import="java.text.CharacterIterator"%>

<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>

<page:pageContext id="pc"/>
<%--
<page:deliveryContext id="deliveryContext" operatingMode="0"/>--%>

<c:if test="${param.refresh eq 'true'}">
	<common:urlBuilder id="refreshUrl" excludedQueryStringParameters="refresh">
	</common:urlBuilder>
	<common:sendRedirect url="${refreshUrl}" />
</c:if>

<structure:boundPage id="redirectPage" propertyName="RedirectPage" useInheritance="false"/>
<c:if test="${not empty redirectPage && !pc.isInPageComponentMode}">
	<page:deliveryContext id="deliveryContext" disablePageCache="true"/>
	<common:sendRedirect url="${redirectPage.url}"/>
</c:if>

<content:content id="personFolder" propertyName="PersonFolder" />
<structure:componentPropertyValue id="phoneBookLink" propertyName="PhoneBookLink" useInheritance="true"/>
<structure:componentPropertyValue id="webMailLink" propertyName="WebMailLink" useInheritance="true"/>
<structure:componentPropertyValue id="googleKey" propertyName="GoogleKey" useInheritance="true"/>
<structure:pageUrl id="mySettingsUrl" propertyName="MySettingsPage" useInheritance="true" />
<structure:siteNode id="mySettingsPage" propertyName="MySettingsPage" useInheritance="true" />

<c:set var="serverName" value="${pageContext.request.serverName}" />

<management:language id="saveLanguage" languageCode="sv"/>

<content:content id="eulaList" propertyName="EULAList" useInheritance="true" />
<c:choose>
	<c:when test="${not empty eulaList}">
		<content:contentVersion id="eulaListVersion" content="${eulaList}" languageId="${saveLanguage.languageId}" useLanguageFallback="false" />
		<c:if test="${not empty eulaListVersion}">
			<content:contentAttribute id="approvedUsers" contentVersion="${eulaListVersion}" attributeName="ApprovedUsers" disableEditOnSight="true"/>
		</c:if>
		<c:set var="principal" value="${pc.principal.name}" />
		<%
			String userName 		= (String) pageContext.getAttribute("principal");
			String approvedUsers 	= (String) pageContext.getAttribute("approvedUsers");
			boolean confirmed = false;
			if(userName != null && approvedUsers != null){
				confirmed = approvedUsers.indexOf(userName) != -1;
			}
			
			pageContext.setAttribute("hasConfirmed", confirmed);
		
		%>		
	</c:when>
	<c:when test="${empty eulaList}">
		<c:set var="hasConfirmed" value="true"/>
	</c:when>
</c:choose>

<%--
<c:set var="hasConfirmed" value="${true}"/>
--%>
<c:set var="hasConfirmed" value="${hasConfirmed}" scope="request" />

<management:language id="currentLanguage" languageId="${pc.languageId}" />

<management:principalProperty id="preferredPortalLanguage" principal="${pc.principal}" attributeName="PreferredPortalLanguage" />

<%--<c:if test="${not empty preferredPortalLanguage and preferredPortalLanguage ne currentLanguage.languageCode}">
	<structure:pageUrlAfterLanguageChange id="currentUrlDifferentLanguage" languageCode="${preferredPortalLanguage}" />
	<common:sendRedirect url="${currentUrlDifferentLanguage}" />
</c:if>--%>

<c:if test="${param.userAction eq 'logout'}">
	<c:set var="mySession" value="${pc.httpServletRequest.session}"/>
	<%
		javax.servlet.http.HttpSession mySession = (javax.servlet.http.HttpSession)pageContext.getAttribute("mySession");
		mySession.invalidate();
	%>
	<%-- TODO: Redir CAS - property --%>
	<common:urlBuilder id="currentUrl" excludedQueryStringParameters="userAction"/>
	<common:sendRedirect url="http://www.gu.se"/>
</c:if>


<%@ page contentType="text/html; charset=UTF-8" %>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">

<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<c:out value="${pc.locale}"/>" lang="<c:out value="${pc.locale}"/>">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
		<meta http-equiv="content-type" content="text/html; charset=utf-8" />
		<meta http-equiv="content-language" content="<c:out value="${pc.locale}"/>"/>
		<meta name="language" content="<c:out value="${pc.locale}"/>" />
		<meta name="generator" content="InfoGlue"/>

		<%-- TODO: vad göra? --%>
		<meta name="LAST-MODIFIED" content="2009-08-07' pattern='yyyy-MM-dd'/>"/>
		<meta name="copyright" content="Copyright University of Gothenburg 2008"/>

		<link rel="shortcut icon" href="<content:assetUrl propertyName="Resources" assetKey="favicon"/>"/>

		<page:pageAttribute id="pageTitlePrefix" name="pageTitlePrefix" />
	
		<c:if test="${pc.contentId > -1}"> 
			<content:contentAttribute id="contentTitle" contentId="${pc.contentId}" attributeName="Title"/>
			<c:set var="pageTitlePrefix" value="${contentTitle}"/>
		</c:if>

		<structure:componentPropertyValue id="baseTitle" propertyName="BaseTitle" useInheritance="true" />
		<title><c:out value="${pageTitlePrefix}" escapeXml="false" /><c:if test="${not empty pageTitlePrefix and not empty baseTitle}"> &#8211; </c:if><c:out value="${baseTitle}" escapeXml="false"/></title>

		<page:deliveryContext id="deliveryContext" disableNiceUri="true"/>
	
		<c:set var="serverName"><%=pageContext.getRequest().getServerName() %></c:set>

		<structure:boundPages id="cssPages" propertyName="CSS pages"/>
		<c:forEach var="cssPage" items="${cssPages}"> 
			<structure:siteNode id="cssNode" siteNodeId="${cssPage.siteNodeId}"/>

			<common:urlBuilder id="cssUrl" baseURL="${cssPage.url}" query="" excludedQueryStringParameters="adjust,siteNodeId,repositoryName">
	            <c:if test="${param.saveAdjust == 'true'}">
					<common:parameter name="saveAdjust" value="true"/>
					<common:parameter name="refresh" value="true"/>
			        <common:parameter name="textFontSize" value="${param.textFontSize}"/>
			        <common:parameter name="fontFamily" value="${param.fontFamily}"/>
			        <common:parameter name="textLineHeight" value="${param.textLineHeight}"/>
			        <common:parameter name="contrast" value="${param.contrast}"/>
			        <common:parameter name="wordspace" value="${param.wordspace}"/>
			        <common:parameter name="letterSpace" value="${param.letterSpace}"/> 
	            </c:if>      
            </common:urlBuilder>

		    <style type="text/css" media="screen">@import url(<c:out value="${cssUrl}"/>);</style>     		
		</c:forEach>

		<structure:boundPage id="printCss" propertyName="printCSS"/>
  	    <link rel="stylesheet" media="print" href="<c:out value='${printCss.url}'/>" type="text/css" />
	
		<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>
	
		<c:if test="${!pc.isInPageComponentMode}">
			<script type="text/javascript" src="<c:out value="${pageContext.request.contextPath}"/>/script/jquery/jquery-1.2.6.min.js"></script>
			<script type="text/javascript" src="<c:out value="${pageContext.request.contextPath}"/>/script/jqueryplugins/ui/jquery-ui-dragDropTabs-1.6rc2.min.js"></script>
		</c:if>
	
		<%-- TODO: browser-stöd --%>
		<script type="text/javascript">
	  		var isRunningIE6OrBelow = false; 
	  	</script>
		<!--[if lt IE 7]>
			<script defer type="text/javascript" src="<c:out value="${pageContext.request.contextPath}"/>/script/pngfix.js"></script>
			<script defer type="text/javascript">try { document.execCommand('BackgroundImageCache', false, true); } catch(e) {}</script>
			<script type="text/javascript">
		  		var isRunningIE6OrBelow = true;
			</script>
		<![endif]-->
		
		<%-- TODO: vad händer här? --%>
		<page:deliveryContext id="deliveryContext" disableNiceUri="true"/>
		<structure:boundPage id="scriptPage" propertyName="JavascriptPage"/>
		<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>
		
		
	   	<script type="text/javascript" src="<c:out value='${scriptPage.url}'/>"></script>
	
		<%-- TODO: integrera med userProperties --%>
		<style type="text/css">
	
		    <structure:componentPropertyValue id="headerBackgroundColor" propertyName="HeadAreaBackgroundColor"/>
		    <structure:componentPropertyValue id="headerColor" propertyName="HeadAreaLeftColor"/>
		    <structure:componentPropertyValue id="headerPadding" propertyName="HeadAreaLeftPadding"/>
			<%
				String headerPadding = (String)pageContext.getAttribute("headerPadding");
				String headerBackgroundColor = (String)pageContext.getAttribute("headerBackgroundColor");
				String headerColor = (String)pageContext.getAttribute("headerColor");
				if(!headerPadding.endsWith("px")) headerPadding = headerPadding + "px";
				if(!headerBackgroundColor.startsWith("#")) headerBackgroundColor = "#" + headerBackgroundColor;
				if(!headerColor.startsWith("#")) headerColor = "#" + headerColor;
				
				pageContext.setAttribute("headerPadding", headerPadding);
				pageContext.setAttribute("headerBackgroundColor", headerBackgroundColor);
				pageContext.setAttribute("headerColor", headerColor);
			%>	    
			#headerArea {
				background-color: <c:out value="${headerBackgroundColor}"/>;
			}					
			#headerArea .left a {
				display: block;
				padding: <c:out value="${headerPadding}"/>;
				color: <c:out value="${headerColor}"/>;
			}
		</style>
	
		
		<%-- TODO: Sätt via property --%>

		<c:if test="${not empty googleKey}">
			<script type="text/javascript">
			  var _gaq = _gaq || [];
			  _gaq.push(
			    ['_setAccount', '<c:out value="${googleKey}" escapeXml="false"/>'],
			    ['_trackPageview']
			  );
			  (function() {
			    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
			    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
			    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
			  })();
			</script>
		</c:if>

	</head>
	<body>
Date: <%=new Date() %><br/>
		<!-- <%=new Date() %> -->
		<%
			org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController templateLogic =(org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
			org.infoglue.cms.entities.structure.SiteNodeVO currentSiteNodeVO = templateLogic.getSiteNode(templateLogic.getSiteNodeId());
			int counter = 0;
			
			while(currentSiteNodeVO.getParentSiteNodeId() != null && counter < 25)
			{
				currentSiteNodeVO = templateLogic.getSiteNode(currentSiteNodeVO.getParentSiteNodeId());
				counter ++;
			}
			
			pageContext.setAttribute("repositoryStartPageId", currentSiteNodeVO.getSiteNodeId());
		%>
	
		<structure:pageUrl id="repositoryStartPageUrl" siteNodeId="${repositoryStartPageId}"/>
		<%-- Change scope of variable so that other components can access it as well --%>
		<c:set var="repositoryStartPageUrl" value="${repositoryStartPageUrl}" scope="request"/>
		
		<c:if test="${hasConfirmed}">
			<c:if test="${not empty pc.principal and pc.principal.name ne 'anonymous'}">
				<div id="pageheader-list-div">
					<div id="userPanelContainer">
						<ul class="pageheader-list">
							<li class="ph-separator">			
							</li>
							<li>
								<!-- Portalen -->
								<a href="<c:out value="${repositoryStartPageUrl}" />" class="ph-list-text" title="<structure:componentLabel mapKeyName="PortalLinkTitleText" />"><structure:componentLabel mapKeyName="PortalLabel" /></a>
							</li>
							<c:if test="${not empty phoneBookLink}"><%--
								<content:assetUrl />
								<%--<content:assetUrl assetKey="icon_phone_hover"/>
								<content:assetUrl assetKey="icon_phone_active"/>--%>
								<li class="ph-separator">			
								</li>
								<li>
									<!-- Telefon -->
									<a id="ph-phone-link" class="ph-picture-link" href="<c:out value="${phoneBookLink}" />" title="<structure:componentLabel mapKeyName="PhoneBookTitleText" />">
										<img src="<content:assetUrl assetKey="icon_phone" propertyName="ImageAssets"/>" alt="<structure:componentLabel mapKeyName="PhoneBookAltText" />" 
											onmouseover="this.src='<content:assetUrl assetKey="icon_phone_hover" propertyName="ImageAssets"/>'"
											onmouseout="this.src='<content:assetUrl assetKey="icon_phone" propertyName="ImageAssets"/>'"
											onmousedown="this.src='<content:assetUrl assetKey="icon_phone_active" propertyName="ImageAssets"/>'"
											onmouseup="this.src='<content:assetUrl assetKey="icon_phone" propertyName="ImageAssets"/>'"
											 />
									</a>
								</li>
							</c:if>
							<c:if test="${not empty webMailLink}">
								<li class="ph-separator">			
								</li>
								<li>
									<!-- Webmail -->
									<a id="ph-message-link" class="ph-picture-link" href="<c:out value="${webMailLink}" />" title="<structure:componentLabel mapKeyName="WebMailTitleText" />" >
									<img src="<content:assetUrl assetKey="icon_webmail" propertyName="ImageAssets"/>" alt="<structure:componentLabel mapKeyName="WebMailAltText" />" 
											onmouseover="this.src='<content:assetUrl assetKey="icon_webmail_hover" propertyName="ImageAssets"/>'"
											onmouseout="this.src='<content:assetUrl assetKey="icon_webmail" propertyName="ImageAssets"/>'"
											onmousedown="this.src='<content:assetUrl assetKey="icon_webmail" propertyName="ImageAssets"/>'"
											onmouseup="this.src='<content:assetUrl assetKey="icon_webmail" propertyName="ImageAssets"/>'"
											 />
									</a>
									</li>
							</c:if>
							<li class="ph-separator">			
							</li>
							<li style="<c:if test="${param.userAction eq 'displayLinks' or param.userAction eq 'editLinks' or param.userAction eq 'editBookmarks'}">background-color: white</c:if>">
								<!-- Bokmärken/länkar -->	
								
								<common:urlBuilder id="displayBookbarksUrl" baseURL="${currentUrl}" excludedQueryStringParameters="userAction">
									<c:if test="${param.userAction ne 'displayLinks'}">
										<common:parameter name="userAction" value="displayLinks"/>
									</c:if>
					            </common:urlBuilder>
								
								<a id="ph-bookmark-link" class="ph-picture-link ph-bookmark-panel" href="<c:out value="${displayBookbarksUrl}" />" title="<structure:componentLabel mapKeyName="BookmarksTitleText" />">
									<c:choose>
										<c:when test="${param.userAction eq 'displayLinks' or param.userAction eq 'editBookmarks' or param.userAction eq 'editLinks'}">
											<img id="bookmarkIcon" src="<content:assetUrl assetKey="icon_bookmark_hover" propertyName="ImageAssets"/>" alt="<structure:componentLabel mapKeyName="BookmarksAltText" />" 
												onmouseover="changeBookmarkIcon('mouseover');"
												onmouseout="changeBookmarkIcon('mouseout');"
												onmousedown="changeBookmarkIcon('mousedown');"
												onmouseup="changeBookmarkIcon('mouseup');"
											/>
										</c:when>
										<c:otherwise>
											<img id="bookmarkIcon" src="<content:assetUrl assetKey="icon_bookmark_selected" propertyName="ImageAssets"/>" alt="<structure:componentLabel mapKeyName="BookmarksAltText" />" 
												onmouseover="changeBookmarkIcon('mouseover');"
												onmouseout="changeBookmarkIcon('mouseout');"
												onmousedown="changeBookmarkIcon('mousedown');"
												onmouseup="changeBookmarkIcon('mouseup');"
											/>
										</c:otherwise>
									</c:choose>
								</a>
								<div id="bookmarks-container" style="<c:if test="${param.userAction eq 'displayLinks' or param.userAction eq 'editBookmarks' or param.userAction eq 'editLinks'}">display: block;</c:if>">
									<a id="ph-bookmark-close" href="<c:out value="${displayBookbarksUrl}" />" title="<structure:componentLabel mapKeyName="BookmarksCloseTitleText" />">
										<img src="<content:assetUrl assetKey="cross_close" propertyName="ImageAssets"/>" alt="<structure:componentLabel mapKeyName="BookmarksCloseAltText" />" 
											onmouseover="this.src='<content:assetUrl assetKey="cross_close_hover" propertyName="ImageAssets"/>'"
											onmouseout="this.src='<content:assetUrl assetKey="cross_close" propertyName="ImageAssets"/>'"
											onmousedown="this.src='<content:assetUrl assetKey="cross_close_active" propertyName="ImageAssets"/>'"
											onmouseup="this.src='<content:assetUrl assetKey="cross_close" propertyName="ImageAssets"/>'"
											 />
									</a>
									<div id="bookmarksDivider">
										<div id="ph-bookmarks">							
											<common:include relationAttributeName="RelatedComponents" contentName="Portal Bokmärkeslista" />
										</div>
										<div id="ph-links">	
											<common:include relationAttributeName="RelatedComponents" contentName="Portal Länkar" />
										</div>
									</div>
								</div>			
							</li>
							<c:if test="${not empty mySettingsUrl}">
								<li class="ph-separator">			
								</li>
								<li>
									<structure:siteNode id="currentPage" />
									<!-- Settings -->	
									<a id="ph-contact-link" class="ph-picture-link" href="<c:out value="${mySettingsUrl}" />" title="<structure:componentLabel mapKeyName="MySettingsTitleText" />">

									<c:choose>
										<c:when test="${currentPage.id eq mySettingsPage.id}">
											<img src="<content:assetUrl assetKey="icon_person_hover" propertyName="ImageAssets"/>" alt="<structure:componentLabel mapKeyName="MySettingsAltText" />" 
												onmouseover="this.src='<content:assetUrl assetKey="icon_person_hover" propertyName="ImageAssets"/>'"
												onmouseout="this.src='<content:assetUrl assetKey="icon_person_hover" propertyName="ImageAssets"/>'"
												onmousedown="this.src='<content:assetUrl assetKey="icon_person_active" propertyName="ImageAssets"/>'"
												onmouseup="this.src='<content:assetUrl assetKey="icon_person_hover" propertyName="ImageAssets"/>'"
											/>
										</c:when>
										<c:otherwise>
											<img src="<content:assetUrl assetKey="icon_person" propertyName="ImageAssets"/>" alt="" 
												onmouseover="this.src='<content:assetUrl assetKey="icon_person_hover" propertyName="ImageAssets"/>'"
												onmouseout="this.src='<content:assetUrl assetKey="icon_person" propertyName="ImageAssets"/>'"
												onmousedown="this.src='<content:assetUrl assetKey="icon_person_active" propertyName="ImageAssets"/>'"
												onmouseup="this.src='<content:assetUrl assetKey="icon_person" propertyName="ImageAssets"/>'"
											/>
										</c:otherwise>
									</c:choose>	
									
									</a>
								</li>
							</c:if>
							<li class="ph-separator">			
							</li>
							<li>
								<%-- Namn --%>			
								<p id="ph-text-name" class="ph-list-text" ><c:out value="${pc.principal.firstName} ${pc.principal.lastName}"/></p>
							</li>
							<li class="ph-separator">
							</li>
							<li>
								<%-- Logga ut --%>
								<a href="ExtranetLogin!logout.action?returnAddress=<c:out value="${repositoryStartPageUrl}"/>" class="ph-list-text" title="<structure:componentLabel mapKeyName="LogOutTitleText" />"><structure:componentLabel mapKeyName="LogoutLabel" /></a>
							</li>
							<li class="ph-separator">			
							</li>
						</ul>
					</div>
				</div>
			</c:if>
		</c:if>
		
		<script type="text/javascript">
		
		var bookmark_hover = "<content:assetUrl assetKey="icon_bookmark_hover" propertyName="ImageAssets"/>";
		var bookmark_selected = "<content:assetUrl assetKey="icon_bookmark_selected" propertyName="ImageAssets"/>";
		var bookmark_active = "<content:assetUrl assetKey="icon_bookmark_active" propertyName="ImageAssets"/>";
		var bookmarksPanelVisible = false;
		
		function changeBookmarkIcon(aEvent)
		{
			var imageToDisplay = "";
			if (bookmarksPanelVisible) //"#bookmarks-container").css("display") == "none"
			{
				if (aEvent == "mousedown")
				{
					imageToDisplay = bookmark_active;
				}
				else if (aEvent == "mouseup")
				{
					imageToDisplay = bookmark_selected;
					bookmarksPanelVisible = false;
				}
				else if (aEvent == "mouseover")
				{
					imageToDisplay = bookmark_hover;
				}
				else if (aEvent == "mouseout")
				{
					imageToDisplay = bookmark_hover;
				}
			}
			else
			{						
				if (aEvent == "mouseover")
				{
					imageToDisplay = bookmark_hover;
				}
				else if (aEvent == "mouseout")
				{
					imageToDisplay = bookmark_selected;
				}
				else if (aEvent == "mousedown")
				{
					imageToDisplay = bookmark_active;
				}
				else if (aEvent == "mouseup")
				{
					imageToDisplay = bookmark_hover;
					bookmarksPanelVisible = true;
				}
			}
			$("#bookmarkIcon").attr("src", imageToDisplay);
		}
		
		function hideOnOutsideClick(){
			$('html').click(function(event) {
				//event.preventDefault();
		        if ($(event.target).parents('#bookmarks-container').length == 0) {
					$('#bookmarks-container').slideUp(300);
					$('#ph-bookmark-link').parent().css('background-color', "");
					changeBookmarkIcon("mouseup");
		            $(this).unbind(event);
		        }		
			});
			$('#bookmarks-container').click(function(event){
				event.stopPropagation();
			});
		}
		<c:if test="${param.userAction eq 'displayLinks' or param.userAction eq 'editBookmarks' or param.userAction eq 'editLinks'}" >
			hideOnOutsideClick();
		</c:if>
		$(document).ready(function(){	
			$('#portalSaveButton').attr("disabled", "disabled");
			
			$('#ph-bookmark-link').click(function(event){
				event.preventDefault();
				event.stopPropagation();
				if ($('#bookmarks-container').css('display') == "none"){
					$('#ph-bookmark-link').parent().css('background-color', "white"); 
					$('#bookmarks-container').slideDown(300);
					hideOnOutsideClick();
				} else{
					$('#bookmarks-container').slideUp(300);
					$('#ph-bookmark-link').parent().css('background-color', "");
					$('html').unbind('click');
				}
			});	
			$('#ph-bookmark-close').click(function(event){
				event.preventDefault();
				if ($('#bookmarks-container').css('display') == "block"){
					$('#bookmarks-container').slideUp(300);
					$('#ph-bookmark-link').parent().css('background-color', ""); 
					changeBookmarkIcon("mouseup");
					$('html').unbind('click');
				} 
			});	
			
			$('#linkTitleText').focus(function(event){
				event.preventDefault();
				if($(this).val() == "<structure:componentLabel mapKeyName="NewLinkTitleLabel" />"){
					$(this).val("");
				}
			});	
			$('#linkText').focus(function(event){
				event.preventDefault();
				if($(this).val() == "<structure:componentLabel mapKeyName="NewLinkUrlLabel" />"){
					$(this).val("");
				}			
			});	
			$('#linkTitleText').blur(function(event){
				event.preventDefault();
				if($(this).val() == ""){
					$('#portalSaveButton').attr("disabled", "disabled");
					$(this).val("<structure:componentLabel mapKeyName="NewLinkTitleLabel" />");
				}
			});	
			$('#linkText').blur(function(event){
				event.preventDefault();
				if($(this).val() == ""){
					$('#portalSaveButton').attr("disabled", "disabled");
					$(this).val("<structure:componentLabel mapKeyName="NewLinkUrlLabel" />");
				}
			});	
			$('#linkTitleText').keyup(function(event){
				event.preventDefault();
				if($(this).val() != ""){
					$('#portalSaveButton').removeAttr("disabled");
				}
			});	
			$('#linkText').keyup(function(event){
				event.preventDefault();
				if($(this).val() != ""){
					$('#portalSaveButton').removeAttr("disabled");
				}
			});	
			
		});
		</script>
	
		<%-- TODO: label-it! --%>
		
		<a href="<c:out value="${repositoryStartPageUrl}"/>" accesskey="1" style="display: none;">Till startsida</a>
			
		<!--eri-no-index-->
	
		<%-- TODO: print-logo i CSS --%>
		
		<div id="siteWidth">
			<div id="home">
				<a name="top"></a>
				<ul class="linklist">
					<li class="first last"><a href="#content" accesskey="s" tabindex="100" title="<structure:componentLabel mapKeyName="jumpToTextTitle"/>"><structure:componentLabel mapKeyName="jumpToTextLabel"/></a></li>
				</ul>
			</div>
					
			<div class="shadow-a">
				<div class="shadow-b">
					<div class="shadow-c">
					
						<%-- TODO: Spara inställningar i userProperties? --%>
						<div id="pageContainer">
							<c:if test="${param.adjust == 'true' || param.saveAdjust == 'true'}">
								<common:include relationAttributeName="RelatedComponents" contentName="GU Anpassa 2.0"/>
							</c:if>
		
							<div id="headerArea">	
								<common:include relationAttributeName="RelatedComponents" contentName="Portal Sidhuvud"/>
							</div>
							
							<c:if test="${hasConfirmed}" >
								<div id="darkRow">
									<common:include relationAttributeName="RelatedComponents" contentName="Portal Toppnavigering"/>
								</div>
							</c:if>
							
							<!-- The Content starts here -->
							<div id="bodyArea">
								<c:if  test="${empty eulaList}">
									<c:if test="${pc.isDecorated}">
										<%-- TODO: Re-add when EULA works 
										<p class="adminError"><structure:componentLabel mapKeyName="MissingEULAList" /></p>
										 --%>
									</c:if>
									
								</c:if>
								<c:choose>
									<c:when test="${!hasConfirmed}">
										<common:include relationAttributeName="RelatedComponents" contentName="Portal Ansvarsförbindelse"/>
									</c:when>
									<c:otherwise>
										<common:include relationAttributeName="RelatedComponents" contentName="Portal Crumbtrail"/>
										<!--/eri-no-index-->
										<ig:slot id="bodyarea" allowedNumberOfComponents="2" allowedComponentGroupNames="PortalLayout"></ig:slot>		
										<!--eri-no-index-->
									</c:otherwise>
								</c:choose>
								<div class="clr"></div>
							</div>				
						</div>		
					</div>
				</div>
			</div>
			
			<c:if test="${hasConfirmed}">
				<!-- Footer -->
				<%-- TODO: make labels --%>
				<structure:componentLabel id="organisationName" mapKeyName="OrganisationName" />
				<structure:componentLabel id="organisationNameClean" mapKeyName="OrganisationNameClean" />
				<structure:componentLabel id="phoneLabel" mapKeyName="PhoneLabel" />
				<structure:componentLabel id="phone" mapKeyName="Phone" />
				<structure:componentLabel id="boxNumber" mapKeyName="BoxNumber" />
				<structure:componentLabel id="zipCode" mapKeyName="ZipCode" />
				<structure:componentLabel id="city" mapKeyName="City" />
				<structure:componentLabel id="mapLabel" mapKeyName="MapLabel" />
				<structure:componentLabel id="mapTitle" mapKeyName="MapTitle" />
				<%--
				<content:contentAttribute id="organisationName" propertyName="siteLabels" attributeName="OrganisationName"/>
				<content:contentAttribute id="organisationNameClean" propertyName="siteLabels" attributeName="OrganisationName" disableEditOnSight="true"/>
				<content:contentAttribute id="phoneLabel" propertyName="siteLabels" attributeName="PhoneLabel"/>
				<content:contentAttribute id="phone" propertyName="siteLabels" attributeName="Phone" disableEditOnSight="true"/>
				<content:contentAttribute id="boxNumber" propertyName="siteLabels" attributeName="boxNumber"/>
				<content:contentAttribute id="zipCode" propertyName="siteLabels" attributeName="zipCode"/>
				<content:contentAttribute id="city" propertyName="siteLabels" attributeName="city"/>
				<content:contentAttribute id="mapLabel" propertyName="siteLabels" attributeName="MapLabel"/>
				<content:contentAttribute id="mapTitle" propertyName="siteLabels" attributeName="MapTitle" disableEditOnSight="true"/>--%>
			
				
				<structure:boundPages id="footerLinks" propertyName="footerLinks"/>
								
				<%-- TODO: ska det vara sidfot? --%>
				<div id="footerArea">
					<p class="left">© <a href="<c:out value="${startPage.url}"/>" title="<c:out value="${homeTitle}"/>"><c:out value="${organisationName}" escapeXml="false"/></a>, <c:out value="${boxNumber}" escapeXml="false"/>, <c:out value="${zipCode}" escapeXml="false"/> <c:out value="${city}" escapeXml="false"/>
					<br /><c:out value="${phoneLabel}" escapeXml="false"/> <c:out value="${phone}" escapeXml="false"/></p>
					
					<p class="right">
						<common:size id="numberOfLinks" list="${footerLinks}" />
						<c:forEach var="footerLink" items="${footerLinks}" varStatus="data">
							<content:contentAttribute id="footerLinkTitle" contentId="${footerLink.metaInfoContentId}" attributeName="Description"/>
							<a class="footerLink" href="<c:out value="${footerLink.url}"/>" title="<c:out value="${footerLinkTitle}"/>">
								<c:out value="${footerLink.navigationTitle}"/></a>
							<c:if test="${data.count < numberOfLinks}" >
								&nbsp;|&nbsp; 
							</c:if>		
						</c:forEach>
					</p>
					<div class="clr"></div>
				</div>
			</c:if>
		</div>
		<div id="dialogComp" style="position: absolute; display: none; top: 300px; right: 300px;">
			<a tabindex="6" href="javascript:void(0);" onclick="hideFormDialogInline();" class="close" title="stäng"></a>
		<div id="dialogCompWrapperDiv" class="dialogTip">
			<div id="dialogDiv" align="top" frameborder="0" width="410" height="200"></div>
				<iframe id="dialogIFrame" frameborder="0" width="410" height="200" scrolling="auto" src="">
					Your browser does not support inline frames or is currently configured not to display inline frames.
				</iframe>
			</div>
		</div>
		<%-- TODO: Hantera print bättre --%>
		<!--Printerfoot, Only visible when printing -->
		<jsp:useBean id="now" class="java.util.Date" />
		<common:urlBuilder id="currentFullUrl" fullBaseUrl="true" excludedQueryStringParameters="print"/>
		
		
		<div class="printfoot">
			<p>
				<structure:componentLabel mapKeyName="ThisPageIsPrintedFrom" />
				<br />
				<c:out value="${currentFullUrl}" escapeXml="false"/>
				<br />
				<structure:componentLabel mapKeyName="PrintDate" />
				<common:formatter value="${now}" pattern="yyyy-MM-dd"/>
<%--
ThisPageIsPrintedFrom_sv=Denna text är utskriven från följande webbsida:
ThisPageIsPrintedFrom_en=This page is printed from the following webpage:
PrintDate_sv=Utskriftsdatum:
PrintDate_en=Print date:
 --%>
			</p>
		</div>
		
		<!--/eri-no-index-->
		
		<c:set var="serverName"><%=pageContext.getRequest().getServerName()%></c:set>
		
		<%-- TODO: uppläsning? --%>
		<structure:componentLabel id="listenLangCode" mapKeyName="listenLangCode"/>
		<form name="insipioRefererForm" method="post" action="http://spoxy4.insipio.com/generator/<c:out value="${listenLangCode}"/>/<c:out value="${serverName}" escapeXml="false"/>">
			<input type="hidden" name="referer" value=""/>
		</form>
	</body>
</html>