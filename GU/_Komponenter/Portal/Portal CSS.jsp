<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c"%>
<%@ taglib uri="infoglue-content" prefix="content"%>
<%@ taglib uri="infoglue-page" prefix="page"%>

<page:pageContext id="pc" />
<content:content id="imageContent" contentId="${pc.componentLogic.infoGlueComponent.contentId}" />

ul.portalLinks {
	list-style-type: none;
	margin: 0;
}

ul.portalLinks li {
	clear: both;
	line-height: 25px;
	width: 100%;
}

ul.portalLinks li a {
	text-decoration: none;
	color: black;
	font-size: 0.75em;
}

#pageheader-list-div { 
	background-image: url("<content:assetUrl assetKey="loggedinbar_bkgrd"/>"); 
	border-top: solid 1px #000; 
	height: 30px;
}

#userPanelContainer {
	max-width: 940px;
	min-width: 500px;
	margin: 0px auto;
}

.pageheader-list {
	float: right;
	margin: 0;
} 

.pageheader-list li { 	
	float: left;
	list-style-type: none; 
}

.ph-list-text {	
	padding: 0 10px 0 10px;
	text-decoration: none; 
	font-size: 0.6875em;
	color: #000; 
} 

.pageheader-list li a:hover { 
	color: #4080b4; 
}

.ph-picture-link {
	display: block;
	width: 30px;
	height: 30px;
	margin-top: 4px;
	padding: 0 8px;
	text-align: center;
}

#headerArea {
	background-image: url("<content:assetUrl assetKey="banner_bkgrd"/>"); 
}

#ph-text-name {
	padding: 6px 10px 0 10px;
	text-transform: uppercase;
	text-decoration: none; 
	font-size: 0.6875em;
	color: #787878; 
}
<%--
#ph-phone-link {
	background-image: url("<content:assetUrl assetKey="icon_phone"/>"); 	
}

#ph-phone-link:hover {
	background-image: url("<content:assetUrl assetKey="icon_phone_hover"/>"); 	
}

#ph-phone-link:active {
	background-image: url("<content:assetUrl assetKey="icon_phone_active"/>"); 	
}
--%>

/* #ph-message-link {
	background-image: url("<content:assetUrl assetKey="icon_webmail"/>");
}

#ph-message-link:hover {
	background-image: url("<content:assetUrl assetKey="icon_webmail_hover"/>");
}

#ph-message-link:active {
	background-image: url("<content:assetUrl assetKey="icon_webmail_active"/>");
} */

/* .ph-bookmark-panel {
	background-image: url("<content:assetUrl assetKey="icon_bookmark_selected"/>"); 
}

.ph-bookmark-panel-selected {
	background-image: url("<content:assetUrl assetKey="icon_bookmark_hover"/>"); 
}

#ph-bookmark-link:hover {
	background-image: url("<content:assetUrl assetKey="icon_bookmark_hover"/>"); 
}

#ph-bookmark-link:active {
	background-image: url("<content:assetUrl assetKey="icon_bookmark_active"/>") !important; 
}

#.bookmark-panel-selected {
	background-image: url("<content:assetUrl assetKey="icon_bookmark_hover"/>") !important; 
} */

/* #ph-contact-link {
	background-image: url("<content:assetUrl assetKey="icon_person"/>"); 
}

#ph-contact-link:hover, #ph-contact-link-selected {
	background-image: url("<content:assetUrl assetKey="icon_person_hover"/>"); 
}

#ph-contact-link:active {
	background-image: url("<content:assetUrl assetKey="icon_person_active"/>"); 
} 

#ph-bookmark-close {
	background-image: url("<content:assetUrl assetKey="cross_close"/>"); 
	background-repeat: no-repeat;
	background-position: center;
	display: block;
	width: 30px;
	height: 30px;
	padding: 2px;
	position: absolute;
	right: 0px;
}

#ph-bookmark-close:hover {
	background-image: url("<content:assetUrl assetKey="cross_close_hover"/>"); 
}

#ph-bookmark-close:active {
	background-image: url("<content:assetUrl assetKey="cross_close_active"/>"); 
}
*/

#ph-bookmark-close {
	display: block;
	width: 30px;
	height: 30px;
	margin: 8px 0;
	position: absolute;
	right: 0px;
}

.ph-separator {
	background-image: url("<content:assetUrl assetKey="loggedinbar_separator"/>");
	background-repeat: no-repeat;
	width: 2px;
	height: 30px;
}

#bookmarks-container {
	position: absolute;	
	background: -moz-linear-gradient(top,  rgba(255,255,255,1) 0%, rgba(255,255,255,0) 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,rgba(255,255,255,1)), color-stop(100%,rgba(255,255,255,0))); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top,  rgba(255,255,255,1) 0%,rgba(255,255,255,0) 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top,  rgba(255,255,255,1) 0%,rgba(255,255,255,0) 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top,  rgba(255,255,255,1) 0%,rgba(255,255,255,0) 100%); /* IE10+ */
	background: linear-gradient(top,  rgba(255,255,255,1) 0%,rgba(255,255,255,0) 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#00ffffff',GradientType=0 ); /* IE6-9 */
	background-color: rgb(240,240,240);
	-webkit-box-shadow:0px 6px 12px -5px #000;
	-moz-box-shadow:0px 6px 12px -5px #000; 
	box-shadow: 0px 6px 12px -5px #000;
	-webkit-border-radius: 0 0 4px 4px;
	-moz-border-radius:  0 0 4px 4px;
	border-radius: 0 0 4px 4px;
	display: none; 
	z-index: 9999;
	width: 610px;
	margin-left: -278px;
	margin-top: -5px;
}

#bookmarks-container h2 {
	font-size: 18px;
	color: black;
	padding-bottom: 10px;
	margin-top: 0;
}

#bookmarks-container p {
	font-size: 0.75em;
	color: black;
}

#bookmarksDivider {
	background-image: url("<content:assetUrl assetKey="separator_vertical"/>"); 
	background-repeat: repeat-y;
	background-position: center;
	margin: 22px 0;
	display: table;	
}

#ph-bookmarks {
	float:left;
	width: 250px;
	margin: 10px 0px 30px 20px;
	padding-right: 33px;
}

#ph-links {
	float:left;
	width: 220px;
	margin: 10px 40px 0 40px;
}

.portalLinksForm {
	clear: both;
	padding-top: 10px;
	padding-bottom: 10px;
}

a.portalLink {
	float: left
}

a.removeLink {
	float: right;
	width: 16px;
	height: 25px;
	display: block;
	margin: 5px 0 0 0;
}

.portalLinkField {
	width: 205px;
	padding: 4px;
	margin-bottom: 5px;
}
/*
.portalButton {
	padding: 5px 15px;
	border-radius: 4px;
	border: 1px solid 
	rgb(140, 140, 140);
	background-color: 
	rgb(240, 240, 240);
	background-image: url("<content:assetUrl assetKey="loggedinbar_bkgrd"/>");
}

.portalButton:active {
	box-shadow: inset 2px 2px 5px rgba(0, 0, 0, 0.25);
}
*/
#bookmarks-container p.bookmarksInfoText {
	font-style: italic;
	font-size: 9px;
	padding-top: 20px;
	display: table;
	clear: both;
}

.bookmarkSwitch {
	position: absolute;
	right: 10px;
	bottom: 10px;
}

.bookmarkSelected:hover, .bookmarkNotSelected:hover {
	background: url("<content:assetUrl assetKey="icon_bookmark_hover"/>") no-repeat;
}

.bookmarkSelected:active, .bookmarkNotSelected:active {
	background: url("<content:assetUrl assetKey="icon_bookmark_active"/>") no-repeat;
}

#darkRow ul.linklist {
	clear: both;
}


/*------------Joakim kod--------------*/
#headerArea {
	border-top: 5px solid #fff;
	position: relative;
/*	background: #fff url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "banner_bkgrd2")") repeat-x;
 filter: progid:DXImageTransform.Microsoft.gradient(startColorstr='#fefefe', endColorstr='#f2f2f2'); 
    background: -webkit-gradient(linear, left top, left bottom, from(#fefefe), to(f2f2f2)); 
    background: -moz-linear-gradient(top,  #fefefe,  #f2f2f2); 
*/
	padding: 0 20px 20px 17px;
	border-bottom: 1px solid #2072b6;
#if($browser.isIE6())
	height:1%;
#end

	background: #f2f2f2; /* Old browsers */
background: -moz-linear-gradient(top,  #fefefe 0%, #f2f2f2 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#fefefe), color-stop(100%,#f2f2f2)); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top,  #fefefe 0%,#f2f2f2 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top,  #fefefe 0%,#f2f2f2 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top,  #fefefe 0%,#f2f2f2 100%); /* IE10+ */
background: linear-gradient(top,  #fefefe 0%,#f2f2f2 100%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fefefe', endColorstr='#f2f2f2',GradientType=0 ); /* IE6-9 */
	}

#headerArea .right {
	width: 23.5%;/**/
	max-width: 220px; 
	text-align: center;
	-webkit-box-shadow:0 1px 2px -1px rgba(0, 0, 0, 0.5);
	-moz-box-shadow:0 1px 2px -1px rgba(0, 0, 0, 0.5); 
	box-shadow: 0 1px 2px -1px rgba(0, 0, 0, 0.5);
	background: #ffffff; /* Old browsers */
background: -moz-linear-gradient(top,  #ffffff 0%, #fefefe 100%); /* FF3.6+ */
background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#fefefe), color-stop(100%,#fefefe)); /* Chrome,Safari4+ */
background: -webkit-linear-gradient(top,  #ffffff 0%,#fefefe 100%); /* Chrome10+,Safari5.1+ */
background: -o-linear-gradient(top,  #ffffff 0%,#fefefe 100%); /* Opera 11.10+ */
background: -ms-linear-gradient(top,  #ffffff 0%,#fefefe 100%); /* IE10+ */
background: linear-gradient(top,  #ffffff 0%,#fefefe 100%); /* W3C */
filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#ffffff', endColorstr='#fefefe',GradientType=0 ); /* IE6-9*/

	-moz-border-radius:  0 0 4px 4px;
    border-radius: 0 0 4px 4px;
	background: #fff;
	background-image: none;
	position: relative;
	padding: 6px 0 8px 0;
	}

#headerArea .left  {
	margin: 20px 20px 0 0;
	padding:0;
	color: #fff;
	}

#headerArea .left a  {
	margin: 0px 0 0 0;
	padding:0;
	color: #fff;
	}

#headerArea .right .left {
	display:none
	}

#headerArea .right .right {
	display:none
	}

.alertComp {border:  1px solid  #f1f1f1;
	background:#fffcd0;
	padding:15px 10px 10px 10px;
	border-left: 5px solid red;
	}


.button {
	font-size: 60%;
	font-weight: 600;
	text-shadow: none;
	width:auto;
	padding:6px 25px;
	border: 0px solid #fefefe;
	-moz-border-radius: 3px;
	border-radius: 3px;
	margin: 15px auto 25px auto;
	text-decoration: none;
	text-align: center;
	color:#484848;
	-webkit-box-shadow: 0 1px 2px rgba(0, 0, 0, 0.5);
	-moz-box-shadow:0 1px 2px rgba(0, 0, 0, 0.5);
	box-shadow:0 1px 2px rgba(0, 0, 0, 0.5);
	-webkit-transition-duration: 0s;
	-moz-transition-duration: 0s;
	transition-duration: 0s;
	-webkit-user-select:none;
	-moz-user-select:none;
	-ms-user-select:none;
	user-select:none;
	text-transform: uppercase;
	background: #f1f1f1; /* Old browsers */
	background: -moz-linear-gradient(top,  #fefefe 0%, #f1f1f1 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#fefefe), color-stop(100%,#f1f1f1)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top,  #fefefe 0%,#f1f1f1 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top,  #fefefe 0%,#f1f1f1 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top,  #fefefe 0%,#f1f1f1 100%); /* IE10+ */
	background: linear-gradient(top,  #fefefe 0%,#f1f1f1 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fefefe', endColorstr='#f1f1f1',GradientType=0 ); /* IE6-9 */
	}

.button:hover,
.button.cancel:hover {
     color:#287ec6;  
	background: #fcfcfc; /* Old browsers */
	background: -moz-linear-gradient(top,  #fcfcfc 0%, #ececec 100%); /* FF3.6+ */
	background: -webkit-gradient(linear, left top, left bottom, color-stop(0%,#fcfcfc), color-stop(100%,#ececec)); /* Chrome,Safari4+ */
	background: -webkit-linear-gradient(top,  #fcfcfc 0%,#ececec 100%); /* Chrome10+,Safari5.1+ */
	background: -o-linear-gradient(top,  #fcfcfc 0%,#ececec 100%); /* Opera 11.10+ */
	background: -ms-linear-gradient(top,  #fcfcfc 0%,#ececec 100%); /* IE10+ */
	background: linear-gradient(top,  #fcfcfc 0%,#ececec 100%); /* W3C */
	filter: progid:DXImageTransform.Microsoft.gradient( startColorstr='#fcfcfc', endColorstr='#ececec',GradientType=0 ); /* IE6-9 */
}

.button:active {
	-webkit-box-shadow: inset 0 0px 2px rgba(0, 0, 0, 0.5);
	-moz-box-shadow: inset 0 0px 2px rgba(0, 0, 0, 0.5);
	box-shadow: inset 0 0px 2px rgba(0, 0, 0, 0.5);
}

.button.cancel,
.button.cancel:active {
	color: #aaa;
}
/*------------ Slut Joakim kod--------------*/
