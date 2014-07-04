<%@page import="org.infoglue.cms.security.InfoGlueGroup"%>
<%@page import="java.util.HashSet"%>
<%@page import="org.infoglue.cms.util.CmsPropertyHandler"%>
<%@page import="org.infoglue.cms.applications.common.VisualFormatter"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-lucene" prefix="lucene" %>
<%@ taglib uri="infoglue-management" prefix="management" %>

<script type="text/javascript" src="<c:out value="${pageContext.request.contextPath}"/>/applications/FCKEditor/fckeditor.js"></script>

<page:pageContext id="pc" />
<page:deliveryContext id="dc" useFullUrl="true" disableNiceUri="false" trimResponse="true" operatingMode="0"/>

<%-- Used for Lucene-index setup --%>
<management:language id="englishLanguage" languageCode="en"/>

<structure:componentPropertyValue id="departmentId" propertyName="DepartmentId" useInheritance="false"/>
<structure:componentPropertyValue id="dataBasePath" propertyName="GUR_DataBasePath" useInheritance="true"/>
<structure:componentPropertyValue id="personData" propertyName="GUR_PersonDataPath" useInheritance="true" />
<structure:componentPropertyValue id="luceneTimeout" propertyName="GUR_LuceneCacheTimeout" useInheritance="true"/>
<structure:pageUrl id="wysiwygConfigUrl" propertyName="WYSIWYGConfig" useInheritance="true" />

<content:content id="departmentFolder" propertyName="DepartmentFolder" />

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

<c:set var="slotName" value="${pc.componentLogic.infoGlueComponent.slotName}"/>
<%
	String slotName = (String)pageContext.getAttribute("slotName");
	String selectedTab = slotName.substring(slotName.length() - 1);
	pageContext.setAttribute("selectedTab", selectedTab);
%>

<div class="guResearchComp departmentDetail">
	<c:if test="${empty departmentId}">
		<p><structure:componentLabel mapKeyName="NoDepartmentSelected"/></p>
	</c:if>
		
	<c:if test="${not empty departmentId}">
	<%
		String departmentId = (String)pageContext.getAttribute("departmentId");	
		if (departmentId.length() == 5)
		{
			departmentId = "0" + departmentId;
			pageContext.setAttribute("departmentId", departmentId);
		}
	%>
	</c:if>
	
	<c:if test="${empty departmentFolder and pc.isDecorated}">
		<p class="adminMessage"><structure:componentLabel mapKeyName="NoDepartmentFolderProvided"/></p>
	</c:if>
	
	<c:if test="${not empty departmentId}">
	<%--
		<content:matchingContents id="subjectList" freeText="${subjectId}" freeTextAttributeNames="SubjectId" 
			contentTypeDefinitionNames="GU Amnesbeskrivning" startNodeId="${subjectDescriptionFolder.contentId}" skipLanguageCheck="true" />

	    <c:set var="subjectContent" value="${subjectList[0]}" />--%>
	    
	    <content:matchingContents id="departmentContents" freeText="${departmentId}" freeTextAttributeNames="DepartmentId"
			contentTypeDefinitionNames="GU Avdelning" startNodeId="${departmentFolder.contentId}" skipLanguageCheck="true" />
		<c:if test="${not empty departmentContents}">
			<c:set var="departmentContent" value="${departmentContents[0]}" />
		</c:if>

	    <c:choose>
		    <c:when test="${not empty departmentContent}">
				<content:hasContentAccess id="isAuthorized" contentId="${departmentContent.contentId}" interceptionPointName="Content.Write" />
		    </c:when>
		    <c:when test="${not empty departmentFolder}">
				<content:hasContentAccess id="isAuthorized" contentId="${departmentFolder.contentId}" interceptionPointName="Content.Write" />
		    </c:when>
	    </c:choose>
	</c:if>
	
	<c:if test="${isAuthorized}">
		<c:if test="${not empty departmentFolder}">
			<c:if test="${param.userAction eq 'createDepartmentDescription'}">
				<structure:componentLabel id="defaultText" mapKeyName="DefaultDescriptionText" />
				<c:catch var="myException1">
					<content:contentTypeDefinition id="ctd" contentTypeDefinitionName="GU Avdelning"/>			
					<content:remoteContentService id="rcs" operationName="createContents" principal="${pc.principal}">
						<content:contentParameter name="${departmentId}" parentContentId="${departmentFolder.contentId}" contentTypeDefinitionId="${ctd.id}" repositoryId="${departmentFolder.repositoryId}">
							<content:contentVersionParameter languageId="${pc.languageId}" allowHTMLContent="true" allowExternalLinks="false" allowAnchorSigns="true" allowDollarSigns="false">
								<content:contentVersionAttributeParameter name="DepartmentId" value="${departmentId}"/>	
								<content:contentVersionAttributeParameter name="Description" value="<p></p>"/>	
							</content:contentVersionParameter>
						</content:contentParameter>
					</content:remoteContentService>	
				</c:catch>
				<c:choose>
					<c:when test="${myException1 != null}">
						<p class="adminError"><structure:componentLabel mapKeyName="AnErrorOccuredWhenSavingContent" />: <c:out value="${myException1.message}"/></p>
					</c:when>
					<c:otherwise>
						<common:urlBuilder id="currentUrl">
							<common:parameter name="userAction" value="hasCreateDepartmentDescription"/>
						</common:urlBuilder>
						<common:sendRedirect url="${currentUrl}" />
					</c:otherwise>
				</c:choose>
			</c:if>
			<c:if test="${not empty param.departmentDescription}">
				<%
					String departmentDescription = (String)pageContext.getRequest().getParameter("departmentDescription");
					departmentDescription = departmentDescription.replaceAll("\\$(?!(\\.|\\(|templateLogic\\.(getPageUrl|getInlineAssetUrl|languageId)))", "&#36;");
					pageContext.setAttribute("departmentDescription", departmentDescription);
				%>
				<c:catch var="myException2">
					<content:updateContentVersion id="ucv" contentId="${param.departmentDescriptionContentId}" languageId="${pc.languageId}" stateId="1" 
							allowHTMLContent="true" allowExternalLinks="true" allowAnchorSigns="true" allowDollarSigns="false" >
					    <content:contentVersionAttributeParameter name="DepartmentId" value="${departmentId}"/> 
					    <content:contentVersionAttributeParameter name="Description" value="${departmentDescription}"/> 
					</content:updateContentVersion>
				</c:catch>

				<c:choose>
					<c:when test="${myException2 != null}">
						<p class="adminError"><structure:componentLabel mapKeyName="AnErrorOccuredWhenSavingContent" />: <c:out value="${myException2.message}"/></p>
					</c:when>
					<c:otherwise>
						<common:urlBuilder id="currentUrl" excludedQueryStringParameters="userAction"/>
						<common:sendRedirect url="${currentUrl}" />
					</c:otherwise>
				</c:choose>
			</c:if>
		</c:if>
	</c:if>

	<c:choose>
		<c:when test="${not empty dataBasePath}">
			<c:catch var="luceneSetupException">
				<c:choose>
					<c:when test="${pc.languageId eq englishLanguage.languageId}">
						<c:set var="departmentData" value="${dataBasePath}/lucene_org_en.dat"/>
						<lucene:setupIndex id="departmentDirectory" directoryCacheName="guDepartments_en" path="${departmentData}" indexes="parentId,departmentId" timeout="${luceneTimeout}" parser="se.gu.infoglue.lucene.GUOrgParser" />
					</c:when>
					<c:otherwise>
						<c:set var="departmentData" value="${dataBasePath}/lucene_org_sv.dat"/>
						<lucene:setupIndex id="departmentDirectory" directoryCacheName="guDepartments_sv" path="${departmentData}" indexes="parentId,departmentId" timeout="${luceneTimeout}" parser="se.gu.infoglue.lucene.GUOrgParser" />
					</c:otherwise>
				</c:choose>
			</c:catch>
		</c:when>
		<c:when test="${empty dataBasePath and pc.isDecorated}">
			<p class="adminError"><structure:componentLabel mapKeyName="NoKataGuData"/></p>
		</c:when>
	</c:choose>
	
	<c:if test="${not empty luceneSetupException and pc.isDecorated}">
	<%--
		<p class="adminError"><c:out value="${luceneSetupException.message}"/></p>--%>
		<p class="adminError"><structure:componentLabel mapKeyName="IndexInitFailed"/> <c:out value="${luceneSetupException.message}"/> (<c:out value="${luceneSetupException.class.name}"/>)</p>
	</c:if>
	
	<c:if test="${not empty departmentData and empty luceneSetupException}">
		<c:if test="${not empty departmentId}">
		<c:if test="${not empty departmentDirectory}">
			<c:catch var="searchException">
				<lucene:search id="departments" directory="${departmentDirectory}" query="departmentId:${departmentId} AND __IGObjectType:departments" />
			</c:catch>
		</c:if>
			
			<c:if test="${not empty searchException and pc.isDecorated}">
				<p class="adminError"><c:out value="${searchException.message}"/></p>
			</c:if>
			
			<c:if test="${not empty departments}">
				<common:size id="size" list="${departments}"/>
			</c:if>
			<c:choose>
				<c:when test="${size eq 0}">
					<structure:componentLabel mapKeyName="NoHit"/>: <c:out value="${departmentId}"/>
				</c:when>
				<c:when test="${size gt 1}">
					<structure:componentLabel mapKeyName="TooManyHits"/>
				</c:when>
				<c:otherwise>
					<c:set var="department" value="${departments[0]}"/>
					
					<div id="kartenaMapDiv" class="right">
						<c:set var="mapAlias" value="${param.mapAlias}"/>
						<%
							String palassoId = (String)pageContext.getAttribute("departmentId");
							String kataguDepartmentId = palassoId.substring(2);
							pageContext.setAttribute("kataguDepartmentId", kataguDepartmentId);
						%>
						<c:set var="mapUrl">http://content.kartena.se/viewer/Default.aspx?customerId=4&category=19,20,21,22,23,17,18,4&alias=<c:out value="${kataguDepartmentId}" escapeXml="false"/>&all=0&lang=<c:out value="${pc.locale.language}"/>&template=FlowTemplate.htm</c:set>
						<iframe class="kartenaMapFrame" frameborder="0" id="mapFrame" name="mapFrame" src="<c:out value="${mapUrl}" escapeXml="true"/>"></iframe>
					</div>
					
					<script type="text/javascript">
						$("#kartenaMapDiv").fadeIn(500);
					</script>

					<div class="contactInformation">
						<p>
							<span class="blockTitle"><c:out value="${department['departmentName']}" escapeXml="false"/></span><!-- prince: <c:out value="${pc.principal.name}"/> --><br/>
							<c:if test="${not empty department['postalAddress']}">
								<c:out value="${department['postalAddress']}" escapeXml="false"/><br/>
							</c:if>
							<c:if test="${not empty department['deliveryAddress']}">
								<structure:componentLabel mapKeyName="DeliveryAddress"/>: <c:out value="${department['deliveryAddress']}" escapeXml="false"/><br/>
							</c:if>
							<c:if test="${not empty department['visitingAddress']}">
								<structure:componentLabel mapKeyName="VisitingAddress"/>: <c:out value="${department['visitingAddress']}" escapeXml="false"/><br/>
							</c:if>
							
							<br/>
							<c:if test="${not empty department['phone']}">
								<structure:componentLabel mapKeyName="Phone"/>: <c:out value="${department['phone']}" escapeXml="false"/><br/>
							</c:if>
							<c:if test="${not empty department['fax']}">
								<structure:componentLabel mapKeyName="Fax"/>: <c:out value="${department['fax']}" escapeXml="false"/><br/>
							</c:if>
							<c:if test="${not empty department['webPage']}">
								<c:set var="linkText" value="${department['webPage']}" />
								<%
									String linkText = (String)pageContext.getAttribute("linkText");
									
									if (linkText.startsWith("http://"))
									{
										linkText = linkText.substring(7);
										pageContext.setAttribute("linkText", linkText);
									}
								%>
								<structure:componentLabel mapKeyName="WebPage"/>: <a href="<c:out value="${department['webPage']}" escapeXml="false"/>"><c:out value="${linkText}" escapeXml="false"/></a><br/>
							</c:if>
							<c:if test="${not empty department['email']}">
								<structure:componentLabel mapKeyName="Email"/>: <a href="mailto:<c:out value="${department['email']}" escapeXml="false"/>"><c:out value="${department['email']}" escapeXml="false"/></a><br/>
							</c:if>
							<br/>
							<c:if test="${not empty department['managerName']}">
								<structure:pageUrl id="personDetailPageUrl" propertyName="GUR_PersonDetailPage" useInheritance="true" />
							
								<c:remove var="managerWorksAtDepartment"/>
								<c:choose>
									<c:when test="${not empty dataBasePath}">
										<c:catch var="personDirectoryException">
											<c:choose>
												<c:when test="${pc.languageId eq englishLanguage.languageId}">
													<c:set var="personData" value="${dataBasePath}/lucene_person_en.dat"/>
													<lucene:setupIndex id="personDirectory" directoryCacheName="guPersons_en" path="${personData}" indexes="id,departmentBottomId,departmentMiddleId,departmentTopId" sortableFields="lastName,firstName,title,phone,email"  timeout="${timeout}" parser="se.gu.infoglue.lucene.GUPersonParser" />
												</c:when>
												<c:otherwise>
													<c:set var="personData" value="${dataBasePath}/lucene_person_sv.dat"/>
													<lucene:setupIndex id="personDirectory" directoryCacheName="guPersons_sv" path="${personData}" indexes="id,departmentBottomId,departmentMiddleId,departmentTopId" sortableFields="lastName,firstName,title,phone,email"  timeout="${timeout}" parser="se.gu.infoglue.lucene.GUPersonParser" />
												</c:otherwise>
											</c:choose>
										</c:catch>
									</c:when>
									<c:when test="${empty dataBasePath and pc.isDecorated}">
										<p class="adminError"><structure:componentLabel mapKeyName="NoKataGuDataPerson"/></p>
									</c:when>
								</c:choose>
								
								<c:choose>
									<c:when test="${pc.isDecorated and not empty personDirectoryException}">
									<%--
										<p class="adminError"><structure:componentLabel mapKeyName="PersonIndexException"/> &ndash; <c:out value="personDirectoryException.message"/></p>--%>
										<p class="adminError"><structure:componentLabel mapKeyName="IndexInitFailed"/> <c:out value="${personDirectoryException.message}"/> (<c:out value="${personDirectoryException.class.name}"/>)</p>
									</c:when>
									<c:when test="${empty personDirectoryException and not empty personDirectory}">
										<c:catch var="personSearchException">
											<lucene:search id="persons" directory="${personDirectory}" query="id:${department['managerId']} AND departmentBottomId:${departmentId}" />
										</c:catch>
										
										<c:choose>
											<c:when test="${pc.isDecorated and not empty personSearchException}">
												<p class="adminError">Person: <structure:componentLabel mapKeyName="PersonSearchException"/> &ndash; <c:out value="personSearchException.message"/></p>
											</c:when>
											<c:when test="${empty personSearchException and not empty persons}">
												<c:set var="managerWorksAtDepartment" value="true"/>
											</c:when>
										</c:choose>
									</c:when>
								</c:choose>
							 
								<common:urlBuilder id="managerDetailPageUrl" baseURL="${personDetailPageUrl}" includeCurrentQueryString="false">
									<common:parameter name="userId" value="${department['managerId']}" />
									<common:parameter name="userName" value="${department['managerName']}" />
									<c:if test="${managerWorksAtDepartment eq true}">
										<common:parameter name="departmentId" value="${departmentId}" />
									</c:if>
									<%--
										This code will create a duplicate languageId in Working but it is required
										for live to work.
									--%>
									<common:parameter name="languageId" value="${pc.languageId}" />
								</common:urlBuilder>
								<c:out value="${department['managerTitle']}" escapeXml="false"/>: <a href="<c:out value="${managerDetailPageUrl}" />"><c:out value="${department['managerName']}" escapeXml="false"/></a>
							</c:if>
						</p>
					</div>
						
					<div class="clr"></div>
					<%--
					<content:matchingContents id="departmentContents" freeText="${departmentId}" freeTextAttributeNames="DepartmentId"
						contentTypeDefinitionNames="GU Avdelning" startNodeId="${departmentFolder.contentId}" skipLanguageCheck="true" />
					<c:if test="${not empty departmentContents}">
						<c:set var="departmentContent" value="${departmentContents[0]}" />
					</c:if>--%>
					
					<div class="departmentDescription">
			
					
						<c:choose>
							<c:when test="${not empty departmentContent}">
								<c:if test="${isAuthorized}">
									<management:language id="swedishVO" languageCode="sv"/>
									<management:language id="englishVO" languageCode="en"/>
									<content:contentVersion id="departmentContentSwedishVersion" useLanguageFallback="false" languageId="${swedishVO.languageId}" content="${departmentContent}" />
									<content:contentVersion id="departmentContentEnglishVersion" useLanguageFallback="false" languageId="${englishVO.languageId}" content="${departmentContent}" />
								</c:if>
								<%--
								<content:contentAttribute id="description" attributeName="Description" useAttributeLanguageFallback="false" contentId="${departmentContent.id}" disableEditOnSight="true"/> --%>
								<content:contentVersion id="departmentContentCurrentVersion" useLanguageFallback="false" languageId="${pc.languageId}" content="${departmentContent}" />
								<c:if test="${not empty departmentContentCurrentVersion}">
									<content:contentAttribute id="description" attributeName="Description" contentVersion="${departmentContentCurrentVersion}" useAttributeLanguageFallback="false" disableEditOnSight="true" />
								</c:if>
								
								<common:urlBuilder id="currentPageUrl" excludedQueryStringParameters="userName,selectedTab" />
								
								<%--  --%>
								<c:if test="${not empty description or isAuthorized}">
									<h2><structure:componentLabel mapKeyName="AboutTheDepartment"/></h2>
									<div id="departmentDescriptionText">
										<c:out value="${description}" escapeXml="false" />
										<c:if test="${isAuthorized}">
											<form method="post" action="<c:out value="${currentPageUrl}" />">
												<fieldset>
													<input type="button" onclick="editDepartmentText();" value="<structure:componentLabel mapKeyName="EditYourText" />" />
												</fieldset>
											</form>
										</c:if>
									</div>
									
									<%-- Notifies authorized users about missing language versions --%>
									<c:if test="${isAuthorized}">
										<c:choose>
											<c:when test="${pc.languageId eq swedishVO.languageId}">
												<c:if test="${empty departmentContentEnglishVersion}"><p class="missingDescription"><structure:componentLabel mapKeyName="MissingEnglishDescription"/></p></c:if>
											</c:when>
											<c:when test="${pc.languageId eq englishVO.languageId}">
												<c:if test="${empty departmentContentSwedishVersion}"><p class="missingDescription"><structure:componentLabel mapKeyName="MissingSwedishDescription"/></p></c:if>
											</c:when>
										</c:choose>
									</c:if>
								</c:if>
								
								<c:if test="${isAuthorized}">
									<div id="departmentDescriptionField">
										<form method="post" action="<c:out value="${currentPageUrl}" />">
											<fieldset>											
												<input type="hidden" name="departmentDescriptionContentId" value="<c:out value="${departmentContent.id}"/>" />
												<textarea id="departmentDescription" name="departmentDescription" class="editDescriptionTextArea"><c:out value="${description}" escapeXml="false" /></textarea>
												<div class="editDescriptionControls">
													<input type="submit" value="<structure:componentLabel mapKeyName="SaveDepartmentText" />" />
													<input type="hidden" name="selectedTab" value="<c:out value="${selectedTab}"/>" />
													<input type="button" onclick="closeDepartmentText();" value="<structure:componentLabel mapKeyName="Cancel" />" />
												</div>
											</fieldset>
										</form>
									</div>
									<script type="text/javascript">
										var oFCKeditor = new FCKeditor( 'departmentDescription' ) ;
										oFCKeditor.BasePath	= '<c:out value="${pageContext.request.contextPath}"/>/applications/FCKEditor/' ;
										oFCKeditor.ProcessHTMLEntities = true;
										oFCKeditor.Width = 500;
										oFCKeditor.Height = 300;
										oFCKeditor.Config["CustomConfigurationsPath"] = "<c:out value="${wysiwygConfigUrl}"/>"; 
										oFCKeditor.Config["AutoDetectLanguage"] = false ;
										oFCKeditor.Config["DefaultLanguage"]    = '<c:out value="${pc.locale.language}"/>' ;
										oFCKeditor.ToolbarSet = "Research_editor";
										oFCKeditor.ReplaceTextarea();
									</script>
								
									<script type="text/javascript">
										function editDepartmentText()
										{
											$("#departmentDescriptionText").hide();
											$("#departmentDescriptionField").show();
										}
										
										function closeDepartmentText()
										{
											$("#departmentDescriptionText").show();
											$("#departmentDescriptionField").hide();
										}
										<c:choose>
											<c:when test="${param.userAction eq 'hasCreateDepartmentDescription'}">
												editDepartmentText();
											</c:when>
											<c:otherwise>
												closeDepartmentText();
											</c:otherwise>
										</c:choose>
									</script>
								</c:if>
							</c:when>
							<c:when test="${empty description and isAuthorized}">
								<h2><structure:componentLabel mapKeyName="AboutTheDepartment"/></h2>
								<p>
									<structure:componentLabel mapKeyName="NoTextCreateOne" />
								</p>
								<form method="post" action="<c:out value="${currentPageUrl}" />">
									<fieldset>
										<input type="hidden" name="userAction" value="createDepartmentDescription" />
										<input type="hidden" name="selectedTab" value="<c:out value="${selectedTab}"/>" />
										<input type="submit" value="<structure:componentLabel mapKeyName="CreateDescription" />" />
									</fieldset>
								</form>
							</c:when>
						</c:choose> <%-- departmentContent --%>
					</div>
				</c:otherwise>
			</c:choose> <%-- Departments size check --%>
		</c:if> <%-- not empty departmentId --%>
	</c:if> <%-- not empty departmentData and empty luceneSetupException --%>
</div>