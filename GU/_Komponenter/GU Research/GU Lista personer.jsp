<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-lucene" prefix="lucene" %>

<page:pageContext id="pc" />

<structure:pageUrl id="personDetailPageUrl" propertyName="GUR_PersonDetailPage" useInheritance="true" />
<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="departmentId" propertyName="DepartmentId" useInheritance="false"/>
<structure:componentPropertyValue id="itemsPerPage" propertyName="ItemsPerPage" useInheritance="false"/>
<structure:componentPropertyValue id="data" propertyName="GUR_PersonDataPath" useInheritance="true"/>
<structure:componentPropertyValue id="timeout" propertyName="GUR_LuceneCacheTimeout" useInheritance="true"/>
<structure:componentPropertyValue id="showTitle" propertyName="ShowTitle" useInheritance="true"/>
<structure:componentPropertyValue id="pagingPages" propertyName="PagingPages" useInheritance="true"/>
<structure:componentPropertyValue id="maxNumberOfItems" propertyName="MaxNumberOfItems" useInheritance="false"/>
<structure:componentPropertyValue id="includePeopleFromChildDepartments" propertyName="IncludePeopleFromChildDepartments" useInheritance="false"/>

<%-- Variable setup --%>

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

			if (pageType.equals("enhetsdetalj"))
			{	
				String departmentId = pageFunction.substring(pageFunction.indexOf("-") + 1);
				pageContext.setAttribute("departmentId", departmentId);
			}
		}
	%>
</c:if>

<c:if test="${empty pagingPages}">
	<c:set var="pagingPages" value="9" />
</c:if>

<c:if test="${empty title}">
	<structure:componentLabel id="title" mapKeyName="DefaultTitle"/>
</c:if>

<c:set var="currentPage" value="${param.pageNumber}" />
<c:if test="${empty currentPage}">
	<c:set var="currentPage" value="1" />
</c:if>

<c:if test="${empty itemsPerPage}">
	<c:set var="itemsPerPage" value="50" />
</c:if>

<c:if test="${not empty param.itemsPerPage}">
	<c:set var="itemsPerPage" value="${param.itemsPerPage}" />
</c:if>

<%-- 
If itemsPerPage is less than 1 it either means that someone has tampered with
the param or that the user selected 'show all' which is represented by the 
value -1 
--%>
     
<c:if test="${itemsPerPage lt 1}">
	<c:remove var="itemsPerPage" />
</c:if>

<c:choose>
	<c:when test="${empty param.sortBy}">
		<c:set var="sortBy" value="lastName,firstName" />
	</c:when>
	<c:otherwise>
		<c:set var="sortBy" value="${param.sortBy}" />
	</c:otherwise>
</c:choose>

<%-- HTML-component start --%>

<!--eri-no-index-->

<div class="guResearchComp personList">

	<c:choose>
		<c:when test="${not empty data}">
			<lucene:setupIndex id="guPeople" directoryCacheName="guPersons" path="${data}" indexes="id,departmentBottomId,departmentMiddleId,departmentTopId" sortableFields="lastName,firstName,title,phone,email" timeout="${timeout}" parser="se.gu.infoglue.lucene.GUPersonParser" />
		</c:when>
		<c:when test="${empty data and pc.isDecorated}">
			<p><structure:componentLabel mapKeyName="NoKataGuData"/></p>
		</c:when>
	</c:choose>

	<c:if test="${not empty data}">
		<c:if test="${empty departmentId and pc.isDecorated}">
			<p class="adminError"><structure:componentLabel mapKeyName="NoOrganizationId"/></p>
		</c:if>
	
		<c:if test="${not empty departmentId}">
			<c:set var="startIndex" value="${(currentPage - 1) * itemsPerPage}" />
			
		    <c:choose>
				<c:when test="${not empty maxNumberOfItems}">
					<c:set var="npost" value="${maxNumberOfItems}"/>
				</c:when>
				<c:when test="${not empty itemsPerPage}">
					<c:set var="npost" value="${itemsPerPage}"/>
				</c:when>
		    </c:choose>
		    
		    <%-- departmentBottomId:${departmentId} --%>
		    <%-- departmentBottomId:${departmentId} or departmentMiddleId:${departmentId} or departmentTopId:${departmentId} --%>
		    		    
		    <c:choose>
		    	<c:when test="${includePeopleFromChildDepartments eq 'yes'}">
		    		<c:set var="luceneQuery" value="departmentBottomId:${departmentId} or departmentMiddleId:${departmentId} or departmentTopId:${departmentId}" />
		    	</c:when>
		    	<c:otherwise>
		    		<c:set var="luceneQuery" value="departmentBottomId:${departmentId}" />
		    	</c:otherwise>
		    </c:choose>
		    
		    <c:choose>
				<c:when test="${empty npost}">
					<lucene:search id="people" directory="${guPeople}" resultCount="numberOfItemsInList"
					 sortFields="${sortBy}" sortAscending="true" startIndex="${startIndex}"
					 query="${luceneQuery}" />
				</c:when>
				<c:otherwise>
					<lucene:search id="people" directory="${guPeople}" resultCount="numberOfItemsInList"
					 sortFields="${sortBy}" sortAscending="true" startIndex="${startIndex}" count="${npost}"
					 query="${luceneQuery}" />
				</c:otherwise>
		    </c:choose>
		
			<c:choose>
				<c:when test="${empty people and pc.isDecorated}">
					<p class="adminMessage"><structure:componentLabel mapKeyName="NoPeopleFound"/> (<c:out value="${departmentId}"/>)</p>
				</c:when>
				<c:when test="${not empty people}">
					<c:if test="${showTitle eq 'yes'}">
						<h2><c:out value="${title}" escapeXml="false"/></h2>
					</c:if>
					<common:size id="numPeople" list="${people}" />
	
					<%
						int pagingPages 	        = new Integer((String)pageContext.getAttribute("pagingPages"));
						int currentPage 	        = new Integer((String)pageContext.getAttribute("currentPage"));
						
						String numberOfItemsInListString = (String)pageContext.getAttribute("numberOfItemsInList");
						int numberOfItemsInList;
						if (numberOfItemsInListString == null || "".equals(numberOfItemsInListString.trim()))
						{
							numberOfItemsInList = 0;
						}
						else
						{
							numberOfItemsInList = new Integer(numberOfItemsInListString);						
						}
						
						String itemsPerPageString = (String)pageContext.getAttribute("itemsPerPage");
						int startIndex, endIndex, numberOfPages;
						// If itemsPerPageString is not set we should list all items on one page
						if (itemsPerPageString == null || "".equals(itemsPerPageString.trim()))
						{
							numberOfPages = 1;
							startIndex = 1;
							endIndex   = numberOfItemsInList;
						}
						else
						{
							Float itemsPerPage = new Float(itemsPerPageString);
							
							numberOfPages			= new Double(Math.ceil(numberOfItemsInList / itemsPerPage)).intValue();
							startIndex = Math.max(1, Math.min(numberOfPages - pagingPages, currentPage - Math.round(pagingPages / 2.0f)) + 1);
							endIndex   = Math.min(numberOfPages, startIndex + pagingPages - 1);
						}
	
						pageContext.setAttribute("startIndex", startIndex);
						pageContext.setAttribute("endIndex", endIndex);
						pageContext.setAttribute("numberOfPages", new Integer(numberOfPages));
						pageContext.setAttribute("halfPagingPages", new Integer(Math.round(pagingPages / 2.0f)));
					%>
					
					<%-- If we are on the last page use the number of items as the end of the interval value.
					 	 If we do not, that value may be higher than the actual total amount --%>
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
					
					<%-- This if-statement and its content is duplicated further down. --%>
					<c:if test="${numberOfItemsInList gt 0 and empty maxNumberOfItems}">
	
						<div class="listInfo"><p><structure:componentLabel mapKeyName="Showing"/> <c:out value="${((currentPage - 1) * itemsPerPage) + 1}" /> - <c:out value="${maxItems}" /> <structure:componentLabel mapKeyName="Of"/> <c:out value="${numberOfItemsInList}" /></p>
							<common:urlBuilder id="changeItemCountUrl" includeCurrentQueryString="false" />
							<form class="itemCountPicker" method="get" action="<c:out value="${changeItemCountUrl}"/>">
								<input type="hidden" name="selectedTab" value="<c:out value="${selectedTab}"/>" />
								<c:forEach var="pair" items="${param}">
									<c:if test="${pair.key ne 'itemsPerPage' and pair.key ne 'pageNumber'}">
										<input type="hidden" name="<c:out value="${pair.key}"/>" value="<c:out value="${pair.value}"/>" />
									</c:if>
								</c:forEach>
								<select class="itemCountSelector" name="itemsPerPage">
									<option <c:if test="${itemsPerPage eq 10}">selected="selected"</c:if>><structure:componentLabel mapKeyName="Show"/> 10 <structure:componentLabel mapKeyName="PerPage"/></option>
									<option <c:if test="${itemsPerPage eq 25}">selected="selected"</c:if>><structure:componentLabel mapKeyName="Show"/> 25 <structure:componentLabel mapKeyName="PerPage"/></option>
									<option <c:if test="${itemsPerPage eq 50}">selected="selected"</c:if>><structure:componentLabel mapKeyName="Show"/> 50 <structure:componentLabel mapKeyName="PerPage"/></option>
									<option <c:if test="${itemsPerPage eq 100}">selected="selected"</c:if>> <structure:componentLabel mapKeyName="Show"/>100 <structure:componentLabel mapKeyName="PerPage"/></option>
									<option <c:if test="${itemsPerPage eq 500}">selected="selected"</c:if>> <structure:componentLabel mapKeyName="Show"/>500 <structure:componentLabel mapKeyName="PerPage"/></option>
									<option <c:if test="${empty itemsPerPage}">selected="selected"</c:if> value="-1"><structure:componentLabel mapKeyName="ShowAll"/></option>
								</select>
								<noscript>
									<input type="submit" value="<structure:componentLabel mapKeyName="NoScriptChangePerPageCount"/>"/>
								</noscript>
							</form>
							
							
						</div>
					</c:if>
					
					<structure:componentLabel id="tableSummary" mapKeyName="TableSummary"/>
					<page:pageAttribute id="pageTitlePrefix" name="pageTitlePrefix" />
					
					<table<c:if test="${not empty tableSummary}"> summary="<c:out value="${tableSummary}"/> <c:out value="${pageTitlePrefix}" />"</c:if>>
						<structure:componentLabel id="tableCaption" mapKeyName="TableCaption"/>
						<thead>
							<tr>
								<common:urlBuilder id="sortByNameUrl" includeCurrentQueryString="true" excludedQueryStringParameters="sortBy,selectedTab">
									<common:parameter name="sortBy" value="lastName,firstName" />
									<common:parameter name="selectedTab" value="${selectedTab}" />
								</common:urlBuilder>
								<common:urlBuilder id="sortByTitleUrl" includeCurrentQueryString="true" excludedQueryStringParameters="sortBy,selectedTab">
									<common:parameter name="sortBy" value="title,lastName,firstName" />
									<common:parameter name="selectedTab" value="${selectedTab}" />
								</common:urlBuilder>
								<common:urlBuilder id="sortByPhoneUrl" includeCurrentQueryString="true" excludedQueryStringParameters="sortBy,selectedTab">
									<common:parameter name="sortBy" value="phone" />
									<common:parameter name="selectedTab" value="${selectedTab}" />
								</common:urlBuilder>
								<common:urlBuilder id="sortByEmailUrl" includeCurrentQueryString="true" excludedQueryStringParameters="sortBy,selectedTab">
									<common:parameter name="sortBy" value="email" />
									<common:parameter name="selectedTab" value="${selectedTab}" />
								</common:urlBuilder>
								<th scope="col"><a href="<c:out value="${sortByNameUrl}" />" <c:if test="${sortBy eq 'lastName,firstName'}">class="sortBySelected"</c:if>><structure:componentLabel mapKeyName="Name"/></a></th>
								<th scope="col"><a href="<c:out value="${sortByTitleUrl}" />" <c:if test="${sortBy eq 'title,lastName,firstName'}">class="sortBySelected"</c:if>><structure:componentLabel mapKeyName="Title"/></a></th>
								<th scope="col"><a href="<c:out value="${sortByPhoneUrl}" />" <c:if test="${sortBy eq 'phone'}">class="sortBySelected"</c:if>><structure:componentLabel mapKeyName="Phone"/></a></th>
								<th scope="col"><a href="<c:out value="${sortByEmailUrl}" />" <c:if test="${sortBy eq 'email'}">class="sortBySelected"</c:if>><structure:componentLabel mapKeyName="Email"/></a></th>
							</tr>
						</thead>
						<tbody>
						<c:forEach var="person" items="${people}" varStatus="loop">
							<c:choose>
								<c:when test="${not empty person['webpage']}">
									<c:set var="detailPageUrl" value="${person['webpage']}" />
									
									<%
									String detailPageUrl = (String)pageContext.getAttribute("detailPageUrl");
									if (detailPageUrl != null && !detailPageUrl.startsWith("http://"))
									{
										detailPageUrl = "http://" + detailPageUrl;
									}
									pageContext.setAttribute("detailPageUrl", detailPageUrl);
									%>
								</c:when>
								<c:otherwise>
									<common:urlBuilder id="detailPageUrl" baseURL="${personDetailPageUrl}" includeCurrentQueryString="false" >
										<common:parameter name="userId" value="${person['id']}" />
										<common:parameter name="departmentId" value="${person['departmentBottomId']}" />
										<%--
											This code will create a duplicate languageId in Working but it is required
											for live to work.
										--%>
										<common:parameter name="languageId" value="${pc.languageId}" />
									</common:urlBuilder>
								</c:otherwise>
							</c:choose>
							<tr>
								<td>
									<a href="<c:out value="${detailPageUrl}" />" class="person">
										<c:out value="${person['lastName']}, ${person['firstName']}" />
									</a>
								</td>
								<td><c:out value="${person['title']}" /></td>
								<td class="guResearchPhone"><c:out value="${person['phone']}" /></td>
								<td><a href="mailto:<c:out value="${person['email']}" />"><c:out value="${person['email']}" /></a></td>
							</tr>
						</c:forEach>
						</tbody>
					</table>
					
					<%-- If maxNumberOfItems is set paging should be disabled, i.e. not shown --%>
					<c:if test="${empty maxNumberOfItems}">
						<%-- This if-statement and its content is duplicated further up. --%>
						<c:if test="${numberOfItemsInList gt 0}">
	
							<div class="listInfo"><p><structure:componentLabel mapKeyName="Showing"/> <c:out value="${((currentPage - 1) * itemsPerPage) + 1}" /> - <c:out value="${maxItems}" /> <structure:componentLabel mapKeyName="Of"/> <c:out value="${numberOfItemsInList}" /></p>
								<common:urlBuilder id="changeItemCountUrl" includeCurrentQueryString="false" />
								<form class="itemCountPicker" method="get" action="<c:out value="${changeItemCountUrl}"/>">
									<input type="hidden" name="selectedTab" value="<c:out value="${selectedTab}"/>" />
									<c:forEach var="pair" items="${param}">
										<c:if test="${pair.key ne 'itemsPerPage' and pair.key ne 'pageNumber'}">
											<input type="hidden" name="<c:out value="${pair.key}"/>" value="<c:out value="${pair.value}"/>" />
										</c:if>
									</c:forEach>
									<select class="itemCountSelector" name="itemsPerPage">
										<option <c:if test="${itemsPerPage eq 10}">selected="selected"</c:if>><structure:componentLabel mapKeyName="Show"/> 10 <structure:componentLabel mapKeyName="PerPage"/></option>
										<option <c:if test="${itemsPerPage eq 25}">selected="selected"</c:if>><structure:componentLabel mapKeyName="Show"/> 25 <structure:componentLabel mapKeyName="PerPage"/></option>
										<option <c:if test="${itemsPerPage eq 50}">selected="selected"</c:if>><structure:componentLabel mapKeyName="Show"/> 50 <structure:componentLabel mapKeyName="PerPage"/></option>
										<option <c:if test="${itemsPerPage eq 100}">selected="selected"</c:if>> <structure:componentLabel mapKeyName="Show"/>100 <structure:componentLabel mapKeyName="PerPage"/></option>
										<option <c:if test="${itemsPerPage eq 500}">selected="selected"</c:if>> <structure:componentLabel mapKeyName="Show"/>500 <structure:componentLabel mapKeyName="PerPage"/></option>
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
									<common:urlBuilder id="firstPageUrl" excludedQueryStringParameters="pageNumber,selectedTab" >
										<common:parameter name="pageNumber" value="1" />
										<common:parameter name="selectedTab" value="${selectedTab}" />
									</common:urlBuilder>
									<common:urlBuilder id="previousPageUrl" excludedQueryStringParameters="pageNumber,selectedTab">
										<common:parameter name="pageNumber" value="${currentPage - 1}" />
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
											<common:urlBuilder id="pageUrl" excludedQueryStringParameters="pageNumber,selectedTab">
												<common:parameter name="pageNumber" value="${page}" />
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
									<common:urlBuilder id="nextPageUrl" excludedQueryStringParameters="pageNumber,selectedTab">
										<common:parameter name="pageNumber" value="${currentPage + 1}" />
										<common:parameter name="selectedTab" value="${selectedTab}" />
									</common:urlBuilder>
									<common:urlBuilder id="lastPageUrl" excludedQueryStringParameters="pageNumber,selectedTab">
										<common:parameter name="pageNumber" value="${numberOfPages}" />
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
						<script type="text/javascript">
						<!-- 
						jQuery(".itemCountSelector").change(function() {
							$(this).parents("form").get(0).submit();
							});
						-->
						</script>
					</c:if> <%-- empty maxNumberOfItems --%>
				</c:when> <%-- not empty people --%>
			</c:choose>
		</c:if> <%-- not empty departmentId --%>
	</c:if> <%-- not empty data --%>
</div>

<!--/eri-no-index-->