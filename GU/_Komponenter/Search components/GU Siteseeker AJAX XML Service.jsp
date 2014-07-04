<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="common" uri="infoglue-common" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib prefix="structure" uri="infoglue-structure" %>
<%@ taglib prefix="page" uri="infoglue-page" %>
<%@ taglib prefix="guweb" uri="guweb" %>

<%@page import="se.gu.siteseeker.Lang"%>
<%@page import="se.gu.siteseeker.DateRange"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController"%>
<%@page import="se.gu.siteseeker.DocType"%>
<%@page import="se.gu.siteseeker.HitCategory"%>

<%@page import="java.util.Hashtable"%>
<%@page import="java.util.TreeMap"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="se.gu.siteseeker.Category"%>

<page:deliveryContext id="dc" trimResponse="true"/>
<page:pageContext id="pc"/>

<% 
// Get categoryAllWeb Id to identify when to show bets
org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController controller = (org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");

String categoryAllWeb = controller.getRepositoryExtraProperty("categoryAllWeb");
if( categoryAllWeb == null || categoryAllWeb.equals("") )
	categoryAllWeb = "126";
	
pageContext.setAttribute("categoryAllWeb", categoryAllWeb);
%>
<management:language id="curLang" languageId="${pc.languageId}"/>
<c:set var="langCode" value="${curLang.languageCode}" scope="page"/>

						
<content:assetUrl id="documentHtm" propertyName="Mallbilder" assetKey="search_icon_html"/>
<content:assetUrl id="documentPdf" propertyName="Mallbilder" assetKey="search_icon_pdf"/>
<content:assetUrl id="documentDoc" propertyName="Mallbilder" assetKey="search_icon_doc"/>
<content:assetUrl id="documentXls" propertyName="Mallbilder" assetKey="search_icon_xls"/>
<content:assetUrl id="documentPpt" propertyName="Mallbilder" assetKey="search_icon_ppt"/>
<content:assetUrl id="documentTxt" propertyName="Mallbilder" assetKey="search_icon_txt"/>
<content:assetUrl id="documentUnknown" propertyName="Mallbilder" assetKey="search_icon_unknown"/>

<jsp:useBean id="sampleSiteSeekerPortTypeProxyid" scope="session" class="se.gu.siteseeker.SiteSeekerPortTypeProxy" />
<jsp:useBean id="siteseekerWebSearchRequest3" scope="page" class="se.gu.siteseeker.DoSearchRequest3" />
<jsp:useBean id="siteseekerLangFilterNum" scope="session" class="se.gu.siteseeker.FilterNum" />
<jsp:useBean id="siteseekerDocTypeFilterNum" scope="page" class="se.gu.siteseeker.FilterNum" />
<jsp:useBean id="siteseekerGetParamRequest" scope="page" class="se.gu.siteseeker.GetParamRequest" />

<structure:componentPropertyValue id="searchCat" propertyName="SearchCategory" useInheritance="false"/>

<c:set var="numerOfResultsPerPage" value="5"/>
<c:if test="${not empty param.hn}">
	<c:set var="numerOfResultsPerPage" value="${param.hn}"/>
</c:if>

<c:set var="noCharactersInURL" value="100"/>
<c:if test="${not empty param.noCharactersInURL}">
	<c:set var="noCharactersInURL" value="${param.noCharactersInURL}"/>
</c:if>

<%
int[] searchedCategoriesInt;

try 
{
	String langCodeJ = (String)pageContext.getAttribute("langCode");
	
	java.util.Calendar calendar = java.util.Calendar.getInstance();
	calendar.add(java.util.Calendar.YEAR, -5);
	
	siteseekerGetParamRequest.setGetDoctypes(true);
	siteseekerGetParamRequest.setGetCategories(true);
	siteseekerGetParamRequest.setGetBestBets(true);
	siteseekerGetParamRequest.setGetLanguages(true);
	siteseekerGetParamRequest.setVersion(4);
	siteseekerGetParamRequest.setLastQuery(calendar);
	siteseekerGetParamRequest.setIlang(langCodeJ);
	
	int numerOfResultsPerPage = 0, noCharactersInURL = 0;
	String temp = "";
	
	try {
		temp = (String)pageContext.getAttribute("noCharactersInURL");
		noCharactersInURL = Integer.parseInt(temp);
	} catch(Exception e) {
		out.print("V¿rdet \"" + temp + "\" ¿r ej till¿tet f¿r \"noCharactersInURL\"");
	}
	
	try
	{
		temp = (String)pageContext.getAttribute("numerOfResultsPerPage");
		numerOfResultsPerPage = Integer.parseInt(temp);
	}
	catch (Exception e)
	{
		out.print("V¿rdet \"" + temp + "\" ¿r ej till¿tet f¿r \"NoOfHits\"");
	}

	BasicTemplateController btc = (BasicTemplateController) pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
	String siteSeekerUrl 		= btc.getRepositoryExtraProperty("siteSeekerUrl");
	//String siteSeekerUrl 		= "http://dev.cms.it.gu.se/infoglueDeliverWorking/ViewPage.action?siteNodeId=108410&contentId=-1";
	//out.print("siteSeekerUrl:" + siteSeekerUrl);
	
	se.gu.siteseeker.ParamResponse paramResponse = null;

	if (siteSeekerUrl == null || siteSeekerUrl.trim().equals(""))
	{
		out.println("Parametern \"siteSeekerUrl\" under \"Extra properties \" &auml;r ej satt f&ouml;r detta repository. Kontakta den systemansvarige f&ouml;r &aring;tg&auml;rd.<br/>");
	}
	else
	{
		sampleSiteSeekerPortTypeProxyid.setSiteSeekerUrl(siteSeekerUrl);
		sampleSiteSeekerPortTypeProxyid.setTimeout(20000);
		sampleSiteSeekerPortTypeProxyid._initSiteSeekerPortTypeProxy();
	
		paramResponse = sampleSiteSeekerPortTypeProxyid.getParam(siteseekerGetParamRequest);

		//Text query
		String aQuery="*";
		if(request.getParameter("searchText") != null && !(request.getParameter("searchText").equals(""))) 
		{
			aQuery = request.getParameter("searchText");	
		}
		
		if( !("personnel".equals( request.getParameter("divId"))) ) 
		{
			aQuery += " hidden:!url:http://mix-vas-1.it.gu.se/*";
		}
		
		/*-----------------------------------------------------------------------------
		 Special case for when the user has searched for document type = Document,
		 i.e. everything except html pages. This must be handled by providing a hidden
		 search param (hidden:!filetype:html) in the query field. 			 
		 ----------------------------------------------------------------------------*/
		 
		if (request.getParameter("searchDocumentType") != null && request.getParameter("searchDocumentType").equals("999"))
		{
			aQuery += " hidden:!filetype:html";
		}
		
		if (request.getParameter("limitToUrl") != null && !request.getParameter("limitToUrl").equals("false") && !request.getParameter("limitToUrl").equals(""))
		{
			aQuery += " url:" + request.getParameter("limitToUrl") + "*";
		}
		siteseekerWebSearchRequest3.setQuery(aQuery);
		
		//Document Type
		if(request.getParameter("searchDocumentType")!= null && !request.getParameter("searchDocumentType").equals("0")  && !(request.getParameter("searchDocumentType").equals("999")))
		{		
			siteseekerDocTypeFilterNum.setV(Integer.parseInt(request.getParameter("searchDocumentType")));	
		}
		else
		{
			siteseekerDocTypeFilterNum = null;	
		}
		siteseekerWebSearchRequest3.setFormat(siteseekerDocTypeFilterNum);
		
		//Categories
		if( request.getParameterValues("searchCategory") == null ) 
		{
			searchedCategoriesInt = null;
		}
		else  // if(request.getParameterValues("searchCategory") != null )
		{
			String[] theCatStr = request.getParameterValues("searchCategory");
			searchedCategoriesInt  = new int[theCatStr.length];
			for(int i=0; i < theCatStr.length; i++)
			{
				searchedCategoriesInt[i] = Integer.parseInt(theCatStr[i]);
			}
			siteseekerWebSearchRequest3.setCategory(searchedCategoriesInt);
		}
		
		//DateRange, first check to see if we should search a specific interval, this is hardcoded from "GU Generella Ledtexter" at the moment.
		//Later this could be changed into siteseeker.Ages
		// 0 = All documents, 1=last week, 2=last month, 3=last year

		if(request.getParameter("da") != null && Integer.parseInt(request.getParameter("da")) > 0)
		{
			java.util.Calendar startCal = java.util.Calendar.getInstance();
			java.util.Calendar endCal = java.util.Calendar.getInstance();
			DateRange aDR = new DateRange();
			aDR.setE(endCal);
			switch(Integer.parseInt(request.getParameter("da")))
			{
				case 1: startCal.add(java.util.Calendar.DAY_OF_YEAR, -7);
				break;
				case 2: startCal.add(java.util.Calendar.MONTH, -1);
				break;
				case 3: startCal.add(java.util.Calendar.YEAR, -1);
				break;
			}
			aDR.setS(startCal);
			siteseekerWebSearchRequest3.setDate(aDR);
		}
		
		//Batch
		
		if(request.getParameter("batch") != null && !request.getParameter("batch").trim().equals(""))
		{
			siteseekerWebSearchRequest3.setBatchNumber(Integer.parseInt(request.getParameter("batch")));
		}
		else 
		{
			siteseekerWebSearchRequest3.setBatchNumber(1);
		}
		
		//Language of pages
		
		if(langCodeJ.equals("en"))
		{
			//siteseekerLangFilterNum.setV(5); // Svenska = 5
			siteseekerLangFilterNum.setV(2); // Engelska = 2
			siteseekerWebSearchRequest3.setLanguage(siteseekerLangFilterNum);
		}
		// Om inte engleskspr¿kig request, men request efter personal filtrera d¿ p¿ svenska
		else if( "personnel".equals( request.getParameter("divId") ) ) {
			siteseekerLangFilterNum.setV(5); // Svenska = 5
			siteseekerWebSearchRequest3.setLanguage(siteseekerLangFilterNum);
		}
		
		siteseekerWebSearchRequest3.setIlang(langCodeJ);
		siteseekerWebSearchRequest3.setNHits(numerOfResultsPerPage);
		
		int sortOrder = 1;
		
		if (request.getParameter("sortOrder") != null && ((String)request.getParameter("sortOrder")).trim() != "")
		{
			if (request.getParameter("sortOrder").equals("relevance"))
			{
				sortOrder = 1;
			}
			else if (request.getParameter("sortOrder").equals("date"))
			{
				sortOrder = 2;
			}
		}
				
		siteseekerWebSearchRequest3.setSortOrder(sortOrder); // 4=Sort by Title 2= by modification date
		siteseekerWebSearchRequest3.setVersion(4); // MUST BE 4 !!!!!
		siteseekerWebSearchRequest3.setUserTokens("");
		siteseekerWebSearchRequest3.setUserIdentifier("11111111111111111111111111111111");
	    
	    se.gu.siteseeker.SearchResponse siteseekerDoSearch = sampleSiteSeekerPortTypeProxyid.doSearch(siteseekerWebSearchRequest3);
	%>

	<%-- 
	Find the Document types and Categories and add them to a hashtable
	2007-11-07 : Find the document types, add them to a hashtable, add icons to a hastable.
	--%>
	<% 
		Hashtable theLangHash 			= new Hashtable();
		Hashtable theCategoryHash 		= new Hashtable();
		Hashtable theDocTypeHash 		= new Hashtable();
		Hashtable iconHash 				= new Hashtable();
		Hashtable titleHash 			= new Hashtable();
		Integer searchCategoryInteger	= 0;
		String categoryName				= "";
		
		paramResponse = sampleSiteSeekerPortTypeProxyid.getParam(siteseekerGetParamRequest);
		
		if(paramResponse != null)
		{
			DocType[] docTypes = paramResponse.getDocs();
			 
		    for(int i=0; i < docTypes.length; i++)
		    {	        	
		    	theDocTypeHash.put(docTypes[i].getId(), docTypes[i].getKey());   
		    }
			
			iconHash.put("html", (String)pageContext.getAttribute("documentHtm"));
			iconHash.put("htm", (String)pageContext.getAttribute("documentHtm"));
			iconHash.put("pdf", (String)pageContext.getAttribute("documentPdf"));
			iconHash.put("doc", (String)pageContext.getAttribute("documentDoc"));
			iconHash.put("xls", (String)pageContext.getAttribute("documentXls"));
			iconHash.put("ppt", (String)pageContext.getAttribute("documentPpt"));
		    iconHash.put("text", (String)pageContext.getAttribute("documentTxt"));
			iconHash.put("unknown", (String)pageContext.getAttribute("documentUnknown"));
		    
			titleHash.put("html", "alt=\"html\" title=\"webbsida\"" );
			titleHash.put("htm","alt=\"html\" title=\"webbsida\"" );
			titleHash.put("pdf", "alt=\"pdf\" title=\"pdf\"" );
			titleHash.put("doc", "alt=\"word\" title=\"word\"" );
			titleHash.put("xls", "alt=\"excel\" title=\"excel\"");
			titleHash.put("ppt", "alt=\"powerpoint\" title=\"powerpoint\"");
			titleHash.put("unknown", "unknown");
		    
			Lang[] langTypes = paramResponse.getLangs();
			for(int i=0; i < langTypes.length; i++)
			{	        	
				theLangHash.put(langTypes[i].getId(), langTypes[i].getDescription());   
			}
			
			Category[] cats = paramResponse.getCats();
			
			for(int i=0; i < cats.length; i++)
			{	        	
				theCategoryHash.put(cats[i].getId(), cats[i].getName());   
			}
			
			searchCategoryInteger = new Integer(request.getParameter("searchCategory"));
			
			categoryName = (String)theCategoryHash.get(searchCategoryInteger);
			pageContext.setAttribute("categoryName", categoryName);
		}
		%>
		<%-- 
		END of Find Document Types
		--%>
	
		<c:set var="thisBatch">1</c:set>
			
		<c:if test="${param.batch ne null}">
			<c:set var="thisBatch" value="${param.batch}"/>
		</c:if>
		
		<c:choose>
		<c:when test="${param.noAjax eq 'true'}">
			<c:if test="${not empty param.cssUrl}">
				<link href="<c:out value="${param.cssUrl}" escapeXml="true"/>" rel="stylesheet" type="text/css" media="screen, print"/>
			</c:if>
			<style type="text/css">
			<%--
				*
				{
					background: none;
					background-color: white;
				}
			--%>
			</style>
			<div id="pageContainer">
			<div id="bodyArea" style="background: none;">
			<div id="searchResultComp">			
			<h1>
				<c:choose>
					<c:when test="${param.categoryName ne null and param.categoryName ne 'undefined'}">
						<c:out value="${param.categoryName}" escapeXml="false"/>
						<c:set var="categoryName" value="${param.categoryName}"/>
					</c:when>
					<c:otherwise>
						<c:out value="${categoryName}" escapeXml="false"/>							
					</c:otherwise>
				</c:choose>
			</h1>
			
			</div></div></div>
		</c:when>
		<c:otherwise>
		
		
		<%
		
		// According to document getMatchingCats is still in beta
		HitCategory[] cats = siteseekerDoSearch.getCats();
		int[] catsInt = new int[cats.length];
		TreeMap categoryIdMap = new TreeMap();
		
		// Category[] matchingCats = paramResponse.getMatchingCats();
		
		for(int i=0; i < cats.length; i++)
		{	
			catsInt[i] = cats[i].getId();     	
			// out.println("id: "+cats[i].getId()+", "+cats[i].getName()+"<br/>");   
			categoryIdMap.put( new Integer(cats[i].getId()), cats[i] );
		}
		%>
		<%--  Searched categories --%>
		<%
		ArrayList categoryIntersection = null;
		if( searchedCategoriesInt != null ) {
			Arrays.sort(catsInt);
			Arrays.sort(searchedCategoriesInt);
			
			categoryIntersection = new ArrayList( );
			int aindex = 0;  
			int bindex = 0;  
			int i = 0;
			while (aindex < searchedCategoriesInt.length && bindex < catsInt.length) {  
				if (searchedCategoriesInt[aindex] == catsInt[bindex]) {  
			    	categoryIntersection.add(i, categoryIdMap.get( new Integer(searchedCategoriesInt[aindex]) ));
			    	aindex++;  
					bindex++;  
				}  
			   	else if (searchedCategoriesInt[aindex] < catsInt[bindex]) {  
			   		aindex++;  
			   	}  
			   	else {  
			    	bindex++;  
			   	}  
			}
		
			pageContext.setAttribute("categoryIntersection", categoryIntersection);
		}
		
		
		%>
		
		<categories>
		<c:if test="${categoryIntersection != null}">
			<c:forEach items="${categoryIntersection}" var="category">
				<category>
					<id><c:out value="${category.id}"/></id>
					<name><c:out value="${category.name}"/></name>
				</category>
			</c:forEach>
		</c:if>
		<categories>
		
		<tab>
			<categoyId><c:out value="${param.searchCategory}"/></categoyId>
		</tab>
		
		<bet>
			<%
			se.gu.siteseeker.Bet[] searchBets = siteseekerDoSearch.getBets();
			String[] categories = request.getParameterValues("searchCategory");
			if( searchBets != null && searchBets.length > 0 && !("999".equals(request.getParameter("searchDocumentType"))) ) {
					%>
				<data>
				<![CDATA[
				<div class="choosenHit">
					<h2><structure:componentLabel mapKeyName="RecommendedHitTitle"/>:</h2>
					<% 
					for( int j=0; j<searchBets.length; j++) {
						%>
							<p><b><a href="<%= searchBets[j].getUrl() %>"><%= searchBets[j].getTitle() %></a></b><br/>
								<%= searchBets[j].getDescription() %><br />
							</p>
						<%
					}
					%>
				</div>
				]]>
				</data>
			<%
			}
			%>
		</bet>
		<%-- HitCategories --%>
		<%--
		if( categoryIntersection != null ) {

			for( int i = 0; i<categoryIntersection.size(); i++ ) {
				HitCategory hc = (HitCategory)categoryIntersection.get(i);
				out.println(hc.getName()+" / "+hc.getNHits());   
			}
		} 
		--%>
		
		</c:otherwise>
		</c:choose>
		<%--
		<div class="resultlist">
				se.gu.siteseeker.Bet[] searchBets = siteseekerDoSearch.getBets();
				String[] categories = request.getParameterValues("searchCategory");
				if( searchBets != null && searchBets.length > 0 &&
						!("999".equals(request.getParameter("searchDocumentType"))) && 
							categories.length == 1 && 
								categories[0].equals(pageContext.getAttribute("categoryAllWeb")) ) {
					%>
					<div class="choosenHit">
						<h2><structure:componentLabel mapKeyName="RecommendedHitTitle"/>:</h2>
						<% 
						for( int j=0; j<searchBets.length; j++) {
							%>
								<p><b><a href="<%= searchBets[j].getUrl() %>"><%= searchBets[j].getTitle() %></a></b><br/>
									<%= searchBets[j].getDescription() %><br />
								</p>
							<%
						}
						%>
					</div>
					<%
				}				     
				int firstEntryNumber 		= 0;
				int lastEntryNumber 		= 0;
				int selectedPage			= 0;
				int numberOfResultsPerPage 	= 0;
				
				try
				{
					selectedPage = Integer.parseInt((String)pageContext.getAttribute("thisBatch"));
				}
				catch (Exception e)
				{
					out.print("V&auml;rdet \"" + request.getParameter("batch") + "\" &auml;r ej numeriskt.");
				}
				
				try
				{
					numberOfResultsPerPage = Integer.parseInt((String)request.getParameter("hn"));
				}
				catch (Exception e)
				{
					out.print("V&auml;rdet \"" + request.getParameter("hn") + "\" &auml;r ej numeriskt.");
				}					
					
				//----------------------------------
				// If there are hits, show this tab
				//----------------------------------
											
				if (siteseekerDoSearch.getNHits() > 0 && (request.getParameter("noAjax") == null || request.getParameter("noAjax").trim().equals("")))
				{
					%>							
						<script type="text/javascript">
							<c:if test="${param.isSubSelect ne 'true'}">
								$("#span_numberOfHits_<c:out value="${param.divId}" escapeXml="false" />").html("<%= siteseekerDoSearch.getNHits() %>");
							</c:if>
							
							<c:choose>
								<c:when test="${param.divId eq 'personnel'}">
									$("#div_<c:out value="${param.divId}" escapeXml="false" />").css("display", "block");
								</c:when>
								<c:otherwise>
									$("#tab_<c:out value="${param.divId}" escapeXml="false" />").css("display", "block");
								</c:otherwise>
							</c:choose>
						</script>
					<%
				}
				/*
				else {%>							
					console.log("<%= request.getParameterValues("searchCategory")[0] %> <%= siteseekerDoSearch.getNHits() %>");
						<script type="text/javascript">
							console.log("No results, <%= request.getParameterValues("searchCategory")[0] %> <%= siteseekerDoSearch.getNHits() %>");
						</script>
					<%
				}
				*/			
			
				if(siteseekerDoSearch != null)
				{
					if(siteseekerDoSearch.getNHits() == 0)
					{
					%>
						<p>
							<structure:componentLabel mapKeyName="SearchResultsNoHits"/>
						</p>
					<%	
					}
					else
					{							
						se.gu.siteseeker.Hit[] searchHits = siteseekerDoSearch.getHits();						      
					    pageContext.setAttribute("batches", siteseekerDoSearch.getNBatch());
						%>								
							<ol start="<%=searchHits[0].getHitNr()+1 %>">
								<%        
							    for(int i=0; i < searchHits.length; i++)
							    {
							  		pageContext.setAttribute("tempDate", searchHits[i].getModDate().getTime());
							  		
							  		if(searchHits[i].getDoctypeId() != 0)
									{
										pageContext.setAttribute("documentClass", "class=\"" + theDocTypeHash.get(searchHits[i].getDoctypeId()) + "\" ");
									}																		
									pageContext.setAttribute("searchHitTitle", searchHits[i].getTitle());
									%>
									
										<li>
											<span>
												<c:choose>
													<c:when test="${param.divId eq 'personnel'}">
														<%= searchHits[i].getTitle()%>
													</c:when>
													<c:otherwise>
														<a href="<%= searchHits[i].getSourceLink()%>" <c:out value="${documentClass}" escapeXml="false" /> <c:if test="${param.noAjax eq 'true'}">target="_top"</c:if>>
															<%= searchHits[i].getTitle()%>
														</a>
													</c:otherwise>
												</c:choose>
											</span>
											<br/>
											<c:if test="${param.hd ne 2}">
												<c:choose>
													<c:when test="${param.divId ne 'personnel'}">
														<%= searchHits[i].getDescription() %>
													</c:when>
													<c:otherwise>
														<% /* searchHits[i].getDescription() */ %>
														<%= searchHits[i].getSpecialText() %>
													</c:otherwise>
												</c:choose>
											</c:if>
											
											<c:if test="${param.divId ne 'personnel'}">
												<div class="searchHitInfo">								            										
													<span class="searchHitUrl">
														<%
															if(searchHits[i].getSourceLink().length() > noCharactersInURL)
															{
																%>
																	<%=searchHits[i].getSourceLink().substring(0, noCharactersInURL-3)%>...	
																<%
															}
															else 
															{
																%>
																	 <%=searchHits[i].getSourceLink()%>	
																<%
															}
														%>
													</span>
													<br/>																			           	
													<span class="searchHitCacheLink">
														<common:transformText id="searchHitTitle" text="${searchHitTitle}" replaceString="<strong>" replaceWithString=""/>
														<common:transformText id="searchHitTitle" text="${searchHitTitle}" replaceString="</strong>" replaceWithString=""/>
														<a <c:if test="${param.noAjax eq 'true'}">target="_top"</c:if> href="http://webbindex.gu.siteseeker.se?q=<c:out value='${param.searchText}'/>&kurl=<%=java.net.URLEncoder.encode(searchHits[i].getSourceLink().substring(7),"iso-8859-1")%>" 
														title='<structure:componentLabel mapKeyName="DisplayPageWithWordsMarkedTitle1"/>: "<c:out value="${searchHitTitle}" escapeXml="false" />" <structure:componentLabel mapKeyName="DisplayPageWithWordsMarkedTitle2"/>'> 
														<structure:componentLabel mapKeyName="DisplayPageWithWordsMarked"/>
														</a>
													</span> 
													
													
												</div>
											</c:if>
										</li>
									<%
								}							
								%>
			        		</ol>
							
				    	    <c:if test="${batches > 1}">						    	    			    	   
								<form method="post" action="<c:out value='${formUrl}'/>" name="hiddenSearchForm">	
									<input name="searchText" type="hidden" value="<c:out value='${param.searchText}'/>" id="searchword" />
									<input name="batch" type="hidden" value="1" />
									<input name="hd" type="hidden" value="<c:out value='${param.hd}'/>" />
									<c:if test="${param.searchCategory != null && !(param.searchCategory eq '')}">
										<input  type="hidden"  name="searchCategory" value="<c:out value='${param.searchCategory}'/>" />
									</c:if>
									<c:if test="${param.searchDocumentType != null && !(param.searchDocumentType eq '')}">
										<input  type="hidden"  name="searchDocumentType" value="<c:out value='${param.searchDocumentType}'/>" />
									</c:if>
									<c:if test="${param.hn != null && !(param.hn eq '')}">
										<input  type="hidden"  name="hn" value="<c:out value='${param.hn}'/>" />
									</c:if>	
									<c:forEach var="cc" items="${paramValues.cc}">
										<input name="cc" type="hidden" value="<c:out value='${cc}'/>" />			
									</c:forEach>				
								</form>
								
						        <ul class="slotlist">
					        		<c:if test="${thisBatch gt 1}">	        						        			
										<li>
											<c:choose>
												<c:when test="${param.noAjax eq true}">
													<common:urlBuilder id="queryUrl" baseURL="${resultUrl}">
														<common:parameter name="searchText" value="${param.searchText}"/>
														<common:parameter name="noCharactersInURL" value="${param.noCharactersInURL}"/>
														<common:parameter name="site" value="${param.site}"/>
														<common:parameter name="batch" value="${thisBatch - 1}"/>
														<common:parameter name="searchCategory" value="${param.searchCategory}"/>
														<common:parameter name="hn" value="${param.hn}"/>
														<common:parameter name="categoryName" value="${param.categoryName}"/>
														<common:parameter name="noAjax" value="true"/>
														<common:parameter name="cssUrl" value="${param.cssUrl}"/>
													</common:urlBuilder>
													<a href="<c:out value="${queryUrl}"/>" title="<structure:componentLabel mapKeyName="SearchResultsPreviousPageLabel"/>" class="number"><structure:componentLabel mapKeyName="SearchResultsPreviousPageLabel"/></a>
												</c:when>
												<c:otherwise>
													<a href="javascript:searchCategory('<c:out value="${param.searchText}"/>', <c:out value="${thisBatch - 1}"/>, '<c:out value="${param.searchCategory}"/>', '<c:out value="${param.divId}"/>', <c:out value="${param.searchDocumentType}"/>, <c:out value="${param.isSubSelect}"/>, '<c:out value="${param.hn}"/>', '<c:out value="${categoryName}"/>')" title="<structure:componentLabel mapKeyName="SearchResultsPreviousPageLabel"/>" class="number"><structure:componentLabel mapKeyName="SearchResultsPreviousPageLabel"/></a>
												</c:otherwise>
											</c:choose>
										</li>
									</c:if>
					        	
					        		<%
										int StartCount=1;
										if(Integer.parseInt((String)pageContext.getAttribute("thisBatch")) >5)
										{
											StartCount = Integer.parseInt((String)pageContext.getAttribute("thisBatch")) -4;
										}
										
										int EndCount = StartCount + 9;
										if(EndCount>siteseekerDoSearch.getNBatch())
										{
											EndCount=siteseekerDoSearch.getNBatch();
										}
										
										pageContext.setAttribute("startBatch", StartCount); 
										pageContext.setAttribute("endBatch", EndCount); 
									%>	
					   				<c:forEach begin="${startBatch}" end="${endBatch}" varStatus="count">
										<c:choose>
											<c:when test="${(startBatch + count.count - 1) eq thisBatch}">
												<li class="current"><c:out value='${startBatch + count.count - 1}'/></li>
											</c:when>
											<c:otherwise>
												<li>
													<c:choose>
														<c:when test="${param.noAjax eq true}">
															<common:urlBuilder id="queryUrl" baseURL="${resultUrl}">
																<common:parameter name="searchText" value="${param.searchText}"/>
																<common:parameter name="noCharactersInURL" value="${param.noCharactersInURL}"/>
																<common:parameter name="site" value="${param.site}"/>
																<common:parameter name="batch" value="${startBatch + count.count-1}"/>
																<common:parameter name="searchCategory" value="${param.searchCategory}"/>
																<common:parameter name="hn" value="${param.hn}"/>
																<common:parameter name="categoryName" value="${param.categoryName}"/>
																<common:parameter name="noAjax" value="true"/>
																<common:parameter name="cssUrl" value="${param.cssUrl}"/>
															</common:urlBuilder>
															<a href="<c:out value="${queryUrl}"/>"><c:out value="${startBatch + count.count - 1}"/></a>
														</c:when>
														<c:otherwise>
															<a href="javascript:searchCategory('<c:out value="${param.searchText}"/>', <c:out value='${startBatch+count.count-1}'/>, '<c:out value="${param.searchCategory}"/>', '<c:out value="${param.divId}"/>', <c:out value="${param.searchDocumentType}"/>, <c:out value="${param.isSubSelect}"/>, '<c:out value="${param.hn}"/>', '<c:out value="${categoryName}"/>');" class="number" title="Sida <c:out value='${startBatch+count.count-1}'/>"> <c:out value="${startBatch+count.count-1}"/></a>
														</c:otherwise>
													</c:choose>
												</li>
											</c:otherwise>
										</c:choose>
									</c:forEach>   
									
									<c:if test="${batches > endBatch}">
										<li>
											...
										</li>
									</c:if>
									
									<c:if test="${thisBatch < batches}">										
										<li>
											<c:choose>
												<c:when test="${param.noAjax eq true}">
													<common:urlBuilder id="queryUrl" baseURL="${resultUrl}">
														<common:parameter name="searchText" value="${param.searchText}"/>
														<common:parameter name="noCharactersInURL" value="${param.noCharactersInURL}"/>
														<common:parameter name="site" value="${param.site}"/>
														<common:parameter name="batch" value="${thisBatch + 1}"/>
														<common:parameter name="searchCategory" value="${param.searchCategory}"/>
														<common:parameter name="hn" value="${param.hn}"/>
														<common:parameter name="categoryName" value="${param.categoryName}"/>
														<common:parameter name="noAjax" value="true"/>
														<common:parameter name="cssUrl" value="${param.cssUrl}"/>
													</common:urlBuilder>
													<a href="<c:out value="${queryUrl}"/>" title="<structure:componentLabel mapKeyName="SearchResultsFNextPageLabel"/>" class="number"><structure:componentLabel mapKeyName="SearchResultsNextPageLabel"/></a>
												</c:when>
												<c:otherwise>
													<a href="javascript:searchCategory('<c:out value="${param.searchText}"/>',<c:out value="${thisBatch + 1}"/>, '<c:out value="${param.searchCategory}"/>', '<c:out value="${param.divId}"/>', <c:out value="${param.searchDocumentType}"/>, <c:out value="${param.isSubSelect}"/>, '<c:out value="${param.hn}"/>', '<c:out value="${categoryName}"/>');" title="<structure:componentLabel mapKeyName="SearchResultsFNextPageLabel"/>" class="number"><structure:componentLabel mapKeyName="SearchResultsNextPageLabel"/></a>
												</c:otherwise>
											</c:choose>
										</li>									
									</c:if>  	
						        </ul>							       
				        	</c:if>						        	
						<%
					} // END OF ELSE if(siteseekerDoSearch.getNHits()==0)
				} //END OF if(siteseekerDoSearch != null)
			</div>
			
			<c:if test="${param.noAjax eq 'true'}">
				</div></div></div>
			</c:if>
			--%>
		<%
	} // END If Siteseeker URL not loaded
}
catch(java.net.SocketTimeoutException e)
{
	out.print("Our search engine is very loaded at the moment and could not serve your request. Please try again later.");
}
catch (Exception e) 
{ 
	/*
	if(e.getCause() != null && e.getCause() instanceof java.net.SocketTimeoutException)
		out.print("Our search engine is very loaded at the moment and could not serve your request. Please try again later.");
	else
		out.print("An error occurred trying to search: " + e.getMessage());
	*/
}
%>