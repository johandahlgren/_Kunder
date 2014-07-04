<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>

<page:pageContext id="pc"/>

<content:content id="employee" propertyName="Employee" useInheritance="false"/>

<c:if test="${not empty param.contentId && param.contentId != -1}">
	<content:content id="employee" contentId="${param.contentId}"/>
</c:if>

<content:contentAttribute id="name" attributeName="Name" contentId="${employee.id}" disableEditOnSight="true" />
<content:contentAttribute id="title" attributeName="Title" contentId="${employee.id}" disableEditOnSight="true" />
<content:contentAttribute id="department" attributeName="Department" contentId="${employee.id}" disableEditOnSight="true" />
<content:contentAttribute id="phone" attributeName="Phone" contentId="${employee.id}" disableEditOnSight="true" />
<content:contentAttribute id="worksWith" attributeName="WorksWith" contentId="${employee.id}" disableEditOnSight="true" />
<content:contentAttribute id="areasOfExpertise" attributeName="AreasOfExpertise" contentId="${employee.id}" disableEditOnSight="true" />
<content:contentAttribute id="previousEmployers" attributeName="PreviousEmployers" contentId="${employee.id}" disableEditOnSight="true" />
<content:contentAttribute id="academicDegree" attributeName="AcademicDegree" contentId="${employee.id}" disableEditOnSight="true" />


<c:choose>
	<c:when test="${empty employee}">
		<c:if test="${pc.isDecorated}">
			<h1><structure:componentLabel mapKeyName="DefaultHeadline"/></h1>
			<div class="adminMessage">
				<structure:componentLabel mapKeyName="NoItemSelected"/>
			</div>
		</c:if>
	</c:when>
	<c:otherwise>
	
		<%-------------------------------------%>
		<%--         Edit content links      --%>
		<%-------------------------------------%>
	
		<c:if test="${pc.isDecorated and not empty employee}">
			<structure:componentLabel id="editContent" mapKeyName="EditContent"/>
			<content:editOnSight id="editOnSightHTML" contentId="${employee.id}" attributeName="FullText" languageId="${pc.languageId}" html="${editContent}"/>
			<div class="igEditButton">
				<c:out value="${editOnSightHTML}" escapeXml="false"/>
			</div>
		</c:if>

		<%-------------------------------------%>
		<%--         Render text content     --%>
		<%-------------------------------------%>
		
		<h1><c:out value="${name}" escapeXml="false" /></h1>
		<div class="employee-info">
			<p>
				<span class="title"><structure:componentLabel mapKeyName="Title"/>: </span><c:out value="${title}" escapeXml="false" />
			</p>
			<p>
				<span class="department"><structure:componentLabel mapKeyName="Department"/>:</span><c:out value="${department}" escapeXml="false" />
			</p>
			<h2><structure:componentLabel mapKeyName="WorksWith"/></h2>
			<c:out value="${worksWith}" escapeXml="false" />
			<h2><structure:componentLabel mapKeyName="AreasOfExpertise"/></h2>
			<c:out value="${areasOfExpertise}" escapeXml="false" />
			<h2><structure:componentLabel mapKeyName="PreviousEmployers"/></h2>
			<c:out value="${previousEmployers}" escapeXml="false" />
			<h2><structure:componentLabel mapKeyName="AcademicDegree"/></h2>
			<c:out value="${academicDegree}" escapeXml="false" />
		</div>
	</c:otherwise>
</c:choose>
