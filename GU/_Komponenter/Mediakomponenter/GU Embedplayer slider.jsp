<%@ taglib uri="infoglue-page" prefix="page"%>
<%@ taglib uri="infoglue-structure" prefix="structure"%>
<%@ taglib uri="infoglue-content" prefix="content"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ taglib uri="infoglue-common" prefix="common"%>
<%@ page import="java.util.Date"%>

<page:pageContext id="pc" />

<c:set var="service" value="none" />
<c:set var="videoUrl" value="${contentMovieURL}" />
<c:set var="slotName" value="${pc.componentLogic.infoGlueComponent.slotName}"/>

<%
	// Setup URLs
	
	String videoUrl = (String)pageContext.getAttribute("videoUrl");
	String service = (String)pageContext.getAttribute("service");
	
	// check if youtube or vimeo url.
	if(videoUrl != null){
		if(videoUrl.contains("youtube") || videoUrl.contains("youtu.be/"))
		{
			service = "youtube";
			if(videoUrl.contains("youtu.be/")){
				videoUrl = videoUrl.substring(videoUrl.lastIndexOf("youtu.be/")+9);
			}
			else if(videoUrl.contains("&v=")){
				videoUrl = videoUrl.substring(videoUrl.lastIndexOf("&v=")+3);
			}
			else if(videoUrl.contains("?v=")){
				videoUrl = videoUrl.substring(videoUrl.lastIndexOf("?v=")+3);
			}
			else{
				service = "none";
			}
			if(videoUrl.contains("&")){
				videoUrl = videoUrl.substring(0, videoUrl.indexOf("&"));
			}
		}
		else if(videoUrl.contains("vimeo")){
			service = "vimeo";
			videoUrl = videoUrl.substring(videoUrl.lastIndexOf("vimeo.com/")+10);
			if(videoUrl.contains("/")){
				videoUrl.replace("/", "");
			}
		}
	}
    pageContext.setAttribute("service", service);
	pageContext.setAttribute("videoUrl", videoUrl);
	
	//size of the player
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

<% 
	long time = System.nanoTime();
	pageContext.setAttribute("time", time);
%>

<%--********************************************--%>
<%--*             HTML for the player          *--%>
<%--********************************************--%>
	<c:choose>
		<c:when test="${service eq 'youtube'}">
			<%--playerapiid=ytplayer_<c:out value="${time}" />&amp;
			&amp;origin=http://www.gu.se --%>
			<iframe 
				id="ytplayer_<c:out value="${time}" />" class="slider_player youtube" width="<c:out value="${width}" />" height="<c:out value="${height}" />" 
				title="<structure:componentLabel mapKeyName="YouTubeTitle" />"
				src="http://www.youtube.com/embed/<c:out value="${videoUrl}" escapeXml="false"/>?rel=0&amp;enablejsapi=1&amp;playerapiid=ytplayer_<c:out value="${time}" />" 
				tabindex="-1" 
				frameborder="0" allowfullscreen></iframe>
		</c:when>
		<c:when test="${service eq 'vimeo'}">
			<iframe
				id="viplayer_<c:out value="${time}" />" class="slider_player vimeo" title="<structure:componentLabel mapKeyName="VimeoTitle" />" 
				src="http://player.vimeo.com/video/<c:out value="${videoUrl}" escapeXml="false"/>?title=0&amp;byline=0&amp;portrait=0&amp;api=1&amp;player_id=viplayer_<c:out value="${time}" />"
				width="<c:out value="${width}" />" height="<c:out value="${height}" />" frameborder="0" 
				tabindex="-1" 
				webkitAllowFullScreen mozallowfullscreen allowFullScreen></iframe>
		</c:when>
		<c:when test="${service eq 'none'}">
			<structure:componentLabel mapKeyName="unavailable" />
			<br />
		</c:when>
	</c:choose>
