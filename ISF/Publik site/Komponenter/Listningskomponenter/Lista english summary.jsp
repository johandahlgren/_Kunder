<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-management" prefix="management" %>

<%@page import="org.infoglue.cms.entities.content.DigitalAssetVO"%>

<page:pageContext id="pc"/>

<!-- eri-no-index -->
<!-- eri-no-follow -->

<structure:componentPropertyValue id="area" propertyName="Area" useInheritance="false"/>
<structure:componentPropertyValue id="maxItems" propertyName="MaxItems" useInheritance="false"/>

<c:choose>
	<c:when test="${empty area and pc.isDecorated}">
		<div class="adminMessage"><structure:componentLabel mapKeyName="NoAreaSelected"/></div>
	</c:when>
	<c:otherwise>
		<c:set var="areaCondition" value="Area=/ISFArea/${area}"/>
		<content:matchingContents id="publications" contentTypeDefinitionNames="ISF Rapport" categoryCondition="${areaCondition}" skipLanguageCheck="true"/>
		<common:size id="size" list="${publications}" />

		<c:if test="${not empty publications}">
			<content:contentSort id="publications" input="${publications}">
				<content:sortContentProperty name="publishDateTime" ascending="false" />
			</content:contentSort>
			<c:if test="${not empty maxItems}">
				<common:sublist id="publications" list="${publications}" startIndex="0" count="${maxItems}"/>
			</c:if>

			<div class="publicationList">
				<div class="innerContainer">
					<h2><structure:componentLabel mapKeyName="${area}"/></h2>
					
					<c:if test="${not empty description}">
						<p><c:out value="${description}" escapeXml="false" /></p>
					</c:if>
					
					<table summary="<structure:componentLabel mapKeyName="TableSummary"/>">
						<thead>
							<tr>
								<th><structure:componentLabel mapKeyName="Title"/></th>
								<th><structure:componentLabel mapKeyName="Published"/></th>
							</tr>
						</thead>
						<tbody>
							<management:language id="swe" languageCode="sv"/>
							<c:forEach var="publication" items="${publications}">
								<c:remove var="title"/>
								<content:contentAttribute id="title" attributeName="EnglishTitle" contentId="${publication.id}" disableEditOnSight="true" languageId="${swe.languageId}" />
								<c:if test="${empty title}">
									<content:contentAttribute id="title" attributeName="Title" contentId="${publication.id}" disableEditOnSight="true" languageId="${swe.languageId}" />
								</c:if>
								
								<content:assets id="assets" contentId="${publication.id}" />
				
								<c:set var="pdfUrl" value="" />
								<c:set var="pdfAsset" value="" />
								
								<%
									int counter = 0;
								%>
								
								<%-- Find the english PDF --%>
								
								<common:size id="size" list="${assets}"/>
																
								<c:forEach var="asset" items="${assets}">
									<content:assetFilePath id="assetPath" digitalAssetId="${asset.id}" />
									<content:assetUrl id="digitalVersion" digitalAssetId="${asset.id}" />
									<%
										DigitalAssetVO asset = (DigitalAssetVO)pageContext.getAttribute("asset");
										String filePath = (String)pageContext.getAttribute("assetPath");
										if (filePath.endsWith(".pdf"))
										{
											if (counter == 1)
											{
												pageContext.setAttribute("pdfAsset", asset);
												break;
											}
											counter ++;
										}
									%>
								</c:forEach>
								
								<c:if test="${not empty pdfAsset}">
									<content:assetUrl id="pdfUrl" digitalAssetId="${pdfAsset.digitalAssetId}" />
								</c:if>
								
								<c:if test="${not empty pdfAsset or pc.isDecorated}">
									<tr>
										<c:choose>
											<c:when test="${empty pdfAsset and pc.isDecorated}">
												<td colspan="2">
													<div class="adminMessage"><structure:componentLabel mapKeyName="NoEnglishPdfFound"/><br/>&quot;<c:out value="${title}" escapeXml="false" />&quot;</div>
												</td>
											</c:when>
											<c:otherwise>
												<td class="pdfCol">
													<a href="<c:out value="${pdfUrl}" escapeXml="false" />" target="_blank" class="pdfLink"><c:out value="${title}" escapeXml="false" /></a>
												</td>
												<td>
													<common:formatter value="${publication.publishDateTime}" pattern="yyyy-MM"/>
												</td>
											</c:otherwise>
										</c:choose>
									</tr>
								</c:if>
							</c:forEach>
						</tbody>
					</table>
				</div>
			</div>
		</c:if>
	</c:otherwise>
</c:choose>

<!-- /eri-no-follow -->
<!-- /eri-no-index -->