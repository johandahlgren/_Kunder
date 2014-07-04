<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-common" prefix="common" %>

<structure:boundPage id="readMorePage" propertyName="ReadMorePage" useInheritance="false" />
<structure:componentPropertyValue id="encodeEmailLabel" propertyName="EmailProtectionLabel" useInheritance="true" />
<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false" />
<structure:componentPropertyValue id="text" propertyName="Text" useInheritance="false" />
<structure:componentPropertyValue id="readMoreText" propertyName="ReadMoreText" useInheritance="false" />

<c:if test="${empty readMore}">
	<structure:componentLabel id="readMore" mapKeyName="ReadMore"/>
</c:if>

<div id="pageIntro">
	<div class="innerContainer">
		<h1><c:out value="${title}" escapeXml="false" /></h1>
		
		<common:transformText id="fixedText" text="${text}" replaceLineBreaks="true" />
		
		<p><common:protectEmail prefix="${encodeEmailLabel}" value="${fixedText}" /></p>
		<c:if test="${not empty readMorePage}">
			<p><a href="<c:out value="${readMorePage.url}"/>"><c:out value="${readMoreText}" /></a></p>
		</c:if>
	</div>
</div>
