#set($cl = $templateLogic.componentLogic)
#set($browser = $templateLogic.browserBean)
#set($void = $templateLogic.deliveryContext.httpHeaders.put("Cache-Control","no-cache"))
#set($void = $templateLogic.deliveryContext.httpHeaders.put("Pragma","no-cache"))
#set($void = $templateLogic.deliveryContext.httpHeaders.put("Expires","0"))


#set($saveAdjust = $templateLogic.getRequestParameter("saveAdjust"))

#if($saveAdjust == "true")

	#set($textFontSize = $templateLogic.getRequestParameter("textFontSize"))
	#set($fontFamily = $templateLogic.getRequestParameter("fontFamily"))
	#set($textLineHeight = $templateLogic.getRequestParameter("textLineHeight"))
	#set($contrast = $templateLogic.getRequestParameter("contrast"))
	#set($wordspace = $templateLogic.getRequestParameter("wordspace"))
	#set($letterSpace = $templateLogic.getRequestParameter("letterSpace"))

#else

	#set($textFontSize = "$!templateLogic.getCookie('textFontSize')")
	#set($fontFamily = "$!templateLogic.getCookie('fontFamily')")
	#set($textLineHeight = "$!templateLogic.getCookie('textLineHeight')")
	#set($contrast = "$!templateLogic.getCookie('contrast')")
	#set($wordspace = "$!templateLogic.getCookie('wordspace')")
	#set($letterSpace = "$!templateLogic.getCookie('letterSpace')")

#end


/* ----------------------------------- */
/* ------------- BASICS -------------- */
/* ----------------------------------- */



#if($textFontSize =="1") 
	
body {
	font-size: 120%;
	}

#elseif($textFontSize =="2") 

body {
	font-size: 140%;
	}

#else

body {
	font-size: 100%;
	}

#end


html, body {
    margin: 0;
    padding: 0;
    }

body {
	background: #f8f8f7;
	line-height: 100%;
	width: 100%;
	}

#siteWidth {
	max-width: 986px;
	margin: 5px auto;
	text-align: left;
	position: relative;
#if($browser.isIE6())	
	width: expression(Math.min(parseInt(this.offsetWidth), 988 ) + "px");
#end
	}

.shadow-a {
	padding: 0 1px 1px 1px;
	background-color: #e9e8e6;
	margin-top: 3px;
#if($browser.isIE6())
	height:1%;
#end
	}

.shadow-b {
	padding: 0 1px 1px 1px;
	background-color: #d1d0ce;
#if($browser.isIE6())
	height:1%;
#end
	}

.shadow-c {
	padding: 1px 1px 1px 1px;
	background-color: #bbbbbb ;
#if($browser.isIE6())
	height:1%;
#end
	}

#pageContainer {	
	padding-bottom:5px;
	background-color: #fff;
#if($browser.isIE6())
	height:1%;
#end
	}
	
.clr {
	clear: both;
	}

.right {
	float: right;
	}

.left {
	float: left;
	}

.ingress {
	font-weight: bold;
	}

p span.citat {
	clear: both;
	display: block;
	font-style: italic;
	text-align:left;
	margin: 1em 6%;
	text-indent: 1.5em;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "citat")") no-repeat left top;
	}

h1 {
	font-weight: normal;
	margin: 0 0 0.5em 0;
	}

h2, h3, h4  {
	font-weight: normal;
	margin:1.25em 0 0.125em 0;
	}

p {
	margin: 0 0 1em 0;
	padding: 0;
	}

dt {
	margin:1.5em 0 0.5em 0;
	}

a:focus {
	outline: 3px invert solid;
	}

.searchfield:focus {
	outline: 1px invert solid;
	}

/* -------------------------------------- */
/* ---------------- LINKS --------------- */
/* -------------------------------------- */

a:hover {
	text-decoration: underline;
	}

a.rssicon,
a.fileicon,
a.excelicon, 
a.powerpointicon,
a.wordicon,
a.pdficon {
	margin:0.5em 0 0.375em 3% ;
	padding:0 0 0 21px;
	display:block;
	background-repeat: no-repeat; 
	background-position: top left;
	clear:both;
	}

.col25 a.rssicon,
.col25 a.fileicon,
.col25 a.excelicon,
.col25 a.powerpointicon,
.col25 a.pdficon,
.col25 a.wordicon {
	margin:0.5em 0 0.375em 4px ;
	}

a.wordicon {
	background-image: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "word")"); 
	}

a.pdficon {
	background-image: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "pdf")"); 
	}

a.excelicon {
	background-image: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "xls")"); 
	}

a.powerpointicon {
	background-image: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "ppt")"); 
	}

a.fileicon {
	background-image: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "file")"); 
	}

a.rssicon {
	background-image: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "rss")"); 
	}

a.nounderline {
	text-decoration:none;
	color: #484848; 
	}

a.nounderline:hover {
	text-decoration:underline;
	}

/* ----------------------------------- */
/* -------------- LISTS -------------- */
/* ----------------------------------- */

ul {
#if($browser.isIE6())
	list-style-type: disc;
#else
	list-style-type: square;
#end
	}

ul,ol {
	padding: 0;
	margin: 0 7% 10px 7%;
	padding:0;
	list-style-position: outside;
	}

ul ul,
ol ol {
	margin-left:16px;
	}

.col25 ol,
.col25 ul {
	margin-left: 26px;
	list-style-position: outside;
	}

/* -------------------------------------- */
/* --------------- TABLES --------------- */
/* -------------------------------------- */

table {
	border-spacing: 0;
	text-align: left;
	empty-cells: show;
	border-collapse: collapse;
	margin-bottom: 2em;
	}

caption {
	caption-side: top;
	text-align: left;
/*	vertical-align: bottom;
*/	padding: 1.25em 0.5em 0.5em 0;
	margin: 0;
	}

th, td {
	padding: 0.25em 0.5em 0.125em 0.5em;
	vertical-align:top;
	font-weight: normal;
	text-align: left;
	}

table.blank {
	border: 0;
	border-spacing: 0;
	text-align: left;
	empty-cells: show;
	}
	
table.blank td {
	border: 0;
	padding: 0.5em;
	vertical-align:top;
	}

table.blank th {
	border: 0;
	padding: 0.5em 0.5em 0.375em 0.5em;
	vertical-align:top;
	}

table, td, th {
	border: 1px solid #ddd;
	}

th	{
	background: #f9f9f9 url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "pageEnd")") repeat-x center center;
	}

.tableOddRow,
#gubasComp .displayInfo.tableOddRow,
#gubasDetailComp .displayInfo.tableOddRow {
	background-color: #f9f9f9;
	}

/**/
#gubasComp table th,
#gubasDetailComp table th {
	font-weight: bold;
	}

#gubasComp table td,
#gubasComp table th,
#gubasDetailComp table td,
#gubasDetailComp table th {
	border-left: 0;
	border-right: 0;
	}

#gubasComp table,
#gubasDetailComp table {
	border-left:0 ;
	border-right: 0;
	width: 100%;
	margin-bottom: 0;
	}

#gubasComp a.bottom ,
#gubasDetailComp a.bottom {
	border: 1px solid #ddd;
	padding: 2px 4px;
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "bottom")") repeat-x center bottom;
	text-decoration: none;
	color: #484848;
	}

#gubasComp a.bottom:hover,
#gubasDetailComp a.bottom:hover {
	border-color:#a3a3a3 ;
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "bottom")") repeat-x center bottom;
	}

#gubasComp a.bottom:active,
#gubasDetailComp a.bottom:active {
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "bottomActive")") repeat-x center bottom;
	}

#gubasComp a.showMore,
#gubasDetailComp a.showMore {
	padding-right: 10px;
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "pil")") no-repeat center right;
	}

#gubasComp a.current,
#gubasDetailComp a.current {
	padding-right: 10px;
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "pilCurrent")") no-repeat center right;
	}

#gubasComp td.col1,
#gubasDetailComp td.col1, 
#gubasComp td.col2,
#gubasDetailComp td.col2, 
#gubasComp td.col3,
#gubasDetailComp td.col3, 
#gubasComp td.col4,
#gubasDetailComp td.col4 
{
 	white-space: nowrap;
}

#gubasDetailComp .displayInfo {
	/*font-size: 1.1875em;*/
}

#gubasComp .displayInfo h2,
#gubasDetailComp .displayInfo h2 {
	margin: 0;
	padding: 0.5em 0 0.25em 0;
	font-size: 110%;
	}

#gubasComp .displayInfo p,
#gubasDetailComp .displayInfo p {
	margin-bottom: 0;
	padding-bottom: 0;
	}

#gubasComp .displayInfo span,
#gubasDetailComp .displayInfo span {
	text-transform: uppercase;
	font-weight: bold;
	font-size: 80%;
	}

#gubasComp .displayInfo,
#gubasDetailComp .displayInfo {
	padding: 0 0.3125em;
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "gubasTDcurrent")") no-repeat top center;
	}

/* ----------------------------------- */
/* ------------- IMAGES -------------- */
/* ----------------------------------- */

#bodyArea img { max-width: 100%; }

.col25 .imageComp img { width: 100%; margin: /*4px 0 10px*/ 0;}

.img_left_s { width:30%; }
.img_left_m { width:40%; }
.img_left_l { width:50%; }
.img_left_xl { width:60%; }
.img_right_s { width:30%; }
.img_right_m { width:40% }
.img_right_l { width:50%; }
.img_right_xl { width:60%; }
	
#if($browser.isOpera()) /*v1 class*/
	.img_left_small { width:111px; }
	.img_left_medium { width:148px;}
	.img_left_large { width:185px; }
	.img_left_xlarge { width:222px;  }
	.img_right_small { width:111px;}
	.img_right_medium { width:148px;}
	.img_right_large { width:185px; }
	.img_right_xlarge { width:222px; }
#else/*v1 class*/
	.img_left_small { width:24.2%; }
	.img_left_medium { width:32.2%; }
	.img_left_large { width:40.3%; }
	.img_left_xlarge { width:48.3%; }
	.img_right_small { width:24.2%; }
	.img_right_medium { width:32.2% }
	.img_right_large { width:40.3%; }
	.img_right_xlarge { width:48.3%; }
#end

.img_left_s,
.img_left_m,
.img_left_l,
.img_left_xl,
.img_left_small,
.img_left_medium,
.img_left_large,
.img_left_xlarge {
	float:left;
	padding:0;
	margin: 0.3125em 2% 0.3125em 0;
	}

/*.col50 img,
.articleComp .col50 img {
	margin: 0.3125em 2% 0.3125em 0;
	}
*/
.img_right_s,
.img_right_m,
.img_right_l,
.img_right_xl,
.img_right_small,
.img_right_medium,
.img_right_large,
.img_right_xlarge {
	float:right; 
	padding:0;
	margin: 0.3125em 0 0.3125em 2%;
	}

.col25 .imageComp img {
	border: none;
	}

.col25 .textComp img {
	margin: 0.3125em 0.3125em 0.3125em 0;
	}

/* --------------- OLD CLASSES --------- */

.img_left_letter,
.img_left_portrait { float:left; padding:0; }
	
.img_right_letter,
.img_right_portrait { float:right; padding:0; }

.img_left_portrait,
.img_left_letter { text-align: left; margin: 0.3125em 2% 0.3125em 0; }

.img_right_portrait,
.img_right_letter {	text-align: left; margin: 0.3125em 0 0.3125em 2%; }

.img_clear { clear:right; margin: 0 0 2% 0; }

/* ----------------------------------- */
/* ------------- HEADER -------------- */
/* ----------------------------------- */
/*
#home p {
	padding: 0 22px;
	margin: 0;
	}
*/
#home a {
	text-decoration: none;
	}

#home a:hover {
	text-decoration: underline;
	}

#headerArea .right ul.linklist {
	padding:  0;
	margin: 0;
	}
	
#home ul.linklist li,
#headerArea .right .linklist li {
	display: inline;
	list-style-type: none;
	padding:0 3px 0 8px;
	margin: 0;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "linkDivider")") no-repeat left center;
	}

#home ul.linklist li.first,
#headerArea .right .linklist li.first,
.linklist li.first {
	padding-left: 0;
	background-image: none;
	}

#home ul.linklist li.last,
#headerArea .right .linklist li.last {
	padding-right: 0;
	}

#headerArea a {
	text-decoration: none;
	}

#headerArea a:hover {
	text-decoration: underline;
	}

#headerArea a img {
	border: none;
	}

#darkRow a {
	text-decoration: none;
	}
	
#darkRow a:hover {
	text-decoration: underline;
	}

#darkRow {
	padding: 0 20px 0 20px;	
	border-top: 2px solid #000;
	background: #191919 url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "crumbtrailBottomLine")") repeat-x center bottom;
	}

#darkRow ul.linklist {
	width: 74.5%;
	max-width: 700px;
	float: left;
	padding: 0;
	margin: 0;
	}

#darkRow ul.linklist li  {
	float: left;
	list-style-type: none;
	line-height: 120%;
	}

#darkRow .sitename,
#darkRow h1 {
	font-weight: normal;
	float: left;
	line-height: 120%;
	}

a.divider {
	padding:0 8px 0 0;
	margin: 0;
background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "linkDivider_white")") no-repeat right center;
font-size: 0.6875em;
	}

form.search {
	width: 23.5%;
	max-width: 220px;
	text-align: center;
	float: right;
	}

#darkRow .linklist li.current {
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "top_current")") no-repeat center bottom;
	}

form.search label,
form.search a {
	font-weight: bold;
	text-transform: uppercase;
	}

/* OLD VERSION	
form.search .searchfield {
#if($browser.isIE())	
	width: 45%;
#else
	width: 50%;
#end
	border: 0;
	}
*/

form.search .searchfield {
#if($browser.isIE())	
	width: 55%;
#else
	width: 60%;
#end
	border: 0;
	font-size:70%;
	color:#474747;
	}



#crumbtrailComp {
	margin: -5px 0 0 0 ;
	border-bottom: 2px solid #000;
	}

#crumbtrailComp ul {
	padding: 6px 15px 3px 15px;
	width: 83%;
	margin: 0;
	float: left;
	}
	
#crumbtrailComp li {
	display: inline;
	margin: 0;
	padding:0;
	}

#crumbtrailComp li a {
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "pil")") right center no-repeat;
	margin-right: 5px;
	padding:0 11px 0 0;
	text-decoration: none;
	}

#crumbtrailComp li a:hover {
	text-decoration: underline;
	}

#crumbtrailComp li.current {
	font-weight: bold;
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "crumbtrailBottomLine")") repeat-x center bottom;
/*	margin-left: 3px;*/
#if($browser.isSafari())	
	padding-bottom: 6px;
#elseif($browser.isIE())	
	padding-bottom: 6px;
#else
	padding-bottom: 5px;
#end	

	}


#sitemap {
#if($browser.isSafari())
	margin:7px 14px 0 15px;
	padding: 2px 0 0 15px;
#else
	margin:9px 14px 0 15px;
	padding: 0 0 0 15px;
#end
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "sitemap")") no-repeat left center ;
	float: right;
	text-decoration: none;
	}

#sitemap:hover {
	text-decoration: underline;
	}

/* ----------------------------------- */
/* ------------ BODY AREA ------------ */
/* ----------------------------------- */

#bodyArea {
	margin: 5px 5px 0 5px;
	padding: 0 0 0 0;
#if($browser.isIE6())
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "pageEnd")") repeat-x center bottom;
#else
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "pageEndTrans")") repeat-x center bottom;
#end
	border-bottom: 1px solid #cdcdcd;
	}

/* ----------------------------------- */
/* ------------- PAGE END ------------ */
/* ----------------------------------- */

#contentEnd {
	margin-top: 3em;
	margin-bottom: 2em;
	}

a#uplink {
	padding-left: 20px;
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "uplink")") no-repeat left center;
	}

a#share {
	padding-left: 20px;
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "share")") no-repeat left center;
	}

#byline {
	border-top: 1px solid #000;
	margin-top: 0.5em;
	}

#byline p {
	margin-top: 0.5em;
	}

#byline p.right {
	text-align: right;
	}

/* ----------------------------------- */
/* --------- LEFT MENU COMP ---------- */
/* ----------------------------------- */

#bodyArea #menuComp ul#menu {
	list-style-type: none;
	margin: 0;
	padding: 0;
	list-style-position: inherit;
	}

#bodyArea #menuComp ul#menu li {
	border-bottom: 1px solid #d4d4d4;
	}

#bodyArea #menuComp ul#menu li a {
	display: block;
	padding:0.4375em 15px 0.5em 0px ;
	text-decoration: none;
	}

#bodyArea #menuComp ul#menu li a:hover {
	text-decoration: underline;
	}

#bodyArea #menuComp ul#menu li a.submenu {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "submenu")") right center no-repeat;
	}

#bodyArea #menuComp ul#menu li a.submenu:hover {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "submenuHover")") right center no-repeat;
	}

#bodyArea #menuComp h1#menuLevel {
	padding:0 0 0.375em 0px ;
	margin: 0;
	margin-top: 1.25em;
	border-bottom: 1px solid #d4d4d4;
	}

#bodyArea #menuComp h1#menuLevel a {
	text-decoration: none;
	}

#bodyArea #menuComp h1#menuLevel a:hover {
	text-decoration: underline;
	}

#bodyArea #menuComp ul#menu li a.current {
	padding-left: 20px;
	position: relative;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "current")") no-repeat left center;
#if($$browser.isIE())
	left: -21px;
#else
	left: -20px;
#end
	}

/* ----------------------------------- */
/* ------------- COLUMNS ------------- */
/* ----------------------------------- */

.col25 {
#if($browser.isOpera())
	width: 23%;
#else
	width: 22.69%;
#end
	max-width: 220px;
	}

.col50 {
#if($browser.isOpera())
	width: 48%;
#elseif($browser.isIE6())
	width:460px;
#else
	width: 47.5%;
#end
	max-width: 460px;
	}

.col75 {
#if($browser.isOpera())	
	width: 73%;
#else
	width: 72.18%;
#end
	max-width: 700px;
	}

.col25,
.col50,
.col75,
.col100 {
	float: left;
#if($browser.isIE6())
	padding:15px 5px 0 15px;
#else
	margin:15px 0.55% 0 1.55%;
#end
	}

.col100 {
	width: 96.95%;
	max-width: 940px;
	}

/* ----------------------------------- */
/* ------------ FOOT AREA ------------ */
/* ----------------------------------- */

#footerArea {
	margin: 0 24px 10px 24px;
	}

#footerArea p {
	margin-top: 0.5em;
}

/* ----------------------------------- */
/* ---------- STARTPAGE SITE --------- */
/* ----------------------------------- */

#profilComp {
	width: 100%;
	background-color: #eee;
	border-bottom: 2px solid #000;
	padding: 0;
	margin: 0;
	position: relative;
	}

#profilComp #vinjett75 {
	float: left;
	width: 74.48%;
	max-width: 722px;
	border-right: 5px solid #fff;
/*	height: 300px;*/
	min-height: 300px;
	}

#profilComp img#vinjett100 {
	float: left;
	margin: 0;
	padding: 0;
	width: 100%;
/*	height: 300px;*/
	}

#profilComp #linkCollection {
	width: 24.96%;
	max-width: 243px;
	float: right;
	right: 0;
	top: 0;
	}

#profilComp #linkCollection ul.collapsablemenu {
	display: none;
	width: 205px; 
	z-index: 1000; 
  	background-color: #fff; 
  	text-align: left; 
  	list-style:none; 
	margin: -1px 16px 0 0;
	border: 1px solid #7d7d7d;
  	border-top: 0;
  	position: absolute;
	}

#profilComp #linkCollection .collectionlinkgroup ul {
	margin-top: -9px;
	}

#profilComp #linkCollection .collapsablemenu li {
	margin: 0;
	padding: 0;
	border-top: 1px solid #dfdfdf;
	}

#profilComp #linkCollection .collapsablemenu a {
	background: none;
	text-decoration: none;
	display: block;
	padding: 1px 5px;
	}

#profilComp #linkCollection .collapsablemenu li a:hover {
	background-color: #f1f1f1;
	}

#profilComp #linkCollection .collapsed .collapsablemenu {
	visibility: hidden;
	}

#profilComp h1 {
	margin: 0 0 0.5em 0;
	padding: 0;
	}

#profilComp #linkCollection h2 {
	background: #fff url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "dropdown")") no-repeat right center;
	font-weight: normal;
	padding: 1px 20px 1px 5px;
	margin: 0 0 0.75em 0;
	display: block;
	width: auto;
	border: 1px solid #7d7d7d;
	}

#profilComp #linkCollection h2 a {
	text-decoration: none;
	}
	
#profilComp #shortcuts {
	border-bottom: 5px solid #fff;
	padding: 18px 18px 14px 18px;
	}

#profilComp #targetGroups {
	padding: 18px 28px 5px 18px ;
	}

#profilComp #targetGroups ul {
	list-style-type: none;
	list-style-position: outside;
	margin: 0;
	padding: 0;
	}

#profilComp #targetGroups li {
	padding: 0 0 0.25em 0;
	margin: 0;
	}

/* -------------------------------------- */
/* ------------- CUSTOMIZE -------------- */
/* -------------------------------------- */

#customizeComp {
	margin:0 ;
	position: relative;
	padding: 0.5em 5px 1.5em 5px; 
	width: auto;
	border-bottom: 1px solid #ebebeb;
	border-top: 5px solid #3364af;
	background-color: #fff;
	}

#customizeComp .col50 {
	margin-top: 0;
	padding-top: 0;
	}

#customizeComp .col50 form {
	margin-top: 0;
	padding-top: 2.5em;
	}
	
#customizeComp form {
	margin:0; 
	padding:0; 
	}

#customizeComp legend {
	display:none; 
	}

#customizeComp label,
#customizeComp select {
	padding:0;
	margin:0;
	}

#customizeComp select {
	width:100%;
	}

#customizeComp .fieldrow {
	width:46%;
	padding-left:4%;
	float:right;
	margin-bottom: 0.5em;
	}

#customizeComp .button {
	float:right;
	margin:1em 0 0 1em;
	}

span.contrast,
span.textFontSize,
span.textLineHeight,
span.wordspace,
span.letterSpace,
span.fontFamily,
p.customizeNote {
	font-weight:bold;
	}

#customizeComp .customizeNote p{
	margin: 1em 0 0 0;
	}

/* -------------------------------------- */
/* ------------ COMP BASICS ------------- */
/* -------------------------------------- */
.eventCategorySelectComp h1,
.eventSearchComp h1,
.dateSpanSelectComp h1,
.graphicCalComp h1,
.col25 #gubasComp.search h1,
.col25 #gubasContactApp h1,
.newsPushComp h1,
.rssPushComp h1,
.calPushComp h1,
.contactComp h1,
.textComp h1 {
	display: block;
	padding: 0 0 1px 5px;
	margin-top: 0;
	font-weight: normal;
	border-bottom: 1px solid #061224;
	border-left: 2px solid #061224;
	}

.eventCategorySelectComp,
.eventSearchComp,
.dateSpanSelectComp,
.graphicCalComp,
.col25 #gubasComp.search,
.imageComp,
.newsListComp,
/*.calListComp,*/
.newsPushComp,
.rssPushComp,
.calPushComp,
.contactComp,
.textComp,
.col25 .adComp,
.col25 .articleComp {
	margin-bottom: 2em;
	margin-top: 1.25em;
	}

.contactComp h2,
.textComp h2 {
	font-weight: bold;
	}

.col50 .newsPushComp h1,
.col50 .calPushComp h1,
.col50 .contactComp h1,
.col50 .textComp h1 {
	padding:0 0 0 5px;
	}

.col100 h1,
.col75 h1,
.col50 h1 {
	margin-bottom: 0.25em;
	margin-top: 0.5em;
	display: block;
	}

.col50 .newsListComp p,
.col50 .calListComp p {
	padding: 0;
	margin: 0 0 10px 0;
	}

/* -------------------------------------- */
/* ------------ SITEMAP COMP ------------ */
/* -------------------------------------- */

#bodyArea .sitemapComp {
	margin-bottom: 5em;
	}

#bodyArea .sitemapComp ul {
	font-weight: bold;
	list-style-type: none;
	}

#bodyArea .sitemapComp ul {
	margin-bottom: 1.375em;
	margin-left: 0;
	}

#bodyArea .sitemapComp ul li a.toplevel {
	margin-top:1.25em; 
	margin-bottom:0.25em; 
	display: block;
	}

#bodyArea .sitemapComp ul ul {
	font-weight: normal;
	list-style-type: none;
	margin-top: 0;
	margin-bottom: 0;
	margin-left:8px;
	}

#bodyArea .sitemapComp ul ul ul {
	font-weight: normal;
	list-style-type: none;
	margin-top: 0;
	margin-bottom: 0;
	margin-left:13px;
	}

#bodyArea .sitemapComp ul ul li a {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "tree")") no-repeat left center;
	padding-left:12px;
	}

/*
.sitemapComp .col50#c2,
.sitemapComp .col50#c4,
.sitemapComp .col50#c6,
.sitemapComp .col50#c8,
.sitemapComp .col50#c10,
.sitemapComp .col50#c12,
.sitemapComp .col50#c14,
.sitemapComp .col50#c16,
.sitemapComp .col50#c18,
.sitemapComp .col50#c20,
.sitemapComp .col50#c22,
.sitemapComp .col50#c24,
.sitemapComp .col50#c26,
.sitemapComp .col50#c28,
.sitemapComp .col50#c30 {
	margin-left: 0;
	padding-left: 0;
	clear: right;
	}
*/
/*
.sitemapComp .col50#c1,
.sitemapComp .col50#c3,
.sitemapComp .col50#c5,
.sitemapComp .col50#c7,
.sitemapComp .col50#c9,
.sitemapComp .col50#c11,
.sitemapComp .col50#c13,
.sitemapComp .col50#c15,
.sitemapComp .col50#c17,
.sitemapComp .col50#c19,
.sitemapComp .col50#c21,
.sitemapComp .col50#c23,
.sitemapComp .col50#c25,
.sitemapComp .col50#c27,
.sitemapComp .col50#c29{
	clear: both;
	}
*/
/* -------------------------------------- */
/* --------------- FORMS ---------------- */
/* -------------------------------------- */

input {
	margin: 0;
	padding: 0;
	padding-left:2px;
	}

label {
	font-weight:normal;
	}

legend {
	padding:1.25em 0 0 0;
	margin: 0;
	font-weight: normal;
	}

fieldset {
	border: 0;
	padding: 0;
	margin: 0;
	}

select {
	width: 50%;
	}

#bodyArea input,
#bodyArea textarea,
#bodyArea select {
	margin: 0 0 1.25em 0;
	}

#bodyArea input.button {
	margin: 0.75em 0 0.5em 0;
	display: block;
	}

.fullwidth {
	width: 99%;
	}

textarea.small,
textarea.medium,
textarea.large {
	height: 7em; 
	}

textarea.small,
select.small,
input.small {
	width: 30%;
	}

textarea.medium,
select.medium,
input.medium {
	width: 70%;
	}

textarea.large,
select.large,
input.large {
	width: 95%;
	}

select.adjust {
        width: auto;
}

input:focus,
textarea:focus {
	background-color: #fffbdf;
	}

.col50 .red,
#calendarComp .red {
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "star")") no-repeat right center;
	padding: 0 12px 0 0;
    zoom: 1;
	}

#calendarComp p .red {
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "star")") no-repeat left center;
	padding: 0 0 0 12px;
    zoom: 1;
	}

/* -------------------------------------- */
/* -------------- SLOT LIST ------------- */
/* -------------------------------------- */

ul.slotlist {
	margin-left: 0;
	padding-left: 0;
	}

ul.slotlist li {
	display: inline;
	margin: 0 0.25em;
	font-weight: bold;
	}

ul.slotlist li:first-child {
	margin-left: 0;
	}

ul.slotlist li.current {
	border: 1px solid #484848;
	padding: 0 0.5em;
	}

/* -------------------------------------- */
/* -------------- AD COMP --------------- */
/* -------------------------------------- */

.col25 .adComp {
	margin: 30px 0 0 0;
	padding: 0;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "pageEnd")") repeat-x center bottom;
	clear: both;
	border: 1px solid #eee;
	border-bottom: 1px solid #cdcdcd;
	}

/*
.col25 .adComp {
	border: 1px solid #eee;
	border-bottom: 1px solid #cdcdcd;
	background-image: none;
	}
*/

.adComp {
	margin: 2em 0 15px 0;
	padding: 5px 15px 0 15px;
	clear: both;
	}

.adComp .col25 {
#if($browser.isOpera())
	width: 25%;
#elseif($browser.isFirefox())/*firefox klarar zoom ut battre*/
	width: 24.75%;
#else
	width: 24.8%;
#end
	max-width:233px;
	}

.adComp .col50 {
#if($browser.isOpera())
	width: 50%;
#else
	width: 49.8%;
#end
	max-width:468px;
	}

.adComp .col25 img,
.col25 .adComp img,
.col50 .adComp img {
	margin: 0;
	}
	
.adComp .col25,
.adComp .col50 {
	border-left: 1px solid #fff;
	border-right: 1px solid #eee;
	padding: 0 0 0 0;
#if($browser.isIE6())
	height: 220px;
#else
	height: 223px;
#end
	margin: 0;
	}

.adComp p {
	padding: 0 15px;
	margin: 5px 0 20px 0;
	}

.adComp h1 {
	padding: 15px 15px 0 15px;
	margin: 0;
	}

.adComp img {
	width: 100%;
	}

.adComp #first {
	border-left: 1px solid #eee;
	padding-left: 0px;
	}
/*
.adComp #last {
	border-right: 1px solid #eee;
	padding-right: 0px;
	}
*/
/* -------------------------------------- */
/* ------------ PARTNER COMP ------------ */
/* -------------------------------------- */

#partnerComp {
	border-top: 2px solid #000;
	margin: 5px 0 -5px 0 ;
	padding: 10px 5px 40px 5px;
	}

#partnerComp h1 {
	text-transform: uppercase;
	font-weight: bold;
	margin: 0 15px 0px 15px;
	padding: 0;
	}
/*
#partnerComp img {
	margin: 0 10px;
	position: absolute;
	bottom: 0;
	}
*/
/*
#partnerComp img {
	position: absolute;
	bottom: 0;
	margin: 0 20px;
	}
*/
/*
#partnerComp img.slot1 {
	position: absolute;
	bottom: 0;
	left: 0;
	margin: 0;
	}
*/
#partnerComp a img {
	border: none;
	}
/*
#partnerComp div.col25 {
	height: 50px;
	position: relative;
	}
*/
/* -------------------------------------- */
/* ------------- DIALOG COMP ------------ */
/* -------------------------------------- */

a.close {
	width: 34px;
	height:23px ;
	position: absolute;
background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "close")") no-repeat;
	right: 19px;
	top: 0;
	}

a.close:hover {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "close2")") no-repeat;
	}

#dialogComp a.close {
	right: 26px;
	top: 3px;
	}

#dialogComp {
	width: 460px;
	background: transparent;
	position: relative;
	}

#dialogComp .dialogContact {
	padding: 25px;
	height: 500px;
	border-top: 0;
	width: auto;
#if($browser.isIE6())
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "dialogContactIE6")") no-repeat left top;
#else
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "dialogContact")") no-repeat left top;
#end
	}

#dialogComp .dialogTip {
	padding: 25px;
	height: 257px;
	border-top: 0;
	width: auto;
#if($browser.isIE6())
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "dialogTipIE6")") no-repeat left top;
#else
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "dialogTip")") no-repeat left top;
#end
	}

body.iframe {
	background: #f8f8f7;
	}

.iframeDialogContent h1/*,
#dialogComp h1*/ {
margin: 0 0 0.5em 0;
	}

.iframeDialogContent h2/*,
#dialogComp h2*/ {
margin: -0.5em 0 0.75em 0;	
	}

.iframeDialogContent input,
.iframeDialogContent select {
	margin-bottom: 1em;
	}

.iframeDialogContent .fullwidth {
	width: 97%;
	}

.iframeDialogContent textarea.fullwidth {
	height: 6em;
	}

.iframeDialogContent input.button {
	margin: 0.25em 0 0 0;
	display: block;
	}

.iframeDialogContent input:focus,
.iframeDialogContent textarea:focus {
	background-color: #fff;
	}

/* -------------------------------------- */
/* --------- NEWS/CALENDAR COMP---------- */
/* -------------------------------------- */

p.author {
	padding-top: 0.5em;
	text-transform: uppercase;
	}

#newsComp.archive ul {
	list-style-type: none;
	margin-left: 0;
	padding-left: 0;
	margin-top: 1em;
	}

.categoryLabel { 
	border-top: 1px solid #aaa;
	border-bottom: 1px solid #aaa;
	margin: 1em 0;
	padding: 0.375em 0;
	text-transform:uppercase; 
	}

.col50 .calListComp h2 .catLabel {
	font-weight: normal;
	float: right;
	}

span.calFactLabel {
	font-weight: bold;
	display: block;
	}

div.calFact {
	margin-top:20px;
	padding-top: 20px;
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "separator")") repeat-x left top;
	}

.calListComp h2.date,
.calListComp div.record {
	margin-top:10px;
	padding-bottom: 10px;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "separator")") repeat-x left bottom;
	clear: both;
	}

div#commentArea {
	margin:2em 0;
	padding: 10px 0 20px 0 ;
/*	background: #fcfcfc url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "separator")") repeat-x left top;
*/	border-bottom:1px solid #ddd ;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "separator")") repeat-x left top;
	}

div#commentArea h2 {
	margin-top: 5px;
	padding-top: 0;
	}

a.commenticon {
	padding-left: 18px;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "commenticon")") no-repeat left center;
	text-decoration: none;
	}

a.commenticon:hover {
	text-decoration: underline;
	}

p.commentInfo {
	margin-top: 1em;
	}

.commentParent {
	margin-bottom: 0.75em;
	border: 1px solid #ddd;
	}

.commentNewChild {
	margin-left: 10px;
	border-left: 1px solid #ddd;
	margin-bottom: 0.5em;
	}

.commentHead {
	border-bottom: 1px solid #ddd;
	padding: 2px 8px;
	background: #f9f9f9 url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "pageEnd")") repeat-x center center;
	}

.commentHead p {
	margin: 0;
	}

.commentNewChild .commentHead {
	border-top: 1px solid #ddd;
	}


.comment {
	padding:8px 10px;
	}

.comment p.commentAuthor {
	font-style: italic;
	}

/* --------------------------------------------- */
/* ----------------- A TILL O ------------------ */
/* --------------------------------------------- */

.AtoO {
	margin-bottom: 2em;
	}

.AtoO ul,
/*#gubasDetailComp ul,     JS*/
#gubasComp.AtoO ul,
.col100 .col25 ul,
.col75 .col25 ul,
.col50 .col25 ul {
	list-style-type: none;
	margin: 0;
	padding: 0;
	}

.col75 .AtoO .col25#c1,
.col75 .AtoO .col25#c4,
.col75 .AtoO .col25#c7 {
	margin-left: 0;
	padding-left: 0;
	}

/*anvands ej pga att col100 stangs innan col25 anvands
.col100 .AtoO .col25#c1,
.col100 .AtoO .col25#c5,
.col100 .AtoO .col25#c9,
.col100 .AtoO .col25#c13,
.col100 .AtoO .col25#c17,
.col100 .AtoO .col25#c21,
.col100 .AtoO .col25#c25,
.col100 .AtoO .col25#c29 {
	margin-left: 0;
	padding-left: 0;
	clear: both;
	}
*/


.col25 .AtoO .col25,
.col50 .AtoO .col25 {
	float: none;
	margin-left: 0;
	}

/* ------------------------------------------- */
/* ------------------ GUSHOP ------------------ */
/* --------------------------------------------- */

#GUshopComp .record {
	margin-top:10px;
	padding: 10px 0 10px 0;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "separator")") repeat-x left bottom;
	clear: both;
	}

#GUshopComp .record img {
	float: left;
	margin: 0 10px 10px 0;
	}

div.order .record {
	margin-top:10px;
	padding: 10px 0 10px 0;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "separator")") repeat-x left bottom;
	clear: both;
	}
	
div.order .record img {
	float: left;
	margin: 0 10px 10px 0;
	width: 120px;
	}	

/* ------------------------------------------- */
/* ----------- Evenemangs/Calender ----------- */
/* --------------------------------------------- */

table#igcalendar {
	width: 100%;
	}

table#igcalendar th,
table#igcalendar td {
	text-align: center;
	vertical-align: middle;
	font-weight:normal;
	padding: 0;
	width: 14%;
	}

table#igcalendar td.today a {
	font-weight: bold;
	background: #ededed url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "today")") repeat-x center center;
	}

table#igcalendar td.current a {
	background-color: #015497; 
	font-weight: bold;
	color: #fff;
	}

table#igcalendar td a {
	display:block;
	}

table#igcalendar td a:hover {
	background-color: #ddd;
	}

table#igcalendar td a:active {
	background-color: #fff;
	}

table#igcalendar td a.last_next {
	font-weight:bold;
	text-decoration:none;
	}

/* -------------------------------------- */
/* ----------- SEARCH RESULT ------------ */
/* -------------------------------------- */

#searchResultComp {
	position: relative;
	margin-bottom: 3em;
	}

#searchResultComp .col100 form .searchfield {
	width: 40%;	
	}

#searchResultComp .col100 #tabstrip ul {
	margin: 0;
	padding:0;
	margin-left: 15px;
	}

#searchResultComp .col100 #tabstrip {
	margin: 4em -15px 0 -15px;
	width: auto;
	padding: 0 0 10px 0;
    background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "tabstripBg")") repeat-x left bottom;
#if($browser.isIE()) 
    border-top:1px solid #fff ; 
#end
	}

#searchResultComp .col100 #tabstrip li {
	display: inline;
	background: #fff url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "flikRbg")") no-repeat right top;
	margin:0 0 -1px 2px;
	float: left;
	border-bottom: 1px solid #b5b5b5;
	}
	
#searchResultComp .col100 #tabstrip li a {
	padding: 0.5em 1.5em 0.25em 1.5em;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "flikLbg")") no-repeat left top;
	display:block;
	text-decoration: none;
	font-weight: bold;
	}

#searchResultComp .col100 #tabstrip li a span {
	font-weight: normal;
	}

#searchResultComp .col100 #tabstrip li a:hover {
	text-decoration: underline;
	}

#searchResultComp .col100 #tabstrip li.current {
	border-bottom: 1px solid #eee;
	}

#searchResultComp .col100 p .current {
	font-weight: bold;
	}

#searchResultComp .col100 p {
	margin: 1em 0;
	}

#searchResultComp .col100 p.nomargin {
	margin: 0;
	}

#searchResultComp .col100 p a {
	margin: 0 0.25em;
	}

#searchResultComp .col75 h1,
#searchResultComp .col25 h1 {
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "separator")") repeat-x left bottom;
	padding-bottom: 12px;
	margin-bottom: 0;
	margin-top: 0.25em;
	}

#searchResultComp .resultlist .choosenHit {
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "separator")") repeat-x left bottom;
	padding: 1em ;
	background-color: #fbfbfb;
	}

#searchResultComp .resultlist .choosenHit h2 {
	margin-top: 0;
	}

#searchResultComp .resultlist ol {
	list-style-position: inside;
	margin: 0;
	padding: 0;
	}

#searchResultComp .resultlist ol li {
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "separator")") repeat-x left bottom;
	padding: 1em 0;
	}

#searchResultComp .resultlist ol li span {
	font-weight: bold;
	}

#searchResultComp .resultlist ol li a {
	text-decoration: none;
	padding-right: 2em;	
	}

.searchHitCacheLink a {
	text-decoration: underline;	
	}

#searchResultComp .resultlist ol li a:hover {
	text-decoration: underline;
	}

.searchHitInfo {
	margin-top: 0.5em;
	}

#searchResultComp .resultlist ul {
	margin: 2em 0;
	padding: 0;
	}

#searchResultComp .resultlist ol li a.pdf  {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "pdf")") no-repeat right center;
	}

#searchResultComp .resultlist ol li a.word  {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "word")") no-repeat right center;
	}

#searchResultComp .resultlist ol li a.ppt  {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "ppt")") no-repeat right center;
	}

#searchResultComp .resultlist ol li a.mov  {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "mov")") no-repeat right center;
	}

#searchResultComp .resultlist ol li a.eps  {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "eps")") no-repeat right center;
	}

#searchResultComp .resultlist ol li a.psd  {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "psd")") no-repeat right center;
	}

#searchResultComp .resultlist ol li a.file  {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "file")") no-repeat right center;
	}

#searchResultComp .resultlist ol li a.xls  {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "eps")") no-repeat right center;
	}

#searchResultComp .resultlist ol li .searchHitInfo,
#searchResultComp .resultlist ol li .searchHitInfo a,
#searchResultComp .resultlist ol li .searchHitUrl,
#searchResultComp .resultlist ol li span.position,
#searchResultComp .resultlist ol li span.organisation,
#searchResultComp .resultlist ol li span.phone,
#searchResultComp .resultlist ol li span.email  {
	background-image: none;
	padding: 0;
	font-weight: normal;
	}

#searchResultComp .resultlist ol li strong {
	border-bottom: 2px solid #ffc000;
	}

/* -------------------------------------- */
/* --------------- GUBAS ---------------- */
/* -------------------------------------- */

#gubasComp {
	}

/*#gubasDetailComp li,     JS*/
#gubasComp li {
	padding-bottom:5px;
	}

#gubasComp.list dd {
	margin: 0 0 0 0;
	padding: 0;
	padding-left: 18px;
	padding-bottom:5px;
	}

#gubasComp.AtoO dd {
	margin: 0;
	padding: 0;
	}

.gubasNoEkoIcon {
	padding-left: 18px;
	}

.gubasEko100Icon {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "gubasEko100IconSmall")") no-repeat left 2px;
	padding-left: 18px;
	}

.gubasEko50Icon {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "gubasEko50IconSmall")") no-repeat left 2px;
	padding-left: 18px;
	}

.gubasAdmin {
	background-color:#feffcb;
	padding: 3px 0;
	}

.gubasAdmin ul {
	margin:0 0 0 16px;
	}

.gubasAdmin li {
	display: inline;
	list-style-type: none;
	padding:0 3px 0 8px;
	margin: 0;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "linkDivider")") no-repeat left center;
	}

.gubasAdmin li.first {background-image:none;
	padding:0 3px 0 0;}

/*gubasHoverBox*/
#gubasDetailComp div.middle {
	width: 452px;
	height: 147px;
	background:transparent  url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "gubasHoverBox")") no-repeat  left top; 
	position: relative;
	top: 0px;
	left: 30px;
	padding-top:20px
	}

#gubasDetailComp div.middle span {padding:0 30px; display:block; text-transform: none; font-weight:normal; font-size:100% }

div.top, div.bottom {display:none !important}

/* -------------------------------------- */
/* --------------- GUalumnDBApp ---------------- */
/* -------------------------------------- */

#GUalumnDBApp #bodyArea #menuComp ul#menu li {
	border:0;
	}

#GUalumnDBApp #bodyArea #menuComp ul#menu li a {
	border-bottom: 1px solid #d4d4d4;
	padding-top: 6px;
	padding-bottom: 5px
	}
	
#GUalumnDBApp #bodyArea #menuComp ul#menu {
	font-weight:bold
	}
	
#GUalumnDBApp #bodyArea #menuComp ul#menu ul  {
	margin:0;
	padding:0;
	list-style-type: none;
	font-weight:normal
	}

/*#GUalumnDBApp #bodyArea #menuComp ul#menu ul a  {
	padding-left:15px;
	}
*/
#GUalumnDBApp #bodyArea #menuComp ul#menu li.current {
	padding-left: 20px;
	position: relative;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "current")") no-repeat left center;
#if($$browser.isIE())
	left: -21px;
#else
	left: -20px;
#end
	}


/* -------------------------------------- */
/* --------------- Handels -------------- */
/* -------------------------------------- */

#haVinjett75 {
	width: 970px;
	border-bottom: 5px solid #FFFFFF; 
	border-top: 5px solid #FFFFFF; 
}

#haVinjett75 img {
	float: left;
	border: none;
	border-right: 5px solid #FFFFFF;
        width: 237px;
	height: 175px;
}

#haVinjett75 a {
	border: none;
}

.haWrapper {
	float:left;
	max-height: 175px;
}

#haShortcuts {
        padding: 18px 18px 14px;
}

#haVinjett75 #linkCollection {
	max-height: 175px;
        float: right;
        max-width: 237px;
        right: 0;
        top: 0;
        width: 100%;
}

#haTargetGroups li{
        height: 30px;
	margin: 0;
        padding-left: 28px;
        padding-right: 28px;
	float:left; 
	display:block; 
	border-left: 1px solid #909090;
}

#haTargetGroups li a {
	display: block;
	padding-top: 6px;
	text-decoration:none;
}

#haTargetGroups ul{
       margin: 0;
       height: 0px;
       width: 100%;
       display: block;
       float: left;
       list-style-position: outside;
       list-style-type: none;
       margin-top: 10px;
       margin-bottom: 10px;
       margin-left: 9px;
#if($browser.isIE7())
       margin-left: 8px;
#end
#if($browser.isIE8())
       margin-left: 8px;
#end
}

#haTargetGroups ul li:first-child {
       border: none;
}

/* -------------------------------------- */
/* --------------- SEMBOKN ---------------- */
/* -------------------------------------- */

#semBokn {
	margin: 0;
	padding:0; 
#if($browser.isIE())	
	width: 700px;
#else
	max-width:700px;
#end
	}

#bodyArea #semBokn .col100 h2.list {
	font-weight:bold;
	}

#semBokn .col100 {
	width:100%;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "separator")") repeat-x left bottom;
	}

#semBokn .col100,
#semBokn .col75 {
	margin:0;
	padding:0
	}

#semBokn .col25 {
	margin-top:0;
	}

#semBokn .col75 { 
	width:65.77%;
#if($browser.isIE())	
	width: 460px;
#end
 	}
#semBokn .col25 { 
#if($browser.isIE())	
	width: 220px;padding:0 0 0 20px;margin:0;
#else
	width:31.5%; margin-left:2.2%;
#end
 	}

#semBokn table {
	margin-bottom:7px;
	width:100%
	}

#semBokn table caption {
	font-size: 100%;
	}

#semBokn table {margin:0; padding:0}

/* -------------------------------------- */
/* ---------- CHANGEBLE VALUES ---------- */
/* -------------------------------------- */

#set($customized = false)
#if($!textFontSize != "" && $!textFontSize != "0")
  #set($customized = true)
#end
#if($!fontFamily != "" && $!fontFamily != "0")
  #set($customized = true)
#end
#if($!textLineHeight != "" && $!textLineHeight != "0")
  #set($customized = true)
#end
#if($!contrast != "" && $!contrast != "0")
  #set($customized = true)
#end
#if($!wordspace != "" && $!wordspace != "0")
  #set($customized = true)
#end
#if($!letterSpace != "" && $!letterSpace != "0")
  #set($customized = true)
#end

#if($customized != true)
	.customizeNote {display:none;}
#end


	#if($!contrast != "0" && $!contrast != "")
.contrast { font-weight:bold;}
	#else
span.contrast {display:none; }
	#end

	#if($!textFontSize != "0" && $!textFontSize != "")
.textFontSize {	font-weight:bold;  }
	#else
span.textFontSize {display:none; }
	#end

	#if($!textLineHeight != "0" && $!textLineHeight != "")
.textLineHeight { font-weight:bold;  }
	#else
span.textLineHeight {display:none; }
	#end

	#if($!wordspace != "0" && $!wordspace != "")
.wordspace { font-weight:bold;  }
	#else
span.wordspace {display:none; }
	#end

	#if($!letterSpace != "0" && $!letterSpace != "")
.letterSpace { font-weight:bold; }
	#else
span.letterSpace {display:none; }
	#end

	#if($!fontFamily != "0" && $!fontFamily != "")
.fontFamily {font-weight:bold; }
	#else
span.fontFamily {display:none; }
	#end



/* -------------------------------------- */
/* -------------- FONT-SIZE ------------- */
/* -------------------------------------- */

label,
/*p.red,*/
.errorMessage,
#bodyArea p,
#partnerComp p,
#bodyArea tr,
#home ul,
#bodyArea ul,
#bodyArea ol,
#bodyArea dd,
#bodyArea #sitemap,
#bodyArea .col25 .textComp h2,
#bodyArea .col25 .textComp h3,
#bodyArea .col25 .textComp h4,
#bodyArea .col50 .rssComp h3,
#bodyArea .col50 .newsListComp h2,
#bodyArea .col50 .calListComp.light h2,
#bodyArea .col50 .calListComp h3,
#bodyArea .col50 .newsPushComp h2,
#bodyArea .col50 .calPushComp h2,
#bodyArea .col25 h2,
#bodyArea #semBokn .col100 h2.list,
#bodyArea a#uplink,
#bodyArea a#share,
#customizeComp p,
.iframeDialogContent p,
#footerArea p {
	font-size: 0.75em;
	}

h1,
.iframeDialogContent h1,
#searchResultComp .col25 h1 {
	font-size: 1.625em;
	}

#bodyArea #gubasComp tr h2,
#headerArea .left a,
#bodyArea .sitemapComp ul a,
p span.citat {
	font-size: 1.5em;
	}

h2,
#bodyArea .AtoO h2,
legend {
	font-size: 1.3125em;
	}

.col25 h1,
#bodyArea h3,
#bodyArea h4,
#bodyArea h5,
#bodyArea #profilComp h1,
#bodyArea caption,
#bodyArea dt,
.adComp h1,
.iframeDialogContent h2 {
	font-size: 1.1875em;
	}

#darkRow ul,
#darkRow .sitename,
#darkRow h1,
div.abc,
.iframeDialogContent h3 {
	font-size: 1em;
	}

#home ul,
#headerArea,
#darkRow label,
#bodyArea #profilComp h2,
#bodyArea #profilComp ul.collapsablemenu,
textarea, input,
#partnerComp h1 {
	font-size: 0.6875em;
	}

#bodyArea ol ol,
#bodyArea ol ol ol,
#bodyArea ul ul,
#bodyArea ul ul ul,
#bodyArea ul ul ul ul,
#bodyArea .sitemapComp ul ul a {
	font-size: 100%;
	}

.commentdate,
.smallfont {
	font-size: 80%;
	}

.searchHitInfo {
	font-size: 90%;
	}

#bodyArea .col25 .textComp h2,
#bodyArea .col25 .textComp h3,
#bodyArea .col25 .textComp h4,
#bodyArea .col50 .rssComp h3,
#bodyArea .col50 .newsListComp h2,
#bodyArea .col50 .calListComp.light h2,
#bodyArea .col50 .calListComp h3 {
	font-weight: bold;
	}



	#if($wordspace =="1") 
/* ------------------------------------------------- */
/* -------------- WORD-SPACE # LARGE --------------- */
/* ------------------------------------------------- */

body,
table  {
	word-spacing: 0.625em;
	}

	#else 

	#end

/* ------------------------------------------------- */
/* ----------------- FONT-FAMILY ------------------- */
/* ------------------------------------------------- */

	#if($fontFamily =="Courier") 

body,
input,
textarea {
	font-family: Courier, sans-serif; 
	}

	#elseif($fontFamily =="TimesNewRoman") 

body,
input,
textarea {
	font-family: Times New Roman, serif; 
	}

	#elseif($fontFamily =="Monaco") 

body,
input,
textarea {
	font-family: Monaco, sans-serif; 
	}

	#elseif($fontFamily =="Trebuchet") 

body,
input,
textarea {
	font-family: Trebuchet, sans-serif; 
	}

	#else


body,
input,
textarea,
#darkRow,
#profilComp #linkCollection h2,
#profilComp ul.collapsablemenu,
#bodyArea .col50 .rssComp h3,
#bodyArea .col50 .newsListComp h2,
#bodyArea .col50 .calListComp.light h2,
#bodyArea .col50 .calListComp h3,
#bodyArea .col50 .newsPushComp h2,
#bodyArea .col50 .calPushComp h2,
#bodyArea #semBokn .col100 h2.list,
#bodyArea .col25 h2,
#bodyArea .col25 h3,
#bodyArea .col25 h4,
#bodyArea .sitemapComp ul ul a {
	font-family: Verdana, Arial, Helvetica, sans-serif; 
	}

p span.citat, 
#darkRow .sitename, 
h1, h2, h3, h4, h5, dt, caption, legend,
#bodyArea .sitemapComp ul a {
#if($browser.isWindows() && $browser.isIE())
	font-family: Helvetica, Arial, sans-serif;
#else
	font-family: "HelveticaNeue-Light", "Helvetica Neue Light", Helvetica, Arial, sans-serif;
#end
	font-weight: normal;
	}

#darkRow h1,
#darkRow .sitename,
#darkRow ul.linklist { font-family: Helvetica, Arial, sans-serif; }

	#end

/* ------------------------------------------------- */
/* ------------------ LINE-HEIGHT ------------------ */
/* ------------------------------------------------- */

	#if($textLineHeight =="1") 

body {						line-height: 120%; }
h1, table {				line-height: 130%; }
h2, h3, h4, p, ul, ol, h5, dd, p span.citat  {	line-height: 170%; }

	#elseif($textLineHeight =="2") 

body {						line-height: 140%; }
h1, table {				line-height: 150%; }
h2, h3, h4, p, ul, ol, h5, dd, p span.citat  {	line-height: 190%; }

	#elseif($textLineHeight =="3") 

body {						line-height: 160%; }
h1, table {				line-height: 170%; }
h2, h3, h4, p, ul, ol, h5, dd, p span.citat  {	line-height: 210%; }

	#else /*0*/

body {						line-height: 100%; }
h1, table {				line-height: 120%;}
h2, h3, h4, p,  ul, ol, h5, dd, p span.citat  {	line-height: 150%; }

	#end

/* ------------------------------------------------- */
/* ------------------ LETTER SPACE ----------------- */
/* ------------------------------------------------- */

	#if($letterSpace =="1") 

body,
table { 						letter-spacing: 1px;}

	#elseif($letterSpace =="2") 

body,
table { 						letter-spacing: 2px; }

	#elseif($letterSpace =="3") 

body,
table { 						letter-spacing: 5px; }

	#else 

	#end

/* ------------------------------------------------- */
/* ------------------ IE SPECIFIC ------------------ */
/* ------------------------------------------------- */

#if($browser.isIE()) 

	body {
		word-wrap:break-word; 
		}

	#customize_area {
		width:expression(document.body.clientWidth > 100? "100%": "auto" ); 
		}

a.gubasEko100Icon {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "gubasEko100IconSmall")") no-repeat right top;
	}

a.gubasEko50Icon {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "gubasEko50IconSmall")") no-repeat right top;
	}

#end
	
/* ------------------------------------------------- */
/* ------------------ IG SPECIFIC ------------------ */
/* ------------------------------------------------- */

.igAddComponent {
   font-size:65%;
   padding:3px;
   line-height:180%; 
   border:1px dashed #000; 
   background-color:#f7f96c; 
   clear:both;
   color:#000;
   }

#headerArea .igAddComponent {
	position: absolute;
	margin-top: -27px;
	}

/* aktiveras efter 10 juni
.img_scaled,
.img_full,
*/.img100 {
	width:100%; 
	padding:0;
	margin:0 0 0.5em 0; 
	clear:both;
	}
/*
h5 {
	clear: both;
	font-style: italic;
	text-align:left; 
	margin: 1em 6%;
	text-indent: 1.75em;
	line-height: 150%;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "citat")") no-repeat left top;
	}

h4 {
	font-size: 0.75em;
	font-weight: bold; 
	font-family: Verdana, Arial, Helvetica, sans-serif;}
*/

/* -------------------------------------- */
/* ------------- FONT COLOR ------------- */
/* -------------------------------------- */

p span.citat,
#bodyArea #menuComp h1#menuLevel a:visited,
a, h1, h2, h3, h4, h5, caption, dt, legend {
	color: #015497;
	}

#bodyArea .col25 a:visited,
#bodyArea .col50 a:visited,
#bodyArea .col75 a:visited,
#bodyArea .col100 a:visited {
	color: #777777;
	}

body,
#partnerComp h1,
#profilComp #linkCollection h2 a,
#profilComp #linkCollection .collapsablemenu a,
#bodyArea #menuComp ul#menu li a,
#bodyArea #menuComp ul#menu li a:visited,
#searchResultComp .col100 #tabstrip li.current a,
#searchResultComp .col100 a.current {
	color: #484848; 
	}

.red,
.OBSmessage,
.errorMessage,
a:hover,
#bodyArea .col25 a:hover,
#bodyArea .col50 a:hover,
#bodyArea .col75 a:hover,
#bodyArea .col100 a:hover
a.expired:hover,
#bodyArea #menuComp ul#menu li a:hover {
	color: red;
	}

#darkRow a,
#darkRow h1,
#darkRow .sitename,
#darkRow  {
	color: #fff;
	}
	
#bodyArea #menuComp ul#menu li a.current {
	color: #000;
	}

a.expired {
	color: gray;
	}

/* ---------------------------------------- */
/* -- BACKGOUND COLORS # CONTRAST NORMAL -- */
/* ---------------------------------------- */

/* ----- HIGH ----- */


	#if($contrast =="high") 

body {
	background-color: #00223f;
	}

.shadow-a {
	background-color: #001a30;
	}

.shadow-b {
	background-color: #000e1a;
	}

.shadow-c {
	background-color: #000 ;
	}

#pageContainer {	
	background-color: #004b89;
	}

#bodyArea {
	background-image: none;
	border-bottom: 0;
	}

#byline {
	border-top: 1px solid #fff;
	}

#bodyArea #menuComp ul#menu li {
	border-bottom: 1px solid #013967;
	}

#bodyArea #menuComp h1#menuLevel {
	border-bottom: 1px solid #013967;
	}

#bodyArea #menuComp ul#menu li a.current {
	padding-left: 20px;
	position: relative;
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "current_HC")") no-repeat left center;
}

#bodyArea #menuComp ul#menu li a.submenu:hover {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "submenuHover_HC")") right center no-repeat;
	}

#crumbtrailComp {
	border-bottom: 2px solid #fff;
	}

#crumbtrailComp li a {
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "pil_HC")") right center no-repeat;
	}

#crumbtrailComp li.current {
	background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "crumbCurrent_HC")") repeat-x center bottom;
	}

#sitemap {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "sitemap_HC")") no-repeat left center ;
	}

#bodyArea .sitemapComp ul ul li a {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "tree_HC")") no-repeat left center;
	}

#profilComp {
	border-bottom: 2px solid #000;
	background-color: #000;
	}

#profilComp #vinjett75 {
	border-right: 5px solid #004b89;
	}

#profilComp #linkCollection ul.collapsablemenu {
  	border: 1px solid #fff;
  	}
  	
#profilComp #linkCollection .collapsablemenu li {
	border-top: 1px solid #dfdfdf;
	}

#profilComp #linkCollection h2 {
	background: #004b89 url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "dropdown")") no-repeat right center;
	border: 1px solid #7d7d7d;
	}

#profilComp #linkCollection ul.collapsablemenu {
  	background-color: #004b89; 
  	}

#profilComp #linkCollection .collapsablemenu li {
	border-top: 1px solid #dfdfdf;
	}

#profilComp #linkCollection .collapsablemenu li a:hover {
	background-color: #000;
	}

#profilComp #shortcuts {
	border-bottom: 5px solid #004b89;
	padding: 18px 18px 14px 18px;
	}

p span.citat {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "citat_HC")") no-repeat left top;
	}

#customizeComp {
	margin:0 ;
	position: relative;
	padding: 0.5em 5px 1.5em 5px; 
	width: auto;
	border-bottom: 1px solid #ebebeb;
	border-top: 5px solid #3364af;
	background-color: #fff;
	}

.eventCategorySelectComp h1,
.eventSearchComp h1,
.dateSpanSelectComp h1,
.graphicCalComp h1,
.col25 #gubasComp.search h1,
.col25 #gubasContactApp h1,
.newsPushComp h1,
.rssPushComp h1,
.calPushComp h1,
.contactComp h1,
.textComp h1 {
	border-bottom: 1px solid #fff;
	border-left: 2px solid #fff;
	}

.adComp .col25,
.adComp .col50 {
	border-left: 1px solid #025ba5;
	border-right: 1px solid #013967;
	}
	
.adComp #first {
	border-left: 1px solid #025ba5;
	padding-left: 0;
	}

#partnerComp {
	border-top: 2px solid #000;
	}
	
.categoryLabel { 
	border-top: 1px solid #fff;
	border-bottom: 1px solid #fff;
	}

div#commentArea {
	border-bottom:1px solid #fff ;
	}

.commentParent {
	border: 1px solid #fff;
	}

.commentNewChild {
	border-left: 1px solid #fff;
	}

.commentHead {
	border-bottom: 1px solid #fff;
	background-color: #000;
	background-image: none;
	}

.commentNewChild .commentHead {
	border-top: 1px solid #ddd;
	}

table, td, th {
	border: 1px solid #000;
	}

th	{
	background: #00335d;
	}

.tableOddRow {
	background-color: #1f6dae;
	}

table#igcalendar td.today a {
	background: #3e7eb2 url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "today")") repeat-x center center;
	}

table#igcalendar td.current a {
	background-color: #000; 
	}

table#igcalendar td a:hover {
	background-color: #000;
	}

table#igcalendar td a:active {
	background-color: #3e7eb2;
	}

#searchResultComp .col100 #tabstrip {
    background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "tabstripBg_HC")") repeat-x left bottom;
#if($browser.isIE()) 
    border-top:1px solid #fff ; 
#end
	}

#searchResultComp .col100 #tabstrip li {
	background: #fff url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "flikRbg_HC")") no-repeat right top;
	border-bottom: 1px solid #fff;
	}
	
#searchResultComp .col100 #tabstrip li a {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "flikLbg_HC")") no-repeat left top;
	}

#home ul.linklist li {
	background: transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "linkDivider_white")") no-repeat left center;
	}

#searchResultComp .col100 #tabstrip li.current {
	border-bottom: 1px solid #004b89;
	}

#searchResultComp .col100 p a.current {
	font-weight: bold;
	}

#searchResultComp .resultlist ol li strong {
	border-bottom: 2px solid #ffc000;
	}

ul.slotlist li.current {
	border: 1px solid #fff;
	padding: 0 0.5em;
	}

/* -------------------------------------- */
/* ------------- FONT COLOR ------------- */
/* -------------------------------------- */

a {
	color: #ffe400;
	}

.red,
.OBSmessage,
.errorMessage,
a:hover,
a.expired:hover,
#bodyArea #menuComp ul#menu li a:hover {
	color: #fff;
	}

body,
.categoryLabel,
#partnerComp h1,
#profilComp #linkCollection h2 a,
#profilComp #linkCollection .collapsablemenu a,
#bodyArea #menuComp ul#menu li a,
#bodyArea #menuComp ul#menu li a:visited,
#bodyArea #menuComp h1#menuLevel a:visited,
#bodyArea #menuComp h1#menuLevel a,
#searchResultComp .col100 #tabstrip li.current a,
#searchResultComp .col100 a.current,
#bodyArea #menuComp ul#menu li a.current,
p span.citat,
h1, h2, h3, h4, h5, caption, dt, legend {
	color: #fff; 
	}


#bodyArea .col25 a:hover,
#bodyArea .col50 a:hover,
#bodyArea .col75 a:hover,
#bodyArea .col100 a:hover {
	color: #fff;
	}
	
#bodyArea .col25 a:visited,
#bodyArea .col50 a:visited,
#bodyArea .col75 a:visited,
#bodyArea .col100 a:visited {
	color: #c3c3c3;
	}

#darkRow a,
#darkRow h1,
#darkRow .sitename,
#darkRow  {
	color: #fff;
	}

a.expired {
	color: gray;
	}

#customizeComp h1,
#customizeComp a,
#headerArea a {
	color: #015497;
	}

#customizeComp {
	color: #484848;
	}


	#elseif($contrast =="low") 

#pageContainer {	
	background-color: #fff9cd;
	}

#searchResultComp .col100 #tabstrip {
    background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "tabstripBg")") repeat-x left bottom;
	}

	#else

/* Fallback to default */

	#end


/* --- HAVSMILJOINSTITUTETS WEB-BANNER --- */

.havsmiljo #headerArea {
background:url(https://cms.it.gu.se/infoglueCMS/digitalAssets/1296/1296175_havsmiljo_bg.png);
height:100px
}
/*
.havsmiljo #headerArea .left {
margin:30px 0 0 0px
}
*/
.havsmiljo #headerArea .right {
background:none;
border:none;
}

.havsmiljo #headerArea p {
color:#fff;
text-align:left;
margin:12px 10px 0 0;
font-size:90%
}


/*----------------- AUTOCOMPLETE ------------------*/

.ac_results {
	background:transparent url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "ac_arrow")")  no-repeat 67% top;
	padding-top:6px;
	z-index:99999;
	}

.ac_results.center {
	background-position:center top;
	}

.ac_results ul {
	list-style-image:none;
	list-style-position:outside;
	list-style-type:none;
	margin:0;
	padding:0;
	width:100%;
	background-color:#f6f7f6;
	border:1px solid #29539a;
	border-top:5px solid #29539a;
	border-bottom:5px solid #29539a;
	overflow:hidden;
	-moz-box-shadow:0 0.4em 1em rgba(0, 0, 0, 0.5);
	-webkit-box-shadow: 0px 2px 10px rgba(0, 0, 0, 0.5);
	}
	
.ac_results li {		
	margin:0;
	overflow:hidden;
	border-left:3px solid #fff;
	border-right:3px solid #fff;
	background:  url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "separator")") repeat-x left top;
	}

.ac_results li:first-child {
	background-image:none
	}

.ac_results li a {
	display:block;
	font-size:75%;
	line-height:140%;
	padding:6px 15px 6px 15px;
	text-decoration:none;
	}

.ac_results li a strong {
	border-bottom:2px solid orange;
	font-weight:normal
	}

.ac_results li.last a {background-image:none}

.ac_results li a:hover {
	background-color:#e4e4e4;
	color:#29539a;
	}

.ac_results li a:focus {
	background-color:#e4e4e4;
	color:#5f5f5f;
	border-left:0;
	border-right:0;
	padding-left:18px;
	padding-right:18px;
	outline:0;
	}

.ac_results .ac_over {
	-moz-background-clip:border;
	-moz-background-inline-policy:continuous;
	-moz-background-origin:padding;
	background:#e4e4e4 url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "separator")") repeat-x left top scroll ;
	color:#29539a;
   }

#logoutDiv {position: fixed; z-index: 100000; right: 10px; top: 10px; background-color: rgb(100, 255, 100); border: 2px solid green; padding: 5px; border-radius: 4px; -moz-border-radius: 4px; -webkit-border-radius: 4px; -webkit-box-shadow: rgba(50, 50, 50, 0.5) 5px 5px 10px; -moz-box-shadow: 5px 5px 10px rgba(50, 50, 50, 0.5);  box-shadow: 5px 5px 10px rgba(50, 50, 50, 0.5);}
#logoutDiv a {color: rgb(0, 50, 0); text-decoration: none; font-size: 12px;}   

/*-------------- GU RESEARCH ORGINAL-------------*/
/*
ul.relatedSubjectListNode {list-style-type: none; margin: 0px 0px 0px 20px;}
ul.subjectListNode, ul.subjectListNode ul li ul {list-style-type: none; display: none; margin-left: 20px;}
ul.topLevel {display: block; margin: 0px;}
ul.topLevel > li > div.relatedIcon {display: none;}
li.treeNode a {cursor: pointer; text-decoration: underline; line-height: 20px;}
div.listIcon {cursor: default; width: 12px; height: 16px; background-repeat: no-repeat; background-position: left center; float: left; margin-right: 2px;}
div.arrow {background-image: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "small_arrow")"); cursor: pointer;}
div.arrowExpanded {background-image: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "small_arrow_down")"); cursor: pointer;}
div.relatedIcon {background-image: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "angle")"); margin-right: 5px;}
.adminError {color:red; font-weight: bold;}
.contactInformation {width: 350px; overflow: hidden; float: left;}
.personInformation .contactInformation {width: 420px; border-top: 1px solid rgb(220, 220, 220); padding-top: 10px;}
.personInformation .contactInformation:first-child {border-top: none; padding-top: 0px;}
.personInformation ul {list-style-type: none;}
.personImageDiv {float: right; width: 222px;}
.personImage {margin-top: 5px; margin-bottom: 5px; display: block; width: 220px; height: 260px; background-position: 50%; background-repeat: no-repeat; border: 1px solid #646464; box-shadow: 2px 2px 20px 0px rgba(0, 0, 0, 0.25);}
.blockTitle {font-weight: bold;}
.personDescription {clear:both;}
.editDescriptionTextArea {width: 500px; height: 200px;}
.editDescriptionControls {display:block;}
.kartenaMapFrame {width: 320px; height: 320px; box-shadow: 2px 2px 20px 0px rgba(0, 0, 0, 0.25); border: 1px solid rgb(150, 150, 150); background-color: rgb(198, 218, 183);}
.publicationType {font-size: 12px; margin-bottom: 30px;}
table.publicationTable, table.publicationTable td, table.publicationTable th  {border: none; padding: 0px 5px 0px 0px;}
.publicationLinkBig {display: table; width: 230px; background-color: rgb(230, 240, 255); padding: 15px 10px 5px 0px; float: right;}
#bodyArea div.publicationLinkBig img {float: left; padding: 10px;}
#bodyArea div.publicationLinkBig div {float: left; width: 140px; padding: 10px 10px 10px 0px;}
#bodyArea div.publicationLinkBig a {text-decoration: none;}
.tabHeader {margin-bottom: 30px;}
.tabContainer {border-bottom: 1px solid rgb(212, 212, 212); height: 30px; width: 100%;}
.tab {display: none; float: left; margin-right: 2px; cursor: pointer; color: rgb(1, 84, 151); font-size: 12px; font-weight: bold; padding: 7px 20px 7px 20px; border-left: 1px solid rgb(212, 212, 212); border-top: 1px solid rgb(212, 212, 212); border-right: 1px solid rgb(212, 212, 212); -webkit-border-top-left-radius: 4px; -webkit-border-top-right-radius: 4px; -moz-border-radius-topleft: 4px; -moz-border-radius-topright: 4px; border-top-left-radius: 4px; border-top-right-radius: 4px;}
.tabSelected { background-color: white; color: black; pointer: auto;}
.tabContent {padding: 20px 0px; display: none;}
.tabContentSelected {display: block;}
ul.orgList {list-style-type: none; margin-left: 0px;}
ul.orglist li a {text-decoration: none;}
.person {}
.person table:hover {background-color:#eee;}
.guResearchPhone {white-space: nowrap;}
.sortBySelected {font-weight: bold;}
.guResearchComp .listInfo p {display:inline;}
.guResearchComp .itemCountPicker {display: inline;}
.guResearchComp .itemCountPicker select {width: 125px;}
.publication {clear: both; float: left; width: 100%; margin-bottom: 20px; font-size: 12px;}
.publicationDescription {float: left; width: 500px;}
a.publicationTitle {font-weight: bold;}
.publicationLink {
	position:relative;
	float: right; 
	width: 120px;
	padding:15px;
	background-color: rgb(230, 240, 255);
	border-radius:2px;
	word-wrap:break-word;
}
.guResearchComp .publicationListInfo.publicationGroup {color:#ccc;}
.guResearchComp .listInfo p {display:inline;}
*/
/* THE TRIANGLE
------------------------------------------------------------------------------------------------------------------------------- */

/* creates triangle */
.publicationLink:after {
	content:"";
	position:absolute;
	/*bottom:auto;*/
	top:50%; /* controls vertical position */
	margin-top:-10px; /* Half height of*/
	left:-10px; /* value = - border-left-width - border-right-width */
	border-width:10px 10px 10px 0;
	border-style:solid;
	border-color:transparent rgb(230, 240, 255);
	/* reduce the damage in FF3.0 */
	display:block; 
	width:0;
}
.treeNode .markedSubject {}


/*-------------- GU RESEARCH - JOAKIM-------------*/
.publicationLink {
	position:relative;
	float: right; 
	width: 20%/*120px*/;
	padding:15px;
	background-color: rgb(230, 240, 255);
	border-radius:3px;
	word-wrap:break-word;
	font-size: 0.75em;
}
.publicationLinkBig {display: table; width: 230px; background-color: rgb(230, 240, 255); padding: 15px 10px 5px 0px; float: right; border-radius:4px;}

.contactInformation {width: 350px; overflow: hidden; float: left;}
.personInformation .contactInformation {width: 420px; border-top: 1px solid rgb(220, 220, 220); padding-top: 10px;}
.personInformation .contactInformation:first-child {border-top: none; padding-top: 0px;}
.personInformation ul {list-style-type: none;}
.personImageDiv {float: right; width: 222px;}
.personImage {margin-top: 5px; margin-bottom: 5px; display: block; width: 220px; height: 260px; background-position: 50%; background-repeat: no-repeat; border: 0px solid #646464; }
.blockTitle {font-weight: bold; /*color: rgb(1, 84, 151);*/}
.personDescription {clear:both;}
.editDescriptionTextArea {width: 500px; height: 200px;}
.editDescriptionControls {display:block;}


.tabHeader {margin-bottom: 30px;}
.tabContainer {border-bottom: 1px solid rgb(212, 212, 212); height: 30px; width: 100%; display: none; visibility: hidden;}
.tab {display: none; float: left; margin-right: 2px; cursor: pointer; /*color: rgb(1, 84, 151);*/ font-size: 0.75em; font-weight: bold; padding: 7px 20px 7px 20px; border-left: 1px solid rgb(212, 212, 212); border-top: 1px solid rgb(212, 212, 212); border-right: 1px solid rgb(212, 212, 212); -webkit-border-top-left-radius: 4px; -webkit-border-top-right-radius: 4px; -moz-border-radius-topleft: 4px; -moz-border-radius-topright: 4px; border-top-left-radius: 4px; border-top-right-radius: 4px;}
.tabSelected { background-color: white; color: #484848; pointer: auto;}
.tabContent {padding: 20px 0px; display: block;}
.tabContentSelected {display: block;}
.tabContainer a.tabContent {display:block;}
.tabContainer a.tab {text-decoration: none;}
.tabContainer a.tab:hover {	text-decoration: underline;}

.publicationType {font-size: 0.75em; margin-bottom: 30px;}
table.publicationTable, 
table.publicationTable td, 
table.publicationTable th  {border: none; padding: 0px 25px 5px 0px; background:none; }
table.publicationTable th {font-weight:bold}

.publication {clear: both; float: left; width: 100%; margin-bottom: 0px; }
.publicationDescription {float: left; width: 70%;}
a.publicationTitle {font-weight: bold; }
span.publicationGroup {font-size:0.875em}
#bodyArea div.publicationLinkBig {padding: 10px;}
#bodyArea div.publicationLinkBig img {float: left; }
#bodyArea div.publicationLinkBig span {float: left; display:block; width: 140px; padding-left: 10px;}
#bodyArea div.publicationLinkBig a {text-decoration: none;}


ul.orgList {list-style-type: none; margin-left: 0px;}
ul.orglist li a {text-decoration: none;}
.person {}
.person table:hover {background-color:#eee;}
.guResearchPhone {white-space: nowrap;}
.sortBySelected {font-weight: bold; background: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "sortorderAZ")") no-repeat right center;  }
.guResearchComp .listInfo p {display:inline;}
.guResearchComp .itemCountPicker {display: inline;}
.guResearchComp .itemCountPicker select {width: 125px;}

.guResearchComp .publicationListInfo.publicationGroup {color:#ccc;}
.guResearchComp .listInfo p {display:inline;}

.personList table th a {display: block; text-decoration: none;}
.personList table th a:hover {text-decoration: underline;}
#bodyArea .personList table th a:visited {color: #015497;}
#bodyArea .personList table th a:hover {color: red;}


ul.relatedSubjectListNode {list-style-image:url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "angle2")"); margin: 0px 0px 0px 16px;}
ul.relatedSubjectListNode ul ul {list-style-type: none; margin: 0px 0px 0px 20px;}
ul.relatedSubjectListNode.topLevel {list-style-type: none;list-style-image:none;}
ul.subjectListNode, ul.subjectListNode ul li ul {list-style-type: none; display: block; margin-left: 20px;}
ul.topLevel {display: block; margin: 0px;}
li.treeNode a {cursor: pointer; text-decoration: underline; line-height: 20px;}
a.listIcon, div.listIcon {display: none; cursor: default; width: 12px; height: 12px; background-repeat: no-repeat; background-position: left center; float: left; margin-right: 2px;margin-top: 4px;}
a.arrow {background-image: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "small_arrow")"); /*cursor: pointer; */ margin-right: 5px;background-position: left bottom;}
a.arrowExpanded {background-image: url("$cl.getAssetUrl($cl.infoGlueComponent.contentId, "small_arrow_down")"); /*cursor: pointer;*/ margin-right: 5px;background-position: left bottom;}
.adminError {color:red; font-weight: bold;}
#kartenaMapDiv {display: none;}
.kartenaMapFrame {width: 320px; height: 320px;  border: 1px solid rgb(150, 150, 150); background-color: rgb(198, 218, 183);}

a:active, a:focus{outline: 0;}