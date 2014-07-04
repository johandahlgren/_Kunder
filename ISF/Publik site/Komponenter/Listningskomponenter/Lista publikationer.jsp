<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="titleProp" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="description" propertyName="Description" useInheritance="false"/>
<structure:componentPropertyValue id="pageCategory" propertyName="PageCategory" useInheritance="true"/>
<structure:componentPropertyValue id="publicationType" propertyName="PublicationType" useInheritance="false"/>
<structure:componentPropertyValue id="hideTypeText" propertyName="HideTypeText" useInheritance="false"/>
<structure:componentPropertyValue id="maxItems" propertyName="MaxItems" useInheritance="false"/>

<c:if test="${hideTypeText ne 'true' and not empty publicationType}">
	<structure:componentLabel id="publicationName" mapKeyName="${publicationType}" />

	<c:if test="${not empty publicationName}">
		<c:set var="title" value="${publicationName}" />
	</c:if>
</c:if>
<c:if test="${not empty titleProp}">
	<c:set var="title" value="${titleProp}" />
</c:if>

<c:if test="${not empty pageCategory and pageCategory ne 'all'}">
	<c:set var="areaCondition" value="Area=/ISFArea/${pageCategory}"/>
</c:if>

<c:choose>
	<c:when test="${publicationType eq 'Rapport'}">
		<content:matchingContents id="publications" contentTypeDefinitionNames="ISF Rapport" categoryCondition="${areaCondition}"/>
	</c:when>
	<c:when test="${publicationType eq 'Arbetsrapport'}">
		<content:matchingContents id="publications" contentTypeDefinitionNames="ISF Arbetsrapport" categoryCondition="${areaCondition}"/>
	</c:when>
	<c:when test="${publicationType eq 'Workingpaper'}">
		<content:matchingContents id="publications" contentTypeDefinitionNames="ISF Working Paper" categoryCondition="${areaCondition}" skipLanguageCheck="true"/>
	</c:when>
</c:choose>

<c:if test="${not empty publications}">
	<content:contentSort id="publications" input="${publications}">
		<content:sortContentProperty name="publishDateTime" ascending="false" />
	</content:contentSort>
	
	<c:if test="${not empty maxItems}">
		<common:sublist id="publications" list="${publications}" count="${maxItems}" />
	</c:if>
</c:if>

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
					<th><structure:componentLabel mapKeyName="Title"/></th>
					<th><structure:componentLabel mapKeyName="Published"/></th>
				</tr>
			</thead>
			<tbody>
				<c:forEach var="publication" items="${publications}">
					<content:contentAttribute id="title" attributeName="Title" contentId="${publication.id}" disableEditOnSight="true"/>
					<content:contentAttribute id="subTitle" attributeName="SubTitle" contentId="${publication.id}" disableEditOnSight="true"/>
					<tr>
						<td>
							<structure:pageUrl id="detailPageUrl" propertyName="PublicationDetailPage" contentId="${publication.contentId}" useInheritance="true"/>
							
							<a href="<c:out value="${detailPageUrl}" escapeXml="false" />">
								<c:out value="${title}" escapeXml="false" />
								<c:if test="${not empty subTitle}">
									&ndash; <c:out value="${subTitle}" />
								</c:if>
							</a>
						</td>
						<td>
							<common:formatter value="${publication.publishDateTime}" pattern="yyyy-MM"/>
						</td>
				</c:forEach>
			</tbody>
		</table>
	</div>
</div>