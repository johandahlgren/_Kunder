<%@ taglib prefix="c"         uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt"       uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="common"    uri="infoglue-common" %>
<%@ taglib prefix="content"   uri="infoglue-content" %>
<%@ taglib prefix="page"      uri="infoglue-page" %>
<%@ taglib prefix="structure" uri="infoglue-structure" %>
<%@ taglib prefix="management" uri="infoglue-management" %>

<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController" %>
<%@page import="org.infoglue.cms.entities.structure.SiteNodeVO" %>

<%@page import="java.util.*" %>
<%@page import="org.infoglue.cms.entities.content.ContentVO" %>
<%@page import="org.infoglue.cms.entities.content.ContentVersionVO" %>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.TemplateController" %>
<%@page import="org.infoglue.cms.controllers.kernel.impl.simple.ContentVersionController" %>
<%@page import="org.infoglue.cms.util.sorters.TemplateControllerAwareComparator" %>

 
<page:pageContext id="pc"/>

<structure:componentPropertyValue id="encodeEmailLabel" propertyName="EmailProtectionLabel" useInheritance="true"/>

<%
pageContext.getAttribute("pc");
%>

<%!
class StickyNewsComparator implements Comparator
{
	TemplateController tc;
	
	public StickyNewsComparator(TemplateController tc)
	{
		this.tc = tc;
	}
	
	public int compare(Object o1, Object o2)
	{
		ContentVO self  = (ContentVO)o1;
		ContentVO other = (ContentVO)o2;
		int returnValue	= 0;
		
		String sticky1 = tc.getContentAttribute(self.getContentId(), "Sticky", true);
		String sticky2 = tc.getContentAttribute(other.getContentId(), "Sticky", true);

		if (sticky1.equals(sticky2))
		{
            return other.getPublishDateTime().compareTo(self.getPublishDateTime());
		}
		else if("true".equals(sticky1) && !"true".equals(sticky2))
		{
			returnValue = -1;
		}
		else if(!"true".equals(sticky1) && "true".equals(sticky2))
		{
			returnValue = 1;
		}

		return returnValue;
	}
}
%>
 
<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>
<c:set var="dateFormat" value="yyyy-MM-dd"/>
<fmt:setLocale scope="session" value="sv_SE"/> 

<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="moreNewsLinkText" propertyName="MoreNewsLinkText" useInheritance="false"/>
<structure:componentPropertyValue id="numberOfNews" propertyName="NumberOfNews" useInheritance="false"/>
<structure:componentPropertyValue id="numberOfExpanded" propertyName="NumberOfExpanded" useInheritance="false"/>

<c:if test="${empty title}">
	<structure:componentLabel id="title" mapKeyName="DefaultHeadline"/>
</c:if>

<c:if test="${empty numberOfNews}">
	<c:set var="numberOfNews" value="10"/>
</c:if>

<c:if test="${empty numberOfExpanded}">
	<c:set var="numberOfExpanded" value="3"/>
</c:if>

<structure:componentPropertyValue id="maxIntroLength" propertyName="MaxIntroLength" useInheritance="false"/>

<%
	java.util.Date toDate = new java.util.Date();
	pageContext.setAttribute("toDate", toDate);
	java.util.Date fromDate = new java.util.Date();
	java.util.Calendar calendar = java.util.Calendar.getInstance();
	calendar.add(java.util.Calendar.YEAR, -1);
	pageContext.setAttribute("fromDate", calendar.getTime());
	
	try
	{
		String temp = (String)pageContext.getAttribute("maxIntroLength");
		
		if (!temp.trim().equals(""))
		{
			int maxIntroLength 	= Integer.parseInt(temp);	
		}
	}
	catch (NumberFormatException nfe)
	{
		out.print("Värdet \"" + (String)pageContext.getAttribute("maxIntroLength") + "\" på egenskapen \"maxIntroLength\" är ej numeriskt. Var god åtgärda. <br/><br/>");
		pageContext.setAttribute("maxIntroLength", null);
	}
	
	BasicTemplateController btc = (BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
	SiteNodeVO currentSideNode	= btc.getSiteNode(btc.getSiteNodeId());
	String pageCategory 			= btc.getContentAttribute(currentSideNode.getMetaInfoContentId(), "PageCategory", true);
	pageContext.setAttribute("pageCategory", pageCategory);
%>
<c:if test="${empty pageCategory}">
	<c:set var="pageCategory" value="Startsida" />
</c:if>

<content:matchingContents id="unsortedNews" contentTypeDefinitionNames="ISF Publik nyhet" categoryCondition="Area=/ISFNewsArea/${pageCategory}"/>

<c:choose>
	<c:when test="${pageCategory eq 'Startsida'}">
		<%
			List unsorted =  (List)pageContext.getAttribute("unsortedNews");
			Collections.sort(unsorted, new StickyNewsComparator(btc));
			pageContext.setAttribute("sortedNews", unsorted);
		%>
	</c:when>
	<c:otherwise>
		<content:contentSort id="sortedNews" input="${unsortedNews}">
			<content:sortContentProperty name="publishDateTime" ascending="false"/>
		</content:contentSort>
	</c:otherwise>
</c:choose>

<common:sublist id="croppedNews" list="${sortedNews}" startIndex="0" count="${numberOfNews}"/>

<common:size id="numberOfNewsInList" list="${croppedNews}" />

<div id="newsBlock">
	<div class="innerContainer">
		<h2><c:out value="${title}"/></h2>

		<c:forEach var="newsItem" items="${croppedNews}" varStatus="loop">
			<c:if test="${newsItem != null}">
				<c:set var="url" value=""/>
				<c:set var="page" value=""/>
				<c:set var="content" value=""/>
				
				<c:set var="publishDate" value="${newsItem.publishDateTime}"/>
				<content:contentAttribute id="title" contentId="${newsItem.contentId}" attributeName="Rubrik" disableEditOnSight="true"/>				
				<content:contentAttribute id="leadIn" contentId="${newsItem.contentId}" attributeName="Ingress" disableEditOnSight="true"/>
		 	 
		 	 	<structure:relatedPages id="pages" attributeName="Page" contentId="${newsItem.id}" />
		 	 	<content:relatedContents id="contents" attributeName="Content" contentId="${newsItem.id}" />
		 	 	
		 	 	<c:if test="${not empty pages}">
		 	 		<c:set var="page" value="${pages[0]}" />
		 	 	</c:if>
		 	 	
		 	 	<c:if test="${not empty contents}">
		 	 		<c:set var="content" value="${contents[0]}" />
		 	 	</c:if>
		 	 	
		 	 	<c:if test="${not empty page}">
		 	 		<c:choose>
		 	 			<c:when test="${not empty content}">
		 	 				<structure:pageUrl id="url" siteNodeId="${page.siteNodeId}" contentId="${content.contentId}" />
		 	 			</c:when>
		 	 			<c:otherwise>
		 	 				<structure:pageUrl id="url" siteNodeId="${page.siteNodeId}" />
		 	 			</c:otherwise>
		 	 		</c:choose>
				</c:if>
								
				<c:choose>
					<c:when test="${not empty maxIntroLength}">
						<%
							String leadIn 		= (String)pageContext.getAttribute("leadIn");							
							int maxIntroLength 	= Integer.parseInt((String)pageContext.getAttribute("maxIntroLength"));
							
							if (maxIntroLength == 0)
							{
								%>
									<c:set var="text" value=""/>
								<%
							}
							else if (leadIn.length() > maxIntroLength)
							{
								%>
									<common:transformText id="leadIn" text="${leadIn}" replaceString="<(.|\n)*?>" replaceWithString="" />
									<common:cropText id="croppedText" text="${leadIn}" maxLength="${maxIntroLength}" suffix="..." />								
									<c:set var="text" value="${croppedText}"/>
								<%
							}
							else
							{
								%>								
									<c:set var="text" value="${leadIn}"/>
								<%
							}								
						%>
					</c:when>
					<c:otherwise>					
						<c:set var="text" value="${leadIn}"/>
					</c:otherwise>
				</c:choose>

				<c:choose>
					<c:when test="${loop.count le numberOfExpanded}">
						<div class="newsItem">
							<c:if test="${empty url && pc.isDecorated}">
								<div class="adminMessage">
									<structure:componentLabel mapKeyName="NoDetailPageSelected"/>
								</div>
							</c:if>
									
							<h3><a href="<c:out value="${url}" escapeXml="false"/>"><c:out value="${title}"/></a></h3>
						
							<span class="newsFacts">
								<strong class="newsDate">
									<span class="innerDate">
										<span class="day"><fmt:formatDate value="${publishDate}" pattern="d"/></span>
										<span class="month"><fmt:formatDate value="${publishDate}" pattern="MMM"/></span>
										<span class="year"><fmt:formatDate value="${publishDate}" pattern="yyyy"/></span>
									</span>
								</strong>
								<content:assignedCategories id="categories" contentId="${newsItem.contentId}" categoryKey="Type"/> 
								<strong class="newsLabel">
									<c:forEach var="category" items="${categories}" varStatus="loop"> 
									    <management:categoryDisplayName id="displayName" categoryVO="${category}" /> 
									    <c:if test="${loop.count > 1}">
									    , 
									    </c:if>
									   	<c:out value="${displayName}" />
									</c:forEach>
								</strong>
							</span>
							<p>
								<common:protectEmail prefix="${encodeEmailLabel}" value="${text}" />
							</p>
						</div>
					</c:when>
					<c:otherwise>
						<c:if test="${loop.count == numberOfExpanded + 1}">
							<h3><structure:componentLabel mapKeyName="PreviousNews"/></h3>
							<ul class="previousNewsList">
						</c:if>
						<li>
							<c:if test="${empty url && pc.isDecorated}">
								<div class="adminMessage">
									<structure:componentLabel mapKeyName="NoDetailPageSelected"/>
								</div>
							</c:if>
							<a href="<c:out value="${url}" escapeXml="false"/>"><c:out value="${title}"/> <span>(<fmt:formatDate value="${publishDate}" pattern="d MMM yyyy"/>)</span></a>
						</li>
						<c:if test="${loop.count == numberOfNewsInList}">
							</ul>
						</c:if>
					</c:otherwise>
				</c:choose>
			</c:if>
		</c:forEach>
	</div>
	<structure:boundPage id="moreNewsPage" propertyName="MoreNewsPage" useInheritance="false"/>

	<c:if test="${not empty moreNewsPage}">
		<structure:componentLabel id="moreNewsLinkText" mapKeyName="MoreNewsLinkText"/>
	
		<div class="moreNews">
			<a href="<c:out value="${moreNewsPage.url}" />">
				<c:out value="${moreNewsLinkText}" escapeXml="false"/>
			</a> 
		</div>
	</c:if>
</div>