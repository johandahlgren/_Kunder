<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-lucene" prefix="lucene" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-common" prefix="common" %>

<structure:componentPropertyValue id="idData" propertyName="GUR_IdDataPath" useInheritance="true" />
<structure:componentPropertyValue id="data" propertyName="GUR_PersonDataPath" useInheritance="true" />
<structure:componentPropertyValue id="userId" propertyName="UserId" />
<structure:componentPropertyValue id="timeout" propertyName="GUR_LuceneCacheTimeout" useInheritance="true"/>

<page:pageContext id="pc"/>

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

			if (pageType.equals("persondetalj"))
			{	
				String departmentId = pageFunction.substring(pageFunction.indexOf("-") + 1);
				pageContext.setAttribute("departmentId", departmentId);
			}
		}
	%>
</c:if>

<%-- If a user name has been sent in the request we want to use this as the page title, even if something goes wrong later. --%>

<c:if test="${not empty param.userName}">
<%--
	<common:transformText id="userName" text="${param.userName}" htmlEncode="true" />--%>
	<%
		String un = pageContext.getRequest().getParameter("userName");
		pageContext.setAttribute("userName",  new String(un.getBytes("ISO-8859-1")));
	%>
	<page:pageAttribute name="pageTitlePrefix" value="${userName}" />
	<page:pageAttribute name="crumbtrailCurrentPageText" value="${userName}" />
</c:if>

<c:if test="${empty person}">
	<c:if test="${not empty param.userId}">
		<c:set var="userId" value="${param.userId}" />
	</c:if>
	
	<c:choose>
		<c:when test="${not empty userId}"> <%-- and not empty idData and not empty data --%>
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
		
			<%-- Convert between xname and personid --%>
			
			<c:choose>
				<c:when test="${not empty idData}">
					<lucene:setupIndex id="personIdDirectory" directoryCacheName="guPersonIds" path="${idData}" indexes="id,xname" timeout="${timeout}" parser="se.gu.infoglue.lucene.GUXNameParser" />
				</c:when>
				<c:when test="${empty idData and pc.isDecorated}">
					<structure:componentLabel id="errorFromLabel" mapKeyName="NoKataGuIdData"/>
					<%--<c:set var="personDetailError" value="${errorFromLabel}" scope="request" />--%>
					<c:set var="personDetailError" scope="request"><c:if test="${not empty personDetailError}"><c:out value="${personDetailError}"/><br/></c:if><c:out value="${errorFromLabel}" escapeXml="false" /></c:set>
				</c:when>
			</c:choose>
			
			<c:if test="${not empty personIdDirectory}">
				<c:choose>
					<c:when test="${isXName}">
						<lucene:search id="ids" directory="${personIdDirectory}" query="xname:${userId}" />
						<c:choose>
							<c:when test="${empty ids}">
								<structure:componentLabel id="errorFromLabel" mapKeyName="ErrorNoIdForXName" />
								<%--<c:set var="error" value="${errorFromLabel}: ${userId}" />--%>
								<%--<c:set var="personDetailError" value="${errorFromLabel}: ${userId}" scope="request" />--%>
								<c:set var="personDetailError" scope="request"><c:if test="${not empty personDetailError}"><c:out value="${personDetailError}"/><br/></c:if><c:out value="${errorFromLabel}: ${userId}" escapeXml="false" /></c:set>
							</c:when>
							<c:otherwise>
								<common:size id="numIds" list="${ids}" />
								<c:if test="${numIds > 1}">
									<structure:componentLabel id="errorFromLabel" mapKeyName="ErrorMultipleIdsForXName" />
									<%--<c:set var="error" value="${errorText}: ${userId}" />--%>
									<%--<c:set var="personDetailError" value="${errorFromLabel}: ${userId}" scope="request" />--%>
									<c:set var="personDetailError" scope="request"><c:if test="${not empty personDetailError}"><c:out value="${personDetailError}"/><br/></c:if><c:out value="${errorFromLabel}: ${userId}" escapeXml="false" /></c:set>
								</c:if>
								<c:set var="xname" value="${userId}" scope="request" />
								<c:set var="personid" value="${ids[0]['id']}" scope="request" />
							</c:otherwise>
						</c:choose>
					</c:when>
					<c:otherwise> <!-- Assumes userId is a KataGu id -->
						<lucene:search id="ids" directory="${personIdDirectory}" query="id:${userId}" />
						<c:choose>
							<c:when test="${empty ids}">
								<structure:componentLabel id="errorFromLabel" mapKeyName="ErrorNoIdForPersonId" />
								<%--<c:set var="error" value="${errorText}: ${userId}" />--%>
								<%--<c:set var="personDetailError" value="${errorFromLabel}: ${userId}" scope="request" />--%>
								<c:set var="personDetailError" scope="request"><c:if test="${not empty personDetailError}"><c:out value="${personDetailError}"/><br/></c:if><c:out value="${errorFromLabel}: ${userId}" escapeXml="false" /></c:set>
							</c:when>
							<c:otherwise>
								<common:size id="numIds" list="${ids}" />
								<c:if test="${numIds > 1}">
									<structure:componentLabel id="errorFromLabel" mapKeyName="ErrorMultipleIdsForPersonId" />
									<%--<c:set var="error" value="${errorText}: ${userId}" />--%>
									<%--<c:set var="personDetailError" value="${errorFromLabel}: ${userId}" scope="request" />--%>
									<c:set var="personDetailError" scope="request"><c:if test="${not empty personDetailError}"><c:out value="${personDetailError}"/><br/></c:if><c:out value="${errorFromLabel}: ${userId}" escapeXml="false" /></c:set>
								</c:if>
								<c:set var="xname" value="${ids[0]['xname']}" scope="request" />
								<c:set var="personid" value="${userId}" scope="request" />
							</c:otherwise>
						</c:choose>
					</c:otherwise>
				</c:choose>
			</c:if>
			
			<c:choose>
				<c:when test="${not empty data}">
					<c:catch var="personDirectoryException">
						<lucene:setupIndex id="personDirectory" directoryCacheName="guPersons" path="${data}" indexes="id,departmentBottomId,departmentMiddleId,departmentTopId" sortableFields="lastName,firstName,title,phone,email"  timeout="${timeout}" parser="se.gu.infoglue.lucene.GUPersonParser" />
					</c:catch>
				</c:when>
				<c:when test="${empty data and pc.isDecorated}">
					<structure:componentLabel id="errorFromLabel" mapKeyName="NoKataGuData"/>
					<c:set var="personDetailError" scope="request"><c:if test="${not empty personDetailError}"><c:out value="${personDetailError}"/><br/></c:if><c:out value="${errorFromLabel}" escapeXml="false" /></c:set>
				</c:when>
			</c:choose>
			
			<%-- Find the person's information --%>
			<c:if test="${not empty personDirectory}">
				<lucene:search id="persons" directory="${personDirectory}" query="id:${personid}" />
				
				<c:if test="${not empty persons}">
					<common:size id="size" list="${persons}"/>
					<c:choose>
						<c:when test="${size eq 0}">
							<structure:componentLabel id="errorFromLabel" mapKeyName="NoPersonFound"/>
							<c:set var="personDetailError" scope="request"><c:if test="${not empty personDetailError}"><c:out value="${personDetailError}"/><br/></c:if><c:out value="${errorFromLabel}: ${userId}" escapeXml="false" /></c:set>
						</c:when>
						<c:otherwise>
							<%-- Store person in request to allow access in template
							     Observe the if-statement surrounding this code. The first pretemplate
							     to set the person variable determines the final value of it. --%>
							<c:set var="persons" value="${persons}" scope="request" />
							
							<%--
							<c:set var="person" value="${persons[0]}" />
							
							<page:pageAttribute name="pageTitlePrefix" value="${person.firstName} ${person.lastName}" />
							<page:pageAttribute name="crumbtrailCurrentPageText" value="${person.firstName} ${person.lastName}" />
							<c:set var="researchHeaderSubtitle" value="${person.title}" scope="request"/>
							--%>
							
							<c:forEach var="person" items="${persons}" varStatus="loop">
										
								<%-------------------------------------------------%>
								<%-- Find the primary department for this person --%>
								<%-------------------------------------------------%>											
																		
								<c:if test="${person['presentationOrder'] eq 1}">
									<c:set var="primaryDepartmentName" value="${person['departmentBottomName']}" />
								</c:if>
							
								<c:if test="${(person['departmentBottomId'] eq departmentId) or (empty departmentId and person['presentationOrder'] eq 1)}">
									<page:pageAttribute name="pageTitlePrefix" value="${person.firstName} ${person.lastName}" />
									<page:pageAttribute name="crumbtrailCurrentPageText" value="${person.firstName} ${person.lastName}" />
									<c:set var="researchHeaderSubtitle" value="${person.title}" scope="request"/>
								</c:if>
							</c:forEach>
							
						</c:otherwise>
					</c:choose>
				</c:if>
			</c:if>
		</c:when>
		<c:otherwise>
			<structure:componentLabel id="errorFromLabel" mapKeyName="NoUserId"/>
			<%--<c:set var="personDetailError" value="${errorFromLabel}" scope="request" />--%>
			<c:set var="personDetailError" scope="request"><c:if test="${not empty personDetailError}"><c:out value="${personDetailError}"/><br/></c:if><c:out value="${errorFromLabel}: ${userId}" escapeXml="false" /></c:set>
		</c:otherwise>
	</c:choose>
</c:if> value=${errorFromLabel}: ${userId}