<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="gup" prefix="gup" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-lucene" prefix="lucene" %>

<%@page import="java.util.Map"%>

<page:pageContext id="pc" />

<structure:componentPropertyValue id="subjectId" propertyName="SubjectId" />
<structure:componentPropertyValue id="subjectDataPath" propertyName="GUR_SubjectDataPath" useInheritance="true"/>
<structure:componentPropertyValue id="timeout" propertyName="GUR_LuceneCacheTimeout" useInheritance="true"/>

<c:if test="${not empty param.subjectId}">
	<c:set var="subjectId" value="${param.subjectId}" />
</c:if>

<c:choose>
	<c:when test="${not empty subjectId}">
		<c:catch var="myError1">
			<c:set var="luceneQuery" value="svepid:${subjectId}" />		
			<lucene:setupIndex id="subjectList" directoryCacheName="subjectList" path="${subjectDataPath}" indexes="catid" timeout="${timeout}" parser="se.gu.infoglue.lucene.GUCategoryParser" />
			<lucene:search id="subjects" directoryCacheName="subjectList" query="catid:${subjectId}" />
		</c:catch>
	
		<c:choose>
			<c:when test="${not empty myError1}">
				<structure:componentLabel id="searchError" mapKeyName="SearchError" />
				<c:set var="subjectDetailError" value="${searchError} ${myError1.message}" scope="request"/>
			</c:when>
			<c:otherwise>
				<c:set var="subject" value="${subjects[0]}" />
				<c:choose>
					<c:when test="${not empty subject}">
						<c:set var="subjectId" value="${subject.svepid}" scope="request"/>

						<c:set var="langCode" value="${pc.locale.language}" />
					
						<%
							String langCode = (String)pageContext.getAttribute("langCode");
							Map<String, Object> subject = (Map<String, Object>)pageContext.getAttribute("subject");
							String subjectName = (String)subject.get(langCode + "_name");
							pageContext.setAttribute("subjectName", subjectName);
						%>

						<page:pageAttribute name="pageTitlePrefix" value="${subjectName}" />
						<page:pageAttribute name="crumbtrailCurrentPageText" value="${subjectName}" />

						<c:if test="${not empty subject.parentid}">
							<c:catch var="myError2">
								<lucene:search id="parents" directoryCacheName="subjectList" query="catid:${subject.parentid}" />
							</c:catch>
					
							<c:set var="parent" value="${parents[0]}" />
							
							<c:choose>
								<c:when test="${not empty myError2}">
									<structure:componentLabel id="searchError" mapKeyName="SearchError" />
									<c:set var="subjectDetailError" value="${searchError} ${myError2.message}" scope="request"/>
								</c:when>
								<c:otherwise>
									<%
										Map<String, Object> parentSubject = (Map<String, Object>)pageContext.getAttribute("parent");
										String parentSubjectName = (String)parentSubject.get(langCode + "_name");
										pageContext.setAttribute("parentSubjectName", parentSubjectName);
									%>
									
									<common:urlBuilder id="parentUrl" excludedQueryStringParameters="subjectId">
										<common:parameter name="subjectId" value="${subject.parentid}" />
									</common:urlBuilder>
									
									<c:set var="researchHeaderSubtitle" scope="request">
										<structure:componentLabel mapKeyName="PartOf" />&nbsp;<a href="<c:out value="${parentUrl}" escapeXml="false" />"><c:out value="${parentSubjectName}" escapeXml="false" /></a>
									</c:set>
								</c:otherwise>
							</c:choose>
						</c:if>
					</c:when>
					<c:when test="${empty subject and pc.isDecorated}">
						<structure:componentLabel id="noSubject" mapKeyName="UnknownSubject" />
						<c:set var="subjectDetailError" value="${noSubject}" scope="request"/>	
					</c:when>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:when test="${empty subjectId and pc.isDecorated}">
		<structure:componentLabel id="noSubject" mapKeyName="NoSubject" />
		<c:set var="subjectDetailError" value="${noSubject}" scope="request"/>
	</c:when>
</c:choose>