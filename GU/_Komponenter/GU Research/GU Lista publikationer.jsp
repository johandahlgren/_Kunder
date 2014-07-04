<%@page import="java.util.Map"%>
<%@page import="java.net.URLEncoder"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
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
		if (aDcName == null) return "NULL";
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

<%-- Variable setup --%>
<structure:componentPropertyValue id="departmentId" propertyName="DepartmentId" useStructureInheritance="false" useInheritance="true"/>
<structure:componentPropertyValue id="userId" propertyName="UserId" useStructureInheritance="false" useInheritance="true"/>
<structure:componentPropertyValue id="subjectId" propertyName="SubjectId" useStructureInheritance="false" useInheritance="true"/>
<structure:componentPropertyValue id="lyear" propertyName="FromYear" useStructureInheritance="false" useInheritance="false"/>
<structure:componentPropertyValue id="hyear" propertyName="ToYear" useStructureInheritance="false" useInheritance="false"/>
<structure:componentPropertyValue id="publicationListUrl" propertyName="GUR_GUPListPublicationsURL" useStructureInheritance="true" useInheritance="true"/>
<structure:componentPropertyValue id="gupTimeout" propertyName="GUR_GUPTimeout" useStructureInheritance="true" useInheritance="true"/>
<structure:componentPropertyValue id="gupCacheTime" propertyName="GUR_GUPCacheTimeoutPublications" useStructureInheritance="true" useInheritance="true"/>
<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="maxNumberOfItems" propertyName="MaxNumberOfItems" useInheritance="false"/>
<structure:componentPropertyValue id="itemsPerPage" propertyName="ItemsPerPage" useInheritance="false"/>
<structure:componentPropertyValue id="showTitle" propertyName="ShowTitle" useInheritance="false"/>
<structure:componentPropertyValue id="pagingPages" propertyName="PagingPages" useInheritance="true"/>

<management:language id="langVO" languageId="${pc.languageId}"/>
<c:choose>
	<c:when test="${langVO.languageCode eq 'en'}">
		<structure:pageUrl id="detailPublicationPageUrl" propertyName="GUR_EnglishPublicationDetailPage" useInheritance="true"/>	
	</c:when>
	<c:otherwise>
		<structure:pageUrl id="detailPublicationPageUrl" propertyName="GUR_PublicationDetailPage" useInheritance="true"/>
	</c:otherwise>
</c:choose>

<content:assetUrl id="documentImageUrl" assetKey="DocumentImage" />

<%-- HTML-component start --%>
<div class="guResearchComp publicationList">

	<%-- Variable configuration --%>
	<c:if test="${empty title}">
		<structure:componentLabel id="title" mapKeyName="DefaultTitle"/>
	</c:if>
	
	<c:if test="${empty pagingPages}">
		<c:set var="pagingPages" value="9" />
	</c:if>
	
	<c:if test="${empty publicationListUrl and pc.isDecorated}">
		<p><structure:componentLabel mapKeyName="NoPublicationsURLProvided"/></p>
	</c:if>
	
	<c:if test="${not empty param.publicationsPerPage}">
		<c:set var="itemsPerPage" value="${param.publicationsPerPage}" />
	</c:if>
	<%-- If itemsPerPage it either means that someone has tampered with
	     the param or that the user selected 'show all' which is represented
	     by the value -1 --%>
	<c:if test="${itemsPerPage lt 1}">
		<c:remove var="itemsPerPage" />
	</c:if>

	<c:if test="${not empty publicationListUrl}">
	
		<c:if test="${not empty param.userId}">
		    <c:set var="userId" value="${param.userId}" />
		</c:if>
		<c:if test="${not empty param.subjectId}">
		    <c:set var="subjectId" value="${param.subjectId}" />
		</c:if>
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
		
					if (pageType.equals("persondetalj") || pageType.equals("enhetsdetalj"))
					{	
						String departmentId = pageFunction.substring(pageFunction.indexOf("-") + 1);
						pageContext.setAttribute("departmentId", departmentId);
					}
				}
			%>
		</c:if>
		<c:if test="${not empty xname}">
		    	<c:set var="userId" value="${xname}" />
		</c:if>
		
		<c:set var="currentPage" value="${param.publicationPageNumber}" />
		<c:if test="${empty currentPage}">
			<c:set var="currentPage" value="1" />
		</c:if>
		
		<%-- It is important that userId is placed before departmentId
				     since a person details view can contain both Ids but the userId
				     should always take precedence --%>
		<common:urlBuilder id="publicationListUrl" baseURL="${publicationListUrl}" includeCurrentQueryString="false" fullBaseUrl="true">
			<c:choose>
				<c:when test="${not empty userId}">
					<common:parameter name="userid" value="${userId}"/>
				</c:when>
				<c:when test="${not empty subjectId}">
					<common:parameter name="svepid" value="${subjectId}"/>
				</c:when>
				<c:when test="${not empty departmentId}">
					<common:parameter name="palassoid" value="${departmentId}"/>
				</c:when>
				<c:otherwise>
					<c:set var="noId" value="true" />
				</c:otherwise>
			</c:choose>
			
			<c:if test="${not empty lyear}">
				<common:parameter name="lyear" value="${lyear}"/>
			</c:if>
			
			<c:if test="${not empty hyear}">
				<common:parameter name="hyear" value="${hyear}"/>
			</c:if>
			
			<%-- If maxNumberOfItems is set we should not do paging --%>
			<c:if test="${not empty currentPage and empty maxNumberOfItems}">
				<common:parameter name="spost" value="${(currentPage - 1) * itemsPerPage}"/>
			</c:if>
			
			<c:choose>
				<c:when test="${not empty maxNumberOfItems}">
					<common:parameter name="npost" value="${maxNumberOfItems}"/>
				</c:when>
				<c:when test="${not empty itemsPerPage}">
					<common:parameter name="npost" value="${itemsPerPage}"/>
				</c:when>
			</c:choose>
		</common:urlBuilder>

		<%-- Data retrieval --%>
		<c:choose>
			<c:when test="${noId eq 'true' and pc.isDecorated}">
				<c:if test="${showTitle eq 'yes'}">
					<h2><c:out value="${title}"/></h2>
				</c:if>
				<p class="adminError"><structure:componentLabel mapKeyName="NoIdProvided"/></p>
			</c:when>
			<c:otherwise>	
				<common:import id="xmlPageXml" url="${publicationListUrl}" timeout="${gupTimeout}" charEncoding="utf-8" useCache="true" cacheTimeout="${gupCacheTimeout}" useFileCacheFallback="true" fileCacheCharEncoding="utf-8"/>
				
				<c:choose>
					<c:when test="${empty xmlPageXml}">
						<c:if test="${showTitle eq 'yes'}">
							<h2><c:out value="${title}"/></h2>
						</c:if>
						<p><structure:componentLabel mapKeyName="NoPublicationXmlData"/></p>
					</c:when>
					<c:otherwise>
						<gup:getGUPData id="xmlPage" xmlData="${xmlPageXml}" language="${pc.locale}" />

						<%-- Look in the result for the value we want in this component --%>
						<c:if test="${not empty xmlPage.response.result.docs}">
							<c:set var="publications" value="${xmlPage.response.result.docs}"/>
							<c:set var="numberOfItemsInList" value="${xmlPage.response.result.numFound}"/>
						</c:if>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
		
		<%-- Content display --%>
		<c:if test="${not empty publications}">						
			<c:set var="${currentYear}" value="" />

			<%
				int pagingPages 	        = new Integer((String)pageContext.getAttribute("pagingPages"));
				int currentPage 	        = new Integer((String)pageContext.getAttribute("currentPage"));
				String numberOfItemsPerPageString = (String)pageContext.getAttribute("itemsPerPage");
				Float numberOfItemsPerPage;
				int startIndex, endIndex, numberOfPages;
				if (numberOfItemsPerPageString == null || "".equals(numberOfItemsPerPageString.trim()))
				{
					numberOfItemsPerPage = 0.0f;
					numberOfPages = 1;
					startIndex = 1;
					endIndex   = -1;
				}
				else
				{
					numberOfItemsPerPage = new Float(numberOfItemsPerPageString);
					Object numgerOfItemsInListObject = pageContext.getAttribute("numberOfItemsInList");
					Float numberOfItemsInList;
					if (numgerOfItemsInListObject instanceof Integer)
					{
						numberOfItemsInList = new Float((Integer)numgerOfItemsInListObject);
					}
					else if (numgerOfItemsInListObject instanceof String)
					{
						String numberOfItemsInListString = (String)numgerOfItemsInListObject;
						if (numberOfItemsInListString == null || "".equals(numberOfItemsInListString.trim()))
						{
							numberOfItemsInList = 0.0f;
						}
						else
						{
							numberOfItemsInList = new Float(numberOfItemsInListString);						
						}
					}
					else
					{
						numberOfItemsInList = 0.0f;
					}

					numberOfPages			= new Double(Math.ceil(numberOfItemsInList / numberOfItemsPerPage)).intValue();
					startIndex = Math.max(1, Math.min(numberOfPages - pagingPages, currentPage - Math.round(pagingPages / 2.0f)) + 1);
					endIndex   = Math.min(numberOfPages, startIndex + pagingPages - 1);
				}

				pageContext.setAttribute("startIndex", startIndex);
				pageContext.setAttribute("endIndex", endIndex);
				pageContext.setAttribute("numberOfPages", new Integer(numberOfPages));
				pageContext.setAttribute("halfPagingPages", new Integer(Math.round(pagingPages / 2.0f)));
			%>

			<%-- If we are on the last page use the number of items as the end of the interval value.
				 If we do not that value may be higher than the actual total amount --%>
			<c:choose>
				<c:when test="${currentPage eq numberOfPages}">
					<c:set var="maxItems" value="${numberOfItemsInList}" />
				</c:when>
				<c:otherwise>
					<c:set var="maxItems" value="${currentPage * itemsPerPage}" />
				</c:otherwise>
			</c:choose>
			
			<c:set var="slotName" value="${pc.componentLogic.infoGlueComponent.slotName}"/>
			<%
				String slotName = (String)pageContext.getAttribute("slotName");
				String selectedTab = slotName.substring(slotName.length() - 1);
				pageContext.setAttribute("selectedTab", selectedTab);
			%>
			
			<c:if test="${numberOfItemsInList gt 0 and showTitle eq 'yes'}">
				<h2><c:out value="${title}"/></h2>
			</c:if>
			
			<%-- This if-statement and its content is duplicated further down. --%>
			<c:if test="${numberOfItemsInList gt 0 and empty maxNumberOfItems}">
				
				<div class="listInfo"><p><structure:componentLabel mapKeyName="Showing"/> <c:out value="${((currentPage - 1) * itemsPerPage) + 1}" /> - <c:out value="${maxItems}" /> <structure:componentLabel mapKeyName="Of"/> <c:out value="${numberOfItemsInList}" /></p>
					<%--
					OBS! Parameters in the action-attribute of a form tag is ignored.
					     Therefore we'll have to add all parameter we want to keep
					     as hidden fields.
					 --%>
					<common:urlBuilder id="changeItemCountUrl" includeCurrentQueryString="false" />
					<form class="itemCountPicker" method="get" action="<c:out value="${changeItemCountUrl}"/>">
						<input type="hidden" name="selectedTab" value="<c:out value="${selectedTab}"/>" />
						<c:forEach var="pair" items="${param}">
							<c:if test="${pair.key ne 'publicationsPerPage' and pair.key ne 'publicationPageNumber' and pair.key ne 'selectedTab' and pair.key ne 'originalRequestURL' and pair.key ne  'originalServletPath' and pair.key ne 'originalQueryString'}">
								<input type="hidden" name="<c:out value="${pair.key}"/>" value="<c:out value="${pair.value}"/>" />
							</c:if>
						</c:forEach>
						<select class="itemCountSelector" name="publicationsPerPage">
							<option <c:if test="${itemsPerPage eq 10}">selected="selected"</c:if> value="10"><structure:componentLabel mapKeyName="Show"/> 10 <structure:componentLabel mapKeyName="PerPage"/></option>
							<option <c:if test="${itemsPerPage eq 25}">selected="selected"</c:if> value="25"><structure:componentLabel mapKeyName="Show"/> 25 <structure:componentLabel mapKeyName="PerPage"/></option>
							<option <c:if test="${itemsPerPage eq 50}">selected="selected"</c:if> value="50"><structure:componentLabel mapKeyName="Show"/> 50 <structure:componentLabel mapKeyName="PerPage"/></option>
							<option <c:if test="${itemsPerPage eq 100}">selected="selected"</c:if> value="100"><structure:componentLabel mapKeyName="Show"/> 100 <structure:componentLabel mapKeyName="PerPage"/></option>
							<option <c:if test="${itemsPerPage eq 500}">selected="selected"</c:if> value="500"><structure:componentLabel mapKeyName="Show"/> 500 <structure:componentLabel mapKeyName="PerPage"/></option>
							<%--<option <c:if test="${empty itemsPerPage}">selected="selected"</c:if> value="-1"><structure:componentLabel mapKeyName="ShowAll"/></option>--%>
						</select>
						<noscript>
							<input type="submit" value="<structure:componentLabel mapKeyName="NoScriptChangePerPageCount"/>"/>
						</noscript>
					</form>
				</div>
			</c:if>

			<c:forEach var="publication" items="${publications}" varStatus="loop">
				<c:if test="${empty maxNumberOfItems}">
					<c:if test="${publication.pubyear ne currentYear}">
						<h3><c:out value="${publication.pubyear}"/></h3>
						<c:set var="currentYear" value="${publication.pubyear}" />
					</c:if>
				</c:if>
				<div class="publication">
					<p class="publicationDescription">
						<%--excludedQueryStringParameters="siteNodeId,sitenodeId,pageNumber,sitenodeid,contentId,subjectId,userId,departmentId" --%>
						<common:urlBuilder id="publicationUrl" baseURL="${detailPublicationPageUrl}" includeCurrentQueryString="false">
							<common:parameter name="publicationId" value="${publication.pubid}" />
						</common:urlBuilder>
						
						<a href="<c:out value="${publicationUrl}" escapeXml="true" />" class="publicationTitle" tabindex="0"><c:out value="${publication.title}" /></a>
						
						<br/>

						<c:set var="dcName" value="${publication.pubtype_dcname}"/>
						<c:set var="pubTypeName" value="${publication.pubtype_iglang}"/>
										
						<%
							String dcName = (String)pageContext.getAttribute("dcName");
							pageContext.setAttribute("pubGroup", getPubGroup(dcName));
						%>
					
						<c:set var="authors" value="" />
						<c:forEach var="authorId" items="${publication.person_id}" varStatus="loop">
							<%-- The parser treats all mapping as 1->* however we know here that it is 1->1 --%>
							<c:set var="authorName" value="${publication.person_normal_mapping[authorId][0]}"/>
							<c:choose>
								<c:when test="${loop.count eq 6}">
									<c:set var="authors"><c:out value="${authors}" escapeXml="false" /> <structure:componentLabel mapKeyName="EtAl"/></c:set>
								</c:when>
								<c:when test="${loop.count < 6}">
									<c:set var="detailPageUrl" value="" />
						
									<c:choose>
										<c:when test="${pubGroup eq '3' and publication.person_role_mapping[authorId][0] eq '2'}">
											<structure:componentLabel id="extra" mapKeyName="Editor"/>
										</c:when>
										<c:otherwise>
											<c:set var="extra" value=""/>
										</c:otherwise>
									</c:choose>
									
									<%-- The parser treats all mapping as 1->* however we know here that it is 1->1 --%>
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
											<c:set var="authors"><c:out value="${authors}" escapeXml="false" /><c:if test="${loop.count > 1}">, </c:if><a href="<c:out value="${detailPageUrl}" />"><c:out value="${authorName}" /></a><c:if test="${not empty extra}"> (<c:out value="${extra}"/>)</c:if></c:set>
										</c:when>
										<c:otherwise>
											<c:set var="authors"><c:out value="${authors}" escapeXml="false" /><c:if test="${loop.count > 1}">, </c:if><c:out value="${authorName}" /><c:if test="${not empty extra}"> (<c:out value="${extra}"/>)</c:if></c:set>
										</c:otherwise>
									</c:choose>
								</c:when>
							</c:choose>
						</c:forEach>
						
						<c:out value="${authors}" escapeXml="false" />
						
						<br/>
						<c:set var="groupSimpleName" value="hej"/>
						<c:choose>
							<c:when test="${pubGroup eq '1'}">
								<c:if test="${not empty publication.sourcetitle}"><c:out value="${publication.sourcetitle}" />,</c:if>
								<c:if test="${not empty publication.sourcevolume}"><structure:componentLabel mapKeyName="Volume"/> <c:out value="${publication.sourcevolume}" />,</c:if>
								<c:if test="${not empty publication.sourceissue}"><structure:componentLabel mapKeyName="Issue"/> <c:out value="${publication.sourceissue}" />,</c:if>
								<c:if test="${not empty publication.sourcepages}"><structure:componentLabel mapKeyName="Pages"/> <c:out value="${publication.sourcepages}" /></c:if>
								
								<structure:componentLabel id="groupSimpleName" mapKeyName="Group1SimpleName"/>
								<c:if test="${dcName eq 'Text.Article.Journal.PeerReviewed'}">
									<structure:componentLabel id="groupSimpleNamePeered" mapKeyName="GroupSimpleNamePeerReviewed"/>
									<c:set var="groupSimpleName" value="${groupSimpleName}, ${groupSimpleNamePeered}"/>
								</c:if>
							</c:when>
							<c:when test="${pubGroup eq '2'}">
								<c:if test="${not empty publication.place}"><c:out value="${publication.place}" />,</c:if>
								<c:if test="${not empty publication.publisher}"><c:out value="${publication.publisher}" /></c:if>
								
								<structure:componentLabel id="groupSimpleName" mapKeyName="Group2SimpleName"/>
							</c:when>
							<c:when test="${pubGroup eq '3'}">
								<c:if test="${not empty publication.place}"><c:out value="${publication.place}" />,</c:if>
								<c:if test="${not empty publication.publisher}"><c:out value="${publication.publisher}" /></c:if>
								
								<structure:componentLabel id="groupSimpleName" mapKeyName="Group3SimpleName"/>
							</c:when>
							<c:when test="${pubGroup eq '4'}">
								<c:if test="${not empty publication.seriestitle}"><c:out value="${publication.seriestitle}" />,</c:if>
								<c:if test="${not empty publication.seriespart}"><c:out value="${publication.seriespart}" />,</c:if>
								<c:if test="${not empty publication.publisherCity}"><c:out value="${publication.publisherCity}" />,</c:if>
								<c:if test="${not empty publication.publisher}"><c:out value="${publication.publisher}" /></c:if>
								(<structure:componentLabel mapKeyName="Report"/>)
								
								<structure:componentLabel id="groupSimpleName" mapKeyName="Group4SimpleName"/>
							</c:when>
							<c:when test="${pubGroup eq '5'}">
								<c:if test="${not empty publication.place}"><c:out value="${publication.place}" />,</c:if>
								<c:if test="${not empty publication.publisher}"><c:out value="${publication.publisher}" />,</c:if>
								<c:choose>
									<c:when test="${dcName eq 'Text.Thesis.Doctoral'}">
										<structure:componentLabel mapKeyName="PhdThesis"/>
										<structure:componentLabel id="groupSimpleName" mapKeyName="Group5SimpleNamePhdThesis"/>
									</c:when>
									<c:when test="${dcName eq 'Text.Thesis.Licentiate'}">
										<structure:componentLabel mapKeyName="LicentiateThesis"/>
										<structure:componentLabel id="groupSimpleName" mapKeyName="Group5SimpleNameLicentiate"/>
									</c:when>
								</c:choose>
							</c:when>
							<c:when test="${pubGroup eq '6'}">
								<c:if test="${not empty publication.sourcetitle}"><c:out value="${publication.sourcetitle}" />,</c:if>
								<c:if test="${not empty publication.place}"><c:out value="${publication.place}" />,</c:if>
								<c:if test="${not empty publication.publisher}"><c:out value="${publication.publisher}" />,</c:if>
								<structure:componentLabel mapKeyName="BookChapter"/>
								
								<structure:componentLabel id="groupSimpleName" mapKeyName="Group6SimpleName"/>
							</c:when>
							<c:when test="${pubGroup eq '7'}">
								<c:if test="${not empty publication.place}"><c:out value="${publication.place}" />,</c:if>
								<c:if test="${not empty publication.publisher}"><c:out value="${publication.publisher}" />,</c:if>
								<structure:componentLabel mapKeyName="TextCritical"/>
								
								<structure:componentLabel id="groupSimpleName" mapKeyName="Group7SimpleName"/>
							</c:when>
							<c:when test="${pubGroup eq '8'}">
								<c:if test="${not empty publication.sourcetitle}"><c:out value="${publication.sourcetitle}" />,</c:if>
								<structure:componentLabel mapKeyName="ConferenceContribution"/>
								
								<structure:componentLabel id="groupSimpleName" mapKeyName="Group8SimpleName"/>
							</c:when>
							<c:when test="${pubGroup eq '9'}">
								<c:if test="${not empty publication.sourcetitle}"><c:out value="${publication.sourcetitle}" />,</c:if>
								<structure:componentLabel mapKeyName="ArtisticResearch"/>
								
								<structure:componentLabel id="groupSimpleName" mapKeyName="Group9SimpleName"/>
							</c:when>
							<c:when test="${pubGroup eq '10'}">
								<c:if test="${not empty publication.patent_number}"><c:out value="${publication.patent_number}" />,</c:if>
								<structure:componentLabel mapKeyName="Patent"/>
								
								<structure:componentLabel id="groupSimpleName" mapKeyName="Group10SimpleName"/>
							</c:when>
							<c:when test="${pubGroup eq '11'}">
								<c:if test="${not empty publication.sourcetitle}"><c:out value="${publication.sourcetitle}" />,</c:if>
								<c:if test="${not empty publication.place}"><c:out value="${publication.place}" />,</c:if>
								<c:if test="${not empty publication.publisher}"><c:out value="${publication.publisher}" />,</c:if>
								<structure:componentLabel mapKeyName="OtherPublication"/>
								
								<structure:componentLabel id="groupSimpleName" mapKeyName="Group11SimpleName"/>
							</c:when>
							<c:when test="${pubGroup eq '12'}">
								<c:if test="${not empty publication.sourcetitle}"><c:out value="${publication.sourcetitle}" />,</c:if>
								<c:if test="${not empty publication.place}"><c:out value="${publication.place}" />,</c:if>
								<c:if test="${not empty publication.publisher}"><c:out value="${publication.publisher}" />,</c:if>
								<c:if test="${not empty pubTypeName}"><c:out value="${pubTypeName}"/></c:if>

								<c:set var="groupSimpleName" value="${pubTypeName}" />
							</c:when>
						</c:choose>
						
						<c:out value="${publication.pubyear}" />

						<br/>

						<span class="publicationGroup"><c:out value="${groupSimpleName}" escapeXml="false"/></span>
					</p>
					<c:if test="${not empty publication.fulltext_url}">
						<c:set var="linkUrl" value="${publication.fulltext_url[0]}"/>
						<c:remove var="isPdf"/>
						<%
							String url = (String)pageContext.getAttribute("linkUrl");
							if (url != null && url.endsWith(".pdf"))
							{
								pageContext.setAttribute("isPdf",true);
							}
							pageContext.setAttribute("linkUrl", url.replaceAll("^[0-9]+:", ""));
						%>
						<div class="publicationLink">
							<a href="<c:out value="${linkUrl}" escapeXml="true" />" onclick="this.target='_blank';" title="<c:out value="${publication.title}" escapeXml="true" />" tabindex="0">
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
						</div>
					</c:if>
				</div>	
			
			</c:forEach>
			
			<%-- If maxNumberOfItems is set paging should be disabled, i.e. not shown --%>
			<c:if test="${empty maxNumberOfItems}">
				<%-- This if-statement and its content is duplicated further up. --%>
				<c:if test="${numberOfItemsInList gt 0}">

					<div class="listInfo"><p><structure:componentLabel mapKeyName="Showing"/> <c:out value="${((currentPage - 1) * itemsPerPage) + 1}" /> - <c:out value="${maxItems}" /> <structure:componentLabel mapKeyName="Of"/> <c:out value="${numberOfItemsInList}" /></p>
						<%--
						OBS! Parameters in the action-attribute of a form tag is ignored.
						     Therefore we'll have to add all parameter we want to keep
						     as hidden fields.
						 --%>
						<common:urlBuilder id="changeItemCountUrl" includeCurrentQueryString="false" />
						<form class="itemCountPicker" method="get" action="<c:out value="${changeItemCountUrl}"/>">
							<input type="hidden" name="selectedTab" value="<c:out value="${selectedTab}"/>" />
							<c:forEach var="pair" items="${param}">
								<c:if test="${pair.key ne 'publicationsPerPage' and pair.key ne 'publicationPageNumber' and pair.key ne 'selectedTab' and pair.key ne 'originalRequestURL' and pair.key ne  'originalServletPath' and pair.key ne 'originalQueryString'}">
									<input type="hidden" name="<c:out value="${pair.key}"/>" value="<c:out value="${pair.value}"/>" />
								</c:if>
							</c:forEach>
							<select class="itemCountSelector" name="publicationsPerPage">
								<option <c:if test="${itemsPerPage eq 10}">selected="selected"</c:if> value="10"><structure:componentLabel mapKeyName="Show"/> 10 <structure:componentLabel mapKeyName="PerPage"/></option>
							<option <c:if test="${itemsPerPage eq 25}">selected="selected"</c:if> value="25"><structure:componentLabel mapKeyName="Show"/> 25 <structure:componentLabel mapKeyName="PerPage"/></option>
							<option <c:if test="${itemsPerPage eq 50}">selected="selected"</c:if> value="50"><structure:componentLabel mapKeyName="Show"/> 50 <structure:componentLabel mapKeyName="PerPage"/></option>
							<option <c:if test="${itemsPerPage eq 100}">selected="selected"</c:if> value="100"><structure:componentLabel mapKeyName="Show"/> 100 <structure:componentLabel mapKeyName="PerPage"/></option>
							<option <c:if test="${itemsPerPage eq 500}">selected="selected"</c:if> value="500"><structure:componentLabel mapKeyName="Show"/> 500 <structure:componentLabel mapKeyName="PerPage"/></option>									
							<%--<option <c:if test="${empty itemsPerPage}">selected="selected"</c:if> value="-1"><structure:componentLabel mapKeyName="ShowAll"/></option>--%>
							</select>
							<noscript>
								<input type="submit" value="<structure:componentLabel mapKeyName="NoScriptChangePerPageCount"/>"/>
							</noscript>
						</form>
					</div>
				</c:if> <%-- numberOfItemsInList gt 0 --%>

				<c:if test="${numberOfPages gt 1}">
					<ul class="slotlist">
						<c:if test="${currentPage > 1}">
							<common:urlBuilder id="firstPageUrl" excludedQueryStringParameters="publicationPageNumber,selectedTab" >
								<common:parameter name="publicationPageNumber" value="1" />
								<common:parameter name="selectedTab" value="${selectedTab}" />
							</common:urlBuilder>
							<common:urlBuilder id="previousPageUrl" excludedQueryStringParameters="publicationPageNumber,selectedTab">
								<common:parameter name="publicationPageNumber" value="${currentPage - 1}" />
								<common:parameter name="selectedTab" value="${selectedTab}" />
							</common:urlBuilder>

							<li><a href="<c:out value="${previousPageUrl}" escapeXml="true" />"><structure:componentLabel mapKeyName="PagingPrevious"/></a></li>
							
							<c:if test="${startIndex > 1}">
								<li><a href="<c:out value="${firstPageUrl}" escapeXml="true" />">1</a></li>
								<%-- Skip the case where there is more than half paging items to the left but no numbers between
								     the first page and the first visible page. Combined with the other if-statement this if says:
								     startIndex > 2 --%>
								<c:if test="${startIndex ne 2}">
									<li>&#8230;</li>
								</c:if>
							</c:if>
						</c:if>
						
						<%
							/* Some of the variables used here are computed earlier in the file 
							 * where the "showing x of y" is displayed.
							 */

							 for (int i = startIndex; i <= endIndex; i++)
							{
								pageContext.setAttribute("page", new Integer(i));
								%>
									<common:urlBuilder id="pageUrl" excludedQueryStringParameters="publicationPageNumber,selectedTab">
										<common:parameter name="publicationPageNumber" value="${page}" />
										<common:parameter name="selectedTab" value="${selectedTab}" />
									</common:urlBuilder>
									<c:choose>
										<c:when test="${currentPage eq page}">
											<li class="current"><c:out value="${page}"/></li>
										</c:when>
										<c:otherwise>
											<li><a href="<c:out value="${pageUrl}" escapeXml="true" />" class="number"><c:out value="${page}"/></a></li>
										</c:otherwise>
									</c:choose>
								<%
							}
						%>
						
						<c:if test="${currentPage < numberOfPages}">
							<common:urlBuilder id="nextPageUrl" excludedQueryStringParameters="publicationPageNumber,selectedTab">
								<common:parameter name="publicationPageNumber" value="${currentPage + 1}" />
								<common:parameter name="selectedTab" value="${selectedTab}" />
							</common:urlBuilder>
							<common:urlBuilder id="lastPageUrl" excludedQueryStringParameters="publicationPageNumber,selectedTab">
								<common:parameter name="publicationPageNumber" value="${numberOfPages}" />
								<common:parameter name="selectedTab" value="${selectedTab}" />
							</common:urlBuilder>
						
							<c:if test="${endIndex < numberOfPages}">
								<c:if test="${currentPage ne numberOfPages - halfPagingPages}">
									<li>&#8230;</li> <%-- ellipsis --%>
								</c:if>
								<li><a href="<c:out value="${lastPageUrl}"/>"><c:out value="${numberOfPages}"/></a></li>
							</c:if>
							<li><a href="<c:out value="${nextPageUrl}" escapeXml="true" />"><structure:componentLabel mapKeyName="PagingNext"/></a></li>
						</c:if>
					</ul>
				</c:if> <%-- numberOfPages gt 1 --%>
				
				<c:if test="${numberOfItemsInList gt 0 and empty maxNumberOfItems}">
					<script type="text/javascript">
					<!-- 
					jQuery(".itemCountSelector").change(function() {
							$(this).parents("form").get(0).submit();
						});
					-->
					</script>
				</c:if>
			</c:if> <%-- empty maxNumberOfItems --%>
		</c:if> <%-- not empty publications --%>
	</c:if> <%-- not empty publicationListUrl --%>
</div><%--page:pageContext id=/option--%>