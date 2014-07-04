<%@ taglib prefix="c"         	uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="management" 	uri="infoglue-management" %>
<%@ taglib prefix="structure" uri="infoglue-structure" %>
<%@ taglib uri="infoglue-common" prefix="common" %>

<%@page import="java.util.List"%>
<%@page import="org.infoglue.cms.entities.management.CategoryVO"%>
<%@page import="org.infoglue.cms.controllers.kernel.impl.simple.CategoryController"%>

<structure:componentPropertyValue id="categoryPath" propertyName="CategoryPath" useInheritance="false" />

<c:choose>
	<c:when test="${empty categoryPath}">
		<structure:componentLabel mapKeyName="NoPathProvided"/>
	</c:when>
	<c:otherwise>
		<%
			String categoryPath = (String)pageContext.getAttribute("categoryPath");
			CategoryVO vo = CategoryController.getController().findByPath(categoryPath);
			vo = CategoryController.getController().findWithChildren(vo.getId());
			List<CategoryVO> children = (List<CategoryVO>)vo.getChildren();
			pageContext.setAttribute("categories", children);
		%>
		
		<c:out value="<properties>" escapeXml="false"/>
			<c:out value="<property name='Alla' value='all' />" escapeXml="false"/>
			<c:forEach var="category" items="${categories}">
				<management:categoryDisplayName id="displayName" categoryVO="${category}" />
				<common:transformText id="escapedCategoryDisplayName" replaceString="&" replaceWithString="&#38;" text="${displayName}" />
				<c:if test="${category.name ne 'Startsida'}">
					<property name="<c:out value="${escapedCategoryDisplayName}" escapeXml="true" />" value="<c:out value="${category.name}" escapeXml="true" />" />
				</c:if>
			</c:forEach>
		<c:out value="</properties>" escapeXml="false"/>
	</c:otherwise>
</c:choose>
