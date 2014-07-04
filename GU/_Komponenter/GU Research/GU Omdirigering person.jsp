<%@ taglib prefix="c"          uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="common"     uri="infoglue-common" %>
<%@ taglib prefix="content"    uri="infoglue-content" %>
<%@ taglib prefix="page"       uri="infoglue-page" %>
<%@ taglib prefix="structure"  uri="infoglue-structure" %>
<%@ taglib prefix="management" uri="infoglue-management" %>
<%@ taglib prefix="lucene"     uri="infoglue-lucene" %>
<%@ taglib prefix="gup"        uri="gup" %>
<%@ taglib prefix="guweb"      uri="guweb" %>

<structure:componentPropertyValue id="idData" propertyName="GUR_IdDataPath" useInheritance="true" />
<structure:componentPropertyValue id="data" propertyName="GUR_PersonDataPath" useInheritance="true" />
<structure:componentPropertyValue id="timeout" propertyName="GUR_LuceneCacheTimeout" useInheritance="true" />
<%--
<guweb:matchingSiteNodes id="redirectSiteNodeId" indexNameValues="PageFunction=persondetalj-.*,PageFunction=enhetsdetalj-.*" 
				attributeName="PageFunction" attributeValue="persondetalj-${person['departmentBottomId']}" returnFirst="true" />
 --%>
<page:pageContext id="pc"/>

<c:choose>
	<c:when test="${param.action eq 'reset' and (pc.principal.name eq 'xsteer' or pc.principal.name eq 'xdajoh')}">
		<guweb:matchingSiteNodes id="redirectSiteNodeId" indexNameValues="PageFunction=enhetsdetalj-.*,PageFunction=persondetalj-.*" attributeName="" attributeValue="" returnFirst="true" />
		<guweb:matchingSiteNodes id="redirectSiteNode" action="reset" />
		<common:urlBuilder id="currentUrl" excludedQueryStringParameters="action">
			<common:parameter name="action" value="status"/>
		</common:urlBuilder>
	
		<common:sendRedirect url="${currentUrl}"/>
	</c:when>
	<c:when test="${param.action eq 'status'}">
		<guweb:matchingSiteNodes id="status" action="status" />
		Indexing status is: <c:out value="${status}"/>
	</c:when>
	<c:otherwise>

		<c:if test="${not empty param.userId}">
			<c:set var="userId" value="${param.userId}" />
		</c:if>
		<c:if test="${not empty param.departmentId}">
			<c:set var="departmentId" value="${param.departmentId}" />
		</c:if>
		
		<c:if test="${not empty userId}">
			<% 
				String userId = (String)pageContext.getAttribute("userId");
				if (userId.startsWith("x"))
				{
					pageContext.setAttribute("isXName", true);
				}
				else
				{
					pageContext.setAttribute("isXName", false);
				}
			%>
		</c:if>
		
		<c:choose>
			<c:when test="${not empty userId}">		
				<%-- Convert xname to personid --%>
				<c:if test="${isXName}">
					<c:choose>
						<c:when test="${empty idData and pc.isDecorated}">
							<structure:componentLabel mapKeyName="NoKataGuIdData"/>
						</c:when>
						<c:when test="${not empty idData}">
							<c:catch var="lucenePersonIdException">
								<lucene:setupIndex id="personIdDirectory" directoryCacheName="guPersonIds" path="${idData}" indexes="id,xname" timeout="${timeout}" parser="se.gu.infoglue.lucene.GUXNameParser" />
							</c:catch>
							
							<c:choose>
								<c:when test="${not empty lucenePersonIdException}">
									<p><c:out value="${lucenePersonIdException}"/></p>
								</c:when>
								<c:otherwise>
									<c:catch var="idSearchException">
										<lucene:search id="ids" directory="${personIdDirectory}" query="xname:${userId}" />
									</c:catch>
									<c:choose>
										<c:when test="${not empty idSearchException or empty ids}">
											<p><structure:componentLabel mapKeyName="ErrorNoIdForXName" />: <c:out value="${idSearchException.message}"/> (<c:out value="${personSearchException.class.name}" />)</p>
										</c:when>
										<c:otherwise>
											<c:set var="userId" value="${ids[0]['id']}" scope="request" />
										</c:otherwise>
									</c:choose>
								</c:otherwise>
							</c:choose>
						</c:when>
					</c:choose>
				</c:if>
				
				<%-- Retrieve person --%>
				<%-- At this point userId is always a KataGu id or an error has occurred --%>
				<c:choose>
					<c:when test="${empty data and pc.isDecorated}">
						<structure:componentLabel mapKeyName="NoKataGuIdData"/>
					</c:when>
					<c:when test="${not empty data}">
						<c:catch var="personDirectoryException">
							<lucene:setupIndex id="personDirectory" directoryCacheName="guPersons" path="${data}" indexes="id,departmentBottomId,departmentMiddleId,departmentTopId,presentationOrder" sortableFields="lastName,firstName,title,phone,email" timeout="${timeout}" parser="se.gu.infoglue.lucene.GUPersonParser" />
						</c:catch>
						
						<c:choose>
							<c:when test="${not empty personDirectoryException and pc.isDecorated}">
								<structure:componentLabel mapKeyName="LuceneException" />&nbsp;<c:out value="${personDirectoryException.message}" /> (<c:out value="${personDirectoryException.class.name}" />)
							</c:when>
							<c:when test="${empty personDirectoryException}">
								<c:choose>
									<c:when test="${not empty departmentId}">
										<c:set var="query" value="id:${userId} and departmentBottomId:${departmentId}"/>
									</c:when>
									<c:otherwise>
										<c:set var="query" value="id:${userId} and presentationOrder:1"/>
									</c:otherwise>
								</c:choose>
		
								<c:catch var="personSearchException">
									<lucene:search id="persons" directory="${personDirectory}" query="${query}" />
								</c:catch>
								
								<c:choose>
									<c:when test="${not empty personSearchException and pc.isDecorated}">
										<structure:componentLabel mapKeyName="LuceneException" />&nbsp;<c:out value="${personSearchException.message}" /> (<c:out value="${personSearchException.class.name}" />)
									</c:when>
									<c:when test="${empty personSearchException}">
										<c:set var="person" value="${persons[0]}"/>
										<c:if test="${empty person}">
											<structure:componentLabel mapKeyName="NoPerson" />
										</c:if>
									</c:when>
								</c:choose>
							</c:when>
						</c:choose>
					</c:when>
				</c:choose>
				
				<c:if test="${not empty person}">
					<%-- Look up SiteNode using Sitenode look up --%>
					<guweb:matchingSiteNodes id="redirectSiteNodeId" indexNameValues="PageFunction=enhetsdetalj-.*,PageFunction=persondetalj-.*" 
						attributeName="PageFunction" attributeValue="persondetalj-${person['departmentBottomId']}" />
					<c:if test="${not empty redirectSiteNodeId}">
						<%--
							This if-statement should return an empty string (or null) if no valid page could be found.
							E.g. the index could be broken or out-dated.
					 	--%>
						<c:remove var="redirectUrl"/>
						<c:forEach var="redirNode" items="${redirectSiteNodeId}">
							<c:if test="${empty redirectUrl}">
								<structure:siteNodeLanguages id="langIds" siteNodeId="${redirNode}"/>
								<c:forEach var="langId" items="${langIds}">
									<c:if test="${langId.languageId eq pc.languageId}">
										<structure:pageUrl id="redirectUrl" siteNodeId="${redirNode}" languageId="${langId.languageId}" />
									</c:if>
								</c:forEach>
							</c:if>
						</c:forEach>
						<c:if test="${not empty redirectUrl}">
							<common:urlBuilder id="redirectUrl" baseURL="${redirectUrl}" excludedQueryStringParameters="siteNodeId,languageId,contentId,departmentId,action"></common:urlBuilder>
						</c:if>
					</c:if>
				</c:if>
				
				<%-- This value is empty if no person page was found --%>
				<c:if test="${empty redirectUrl}">
					<management:language id="langVO" languageId="${pc.languageId}"/>
					<structure:pageUrl id="redirectUrl" propertyName="PersonDetailPageFallback_${langVO.languageCode}" useInheritance="false" />
					<%-- Remember to keep departmentId and userId in the URL! --%>
					<common:urlBuilder id="redirectUrl" baseURL="${redirectUrl}" excludedQueryStringParameters="siteNodeId,languageId,contentId,action"></common:urlBuilder>
				</c:if>
			</c:when>
			<c:otherwise>
				<html>
					<head></head>
					<body><p class="adminError"><structure:componentLabel mapKeyName="NoUserId" /></p></body>
				</html>
			</c:otherwise>
		</c:choose>
		
		
		<c:if test="${not empty redirectUrl}">
			<c:choose>
				<c:when test="${param.action eq 'test'}">
					redirectSiteNodeId: <c:out value="${redirectSiteNodeId}"/><br/>
					redirectUrl: <c:out value="${redirectUrl}"/>
				</c:when>
				<c:otherwise>
					<common:sendRedirect url="${redirectUrl}" />
				</c:otherwise>
			</c:choose>
		</c:if>
	</c:otherwise> <%-- end: Not reset cache --%>
</c:choose>