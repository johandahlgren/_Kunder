/*
 * 	Easy Slider 1.7 - jQuery plugin
 *	written by Alen Grakalic	
 *	http://cssglobe.com/post/4004/easy-slider-15-the-easiest-jquery-plugin-for-sliding
 *
 *	Copyright (c) 2009 Alen Grakalic (http://cssglobe.com)
 *	Dual licensed under the MIT (MIT-LICENSE.txt)
 *	and GPL (GPL-LICENSE.txt) licenses.
 *
 *	Extended by Mikael Danell
 *	Knowit AB (2012)
 *
 *	Built for jQuery library
 *	http://jquery.com
 *
 */
 
/*
 *	markup example for $("#slider").easySlider();
 *	
 * 	<div id="slider">
 *		<ul>
 *			<li><img src="images/01.jpg" alt="" /></li>
 *			<li><img src="images/02.jpg" alt="" /></li>
 *			<li><img src="images/03.jpg" alt="" /></li>
 *			<li><img src="images/04.jpg" alt="" /></li>
 *			<li><img src="images/05.jpg" alt="" /></li>
 *		</ul>
 *	</div>
 *
 */

var players = new Array();
 
function onStateChange(event)
{
	//console.log("---------- Nu h�nde det n�got: " + aText);
	/*
		if (event == play)
		{
			onPlay();
		}
		else if (event == pause)
		{
			onPause();
		}
		if (event == finish)
		{
			onFinish();
		}
	*/
}

function onPlay()
{
}

function onPause()
{
}

function onFinish()
{
}

function fp_ready(flowplayer)
{
	var playerId = flowplayer.id();
		
	if (players[playerId] == null)
	{
		players[playerId] = flowplayer;
	}
}
 
(function($) {

	$.fn.easySlider = function(options){
	  
		// default configuration properties
		var defaults = {			
			prevId: 		'prevBtn',
			prevText: 		'Previous',
			nextId: 		'nextBtn',	
			nextText: 		'Next',
			controlsShow:	true,
			controlsBefore:	'',
			controlsAfter:	'',	
			controlsFade:	true,
			firstId: 		'firstBtn',
			firstText: 		'First',
			firstShow:		false,
			lastId: 		'lastBtn',	
			lastText: 		'Last',
			lastShow:		false,				
			vertical:		false,
			speed: 			800,
			auto:			false,
			pause:			2000,
			continuous:		false, 
			numeric: 		false,
			numericId: 		'controls',
			firstTitle: 	'Go to first slide',
			prevTitle: 		'Go to previous slide',
			nextTitle: 		'Go to next slide',
			lastTitle: 		'Go to last slide',
			gotoTitle: 		'Select slide',
			nextButtonImage: '',
			prevButtonImage: ''
		}; 
		
		var options = $.extend(defaults, options);  
								
		this.each(function() {  
			var obj 			= $(this); 
			var s 				= $("li", obj).length;
			var w 				= $("li", obj).width(); 
			var h 				= $("li", obj).height(); 
			var clickable 		= true;
			var currentSlide 	= 0;
			var inSlide 		= false;
			var selectedSlide 	= null;
						
			obj.width(w); 
			obj.height(h); 
			obj.css("overflow","hidden");
			var ts = s-1;
			var t = 0;
			$("ul", obj).css('width',s*w);		

			//------------------------------------------------------------------
			// Clone the first and last slides
			// In order for some of the advanced accessibility features to work 
			// the id:s of the clones must be changed because the logic doesn't
			// work if multiple elements have the same id:s.
			//------------------------------------------------------------------

			if(options.continuous){
				var lastChild = $("ul li:last-child", obj).clone();
				lastChild.css("margin-left","-"+ w +"px");
				$(lastChild).removeClass("movieSlide");
				$("a", lastChild).removeClass("slider_movie");
				$("iframe", lastChild).attr("id", "dummy");
				$("div.flowplayerContainer", lastChild).attr("id", "dummy");
				$("ul", obj).prepend(lastChild);

				var firstChild = $("ul li:nth-child(2)", obj).clone();
				$(firstChild).removeClass("movieSlide");
				$("a", firstChild).removeClass("slider_movie");
				$("iframe", firstChild).attr("id", "dummy");
				$("div.flowplayerContainer", firstChild).attr("id", "dummy");
				$("ul", obj).append(firstChild);
				$("ul", obj).css('width',(s+1)*w);
			};				

			if(!options.vertical) $("li", obj).css('float','left');

			//-------------------------
			// Previous / next buttons
			//-------------------------
								
			if(options.controlsShow){
				var html = options.controlsBefore;				
				if(options.firstShow) html += '<span id="'+ options.firstId +'"><a href=\"javascript:void(0);\" tabindex=\"-1\" title=\"' + options.firstTitle + '\">' + options.firstText + '</a></span>';
				html += ' <span id="'+ options.nextId +'"><a href=\"javascript:void(0);\" tabindex=\"-1\" title=\"' + options.nextTitle + '\"><img src=\"' + options.nextButtonImage + '\" alt=\"' + options.nextTitle + '\"/>'+ options.nextText +'</a></span>';
				html += ' <span id="'+ options.prevId +'"><a href=\"javascript:void(0);\" tabindex=\"-1\" title=\"' + options.prevTitle + '\"><img src=\"' + options.prevButtonImage + '\" alt=\"' + options.prevTitle + '\"/>'+ options.prevText +'</a></span>';
				if(options.lastShow) html += ' <span id="'+ options.lastId +'"><a href=\"javascript:void(0);\" tabindex=\"-1\" title=\"' + options.lastTitle + '\" >' + options.lastText + '</a></span>';				
				html += options.controlsAfter;						
				$(obj).before(html);
				
				if(options.numeric){
					var imageSelectors = '<ol id="'+ options.numericId +'"></ol>';
					$(obj).after(imageSelectors);
				}										
			};
			
			$("a", "#" + options.nextId).click(function(){		
				animate("next",true);
			});
			$("a", "#" + options.prevId).click(function(){		
				animate("prev",true);				
			});	
			$("a", "#" + options.firstId).click(function(){		
				animate("first",true);
			});				
			$("a", "#" + options.lastId).click(function(){		
				animate("last",true);				
			});
			
			//-------------------------
			// "Jump to slide" buttons
			//-------------------------
			
			if(options.numeric){									
				for(var i = 0 ; i < s; i++){						
					$(document.createElement("li"))
						.attr('id',options.numericId + (i+1))
						.html('<a rel='+ i +' href=\"javascript:void(0);\" tabindex=\"-1\" title="' + options.gotoTitle + ' ' + (i+1) + '">'+ (i+1) +'</a>')
						.appendTo($("#"+ options.numericId))
						.click(function(){							
							animate($("a",$(this)).attr('rel'),true);
						}); 												
				};							
			}
			
			//-----------------------------------------------
			// Bind mouseover, mouseleave and blur events to 
			// handle autoplay on / off and reset some stuff
			//-----------------------------------------------
			
			obj.parent().bind("mouseover", function() {
				if(options.auto){;
					clearTimeout(timeout);
				};
				obj.parent().focus();
			});	
			
			obj.parent().bind("mouseleave", function() {
				if(!pauseAutoPlay){
					if(options.auto){;
						timeout = setTimeout(function(){
							animate("next",false);
						},options.pause);
					};
				}
				obj.parent().blur();
			});
			
			obj.parent().bind("blur focus", function() {
				inSlide = false;
			});

			//------------------------------------------------------------------
			// Prevent the page from scrolling when pressing the cursor buttons
			// when the slider div has the focus
			//------------------------------------------------------------------
						
			obj.parent().bind("keydown keypress", function(event) {
				if (event.which >= 37 && event.which <= 40)
				{
					event.preventDefault();
				}
			});

			//------------------------------------------------------------------
			// Capture the keypress events when the user navigates in the slider
			//------------------------------------------------------------------
			
			obj.parent().bind("keyup", function(event) {
				selectedSlide = $("li", obj).eq(parseInt(currentSlide) + 1);
				if (event.which == 37) // Left arrow
				{
					if (inSlide == false)
					{
						animate("prev",false);
					}
					else
					{
						var linkElement = $("a.slider_link_button", selectedSlide);
						if (linkElement.length > 0)
						{
							linkElement.focus();
						}
					}
				}
				else if (event.which == 39) // Right arrow
				{
					if (inSlide == false)
					{
						animate("next",false);
					}
					else
					{
						var movieContainer = $("a.slider_movie", selectedSlide);
						if (movieContainer.length > 0)
						{
							movieContainer.focus();
						}
					}
				}
				else if (event.which == 38) // Up arrow
				{
					selectedSlide.parent().parent().parent().focus();
					inSlide = false;
				}
				else if (event.which == 40) // Down arrow
				{
					var linkElement = $("a.slider_link_button", selectedSlide);
					var movieContainer = $("a.slider_movie", selectedSlide);
					if (movieContainer.length > 0)
					{
						movieContainer.focus();
						inSlide = true;
					}
					else if (linkElement.length > 0)
					{
						linkElement.focus();
						inSlide = true;
					}
				}
			});
			
			//-----------------------------------------------
			// Enter button pressed when the movie has focus
			// This should start or pause the video
			//-----------------------------------------------
			
			var sliderMovieObjects = $("a.slider_movie", obj);
			sliderMovieObjects.bind("keyup", function(event) {
				if (event.which == 13) // Enter button
				{
					var selectedSlide 		= $("li", obj).eq(parseInt(currentSlide) + 1);
					
					//------------------------------------------
					// If the player uses an iframe it's either
					// a Youtube or a Vimeo player
					//------------------------------------------
					
					var selectedPlayer 		= $("iframe", selectedSlide);
					
					if (selectedPlayer.length > 0)
					{
						var selectedPlayerId 	= selectedPlayer.attr("id");
						var player 				= players[selectedPlayerId];
						
						//-----------------------------------
						// If the player is a Youtube player
						//-----------------------------------
						
						if (selectedPlayerId.indexOf("ytplayer") >= 0)
						{
							if(player.getPlayerState() == YT.PlayerState.PLAYING)
							{
								player.pauseVideo();
							}
							else
							{
								player.playVideo();
							}
						}
						
						//-----------------------------------
						// If the player is a Vimeo player
						//-----------------------------------
						
						else if (selectedPlayerId.indexOf("viplayer") >= 0)
						{
							player.api("paused", function (paused, playerId) {
								if(!paused)
								{
									player.api("pause");
								}
								else
								{
									player.api("play");
								}
							});
						}
					}
					
					//-----------------------------------
					// Assuming this is a Flowplayer
					//-----------------------------------
					
					else 
					{
						var selectedPlayer 		= $("div.flowplayerContainer", selectedSlide);
						var selectedPlayerId 	= selectedPlayer.attr("id");
						var player 				= players[selectedPlayerId];
						
						player.toggle();
					}
				}
			});
			
			//----------------------------------------------
			//
			//
			// Setup controls for YouTube and Vimeo players
			//
			//
			//----------------------------------------------

			//---------------------------
			// Initialize YouTube-player
			//---------------------------
			
			YT_ready(function() {
				var ytPlayers = $("div.slider_container li.movieSlide iframe[id*='ytplayer']");
								
				$.each(ytPlayers, function(index, ytPlayer) {
					var playerId = $(ytPlayer).attr("id");
					var newPlayer = new YT.Player(playerId, {
						events: {
							'onStateChange': onStateChange
						}
					});

					if (players[playerId] == null)
					{
						players[playerId] = newPlayer;
					}
				});
			});
			
			//-------------------------
			// Initialize Vimeo player
			//-------------------------
			
			var viPlayers = $("div.slider_container li.movieSlide iframe[id*='viplayer']");
												
			$.each(viPlayers, function(index, viPlayer) {
				var playerId = $(viPlayer).attr("id");
				var newPlayer = $fr($("#" + playerId)[0]);

				newPlayer.addEvent('ready', function() {			
					newPlayer.addEvent('play', onPlay);
					newPlayer.addEvent('pause', onPause);
					newPlayer.addEvent('finish', onFinish);
				});	

				if (players[playerId] == null)
				{
					players[playerId] = newPlayer;
				}
			});
			
			//-------------------------
			// Initialize Flowplayer
			//-------------------------
			
			// Flowplayers are initialized by the method fp_ready() defined above.
			
		
			//---------------------------------------
			//
			//
			//            Utility methods
			//
			//
			//---------------------------------------
						
			function setCurrent(i){
				currentSlide = i;
				i = parseInt(i)+1;
				$("li", "#" + options.numericId).removeClass("current");
				$("li#" + options.numericId + i).addClass("current");
			};
			
			function adjust(){
				if(t>ts) t=0;		
				if(t<0) t=ts;	
				if(!options.vertical) {
					$("ul",obj).css("margin-left",(t*w*-1));
				} else {
					$("ul",obj).css("margin-left",(t*h*-1));
				}
				clickable = true;
				if(options.numeric) setCurrent(t);
			};
			
			function animate(dir,clicked){
				if (clickable){
					clickable = false;
					var ot = t;				
					switch(dir){
						case "next":
							t = (ot>=ts) ? (options.continuous ? parseInt(t)+1 : ts) : parseInt(t)+1;						
							break; 
						case "prev":
							t = (t<=0) ? (options.continuous ? t-1 : 0) : t-1;
							break; 
						case "first":
							t = 0;
							break; 
						case "last":
							t = ts;
							break; 
						default:
							t = dir;
							break; 
					};	
					var diff = Math.round(Math.abs(ot-t) / 2);
					var speed = diff * options.speed;
										
					if(!options.vertical) {
						p = (t*w*-1);
						$("ul",obj).animate(
							{ marginLeft: p }, 
							{ queue:false, duration:speed, complete:adjust }
						);				
					} else {
						p = (t*h*-1);
						$("ul",obj).animate(
							{ marginTop: p }, 
							{ queue:false, duration:speed, complete:adjust }
						);
					};
					
					if(!options.continuous && options.controlsFade){					
						if(t==ts){
							$("a","#"+options.nextId).hide();
							$("a","#"+options.lastId).hide();
						} else {
							$("a","#"+options.nextId).show();
							$("a","#"+options.lastId).show();					
						};
						if(t==0){
							$("a","#"+options.prevId).hide();
							$("a","#"+options.firstId).hide();
						} else {
							$("a","#"+options.prevId).show();
							$("a","#"+options.firstId).show();
						};					
					};				
					
					if(clicked) clearTimeout(timeout);
					if(options.auto && dir=="next" && !clicked){;
						timeout = setTimeout(function(){
							animate("next",false);
						}, diff * options.speed + options.pause);
					};
			
				};
				
			};
			
			//-----------------------
			// Initialize the slider
			//-----------------------
			
			var timeout;
			if(options.auto){;
				timeout = setTimeout(function(){
					animate("next",false);
				},options.pause);
			};		
			
			if(options.numeric) setCurrent(0);
		
			if(!options.continuous && options.controlsFade){					
				$("a","#"+options.prevId).hide();
				$("a","#"+options.firstId).hide();				
			};
			
			/*			
			//var playerFrames = document.getElementsByClassName("slider_player");
			var playerFrames = document.getElementsByTagName("iframe");
			var players;
			
			console.log("Number of player frames: " + playerFrames.length);
			
			if(playerFrames.length > 0) {		
				players = Array();	
				for(var i = 0; i < playerFrames.length; i++) {
					
					//-----------------------
					// Handle YouTube-player
					//-----------------------
					
					if($(playerFrames[i]).attr("id").indexOf("ytplayer") >= 0){
						(function(){
							var playerId = $(playerFrames[i]).attr("id");
							YT_ready(function(){
								var internalPlayerId = playerId;
								console.log("YT READY: " + internalPlayerId);
								new YT.Player(internalPlayerId, {
									events: {
										'onStateChange': onPlayerStateChange
									}
								});	
							});
						})();
					}
					
					//-----------------------
					// Handle Vimeo player
					//-----------------------
					
					else if($(playerFrames[i]).attr("id").indexOf("viplayer") >= 0){
						(function(){
							var viPlayerId = $(playerFrames[i]).attr("id");
							players[viPlayerId] = $fr($("#" + viPlayerId)[0]);
							// When the player is ready, add listeners for pause, finish, and playProgress
							players[viPlayerId].addEvent('ready', function() {
								var viInternalPlayerId = viPlayerId;	
								console.log("VIMEO READY: " + viInternalPlayerId);				
								players[viInternalPlayerId].addEvent('play', onPlay);
								players[viInternalPlayerId].addEvent('finish', onFinish);
							});	
						})();						
					}
					
					//-----------------------
					// Handle Flowplayer
					//-----------------------
					
					else if ($(playerFrames[i]).attr("id").indexOf("viplayer") >= 0) {			
						console.log("setting flowplayer");
						fp_ready = function(obj) {
							console.log(obj);
							$(obj).addEventListener("onStart", onPlay);
						};
						/*console.log($f);
						var fpPlayerId = $(playerFrames[i]).attr("id");
						$f().onStart( function() {
							onPlay();
						});*/
						/*$f($(playerFrames[i]).attr("id")).onStart(onFinish());
					}
				}
			}*/
			
			/*			
			function onPlayerStateChange(event) {
				if (event.data == YT.PlayerState.PLAYING) {
					onPlay();
				}
				else if(event.data == YT.PlayerState.ENDED) {
					onFinish();
				}
			}

			function onPlay() {
				if(options.auto){;
					clearTimeout(timeout);
					userInteracting = true;
				};	
			}
			
			//Inte implementerad!
			function pausePlayer() {
				player.api($(this).text().toLowerCase());
			}

			function onFinish() {
				if(options.auto){;
					timeout = setTimeout(function(){
						animate("next",false);
					},options.pause);	
				}
			}*/
		});
	  
	};

})(jQuery);