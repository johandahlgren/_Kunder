<%@ taglib prefix="c"         uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt"       uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="common"    uri="infoglue-common" %>
<%@ taglib prefix="content"   uri="infoglue-content" %>
<%@ taglib prefix="page"      uri="infoglue-page" %>
<%@ taglib prefix="structure" uri="infoglue-structure" %>
<%@ taglib prefix="management" uri="infoglue-management" %>

<%@page import="org.infoglue.cms.entities.content.DigitalAssetVO"%>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="encodeEmailLabel" propertyName="EmailProtectionLabel" useInheritance="true"/>
<structure:componentPropertyValue id="pageCategory" propertyName="PageCategory" useInheritance="true"/>

<c:if test="${not empty pageCategory}">
	<c:set var="areaCondition" value="Area=/ISFArea/${pageCategory}"/>
</c:if>

<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>
<c:set var="dateFormat" value="yyyy-MM"/>
<fmt:setLocale scope="session" value="sv_SE"/> 

<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="moreLinkText" propertyName="MoreLinkText" useInheritance="false"/>

<c:if test="${empty title}">
	<structure:componentLabel id="title" mapKeyName="DefaultHeadline"/>
</c:if>

<content:matchingContents id="unsortedItems" contentTypeDefinitionNames="ISF Remissvar" categoryCondition="${areaCondition}" />

<content:contentSort id="sortedItems" input="${unsortedItems}">
	<content:sortContentProperty name="publishDateTime" ascending="false"/>
</content:contentSort>

<common:size id="size" list="${sortedItems}" />

<c:if test="${size gt 0}">
	<div class="publicationList">
		<div class="innerContainer">
			<c:if test="${not empty title}">
				<h2><c:out value="${title}" escapeXml="false" /></h2>
			</c:if>
			<table summary="<structure:componentLabel mapKeyName="Summary"/>">
				<tr>
					<th class="pdfCol"><structure:componentLabel mapKeyName="Title"/></th>
					<th><structure:componentLabel mapKeyName="Label"/></th>
					<th><structure:componentLabel mapKeyName="Reference"/></th>
					<th><structure:componentLabel mapKeyName="Published"/></th>
				</tr>
				
				<c:forEach var="item" items="${sortedItems}" varStatus="loop">
					<c:if test="${item != null}">
						<content:contentAttribute id="title" contentId="${item.contentId}" attributeName="Title" disableEditOnSight="true"/>				
						<content:contentAttribute id="label" contentId="${item.contentId}" attributeName="Label" disableEditOnSight="true"/>
						<content:contentAttribute id="reference" contentId="${item.contentId}" attributeName="Reference" disableEditOnSight="true"/>
				 	 
				 	 	<structure:pageUrl id="detailUrl" siteNodeId="${detailPage.siteNodeId}" contentId="${item.contentId}" />
				 	 			
				 	 	<content:assets id="assets" contentId="${item.id}" />
				
						<%-- Find the electronic version --%>
						
						<c:forEach var="asset" items="${assets}">
							<content:assetFilePath id="assetPath" digitalAssetId="${asset.id}" />
							<content:assetUrl id="digitalVersion" digitalAssetId="${asset.id}" />
							<%
								DigitalAssetVO asset = (DigitalAssetVO)pageContext.getAttribute("asset");
								String filePath = (String)pageContext.getAttribute("assetPath");
								if (filePath.endsWith(".pdf"))
								{
									pageContext.setAttribute("digitalVersionAsset", asset);
									break;
								}
							%>
						</c:forEach>
				 	 			
				 	 	<content:assetUrl id="pdfUrl" digitalAssetId="${digitalVersionAsset.digitalAssetId}" />
				 	 											
						<tr>	
							<td class="pdfCol"><a class="pdfLink" href="<c:out value="${pdfUrl}" escapeXml="false"/>" target="_blank"><c:out value="${title}"/></a></td>
							<td><c:out value="${label}" escapeXml="true"/></td>
							<td><c:out value="${reference}" escapeXml="true"/></td>
							<td><common:formatter type="java.util.Date" value="${item.publishDateTime}" pattern="yyyy-MM" /></td>
						</tr>
					</c:if>
				</c:forEach>
			</table>
		</div>	
	</div>
</c:if>