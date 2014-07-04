<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>

<page:pageContext id="pc"/>
<page:deliveryContext id="deliveryContext"/>

<structure:componentPropertyValue id="sliderType" propertyName="SliderType" useInheritance="false"/>
<structure:componentPropertyValue id="autoPlay" propertyName="AutoPlay" useInheritance="false"/>
<structure:componentPropertyValue id="sliderDelay" propertyName="Delay" useInheritance="false"/>

<content:content id="componentContent" contentId="${pc.componentLogic.infoGlueComponent.contentId}"/>
<content:relatedContents id="configurationContent" contentId="${componentContent.contentId}" attributeName="RelatedComponents" onlyFirst="true"/>
<c:set var="configurationContent" value="${configurationContent}" scope="request"/>

<content:boundContents id="mediaContents" propertyName="MediaContent" useInheritance="false"/>
<common:size id="mediaContentsSize" list="${mediaContents}" />

<c:set var="slotName" value="${pc.componentLogic.infoGlueComponent.slotName}" />

<%--------------------------
	Configure the player
--------------------------%>

<c:set var="sliderSpeed" value="500" />

<c:choose>
	<c:when test="${slotName eq 'top' or slotName eq '4col'}">
		<c:set var="sliderWidth" value="969" />
		<c:set var="sliderHeight" value="300" />
		<c:set var="imageExpandedWidth" value="650" />
	</c:when>
	<c:otherwise>
		<c:set var="sliderWidth" value="699" />
		<c:set var="sliderHeight" value="300" />
		<c:set var="imageExpandedWidth" value="450" />
	</c:otherwise>
</c:choose>

<%
	Integer sliderWidth 		= new Integer((String)pageContext.getAttribute("sliderWidth"));
	Integer mediaContentsSize 	= (Integer)pageContext.getAttribute("mediaContentsSize");
	
	Double imageWidth = Math.ceil(sliderWidth.doubleValue()/mediaContentsSize.doubleValue());
	pageContext.setAttribute("imageWidth", "" + imageWidth.intValue());
%>

<%------------------------
     Unique Identifier
------------------------%>

<c:set var="slotName" value="${pc.componentLogic.infoGlueComponent.slotName}"/>
<common:transformText id="cleanedSlotName" text="${slotName}" replaceString="-" replaceWithString="_"/>
<c:set var="uniqueId" value="${cleanedSlotName}_${pc.componentLogic.infoGlueComponent.positionInSlot}"/>

<script type="text/javascript">
	var pauseAutoPlay = false;
				
	function toggleAutoPlay()
	{
		if (pauseAutoPlay == false)
		{
			$(".autoPlayButton img").attr("src", "<content:assetUrl assetKey="play" />");
			pauseAutoPlay = true;
		}
		else
		{
			$(".autoPlayButton img").attr("src", "<content:assetUrl assetKey="pause" />");
			pauseAutoPlay = false;
		}
	}	
</script>

<c:choose>
	<c:when test="${sliderType eq 'normal'}">
		<c:set var="identifier" value="normal_${uniqueId}" />		
		<c:if test="${!easySliderIncluded}">
			<script type="text/javascript">
				// Define YT_ready function.
				var YT_ready = (function(){
					var onReady_funcs = [], api_isReady = false;
					/* @param func function     Function to execute on ready
					 * @param func Boolean      If true, all qeued functions are executed
					 * @param b_before Boolean  If true, the func will added to the first
												 position in the queue*/
					return function(func, b_before){
						if (func === true) {
							api_isReady = true;
							for (var i=0; i<onReady_funcs.length; i++){
								// Removes the first func from the array, and execute func
								onReady_funcs.shift()();
							}
						}
						else if(typeof func == "function") {
							if (api_isReady) func();
							else onReady_funcs[b_before?"unshift":"push"](func); 
						}
					}
				})();
				// This function will be called when the API is fully loaded
				function onYouTubePlayerAPIReady() {YT_ready(true)}
	
				// Load YouTube Frame API
				(function(){ //Closure, to not leak to the scope
				  var s = document.createElement("script");
				  s.src = "http://www.youtube.com/player_api"; /* Load Player API*/
				  var before = document.getElementsByTagName("script")[0];
				  before.parentNode.insertBefore(s, before);
				})();
			</script>
			<content:assetUrl id="easySliderJSLocation" assetKey="easySlider"/>
			<content:assetUrl id="froogaloopJSLocation" assetKey="froogaloop"/>		
			<content:assetUrl id="flowplayerJSLocation" assetKey="flowplayer"/>
			<script type="text/javascript" src="<c:out value="${flowplayerJSLocation}" />"></script>		
			<script type="text/javascript" src="<c:out value="${easySliderJSLocation}" />"></script>
			<script type="text/javascript" src="<c:out value="${froogaloopJSLocation}" />" ></script>
			<c:set var="easySliderIncluded" value="true" scope="request"/>
		</c:if>			
		<script type="text/javascript">		
		jQuery(document).ready(function(){	
			jQuery("#slider_<c:out value="${identifier}" />").easySlider({
					controlsShow: true,
					nextText: "<structure:componentLabel mapKeyName="NextButtonText" />",
					prevText: "<structure:componentLabel mapKeyName="PrevButtonText" />",
					firstText: "<structure:componentLabel mapKeyName="FirstButtonText" />",
					lastText: "<structure:componentLabel mapKeyName="LastButtonText" />",
					nextTitle: "<structure:componentLabel mapKeyName="NextButtonTitle" />",
					prevTitle: "<structure:componentLabel mapKeyName="PrevButtonTitle" />",
					firstTitle: "<structure:componentLabel mapKeyName="FirstButtonTitle" />",
					lastTitle: "<structure:componentLabel mapKeyName="LastButtonTitle" />",
					gotoTitle: "<structure:componentLabel mapKeyName="GotoButtonTitle" />",
					auto: <c:out value="${autoPlay}" />, 
					pause: <c:out value="${sliderDelay}" />,
					speed: <c:out value="${sliderSpeed}" />,
					numeric: true,
					continuous: true,
					nextButtonImage: "<content:assetUrl assetKey="next" />",
					prevButtonImage: "<content:assetUrl assetKey="previous" />"					
			});
		});		
		</script>
		
		<style>									
			.slider_container, .slider_content{
				width: <c:out value="${sliderWidth}" />px;
			}			
			
			/* Easy Slider */
			#slider_<c:out value="${identifier}" /> ul, #slider_<c:out value="${identifier}" /> li{
				margin:0;
				padding:0;
				list-style:none;
			}
			
			#slider_<c:out value="${identifier}" /> li{ 
				/* 
					define width and height of list item (slide)
					entire slider area will adjust according to the parameters provided here
				*/ 
				width:<c:out value="${sliderWidth}" />px;
				height:<c:out value="${sliderHeight}" />px;
				position:relative;
				overflow:hidden; 
			}	
		</style>
					
	</c:when> 
	<c:when test="${sliderType eq 'accordion'}">
		<c:set var="identifier" value="accordion_${uniqueId}" />
		<c:if test="${!kwicksIncluded}">
			<content:assetUrl id="kwicksJSLocation" assetKey="kwicks"/>
			<content:assetUrl id="easingJSLocation" assetKey="easing"/>
			<script type="text/javascript" src="<c:out value="${kwicksJSLocation}" />" ></script>
			<script type="text/javascript" src="<c:out value="${easingJSLocation}" />" ></script>
			<c:set var="kwicksIncluded" value="true" scope="request"/>
		</c:if>		
		
		<script type="text/javascript">
			jQuery(document).ready(function(){	
				jQuery('.kwicks_<c:out value="${identifier}" />').kwicks({
						max : <c:out value="${imageExpandedWidth}" />, 
						auto: <c:out value="${autoPlay}" />,
						pause: <c:out value="${sliderDelay}" />,
						duration: <c:out value="${sliderSpeed}" />,
						slideCount: <c:out value="${mediaContentsSize}" />,
						isVertical: false
				});
			});	
		</script>
		
		<style>			
			.accordion_content {
				width: <c:out value="${sliderWidth}" />px;
			}
			
			.accordion_overlay_text h3, .accordion_overlay_text p {
				width: <c:out value="${imageWidth-40}" />px;
			}
			
			.accordion_content li.active div.accordion_overlay_text p, .accordion_content li.active div.accordion_overlay_text h3{
				width: <c:out value="${imageExpandedWidth-40}" />px;
			}
					
			.kwicks_<c:out value="${identifier}" /> {
				/* recommended styles for kwicks ul container */
				list-style: none;
				position: relative;
				margin: 0;
				padding: 0;
			}
			
			.kwicks_<c:out value="${identifier}" /> li{
				/* these are required, but the values are up to you (must be pixel) */
				width: <c:out value="${imageWidth}" />px;
				height: <c:out value="${sliderHeight}" />px;
			
				/*do not change these */
				display: block;
				overflow: hidden;
				padding: 0;  /* if you need padding, do so with an inner div (or implement your own box-model hack) */
			}
			
			.kwicks_<c:out value="${identifier}" /> li img{
				max-width: none !important;
			}
			
			.kwicks_<c:out value="${identifier}" />.horizontal li {
				/* This is optional and will be disregarded by the script.  However, it should be provided for non-JS enabled browsers. */
				margin-right: 5px; /*Set to same as spacing option. */	
				float: left;
			}
			
			.kwicks_<c:out value="${identifier}" />.vertical  li{
				/* This is optional and will be disregarded by the script.  However, it should be provided for non-JS enabled browsers. */
				margin-bottom: 5px; /*Set to same as spacing option. */	
			}
			
			.kwicks_<c:out value="${identifier}" />.vertical #kwick_4 {
				margin-bottom: none; /* cancel margin on last kiwck (if you set a margin above) */
			}			
		</style>

		<noscript>
			<style>
				.kwicks_<c:out value="${identifier}" /> li{
					width: <c:out value="${sliderWidth}" />px;					
				}
			</style>
		</noscript>			
	</c:when>
	<c:otherwise>
		No slider type selected<br/>
	</c:otherwise>
</c:choose>



<%--********************************************--%>
<%--*             HTML for the slider          *--%>
<%--********************************************--%>

<c:choose>
	<c:when test="${pc.isDecorated}">
		<h2>Slider only works in Preview so far</h2>
	</c:when>
	<c:otherwise>
		<noscript>
			<p>
				<a href="#afterSlideShow_<c:out value="${identifier}" />"><structure:componentLabel mapKeyName="SkipSlideShow" /></a>
			</p>
		</noscript>

		<div class="slider_container">
			<c:choose>
				<%-- Normal = Easy Slider --%>
				<c:when test="${sliderType eq 'normal'}"> 
					<div class="slider_content" tabindex="0">
						<%-- Button for pausing and starting autoplay --%>
						<c:if test="${autoPlay eq 'true'}">
							<a href="javascript: toggleAutoPlay();" class="autoPlayButton" tabindex="0" title="<structure:componentLabel mapKeyName="PlayPauseAutoplayButtonTitle" />">
								<img src="<content:assetUrl assetKey="pause" />" alt="<structure:componentLabel mapKeyName="PlayPauseAutoplayButtonAlt" />" />
							</a>
						</c:if>
						<div id="slider_<c:out value="${identifier}" />">
							<ul>
								<c:forEach var="mediaContent" items="${mediaContents}" varStatus="count">
									<content:contentAttribute id="contentTitle" contentId="${mediaContent.contentId}" attributeName="Title" disableEditOnSight="true"/>
									<content:contentAttribute id="contentText" contentId="${mediaContent.contentId}" attributeName="Text" disableEditOnSight="true"/>
									<content:contentAttribute id="contentAltText" contentId="${mediaContent.contentId}" attributeName="AltText"disableEditOnSight="true"/>
									<content:contentAttribute id="netConnectionUrl" contentId="${mediaContent.contentId}" attributeName="NetConnectionUrl" disableEditOnSight="true"/>
									<content:contentAttribute id="contentMovieURL" contentId="${mediaContent.contentId}" attributeName="MovieUrl" disableEditOnSight="true"/>
									<content:contentAttribute id="contentTextOrient" contentId="${mediaContent.contentId}" attributeName="TextOrientation" disableEditOnSight="true"/>
									<structure:relatedPages id="contentIntLinks" contentId="${mediaContent.contentId}" attributeName="InternalLink"/>
									<content:contentAttribute id="contentExtLink" contentId="${mediaContent.contentId}" attributeName="ExternalLink" disableEditOnSight="true"/>
									<content:assetUrl id="contentPicture" contentId="${mediaContent.contentId}" assetKey="Picture" useInheritance="false" />
									
									<c:set var="contentMovieURL" value="${contentMovieURL}" scope="request" />
									<%
										String videoUrl = (String)pageContext.getAttribute("contentMovieURL");
										String player = "";
										// check if youtube, vimeo or flowplayer url.
										if(videoUrl != null){
											if(videoUrl.contains("youtube") || videoUrl.contains("youtu.be/") || videoUrl.contains("vimeo"))
											{
												player = "embed";
											}
											else
											{
												player = "flowplayer";
											}
										}
									    pageContext.setAttribute("player", player);										
									%>
									<c:choose>
										<c:when test="${not empty contentMovieURL}">
											<li class="movieSlide">
												<c:if test="${contentTextOrient ne 'None'}">																		
													<div class="slider_text movie_orientation">
														<h3><c:out value="${contentTitle}" /></h3>
														<p><c:out value="${contentText}" /></p>
														<c:choose>
															<c:when test="${not empty contentIntLinks}">
																<c:forEach var="contentIntLink" items="${contentIntLinks}" varStatus="count">
																	<a class="slider_link_button" href="<c:out value="${contentIntLink.url}"/>" tabindex="-1"><structure:componentLabel mapKeyName="ReadMore" /></a>
																</c:forEach>
															</c:when>
															<c:when test="${not empty contentExtLink}">
																<%
																	String extLink = (String)pageContext.getAttribute("contentExtLink");
																	if (!extLink.startsWith("http://")) 
																	{
																		extLink = "http://" + extLink;
																	}
																	pageContext.setAttribute("contentExtLink", extLink);
																%>	
																<a class="slider_link_button" href="<c:out value="${contentExtLink}"/>" tabindex="-1"><structure:componentLabel mapKeyName="ReadMore" /></a>
															</c:when>
														</c:choose>
													</div>
												</c:if>
												<a class="slider_movie" tabindex="-1">											
													<c:choose>
														<c:when test="${player eq 'embed'}">
															<common:include relationAttributeName="RelatedComponents" contentName="GU Embedplayer Slider" />
														</c:when>
														<c:when test="${player eq 'flowplayer'}">
															<c:set var="contentPicture" value="${contentPicture}" scope="request" />
															<c:set var="netConnectionUrl" value="${netConnectionUrl}" scope="request" />
															<common:include relationAttributeName="RelatedComponents" contentName="GU Flowplayer Slider" />
														</c:when>
													</c:choose>													
												</a>
											</li>
										</c:when>
										<c:otherwise>
											<%
												if (pageContext.getAttribute("contentTextOrient") != null)
												{
													String orientation = (String)pageContext.getAttribute("contentTextOrient");
													
													if(orientation.equals("Left")){															
														pageContext.setAttribute("orientationClass", "left_orientation");
													}
													else if(orientation.equals("Right")){
														pageContext.setAttribute("orientationClass", "right_orientation");
													}
													else if(orientation.equals("Top")){
														pageContext.setAttribute("orientationClass", "top_orientation");
													}
													else if(orientation.equals("Bottom")){
														pageContext.setAttribute("orientationClass", "bottom_orientation");
													}
												}
											%>
											<li>
												<c:if test="${contentTextOrient ne 'None'}">
													<div class="slider_overlay_text <c:out value="${orientationClass}"/>">
														<h3><c:out value="${contentTitle}" /></h3>
														<p><c:out value="${contentText}" /></p>
														<c:choose>
															<c:when test="${not empty contentIntLinks}">
																<c:forEach var="contentIntLink" items="${contentIntLinks}" varStatus="count">
																	<a class="slider_link_button" href="<c:out value="${contentIntLink.url}"/>"><structure:componentLabel mapKeyName="ReadMore" /></a>
																</c:forEach>
															</c:when>
															<c:when test="${not empty contentExtLink}">
																<%
																	String extLink = (String)pageContext.getAttribute("contentExtLink");
																	if (!extLink.startsWith("http://")) 
																	{
																		extLink = "http://" + extLink;
																	}
																	pageContext.setAttribute("contentExtLink", extLink);
																%>	
																<a class="slider_link_button" href="<c:out value="${contentExtLink}"/>" tabindex="-1"><structure:componentLabel mapKeyName="ReadMore" /></a>
															</c:when>
														</c:choose>
													</div>
												</c:if>
												<c:if test="${empty contentAltText}">
													<c:set var="contentAltText" value="${contentTitle}" />
												</c:if>
												<img src="<c:out value="${contentPicture}" />" alt="<c:out value="${contentAltText}" />"/>
											</li>											
										</c:otherwise>
									</c:choose>
								</c:forEach>
							</ul>
						</div>
					</div>	
				</c:when>
				<%-- Accordion = Kwicks --%>
				<c:when test="${sliderType eq 'accordion'}">
					<div class="accordion_content" tabindex="0">
						<%-- Button for pausing and starting autoplay --%>
						<c:if test="${autoPlay eq 'true'}">
							<a href="javascript: toggleAutoPlay();" class="autoPlayButton" tabindex="0">
								<img src="<content:assetUrl assetKey="pause" />" alt="<structure:componentLabel mapKeyName="PlayPauseAutoplayButtonAlt" />" title="<structure:componentLabel mapKeyName="PlayPauseAutoplayButtonTitle" />" />
							</a>
						</c:if>
						<ul class="kwicks_<c:out value="${identifier}" /> horizontal">
							<c:forEach var="mediaContent" items="${mediaContents}" varStatus="count">
								<content:contentAttribute id="contentTitle" contentId="${mediaContent.contentId}" attributeName="Title" disableEditOnSight="true"/>
								<content:contentAttribute id="contentText" contentId="${mediaContent.contentId}" attributeName="Text" disableEditOnSight="true"/>
								<content:contentAttribute id="contentAltText" contentId="${mediaContent.contentId}" attributeName="AltText"disableEditOnSight="true"/>
								<structure:relatedPages id="contentIntLinks" contentId="${mediaContent.contentId}" attributeName="InternalLink"/>
								<content:contentAttribute id="contentExtLink" contentId="${mediaContent.contentId}" attributeName="ExternalLink" disableEditOnSight="true"/>
								<content:assetUrl id="contentPicture" contentId="${mediaContent.contentId}" assetKey="Picture" useInheritance="false" />
								<li>
									<img src="<c:out value="${contentPicture}" />" alt="<c:out value="${contentAltText}" />"/>
									<div class="accordion_overlay_text">
										<h3><c:out value="${contentTitle}" /></h3>
										<p><c:out value="${contentText}" /></p>
										<c:choose>
											<c:when test="${not empty contentIntLinks}">
												<c:forEach var="contentIntLink" items="${contentIntLinks}" varStatus="count">
													<a class="slider_link_button" href="<c:out value="${contentIntLink.url}"/>"><structure:componentLabel mapKeyName="ReadMore" /></a>
												</c:forEach>
											</c:when>
											<c:when test="${not empty contentExtLink}">
												<%
													String extLink = (String)pageContext.getAttribute("contentExtLink");
													if (!extLink.startsWith("http://")) 
													{
														extLink = "http://" + extLink;
													}
													pageContext.setAttribute("contentExtLink", extLink);
												%>	
												<a class="slider_link_button" href="<c:out value="${contentExtLink}"/>" tabindex="-1"><structure:componentLabel mapKeyName="ReadMore" /></a>
											</c:when>
										</c:choose>
									</div>
								</li>
							</c:forEach>										
						</ul>
					</div>	
				</c:when>
				<c:otherwise>
					<%-- Error handling? --%>
					<!--FEL :(!-->
				</c:otherwise>
			</c:choose>	
		</div>
		<noscript>
			<a name="afterSlideShow_<c:out value="${identifier}" />"></a>
		</noscript>
	</c:otherwise>
</c:choose>