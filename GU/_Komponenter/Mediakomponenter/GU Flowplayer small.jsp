<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-common" prefix="common" %>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="sourceType" propertyName="SourceType" useInheritance="false"/>
<structure:componentPropertyValue id="netConnectionUrl" propertyName="NetConnectionUrl" useInheritance="false"/>
<structure:componentPropertyValue id="mediaClip" propertyName="MediaClip" useInheritance="false"/>
<structure:componentPropertyValue id="aspectRatio" propertyName="AspectRatio" useInheritance="false"/>
<structure:componentPropertyValue id="autoPlay" propertyName="AutoPlay" useInheritance="false"/>
<structure:componentPropertyValue id="autoRepeat" propertyName="AutoRepeat" useInheritance="false"/>
<structure:componentPropertyValue id="hideControls" propertyName="HideControls" useInheritance="false"/>
<structure:componentPropertyValue id="splashScreenType" propertyName="SplashScreenType" useInheritance="false"/>
<structure:componentPropertyValue id="startFrame" propertyName="StartFrame" useInheritance="false"/>
<structure:componentPropertyValue id="googleKey" propertyName="GoogleKey" useInheritance="true"/>
<structure:componentPropertyValue id="liveStream" propertyName="LiveStream" useInheritance="false"/>
<structure:componentPropertyValue id="fallbackurl" propertyName="FallbackUrl" useInheritance="false"/>

<content:assetUrl id="userSelectedSplashImageUrl" propertyName="SplashImage" useInheritance="false"/>

<structure:pageUrl id="customCssUrl" propertyName="CustomCssUrl" useInheritance="false"/>
<structure:pageUrl id="linkUrl" propertyName="LinkUrl" useInheritance="false"/>

<content:content id="componentContent" contentId="${pc.componentLogic.infoGlueComponent.contentId}"/>
<content:relatedContents id="configurationContent" contentId="${componentContent.contentId}" attributeName="RelatedComponents" onlyFirst="true"/>

<c:if test="${empty configurationContent}">
	Inget FlowplayerSettings-inneh&aring;ll utpekat i related contents. Kan inte forts&auml;tta.<br/>
</c:if>

<c:set var="settingsContentId" value="${configurationContent.contentId}"/>

<content:assetUrl id="flowplayerSwfLocation" contentId="${settingsContentId}" assetKey="FlowplayerSwf"/>
<content:assetUrl id="flowplayerControlsSwfLocation" contentId="${settingsContentId}" assetKey="FlowplayerControlsSwf"/>
<content:assetUrl id="flowplayerJavascriptLocation" contentId="${settingsContentId}" assetKey="FlowplayerJavascript"/>
<content:assetUrl id="flowplayerControlsJavaScriptLocation" contentId="${settingsContentId}" assetKey="FlowplayerControlsJavaScript"/>
<content:assetUrl id="flowplayerRtmpPluginLocation" contentId="${settingsContentId}" assetKey="FlowplayerRtmpPlugin"/>
<content:assetUrl id="flowplayerViralPlugin" contentId="${settingsContentId}" assetKey="FlowplayerViralPlugin"/>
<content:assetUrl id="flowplayerAnalyticsPlugin" contentId="${settingsContentId}" assetKey="FlowplayerAnalyticsPlugin"/>
<content:assetUrl id="flowplayerContentPlugin" contentId="${settingsContentId}" assetKey="FlowplayerContentPlugin"/>
<content:assetUrl id="flowplayerMusicPluginLocation" contentId="${settingsContentId}" assetKey="FlowplayerMusicPlugin"/>
<content:assetUrl id="flowplayerIpadJavascriptLocation" contentId="${settingsContentId}" assetKey="FlowplayerIpadJavascript"/>
<content:assetUrl id="flowplayerPseudoStreamingPluginLocation" contentId="${settingsContentId}" assetKey="FlowplayerPseudoStreamingPlugin"/>

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
	String sourceType 				= (String)pageContext.getAttribute("sourceType");
	String fallback 				= (String)pageContext.getAttribute("fallbackurl");
	String fileType					= mediaClip.substring(mediaClip.lastIndexOf(".") + 1);
	boolean isIdevice 				= false;
	
	// Add a trailing / on the iPadStreamUrl if it's not already there
	
	if (!iPadStreamUrl.endsWith("/"))
	{
		iPadStreamUrl += "/";
	}
	
	// Remove file ending if it is an flv or mp3 stream.
	
	if(sourceType.equals("streaming") && (fileType.equals("flv") || fileType.equals("mp3")))
	{
		mediaClip 				= mediaClip.substring(0, mediaClip.lastIndexOf("."));
	}
	
	pageContext.setAttribute("mediaClip", mediaClip);
	
	//Ipad fallbackUrl
	
	String ipadUrl = "";
		
	if (fallback == null || fallback.isEmpty())
	{
		// If this is a static clip we use the original URL as the iPad fallback URL as well.
		
		if (sourceType.equals("static") || sourceType.equals("pseudoStreaming"))
		{
			ipadUrl = mediaClip;
		}
		else
		{
			iPadStreamUrl 	= iPadStreamUrl.replace("rtmp","http");
			
			// Remove the codec-ID from the mediaClip
			
			if (iPadMediaClip.indexOf(":/") > -1 )
			{
				iPadMediaClip 	= iPadMediaClip.substring(iPadMediaClip.indexOf(":/") + 2);
			}
			
			ipadUrl 		= iPadStreamUrl + iPadMediaClip;	
		}
		
		// Check if this is an flv or f4v clip. In that case we can't use the autogenerated URL with iDevices...
			
		String userAgent = request.getHeader("User-Agent");
		pageContext.setAttribute("userAgent", userAgent);
		
		if(userAgent.indexOf("iPad") > - 1 || userAgent.indexOf("iPod") > - 1 || userAgent.indexOf("iPhone") > - 1)
		{
			isIdevice = true;
		}
		
		if ((fileType.equals("flv") || fileType.equals("f4v")) && isIdevice)
		{
			pageContext.setAttribute("unableToPlayOnThisDevice", true);
		}
		else
		{
			pageContext.setAttribute("unableToPlayOnThisDevice", false);
		}
	}
	else 
	{
		ipadUrl = fallback;
	}
	pageContext.setAttribute("isIdevice", isIdevice);
	pageContext.setAttribute("ipadUrl", ipadUrl);
	pageContext.setAttribute("fileType", fileType);
%>

<!--
Video info:<br/>
userAgent: <c:out value="${userAgent}" escapeXml="false"/><br/>
sourceType: <c:out value="${sourceType}" escapeXml="false"/><br/>
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
		<c:choose>
			<c:when test="${aspectRatio eq 'widescreen'}">
				<c:set var="splashImageUrl" value="${splashWideSmall}"/>
			</c:when>
			<c:otherwise>
				<c:set var="splashImageUrl" value="${splashNormalSmall}"/>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

<c:set var="slotName" value="${pc.componentLogic.infoGlueComponent.slotName}"/>
<common:transformText id="cleanedSlotName" text="${slotName}" replaceString="-" replaceWithString="_"/>
<c:set var="uniqueId" value="${cleanedSlotName}_${pc.componentLogic.infoGlueComponent.positionInSlot}"/>

<%
	String size 		= (String)pageContext.getAttribute("size");
	String aspectRatio 	= (String)pageContext.getAttribute("aspectRatio");
	float width			= 220;
	double height		= 0;
	double aspect		= 0;

	if (aspectRatio.equals("widescreen"))
	{
		aspect 	= (double)9/(double)16;
	}
	else
	{
		aspect 	= (double)3/(double)4;
	}
	height 	= aspect * width;
	pageContext.setAttribute("width", Math.round(width));
	pageContext.setAttribute("height", Math.round(height));
%>

<link rel="stylesheet" type="text/css" href="<c:out value="${defaultCssUrl}" escapeXml="false"/>"/>

<c:if test="${not empty title}">
	<h1><c:out value="${title}" escapeXml="false"/></h1> 
</c:if>

<c:choose>
	<c:when test="${isIdevice && fileType eq 'mp3'}">
		<p>
			<structure:componentLabel mapKeyName="mp3Idevice" />
		</p>
		<p>
			<a href="<c:out value="${ipadUrl}"/>"target="_blank"><structure:componentLabel mapKeyName="mp3IdeviceKlickToPlay" /></a>
		</p>
	</c:when>
	<c:when test="${unableToPlayOnThisDevice}">
		<div class="unableToPlaySmall" style="width: <c:out value="${width}"/>px; height: <c:out value="${height}"/>px; background-image: url('<c:out value="${splashImageUrl}"/>');">
			<structure:componentLabel mapKeyName="unableToPlayOnThisDevice" />
		</div>
	</c:when>
	<c:otherwise>
		<c:if test="${not empty customCssUrl}">
			<link rel="stylesheet" type="text/css" href="<c:out value="${customCssUrl}" escapeXml="false"/>"/>
		</c:if>
		
		<script type="text/javascript" src="<c:out value="${flowplayerJavascriptLocation}" escapeXml="false"/>"></script>
		<script type="text/javascript" src="<c:out value="${flowplayerControlsJavaScriptLocation}" escapeXml="false"/>"></script> 
		<script type="text/javascript" src="<c:out value="${flowplayerIpadJavascriptLocation}" escapeXml="false"/>"></script>
				
		<c:if test="${empty autoPlay}">
			<c:set var="autoPlay" value="${false}"/>
		</c:if>
		
		<c:if test="${empty startFrame}">
			<c:set var="startFrame" value="0"/>
		</c:if>
		
		<c:set var="pluginsString">
			<c:choose>
					<c:when test="${hideControls eq 'yes' || not empty linkUrl}">
							controls: null,
					</c:when>
					<c:otherwise>
							controls: 
							{
								// location of the controlbar plugin
								url: "<c:out value="${flowplayerControlsSwfLocation}" escapeXml="false"/>",
						
								// display properties such as size, location and opacity
								left: 0,
								bottom: 0,
								opacity: 0.95,
						
								// styling properties (will be applied to all plugins)
								background: "transparent",
								backgroundGradient: "none",
						
								// controlbar specific settings
								timeColor: "#bbbbbb",
								durationColor: "#ffffff",
								
								all: false,
								play: false,
								scrubber: true,
								time: false,
								mute: true,
								volume: false,
								fullscreen: true,
								
								// tooltips (since 3.1)
								tooltips: 
								{
									buttons: true,
									fullscreen: "<structure:componentLabel mapKeyName="fullscreen" />",
									fullscreenExit: "<structure:componentLabel mapKeyName="exitFullscreen" />",
									mute: "<structure:componentLabel mapKeyName="mute" />",
									unmute :"<structure:componentLabel mapKeyName="unmute" />"
								}
							},
					</c:otherwise>
				</c:choose>
				rtmp: 
				{
					url: "<c:out value="${flowplayerRtmpPluginLocation}" escapeXml="false"/>",
					netConnectionUrl: "<c:out value="${netConnectionUrl}" escapeXml="false"/>"
				},
				pseudoStreaming: 
				{
					url: "<c:out value="${flowplayerPseudoStreamingPluginLocation}" escapeXml="false"/>"
				}
		</c:set>
		
		
		<script type="text/javascript">
			function playMovie(aPlayerId)
			{
				$f(aPlayerId).play(); 
			}
		
			function pauseMovie(aPlayerId)
			{
				$f(aPlayerId).pause(); 
			}
		</script>
		
		<%--********************************************--%>
		<%--*             HTML for the player          *--%>
		<%--********************************************--%>
		
		<c:if test="${not empty linkUrl}">
			<div class="playeroverlay" style="display: block; height: <c:out value="${height}" escapeXml="false"/>px; width: <c:out value="${width}" escapeXml="false"/>px; background-image: url('<c:out value="${transparentGifUrl}" escapeXml="false"/>');" onclick="document.location='<c:out value="${linkUrl}" escapeXml="false"/>';" onmouseover="playMovie('player_<c:out value="${uniqueId}" escapeXml="false"/>')" onmouseout="pauseMovie('player_<c:out value="${uniqueId}" escapeXml="false"/>');">
			</div>
		</c:if>
		
		<div class="playerdiv_small">
			<a id="player_<c:out value="${uniqueId}" escapeXml="false"/>" class="player" style="display: block; width: <c:out value="${width}" escapeXml="false"/>px; height: <c:out value="${height}" escapeXml="false"/>px;">
			</a>
		</div>
		
		<%--********************************************--%>
		<%--*       Javascript for the player          *--%>
		<%--********************************************--%>
		 
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
			$f("player_<c:out value="${uniqueId}" escapeXml="false"/>", 
			{ 
				src: "<c:out value="${flowplayerSwfLocation}" escapeXml="false"/>",
				wmode: "opaque"
			},
			{
				key: '#@e507600331d78c0a6d7',  
				logo:null,
				<c:if test="${not empty playImageUrl && not empty playImageSmallUrl}">
				play: 
				{
					width: 39,
					height: 39,
					opacity: 1,
					label: null,
					replayLabel: null,
					fadeSpeed: 500,
					rotateSpeed: 50
				},
				</c:if>
				playlist: 
				[
					<c:if test="${(splashScreenType eq 'selectImage' && autoPlay eq 'false') || sourceType eq 'streaming'}">
					{
						url: '<c:out value="${splashImageUrl}" escapeXml="false"/>', 
						scaling: 'fit'
					},
					</c:if>
					{ 
						url: "<c:out value="${mediaClip}" escapeXml="false"/>",
						scaling: "fit",
						onBeforeFinish: function()
						{ 
							<c:choose>
								<c:when test="${autoRepeat ne 'no'}">
				                	return false;
				                </c:when>
				                <c:otherwise>
				                	return true;
				                </c:otherwise>
			                </c:choose>
			            },
						autoPlay: <c:out value="${autoPlay}" escapeXml="false"/>
			
						<c:if test="${liveStream eq 'yes'}">
						,live: true
						</c:if>
						
						<c:choose>
						<c:when test="${sourceType eq 'streaming'}">
						,provider: "rtmp"
						,ipadUrl: "<c:out value="${ipadUrl}" escapeXml="false"/>"
						</c:when>
						<c:when test="${sourceType eq 'pseudoStreaming'}">
						,provider: "pseudoStreaming"
						,ipadUrl: "<c:out value="${ipadUrl}" escapeXml="false"/>"
						,start: <c:out value="${startFrame}" escapeXml="false"/>
						,autoBuffering: true
						</c:when>
						<c:otherwise>
						,start: <c:out value="${startFrame}" escapeXml="false"/>
						,autoBuffering: true
						,ipadUrl: "<c:out value="${ipadUrl}" escapeXml="false"/>"
						</c:otherwise>
						</c:choose>
				    }
				],
				canvas:  
				{
					backgroundColor: '#000000',
					backgroundGradient: 'none'
				},
				plugins: 
				{
					<c:out value="${pluginsString}" escapeXml="false"/>
				}
			}).ipad({simulateiDevice: false, controls: true});
		});
		</script>
	</c:otherwise>
</c:choose>
