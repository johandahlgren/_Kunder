<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-common" prefix="common" %>

<page:pageContext id="pc"/>

<%--<c:set var="netConnectionUrl" value="rtmp://flash.gu.se/ie/"/>--%>

<%-------------------------------------------------------------
 Get the values set in the GU Slider component's request scope
 ------------------------------------------------------------%>

<c:set var="netConnectionUrl" value="${netConnectionUrl}"/>
<c:set var="mediaClip" value="${contentMovieURL}" />
<c:set var="userSelectedSplashImageUrl" value="${contentPicture}" />

<c:if test="${empty configurationContent}">
	<structure:componentLabel mapKeyName="noConfigCont" />
</c:if>

<c:set var="settingsContentId" value="${configurationContent.contentId}"/>

<content:assetUrl id="flowplayerSwfLocation" contentId="${settingsContentId}" assetKey="FlowplayerSwf"/>
<content:assetUrl id="flowplayerControlsSwfLocation" contentId="${settingsContentId}" assetKey="FlowplayerControlsSwf"/>
<content:assetUrl id="flowplayerControlsJavaScriptLocation" contentId="${settingsContentId}" assetKey="FlowplayerControlsJavaScript"/>
<content:assetUrl id="flowplayerRtmpPluginLocation" contentId="${settingsContentId}" assetKey="FlowplayerRtmpPlugin"/>
<content:assetUrl id="flowplayerAnalyticsPlugin" contentId="${settingsContentId}" assetKey="FlowplayerAnalyticsPlugin"/>
<content:assetUrl id="flowplayerIpadJavascriptLocation" contentId="${settingsContentId}" assetKey="FlowplayerIpadJavascript"/>

<content:assetUrl id="transparentGifUrl" contentId="${settingsContentId}" assetKey="transparent"/>
<content:assetUrl id="defaultCssUrl" contentId="${settingsContentId}" assetKey="DefaultCss"/>
<content:assetUrl id="splashWideLarge" contentId="${settingsContentId}" assetKey="SplashWideLarge"/>
<content:assetUrl id="splashWideSmall" contentId="${settingsContentId}" assetKey="SplashWideSmall"/>
<content:assetUrl id="splashNormalLarge" contentId="${settingsContentId}" assetKey="SplashNormalLarge"/>
<content:assetUrl id="splashNormalSmall" contentId="${settingsContentId}" assetKey="SplashNormalSmall"/>
<content:assetUrl id="playImageUrl" contentId="${settingsContentId}" assetKey="PlayImage"/>
<content:assetUrl id="playImageSmallUrl" contentId="${settingsContentId}" assetKey="PlayImageSmall"/>

<%
	// Setup URLs
	
	String mediaClip 				= (String)pageContext.getAttribute("mediaClip");
	String originalMediaClip 		= mediaClip;
	String iPadMediaClip 			= mediaClip;
	String originalNetConnectionUrl = (String)pageContext.getAttribute("netConnectionUrl");
	String iPadStreamUrl 			= originalNetConnectionUrl;
	boolean isIdevice 				= false;
	
	String userAgent = request.getHeader("User-Agent");
	pageContext.setAttribute("userAgent", userAgent);
	
	// Add a trailing / on the iPadStreamUrl if it's not already there
	
	if (!iPadStreamUrl.endsWith("/"))
	{
		iPadStreamUrl += "/";
	}
		
	// Ipad fallbackUrl
	
	String ipadUrl = "";
		
	
	iPadStreamUrl = iPadStreamUrl.replace("rtmp","http");
	
	// Remove the codec-ID from the mediaClip
	
	if (iPadMediaClip.indexOf(":") > -1 )
	{
		iPadMediaClip 	= iPadMediaClip.substring(iPadMediaClip.indexOf(":") + 1);
		if (iPadMediaClip.indexOf("/") == 0 ){
			iPadMediaClip 	= iPadMediaClip.substring(iPadMediaClip.indexOf("/") + 1);
		}
	}
	
	ipadUrl = iPadStreamUrl + iPadMediaClip;	
		
	pageContext.setAttribute("isIdevice", isIdevice);
	pageContext.setAttribute("ipadUrl", ipadUrl);
%>

<!--
Video info:<br/>
userAgent: <c:out value="${userAgent}" escapeXml="false"/><br/>
netConnectionUrl: <c:out value="${netConnectionUrl}" escapeXml="false"/><br/>
mediaClip: <c:out value="${mediaClip}" escapeXml="false"/><br/>
ipadUrl: <c:out value="${ipadUrl}" escapeXml="false"/><br/>
fileType: <c:out value="${fileType}" escapeXml="false"/><br/>
-->

<c:choose>
	<c:when test="${not empty userSelectedSplashImageUrl}">
		<c:set var="splashImageUrl" value="${userSelectedSplashImageUrl}"/>
	</c:when>
	<c:otherwise>
		<c:set var="splashImageUrl" value="${splashWideLarge}"/>
	</c:otherwise>
</c:choose>

<c:set var="slotName" value="${pc.componentLogic.infoGlueComponent.slotName}"/>
<%
	String slotName 	= (String)pageContext.getAttribute("slotName");
	float width;
	if(slotName.equals("top") || slotName.equals("4col"))
		width			= 460;
	else
		width			= 320;
	double height		= 0;
	double aspect		= 0;
	
	aspect 	= (double)9/(double)16;
	height 	= aspect * width;
	
	pageContext.setAttribute("width", Math.round(width));
	pageContext.setAttribute("height", Math.round(height));
%>

<%--********************************************--%>
<%--*             HTML for the player          *--%>
<%--********************************************--%>

<link rel="stylesheet" type="text/css" href="<c:out value="${defaultCssUrl}" escapeXml="false"/>"/>

<c:choose>
	<c:when test="${unableToPlayOnThisDevice}">
		<div class="unableToPlayLarge" style="width: <c:out value="${width}"/>px; height: <c:out value="${height}"/>px; background-image: url('<c:out value="${splashImageUrl}"/>');">
			<structure:componentLabel mapKeyName="unableToPlayOnThisDevice" />
		</div>
	</c:when>
	<c:otherwise>		
		
		<common:transformText id="cleanedSlotName" text="${slotName}" replaceString="-" replaceWithString="_"/>
		<% 
			long time = System.nanoTime();
			pageContext.setAttribute("time", time);
		%>
		<c:set var="uniqueId" value="${time}"/>
		
		<script type="text/javascript" src="<c:out value="${flowplayerControlsJavaScriptLocation}" escapeXml="false"/>"></script> 
		<script type="text/javascript" src="<c:out value="${flowplayerIpadJavascriptLocation}" escapeXml="false"/>"></script>
		
		<div id="flowplayer_<c:out value="${uniqueId}" escapeXml="false"/>" class="flowplayerContainer" style="display: block; width: <c:out value="${width}" escapeXml="false"/>px; height: <c:out value="${height}" escapeXml="false"/>px;"></div>
		
		<%-- Ugly hack for iPad/iPhone problem vith black box --%>
		<div id="flowplayer_<c:out value="${uniqueId}" escapeXml="false"/>_dummy" style="display: none;"></div>
		<%-- END Ugly hack for iPad/iPhone problem vith black box --%>
				
		<script type="text/javascript">
			var player<c:out value="${uniqueId}" escapeXml="false"/> = null;
			
			<c:choose>
				<c:when test="${pc.isInPageComponentMode}">
			$(window).load(function ()
				</c:when>
				<c:otherwise>
			$(document).ready(function ()
				</c:otherwise>
			</c:choose>
			{
				
				$f("flowplayer_<c:out value="${uniqueId}" escapeXml="false"/>", 
				{ 
					src: "<c:out value="${flowplayerSwfLocation}" escapeXml="false"/>",
					wmode: "opaque"
				},
				{
					key: '#@e507600331d78c0a6d7',  
					logo: null,
					<c:if test="${not empty playImageUrl && not empty playImageSmallUrl}">
					play: 
					{
						url: "<c:out value="${playImageUrl}" escapeXml="false"/>",
						width: 78,
						height: 78,
						opacity: 1,
						label: null,
						replayLabel: null,
						fadeSpeed: 500,
						rotateSpeed: 50
					},
					</c:if>
					onLoad: function() {
						fp_ready(this);
					},
					playlist: 
					[
						{
							url: '<c:out value="${splashImageUrl}" escapeXml="false"/>', 
							scaling: 'fit'
						},
						{ 
							url: "<c:out value="${mediaClip}" escapeXml="false"/>",
							scaling: "fit",
							onBeforeFinish: function()
							{								
					        	return true;
					        },
							autoPlay: false,		
							live: false,
							provider: "rtmp",
							ipadUrl: "<c:out value="${ipadUrl}" escapeXml="false"/>"
						}
					],
					plugins: 
					{
						controls: null,
						<c:if test="${not empty analyticsID}">
						gatracker: 
						{
							url: "<c:out value="${flowplayerAnalyticsPlugin}" escapeXml="false"/>",
							debug: false,
							trackingMode: "Bridge",
							bridgeObject: "pageTracker",
							accountId: "<c:out value="${analyticsID}" />"
						},</c:if> 
						rtmp: 
						{
							url: "<c:out value="${flowplayerRtmpPluginLocation}" escapeXml="false"/>",
							netConnectionUrl: "<c:out value="${netConnectionUrl}" escapeXml="false"/>",
							durationFunc: 'getStreamLength'
						}
					}
				}).ipad({simulateiDevice: false, controls: true});
				
				<%-- Ugly hack for iPad/iPhone problem vith black box --%>
				$f("flowplayer_<c:out value="${uniqueId}" escapeXml="false"/>_dummy", 
				{ 
					src: "<c:out value="${flowplayerSwfLocation}" escapeXml="false"/>",
					wmode: "opaque"
				});
				<%-- END Ugly hack for iPad/iPhone problem vith black box --%>
			});
		</script>
	</c:otherwise>
</c:choose>