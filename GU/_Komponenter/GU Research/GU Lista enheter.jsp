<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-lucene" prefix="lucene" %>

<page:pageContext id="pc" />

<structure:pageUrl id="departmentDetailPageUrl" propertyName="GUR_DepartmentDetailPage" useInheritance="true" />
<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="departmentId" propertyName="DepartmentId" useInheritance="false"/>
<structure:componentPropertyValue id="departmentData" propertyName="GUR_DepartmentDataPath" useInheritance="true"/>
<structure:componentPropertyValue id="luceneTimeout" propertyName="GUR_LuceneCacheTimeout" useInheritance="true"/>
<structure:componentPropertyValue id="showTitle" propertyName="ShowTitle" useInheritance="false"/>

<c:if test="${not empty param.departmentId}">
	<c:set var="departmentId" value="${param.departmentId}" />
</c:if>

<c:if test="${empty departmentId}">
	<structure:pageAttribute id="pageFunction" attributeName="PageFunction" disableEditOnSight="true" />
	<%
		String pageFunction = (String)pageContext.getAttribute("pageFunction");

		if (pageFunction.indexOf("-") > -1)
		{
			String pageType 	= pageFunction.substring(0, pageFunction.indexOf("-"));

			if (pageType.equals("enhetsdetalj"))
			{
				String departmentId = pageFunction.substring(pageFunction.indexOf("-") + 1);
				pageContext.setAttribute("departmentId", departmentId);
			}
		}
	%>
</c:if>

<c:if test="${empty title}">
	<structure:componentLabel id="title" mapKeyName="DefaultTitle"/>
</c:if>

<c:choose>
	<c:when test="${not empty departmentData}">
		<lucene:setupIndex id="departmentDirectory" directoryCacheName="guDepartments" path="${departmentData}" indexes="parentId,departmentId" timeout="${luceneTimeout}" parser="se.gu.infoglue.lucene.GUOrgParser" />
	</c:when>
	<c:when test="${empty departmentData and pc.isDecorated}">
		<p class="adminError"><structure:componentLabel mapKeyName="NoKataGuData"/></p>
	</c:when>
</c:choose>

<!--eri-no-index-->

<div class="guResearchComp departmentList">
	<c:choose>
		<c:when test="${empty departmentId and pc.isDecorated}">
			<h2><c:out value="${title}" escapeXml="false"/></h2>
			<p class="adminError"><structure:componentLabel mapKeyName="NoOrganizationId"/></p>
		</c:when>		
		<c:when test="${not empty departmentData}">
			<c:if test="${not empty departmentId}">
				<lucene:search id="departments" directory="${departmentDirectory}" query="parentId:${departmentId}" />
			
				<c:if test="${not empty departments}">
					<c:if test="${showTitle eq 'yes'}">
						<h2><c:out value="${title}" escapeXml="false"/></h2>
					</c:if>
					<ul class="orgList">
						<c:forEach var="department" items="${departments}" varStatus="loop">
							<common:urlBuilder id="detailPageUrl" baseURL="${departmentDetailPageUrl}" includeCurrentQueryString="false">
								<common:parameter name="departmentId" value="${department['departmentId']}" />
								<%--
									This code will create a duplicate languageId in Working but it is required
									for live to work.
								--%>
								<common:parameter name="languageId" value="${pc.languageId}" />
							</common:urlBuilder>
							<li><a href="<c:out value="${detailPageUrl}" escapeXml="true" />"><c:out value="${department['departmentName']}" /></a></li>
						</c:forEach>
					</ul>
				</c:if>
			</c:if> <%-- not empty departmentId --%>
		</c:when> <%-- not empty data --%>
	</c:choose>
</div>

<!--/eri-no-index-->