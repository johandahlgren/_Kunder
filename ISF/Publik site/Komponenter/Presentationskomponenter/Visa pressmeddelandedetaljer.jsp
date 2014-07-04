<%@page import="org.infoglue.cms.entities.content.DigitalAssetVO"%>
<%@page import="java.text.DecimalFormat"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.List"%>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib prefix="management" uri="infoglue-management" %>

<%@page import="org.infoglue.cms.controllers.kernel.impl.simple.RegistryController"%>
<%@page import="org.infoglue.cms.applications.databeans.ReferenceBean"%>
<%@page import="org.infoglue.cms.entities.structure.SiteNodeVO"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.TemplateController"%>
<%@page import="org.infoglue.cms.entities.management.LanguageVO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<structure:componentPropertyValue id="encodeEmailLabel" propertyName="EmailProtectionLabel" useInheritance="true"/>
<structure:pageUrl id="shoppingBasketPageUrl" propertyName="ShoppingBasketPage" useInheritance="true" />

<page:pageContext id="pc"/>

<page:pageAttribute id="pressRelease" name="pressRelease" />

<c:if test="${empty pressRelease}">
	<content:content id="pressRelease" propertyName="pressRelease"/>
	
	<c:if test="${not empty param.contentId}">
		<content:content id="pressRelease" contentId="${param.contentId}" />
	</c:if>
</c:if>

<c:if test="${empty pressRelease and pc.isDecorated}">
	<div class="adminMessage"><structure:componentLabel mapKeyName="NoPressReleaseProvided"/></div>
</c:if>

<c:if test="${not empty pressRelease}">
	<content:relatedContents id="report" contentId="${pressRelease.id}" attributeName="Report" onlyFirst="true" />
	<c:choose>
		<c:when test="${empty report and pc.isDecorated}">
				<div class="adminMessage"><structure:componentLabel mapKeyName="NoReportProvided"/></div>
		</c:when>
		<c:when test="${not empty report}">
			<content:contentAttribute id="reportNumber" attributeName="ReportNumber" contentId="${report.id}" disableEditOnSight="true"/>			
			<content:contentAttribute id="reportTitle" attributeName="Title" contentId="${report.id}" disableEditOnSight="true"/>	
			<content:contentAttribute id="contactPersonName" attributeName="ContactPersonName" contentId="${report.id}"  disableEditOnSight="true" />
			<content:contentAttribute id="contactPersonPhone" attributeName="ContactPersonPhone" contentId="${report.id}" disableEditOnSight="true" />
			<content:contentTypeDefinition id="contentTypeDef" contentId="${report.id}" />
			<content:assets id="assets" contentId="${report.id}" />
			
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
		</c:when>
	</c:choose>

	<c:if test="${not empty report}">
		<div class="textBox">
			<div class="innerContainer">
				<div id="reportDetails">
					<c:if test="${not empty reportNumber}">
						<h2><structure:componentLabel mapKeyName="Report" />&nbsp;<c:out value="${reportNumber}" escapeXml="false" /></h2>
					</c:if>
					
					<c:if test="${not empty reportTitle}">
						<h3><structure:componentLabel mapKeyName="ReportTitle"/></h3>
						<p class="reportTitle"><c:out value="${reportTitle}"/></p>
					</c:if>
					
					<c:if test="${not empty contactPersonName or not empty contactPersonPhone}">
						<h3><structure:componentLabel mapKeyName="ContactPerson"/></h3>
						<p>
							<span><c:out value="${contactPersonName}"/></span>
							<span><c:out value="${contactPersonPhone}"/></span>
						</p>
					</c:if>
					
					<!-- eri-no-index -->
					<structure:pageUrl id="readMoreLink" propertyName="PublicationDetailPage" contentId="${report.id}" />
					<h3><structure:componentLabel mapKeyName="MoreInfo"/></h3>
					<ul>
						<li>
							<a href="<c:out value="${readMoreLink}" escapeXml="false"/>"><structure:componentLabel mapKeyName="ReadMore"/></a>
						</li>
					</ul>
					
					<c:if test="${not empty digitalVersionAsset or contentTypeDef.name eq 'ISF Rapport'}">
						<h3><structure:componentLabel mapKeyName="DownloadAndOrder"/></h3>
						<ul>
							<c:if test="${not empty digitalVersionAsset}">
			 		 			<common:formatter id="digitalVersionSize" type="fileSize" value="${digitalVersionAsset.assetFileSize}" />
						 		<content:assetUrl id="digitalVersionURL" digitalAssetId="${digitalVersionAsset.digitalAssetId}" />
						 		<li><a class="pdfLink" href="<c:out value="${digitalVersionURL}" />" target="_blank" title="<structure:componentLabel mapKeyName="OpensInNewWindow"/>"><structure:componentLabel mapKeyName="DownloadAsPdf"/>&nbsp;(<c:out value="${digitalVersionSize}" />)</a></li>
							</c:if>
							<c:if test="${contentTypeDef.name eq 'ISF Rapport'}">
								<common:urlBuilder id="directOrderUrl" baseURL="${shoppingBasketPageUrl}" excludedQueryStringParameters="siteNodeId,sitenodeId,sitenodeid,contentId,directOrderReport">
									<common:parameter name="directOrderReport" value="${report.id}" />
								</common:urlBuilder>
								<li><a class="orderPrintLink" href="<c:out value="${directOrderUrl}" />" data-reportid="<c:out value="${report.id}" />"><structure:componentLabel mapKeyName="OrderPublication"/></a></li>
							</c:if>
						</ul>
					</c:if>
					<!-- /eri-no-index -->
				</div>
			</div>
		</div>
	</c:if>
</c:if>
