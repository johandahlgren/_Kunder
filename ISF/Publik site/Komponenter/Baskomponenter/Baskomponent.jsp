<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-management" prefix="management" %>

<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController" %>
<%@page import="org.infoglue.cms.entities.structure.SiteNodeVO" %>
<%@page import="org.infoglue.deliver.applications.databeans.DeliveryContext" %>
<%@page import="org.infoglue.cms.util.CmsPropertyHandler" %>

<page:pageContext id="pc"/>

<page:httpHeader name="Cache-Control" value="no-cache"/>
<page:httpHeader name="Pragma" value="no-cache"/>
<page:httpHeader name="Expires" value="0"/>

<%
	BasicTemplateController btc = (BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
%>

<structure:componentPropertyValue id="analyticsId" propertyName="AnalyticsId" useInheritance="true"/>

<content:content id="logotyp" propertyName="Logotyp" useInheritance="true"/>
<content:assetUrls id="logotypUrls" contentId="${logotyp.id}" />
<c:set var="logotypUrl" value="${logotypUrls[0]}"/>
<content:contentAttribute id="logotypAlt" attributeName="Alt" contentId="${logotyp.id}" disableEditOnSight="true"/>
<content:assetUrl id="favIcon" propertyName="FavIcon"/>
<structure:pageUrl id="startPageUrl" propertyName="Startsida" />
<structure:componentLabel id="startPageTitle" mapKeyName="StartPageTitle"/>
<structure:boundPage id="rssPage" propertyName="RssPage" />
<structure:boundPage id="inEnglishPage" propertyName="InEnglishPage" />
<structure:pageUrl id="searchResultPageUrl" propertyName="SokResultatSida"/>
<structure:componentLabel id="goToMainContent" mapKeyName="GoToMainContent"/>

<structure:boundPages id="group1Pages" propertyName="Group1Pages" useInheritance="true" />
<structure:boundPages id="group2Pages" propertyName="Group2Pages" useInheritance="true" />
<structure:boundPages id="group3Pages" propertyName="Group3Pages" useInheritance="true" />
<structure:boundPages id="topPages" propertyName="TopPages" useInheritance="true" />

<content:assetUrls id="jSHeadScripts" propertyName="JSHeadScripts" useInheritance="true" />
<content:assetUrls id="jSEndBodyScripts" propertyName="JSEndBodyScripts" useInheritance="true" />

<structure:pageUrl id="shoppingBasketPageUrl" propertyName="ShoppingBasketPage" />

<common:getCookie id="isfSelectedContrast" name="isfSelectedContrast"/>

<c:if test="${not empty param.contrast}">
	<c:choose>
		<c:when test="${not empty param.resetStyles}">
			<common:setCookie name="isfSelectedContrast" path="/isf<%= org.infoglue.cms.util.CmsPropertyHandler.getOperatingMode() %>" value="" maxAge="-1" />
		</c:when>
		<c:otherwise>
			<common:setCookie name="isfSelectedContrast" path="/isf<%= org.infoglue.cms.util.CmsPropertyHandler.getOperatingMode() %>" value="${param.contrast}" maxAge="${1000*60*60*24*365}" />
		</c:otherwise>
	</c:choose>
	<common:urlBuilder id="currentUrl" includeCurrentQueryString="true" excludedQueryStringParameters="contrast" />
	<common:sendRedirect url="${currentUrl}" />
</c:if>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="sv" xml:lang="sv">
	<head>
		<meta http-equiv="X-UA-Compatible" content="IE=edge" />
        <meta http-equiv="content-Type" content="text/html; charset=utf-8" />
        <meta http-equiv="pragma" content="no-cache" /> 
        <meta http-equiv="cache-control" content="no-cache" />
        <meta http-equiv="cache-control" content="no-store" />
        <meta http-equiv="expires" content="-1">
        
        <title>
        	<structure:componentLabel id="siteName" mapKeyName="SiteName"/>
			<c:set var="contentId" value="${param.contentId}"/>
        	<page:pageAttribute id="extraNavigationTitle" name="extraNavigationTitle" />
			<c:if test="${not empty contentId}">
				<content:contentAttribute id="contentTitle" contentId="${contentId}" disableEditOnSight="true" attributeName="Title"/>
				<content:contentAttribute id="contentRubrik" contentId="${contentId}" attributeName="Rubrik" disableEditOnSight="true" />
			</c:if>
			<%
				SiteNodeVO currentSideNode	= btc.getSiteNode(btc.getSiteNodeId());
				String pageName 			= btc.getContentAttribute(currentSideNode.getMetaInfoContentId(), "NavigationTitle", true);
				String contentId			= (String)pageContext.getAttribute("contentId");
				String extraNavigationTitle = (String)pageContext.getAttribute("extraNavigationTitle");
				
				if (extraNavigationTitle != null && !extraNavigationTitle.trim().equals(""))
				{
					pageName = extraNavigationTitle;
				}
				else if (contentId != null && !contentId.trim().equals("") && !contentId.trim().equals("-1"))
				{
					pageName = (String)pageContext.getAttribute("contentTitle");
					if (pageName == null || pageName.trim().equals(""))
					{
						pageName = (String)pageContext.getAttribute("contentRubrik");
					}
				}
				
				pageContext.setAttribute("pageNavTitle", pageName);
			%>
			<c:out value="${pageNavTitle}" escapeXml="false"/> - <c:out value="${siteName}" escapeXml="false" />
        </title>
        
        <page:deliveryContext id="deliveryContext" disableNiceUri="true"/>
        <structure:boundPage id="cssSida" propertyName="CSS Sida"/>
        <structure:boundPage id="cssSidaIe" propertyName="CSS Sida IE"/>
        <structure:boundPage id="cssSidaKontrast" propertyName="CSS Sida Anpassad"/>
        <structure:boundPage id="cssSidaPrint" propertyName="CSS Sida Print"/>
        <structure:componentPropertyValue id="siteSeekerCss" propertyName="SiteSeekerCss"/>
        
        <link href="<c:out value="${cssSida.url}" escapeXml="false" />" rel="stylesheet" type="text/css" media="all" />
        
        <c:if test="${not empty cssSidaIe.url}">
        	<%-- IE-CSS --%>
	        <!--[if lte IE 7]>
	        <link href="<c:out value="${cssSidaIe.url}" escapeXml="false" />" rel="stylesheet" type="text/css" media="all" />
	        <![endif]-->
        </c:if>
        <c:if test="${not empty cssSidaPrint.url}">
        	<%-- Print-CSS --%>
        	<link rel="stylesheet" type="text/css" href="<c:out value="${cssSidaPrint.url}" escapeXml="false" />" media="print" />
        </c:if>

        <c:if test="${not empty siteSeekerCss}">
        	<%-- Print-CSS --%>
        	<link rel="stylesheet" type="text/css" href="<c:out value="${siteSeekerCss}" escapeXml="false" />" media="all" />
        </c:if>
        
       	<%-- Högkontrast-CSS --%>
       	<link id="contrastCss" rel="stylesheet" type="text/css" media="screen" href="<c:out value="${cssSidaKontrast.url}" escapeXml="false" />" />
        
        <c:forEach var="javascript" items="${jSHeadScripts}" varStatus="loop">
			<script type="text/javascript" src="<c:out value="${javascript}" escapeXml="false" />"></script>
		</c:forEach>

		<script type="text/javascript" src="/search/scripts/jquery-1.5.1.min.js"></script>
		<script type="text/javascript" src="/search/scripts/jquery-ui-1.8.14.fwcomplete.min.js"></script>
		<script type="text/javascript" src="/search/scripts/jquery.qtip-1.0.0-rc3.min.js"></script>
		<script type="text/javascript" src="/search/scripts/fwcomplete.0.6.3.js"></script>
		<script type="text/javascript" src="/search/scripts/jsp-gui.js"></script>
		<%--
		<link href="/search/css/qc.css" rel="stylesheet" type="text/css" media="all"></link> --%>
				
        
        <link rel="icon" href="<c:out value="${favIcon}" />" type="image/x-icon" />
		<link rel="shortcut icon" href="<c:out value="${favIcon}" />" type="image/x-icon" />
		
		<page:deliveryContext id="deliveryContext" disableNiceUri="false"/> 
		<script type="text/javascript">		
			
			//--------------------------------------------------------------------------------
			// A global variable used by the javascript file to set the cookie path.
			// This rather bad solution is required since the JS is an included file and not 
			// a JSP-page that is rendered by the server.
			//--------------------------------------------------------------------------------
			
			var cookiePath = "/isf<%= org.infoglue.cms.util.CmsPropertyHandler.getOperatingMode() %>";
			
			//-------------------------------------------------------------
			// Dynamically loading HighContrsatCSS to fix caching problems
			//-------------------------------------------------------------
			
			var head  = document.getElementsByTagName("head")[0];
			var link  = document.createElement("link");
			link.rel  = "stylesheet";
			link.type = "text/css";
			link.href = "<c:out value="${cssSidaKontrast.url}" escapeXml="false" />&random=" + new Date().getTime();
			link.media = "screen";
			head.appendChild(link);
		
			function setCookie(aName, aValue, aExpiredays)
			{
				var exdate=new Date();
				exdate.setDate(exdate.getDate() + aExpiredays);
				document.cookie=aName+ "=" +escape(aValue) + ((aExpiredays == null) ? "" : ";expires=" + exdate.toUTCString() + ";path=<c:out value="${cookiePath}" escapeXml="false"/>");
			}

		</script> 
		
		<script type="text/javascript">
			var _gaq = _gaq || [];
			_gaq.push(['_setAccount', '<c:out value="${analyticsId}" />']);
			_gaq.push(['_trackPageview']);
			
			(function() 
			{
				var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
				ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
				var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
			})();
		</script>
    </head>
	
	<body class="nonjs">
		<div id="bodyContainer">
            <div class="innerContainer">
            	<!-- eri-no-index -->
				<div id="headerContainer">
                    <div class="innerContainer">
						<div id="logoContainer">
                            <div class="innerContainer">
                                <a href="<c:out value="${startPageUrl}" escapeXml="false"/>" title="<c:out value="${startPageTitle}" escapeXml="false"/>" accesskey="1"> <%--Gå till startsidan --%>
                                	<img src="<c:out value="${logotypUrl}"/>" alt="<c:out value="${logotypAlt}" />" />
                                </a>
                                <span id="skipLink">
                                    <a href="#content" accesskey="s"><c:out value="${goToMainContent}" escapeXml="false"/></a>
                                </span>
                            </div>
                        </div>
						<div id="toolMenuContainer">
                            <div class="innerContainer">
                                <ul>
                                    <c:forEach var="page" items="${topPages}" varStatus="loop">
										<c:set var="menuItemPositionClass" value="" />
										<c:if test="${loop.first}">
											<c:set var="menuItemPositionClass" value="first" />
										</c:if>
										<li class="<c:out value="${menuItemPositionClass}" />">
											<a href="<c:out value="${page.url}" escapeXml="false" />"><c:out value="${page.navigationTitle}" escapeXml="true"/></a>
										</li>
									</c:forEach>
                                    <li class="rss">
                                    	<c:choose>
                                    		<c:when test="${empty rssPage.url and pc.isDecorated}"><div class="adminMessage"><structure:componentLabel mapKeyName="NoRssPage"/></div></c:when>
                                    		<c:otherwise><a href="<c:out value="${rssPage.url}" escapeXml="false" />"><span><c:out value="${rssPage.navigationTitle}"/></span></a></c:otherwise>
                                    	</c:choose>
                                    </li>
									<li class="last">
                                    	<c:choose>
                                    		<c:when test="${empty inEnglishPage.url and pc.isDecorated}"><div class="adminMessage"><structure:componentLabel mapKeyName="NoInEnglishPage"/></div></c:when>
                                    		<c:otherwise><a href="<c:out value="${inEnglishPage.url}" escapeXml="false" />"><span><c:out value="${inEnglishPage.navigationTitle}"/></span></a></c:otherwise>
                                    	</c:choose>
                                    </li>
                                </ul>
                            </div>
                        </div>
                        
                        <div id="shoppingBasketContainer">
                            <div class="innerContainer">
                                <span><strong>1 <structure:componentLabel mapKeyName="Report"/></strong> <structure:componentLabel mapKeyName="InTheBasket"/></span>
                                <a href="<c:out value="${shoppingBasketPageUrl}"/>" title="<structure:componentLabel mapKeyName="TitleShowChange"/>"><structure:componentLabel mapKeyName="ShowChange"/></a>
                            </div>
                        </div>
                        
						<div id="searchContainer">
                            <div class="innerContainer">
                            	<structure:componentLabel id="searchWebSite" mapKeyName="SearchWebSite"/>
                            	<form action="<c:out value="${searchResultPageUrl}" escapeXml="false" />" method="get" accept-charset="utf-8">
	                                <fieldset>
	                                	<legend><structure:componentLabel mapKeyName="SearchWebSite"/></legend>
	                                    <label for="searchField"><structure:componentLabel mapKeyName="SearchWebSiteLabel"/></label>
	                                    <input type="hidden" class="emptyQuery" name="emptyQuery" value="no" />
	                                    <input id="searchField" class="ui-autocomplete-input" name="q" type="text" accesskey="4" />
	                                    <input type="submit" class="searchButton" value="<structure:componentLabel mapKeyName="Search"/>" />
	                                </fieldset>
	                        	</form>
                            </div>
                        </div>
						
						<div id="topMenuContainer">
                            <div class="innerContainer">       
                                <ul id="topMenuFirst">
									<c:forEach var="page" items="${group1Pages}" varStatus="loop">
										<c:set var="menuItemPositionClass" value="" />
										<c:if test="${loop.first}">
											<c:set var="menuItemPositionClass"><c:out value="${menuItemPositionClass}" /> first</c:set>
										</c:if>
										<c:if test="${loop.last}">
											<c:set var="menuItemPositionClass"><c:out value="${menuItemPositionClass}" /> last</c:set>
										</c:if>
										<structure:isSiteNodeParentToCurrentSiteNode siteNodeId="${page.siteNodeId}" id="isCurrent" />
										<c:choose>
											<c:when test="${isCurrent}">
												<li class="selected <c:out value="${menuItemPositionClass}" />""><a href="<c:out value="${page.url}" escapeXml="false" />"><span><c:out value="${page.navigationTitle}"/></span></a></li>
											</c:when>
											<c:otherwise>
												<li class="<c:out value="${menuItemPositionClass}" />"><a href="<c:out value="${page.url}" escapeXml="false" />"><span><c:out value="${page.navigationTitle}"/></span></a></li>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</ul> <%-- topMenuFirst --%>
                                
                                <ul id="topMenuSecond">
									<c:forEach var="page" items="${group2Pages}" varStatus="loop">
										<c:set var="menuItemPositionClass" value="" />
										<c:if test="${loop.first}">
											<c:set var="menuItemPositionClass"><c:out value="${menuItemPositionClass}" /> first</c:set>
										</c:if>
										<c:if test="${loop.last}">
											<c:set var="menuItemPositionClass"><c:out value="${menuItemPositionClass}" /> last</c:set>
										</c:if>
										<structure:isSiteNodeParentToCurrentSiteNode siteNodeId="${page.siteNodeId}" id="isCurrent" />
										<c:choose>
											<c:when test="${isCurrent}">
												<li class="selected <c:out value="${menuItemPositionClass}" />"><a href="<c:out value="${page.url}" escapeXml="false" />"><span><c:out value="${page.navigationTitle}"/></span></a></li>
											</c:when>
											<c:otherwise>
												<li class="<c:out value="${menuItemPositionClass}" />"><a href="<c:out value="${page.url}" escapeXml="false" />"><span><c:out value="${page.navigationTitle}"/></span></a></li>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</ul> <%-- slut topMenuSecond --%>
                                
                                <ul id="topMenuThird">
									<c:forEach var="page" items="${group3Pages}" varStatus="loop">
										<c:set var="menuItemPositionClass" value="" />
										<c:if test="${loop.first}">
											<c:set var="menuItemPositionClass"><c:out value="${menuItemPositionClass}" /> first</c:set>
										</c:if>
										<c:if test="${loop.last}">
											<c:set var="menuItemPositionClass"><c:out value="${menuItemPositionClass}" /> last</c:set>
										</c:if>
										<structure:isSiteNodeParentToCurrentSiteNode siteNodeId="${page.siteNodeId}" id="isCurrent" />
										<c:choose>
											<c:when test="${isCurrent}">
												<li class="selected <c:out value="${menuItemPositionClass}" />">
													<a href="<c:out value="${page.url}" escapeXml="false" />"><span><c:out value="${page.navigationTitle}"/></span></a>
												</li>
											</c:when>
											<c:otherwise>
												<li class="<c:out value="${menuItemPositionClass}" />">
													<a href="<c:out value="${page.url}" escapeXml="false" />"><span><c:out value="${page.navigationTitle}"/></span></a>
												</li>
											</c:otherwise>
										</c:choose>
									</c:forEach>
								</ul> <%-- slut topMenuThird  --%>
                            </div>
                        </div>
					</div> 
				</div> <%-- slut headerContainer --%>
				<!-- /eri-no-index -->
				   
				<%-- finns flera olika sidlayoutsklasser som måste sättas på mainContentContainer för sidlayouterna startsida, understartsida, bred sida (utan högerkolumn), fullbreddsida (utan högerkolumn och vänstermeny) --%>
                <%-- vanliga 3-kolumnssidor med vanlig text har ingen klass alls här --%>
				
				<ig:slot id="huvudinnehall" allowedComponentGroupNames="Layout" allowedNumberOfComponents="1" inherit="false"></ig:slot>
		
				<div id="footerContainer">
                    <div class="innerContainer"><%-- OBS: nytt innehåll --%>
						<ig:slot id="sidFot" allowedComponentNames="Sidfot" allowedNumberOfComponents="1" inherit="true"></ig:slot>
					</div> 
				</div><%-- slut footerContainer --%>
			</div>
		</div>
		
		<script type="text/javascript">
			$(document).ready(function() {
				$("#pageMainContent a[href*='.pdf'], div.textBox a[href*='.pdf']").each(function() {
					if (!$(this).hasClass("pdfLink"))
					{
						$(this).addClass("pdfLink");
						$(this).attr("title", "<structure:componentLabel mapKeyName="PdfLinkInlineText"/>");
						$(this).attr("target", "_blank");
						var temp = $(this).text()
						$(this).text(temp + " (PDF)");
					}
				})
			});
		</script>
		
		<!-- eri-no-index -->
		<!-- eri-no-follow -->
		<div id="shoppingLightbox">
            <div class="container">
                <div class="innerContainer">
                    <p>
                        <strong><structure:componentLabel mapKeyName="PdfLinkText"/></strong>
                    </p>
                    <ul>
                        <li><a href="<c:out value="${shoppingBasketPageUrl}" />" class="goToShoppingBasket" title="<structure:componentLabel mapKeyName="TitleGoToCheckout"/>"><structure:componentLabel mapKeyName="GoToCheckout"/></a></li>
                        <li><a href="#" class="closeShoppingLightbox" title="<structure:componentLabel mapKeyName="TitleBackToPage"/>"><structure:componentLabel mapKeyName="BackToPage"/></a></li>
                    </ul>
                    <p>
                        <structure:componentLabel mapKeyName="BasketHelp"/>
                    </p>
                </div>
            </div>
        </div>
        <!-- /eri-no-follow -->
        <!-- /eri-no-index -->
		
		<c:forEach var="javascript" items="${jSEndBodyScripts}" varStatus="loop">
			<script type="text/javascript" src="<c:out value="${javascript}" escapeXml="false" />"></script>
		</c:forEach>
	</body>
</html>