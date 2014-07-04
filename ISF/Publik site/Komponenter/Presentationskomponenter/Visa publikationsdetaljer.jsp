<%@page import="org.infoglue.cms.entities.content.DigitalAssetVO"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-common" prefix="common" %>

<page:pageContext id="pc"/>

<content:content id="publication" propertyName="Publication"/>

<structure:pageUrl id="shoppingBasketPageUrl" propertyName="ShoppingBasketPage" useInheritance="true" />

<c:if test="${not empty param.contentId}">
	<content:content id="publication" contentId="${param.contentId}" />
</c:if>

<div class="textBox">
	<div class="innerContainer">
		<div id="publicationDetails">
			<c:if test="${empty publication and pc.isDecorated}">
				<div class="adminMessage"><structure:componentLabel mapKeyName="NoPublicationProvided"/></div>
			</c:if>
			
			<c:if test="${not empty publication}">
				
				<content:assignedCategories id="subjectAreaList" contentId="${publication.id}" categoryKey="Area" />
				<content:contentAttribute id="contactPersonName" contentId="${publication.id}" attributeName="ContactPersonName" disableEditOnSight="true" />
				<content:contentAttribute id="contactPersonPhone" contentId="${publication.id}" attributeName="ContactPersonPhone" disableEditOnSight="true" />
				<content:contentAttribute id="governmentAssignment" contentId="${publication.id}" attributeName="GovernmentAssignment" disableEditOnSight="true" />
				<content:contentTypeDefinition id="contentTypeDef" contentId="${publication.id}" />
				
				<%--<content:assignedCategories id="publicationTypes" contentId="${publication.id}" categoryKey="ISFPublicationType" />--%>
				<content:relatedContents id="pressrelease" attributeName="Pressrelease" contentId="${publication.id}" onlyFirst="true" />
				
				<h2><structure:componentLabel mapKeyName="Title"/></h2>
				
				<content:assets id="assets" contentId="${publication.id}" />
				
				
				<%-- Find the electronic version --%>
				
				<%
					int counter = 0;
				%>
				
				<c:forEach var="asset" items="${assets}">
					<content:assetFilePath id="assetPath" digitalAssetId="${asset.id}" />
					<content:assetUrl id="digitalVersion" digitalAssetId="${asset.id}" />
					<%
						DigitalAssetVO asset = (DigitalAssetVO)pageContext.getAttribute("asset");
						String filePath = (String)pageContext.getAttribute("assetPath");
						if (filePath.endsWith(".pdf"))
						{
							if (counter == 0)
							{
								pageContext.setAttribute("digitalVersionAsset", asset);
							}
							else if (counter == 1)
							{
								pageContext.setAttribute("englishSummaryAsset", asset);
								break;
							}
							counter ++;
						}
					%>
				</c:forEach>
								
				<%-- Find the cover image --%>
				
				<c:forEach var="asset" items="${assets}">
					<content:assetFilePath id="assetPath" digitalAssetId="${asset.id}" />
					<content:assetUrl id="publicationCoverURL" digitalAssetId="${asset.id}" />
					<%
						DigitalAssetVO asset = (DigitalAssetVO)pageContext.getAttribute("asset");
						String filePath = (String)pageContext.getAttribute("assetPath");
						if (filePath.endsWith(".png") || filePath.endsWith(".jpg") || filePath.endsWith(".gif"))
						{
							pageContext.setAttribute("coverAsset", asset);
							break;
						}
					%>
				</c:forEach>
				
				<c:if test="${not empty coverAsset}">
					<c:if test="${contentTypeDef.name eq 'ISF Rapport'}">
						<c:set var="typeClass" value="report" />
					</c:if>
					<content:assetUrl id="coverURL" digitalAssetId="${coverAsset.digitalAssetId}" />
			 		<div id="publicationCover" class="<c:out value="${typeClass}" />"><img src="<c:out value="${coverURL}"/>" alt="<structure:componentLabel mapKeyName="PublicationCoverAltText"/>" /></div>
				</c:if>

				<c:if test="${governmentAssignment eq 'true'}">
					<p><structure:componentLabel mapKeyName="GovernmentAssignment"/></p>
				</c:if>
	
				<c:if test="${not empty subjectAreaList}">
					<h3><structure:componentLabel mapKeyName="SubjectAreas"/></h3>
					<p>
						<c:forEach var="subjectArea" items="${subjectAreaList}" varStatus="loop"><management:categoryDisplayName id="subjectAreaName" categoryVO="${subjectArea}" /><c:out value="${subjectAreaName}" /><c:if test="${not loop.last}">, </c:if></c:forEach>
					</p>
				</c:if>
				
				<c:if test="${not empty contactPersonName or not empty contactPersonPhone}">
					<h3><structure:componentLabel mapKeyName="ContactPerson"/></h3>
					<p>
						<c:if test="${not empty contactPersonName}">
							<span><c:out value="${contactPersonName}" escapeXml="false" /></span>
						</c:if>
						<c:if test="${not empty contactPersonPhone}">
							<span><structure:componentLabel mapKeyName="ContactPersonPhone"/>:&nbsp;<c:out value="${contactPersonPhone}" escapeXml="false" /></span>
						</c:if>
					</p>
				</c:if>

				<!-- eri-no-index -->
				<!-- eri-no-follow -->
				<c:if test="${not empty digitalVersionAsset or contentTypeDef.name eq 'ISF Rapport'}">	
					<h3><structure:componentLabel mapKeyName="DownloadAndOrder"/></h3>
					<ul>
						<c:if test="${not empty digitalVersionAsset}">
		 		 			<common:formatter id="digitalVersionSize" type="fileSize" value="${digitalVersionAsset.assetFileSize}" />
					 		<content:assetUrl id="digitalVersionURL" digitalAssetId="${digitalVersionAsset.digitalAssetId}" />
					 		<li><a class="pdfLink" href="<c:out value="${digitalVersionURL}" />" target="_blank" rel="attachment" title="<structure:componentLabel mapKeyName="OpensInNewWindow"/>"><structure:componentLabel mapKeyName="DownloadAsPdf"/>&nbsp;(<c:out value="${digitalVersionSize}" />)</a></li>
						</c:if>
						<c:if test="${contentTypeDef.name eq 'ISF Rapport'}">
							<common:urlBuilder id="directOrderUrl" baseURL="${shoppingBasketPageUrl}" excludedQueryStringParameters="siteNodeId,sitenodeId,sitenodeid,contentId,directOrderReport">
								<common:parameter name="directOrderReport" value="${publication.id}" />
							</common:urlBuilder>
							<li><a class="orderPrintLink" href="<c:out value="${directOrderUrl}" />" data-reportid="<c:out value="${publication.id}" />"><structure:componentLabel mapKeyName="OrderPublication"/></a></li>
						</c:if>
					</ul>
				</c:if>
				
				<c:if test="${not empty englishSummaryAsset or not empty pressrelease}">
					<h3><structure:componentLabel mapKeyName="MoreInfo"/></h3>
					<ul>
						<c:if test="${not empty englishSummaryAsset}">
		 		 			<common:formatter id="englishSummarySize" type="fileSize" value="${englishSummaryAsset.assetFileSize}" />
					 		<content:assetUrl id="englishSummaryURL" digitalAssetId="${englishSummaryAsset.digitalAssetId}" />
					 		<li><a class="pdfLink" href="<c:out value="${englishSummaryURL}" />" target="_blank" title="<structure:componentLabel mapKeyName="OpensInNewWindow"/>"><structure:componentLabel mapKeyName="EnglishSummary"/>&nbsp;(<c:out value="${englishSummarySize}" />)</a></li>
						</c:if>
						<c:if test="${not empty pressrelease}">
							<structure:pageUrl id="pressreleaseUrl" contentId="${pressrelease.id}" propertyName="PressReleaseDetailPage" /> 
							<li><a href="<c:out value="${pressreleaseUrl}" escapeXml="false" />" rel="attachment"><structure:componentLabel mapKeyName="PressRelease"/></a></li>
						</c:if>						
					</ul>
				</c:if>
				<!-- /eri-no-follow -->
				<!-- /eri-no-index -->
			</c:if>
		</div>
	</div>
</div>