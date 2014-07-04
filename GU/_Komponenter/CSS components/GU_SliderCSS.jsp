<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ taglib uri="infoglue-content" prefix="content"%>
<%@ taglib uri="infoglue-page" prefix="page"%>

.slider_container {
	margin-bottom: 10px;
	background: rgb(70. 70, 70); /* Old browsers */
	background: -moz-linear-gradient(top,  rgba(100,100,100,1) 0%, rgba(40,40,40,1) 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(100,100,100,1)), color-stop(100%,rgba(40,40,40,1))); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top,  rgba(100,100,100,1) 0%,rgba(40,40,40,1) 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top,  rgba(100,100,100,1) 0%,rgba(40,40,40,1) 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top,  rgba(100,100,100,1) 0%,rgba(40,40,40,1) 100%); /* IE10+ */
	background: linear-gradient(to bottom,  rgba(100,100,100,1) 0%,rgba(40,40,40,1) 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#646464', endColorstr='#282828',GradientType=0 ); /* IE6-9 */
	position: relative;
	margin-bottom: 10px;
}

.col50 .slider_container {
	float: left;
}

.slider_content:focus, a.slider_link_button:focus, a.autoPlayButton:focus, .slider_movie:focus, .accordion_content:focus {
	outline: 3px solid rgb(39, 97, 143);
}

.slider_content img, a.slider_link_button:active {
	outline: none;
}
						
/*------------------------------*/
/*           Accordion          */
/*------------------------------*/

.accordion_content 
{
	border-right: 1px solid rgb(150, 150, 150);
	border-top: 1px solid rgb(150, 150, 150);
	border-bottom: 1px solid rgb(100, 100, 100);
	overflow: hidden;
}
.accordion_content li 
{
	border-left: 1px solid rgb(150, 150, 150);
	box-shadow: 0px 0px 60px rgba(0, 0, 0, 0.5);
	background-image: url("<content:assetUrl assetKey="loading" useInheritance="false" />");
	background-position: center;
	background-repeat: no-repeat;
}
.accordion_overlay_text
{
	background-color: rgba(255, 255, 255, 0.75);
	position: absolute;
	bottom: 0px;
	height: 65px;
	padding: 10px 20px;
	width: 100%;
}
.accordion_overlay_text h3
{
	margin: 0 0 5px 0;
	color: rgb(75, 75, 75);
	font-size: 12px !important;
	line-height: 100%;
	text-transform: uppercase;
}
.accordion_overlay_text p
{
	font-size: 12px !important;
	color: rgb(75, 75, 75);
	display: none;
	padding: 0;
	margin: 0;
}
.slider_link_button
{
	border-radius: 5px;
	border: 1px solid rgb(15, 15, 15);
	padding: 2px 10px;
	text-decoration: none;
	color: rgb(200, 200, 200) !important;
	text-align: center;
	margin-top: 5px;
	width: 100px;
	box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
	background: rgb(100, 100, 100); /* Old browsers */
	background: -moz-linear-gradient(top,  rgba(125,126,125,1) 0%, rgba(14,14,14,1) 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(125,126,125,1)), color-stop(100%,rgba(14,14,14,1))); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top,  rgba(125,126,125,1) 0%,rgba(14,14,14,1) 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top,  rgba(125,126,125,1) 0%,rgba(14,14,14,1) 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top,  rgba(125,126,125,1) 0%,rgba(14,14,14,1) 100%); /* IE10+ */
	background: linear-gradient(to bottom,  rgba(125,126,125,1) 0%,rgba(14,14,14,1) 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#7d7e7d', endColorstr='#0e0e0e',GradientType=0 ); /* IE6-9 */
}
.accordion_overlay_text a:active, .slider_text a:active, .slider_overlay_text a:active
{
	box-shadow: inset 3px 3px 5px rgba(0, 0, 0, 0.55);
}
.accordion_overlay_text a {
	display: none;
}
.slider_text a, .slider_overlay_text a {
	margin: 30px auto 0 auto;
	display: table;
	padding: 10px 30px;
}
.accordion_content li.active div.accordion_overlay_text p, .accordion_content li.active div.accordion_overlay_text a
{
	display: block;
}
.accordion_content li.active div.accordion_overlay_text h3
{
	font-size: 16px !important;
	font-weight: bold;
	text-transform: none;
}


/*------------------------------*/
/*             Slider           */
/*------------------------------*/

.slider_content{
	margin: 0 auto;
	position:relative;
	overflow: hidden;
}

/* image replacement */
.graphic, #prevBtn, #nextBtn, #slider1prev, #slider1next{
    margin: 0;
    padding: 0;
    display: block;
}		

/* Easy Slider */
#prevBtn a, #nextBtn a,
#slider1next a, #slider1prev a{ 
	position: absolute;
	top: 70px;
	z-index: 1000;
	background-color: rgba(255, 255, 255, 0.3);
	display: block;
	width: 48px;
	border-radius: 10px;
	border-top-left-radius: 10px;
	border-top-right-radius: 10px;
	border-bottom-right-radius: 10px;
	border-bottom-left-radius: 10px;
	padding: 20px;
	height: 100px;
	display: none;
	box-shadow: 2px 2px 20px rgba(0, 0, 0, 0.5);
	font-size: 80px;
	color: rgba(255, 255, 255, 0.2);
	text-decoration: none;
	line-height: 90px;
}
#prevBtn a:hover, #nextBtn a:hover,
#slider1next a:hover, #slider1prev a:hover{ 
	color: rgba(255, 255, 255, 0.5);
}
a.autoPlayButton {
	position: absolute;
	right: 10px;
	bottom: 10px;
	display: none;
	z-index: 10000;
}									
#nextBtn a {
	right: -20px;
}
#prevBtn a {
	left: -20px;
	text-indent: 10px;
}
#nextBtn a img {
	display: none;
}
#prevBtn a img {
	display: none;
}
.slider_container:hover #prevBtn a, .slider_container:hover #nextBtn a, .slider_container:focus #prevBtn a, .slider_container:focus #nextBtn a {
	display: block;
}

/*------- Slider text -----*/>

.slider_text{
	float: left;
	padding: 20px;
}

.slider_text h3 {
	color: rgb(220, 220, 220);
	font-size: 24px !important;
	margin: 0px;
	line-height: 100%;
	margin-bottom: 10px;
	text-shadow: 1px 1px 4px black;
}	

.slider_text p {
	font-size: 12px !important;
	color: white;
}

.slider_movie{
	float: left;
	border: 1px solid rgb(0, 0, 0);
	margin-top: 20px;
	box-shadow: 5px 5px 20px rgba(0, 0, 0, 0.5);
	background-image: url("<content:assetUrl assetKey="loading" useInheritance="false" />");
	background-position: center;
	background-repeat: no-repeat;
}
				
.slider_overlay_text {
	background-color: rgba(0, 0, 0, 0.6);
	position: absolute;
	padding: 10px;
	width: 100%;
}
.slider_overlay_text h3 {
	color: rgb(220, 220, 220);
	font-size: 24px !important;
	margin: 0 0 8px 0;
	line-height: 100%;
}

.slider_overlay_text p {
	color: rgb(220, 220, 220);
	font-size: 12px !important;
	margin: 0px;
}

.left_orientation {
	left: 0;
	width: 200px;
	top: 0;
	bottom: 0;
}

.right_orientation {
	right: 0;
	width: 200px;
	top: 0px;
	bottom: 0;
}

.top_orientation {
	top: 0;
}

.bottom_orientation {
	bottom: 0;
}

.movie_orientation {
	margin-top: 20px;
	width: 250px;
	margin-left: 110px;
	margin-right: 20px;
	float: left;
}

.col50 .movie_orientation {
	margin-left: 60px;
}

/*------- Slider images --------*/

.slider_content ul li img {
	width: 100%;
}

/*----- Numeric controls -----*/

.slider_content:hover ol#controls, .slider_content:focus ol#controls {
	display: block;
}
ol#controls{
	margin: 0;
	padding: 10px 20px 30px 40px;
	position: absolute;
	bottom: -20px;
	left: -20px;
	display: none;
	z-index: 10000;
	background-color: rgba(255, 255, 255, 0.3);
	border-radius: 10px;
	box-shadow: 2px 2px 20px rgba(0, 0, 0, 0.5);
}
ol#controls li{
	margin:0 5px 0 5px;
	padding:0;
	float:left;
	list-style:none;
}
ol#controls li a{
	border: 1px solid rgb(0, 0, 0);
	background-color: rgb(200, 200, 200);
	padding: 7px;
	text-decoration: none;
	border-radius: 10px;
	font-size: 0;
	box-shadow: inset 2px 2px 5px rgba(0, 0, 0, 0.5);
}
ol#controls li a:hover{
	background-color: rgba(0, 81, 135, 0.1);
}
ol#controls li.current a{
	background-color: rgb(0, 81, 135);
	box-shadow: inset -2px -2px 5px rgba(0, 0, 0, 0.5), 1px 1px 3px rgba(0, 0, 0, 0.5);
}
.slider_container:hover a.autoPlayButton, .slider_content:focus a.autoPlayButton , a.autoPlayButton:focus {
	display: block;
}