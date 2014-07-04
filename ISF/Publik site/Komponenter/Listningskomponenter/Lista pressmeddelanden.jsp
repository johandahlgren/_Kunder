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
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>
 
<page:pageContext id="pc"/>

<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>
<c:set var="dateFormat" value="yyyy-MM-dd"/>
<fmt:setLocale scope="session" value="sv_SE"/> 

<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="moreItemsLinkText" propertyName="MoreNewsLinkText" useInheritance="false"/>
<structure:componentPropertyValue id="numberOfItems" propertyName="NumberOfNews" useInheritance="false"/>
<structure:componentPropertyValue id="numberOfExpanded" propertyName="NumberOfExpanded" useInheritance="false"/>

<c:if test="${empty title}">
	<structure:componentLabel id="title" mapKeyName="DefaultHeadline"/>
</c:if>

<c:if test="${empty numberOfNews}">
	<c:set var="numberOfItems" value="10"/>
</c:if>

<c:if test="${empty numberOfExpanded}">
	<c:set var="numberOfExpanded" value="3"/>
</c:if>

<structure:componentPropertyValue id="maxIntroLength" propertyName="MaxIntroLength" useInheritance="false"/>

<%
	/* Check if maxIntroLength is a valid integer. Nulls the maxIntroLength value if it is not.
	*/
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
%>

<content:matchingContents id="unsortedItems" contentTypeDefinitionNames="ISF Pressmeddelande" />

<content:contentSort id="sortedItems" input="${unsortedItems}">
	<%--<content:sortContentProperty name="publishDateTime" ascending="false"/>--%>
	<content:sortContentVersionAttribute name="Date" className="java.lang.String" ascending="false" />
</content:contentSort>

<common:sublist id="croppedItems" list="${sortedItems}" startIndex="0" count="${numberOfItems}"/>

<common:size id="numberOfItemInList" list="${croppedItems}" />

<div id="newsBlock" class="pressReleases">
	<div class="innerContainer">
		<h2><c:out value="${title}"/></h2>
		
		<c:forEach var="item" items="${croppedItems}" varStatus="loop">
			<c:if test="${item != null}">
				<c:set var="publishDate" value="${item.publishDateTime}"/>
				<content:contentAttribute id="title" contentId="${item.contentId}" attributeName="Title" disableEditOnSight="true"/>				
				<content:contentAttribute id="leadIn" contentId="${item.contentId}" attributeName="Ingress" disableEditOnSight="true"/>
				<content:contentAttribute id="label" contentId="${item.contentId}" attributeName="Label" disableEditOnSight="true"/>
				<content:contentAttribute id="date" contentId="${item.contentId}" attributeName="Date" disableEditOnSight="true"/>
						
				<%
					try
					{
						SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd");
				        Date myDate = formatter.parse((String)pageContext.getAttribute("date"));
				        pageContext.setAttribute("publishDate", myDate);
					}
					catch (Exception e)
					{
						//Do nothing. Use the original value.
					}
				%>
								
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
				
				<%--<common:urlBuilder id="url" baseURL="${url}" includeCurrentQueryString="false">
					<common:parameter name="contentId" value="${item.id}" />
				</common:urlBuilder>--%>
				<structure:pageUrl id="url" propertyName="DetailPage" contentId="${item.id}" useInheritance="false"/>

				<c:choose>
					<c:when test="${loop.count le numberOfExpanded}">
						<div class="newsItem">
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
							</span>
							<p>
								<common:protectEmail prefix="${encodeEmailLabel}" value="${text}" />
							</p>
						</div>
					</c:when> <%-- loop.count le numberOfExpanded --%>
					<c:otherwise>
						<c:if test="${loop.count == numberOfExpanded + 1}">
							<h3><structure:componentLabel mapKeyName="PreviousItems"/></h3>
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
		<c:if test="${empty url and pc.isDecorated}">
			<div class="adminMessage">
				<structure:componentLabel mapKeyName="NoDetailPageSelected"/>
			</div>
		</c:if>
		<structure:boundPage id="moreItemsPage" propertyName="MoreItemsPage" useInheritance="false"/>

		<c:if test="${not empty moreItemsPage}">
			<structure:componentLabel id="moreItemsLinkText" mapKeyName="MoreItemsLinkText"/>
		
			<div class="moreNews">
				<a href="<c:out value="${moreItemsPage.url}" />">
					<c:out value="${moreItemsLinkText}" escapeXml="false"/>
				</a> 
			</div>
		</c:if>
	</div>
</div>
