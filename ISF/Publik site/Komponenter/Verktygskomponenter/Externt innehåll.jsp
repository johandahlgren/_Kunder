<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib prefix="management" uri="infoglue-management" %>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="url" propertyName="Url" useInheritance="false"/>
<structure:componentPropertyValue id="width" propertyName="Width" useInheritance="false"/>
<structure:componentPropertyValue id="height" propertyName="Height" useInheritance="false"/>

<c:if test="${not empty url}">
	<iframe id="externalContent" width="<c:out value="${width}"/>" height="<c:out value="${height}"/>" src="<c:out value="${url}"/>"></iframe>
</c:if>
