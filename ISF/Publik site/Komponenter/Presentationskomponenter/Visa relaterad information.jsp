<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-page" prefix="tl" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<%@ page import="java.util.Collection"%>

<%@ page contentType="text/html; charset=UTF-8" %>

<page:pageContext id="btc"/>

<%@page import="org.infoglue.cms.entities.structure.SiteNodeVO"%>
<%@page import="org.infoglue.cms.entities.content.DigitalAssetVO"%>
<%@page import="org.infoglue.cms.entities.content.Content"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController"%>
<%@page import="java.util.List"%>

<content:assetUrl id="documentHtm" propertyName="Images" assetKey="document_htm"/>
<content:assetUrl id="documentPdf" propertyName="Images" assetKey="document_pdf"/>
<content:assetUrl id="documentDoc" propertyName="Images" assetKey="document_doc"/>
<content:assetUrl id="documentXls" propertyName="Images" assetKey="document_xls"/>
<content:assetUrl id="documentPpt" propertyName="Images" assetKey="document_ppt"/>

<content:content id="miniArticle" propertyName="MiniArticle" useInheritance="false"/>

<content:contentAttribute id="miniArticleTitle" attributeName="Title" contentId="${miniArticle.id}" disableEditOnSight="true" />
<content:contentAttribute id="miniArticleText" attributeName="Text" contentId="${miniArticle.id}" disableEditOnSight="true" />

<structure:componentPropertyValue id="internalUrlPattern" propertyName="InternalUrlPattern"/>

<content:assetUrl id="imageUrl" contentId="${miniArticle.contentId}" assetKey="Image" useInheritance="false"/>

<c:set var="displayComponent" value="false"/>

<c:choose>	
	<c:when test="${param.contentId != null && param.contentId != -1}">
		<content:content id="articleContent" contentId="${param.contentId}"/>
	</c:when>
</c:choose>

<content:contentAttribute id="articleContentTitle11" attributeName="Title" contentId="${articleContent.id}" disableEditOnSight="true" />
<content:contentAttribute id="rd" attributeName="RelatedDocuments" contentId="${articleContent.id}" disableEditOnSight="true" />

<c:if test="${articleContent == null}">
	<content:content id="articleContent" propertyName="Artikel" useStructureInheritance="false"/>
</c:if>	

<%
	BasicTemplateController btc = (BasicTemplateController)pageContext.getAttribute("btc");
%>

<%-- If there are any related contents we want to display the component  --%>
<content:relatedContents id="contents" contentId="${articleContent.id}" attributeName="RelatedDocuments"/>
<%
	Collection contents = (Collection)pageContext.getAttribute("contents");	
	if (!contents.isEmpty())
	{
		pageContext.setAttribute("displayComponent", true);		
	}
%>

<%-- If there are any related pages we want to display the component  --%>

<structure:relatedPages id="webPages" contentId="${articleContent.id}" attributeName="RelatedPages"/>
<structure:siteNodesFromWebPages id="siteNodes" webpages="${webPages}"/>

<%
	Collection siteNodes = (Collection)pageContext.getAttribute("siteNodes");
	if (!siteNodes.isEmpty())
	{
		pageContext.setAttribute("displayComponent", true);		
	}
%>	

<%-- If there are any related external links we want to display the component  --%>

<content:contentAttribute id="relatedExternalLinks" contentId="${articleContent.contentId}" attributeName="RelatedExternalLinks" useStructureInheritance="false" disableEditOnSight="true" />
<c:if test="${relatedExternalLinks != ''}">		
	<c:set var="displayComponent" value="true"/>	
</c:if>	

<structure:componentPropertyValue id="sortOrder" propertyName="SortOrder" useInheritance="false"/>
<c:if test="${sortOrder == '' || sortOrder == 'Undefined' || sortOrder == null}">
	<c:set var="sortOrder" value="list"/>
</c:if>

<%-- Generate the page --%>


<c:if test="${displayComponent == false and btc.isDecorated}">
 <div class="rightBlock">
  <div class="adminMessage"><structure:componentLabel mapKeyName="NothingToDisplay"/></div>
 </div>
</c:if>

<c:if test="${displayComponent == true}">
  <div class="textBox">
  	<div class="innerContainer">
		<c:if test="${not empty imageUrl}">
				<img id="side-col-image" alt="<c:out value="${miniArticleTitle}" escapeXml="false" />" src="<c:out value="${imageUrl}" escapeXml="false" />">
		</c:if>
	
		<c:if test="${not empty miniArticle}">
			<c:if test="${not empty miniArticleTitle}">
				<h3><c:out value="${miniArticleTitle}" escapeXml="false" /></h3>
			</c:if>
			
			<p>
				<c:out value="${miniArticleText}" escapeXml="false" />
			</p>
		</c:if>
			
		<div id="related-links">
			<c:choose>
				<c:when test="${articleContent != null}">		
					<%
						StringBuffer sb = new StringBuffer();
						String assetUrl	= "";
						String title	= "";
					%>
					
					<%-- Handle related contents --%>
							
					<structure:componentLabel id="relatedLinksLabel" mapKeyName="RelatedLinks"/>
					<structure:componentLabel id="relatedExternalLinksLabel" mapKeyName="RelatedExternalLinks"/>
							
					<c:set var="sortedContents" value="${contents}"/>
							
					<c:if test="${sortOrder == 'date'}">			
						<content:contentSort id="sortedContents" input="${contents}">
							<content:sortContentProperty name="publishDateTime" ascending="false"/>
						</content:contentSort>
					</c:if>
					
					<!-- Handle related pages -->
		
					<c:set var="sortedSiteNodes" value="${siteNodes}"/>
					
					<c:if test="${sortOrder == 'date'}">
						<structure:sortPages id="sortedSiteNodes" input="${sortedSiteNodes}" sortProperty="publishDateTime" sortOrder="desc"/>
					</c:if>
					
					<%
						if(siteNodes.size() > 0)
						{
							sb.append("<h3>" + pageContext.getAttribute("relatedLinksLabel") + "</h3>");
							sb.append("<ul class=\"pages\">");
							%>
							
							<c:forEach var="sortedSiteNode" items="${sortedSiteNodes}">					
								<% 
									SiteNodeVO mySiteNode = (SiteNodeVO)pageContext.getAttribute("sortedSiteNode");				
									assetUrl	= btc.getPageUrl(mySiteNode.getSiteNodeId(), btc.getLanguageId(), new Integer(-1));
									title		= btc.getPageNavTitle(mySiteNode.getSiteNodeId());	
									sb.append("<li><a href=\"" + assetUrl + "\">" + title + "</a></li>"); 
								%>										
							</c:forEach>
							
							<%
							sb.append("</ul>");
						}
						
						String myString		= (String)pageContext.getAttribute("relatedExternalLinks");
												
						if (myString != null && !myString.trim().equals("") && !myString.trim().equals("undefined19"))
						{
							sb.append("<h3>" + pageContext.getAttribute("relatedExternalLinksLabel") + "</h3>");
							sb.append("<ul class=\"links\">");
						
							//-------------------------------
							// Handle related external links 
							//-------------------------------
									
							String temp			= "";
							String myLinkText	= "";
							String myUrl 		= "";
							boolean addedLink   = false;
							
							if (myString != null && !myString.trim().equals(""))
							{					
								java.util.StringTokenizer st1 = new java.util.StringTokenizer(myString, ";");
								
								while (st1.hasMoreTokens())
								{
									myLinkText	= "";
									myUrl 		= "";							
									temp 		= (String)st1.nextToken();
									
									if (!temp.trim().equals(""))
									{						
										if (temp.indexOf("=") != -1)
										{
											myLinkText 	= temp.substring(0, temp.indexOf("="));
											myUrl		= temp.substring(temp.indexOf("=") + 1);
										}
										
										if (!myLinkText.trim().equals("") && !myUrl.trim().equals(""))
										{
											sb.append("<li><a href=\"" + myUrl + "\" target=\"_blank\">" + myLinkText + "</a></li>");	
											addedLink = true;
										}	
									}
								}							
							}
							
							sb.append("</ul>");
						}
						
						out.print(sb.toString());
					%>
					
					<h3><structure:componentLabel mapKeyName="RelatedDocuments"/></h3>
					<ul class="documents">
						<c:forEach var="content" items="${sortedContents}">
							<c:set var="contentId" value="${content.id}"/>
							<content:contentTypeDefinition id="ctd" contentId="${content.contentId}"/>
							<content:contentAttribute id="title" contentId="${content.id}" attributeName="Rubrik" disableEditOnSight="true"/>
							<content:assets id="assets" contentId="${content.id}"/>
							
							<c:forEach var="asset" items="${assets}">
								<content:assetUrl id="assetUrl" digitalAssetId="${asset.id}"/>
								<common:formatter id="fileSize" type="fileSize" value="${asset.assetFileSize}" />
								<li>
									<a class="pdfLink" href="<c:out value="${assetUrl}" />" target="_blank" title="<structure:componentLabel mapKeyName="OpensInNewWindow"/>">
										<c:out value="${asset.assetKey}" />&nbsp;(<c:out value="${fileSize}" />)
									</a>
								</li>
							</c:forEach>			
						</c:forEach>
					</ul>
				</c:when>	
			</c:choose>
		</div>
	</div>
</c:if>
