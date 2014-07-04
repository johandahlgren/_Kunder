<%@page import="java.util.HashSet"%>
<%@page import="java.util.Map"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-lucene" prefix="lucene" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="gup" prefix="gup" %>

<%@page import="org.infoglue.deliver.util.Timer"%>
<%@page import="org.infoglue.cms.controllers.kernel.impl.simple.RegistryController"%>
<%@page import="org.infoglue.cms.applications.databeans.ReferenceBean"%>
<%@page import="org.infoglue.cms.entities.structure.SiteNodeVO"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.TemplateController"%>
<%@page import="org.infoglue.cms.entities.management.LanguageVO"%>

<%@page import="java.util.List"%>

<page:pageContext id="pc"/>

<%!
	String getPubGroup(String aDcName)
	{
		if (aDcName == null) return "";
		if (aDcName.equals("Text.Article.Journal.PeerReviewed") || aDcName.equals("Text.Article.Journal.ResearchReview") || aDcName.equals("Text.Article.Journal") || aDcName.equals("Text.Article.Magazine") || aDcName.equals("Text.Article.Journal.BookReview"))
		{
			return "1";
		}
		else if (aDcName.equals("Text.Monograph") || aDcName.equals("Text.Monograph.TextBook"))
		{
			return "2";
		}
		else if (aDcName.equals("Text.Monograph.Editor") || aDcName.equals("Text.Monograph.Editor.Critical"))
		{
			return "3";
		}
		else if (aDcName.equals("Text.TechReport"))
		{
			return "4";
		}
		else if (aDcName.equals("Text.Thesis.Doctoral") || aDcName.equals("Text.Thesis.Licentiate"))
		{
			return "5";
		}
		else if (aDcName.equals("Text.Monograph.Chapter"))
		{
			return "6";
		}
		else if (aDcName.equals("Text.Monograph.Editor.Critical"))
		{
			return "7";
		}
		else if (aDcName.equals("Text.Article.Conference.PeerReviewed") || aDcName.equals("Text.Article.Conference") || aDcName.equals("Text.Article.Conference.Poster"))
		{
			return "8";
		}
		else if (aDcName.equals("Text.TechReport.Artistic"))
		{
			return "9";
		}
		else if (aDcName.equals("Text.Patent"))
		{
			return "10";
		}
		else if (aDcName.equals("Text.Other"))
		{
			return "11";
		}
		else
		{
			return "12";
		}
	}
%>

<structure:componentPropertyValue id="gupTimeout" propertyName="GUR_GUPTimeout" useInheritance="true"/>
<structure:componentPropertyValue id="gupCacheTime" propertyName="GUR_GUPCacheTimeout" useInheritance="true"/>
<structure:componentPropertyValue id="publicationUrl" propertyName="GUR_GUPSinglePublicationUrl" useInheritance="true"/>
<structure:componentPropertyValue id="subjectDataPath" propertyName="GUR_SubjectDataPath" useInheritance="true"/>

<structure:pageUrl id="departmentDetailPageUrl" propertyName="GUR_DepartmentDetailPage" useInheritance="true" />

<div class="guResearchComp publicationDetail">
	<c:if test="${not empty publication}">
		<c:set var="dcName" value="${publication.pubtype_dcname}"/>
		<c:set var="pubTypeName" value="${publication.pubtype_iglang}"/>
						
		<%
			String dcName = (String)pageContext.getAttribute("dcName");
			pageContext.setAttribute("pubGroup", getPubGroup(dcName));
		%>
	
		<h1><c:out value="${publication.title}" /></h1>
		
		<c:if test="${not empty pubTypeName}">
			<div class="publicationType">
				<c:out value="${pubTypeName}" escapeXml="false" />
			</div>
		</c:if>
		
		<c:if test="${not empty publication.fulltext_url}">
			<div class="publicationLinkBig">
				<c:set var="linkUrl" value="${publication.fulltext_url[0]}"/>
				<c:remove var="isPdf"/>
				<%
					String linkUrl 	= (String)pageContext.getAttribute("linkUrl");
					linkUrl         = linkUrl.replaceAll("^[0-9]+:", "");
					pageContext.setAttribute("linkUrl", linkUrl);
					String url = (String)pageContext.getAttribute("linkUrl");
					if (url != null && url.endsWith(".pdf"))
					{
						pageContext.setAttribute("isPdf",true);
					}
					pageContext.setAttribute("linkUrl", url.replaceAll("^[0-9]+:", ""));
				%>
			<%--<div class="publicationLink">
					<a href="<c:out value="${linkUrl}" escapeXml="true" />" onclick="this.target='_blank';">
						<structure:componentLabel mapKeyName="ToDocument"/><br/>								
						<c:choose>
							<c:when test="${isPdf eq 'true'}">
								<structure:componentLabel mapKeyName="DocumentPdf"/>
							</c:when>
							<c:otherwise>
								<structure:componentLabel mapKeyName="DocumentHtml"/>
							</c:otherwise>
						</c:choose>
					</a>
				</div>--%>
<%--
				<%
					String linkUrl 	= (String)pageContext.getAttribute("linkUrl");
					linkUrl         = linkUrl.replaceAll("^[0-9]+:", "");
					pageContext.setAttribute("linkUrl", linkUrl);
					String fileType	= linkUrl.substring(linkUrl.lastIndexOf(".") + 1);
					String icon		= "";
					
					if (fileType.toLowerCase().equals("pdf"))
					{
						icon 		= "PdfIcon";
					}
					else if (fileType.toLowerCase().equals("html") || fileType.toLowerCase().equals("htm"))
					{
						icon 		= "HtmlIcon";
					}
					else if (fileType.toLowerCase().equals("doc") || fileType.toLowerCase().equals("docx"))
					{
						icon 		= "WordIcon";
					}
					else
					{
						icon 		= "GenericDocumentIcon";
					}
					
					pageContext.setAttribute("icon", icon);
				%>--%>
				
				<c:choose>
					<c:when test="${isPdf eq 'true'}">
						<structure:componentLabel id="fullTextText" mapKeyName="DocumentPdf"/>
						<structure:componentLabel id="fullTextImageAlt" mapKeyName="FullTextPdfImageAlt"/>
						<content:assetUrl id="iconUrl" assetKey="PdfIcon" />
					</c:when>
					<c:otherwise>
						<structure:componentLabel id="fullTextText" mapKeyName="DocumentGeneric"/>
						<structure:componentLabel id="fullTextImageAlt" mapKeyName="FullTextGenericImageAlt"/>
						<content:assetUrl id="iconUrl" assetKey="GenericDocumentIcon" />
					</c:otherwise>
				</c:choose>

				<p>
					<a href="<c:out value="${linkUrl}" />" onclick="this.target='_blank';" title="<c:out value="${publication.title}" />">
						<img src="<c:out value="${iconUrl}"/>" alt="" />
						<span>
							<c:out value="${fullTextText}"/>
						</span>
					</a>
				</p>
			</div>
		</c:if>
		
		<structure:componentLabel id="tableSummary" mapKeyName="TableSummary"/>
		<table<c:if test="${not empty tableSummary}"> summary="<c:out value="${tableSummary}"/> '<c:out value="${publication.title}" />'"</c:if> class="publicationTable">
			<c:if test="${not empty publication.person_id}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="Authors"/></th>
					<td>
					<%--
						<c:forEach var="author" items="${publication.authors}" varStatus="loop">--%>
						<c:forEach var="authorId" items="${publication.person_id}" varStatus="loop">
						
							<c:if test="${(pubGroup eq '3' and publication.person_role_mapping[authorId][0] eq '2') or pubGroup ne '3'}">
								<%-- The parser treats all mapping as 1->* however we know here that it is 1->1 --%>
								<c:set var="authorName" value="${publication.person_normal_mapping[authorId][0]}"/>
								
								<c:if test="${pubGroup eq '3'}">
									<c:set var="extra"> (<structure:componentLabel mapKeyName="Editor"/>)</c:set>
								</c:if>
								
								<c:set var="detailPageUrl" value="" />
								
								<c:set var="userId" value="${publication.personid_extid_mapping[authorId][0]}"/>
								
								<c:if test="${not empty userId}">
								
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
									
									<c:if test="${isXName}">
										<structure:pageUrl id="siteNodeUrl" propertyName="GUR_PersonDetailPage" useInheritance="true" />

										<common:urlBuilder id="detailPageUrl" baseURL="${siteNodeUrl}" includeCurrentQueryString="false">
											<common:parameter name="userId" value="${userId}" />
											<common:parameter name="userName" value="${authorName}"  />
											<%--
												This code will create a duplicate languageId in Working but it is required
												for live to work.
											--%>
											<common:parameter name="languageId" value="${pc.languageId}" />
										</common:urlBuilder>
									</c:if>
									
								</c:if>
								
								<c:choose>
									<c:when test="${not empty detailPageUrl}">
										<a href="<c:out value="${detailPageUrl}" />"><c:out value="${authorName}" /><c:out value="${extra}" /></a><br/>
									</c:when>
									<c:otherwise>
										<c:out value="${authorName}" /> <c:out value="${extra}" /><br/>
									</c:otherwise>
								</c:choose>
							</c:if>
						</c:forEach>
					</td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.sourcetitle}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="PublishedIn"/></th>
					<td><c:out value="${publication.sourcetitle}" /></td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.sourcevolume}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="Volume"/></th>
					<td><c:out value="${publication.sourcevolume}" /></td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.sourceissue}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="Issue"/></th>
					<td><c:out value="${publication.sourceissue}" /></td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.sourcepages}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="Pages"/></th>
					<td><c:out value="${publication.sourcepages}" /></td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.dissdate}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="DateOfPublicDefense"/></th>
					<td>
						<common:cropText id="croppedText" text="${publication.dissdate}" maxLength="10" suffix="" />
						<c:out value="${croppedText}"/>
					</td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.dissopponent}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="OpponentAtPublicDefense"/></th>
					<td><c:out value="${publication.dissopponent}" /></td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.isbn}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="ISBN"/></th>
					<td><c:out value="${publication.isbn}" /></td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.issn}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="ISSN"/></th>
					<td><c:out value="${publication.issn}" /></td>
				</tr>
			</c:if>		
			<c:if test="${not empty publication.publisher}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="Publisher"/></th>
					<td>
						<c:out value="${publication.publisher}" />
					</td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.place}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="PlaceOfPublication"/></th>
					<td>
						<c:out value="${publication.place}" />
					</td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.pubyear}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="PublicationYear"/></th>
					<td><c:out value="${publication.pubyear}" /></td>
				</tr>
			</c:if>
			
			<c:if test="${not empty publication.department_id}">
				<c:set var="instance_department_mapping" value="${publication.instance_department_mapping}"/>
				<%
					Map<String,List<?>> vals = (Map<String,List<?>>)pageContext.getAttribute("instance_department_mapping");
					if (vals != null)
					{
						pageContext.setAttribute("guDepartments", new HashSet(vals.get("2")));
					}
				%>

				<tr class="publicedAtRow">
					<th scope="row"><structure:componentLabel mapKeyName="PublishedAt"/></th>
					<td>
						<c:forEach var="departmentId" items="${publication.department_id}" varStatus="loop">
							
							<c:if test="${departmentId ne '0'}">
								<%-- The parser treats all mapping as 1->* however we know here that it is 1->1 --%>
								<c:set var="departmentPalasso" value="${publication.dept_palasso_mapping[departmentId][0]}"/>
								<c:set var="departmentName" value="${publication.department_mapping_iglang[departmentId][0]}"/>

								<c:set var="departmentIsGU" value="${false}"/>
								<c:forEach var="id" items="${guDepartments}">
									<c:if test="${id eq departmentId}">
										<c:set var="departmentIsGU" value="${true}"/>
									</c:if>
								</c:forEach>
							</c:if>
	
							<c:if test="${not empty departmentName and departmentIsGU eq true}">
								<c:choose>
									<c:when test="${not empty departmentPalasso}">
										<common:urlBuilder id="departmentUrl" baseURL="${departmentDetailPageUrl}" includeCurrentQueryString="false">
											<common:parameter name="departmentId" value="${departmentPalasso}" />
											<%--
												This code will create a duplicate languageId in Working but it is required
												for live to work.
											--%>
											<common:parameter name="languageId" value="${pc.languageId}" />
										</common:urlBuilder>
									
										<a href="<c:out value="${departmentUrl}"/>"><c:out value="${departmentName}" escapeXml="false"/></a><br/>
									</c:when>
									<c:otherwise>
										<c:out value="${departmentName}" escapeXml="false"/><br/>
									</c:otherwise>
								</c:choose>
							</c:if>
						</c:forEach>
					</td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.series_title}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="SeriesTitle"/></th>
					<td>
						<c:forEach var="title" items="${publication.series_title}" varStatus="loop">
							<c:if test="${not loop.first}"><br/></c:if><c:out value="${title}" />
						</c:forEach>
					</td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.seriesPart}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="SeriesPart"/></th>
					<td><c:out value="${publication.seriesPart}" />
				</tr>
			</c:if>	
			<c:if test="${not empty publication.sourcepages}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="Pages"/></th>
					<td>
						<c:out value="${publication.sourcepages}" />
					</td>
				</tr>
			</c:if>						
			<c:if test="${not empty publication.language}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="Language"/></th>
					<td>
						<c:forEach var="language" items="${publication.language}" varStatus="loop">
							<c:if test="${not loop.first}">, </c:if><c:out value="${language}" />
						</c:forEach>
					</td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.patent_applicant}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="Inventors"/></th>
					<td><c:out value="${publication.patent_applicant}" /></td>
				</tr>
			</c:if>	
			<c:if test="${not empty publication.patent_application_number}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="PatentApplicationNumber"/></th>
					<td><c:out value="${publication.patent_application_number}" /></td>
				</tr>
			</c:if>	
			<c:if test="${not empty publication.patent_application_date}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="PatentApplicationDate"/></th>
					<td>
						<common:cropText id="croppedText" text="${publication.patent_application_date}" maxLength="10" suffix="" />
						<c:out value="${croppedText}"/>
					</td>
				</tr>
			</c:if>	
			<c:if test="${not empty publication.patent_number}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="PatentNumber"/></th>
					<td><c:out value="${publication.patent_number}" /></td>
				</tr>
			</c:if>	
			<c:if test="${not empty publication.patent_date}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="PatentPublicationDate"/></th>
					<td>
						<common:cropText id="croppedText" text="${publication.patent_date}" maxLength="10" suffix="" />
						<c:out value="${croppedText}"/>
					</td>
				</tr>
			</c:if>	
			<c:if test="${not empty publication.fulltext_url}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="Links"/></th>
					<td>
						<c:forEach var="link" items="${publication.fulltext_url}" varStatus="loop">
							<c:set var="linkText" value="${link}" />

							<%
								String linkText = (String)pageContext.getAttribute("linkText");
								linkText         = linkText.replaceAll("^[0-9]+:", "");
								String link = (String)pageContext.getAttribute("link");
								pageContext.setAttribute("link", link.replaceAll("^[0-9]+:", ""));
								
								if (linkText.startsWith("http://"))
								{
									linkText = linkText.substring(7);
								}
								pageContext.setAttribute("linkText", linkText);
								
								pageContext.setAttribute("stringLength", linkText.length());
							%>
							
							<c:if test="${stringLength gt 40}">
								<common:cropText id="linkText" text="${linkText}" maxLength="40" />
							</c:if>
							<a href="<c:out value="${link}" />" onclick="this.target='_blank';"><c:out value="${linkText}" /></a><br/>
						</c:forEach>
					</td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.keywords}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="Keywords"/></th>
					<td>
						<c:out value="${publication.keywords}" />
					</td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.category_id}"><%--not empty publication.category_id --%>
				<c:catch var="indexException">
					<lucene:setupIndex id="subjectList" directoryCacheName="subjectList" path="${subjectDataPath}" indexes="catid,svepid,node_type" timeout="${timeout}" parser="se.gu.infoglue.lucene.GUCategoryParser" />
				</c:catch>
				<c:choose>
					<c:when test="${not empty indexException and pc.isDecorated}">
						 <tr>
							<th scope="row"><structure:componentLabel mapKeyName="SubjectCategories"/></th>
							<td>
								<p class="adminMessage"><structure:componentLabel mapKeyName="IndexInitFailed"/> <c:out value="${indexException.message}"/> (<c:out value="${indexException.class.name}"/>)</p>
							</td>
						</tr>
					</c:when>
					<c:when test="${empty indexException}">
						<tr>
							<th scope="row"><structure:componentLabel mapKeyName="SubjectCategories"/></th>
							<td>
								<c:set var="langCode" value="${pc.locale.language}" />
								<c:choose>
									<c:when test="${langCode eq 'en'}">
										<structure:pageUrl id="siteNodeUrl" propertyName="GUR_EnglishSubjectDetailPage" useInheritance="true" />
									</c:when>
									<c:otherwise>
										<structure:pageUrl id="siteNodeUrl" propertyName="GUR_SubjectDetailPage" useInheritance="true" />
									</c:otherwise>
								</c:choose>
								<%--
									<structure:pageUrl id="siteNodeUrl" propertyName="GUR_SubjectDetailPage" useInheritance="true" />--%>

								<c:set var="categories" value="" />
								<management:language id="language" languageId="${pc.languageId}"/>
								<c:set var="key" value="${language.languageCode}_name"/>
								<c:forEach var="categoryId" items="${publication.category_id}" varStatus="loop">
									<lucene:search id="categoryList" query="catid:${categoryId}" directory="${subjectList}"/>
									<c:set var="category" value="${categoryList[0]}"/>
									<%-- excludedQueryStringParameters="siteNodeId,sitenodeId,sitenodeid,contentId,userId,publicationId,departmentId" --%>
									<common:urlBuilder id="detailPageUrl" baseURL="${siteNodeUrl}" includeCurrentQueryString="false">
										<common:parameter name="subjectId" value="${category.svepid}" />
									</common:urlBuilder>
									
									<c:set var="categoryName" value="${category[key]}"/>
									<c:choose>
										<c:when test="${not empty detailPageUrl}">
											<c:set var="categories"><c:out value="${categories}" escapeXml="false" /><c:if test="${loop.count > 1}">, </c:if><a href="<c:out value="${detailPageUrl}" />"><c:out value="${categoryName}" /></a></c:set>
										</c:when>
										<c:otherwise>
											<c:set var="categories"><c:out value="${categories}" escapeXml="false" /><c:if test="${loop.count > 1}">, </c:if><c:out value="${categoryName}" /></c:set>
										</c:otherwise>
									</c:choose>
								</c:forEach>
								<c:out value="${categories}" escapeXml="false" />
							</td>
						</tr>
					</c:when>
				</c:choose>
			</c:if>
			<c:if test="${not empty publication.artworkprocess}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="ArtworkProcess"/></th>
					<td><c:out value="${publication.artworkprocess}" /></td>
				</tr>
			</c:if>
			<c:if test="${not empty publication.artworkessay}">
				<tr>
					<th scope="row"><structure:componentLabel mapKeyName="ArtworkEssay"/></th>
					<td><c:out value="${publication.artworkessay}" /></td>
				</tr>
			</c:if>	
		</table>
		
		<c:if test="${not empty publication.abstract}">
			<h1><structure:componentLabel mapKeyName="Abstract"/></h1>
			<p>
				<c:out value="${publication.abstract}" escapeXml="false" />
			</p>
		</c:if>
	</c:if>
</div>