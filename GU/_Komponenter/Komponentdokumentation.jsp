<%@page import="java.util.Calendar"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.TemplateController"%>
<%@page import="org.infoglue.cms.entities.content.ContentVO"%>
<%@page import="java.util.Comparator"%>
<%@page import="org.infoglue.cms.entities.content.DigitalAssetVO"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController" %>
<%@page import="org.infoglue.cms.entities.structure.SiteNodeVO" %>

<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="repositories" propertyName="Repositories" useInheritance="false"/>
<structure:componentPropertyValue id="viewAsStandalone" propertyName="ViewAsStandalone" useInheritance="false"/>
<structure:componentPropertyValue id="startNode" propertyName="StartNode" useInheritance="false"/>
<structure:componentPropertyValue id="encoding" propertyName="Encoding" useInheritance="false"/>
<content:content id="startNode" propertyName="StartNode" useInheritance="false" />

<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>

<c:if test="${empty title}">
	<structure:componentLabel id="title" mapKeyName="Title"/>
</c:if>

<c:choose>
	<c:when test="${not empty repositories and not empty startNode}">
		<content:matchingContents id="components" contentTypeDefinitionNames="HTMLTemplate" repositoryIds="${repositories}" startNodeId="${startNode.id}" />
	</c:when>
	<c:when test="${empty repositories and not empty startNode}">
		<content:matchingContents id="components" contentTypeDefinitionNames="HTMLTemplate" startNodeId="${startNode.id}" />
	</c:when>
	<c:when test="${not empty repositories and empty startNode}">
		<content:matchingContents id="components" contentTypeDefinitionNames="HTMLTemplate" repositoryIds="${repositories}" />
	</c:when>
	<c:otherwise>
		<content:matchingContents id="components" contentTypeDefinitionNames="HTMLTemplate" />
	</c:otherwise>
</c:choose>

<content:contentSort id="components" input="${components}">
	<content:sortContentProperty name="name" ascending="true" />
</content:contentSort>

<c:if test="${viewAsStandalone eq 'true'}">

<%@ page contentType="text/html; charset=UTF-8" %>
<%--
<?xml version="1.0" encoding="UTF-8"?>--%>
<%--
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd"> --%>
<!DOCTYPE html>
<html>
	<head>
		<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
		<title><c:out value="${title}"/></title>
		
		<content:assetUrl id="faviconUrl" assetKey="favicon"/>
		<link rel="shortcut icon" href="<c:out value="${faviconUrl}"/>"/>
		
		<script type="text/javascript" src="http://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js"></script>
	</head>
	<body>
</c:if>
<!-- eri-no-index -->
	<%--
	<%
	TemplateController tc = (TemplateController)pageContext.getAttribute("pc");
	tc.getDeliveryContext().getHtmlHeadItems().add("<link href='http://fonts.googleapis.com/css?family=Asap' rel='stylesheet' type='text/css'>");
	%>--%>
		<content:assetUrl id="logoUrl" assetKey="logo"/>
		<content:assetUrl id="first" assetKey="first"/>
		<content:assetUrl id="last" assetKey="last"/>
		<content:assetUrl id="next" assetKey="next"/>
		<content:assetUrl id="previous" assetKey="previous"/>
		
		<style type="text/css" >
			* {font-family: verdana, sans-serif; font-size: 14px;}
			body {margin:0;padding:0; background-color: rgb(230, 230, 220)}
			a {text-decoration: none;color:black;}
			h1 {font-size: 32px;}
			h2 {font-size: 24px; margin: 0; padding: 0; float: left; font-weight: normal;}
			table {border-collapse: collapse;width: 100%; }
			table tr th {border-bottom: 1px solid rgb(220, 220, 220); padding-bottom: 2px; text-align: left; padding-left:10px;}
			table tr td {padding: 2px;}
			table tr.property td {padding:6px 10px; border-bottom:1px solid rgb(240, 240, 240);}
			table tr.property:hover td {background-color: rgb(250, 250, 240);}
			p {margin: 0 0 12px 0; line-height: 20px;}
			.message {font-style: italic;}
			.componentSeparator {height: 2px; background-color: black;}
			.componentHeader {margin-top: 40px; margin-bottom: 20px; background-color: rgb(220, 220, 220); padding: 4px 10px; height: 32px; box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.25); border-radius: 5px;}
			.componentHeaderDate {float: right; color: rgb(150, 150, 150); line-height: 32px;}
			.description {padding: 0 10px;}
			#componentDocumentation #main tr.description td {padding: 6px 10px;}
			#componentDocumentation #main ul {padding-left: 25px;}
			#componentDocumentation #main .description {padding-bottom: 15px;}
			#head {display:block;position:fixed;width:300px;height: 190px;top:0;left:0;	background-image: url(<c:out value="${logoUrl}"/>);background-repeat: no-repeat;background-position: 50% 30%;}
			#head h1 {margin-top:145px;text-align: center; color: rgb(100, 100, 90);}
			#menu {position:fixed; width:300px; top:210px;}
			#menu ul {list-style-type: none; padding:0; margin:0;}
			#menu ul li {padding:0 10px; border-bottom:1px solid rgb(230, 230, 230);}
			#menu ul li:hover {box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.25);}
			#menu .menuItemSelected{background-color: rgb(250, 250, 240); box-shadow: 0px 0px 15px rgba(0, 0, 0, 0.25);}
			#menu ul a {display: block; height: 32px; line-height: 32px;}
			#menu #developerDescButton {padding:5px 10px;display:block;margin-top:40px;}
			#menuBox {display: block; width:280px; max-height: 500px; overflow: auto; box-shadow: inset 1px 1px 3px rgba(0, 0, 0, 0.25); background-color: rgb(240, 240, 210); margin: 0 10px; border-radius: 5px; border: 1px solid rgb(180, 180, 160);}
			#main {margin-left:300px;padding: 0 20px 20px 20px;border-left: 1px solid rgb(180, 180, 180); border-right: 1px solid rgb(180, 180, 180); box-shadow:0px 0px 15px rgba(0, 0, 0, 0.25) inset; background-color: white; width: 700px;}
			.button
			{
				text-align: center;
				color: rgb(50, 50, 30);
				line-height: 40px;
				border: 1px solid rgb(0, 150, 0); 
				padding: 10px 20px; 
				margin: 20px 0 0 0; 
				cursor: pointer; 
				display: block;
				width: 100px; 
				height: 40px;
				border: 1px outset rgb(180, 180, 130); padding: 5px 10px; box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5); -webkit-box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5); -moz-box-shadow: 2px 2px 5px rgba(0, 0, 0, 0.5);
				background-color: rgb(240, 240, 220);
				margin: 0 20px;
				border-radius: 5px;
			}
			a.button {margin-bottom: 10px; background-position: center; background-repeat: no-repeat; background-color: rgb(240, 240, 220);}
			.buttonActive, a.button:active {box-shadow: inset 3px 3px 10px 0 rgba(0, 0, 0, 0.5);}
			#firstAnchor {background-image: url(<c:out value="${first}"/>);}
			#lastAnchor {background-image: url(<c:out value="${last}"/>);}
			#nextAnchor {background-image: url(<c:out value="${next}"/>);}
			#previousAnchor {background-image: url(<c:out value="${previous}"/>);}
			div.toggleButton {width: 240px;}
			#navigator {display: block; width: 120px; ;position: fixed; left:1042px; top:250px;}
			#navigator a {display: block; width:100px; height: 100px;}
		</style>
		<style type="text/css" media="print">
			* {background-image:none; background-color: white;}
			#developerDescButton {display: none;}
			#menu {display: none;}
			#head {left:20px;top:20px;width: 100%;height: 55px;vertical-align: bottom;position:relative;border-width: 0;background-image:none;background-color: white;}
			#head h1 {margin-top:10px;font-size: 56px;color:black;}
			#main {margin-left:10px;box-shadow:none;border-width: 0;}
			#main tr {page-break-inside:avoid;}
			#main .componentHeader {box-shadow:none;}
			#navigator {display:none;}
		</style>
			
		<div id="componentDocumentation">
			<c:if test="${not empty components}">
				<div id="head">
					<h1><c:out value="${title}"/></h1>
				</div>
				<div id="menu">
					<div id="menuBox">
						<ul>
							<c:forEach var="component" items="${components}">
								<li id="menu_<c:out value="${component.id}" />"><a href="#component_<c:out value="${component.id}"/>"><c:out value="${component.name}"/></a></li>
							</c:forEach>
						</ul>
					</div>
					<div class="button toggleButton" id="developerDescButton">
						<structure:componentLabel mapKeyName="ToggleDeveloperDesc"/>
					</div>
				</div>
				<div id="main">
					<c:forEach var="component" items="${components}">
						<div class="component">
							<%-- Reset fields --%>
							<c:remove var="description"/>
							<c:remove var="developerDescription"/>
							<c:remove var="componentProperties"/>
							<c:remove var="propertiesHTML"/>

							<a id="component_<c:out value="${component.id}"/>"></a>
							<br/>
							<div class="componentHeader">
								<h2><c:out value="${component.name}"/></h2>
								<content:contentVersion id="cv" content="${component}" />
								<common:formatter id="lastModifedDate" value="${cv.modifiedDateTime}" pattern="yyyy-MM-dd HH:mm" />
								<div class="componentHeaderDate"><structure:componentLabel mapKeyName="LastModificationDate"/>: <c:out value="${lastModifedDate}"/> <structure:componentLabel mapKeyName="By"/> "<c:out value="${cv.versionModifier}" />"</div>
							</div>
							<div class="description">
								<content:contentAttribute id="description" attributeName="Description" contentId="${component.id}" disableEditOnSight="true" />
								<c:choose>
									<c:when test="${empty description}">
										<p class="message"><structure:componentLabel mapKeyName="NoDescription"/></p>
									</c:when>
									<c:otherwise>
										<c:out value="${description}" escapeXml="false"/>
									</c:otherwise>
								</c:choose>
							</div>
							<div class="description developerDescription">
								<content:contentAttribute id="developerDescription" attributeName="DeveloperDescription" contentId="${component.id}" disableEditOnSight="true" />
								<c:choose>
									<c:when test="${empty developerDescription}">
										<p class="message"><structure:componentLabel mapKeyName="NoDeveloperDescription"/></p>
									</c:when>
									<c:otherwise>
										<c:out value="${developerDescription}" escapeXml="false"/>
									</c:otherwise>
								</c:choose>
							</div>
							
							<content:contentAttribute id="componentProperties" attributeName="ComponentProperties" contentId="${component.id}" disableEditOnSight="true" />
								
							<c:set var="propertiesXSLT">
								<xsl:stylesheet version="2.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
								  	<xsl:output method="xml" omit-xml-declaration="yes" version="1.0" encoding="<c:out value="${encoding}" />" indent="yes"/>
								    
									<xsl:template match="/"> 
										<table>
									     	<tr>
									       		<th><structure:componentLabel mapKeyName="PropName"/></th>
									       		<th><structure:componentLabel mapKeyName="PropDefaultValue"/></th>												
									       		<th><structure:componentLabel mapKeyName="PropDescription"/></th>
									     	</tr>
								   	    	<xsl:for-each select="//property">
										     	<tr class="property">
										     		<%-- Prints a n-dash for every value that is not set --%>
										      		<td><xsl:choose><xsl:when test="@displayName != ''"><xsl:value-of select="@displayName"/></xsl:when><xsl:otherwise>&#8211;</xsl:otherwise></xsl:choose></td>
										      		<td><xsl:choose><xsl:when test="@defaultValue != ''"><xsl:value-of select="@defaultValue"/></xsl:when><xsl:otherwise>&#8211;</xsl:otherwise></xsl:choose></td>
										      		<td><xsl:choose><xsl:when test="@description != ''"><xsl:value-of select="@description"/></xsl:when><xsl:otherwise>&#8211;</xsl:otherwise></xsl:choose></td>
										     	</tr>
								    		</xsl:for-each>
							    		</table>
								  	</xsl:template>
								</xsl:stylesheet>
							</c:set>
							
							<c:catch var="error">
								<c:if test="${not empty componentProperties}">
									<common:XSLTransform id="propertiesHTML" xmlString="${componentProperties}" styleString="${propertiesXSLT}" outputFormat="string"/>
								</c:if>
							</c:catch>

							<c:if test="${not empty error}">
								<tr>
									<td colspan="3">
										<structure:componentLabel mapKeyName="PropertiesError"/> <c:out value="${error}"/>
									</td>
								</td>
							</c:if>
										
							<c:out value="${propertiesHTML}" escapeXml="false"/>
						</div>
					</c:forEach>
				</div>
				<div id="navigator">
				
					<a class="button" id="firstAnchor" href="#" title="<structure:componentLabel mapKeyName="First" />"></a>
					<a class="button" id="previousAnchor" href="#" title="<structure:componentLabel mapKeyName="Previous" />"></a>
					<a class="button" id="nextAnchor" href="#" title="<structure:componentLabel mapKeyName="Next" />"></a>
					<a class="button" id="lastAnchor" href="#" title="<structure:componentLabel mapKeyName="Last" />"></a>
				</div>
			</c:if>
		</div>
		<script type="text/javascript">
		<!--
			function scrollTo(h) {
				if (h) {
					if (h.indexOf("#") != 0) {
						h = "#" + h;
					}
					$('html,body').animate({scrollTop:$(h).offset().top}, 300);
					window.location.hash = h;
					
					var itemId = h.substring(h.indexOf("_") + 1);
					markSelected("menu_" + itemId);
				}
			}
			function firstAnchor() {
				var firstHash = $(".component").first().children("a").attr("id");
				if (firstHash) {
					scrollTo(firstHash);
				}
			}
			function nextAnchor() {
				if (window.location.hash) {
					// the hash has a hash so we do not need to add a jQuery-hash
					var nextHash = $(window.location.hash).parent().next().children("a").attr("id");
					scrollTo(nextHash);
				} else {
					var firstHash = $(".component").first().children("a").attr("id");
					if (firstHash) {
						scrollTo(firstHash);
					}
				}
			}
			
			function previousAnchor() {
				if (window.location.hash) {
					// the hash has a hash so we do not need to add a jQuery-hash
					var prevHash = $(window.location.hash).parent().prev().children("a").attr("id");
					scrollTo(prevHash);
				}
			}
			
			function lastAnchor() {
				var lastHash = $(".component").last().children("a").attr("id");
				if (lastHash) {
					scrollTo(lastHash);
				}
			}
			
			function toggleButton(aButtonId)
			{
				var button = $("#" + aButtonId);
				if (button.hasClass("buttonActive"))
				{
					button.removeClass("buttonActive");
				}
				else
				{
					button.addClass("buttonActive");
				}
			}
			
			function markSelected(aElementId)
			{
				$("#menuBox li").removeClass("menuItemSelected");
				$("#" + aElementId).addClass("menuItemSelected");
			}
			
			$(".developerDescription").hide();
			$("#developerDescButton").click(function() {
				$(".developerDescription").toggle();
				toggleButton(this.id);
			});
			
			$(document).ready(function($) {
				$("#firstAnchor").click(function(event){
					event.preventDefault();
					firstAnchor();
				});
				$("#previousAnchor").click(function(event){
					event.preventDefault();
					previousAnchor();
				});
				$("#nextAnchor").click(function(event){
					event.preventDefault();
					nextAnchor();
				});
				$("#lastAnchor").click(function(event){
					event.preventDefault();
					lastAnchor();
				});
				
				$("a").click(function(event){
					if (this.hash) {
						event.preventDefault();
						scrollTo(this.hash);
					}
				});
				$("#menuBox li").click(function(event){
					markSelected(this.id);
				});
			});
		//-->
		</script>

<!-- /eri-no-index -->

<c:if test="${viewAsStandalone eq 'true'}">
		</body>
	</html>
</c:if>