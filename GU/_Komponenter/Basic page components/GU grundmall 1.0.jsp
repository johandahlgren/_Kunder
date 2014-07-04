<%@page import="javax.imageio.IIOException"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>

<page:pageContext id="pc"/>
<page:deliveryContext id="deliveryContext"/>

<c:set var="serverName" value="${pageContext.request.serverName}" />

<structure:boundPage id="redirectPage" propertyName="RedirectPage" useInheritance="false"/>
<c:if test="${not empty redirectPage && !pc.isInPageComponentMode}">
	<page:deliveryContext id="deliveryContext" disablePageCache="true"/>
	<common:sendRedirect url="${redirectPage.url}"/>
</c:if>

<c:if test="${pc.principal.name == 'eventPublisher'}">
	<c:set var="mySession" value="${pc.httpServletRequest.session}"/>
	<%
		javax.servlet.http.HttpSession mySession = (javax.servlet.http.HttpSession)pageContext.getAttribute("mySession");
		mySession.invalidate();
	%>
	<common:urlBuilder id="currentUrl"/>
	<common:sendRedirect url="${currentUrl}"/>
</c:if>

<c:if test="${param.userAction eq 'logout'}">
	<c:set var="mySession" value="${pc.httpServletRequest.session}"/>
	<%
		javax.servlet.http.HttpSession mySession = (javax.servlet.http.HttpSession)pageContext.getAttribute("mySession");
		mySession.invalidate();
	%>
	
	<common:urlBuilder id="currentUrl" excludedQueryStringParameters="userAction"/>
	<common:sendRedirect url="http://www.gu.se"/>
</c:if>

<common:urlBuilder id="currentUrl" fullBaseUrl="true"/>
<common:URLEncode id="curAddress" value="${currentUrl}"/>

<structure:boundPage id="universityStartPage" propertyName="UniversityStartPage"/>
<structure:boundPage id="startPage" propertyName="StartPage"/>

<content:contentAttribute id="organisationName" propertyName="siteLabels" attributeName="OrganisationName" disableEditOnSight="true"/>
<c:choose> 
   	<c:when test="${pc.contentId > -1}"> 	   	
		<content:content id="articleContent"/>
   	</c:when> 
	<c:otherwise>
		<content:content id="articleContent" propertyName="Article" useInheritance="true"/>
	</c:otherwise>
</c:choose> 

<content:contentAttribute id="keywords" contentId="${pc.metaInformationContentId}" attributeName="MetaInfo" disableEditOnSight="true"/>
<content:contentAttribute id="keywordsArticle" contentId="${articleContent.contentId}" attributeName="MetaKeywords" disableEditOnSight="true"/>
<content:contentAttribute id="description" contentId="${pc.metaInformationContentId}" attributeName="Description" disableEditOnSight="true"/>
<content:contentAttribute id="articleTitle" contentId="${articleContent.contentId}" attributeName="Title" disableEditOnSight="true"/>
<content:contentAttribute id="articleSkribent" contentId="${articleContent.contentId}" attributeName="SkribentNamn" disableEditOnSight="true"/>
<content:contentAttribute id="articleSkribentEmail" contentId="${articleContent.contentId}" attributeName="SkribentEpost" disableEditOnSight="true"/>


<c:if test="${not empty articleContent}">
	<content:contentVersion id="articleContentVersion" content="${articleContent}"/>
	<c:if test='${articleContentVersion != null}'>
		<management:principal id="articleCreator" contentVersion="${articleContentVersion}"/>
	</c:if>
</c:if>


<%@ page contentType="text/html; charset=UTF-8" %>

<c:if test="${not empty pc.principal && pc.principal ne 'anonymous' && pc.isInPageComponentMode}">
	<c:set var="currentPageId" value="${pc.siteNodeId}"/>
	<management:principalProperty id="myHomePage" attributeName="MyHomePage"/>
	<management:principalProperty id="showMyHomepage" attributeName="showMyHomepage"/>
	
	<%
		String myHomePageXML 	= (String)pageContext.getAttribute("myHomePage");

		int index1				= myHomePageXML.indexOf("&lt;id&gt;");
		if (index1 > -1)
		{
			String myHomePageIdString 	= myHomePageXML.substring(index1 + 10);
			int index2					= myHomePageIdString.indexOf("&lt;");
			if (index2 > -1)
			{
				myHomePageIdString		= myHomePageIdString.substring(0, index2);
				Long myHomePageId		= new Long(myHomePageIdString);
				pageContext.setAttribute("myHomePageId", myHomePageId);
			}
		}
	%>
	<c:set var="myHomePageId" value="${myHomePageId}" scope="session"/>
	<c:if test="${not empty myHomePageId && currentPageId ne myHomePageId}">
		<c:if test="${not hasRedirected}">
			<structure:pageUrl id="myPageUrl" siteNodeId="${myHomePageId}"/>
			<c:set var="hasRedirected" value="${true}" scope="session"/>
			<common:sendRedirect url="${myPageUrl}"/>
		</c:if>
	</c:if>
</c:if>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
       "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">


<%@page import="java.text.StringCharacterIterator"%>
<%@page import="java.text.CharacterIterator"%><html xmlns="http://www.w3.org/1999/xhtml" xml:lang="<c:out value="${pc.locale}"/>" lang="<c:out value="${pc.locale}"/>">
<head>

	<meta http-equiv="content-type" content="text/html; charset=utf-8" />
	<meta http-equiv="content-language" content="<c:out value="${pc.locale}"/>"/>
	<meta name="language" content="<c:out value="${pc.locale}"/>" />
	<meta name="generator" content="InfoGlue"/>
	
	<structure:componentPropertyValue id="googleMetaVerifyCode" propertyName="GoogleMetaVerifyCode" useInheritance="false"/>
	
	<c:if test="${googleMetaVerifyCode ne '' and not empty googleMetaVerifyCode}">
		<meta name="google-site-verification" content="<c:out value="${googleMetaVerifyCode}" escapeXml="false"/>"/>
	</c:if>

	<c:choose>
	  <c:when test="${param.feedbackForm == 'true' || param.tipFriend == 'true' || param.siteMap == 'true' || param.adjust == 'true' || param.print == 'true'  || !empty param.commentAction || !empty param.siteSearch}">
	  	<meta name="robots" content="noindex,nofollow"/>
	  	<page:deliveryContext id="deliveryContext" disablePageCache="true"/>
	  </c:when>
	  <c:otherwise>
	  	<meta name="robots" content="index,follow"/>
	  </c:otherwise>
	</c:choose>

	<meta name="description" content="<c:out value="${description}"/>"/>
	<meta name="keywords" content="<c:out value="${keywords}" />"/>
	<c:if test='${articleSkribent != null && articleSkribent != "" }'><meta name="author" content="<c:out value="${articleSkribent}"/>"/></c:if>
	<meta name="LAST-MODIFIED" content="<fmt:formatDate value='${articleContentVersion.modifiedDateTime}' pattern='yyyy-MM-dd'/>"/>
	<meta name="copyright" content="Copyright University of Gothenburg 2008"/>
	
	<meta name="DC.Title" content="<c:out value="${pc.pageTitle}"/>"/>
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#title"/>
	
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#creator"/>
	<meta name="DC.Subject" content="<c:out value="${keywords}"/>"/>
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#subject"/>

	<meta name="DC.Subject" content="<c:out value="${keywordsArticle}"/>"/>
	<meta name="DC.Subject" content="<c:out value="${articleTitle}"/>"/>
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#subject"/>

	<meta name="DC.Description" content="<c:out value="${description}"/>"/>
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#description"/>

	<c:if test='${articleSkribent != null && articleSkribent != "" }'>
	<meta name="DC.Creator.PersonalName" content="<c:out value='${articleSkribent}'/>"/>
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#creator"/>
	</c:if>

	<meta name="DC.Type" content="Text.Article"/>
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#type"/>

	<meta name="DC.Date" content="(SCHEME=ISO8601) <fmt:formatDate value='${articleContent.publishDateTime}' pattern='yyyy-MM-dd'/>"/>
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#date"/>

	<meta name="DC.Format" content="(SCHEME=IMT) text/html"/>
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#format"/>

	<meta name="DC.Date.X-MetadataLastModified" content="(SCHEME=ISO8601) <fmt:formatDate value='${articleContentVersion.modifiedDateTime}' pattern='yyyy-MM-dd'/>"/>
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#date"/>

	<meta name="DC.Language" content="(SCHEME=ISO639-1) <c:out value="${pc.locale}"/>"/>
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#language"/>

	<meta name="DC.Publisher" content="<c:out value="${articleCreator.firstName}"/> <c:out value="${articleCreator.lastName}"/>"/>
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#publisher"/>


	<meta name="DC.Identifier" content="<c:out value="${pc.currentPageUrl}"/>"/>
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#identifier"/>

	<meta name="DC.Rights" content="Copyright University of Gothenburg 2011"/>
	<link rel="schema.DC" href="http://purl.org/metadata/dublin_core_elements#rights"/>
        <!--currntSiteNodeId=<c:out value="${deliveryContext.siteNodeId}"/>-->
	
    <ig:slot id="HTMLHead" disableSlotDecoration="true"></ig:slot>
	
        <link rel="shortcut icon" href="<content:assetUrl propertyName="Mallbilder" assetKey="favicon"/>"/>
        <link rel="icon" type="image/png" size="144x144" href="<content:assetUrl propertyName="Mallbilder" assetKey="icon-144x144"/>" />
        <link rel="icon" type="image/png" size="16x16" href="<content:assetUrl propertyName="Mallbilder" assetKey="icon-16x16"/>" />

        <link rel="apple-touch-icon-precomposed" href="<content:assetUrl propertyName="Mallbilder" assetKey="icon-144x144"/>" />
        <link rel="apple-touch-icon-precomposed" sizes="144x144" href="<content:assetUrl propertyName="Mallbilder" assetKey="icon-144x144"/>" />
        <link rel="apple-touch-icon-precomposed" sizes="114x114" href="<content:assetUrl propertyName="Mallbilder" assetKey="icon-114x114"/>" />
        <link rel="apple-touch-icon-precomposed" sizes="72x72" href="<content:assetUrl propertyName="Mallbilder" assetKey="icon-72x72"/>" />



	<!--<structure:siteNode id="siteRssNode" propertyName="rssNode" targetSiteNodeId="${deliveryContext.siteNodeId}" useInheritance="false"/>
	<c:if test="${siteRssNode!='' && siteRssNode !=null}">
	
		<structure:componentPropertyValue id="rssTempTitle" propertyName="FeedTitle" siteNodeId="${siteRssNode.siteNodeId}"/>

		<c:set var="rssTitle" value="GU Faculty News Listing"/>
		<c:if test="${rssTempTitle != null}">
		 <c:set var="rssTitle" value="${rssTempTitle}"/>
		</c:if>
		
		<page:deliveryContext id="deliveryContext" disableNiceUri="true"/>
		<structure:pageUrl id="rssUrl" siteNodeId="${siteRssNode.id}"/>
		<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>
		
		<link rel="alternate" type="application/rss+xml" title="<c:out value="${rssTitle}"/>" href="<c:out value="${rssUrl}"/>&amp;fromsitenodeid=<c:out value="${deliveryContext.siteNodeId}"/>"/>
	</c:if> -->

	<c:choose>
       	<c:when test="${param.programid != null && param.programid ne ''}">
       
       	</c:when>
       	<c:when test="${param.courseId != null && param.courseId ne ''}">
       
        </c:when>
       	<c:when test="${param.subjectParam != null && param.subjectParam ne ''}">
       
       	</c:when>
       	<c:otherwise>
       	
			<title>
                <c:choose>
					<c:when test="${param.siteMap == 'true'}">
						<structure:boundPage id="mbasepage" propertyName="MenuBasePage" useRepositoryInheritance="false"/>
                    	<structure:componentLabel mapKeyName="siteMapLabel"/> <c:choose><c:when test="${not empty mbasepage && not empty mbasepage.navigationTitle}"> - <c:out value="${mbasepage.navigationTitle}"/>,</c:when><c:otherwise>-</c:otherwise></c:choose> <c:out value="${organisationName}"/> <c:out value="${organisationsNamn}"/>
					</c:when>
					<c:when test="${param.siteSearch == 'true'}">
			        	<structure:componentLabel mapKeyName="searchLabel"/> - <c:out value="${organisationName}"/> <c:out value="${organisationsNamn}"/>
					</c:when>
					<c:otherwise>
						<page:pageAttribute id="pageTitlePrefix" name="pageTitlePrefix" />
						<c:if test="${pc.contentId > -1}"> 
							<content:contentAttribute id="contentTitle" contentId="${pc.contentId}" attributeName="Title"/>
							<c:set var="pageTitlePrefix" value="${contentTitle}"/>
						</c:if>
					
						<c:choose>
							<c:when test="${not empty pageTitlePrefix}">
								<c:out value="${pageTitlePrefix}" escapeXml="false" /> - <c:out value="${organisationName}"/> <c:out value="${organisationsNamn}"/>
							</c:when>
							<c:otherwise>
								<structure:boundPage id="mbasepage" propertyName="MenuBasePage" useRepositoryInheritance="false"/>
								<c:out value="${pc.pageTitle}"/> <c:choose><c:when test="${not empty mbasepage && not empty mbasepage.navigationTitle}"> - <c:out value="${mbasepage.navigationTitle}"/>,</c:when><c:otherwise>-</c:otherwise></c:choose> <c:out value="${organisationName}"/> <c:out value="${organisationsNamn}"/>
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
				  
			</title>

		</c:otherwise>
	</c:choose>

	<page:deliveryContext id="deliveryContext" disableNiceUri="true"/>

	<c:choose>
		<c:when test="${param.print=='true'}">
	        <structure:boundPage id="printCss" propertyName="printCSS"/>
   	    	<link rel="stylesheet" media="screen, print" href="<c:out value='${printCss.url}'/>" type="text/css" />
	  	</c:when>
	 	<c:otherwise>      	
			
			<structure:componentPropertyValue id="headerType" propertyName="HeaderType"/>
			<c:if test="${empty headerType || headerType == 'false'}"><c:set var="headerType" value="standardGU"/></c:if>
			
			<c:set var="serverName"><%=pageContext.getRequest().getServerName() %></c:set>

			<structure:boundPages id="cssPages" propertyName="CSS pages"/>
			<c:forEach var="cssPage" items="${cssPages}"> 
				<structure:siteNode id="cssNode" siteNodeId="${cssPage.siteNodeId}"/>
				<!--  <c:out value="${headerType}"/> <c:out value="${cssNode.name}"/> -->
				<c:if test="${(headerType == 'standardGU' && cssNode.name != 'GU_HeaderLevel3CSSVer2') || (headerType == 'level3page' && cssNode.name != 'GU_HeaderCSSVer2')}">
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

					<c:choose>
						<c:when test="${serverName == 'dev.cms.it.gu.se' || serverName == 'cms.it.gu.se'}">
				      		<style type="text/css" media="screen, print">@import url(<c:out value="${cssUrl}"/>);</style>
						</c:when>
						<c:otherwise>
				      		<style type="text/css" media="screen, print">@import url(http://www.gu.se<c:out value="${cssUrl}"/>);</style>
						</c:otherwise>
					</c:choose>

				</c:if>	      		
			</c:forEach>

      	</c:otherwise>
	</c:choose>

	<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>

	<c:if test="${!pc.isInPageComponentMode}">
		<script type="text/javascript" src="<c:out value="${pageContext.request.contextPath}"/>/script/jquery/jquery-1.2.6.min.js"></script>
		<script type="text/javascript" src="<c:out value="${pageContext.request.contextPath}"/>/script/jqueryplugins/ui/jquery-ui-dragDropTabs-1.6rc2.min.js"></script>
	</c:if>
	
  	<script type="text/javascript">
  	<!-- 
  	var isRunningIE6OrBelow = false; 
  	-->
  	</script>
	<!--[if lt IE 7]>
	<script defer type="text/javascript" src="<c:out value="${pageContext.request.contextPath}"/>/script/pngfix.js"></script>
	<script defer type="text/javascript">try { document.execCommand('BackgroundImageCache', false, true); } catch(e) {}</script>
	<script type="text/javascript">
  		var isRunningIE6OrBelow = true;
	</script>
	<![endif]-->
	
	<page:deliveryContext id="deliveryContext" disableNiceUri="true"/>
	<structure:boundPage id="scriptPage" propertyName="JavascriptPage"/>
	<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>
   	<script type="text/javascript" src="<c:out value='${scriptPage.url}'/>"></script>
	<script type="text/javascript" src="<c:out value="${pageContext.request.contextPath}"/>/script/jqueryplugins/swfobject/swfobject.js"></script>
	
	<style type="text/css">
	    #profilComp #linkCollection ul.collapsablemenu {
			display: block;
	        position: relative;
	    }
	    
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
		<c:if test="${headerType == 'level3page'}">
		#headerArea {
			background-color: <c:out value="${headerBackgroundColor}"/>;
		}					
		#headerArea .left a {
			display: block;
			padding: <c:out value="${headerPadding}"/>;
			color: <c:out value="${headerColor}"/>;
		}					
		</c:if>
	</style>
	
	<script type="text/javascript">
	<!--
			document.write('<style type="text/css">#profilComp #linkCollection ul.collapsablemenu { display: none; position: absolute; }</style>');
	-->
	</script>
	
	<c:if test="${serverName ne 'dev.cms.it.gu.se'}">
		<script type="text/javascript">
		  var _gaq = _gaq || [];
		  _gaq.push(
		    ['_setAccount', 'UA-826108-1'],
		    ['_trackPageview']
		  );
		  <structure:componentPropertyValue id="googleKey" propertyName="GoogleKey"/>
		  <c:if test="${googleKey != null && googleKey != '' && googleKey != 'UA-826108-1'}">
		    _gaq.push(
		      ['b._setAccount', '<c:out value="${googleKey}" escapeXml="false"/>'],
		      ['b._trackPageview']
		    );
		  </c:if>
		  (function() {
		    var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
		    ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
		    var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
		  })();
		</script>
	</c:if>
</head>
<body>
<script type="text/javascript">
<!--
$(document).ready(function() 
{
	$(document).click(function () { 
		$("#drop1").slideUp("fast");
		$("#drop2").slideUp("fast");
		$("#drop3").slideUp("fast");
	   	$("#select1").css("visibility", "visible");
		$("#select2").css("visibility", "visible");
		$("#select3").css("visibility", "visible");
    });
});
-->
</script>

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

<a href="<c:out value="${repositoryStartPageUrl}"/>" accesskey="1" style="display: none;">Till startsida</a>
		
<!--eri-no-index-->

<c:if test="${param.print == 'true'}">
	<structure:boundPage id="leftLogoPage" propertyName="LeftLogoPage" useRepositoryInheritance="false"/>
	<structure:boundPage id="rightLogoPage" propertyName="RightLogoPage" useRepositoryInheritance="false"/>
	
	<c:if test="${empty leftLogoPage}">
		<structure:boundPage id="leftLogoPage" propertyName="StartPage"/>
	</c:if>

	<structure:componentPropertyValue id="headerType" propertyName="HeaderType"/>
	<c:if test="${empty headerType || headerType == 'false'}"><c:set var="headerType" value="standardGU"/></c:if>
		
	<!--Printer Head, Only visible when printing-->
	<div id="printhead">
		<%--<c:choose>
			<c:when test="${headerType == 'level3page'}">
				<c:set var="serverName"><%=pageContext.getRequest().getServerName()%></c:set>
				<c:choose>
					<c:when test="${serverName == 'dev.cms.it.gu.se'}">
						<content:assetUrl id="printAssetUrl" contentId="149109" assetKey="print" />
					</c:when>
					<c:otherwise>
						<content:assetUrl id="printAssetUrl" contentId="882411" assetKey="print" />
					</c:otherwise>
				</c:choose>
			</c:when>
			<c:otherwise>--%>
				<content:assetUrl id="printAssetUrl" propertyName="LeftLogotype" assetKey="print"/>
				<content:assetUrl id="printDividerAssetUrl" assetKey="logoDivider"/>
				<content:assetUrl id="printRightAssetUrl" propertyName="RightLogotype" assetKey="print"/>
			<%--</c:otherwise>
		</c:choose>--%>
		<%
		String printAssetUrl = (String)pageContext.getAttribute("printAssetUrl");
		String widthString = "";
		if(printAssetUrl != null && !printAssetUrl.equals(""))
		{
			try 
			{
				String filePath = org.infoglue.cms.util.CmsPropertyHandler.getDigitalAssetPath0();
				String printAssetFilePart = printAssetUrl.substring(printAssetUrl.indexOf("digitalAssets") + 13);
				java.awt.Image image = javax.imageio.ImageIO.read(new java.io.File(filePath + printAssetFilePart));
				widthString = "style=\"width:" + (image.getWidth(null) / 2) + "px;\"";
			}
			catch (Exception ex)
			{
				// Prevents output in the logs
			}
		}
		String printRightAssetUrl = (String)pageContext.getAttribute("printRightAssetUrl");
		String widthStringRight = "";
		if(printRightAssetUrl != null && !printRightAssetUrl.equals(""))
		{
			try 
			{
				String filePath = org.infoglue.cms.util.CmsPropertyHandler.getDigitalAssetPath0();
				String printRightAssetFilePart = printRightAssetUrl.substring(printAssetUrl.indexOf("digitalAssets") + 13);
				java.awt.Image image = javax.imageio.ImageIO.read(new java.io.File(filePath + printRightAssetFilePart));
				widthStringRight = "style=\"width:" + (image.getWidth(null) / 2) + "px;\"";
			}
			catch (Exception ex)
			{
				// Prevents output in the logs
			}
		}
		%>
		<a href="<c:out value="${leftLogoPage.url}"/>" accesskey="1" title="<structure:componentLabel mapKeyName="startPageLinkTitle"/> <c:out value="${leftLogoPage.navigationTitle}"/>">
			<img <%= widthString %> src="<c:out value="${printAssetUrl}"/>" alt="<c:out value="${leftLogoPage.navigationTitle}"/>"/>
		</a>
		<content:assetUrl id="logoDivider" assetKey="logoDivider"/>
		<c:if test="${not empty logoDivider}">
			<img src="<c:out value="${logoDivider}" />" alt="divider"/>
		</c:if>
		<c:if test="${not empty rightLogoPage}">
			<a href="<c:out value="${rightLogoPage.url}"/>" accesskey="1" title="<structure:componentLabel mapKeyName="startPageLinkTitle"/> <c:out value="${rightLogoPage.navigationTitle}"/>">
				<img <%= widthString %> src="<c:out value="${printRightAssetUrl}"/>" alt="<c:out value="${rightLogoPage.navigationTitle}"/>"/>
			</a>
		</c:if>
<%--
		<img src="<content:assetUrl assetKey="logoDivider"/>" alt="divider"/>
		<a href="<c:out value="${rightLogoPage.url}"/>" accesskey="1" title="<structure:componentLabel mapKeyName="startPageLinkTitle"/> <c:out value="${rightLogoPage.navigationTitle}"/>">
			<img <%= widthString %> src="<c:out value="${printRightAssetUrl}"/>" alt="<c:out value="${rightLogoPage.navigationTitle}"/>"/>
		</a>--%>
	</div>
</c:if>

<noscript>
	<content:contentAttribute propertyName="siteLabels" attributeName="NoScriptText"/>
</noscript>

<content:contentAttribute id="jumpToTextTitle" propertyName="siteLabels" attributeName="JumpToTextTitle" disableEditOnSight="true"/>

<c:if test="${not empty pc.principal && pc.principal ne 'anonymous' && pc.isInPageComponentMode && showMyHomepage != 'false'}">
	<c:if test="${not empty myHomePageId}">
		<div id="logoutDiv">
			<common:urlBuilder id="logoutUrl">
				<common:parameter name="userAction" value="logout"/>
			</common:urlBuilder>
			
			<structure:pageUrl id="myPageUrl" siteNodeId="${myHomePageId}"/>
			<a href="<c:out value="${myPageUrl}" escapeXml="false"/>"><structure:componentLabel mapKeyName="myPage"/></a> | 
			<a href="<c:out value="${logoutUrl}" escapeXml="false"/>"><structure:componentLabel mapKeyName="logOut"/></a>
		</div>
	</c:if>
</c:if>

<div id="siteWidth">
	<div id="home">
		<a name="top"></a>
		
		<ul class="linklist">
			<li class="first"><a href="#content" accesskey="s" tabindex="100" title="<c:out value="${jumpToTextTitle}"/>"><structure:componentLabel mapKeyName="jumpToTextLabel"/></a></li>
			
			<c:choose>
				<c:when test="${headerType == 'level3page'}">
					<!-- Kopia av Anpassagrejer -->
					<common:urlBuilder id="customizePage" excludedQueryStringParameters="adjust,returnAddress,saveAdjust" fullBaseUrl="true">
						<common:parameter name="adjust" value="true"/>
						<common:parameter name="refresh" value="true"/>
					</common:urlBuilder>
					
					<common:URLEncode id="customizePage" value="${customizePage}"/>
					
					
					<c:choose>
						<c:when test="${serverName == 'dev.cms.it.gu.se' || serverName == 'cms.it.gu.se'}">
							<common:urlBuilder id="postUrl" baseURL="/infoglueDeliverWorking/jsp/retrieveAdjust.jsp">
								<common:parameter name="returnAddress" value="${customizePage}"/>
							</common:urlBuilder>
						</c:when>
						<c:otherwise>
							<common:urlBuilder id="postUrl" baseURL="http://www.gu.se/jsp/retrieveAdjust.jsp">
								<common:parameter name="returnAddress" value="${customizePage}"/>
							</common:urlBuilder>
						</c:otherwise>
					</c:choose>
					<!-- / Slut Kopia av Anpassagrejer -->
									
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
					boolean usesNiceURI = false;
					if (alternateLanguageStartPageTestUrl != null)
					{
						usesNiceURI = (alternateLanguageStartPageTestUrl.indexOf("ViewPage") > -1 ? false : true);
					}
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
										
					<li><a href="<c:out value="${postUrl}"/>" accesskey="8" title="<structure:componentLabel mapKeyName="adjustLinkTitle"/>" rel="nofollow"><structure:componentLabel mapKeyName="adjustLinkLabel"/></a> </li>				
					<c:choose>
						<c:when test="${not empty alternateLanguageStartPage && alternateLanguageStartPage != 'Undefined' && hasAlternativeContentVersion}">
							<li><a href="#" onclick="insipio_setReferer()" title="<structure:componentLabel mapKeyName="listenTitle"/>"><structure:componentLabel mapKeyName="listenLabel"/></a></li>
							<li class="last"><a href="<c:out value="${alternateLanguageStartPageUrl}"/>" class="whitelink1" title="<c:out value="${alternativeLanguageStartPageTitle}"/>"><structure:componentLabel mapKeyName="languageChangePrefix"/> <c:out value="${alternativeLanguage.localizedDisplayLanguage}"/></a></li>
						</c:when>
						<c:otherwise>
							<li class="last"><a href="#" onclick="insipio_setReferer()" title="<structure:componentLabel mapKeyName="listenTitle"/>"><structure:componentLabel mapKeyName="listenLabel"/></a></li>
						</c:otherwise>
					</c:choose>	
				</c:when>
				<c:otherwise>
					<structure:componentPropertyValue id="hideUniversityStartPage" propertyName="HideUniversityStartPage"/>
					<c:if test="${hideUniversityStartPage != 'true'}">
						<li><a href="<c:out value="${universityStartPage.url}"/>" title="<structure:componentLabel mapKeyName="startPageTitle"/>"><structure:componentLabel mapKeyName="startPageLabel"/></a></li>
					</c:if>
				</c:otherwise>
			</c:choose>
		</ul>
		
	</div>
			
	<div class="shadow-a">
		<div class="shadow-b">
			<div class="shadow-c">
			
				<div id="pageContainer">
					<c:if test="${param.adjust == 'true' || param.saveAdjust == 'true'}">
						<common:include relationAttributeName="RelatedComponents" contentName="GU Anpassa 2.0"/>
					</c:if>
					
					<structure:componentPropertyValue id="level3PageAlternativeClass" propertyName="Level3PageAlternativeClass"/>
			
					<c:if test="${headerType == 'level3page' and level3PageAlternativeClass != ''}">
						<div class="<c:out value="${level3PageAlternativeClass}"/>">	
					</c:if>
			
					<div id="headerArea">
						<ig:slot id="headerAreaSlot" allowedNumberOfComponents="1" allowedComponentNames="GU Header 2.0,Level 3 Header 2.0"></ig:slot>		
						<content:assetUrl id="leftLogotype" propertyName="LeftLogotype" useRepositoryInheritance="false"/>
						<structure:boundPage id="leftLogoPage" propertyName="LeftLogoPage" useRepositoryInheritance="false"/>
						<c:if test="${empty leftLogotype && empty leftLogoPage}">
							<common:include relationAttributeName="RelatedComponents" contentName="GU Header 2.0"/>			
						</c:if>
					</div>
					<c:if test="${headerType == 'level3page' and level3PageAlternativeClass != ''}">
						</div>	
					</c:if>
					
					<structure:componentPropertyValue id="showBlackTopArea" propertyName="ShowBlackTopArea" useRepositoryInheritance="false"/>
					<c:if test="${showBlackTopArea != 'false'}">
					<div id="darkRow">
						<common:include relationAttributeName="RelatedComponents" contentName="GU TopNavigation 2.0"/>
					</div>
					</c:if>
					
					<!-- The Content starts here -->
					<div id="bodyArea">
							
						<structure:componentPropertyValue id="showCrumbtrailArea" propertyName="ShowCrumbtrailArea" useInheritance="false"/>
						<c:if test="${empty showCrumbtrailArea || showCrumbtrailArea != 'false' || param.siteSearch == 'true'}">
							<common:include relationAttributeName="RelatedComponents" contentName="GU Crumbtrail 2.0"/>
						</c:if>
							
						<c:choose>	
							<c:when test="${param.siteMap == 'true'}">

								<!-- SiteMap -->
								<div class="col25">
									<div id="menuComp">
										<h1 id="menuLevel"><structure:componentLabel mapKeyName="siteMapLabel"/></h1>
									</div>
								</div>
								<div class="col75">
									<a name="content"></a>
									<common:include relationAttributeName="RelatedComponents" contentName="SiteMap"/>
								</div>
								<div class="clr"></div>
								<!-- SiteMap End -->

							</c:when>
							<c:when test="${param.siteSearch == 'true'}">
								
								<!-- Search -->
								<c:choose>
									<c:when test="${param.isJavascriptSupported == 'false'}">
										<common:include relationAttributeName="RelatedComponents" contentName="GU SiteSeeker category result no js component"/>
									</c:when>
									<c:otherwise>
										<common:include relationAttributeName="RelatedComponents" contentName="GU SiteSeeker category result component"/>
									</c:otherwise>
								</c:choose>
								<!-- Search End -->

							</c:when>
							<c:otherwise>
							
								<!--/eri-no-index-->
								<!-- Profile area top -->
								<ig:slot id="profileTopArea" allowedNumberOfComponents="1" allowedComponentNames="Profilbild fullbredd,Profilflash fullbredd,Crumbtrail" inherit="false"></ig:slot>
								<!-- / End Profile Area top -->
								
								<!-- The Content starts here -->	
								<ig:slot id="bodyarea" allowedNumberOfComponents="1"></ig:slot>
								<!-- / Content END -->			
								<!--eri-no-index-->
									
							</c:otherwise>
						</c:choose>
							
					</div>
					<!-- The Content ends here -->

					<content:content id="fundedByArticle" propertyName="FundedByArticle" useInheritance="false"/>

					<c:if test="${not empty fundedByArticle}">
					<common:include relationAttributeName="RelatedComponents" contentName="Partner Component"/>
					</c:if>
										
				</div>		
			</div>
		</div>
	</div>
	
<!-- Footer -->
	<content:contentAttribute id="organisationName" propertyName="siteLabels" attributeName="OrganisationName"/>
	<content:contentAttribute id="organisationNameClean" propertyName="siteLabels" attributeName="OrganisationName" disableEditOnSight="true"/>
	<content:contentAttribute id="phoneLabel" propertyName="siteLabels" attributeName="PhoneLabel"/>
	<content:contentAttribute id="phone" propertyName="siteLabels" attributeName="Phone" disableEditOnSight="true"/>
	<content:contentAttribute id="boxNumber" propertyName="siteLabels" attributeName="boxNumber"/>
	<content:contentAttribute id="zipCode" propertyName="siteLabels" attributeName="zipCode"/>
	<content:contentAttribute id="city" propertyName="siteLabels" attributeName="city"/>
	<content:contentAttribute id="mapLabel" propertyName="siteLabels" attributeName="MapLabel"/>
	<content:contentAttribute id="mapTitle" propertyName="siteLabels" attributeName="MapTitle" disableEditOnSight="true"/>

	<content:contentAttribute id="mapAlias" propertyName="siteLabels" attributeName="MapAlias"/>
	
	<c:if test="${mapAlias == ''}">
		<c:set var="mapAlias" value="9020"/>
	</c:if>
	
	<structure:pageUrl id="mainMapPageUrl" propertyName="MainMapPage"/>
	
	<common:URLEncode id="organisationNameCleanEncoded" value="${organisationNameClean}" encoding="iso-8859-1"/>
	<common:urlBuilder id="showMapUrl" baseURL="${mainMapPageUrl}" fullBaseUrl="true" excludedQueryStringParameters="siteMap,adjust,recipientName,email,returnAddress,showMap">
		<common:parameter name="showMap" value="true"/>
		<common:parameter name="mapAlias" value="${mapAlias}"/>
		<common:parameter name="keepArticle" value="true"/>
		<common:parameter name="mapTitle" value="${organisationNameCleanEncoded}"/>
	</common:urlBuilder>
	
	<structure:boundPages id="footerLinks" propertyName="footerLinks"/>
	
	<content:contentAttribute id="footerPage1Title" contentId="${footerLinks[0].metaInfoContentId}" attributeName="Description"/>
	
	<div id="footerArea">
		<p class="left">&copy; <a href="<c:out value="${startPage.url}"/>" title="<c:out value="${homeTitle}"/>"><c:out value="${organisationName}" escapeXml="false"/></a>, <c:out value="${boxNumber}" escapeXml="false"/>, <c:out value="${zipCode}" escapeXml="false"/> <c:out value="${city}" escapeXml="false"/>
		<br /><c:out value="${phoneLabel}" escapeXml="false"/> <c:out value="${phone}" escapeXml="false"/>, <a accesskey="7" href="<c:out value="${footerLinks[0].url}"/>" title="<c:out value="${footerPage1Title}"/>"><c:out value="${footerLinks[0].navigationTitle}"/></a></p>
		<p class="right"><a accesskey="0" href="<c:out value="${footerLinks[1].url}"/>" title="<c:out value="${footerPage2Title}"/>"><c:out value="${footerLinks[1].navigationTitle}"/></a> | <a href="<c:out value="${showMapUrl}" escapeXml="true"/>" title="<c:out value="${mapTitle}" escapeXml="false"/>"><c:out value="${mapLabel}" escapeXml="false"/></a></p>
		<div class="clr"></div>
	</div>

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

<c:if test="${pc.isInPageComponentMode}">
	<script type="text/javascript"> 
    	function keepSession() { jQuery.get("UpdateCache!test.action"); setTimeout("keepSession()", 600000); }
      	$(document).ready(function() { setTimeout("keepSession()", 60000);});
    </script>
</c:if>

<!--Printerfoot, Only visible when printing -->
<jsp:useBean id="now" class="java.util.Date" />
<common:urlBuilder id="currentFullUrl" fullBaseUrl="true" excludedQueryStringParameters="print"/>

<c:if test="${param.print == 'true'}">
<div class="printfoot">
	Denna text är utskriven från följande webbsida: <br />
	<c:out value="${currentFullUrl}" escapeXml="false"/>
	<br />
	Utskriftsdatum: <common:formatter value="${now}" pattern="yyyy-MM-dd"/>
</div>
</c:if>
<!--/eri-no-index-->

<c:set var="serverName"><%=pageContext.getRequest().getServerName()%></c:set>

<structure:componentLabel id="listenLangCode" mapKeyName="listenLangCode"/>
<form name="insipioRefererForm" method="post" action="http://spoxy4.insipio.com/generator/<c:out value="${listenLangCode}"/>/<c:out value="${serverName}" escapeXml="false"/>">
	<input type="hidden" name="referer" value=""/>
</form>
</body>
</html>