<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>

<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController" %>
<%@page import="org.infoglue.cms.entities.structure.SiteNodeVO" %>
<%@page import="org.infoglue.deliver.applications.databeans.DeliveryContext"%>
<%@page import="org.infoglue.cms.util.CmsPropertyHandler"%>


<page:pageContext id="pc"/>

<content:content id="logotyp" propertyName="Logotyp" useInheritance="true"/>
<content:contentAttribute id="logotypAlt" attributeName="Alt" contentId="${logotyp.id}" disableEditOnSight="true"/>
<content:assetUrl id="logotypUrl" contentId="${logotyp.id}"/>
<structure:pageUrl id="hemUrl" propertyName="Startsida" />
<structure:boundPage id="searchResultPage" propertyName="SokResultatSida"/>
<structure:boundPage id="firePage" propertyName="FirePage"/>
<structure:boundPage id="phonePage" propertyName="PhonePage"/>
<content:content id="supportSystemsFolder" propertyName="SupportSystemsFolder" useInheritance="true"/>
<structure:boundPages id="topMenuPages" propertyName="TopMenuPages" useInheritance="true" />
<structure:componentPropertyValue id="authorizedIpAddresses" propertyName="AuthorizedIpAddresses"/>
<structure:pageUrl id="authorizationPageUrl" propertyName="AuthorizationPage"/>
<structure:componentPropertyValue id="displayDebug" propertyName="DisplayDebug"/>

<%
	BasicTemplateController btc = (BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
	String operatingMode 		= org.infoglue.cms.util.CmsPropertyHandler.getOperatingMode();
	pageContext.setAttribute("operatingMode", operatingMode);
%>

<c:choose>
	<c:when test="${operatingMode eq '0'}">
		<structure:componentPropertyValue id="cookieDomain" propertyName="CookieDomainWorking"/>
		<structure:componentPropertyValue id="cookiePath" propertyName="CookiePathWorking"/>
	</c:when>
	<c:otherwise>
		<structure:componentPropertyValue id="cookieDomain" propertyName="CookieDomain"/>
		<structure:componentPropertyValue id="cookiePath" propertyName="CookiePath"/>
	</c:otherwise>
</c:choose>

<%-- 
<c:if test="${param.userAction eq 'logout'}">
	<common:setCookie name="igextranetpassword" path="${cookiePath}" value="" maxAge="-1" />
	<common:setCookie name="igextranetuserid" path="${cookiePath}" value="" maxAge="-1" />
	<common:setCookie name="igpassword" path="${cookiePath}" value="" maxAge="-1" />
	<common:setCookie name="iguserid" path="${cookiePath}" value="" maxAge="-1" />
	<common:setCookie name="JSESSIONID" path="${cookiePath}" value="" maxAge="-1" />

	<c:set var="mySession" value="${pc.httpServletRequest.session}"/>
	<%
		//javax.servlet.http.HttpSession mySession = (javax.servlet.http.HttpSession)pageContext.getAttribute("mySession");
		//mySession.invalidate();
	%>
	
	<common:urlBuilder id="logoutUrl" excludedQueryStringParameters="userAction"
	
	</common:urlBuilder>>

	<common:setCookie name="igextranetpassword" path="${cookiePath}" value="" maxAge="-1" />
	<common:setCookie name="igextranetuserid" path="${cookiePath}" value="" maxAge="-1" />
	
	<%
		String currentUrl 			= btc.getCurrentPageUrl();
		String logoutUrl 			= btc.getRepositoryBaseUrl() + "/ExtranetLogin!logout.action?returnAddress=" + currentUrl + "&a";
		pageContext.setAttribute("extranetLogoutUrl", logoutUrl);
	%>
	<common:sendRedirect url="${extranetLogoutUrl}"/>
</c:if>
--%>

<c:if test="${not empty param.uppdateraStyle}">
	<c:choose>
		<c:when test="${not empty param.aterstallStyles}">
			<common:setCookie name="isfIntranetSelectedContrast" path="${cookiePath}" value="" maxAge="-1" />
		</c:when>
		<c:otherwise>
			<common:setCookie name="isfIntranetSelectedContrast" path="${cookiePath}" value="${param.contrast}" maxAge="${1000*60*60*24*365}" />
		</c:otherwise>
	</c:choose>
</c:if>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" xml:lang="en">
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
		
		<meta http-equiv="cache-control" content="no-cache" />
		<meta http-equiv="pragma" content="no-cache" />
		<meta http-equiv="expires" content="-1" />

		<title>
			<structure:componentLabel id="siteName" mapKeyName="SiteName"/>
			<c:set var="contentId" value="${param.contentId}"/>
			<c:if test="${not empty contentId}">
				<content:contentAttribute id="contentTitle" contentId="${contentId}" attributeName="Title"/>
				<content:contentAttribute id="contentRubrik" contentId="${contentId}" attributeName="Rubrik"/>
			</c:if>
			
			<%
				SiteNodeVO currentSideNode	= btc.getSiteNode(btc.getSiteNodeId());
				String pageName 			= btc.getContentAttribute(currentSideNode.getMetaInfoContentId(), "NavigationTitle", true);
				String contentId			= (String)pageContext.getAttribute("contentId");
				
				if (contentId != null && !contentId.trim().equals("") && !contentId.trim().equals("-1"))
				{
					pageName = (String)pageContext.getAttribute("contentTitle");
					if (pageName == null || pageName.trim().equals(""))
					{
						pageName = (String)pageContext.getAttribute("contentRubrik");
					}
				}
				
				pageContext.setAttribute("pageNavTitle", pageName);
			%>
			<c:out value="${siteName}" /> - <c:out value="${pageNavTitle}"/>
		</title>
		
		<page:deliveryContext id="deliveryContext" disableNiceUri="true"/>
		<structure:boundPage id="cssSida" propertyName="CSS Sida"/>
		<structure:boundPage id="cssSidaPrint" propertyName="CSS Sida Print"/>
		<structure:boundPage id="cssSidaIe" propertyName="CSS Sida IE"/>
		<structure:boundPage id="cssSidaAnpassad" propertyName="CSS Sida Anpassad"/>
		
		<link media="all" href="<c:out value="${cssSida.url}" escapeXml="false" />" rel="stylesheet" type="text/css" />
		<link media="print" href="<c:out value="${cssSidaPrint.url}" escapeXml="false" />" rel="stylesheet" type="text/css" />
		<link media="all" href="<c:out value="${cssSidaAnpassad.url}" escapeXml="false" />" rel="stylesheet" type="text/css" />
		
		<!--[if lte IE 7]>
		<link media="all" href="<c:out value="${cssSidaIe.url}" escapeXml="false" />" type="text/css" rel="stylesheet" />
		<![endif]-->
		
		<%-- RSS --%>
		
		<structure:boundPages id="rssPages" propertyName="RssPages"/>
		
		<c:forEach var="rssPage" items="${rssPages}">		
			<common:urlBuilder id="rssUrl" baseURL="${rssPage.url}" query="" excludedQueryStringParameters="adjust,siteNodeId,repositoryName">
		    </common:urlBuilder>
		    <content:contentAttribute id="rssTitle" contentId="${rssPage.metaInfoContentId}" attributeName="Title"/> 		        
		    <link rel="alternate" href="<c:out value="${rssUrl}" escapeXml="true"/>" type="application/rss+xml" title="<c:out value="${rssTitle}"/>"/>	
		</c:forEach>
		
		<page:deliveryContext id="deliveryContext" disableNiceUri="false"/> 
		
		<script type="text/javascript">
			function setCookie(aName, aValue, aExpiredays)
			{
				var exdate=new Date();
				exdate.setDate(exdate.getDate() + aExpiredays);
				document.cookie=aName+ "=" +escape(aValue) + ((aExpiredays == null) ? "" : ";expires=" + exdate.toUTCString() + ";path=<c:out value="${cookiePath}" escapeXml="false"/>");
			}
			
			function logout()
			{
				setCookie("igextranetpassword", null, -1);
				setCookie("igextranetuserid", null, -1);
				<%
					String currentUrl 			= btc.getCurrentPageUrl();
					String logoutUrl 			= btc.getRepositoryBaseUrl() + "/ExtranetLogin!logout.action?returnAddress=" + currentUrl;
					pageContext.setAttribute("extranetLogoutUrl", logoutUrl);
				%>
				document.location = "<c:out value="${extranetLogoutUrl}" escapeXml="false"/>";
			}
		</script>  
	</head>
	
	<body>
		<c:if test="${displayDebug eq 'yes'}">
			<!--
				contrastcookievalue: <c:out value="${isfSelectedContrast}" /><br />
				fontcookieValue: <c:out value="${isfSelectedFont}" /><br />
				contrastParameter: <c:out value="${param.contrast}" /><br />
				fontParameter: <c:out value="${param.font}" /><br />
				<%
				out.print("remoteAddress: " + request.getRemoteAddr() + "<br/>");
				out.print("remoteHost: " + request.getRemoteHost() + "<br/>");
				%>
				LoggedInAs: <c:out value="${pc.principal}" escapeXml="false"/><br/>	
				pc.principal eq 'anonymous': <c:out value="${pc.principal eq 'anonymous'}" escapeXml="false"/><br/>
				operatingMode: <c:out value="${operatingMode}" escapeXml="false"/><br/>
				cookieDomain: <c:out value="${cookieDomain}" escapeXml="false"/><br/>
				cookiePath: <c:out value="${cookiePath}" escapeXml="false"/><br/>
			-->
		</c:if>

		<div id="minMax">
			<div id="outerwrapper">	
				<div id="header">
					<div class="content">
						<div id="logo">
							<span id="skip">
								<a href="#tocontent" accesskey="s">Gå direkt till huvudinnehåll</a> 
                            </span> 
							<a href="<c:out value="${hemUrl}" escapeXml="false"/>" accesskey="1">
								<img alt="<c:out value="${logotypAlt}" />" src="<c:out value="${logotypUrl}"/>" />
							</a>
						</div>
						<h2 class="structural">Sök på intranätet</h2>
						<div id="search">
							<div class="input-sok">
							  	<form action="<c:out value="${searchResultPage.url}" escapeXml="false"/>" method="post">
									<fieldset>
										<input type="text" name="query" title="<structure:componentLabel mapKeyName="SokFaltTitleText"/>" id="sok" accesskey="4" value=""/>
										<input type="submit" value="<structure:componentLabel mapKeyName="SokKnappText"/>" title="<structure:componentLabel mapKeyName="SokKnappTitleText"/>" id="sok-knapp" /> 
						    		</fieldset>
						    	</form>
							</div>
						</div>
						<div id="logged-in-user">
                            <c:choose>
								<c:when test="${pc.principal ne 'anonymous'}">
									<structure:componentLabel mapKeyName="LoggedInAs"/>: <c:out value="${pc.principal}" escapeXml="false"/>
									
									<%-- 
									<common:urlBuilder id="logoutUrl">
										<common:parameter name="userAction" value="logout"/>
									</common:urlBuilder>
									
									<a href="<c:out value="${logoutUrl}" escapeXml="false"/>"><structure:componentLabel mapKeyName="LogOut"/></a>
									--%>
									
									<a href="javascript: logout();"><structure:componentLabel mapKeyName="LogOut"/></a>
								</c:when>
								<c:otherwise>
									&nbsp;
								</c:otherwise>
							</c:choose>
                        </div>
					</div>
				</div> <!-- end header -->
				
				<h2 class="structural">Stödfunktioner</h2>
				
			    <div id="topmenu">
					<ul class="topmenu-1">
						<li class="fire"><a href="<c:out value="${firePage.url}" escapeXml="false" />"><c:out value="${firePage.navigationTitle}" escapeXml="false" /></a></li> 
                      		<li class="phone-list"><a href="<c:out value="${phonePage.url}" escapeXml="false" />"><c:out value="${phonePage.navigationTitle}"/></a></li> 
					</ul>
					<div class="tools-outer-container">
                        <div class="tools-inner-container"> 
                            <ul class="topmenu-tools"> 
                            	<content:childContents id="supportSystems" contentId="${supportSystemsFolder.id}" sortAttribute="SortOrder" includeFolders="false"/>
						 
								<c:forEach var="supportSystem" items="${supportSystems}" varStatus="loop">
									<content:contentAttribute id="link" contentId="${supportSystem.contentId}" attributeName="Link" disableEditOnSight="true"/>
									<content:contentAttribute id="linkText" contentId="${supportSystem.contentId}" attributeName="LinkText" disableEditOnSight="true"/>
									<content:assetUrl id="imageUrl" contentId="${supportSystem.contentId}" assetKey="Image" useInheritance="false"/>											
									
									<li>
										<a href="<c:out value="${link}" escapeXml="false"/>" target="_blank" title="<c:out value="${linkText}" escapeXml="false"/>">
											<img alt="<c:out value="${link}" />" src="<c:out value="${imageUrl}"/>" />
										</a>
									</li>
								</c:forEach>
                            </ul>
                        </div>
                    </div>
					<ul class="topmenu-2">
						<c:forEach var="page" items="${topMenuPages}" varStatus="loop">
							<li><a href="<c:out value="${page.url}" escapeXml="false" />"><c:out value="${page.navigationTitle}"/></a></li>
						</c:forEach>
					</ul>
			    </div>
				<div id="wrapper">
					 <ig:slot id="huvudinnehall" allowedComponentNames="Startsidelayout,Trekolumnslayout,Bred sida" allowedNumberOfComponents="1" inherit="false"></ig:slot>
				</div><!-- end wrapper -->
				
				<h2 class="structural">Kontaktinformation</h2>
				
				<div id="footer">
					<ig:slot id="footer" allowedComponentNames="Sidfot" allowedNumberOfComponents="1" inherit="true"></ig:slot>
				</div> <!-- end footer -->
		    </div> <!-- end outerwrapper -->
		</div> <!-- end minMax -->
		
		
		<script type="text/javascript">

			//------------------
			// Google Analytics
			//------------------
			
			var gaJsHost = (("https:" == document.location.protocol) ? "https://ssl." : "http://www.");
			document.write(unescape("%3Cscript src='" + gaJsHost + "google-analytics.com/ga.js' type='text/javascript'%3E%3C/script%3E"));
			</script>
			<script type="text/javascript">
			try 
			{
				var pageTracker = _gat._getTracker("UA-9492895-1");
				pageTracker._trackPageview();
			} 
			catch(err) {}

		</script>
	</body>
</html>
