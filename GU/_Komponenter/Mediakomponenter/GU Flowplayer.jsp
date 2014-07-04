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
<structure:componentPropertyValue id="hideLinkText" propertyName="HideLinkText" useInheritance="false"/>
<structure:componentPropertyValue id="controls" propertyName="Controls" useInheritance="false"/>
<structure:componentPropertyValue id="linkText" propertyName="LinkText" useInheritance="false"/>
<structure:componentPropertyValue id="startFrame" propertyName="StartFrame" useInheritance="false"/>
<structure:componentPropertyValue id="splashScreenType" propertyName="SplashScreenType" useInheritance="false"/>
<structure:componentPropertyValue id="googleKey" propertyName="GoogleKey" useInheritance="true"/>
<structure:componentPropertyValue id="liveStream" propertyName="LiveStream" useInheritance="false"/>
<structure:componentPropertyValue id="informationTitle" propertyName="InformationTitle" useInheritance="false"/>
<structure:componentPropertyValue id="informationText" propertyName="InformationText" useInheritance="false"/>
<structure:componentPropertyValue id="fallbackurl" propertyName="FallbackUrl" useInheritance="false"/>
<structure:componentPropertyValue id="analyticsID" propertyName="GoogleKey" useInheritance="true"/>

<content:assetUrl id="userSelectedSplashImageUrl" propertyName="SplashImage" useInheritance="false"/>

<content:content id="componentContent" contentId="${pc.componentLogic.infoGlueComponent.contentId}"/>
<content:relatedContents id="configurationContent" contentId="${componentContent.contentId}" attributeName="RelatedComponents" onlyFirst="true"/>

<c:if test="${empty configurationContent}">
	<structure:componentLabel mapKeyName="noConfigCont" />
</c:if>

<c:set var="settingsContentId" value="${configurationContent.contentId}"/>

<content:assetUrl id="flowplayerSwfLocation" contentId="${settingsContentId}" assetKey="FlowplayerSwf"/>
<content:assetUrl id="flowplayerControlsSwfLocation" contentId="${settingsContentId}" assetKey="FlowplayerControlsSwf"/>
<content:assetUrl id="flowplayerViralPlugin" contentId="${settingsContentId}" assetKey="FlowplayerViralPlugin"/>
<content:assetUrl id="flowplayerJavascriptLocation" contentId="${settingsContentId}" assetKey="FlowplayerJavascript"/>
<content:assetUrl id="flowplayerControlsJavaScriptLocation" contentId="${settingsContentId}" assetKey="FlowplayerControlsJavaScript"/>
<content:assetUrl id="flowplayerViralPlugin" contentId="${settingsContentId}" assetKey="FlowplayerViralPlugin"/>
<content:assetUrl id="flowplayerRtmpPluginLocation" contentId="${settingsContentId}" assetKey="FlowplayerRtmpPlugin"/>
<content:assetUrl id="flowplayerAnalyticsPlugin" contentId="${settingsContentId}" assetKey="FlowplayerAnalyticsPlugin"/>
<content:assetUrl id="flowplayerContentPlugin" contentId="${settingsContentId}" assetKey="FlowplayerContentPlugin"/>
<content:assetUrl id="flowplayerAudioPluginLocation" contentId="${settingsContentId}" assetKey="FlowplayerAudioPlugin"/>
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


<c:set var="fullUrl" value="http://${pageContext.request.serverName}" />

<c:set var="flowplayerSwfLocation" value="${fullUrl}${flowplayerSwfLocation}" />
<c:set var="flowplayerControlsSwfLocation" value="${fullUrl}${flowplayerControlsSwfLocation}" />
<c:set var="flowplayerJavascriptLocation" value="${fullUrl}${flowplayerJavascriptLocation}" />
<c:set var="flowplayerControlsJavaScriptLocation" value="${fullUrl}${flowplayerControlsJavaScriptLocation}" />
<c:set var="flowplayerRtmpPluginLocation" value="${fullUrl}${flowplayerRtmpPluginLocation}" />
<c:set var="flowplayerViralPlugin" value="${fullUrl}${flowplayerViralPlugin}" />
<c:set var="flowplayerAnalyticsPlugin" value="${fullUrl}${flowplayerAnalyticsPlugin}" />
<c:set var="flowplayerContentPlugin" value="${fullUrl}${flowplayerContentPlugin}" />
<c:set var="flowplayerAudioPluginLocation" value="${fullUrl}${flowplayerAudioPluginLocation}" />
<c:set var="flowplayerIpadJavascriptLocation" value="${fullUrl}${flowplayerIpadJavascriptLocation}" />
<c:set var="flowplayerPseudoStreamingPluginLocation" value="${fullUrl}${flowplayerPseudoStreamingPluginLocation}" />

<c:if test="${not empty userSelectedSplashImageUrl}">
	<c:set var="userSelectedSplashImageUrl" value="${fullUrl}${userSelectedSplashImageUrl}" />
</c:if>

<c:set var="transparentGifUrl" value="${fullUrl}${transparentGifUrl}" />
<c:set var="defaultCssUrl" value="${fullUrl}${defaultCssUrl}" />
<c:set var="splashWideLarge" value="${fullUrl}${splashWideLarge}" />
<c:set var="splashWideSmall" value="${fullUrl}${splashWideSmall}" />
<c:set var="splashNormalLarge" value="${fullUrl}${splashNormalLarge}" />
<c:set var="splashNormalSmall" value="${fullUrl}${splashNormalSmall}" />
<c:set var="playImageUrl" value="${fullUrl}${playImageUrl}" />
<c:set var="playImageSmallUrl" value="${fullUrl}${playImageSmallUrl}" />
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
			
			if (iPadMediaClip.indexOf(":") > -1 )
			{
				iPadMediaClip 	= iPadMediaClip.substring(iPadMediaClip.indexOf(":") + 1);
				if (iPadMediaClip.indexOf("/") == 0 ){
					iPadMediaClip 	= iPadMediaClip.substring(iPadMediaClip.indexOf("/") + 1);
				}
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
				<c:set var="splashImageUrl" value="${splashWideLarge}"/>
			</c:when>
			<c:otherwise>
				<c:set var="splashImageUrl" value="${splashNormalLarge}"/>
			</c:otherwise>
		</c:choose>
	</c:otherwise>
</c:choose>

<%
	String aspectRatio 	= (String)pageContext.getAttribute("aspectRatio");
	String controls 	= (String)pageContext.getAttribute("controls");
	float width			= 460;
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

	if (!controls.equals("audio"))
	{
		height 	= aspect * width;
	}
	else
	{
		height = 30;
	}
	pageContext.setAttribute("width", Math.round(width));
	pageContext.setAttribute("height", Math.round(height));
%>

<%--********************************************--%>
<%--*             HTML for the player          *--%>
<%--********************************************--%>

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
		<div class="unableToPlayLarge" style="width: <c:out value="${width}"/>px; height: <c:out value="${height}"/>px; background-image: url('<c:out value="${splashImageUrl}"/>');">
			<structure:componentLabel mapKeyName="unableToPlayOnThisDevice" />
		</div>
	</c:when>
	<c:otherwise>
		<c:set var="slotName" value="${pc.componentLogic.infoGlueComponent.slotName}"/>
		
		<common:transformText id="cleanedSlotName" text="${slotName}" replaceString="-" replaceWithString="_"/>
		
		<c:set var="uniqueId" value="${cleanedSlotName}_${pc.componentLogic.infoGlueComponent.positionInSlot}"/>
		
		<script type="text/javascript" src="<c:out value="${flowplayerJavascriptLocation}" escapeXml="false"/>"></script>
		<script type="text/javascript" src="<c:out value="${flowplayerControlsJavaScriptLocation}" escapeXml="false"/>"></script> 
		<script type="text/javascript" src="<c:out value="${flowplayerIpadJavascriptLocation}" escapeXml="false"/>"></script>
		
		<c:if test="${empty autoPlay}">
			<c:set var="autoPlay" value="false"/>
		</c:if>
		
		<c:if test="${empty startFrame || startFrame eq '0'}">
			<c:set var="startFrame" value="1"/>
		</c:if>
		
		<c:set var="pluginsString">
			<c:choose>
				<c:when test="${empty controls || controls eq 'none'}">
						controls: null,
				</c:when>
				<c:when test="${controls eq 'audio'}">
						controls: 
						{
							url: "<c:out value="${flowplayerControlsSwfLocation}" escapeXml="false"/>",
							
							// display properties such as size, location and opacity
							left: 0,
							bottom: 0,
							opacity: 1,
							
							// styling properties (will be applied to all plugins)
							background: "#000000",
							backgroundGradient: "none",
							
							fullscreen: false,
							height: 30,
							autoHide: false
						},
						audio: 
						{
							url: '<c:out value="${flowplayerAudioPluginLocation}" escapeXml="false"/>'
						},
				</c:when>
				<c:otherwise>
						controls: 
						{
							// location of the controlbar plugin
							url: "<c:out value="${flowplayerControlsSwfLocation}" escapeXml="false"/>",
		
							// display properties such as size, location and opacity
							left: 0,
							bottom: 0,
							opacity: 0.7,
					
							// styling properties (will be applied to all plugins)
							background: "#000000",
							backgroundGradient: "none",
					
							// controlbar specific settings
							timeColor: "#bbbbbb",
							durationColor: "#ffffff",
							all: false,
							play: true,
							scrubber: true,
							time: true,
							mute: true,
							volume: true,
							fullscreen: true,
							
							autoHide: true,
												
							// tooltips (since 3.1)
							tooltips: 
							{
								buttons: true,
								play: "<structure:componentLabel mapKeyName="play" />",
								pause: "<structure:componentLabel mapKeyName="pause" />",
								stop: "<structure:componentLabel mapKeyName="stop" />",
								fullscreen: "<structure:componentLabel mapKeyName="fullscreen" />",
								fullscreenExit: "<structure:componentLabel mapKeyName="exitFullscreen" />",
								mute: "<structure:componentLabel mapKeyName="mute" />",
								unmute :"<structure:componentLabel mapKeyName="unmute" />"
							}
						},
				</c:otherwise>
			</c:choose>
			<c:if test="${controls ne 'audio'}">
						viral: 
						{
							url: "<c:out value="${flowplayerViralPlugin}" escapeXml="false"/>",
							/*icons: 
							{
								color: "rgba(100, 100, 100, 0.5)",
							    overColor: "rgba(200, 200, 200, 0.5)"
							},*/
							email: false,
							embed: 
							{
									title: "<structure:componentLabel mapKeyName="embedTitle" />",
									options: "<structure:componentLabel mapKeyName="embedOptions" />",
									backgroundColor: "<structure:componentLabel mapKeyName="embedBackgroundColor" />",
									buttonColor: "<structure:componentLabel mapKeyName="embedButtonColor" />",
									size: "<structure:componentLabel mapKeyName="embedSize" />",
									copy: "<structure:componentLabel mapKeyName="embedCopy" />" 
							},			
							share: 
							{
								title: "<structure:componentLabel mapKeyName="shareText" />"
							}
						},
			</c:if>
						gatracker: 
						{
							url: "<c:out value="${flowplayerAnalyticsPlugin}" escapeXml="false"/>",
							debug: false,
							trackingMode: "Bridge",
							bridgeObject: "pageTracker",
							accountId: "<c:out value="${analyticsID}" />"
						},
						rtmp: 
						{
							url: "<c:out value="${flowplayerRtmpPluginLocation}" escapeXml="false"/>",
							netConnectionUrl: "<c:out value="${netConnectionUrl}" escapeXml="false"/>",
							durationFunc: 'getStreamLength'
						},
						pseudoStreaming: 
						{
							url: "<c:out value="${flowplayerPseudoStreamingPluginLocation}" escapeXml="false"/>"
						}
		</c:set>
		
		<div class="playerdiv_large" style="display: block; width: <c:out value="${width}" escapeXml="false"/>px; height: <c:out value="${height}" escapeXml="false"/>px;">
			<a id="player_<c:out value="${uniqueId}" escapeXml="false"/>" style="display: block; width: <c:out value="${width}" escapeXml="false"/>px; height: <c:out value="${height}" escapeXml="false"/>px;"></a>
			
			<%-- Ugly hack for iPad/iPhone problem vith black box --%>
			<a id="player_<c:out value="${uniqueId}" escapeXml="false"/>_dummy" style="display: none;"></a>
			<%-- END Ugly hack for iPad/iPhone problem vith black box --%>
		</div>
		
		<%--********************************************--%>
		<%--*       Javascript for the player          *--%>
		<%--********************************************--%>
		
		<script type="text/javascript">
			function playMovie(aPlayerId)
			{
				$f(aPlayerId).play(); 
			}
		
			function pauseMovie(aPlayerId)
			{
				$f(aPlayerId).pause(); 
			}
		
			function showShare(playerId)
			{
				eval(playerId).getPlugin("viral").fadeIn();
				eval(playerId).getPlugin("viral").show();
			}
		</script>
		
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
					<c:if test="${not empty playImageUrl && not empty playImageSmallUrl && controls ne 'audio'}">
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
					onMouseOver: function() 
					{
						$("#contentInfo_<c:out value="${uniqueId}" />").css('display', 'block');
					},
					onMouseOut: function() 
					{
						$("#contentInfo_<c:out value="${uniqueId}" />").css('display', 'none');
					},
					playlist: 
					[
						<c:if test="${((splashScreenType eq 'selectImage' && autoPlay eq 'false') || sourceType eq 'streaming') && controls ne 'audio'}">
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
				
				<%-- Ugly hack for iPad/iPhone problem vith black box --%>
				$f("player_<c:out value="${uniqueId}" escapeXml="false"/>_dummy", 
				{ 
					src: "<c:out value="${flowplayerSwfLocation}" escapeXml="false"/>",
					wmode: "opaque"
				});
				<%-- END Ugly hack for iPad/iPhone problem vith black box --%>
			});
		</script>
	</c:otherwise>
</c:choose>

<c:if test="${not empty informationTitle || not empty informationText}">
	<div id="contentInfo_<c:out value="${uniqueId}" escapeXml="false"/>" class="infobox" style="display: none; width: <c:out value="${width - 22}" escapeXml="false"/>px;">
		<span class="infotitle">
			<c:out value="${informationTitle}" escapeXml="false"/>
		</span>
		<br/>
		<span class="infotext">
			<%
				String informationText = (String)pageContext.getAttribute("informationText");
				if (informationText != null)
				{
					informationText = informationText.replaceAll("[\r\n]", "<br/>");
				}
				pageContext.setAttribute("informationText", informationText);
			%>
			<c:out value="${informationText}" escapeXml="false"/>
		</span>
	</div>
</c:if>
