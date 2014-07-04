<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-lucene" prefix="lucene" %>
<%@ taglib uri="gup" prefix="gup" %>

<page:pageContext id="pc" />

<structure:pageUrl id="personDetailPageUrl" propertyName="GUR_PersonDetailPage" useInheritance="true" />
<structure:pageUrl id="departmentDetailPageUrl" propertyName="GUR_DepartmentDetailPage" useInheritance="true" />

<%-- General  --%>
<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="showTitle" propertyName="ShowTitle" useInheritance="false"/>
<structure:componentPropertyValue id="showTopResearchers" propertyName="ShowTopResearchers" useInheritance="false"/>

<%-- Data retrieval --%>
<structure:componentPropertyValue id="subjectId" propertyName="SubjectId" useInheritance="true"/>
<structure:componentPropertyValue id="idData" propertyName="GUR_IdDataPath" useInheritance="true" />
<structure:componentPropertyValue id="personData" propertyName="GUR_PersonDataPath" useInheritance="true"/>
<structure:componentPropertyValue id="lyear" propertyName="FromYear" useStructureInheritance="false" useInheritance="false"/>
<structure:componentPropertyValue id="hyear" propertyName="ToYear" useStructureInheritance="false" useInheritance="false"/>
<structure:componentPropertyValue id="luceneTimeout" propertyName="GUR_LuceneCacheluceneTimeout" useInheritance="true"/>
<structure:componentPropertyValue id="gupluceneTimeout" propertyName="GUR_GUPluceneTimeout" useStructureInheritance="true" useInheritance="true"/>
<structure:componentPropertyValue id="gupCacheTime" propertyName="GUR_GUPCacheluceneTimeoutResearchers" useStructureInheritance="true" useInheritance="true"/>
<structure:componentPropertyValue id="gupRequestTime" propertyName="GUR_GUPTimeout" useStructureInheritance="true" useInheritance="true"/>
<structure:componentPropertyValue id="subjectDataPath" propertyName="GUR_SubjectDataPath" useInheritance="true"/>

<%-- Paging related properties --%>
<structure:componentPropertyValue id="maxNumberOfItems" propertyName="MaxNumberOfItems" useInheritance="false"/>
<structure:componentPropertyValue id="itemsPerPage" propertyName="ItemsPerPage" useInheritance="false"/>
<structure:componentPropertyValue id="pagingPages" propertyName="PagingPages" useInheritance="false"/>

<%--
"/upl-records-publications/header/relations/researchers/*");
			XPathExpression researchersList = XPathFactory.newInstance().newXPath().compile("/upl-records-publications/header/relations/researchers/*")
 --%>
<c:choose>
	<c:when test="${showTopResearchers}">
		<structure:componentPropertyValue id="researchersListUrl" propertyName="GUR_GUPListPublicationsURL" useStructureInheritance="true" useInheritance="true"/>
		<%--<c:set var="xPathExpr" value="/upl-records-publications/header/relations/researchers/*"/> --%>
		<c:if test="${empty maxNumberOfItems}">
			<c:set var="maxNumberOfItems" value="10"/>
		</c:if>
	</c:when>
	<c:otherwise>
		<structure:componentPropertyValue id="researchersListUrl" propertyName="GUR_GUPListResearchersURL" useStructureInheritance="true" useInheritance="true"/>
		<%--<c:set var="xPathExpr" value="/upl-records-researchers/upl-researchers/*"/> --%>
	</c:otherwise>
</c:choose>

<c:if test="${not empty param.subjectId}">
	<c:set var="subjectId" value="${param.subjectId}" />
</c:if>

<c:if test="${empty title}">
	<structure:componentLabel id="title" mapKeyName="DefaultTitle"/>
</c:if>

<c:if test="${empty pagingPages}">
	<c:set var="pagingPages" value="9" />
</c:if>

<c:set var="currentPage" value="${param.researchersPageNumber}" />
<c:if test="${empty currentPage}">
	<c:set var="currentPage" value="1" />
</c:if>

<c:if test="${empty itemsPerPage}">
	<c:set var="itemsPerPage" value="50" />
</c:if>

<c:if test="${not empty param.researchersPerPage}">
	<c:set var="itemsPerPage" value="${param.researchersPerPage}" />
</c:if>
<%-- If itemsPerPage < 1 it either means that someone has tampered with
     the param or that the user selected 'show all' which is represented
     by the value -1 --%>
<c:if test="${itemsPerPage lt 1}">
	<c:remove var="itemsPerPage" />
</c:if>

<!--eri-no-index-->
<div class="guResearchComp researcherList">
	<c:choose>
		<c:when test="${empty subjectId and pc.isDecorated}">
			<p class="adminError"><structure:componentLabel mapKeyName="NoSubjectId"/></p>
		</c:when>
		<c:when test="${not empty subjectId}">
			<c:choose>
				<c:when test="${not empty researchersListUrl}">
					<lucene:setupIndex id="subjectList" directoryCacheName="subjectList" path="${subjectDataPath}" indexes="catid,svepid,node_type,parentid" timeout="${luceneTimeout}" parser="se.gu.infoglue.lucene.GUCategoryParser" />
					<lucene:search id="subjects" directory="${subjectList}" query="svepid:${subjectId}" />
					<c:set var="subjectId" value="${subjects[0].catid}"/>

					<common:urlBuilder id="researchersUrl" baseURL="${researchersListUrl}" fullBaseUrl="true" includeCurrentQueryString="false" >
						<common:parameter name="catid" value="${subjectId}" />

						<c:choose>
							<c:when test="${not empty maxNumberOfItems}">
								<%-- We always get all related researchers in the publications list
								     npost in this case means the number of publications, which we
								     are not interested in. So the minimum number of publications
								     is a good number to use (npost=0 => all pubs). --%>
								<common:parameter name="npost" value="1"/>
							</c:when>
							<c:when test="${not empty itemsPerPage}">
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
							
								<common:parameter name="npost" value="${itemsPerPage}"/>
							</c:when>
						</c:choose>
					</common:urlBuilder>
					<common:import id="researchersXml" url="${researchersUrl}" timeout="${gupRequestTime}" charEncoding="utf-8" useCache="true" cacheTimeout="${gupCacheTime}" useFileCacheFallback="true" fileCacheCharEncoding="utf-8"/>					

					<c:if test="${not empty researchersXml}">
						<c:choose>
							<c:when test="${showTopResearchers}">
								<gup:getGUPData id="xmlPage" xmlData="${researchersXml}"/>
								<c:set var="researchersData" value="${xmlPage.researchers}"/>
								<%--
									OBS! numberOfItemsInList gives an incorrect value in the case where showTopResearchers=true.
									Normally it doesn't matter because the value is not used but in order to future proof the 
									component the value is corrected here.
								 --%>
								<common:size id="numberOfItemsInList" list="${researchersData}" />
							</c:when>
							<c:otherwise>
								<gup:getResearchers id="researchersData" resultCount="numberOfItemsInList" xmlData="${researchersXml}" language="${pc.locale}" xPathExpression="/upl-records-researchers/upl-researchers/*" />
							</c:otherwise>
						</c:choose>
					

						<%-- Sublist to the number of researchers that should be shown to deal with GUP's has-more-items feature.
					     GUP's idea is that if you get one more item then you asked for there is more content
					     i.e. more pages to display.
					     We deal with this by looking at the total number of posts instead --%>
					    <c:choose>
							<c:when test="${not empty itemsPerPage and not empty researchersData}">
								<common:sublist id="researchersData" list="${researchersData}" count="${itemsPerPage}" />
							</c:when>
					    </c:choose>
					</c:if>
				</c:when>
				<c:when test="${empty researchersListUrl and pc.isDecorated}">
					<p class="adminMessage"><structure:componentLabel mapKeyName="NoGupUrl"/></p>
				</c:when>
			</c:choose>
		</c:when>
	</c:choose>

	<c:choose>
		<c:when test="${empty researchersData and pc.isDecorated}">
			<p class="adminError"><structure:componentLabel mapKeyName="ErrorFromGup"/></p>
		</c:when>
		<c:when test="${not empty researchersData}">
			<c:choose>
				<c:when test="${empty personData and pc.isDecorated}">
					<p class="adminMessage"><structure:componentLabel mapKeyName="NoKataGuData"/></p>
				</c:when>
				<c:when test="${not empty personData}">
					<c:catch var="guPeopleError">
						<%-- It is very very very important to use the same indexes and sortableFields with all setupIndex that uses the same cacheName --%>
						<lucene:setupIndex id="guPeople" directoryCacheName="guPersons" path="${personData}" indexes="id,departmentBottomId,departmentMiddleId,departmentTopId" sortableFields="lastName,firstName,title,phone,email" timeout="${luceneTimeout}" parser="se.gu.infoglue.lucene.GUPersonParser" />
					</c:catch>
				</c:when>
			</c:choose>
		</c:when>
	</c:choose>
	
	<c:choose>
		<c:when test="${empty idData and pc.isDecorated}">
			<p class="adminMessage"><structure:componentLabel mapKeyName="NoKataGuIdData"/></p>
		</c:when>
		<c:when test="${not empty idData}">
			<c:catch var="personIdDirectoryError">
				<lucene:setupIndex id="personIdDirectory" directoryCacheName="guPersonIds" path="${idData}" indexes="id,xname" timeout="${luceneTimeout}" parser="se.gu.infoglue.lucene.GUXNameParser" />
			</c:catch>
		</c:when>
	</c:choose>

	<%-- Do not list any researchers if we do not get data from both systems.
	     Errors for missing data has been printed before this --%>
	<c:if test="${not empty researchersData and not empty guPeople}">
		<common:size id="foo" list="${researchersData}"/>
		<c:if test="${numberOfItemsInList gt 0 and showTitle eq 'yes'}">
			<h2><c:out value="${title}" escapeXml="false"/></h2>
		</c:if>
		
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
				Object numberOfItemsInListObject = pageContext.getAttribute("numberOfItemsInList");
				Float numberOfItemsInList = 0.0f;
				if (numberOfItemsInListObject instanceof String)
				{
					String numberOfItemsInListString = (String)numberOfItemsInListObject;
					if (numberOfItemsInListString == null || "".equals(numberOfItemsInListString.trim()))
					{
						numberOfItemsInList = 0.0f;
					}
					else
					{
						numberOfItemsInList = new Float(numberOfItemsInListString);						
					}
				}
				else if (numberOfItemsInListObject instanceof Integer)
				{
					numberOfItemsInList = new Float((Integer)numberOfItemsInListObject);
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
			//out.print("!!!!! " + pageContext.getAttribute("slotName").getClass().getName());
			String slotName = (String)pageContext.getAttribute("slotName");
			String selectedTab = slotName.substring(slotName.length() - 1);
			pageContext.setAttribute("selectedTab", selectedTab);
		%>
		
		<common:size id="numPeople" list="${researchersData}" />
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
						<c:if test="${pair.key ne 'researchersPerPage' and pair.key ne 'researchersPageNumber' and pair.key ne 'selectedTab'}">
							<input type="hidden" name="<c:out value="${pair.key}"/>" value="<c:out value="${pair.value}"/>" />
						</c:if>
					</c:forEach>
					<select class="itemCountSelector" name="researchersPerPage">
						<option <c:if test="${itemsPerPage eq 10}">selected="selected"</c:if> value="10"><structure:componentLabel mapKeyName="Show"/> 10 <structure:componentLabel mapKeyName="PerPage"/></option>
						<option <c:if test="${itemsPerPage eq 25}">selected="selected"</c:if> value="25"><structure:componentLabel mapKeyName="Show"/> 25 <structure:componentLabel mapKeyName="PerPage"/></option>
						<option <c:if test="${itemsPerPage eq 50}">selected="selected"</c:if> value="50"><structure:componentLabel mapKeyName="Show"/> 50 <structure:componentLabel mapKeyName="PerPage"/></option>
						<option <c:if test="${itemsPerPage eq 100}">selected="selected"</c:if> value="100"><structure:componentLabel mapKeyName="Show"/> 100 <structure:componentLabel mapKeyName="PerPage"/></option>
						<option <c:if test="${itemsPerPage eq 500}">selected="selected"</c:if> value="500"><structure:componentLabel mapKeyName="Show"/> 500 <structure:componentLabel mapKeyName="PerPage"/></option>
						<option <c:if test="${empty itemsPerPage}">selected="selected"</c:if> value="-1"><structure:componentLabel mapKeyName="ShowAll"/></option>
					</select>
					<noscript>
						<input type="submit" value="<structure:componentLabel mapKeyName="NoScriptChangePerPageCount"/>"/>
					</noscript>
				</form>
			</div>
		</c:if> <%-- numberOfItemsInList gt 0 and empty maxNumberOfItems --%>
		
		<structure:componentLabel id="tableSummary" mapKeyName="TableSummary"/>
		<page:pageAttribute id="pageTitlePrefix" name="pageTitlePrefix" />
		
		<table<c:if test="${not empty tableSummary}"> summary="<c:out value="${tableSummary}"/> <c:out value="${pageTitlePrefix}" />"</c:if>>
			<thead>
				<tr>
					<th><structure:componentLabel mapKeyName="Name"/></th>
					<th><structure:componentLabel mapKeyName="Title"/></th>
					<th><structure:componentLabel mapKeyName="Organization"/></th>
				</tr>
			</thead>
			<tbody>
				<c:if test="${showTopResearchers}">
					<c:set var="researchersCount" value="${0}"/>
				</c:if>
				<c:forEach var="researcher" items="${researchersData}" varStatus="loop">

					<c:if test="${showTopResearchers and not empty maxNumberOfItems}">
						<%
							Long researchersCount = (Long)pageContext.getAttribute("researchersCount");
							String maxNumberOfItemsString = (String)pageContext.getAttribute("maxNumberOfItems");
							Integer maxNumberOfItems = Integer.parseInt(maxNumberOfItemsString);
							if (researchersCount >= maxNumberOfItems)
							{
								out.print("###################### BREAKING ############################");
								break;
							}
						%>
					</c:if>

					<c:choose>
						<c:when test="${showTopResearchers}">
							<c:set var="xname" value="${researcher.external_user_id}"/>
						</c:when>
						<c:otherwise>
							<c:set var="xname" value="${researcher.XName}"/>
						</c:otherwise>
					</c:choose>
					<%--
						Since we complement the list of researchers with data from KataGu we need to have a xname to search for.
						We should only get researchers that have xnames but just to be safe we filter as well.
					 --%>
					<c:if test="${not empty xname}">
						<c:choose>
							<c:when test="${not empty personIdDirectoryError and pc.isDecorated}">
								<p class="adminMessage"><structure:componentLabel mapKeyName="SetupIdIndexException"/> <c:out value="${personIdDirectoryError.message}"/></p>
							</c:when>
							<c:when test="${empty personIdDirectoryError}">
								<c:catch var="personSearchException">
									<lucene:search id="personIds" directory="${personIdDirectory}" query="xname:${xname}" />
									<c:set var="personId" value="${personIds[0].id}"/>
								</c:catch>
								<c:if test="${not empty personSearchException and pc.isDecorated}">
									<c:out value="${personSearchException.message}"/>
								</c:if>
							</c:when>
						</c:choose>
						
						<c:if test="${not empty personId}">
							<lucene:search id="people" directory="${guPeople}" query="id:${personId}" />
							<c:set var="person" value="${people[0]}" />
							
							<c:if test="${not empty person}">
								<c:if test="${showTopResearchers}">
									<c:set var="researchersCount" value="${researchersCount + 1}"/>
								</c:if>
							
								<%-- Define Person detail link --%>
								<c:choose>
									<c:when test="${person['webpage']}">
										<c:set var="personDetailPageUrl" value="${person['webpage']}" />
									</c:when>
									<c:otherwise>
										<common:urlBuilder id="personDetailPage" baseURL="${personDetailPageUrl}" includeCurrentQueryString="false" >
											<common:parameter name="userId" value="${person['id']}" />
											<%--
												This code will create a duplicate languageId in Working but it is required
												for live to work.
											--%>
											<common:parameter name="languageId" value="${pc.languageId}" />
										</common:urlBuilder>
									</c:otherwise>
								</c:choose>
								
								<%-- Define Department detail link --%>
								<common:urlBuilder id="departmentDetailPage" baseURL="${departmentDetailPageUrl}" includeCurrentQueryString="false" >
									<common:parameter name="departmentId" value="${person['departmentBottomId']}" />
									<%--
										This code will create a duplicate languageId in Working but it is required
										for live to work.
									--%>
											<common:parameter name="languageId" value="${pc.languageId}" />
								</common:urlBuilder>
								<tr>
									<td>
										<a href="<c:out value="${personDetailPage}" />" class="person">
											<c:out value="${person['lastName']}, ${person['firstName']}" />
										</a>
									</td>
									<td><c:out value="${person['title']}" /></td>
									<td>
										<a href="<c:out value="${departmentDetailPage}" />">
											<c:out value="${person['departmentBottomName']}" />
										</a>
									</td>
								</tr>
							</c:if>
						</c:if>
					</c:if>
				</c:forEach>
			</tbody>
		</table>
		
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
							<c:if test="${pair.key ne 'researchersPerPage' and pair.key ne 'researchersPageNumber' and pair.key ne 'selectedTab'}">
								<input type="hidden" name="<c:out value="${pair.key}"/>" value="<c:out value="${pair.value}"/>" />
							</c:if>
						</c:forEach>
						<select class="itemCountSelector" name="researchersPerPage">
							<option <c:if test="${itemsPerPage eq 10}">selected="selected"</c:if> value="10"><structure:componentLabel mapKeyName="Show"/> 10 <structure:componentLabel mapKeyName="PerPage"/></option>
						<option <c:if test="${itemsPerPage eq 25}">selected="selected"</c:if> value="25"><structure:componentLabel mapKeyName="Show"/> 25 <structure:componentLabel mapKeyName="PerPage"/></option>
						<option <c:if test="${itemsPerPage eq 50}">selected="selected"</c:if> value="50"><structure:componentLabel mapKeyName="Show"/> 50 <structure:componentLabel mapKeyName="PerPage"/></option>
						<option <c:if test="${itemsPerPage eq 100}">selected="selected"</c:if> value="100"><structure:componentLabel mapKeyName="Show"/> 100 <structure:componentLabel mapKeyName="PerPage"/></option>
						<option <c:if test="${itemsPerPage eq 500}">selected="selected"</c:if> value="500"><structure:componentLabel mapKeyName="Show"/> 500 <structure:componentLabel mapKeyName="PerPage"/></option>									
						<option <c:if test="${empty itemsPerPage}">selected="selected"</c:if> value="-1"><structure:componentLabel mapKeyName="ShowAll"/></option>
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
						<common:urlBuilder id="firstPageUrl" excludedQueryStringParameters="researchersPageNumber,selectedTab" >
							<common:parameter name="researchersPageNumber" value="1" />
							<common:parameter name="selectedTab" value="${selectedTab}" />
						</common:urlBuilder>
						<common:urlBuilder id="previousPageUrl" excludedQueryStringParameters="researchersPageNumber,selectedTab">
							<common:parameter name="researchersPageNumber" value="${currentPage - 1}" />
							<common:parameter name="selectedTab" value="${selectedTab}" />
						</common:urlBuilder>

						<li><a href="<c:out value="${previousPageUrl}"/>"><structure:componentLabel mapKeyName="PagingPrevious"/></a></li>
						
						<c:if test="${startIndex > 1}">
							<li><a href="<c:out value="${firstPageUrl}"/>">1</a></li>
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
								<common:urlBuilder id="pageUrl" excludedQueryStringParameters="researchersPageNumber,selectedTab">
									<common:parameter name="researchersPageNumber" value="${page}" />
									<common:parameter name="selectedTab" value="${selectedTab}" />
								</common:urlBuilder>
								<c:choose>
									<c:when test="${currentPage eq page}">
										<li class="current"><c:out value="${page}"/></li>
									</c:when>
									<c:otherwise>
										<li><a href="<c:out value="${pageUrl}" />" class="number"><c:out value="${page}"/></a></li>
									</c:otherwise>
								</c:choose>
							<%
						}
					%>
					
					<c:if test="${currentPage < numberOfPages}">
						<common:urlBuilder id="nextPageUrl" excludedQueryStringParameters="researchersPageNumber,selectedTab">
							<common:parameter name="researchersPageNumber" value="${currentPage + 1}" />
							<common:parameter name="selectedTab" value="${selectedTab}" />
						</common:urlBuilder>
						<common:urlBuilder id="lastPageUrl" excludedQueryStringParameters="researchersPageNumber,selectedTab">
							<common:parameter name="researchersPageNumber" value="${numberOfPages}" />
							<common:parameter name="selectedTab" value="${selectedTab}" />
						</common:urlBuilder>
					
						<c:if test="${endIndex < numberOfPages}">
							<c:if test="${currentPage ne numberOfPages - halfPagingPages}">
								<li>&#8230;</li>
							</c:if>
							<li><a href="<c:out value="${lastPageUrl}"/>"><c:out value="${numberOfPages}"/></a></li>
						</c:if>
						<li><a href="<c:out value="${nextPageUrl}"/>"><structure:componentLabel mapKeyName="PagingNext"/></a></li>
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
	</c:if> <%-- END: not empty researchersData and not empty guPeople --%>
</div>
<!--/eri-no-index-->
