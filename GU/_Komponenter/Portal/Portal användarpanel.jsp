<%@ page import="java.util.*,java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
<%@ taglib prefix="common" uri="infoglue-common"%>
<%@ taglib prefix="content" uri="infoglue-content"%>
<%@ taglib prefix="page" uri="infoglue-page"%>
<%@ taglib prefix="structure" uri="infoglue-structure"%>
<%@ taglib uri="infoglue-management" prefix="management"%>

<page:pageContext id="pc" />
<page:deliveryContext id="dc" operatingMode="0"/>

<structure:componentPropertyValue id="phoneBookLink" propertyName="PhoneBookLink" useInheritance="true"/>
<structure:componentPropertyValue id="webMailLink" propertyName="WebMailLink" useInheritance="true"/>

<c:set var="userName" value="${pc.principal.firstName} ${pc.principal.lastName}" />

<%
	String userName = (String)pageContext.getAttribute("userName");
	
	if(userName != null){
		userName = userName.toUpperCase();
		pageContext.setAttribute("userName", userName);
	}
%>

<div id="pageheader-list-div">
	<div id="userPanelContainer">
		<ul class="pageheader-list">
			<li class="ph-separator">			
			</li>
			<li>
				<!-- Portalen -->
				<a href="#" class="ph-list-text" ><structure:componentLabel mapKeyName="PortalLabel" /></a>
			</li>
			<li class="ph-separator">			
			</li>
			<li>
				<!-- Telefon -->
				<a id="ph-phone-link" class="ph-picture-link" href="#" alt="" ></a>
			</li>
			<li class="ph-separator">			
			</li>
			<li>
				<!-- Meddelanden -->
				<a id="ph-message-link" class="ph-picture-link" href="#" alt="" ></a>
			</li>
			<li class="ph-separator">			
			</li>
			<li>
				<!-- Bokmärken/länkar -->	
				<a id="ph-bookmark-link" class="ph-picture-link" href="#" alt=""></a>
				<div id="bookmarks-container">
					<a id="ph-bookmark-close" href="#" alt=""></a>							
					<common:include relationAttributeName="RelatedComponents" contentName="Portal Bokmärkeslista"/>
					<common:include relationAttributeName="RelatedComponents" contentName="Portal Länkar"/>
				</div>			
			</li>
			<li class="ph-separator">			
			</li>
			<li>
				<!-- Person -->			
				<a id="ph-contact-link" class="ph-picture-link" href="#" alt=""></a>
			</li>
			<li class="ph-separator">			
			</li>
			<li>
				<!-- Namn -->			
				<p id="ph-text-name" class="ph-list-text" ><c:out value="${userName}"/></p>
			</li>
			<li class="ph-separator">
			<li>
				<!-- Logga ut -->
				<a href="#" class="ph-list-text" ><structure:componentLabel mapKeyName="LogoutLabel" /></a>
			</li>
			<li class="ph-separator">			
			</li>
		</ul>
	</div>
</div>


<script type="text/javascript">
$(document).ready(function(){
	$('#ph-bookmark-link').click(function(){
		if ($('#bookmarks-container').css('display') == "none"){
			$('#ph-bookmark-link').parent().css('background-color', "white"); 
			$('#bookmarks-container').show();
		} else{
			$('#bookmarks-container').hide();
			$('#ph-bookmark-link').parent().css('background-color', ""); 
		}
	});	
	$('#ph-bookmark-close').click(function(){
		if ($('#bookmarks-container').css('display') == "none"){
			$('#ph-bookmark-link').parent().css('background-color', "white"); 
			$('#bookmarks-container').show();
		} else{
			$('#bookmarks-container').hide();
			$('#ph-bookmark-link').parent().css('background-color', ""); 
		}
	});	
});
</script>

