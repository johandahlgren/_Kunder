<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>

<structure:boundPage id="readMorePage" propertyName="ReadMorePage"/>
<content:content id="backgroundImage" propertyName="Image" useInheritance="true"/>
<content:contentAttribute id="backgroundImageAlt" attributeName="Alt" contentId="${backgroundImage.id}" disableEditOnSight="true"/>
<content:assetUrl id="backgroundImageUrl" contentId="${backgroundImage.id}"/>

<structure:componentPropertyValue id="topText" propertyName="TopText" />
<structure:componentPropertyValue id="info" propertyName="Info" />
<structure:componentPropertyValue id="readMore" propertyName="ReadMore" />

<div id="pageIntro">
	<div class="innerContainer">
		<h1><c:out value="${topText}" /></h1>
		<p><c:out value="${info}" /></p>
		<p><a href="<c:out value="${readMorePage.url}"/>"><c:out value="${readMore }" /></a></p>
	</div>
</div>
