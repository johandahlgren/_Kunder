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

<structure:componentPropertyValue id="publicationType" propertyName="PublicationType" useInheritance="false"/>
<structure:componentPropertyValue id="description" propertyName="Description" useInheritance="false"/>
<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="hideTypeText" propertyName="HideTypeText" useInheritance="false"/>
<structure:componentPropertyValue id="maxItems" propertyName="MaxItems" useInheritance="false"/>
<structure:componentPropertyValue id="pageCategory" propertyName="PageCategory" useInheritance="true"/>

<c:if test="${not empty pageCategory and pageCategory ne 'all'}">
	<c:set var="areaCondition" value="Area=/ISFArea/${pageCategory}"/>
</c:if>

<c:choose>
	<c:when test="${not empty publicationType}">
		<content:matchingContents id="publications" contentTypeDefinitionNames="${publicationType}" categoryCondition="${areaCondition}" />
	</c:when>
	<c:otherwise>
		<content:matchingContents id="publications" contentTypeDefinitionNames="ISF Skrivelser" categoryCondition="${areaCondition}" />
	</c:otherwise>
</c:choose>

<c:if test="${not empty publications}">
	<content:contentSort id="publications" input="${publications}">
		<content:sortContentProperty name="publishDateTime" ascending="false" />
	</content:contentSort>
	
	<c:if test="${not empty maxItems}">
		<common:sublist id="publications" list="${publications}" count="${maxItems}" />
	</c:if>
</c:if>

<!-- eri-no-index -->

<div class="publicationList">
	<div class="innerContainer">
		<c:if test="${not empty title}">
			<h2><c:out value="${title}" escapeXml="false" /></h2>
		</c:if>
		<c:if test="${not empty description}">
			<p><c:out value="${description}" escapeXml="false" /></p>
		</c:if>
		<table summary="<structure:componentLabel mapKeyName="TableSummary"/>">
			<thead>
				<tr>
					<th scope="col"><structure:componentLabel mapKeyName="Title"/></th>
					<th scope="col"><structure:componentLabel mapKeyName="Published"/></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="publication" items="${publications}">
					<content:contentAttribute id="title" attributeName="Title" contentId="${publication.id}" disableEditOnSight="true"/>

					
					<%-- Find the electronic version --%>
					<content:assets id="assets" contentId="${publication.id}" />
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
					
					<c:if test="${not empty digitalVersionAsset}">
						<tr>
							<td class="pdfCol">
								<content:assetUrl id="pdfUrl" digitalAssetId="${digitalVersionAsset.digitalAssetId}" />
								<a href="<c:out value="${pdfUrl}" escapeXml="false" />" class="pdfLink" title="<structure:componentLabel mapKeyName="DigitalVersionTitle"/>" target="_blank">
									<c:out value="${title}" escapeXml="false" />
								</a>
							</td>
							<td class="minimumWidthNoWrapColumn">
								<common:formatter value="${publication.publishDateTime}" pattern="yyyy-MM"/>
							</td>
						</tr>
					</c:if>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>

<!-- /eri-no-index -->