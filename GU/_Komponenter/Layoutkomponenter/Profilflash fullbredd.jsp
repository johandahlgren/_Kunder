<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>

<page:deliveryContext id="deliveryContext" disableNiceUri="true"/>

<structure:boundPage id="GUFlashVinjettXML" propertyName="GUFlashVinjettXML"/>
<content:boundContents id="flashImages" propertyName="GUFlashImages"/>
<structure:componentPropertyValue id="randomImages" propertyName="RandomFlashImages"/>

<c:if test="${not empty flashImages}">
	<c:set var="numberOfImages" value="0"/>
	<script type="text/javascript">
	<c:forEach var="image" items="${flashImages}" varStatus="loop">
		<c:set var="numberOfImages" value="${loop.count}"/>
		<content:assetUrl id="imageUrl" contentId="${image.contentId}" useInheritance="false"/>
		var assetUrl<c:out value="${loop.count}" /> = '<c:out value="${imageUrl}" />';
	</c:forEach>
	
	function randomUrl() {
	var numberOfAssets = <c:out value="${numberOfImages}" />;
	var random = Math.floor(numberOfAssets * Math.random()) + 1;
	var url = eval('assetUrl' + random);
	
	return url;
	}
	
	</script>
</c:if>

<structure:componentPropertyValue id="height" propertyName="Height"/>
<c:if test="${empty height || height == 'Undefined'}">
	<c:set var="height" value="300"/>
</c:if>

<common:urlBuilder id="xmlURL" baseURL="${GUFlashVinjettXML.url}" excludedQueryStringParameters="siteNodeId,languageId,contentId">
	<common:parameter name="originalSiteNodeId" value="${deliveryContext.siteNodeId}"/>
</common:urlBuilder>
<common:URLEncode id="xmlURL" value="${xmlURL}" encoding="iso-8859-1"/>

<script type="text/javascript">
	var IE6=(navigator.userAgent.toLowerCase().indexOf('msie 6') != -1) && (navigator.userAgent.toLowerCase().indexOf('msie 7') == -1)
	if(!IE6)
	{
	<!--
		$(document).ready(function() {
	    	swfobject.embedSWF("<content:assetUrl assetKey="guTopBanner" />", "swap", "100%", "<c:out value="${height}"/>", "9.0.0", false, { xmlURL: '<c:out value="${xmlURL}"  escapeXml="false"/>' }, { wmode: 'transparent', scale: 'noorder' } );
	    });
	-->
}
</script>

<div id="swap">
	<%-- Visa första bilden i flash image serie om flash inte är installerat --%>
	<img src="" alt="<c:out value="${txt}"/>" id="flashImage"/>
	<script type="text/javascript">
		<c:choose>
			<c:when test="${randomImages eq 'true'}">
				$("#flashImage").attr("src", randomUrl());
			</c:when>
			<c:otherwise>
				<content:assetUrl id="imageUrl" contentId="${flashImages[0].contentId}"/>
				$("#flashImage").attr("src", "<c:out value="${imageUrl}" />");
			</c:otherwise>
		</c:choose>
	</script>
</div>