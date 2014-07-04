<%@page import="java.util.Arrays"%>
<%@page import="org.infoglue.cms.entities.management.LanguageVO"%>
<%@page import="org.infoglue.cms.controllers.kernel.impl.simple.ContentVersionControllerProxy"%>
<%@page import="org.infoglue.cms.entities.management.ContentTypeDefinitionVO"%>
<%@page import="java.util.Date"%>
<%@page import="javax.xml.rpc.encoding.XMLType"%>
<%@page import="javax.xml.rpc.ParameterMode"%>
<%@page import="org.apache.axis.encoding.ser.BeanDeserializerFactory"%>
<%@page import="org.apache.axis.encoding.ser.BeanSerializerFactory"%>
<%@page import="org.apache.axis.client.Call"%>
<%@page import="org.apache.axis.client.Service"%>
<%@page import="org.infoglue.deliver.util.webservices.InfoGlueWebServices"%>
<%@page import="org.infoglue.cms.entities.content.ContentVersionVO"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Collections"%>
<%@page import="org.infoglue.cms.security.InfoGluePrincipal"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.infoglue.cms.webservices.elements.CreatedEntityBean"%>
<%@page import="org.infoglue.cms.webservices.elements.StatusBean"%>
<%@page import="org.infoglue.deliver.util.webservices.DynamicWebservice"%>
<%@page import="javax.xml.namespace.QName"%>
<%@page import="org.infoglue.cms.util.CmsPropertyHandler"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %> 
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="http://java.sun.com/jstl/fmt" prefix="fmt" %>
<%@ taglib uri="infoglue-lucene" prefix="lucene" %>
<%@ taglib uri="infoglue-management" prefix="management" %>


<script type="text/javascript" src="<c:out value="${pageContext.request.contextPath}"/>/applications/FCKEditor/fckeditor.js"></script>

<page:pageContext id="pc"/>

<page:deliveryContext id="dc" useFullUrl="true" disableNiceUri="false" trimResponse="true" operatingMode="0"/>
<content:content id="personFolder" propertyName="PersonFolder" />
<structure:pageUrl id="departmentDetailPageUrl" propertyName="GUR_DepartmentDetailPage" useInheritance="true" />
<structure:pageUrl id="wysiwygConfigUrl" propertyName="WYSIWYGConfig" useInheritance="true" />
<structure:componentPropertyValue id="luceneTimeout" propertyName="GUR_LuceneCacheTimeout" useInheritance="true"/>
<structure:componentPropertyValue id="dataBasePath" propertyName="GUR_DataBasePath" useInheritance="true"/>

<management:language id="englishLanguage" languageCode="en"/>

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

			if (pageType.equals("persondetalj"))
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

<content:content id="cont" contentId="${param.userDescriptionContentId}" />

<common:urlBuilder id="currentPageUrl" excludedQueryStringParameters="userName,userAction,selectedTab" />

<%----------------------------------------------%>
<%-- OBS! Persondata hämtas ut i pretemplate! --%>
<%----------------------------------------------%>

<div class="guResearchComp personDetail">
	<c:if test="${empty personFolder and pc.isDecorated}">
		<p class="adminError"><structure:componentLabel mapKeyName="NoPersonFolderProvided" /></p>
	</c:if>

	<c:choose>
		<c:when test="${not empty personDetailError and pc.isDecorated}">
			<p class="adminError"><c:out value="${personDetailError}" escapeXml="false" /></p>
		</c:when>
		<c:when test="${empty personDetailError and not empty xname}">
			<content:matchingContents id="personContents" freeText="${xname}" freeTextAttributeNames="UserId" contentTypeDefinitionNames="GU Person" skipLanguageCheck="true" startNodeId="${personFolder.contentId}" />
			<c:if test="${not empty personContents}"><c:set var="personContent" value="${personContents[0]}"/></c:if>
			<%--
		    <c:if test="${not empty param.userAction}"> --%>
			    <%-- #####  This <choose> defines isAuthorized ############################ 
			    	 Determine isAuthorized based on the most specific content available.
			         That is: if the person has a content that determines the access, otherwise
			         the folder are traversed until one is found or until there are no more --%>
			    <c:if test="${not empty personFolder}">
				    <c:choose>
				    	<c:when test="${not empty personContent}">
							<content:hasContentAccess id="isAuthorized" contentId="${personContent.contentId}" interceptionPointName="Content.Write" />
						</c:when>
						<c:otherwise>
							<c:set var="primaryDepartmentId"><c:out value="${primaryDepartmentId}"/></c:set>
							<content:childContents id="folders" contentId="${personFolder.contentId}" includeFolders="true" matchingName="${primaryDepartmentId}" />
							<c:choose>
								<c:when test="${not empty folders}">
									<content:hasContentAccess id="isAuthorized" contentId="${folders[0].contentId}" interceptionPointName="Content.Write" />
									<%--<management:hasAccess id="isAuthorized" extraParameters="${folders[0].contentId}" interceptionPointName="Content.Write" />--%>
								</c:when>
						    	<c:otherwise> <%-- We know personFolder is defined due to surrounding if --%>
									<content:hasContentAccess id="isAuthorized" contentId="${personFolder.contentId}" interceptionPointName="Content.Write" />
								</c:otherwise>
							</c:choose>
						</c:otherwise>
				    </c:choose>
				    <c:set var="isAuthorized" value="${pc.principal.name eq xname or isAuthorized}"/>
			    </c:if>
			    
			    <%--
			</c:if> --%>
		    
		    
			<%--
			<c:if test="${not empty departmentId or not empty primaryDepartmentId}">
				<c:set var="departmentFolderId" value="${primaryDepartmentId}" />
				<c:if test="${not empty departmentId}">
					<c:set var="departmentFolderId" value="${departmentId}" />
				</c:if>
			</c:if>--%>
			
			<%--
				param.primaryDepartmentId is defined when the component want to create the user's content.
				departmentFolderId should be defined in all cases however to guarantee the right precedence
				param.primaryDepartmentId is used in first-hand.
			 --%><%--
	    	<c:if test="${not empty param.primaryDepartmentId or not empty departmentFolderId}">
	    		<c:set var="nameToMatch" value="${departmentFolderId}" />
				<c:if test="${not empty param.primaryDepartmentId}">
					<c:set var="nameToMatch" value="${param.primaryDepartmentId}" />
				</c:if>--%>
	    	<%--
	    		nameToMatch: <c:out value="${nameToMatch}"/> || <%=pageContext.getAttribute("nameToMatch")!=null?pageContext.getAttribute("nameToMatch").getClass():"null" %><br/>--%>
	    		<%--
	    		<content:childContents id="folders" contentId="${personFolder.contentId}" includeFolders="true" matchingName="${nameToMatch}" />
	    		
	    		<c:choose>
					<c:when test="${empty folders}">
						<p>Creates folder</p>
						<c:catch var="folderException">
							<content:contentTypeDefinition id="ctd" contentTypeDefinitionName="Folder"/>		
							<content:remoteContentService id="rcs" operationName="createContents" principal="${pc.principal}">
								<content:contentParameter name="${nameToMatch}" parentContentId="${personFolder.contentId}" contentTypeDefinitionId="${ctd.id}" repositoryId="${personFolder.repositoryId}" isBranch="true">
								</content:contentParameter>
							</content:remoteContentService>
							<c:set var="parentFolderId" value="${rcs.createdBeans[0].entityId}" />
						</c:catch>
						
						<c:if test="${myException1 != null}">
							<p class="adminError"><structure:componentLabel mapKeyName="AnErrorOccuredWhenSavingContent" />: <c:out value="${folderException.message}"/></p>
						</c:if>
					</c:when>
					<c:otherwise>
						<p>Found folder</p>
						<c:set var="parentFolderId" value="${folders[0].contentId}" />
					</c:otherwise>
				</c:choose>
				
				<c:if test="${empty isAuthorized and not empty parentFolderId}">
					<content:hasContentAccess id="isAuthorized" contentId="${parentFolderId}" interceptionPointName="Content.Write" />
				</c:if>
	    	</c:if>--%>

			<c:if test="${isAuthorized}">
				<c:if test="${param.userAction eq 'createPersonalDescription'}">
					<c:if test="${not empty personFolder}"> <%-- Should never be empty here, but just in case. --%>
						<%-- Folders might have been retrieved before. So to optimize a bit we do not retrieve them again
						     if we already have them. :-) --%>
						<c:if test="${empty folders}">
							<c:set var="primaryDepartmentId"><c:out value="${primaryDepartmentId}"/></c:set>
							<content:childContents id="folders" contentId="${personFolder.contentId}" includeFolders="true" matchingName="${primaryDepartmentId}" />
						</c:if>
						
						<c:choose>
							<c:when test="${empty folders}">
								<c:catch var="folderException">
									<content:contentTypeDefinition id="ctd" contentTypeDefinitionName="Folder"/>		
									<content:remoteContentService id="rcs" operationName="createContents" principal="${pc.principal}">
										<content:contentParameter name="${primaryDepartmentId}" parentContentId="${personFolder.contentId}" contentTypeDefinitionId="${ctd.id}" repositoryId="${personFolder.repositoryId}" isBranch="true">
										</content:contentParameter>
									</content:remoteContentService>
									<c:set var="parentFolderId" value="${rcs.createdBeans[0].entityId}" />
								</c:catch>
								
								<c:if test="${not empty folderException}">
									<p class="adminError"><structure:componentLabel mapKeyName="AnErrorOccuredWhenSavingContent" />: <c:out value="${folderException.message}"/></p>
								</c:if>
							</c:when>
							<c:otherwise>
								<c:set var="parentFolderId" value="${folders[0].contentId}" />
							</c:otherwise>
						</c:choose>
					</c:if>

					<%-- Create the new content and put it in the correct folder --%>
					<c:if test="${not empty parentFolderId}">
						<c:catch var="contentCreateException">
							<structure:componentLabel id="defaultText" mapKeyName="DefaultDescriptionText" />
							<content:contentTypeDefinition id="ctd" contentTypeDefinitionName="GU Person"/>			
							<content:remoteContentService id="rcs" operationName="createContents" principal="${pc.principal}" >
								<content:contentParameter name="${xname}" parentContentId="${parentFolderId}" contentTypeDefinitionId="${ctd.id}" repositoryId="${personFolder.repositoryId}">
									<content:contentVersionParameter languageId="${pc.languageId}" allowHTMLContent="true" allowExternalLinks="true" allowAnchorSigns="true" allowDollarSigns="false">
										<content:contentVersionAttributeParameter name="UserId" value="${xname}"/>
										
									</content:contentVersionParameter>
								</content:contentParameter>
							</content:remoteContentService>	
						</c:catch>
					</c:if>
					<%-- <content:contentVersionAttributeParameter name="Description" value="<p>${defaultText}</p>"/>	 --%>
					<c:choose>
						<c:when test="${not empty contentCreateException}">
							<p class="adminError"><structure:componentLabel mapKeyName="AnErrorOccuredWhenSavingContent" />: <c:out value="${contentCreateException.message}"/></p>
						</c:when>
						<c:otherwise>
							<common:urlBuilder id="currentUrl">
								<common:parameter name="userAction" value="hasCreatePersonalDescription"/>
							</common:urlBuilder>
							<common:sendRedirect url="${currentUrl}" />
						</c:otherwise>
					</c:choose>
				</c:if>
			
				<c:if test="${param.userAction eq 'updatePersonalDescription'}">
					<%
						Object userDescriptionObject = pageContext.getRequest().getParameter("userDescription");
						String userDescription = "";
						if (userDescriptionObject != null && userDescriptionObject instanceof String)
						{
							userDescription = (String)userDescriptionObject;
							userDescription = userDescription.replaceAll("\\$(?!(\\.|\\(|templateLogic\\.(getPageUrl|getInlineAssetUrl|languageId)))", "&#36;");
						}
						pageContext.setAttribute("userDescription", userDescription);
					%>
					<c:catch var="updateException">
						<content:updateContentVersion id="ucv" contentId="${param.userDescriptionContentId}" languageId="${pc.languageId}" stateId="1" 
								allowHTMLContent="true" allowExternalLinks="true" allowAnchorSigns="true" allowDollarSigns="false" createVersionIfNotExists="true" >
							<content:contentVersionAttributeParameter name="UserId" value="${xname}"/> 
						    <content:contentVersionAttributeParameter name="Description" value="${userDescription}"/> 
						</content:updateContentVersion>
					</c:catch>
	
					<c:choose>
						<c:when test="${not empty updateException}">
							<p class="adminError"><structure:componentLabel mapKeyName="AnErrorOccuredWhenSavingContent" />: <c:out value="${updateException.message}"/></p>
						</c:when>
						<c:otherwise>
							<common:urlBuilder id="currentUrl" excludedQueryStringParameters="userAction" />
							<common:sendRedirect url="${currentUrl}" />
						</c:otherwise>
					</c:choose>
				</c:if>

				<common:parseMultipart id="formParameters" maxSize="25000000" allowedContentTypes="image/gif,image/jpg,image/jpeg,image/png,application/pdf,image/pjpeg" ignoreEmpty="true"/>
			
				<c:if test="${formParameters.userAction eq 'uploadImage'}">
					<c:catch var="uploadError">
					
						<%----------------------------------------------------------%>
						<%--                 Upload the new image                 --%>
						<%----------------------------------------------------------%>
						
						<content:updateContentVersion id="rcs" contentId="${formParameters.contentId}" languageId="${pc.languageId}" updateExistingAssets="true">
							<c:forEach var="fileItem" items="${formParameters.files}">
								<c:set var="fileNameCandidate" value="${fileItem.name}"/>
								<%
									String fileNameCandidate = (String)pageContext.getAttribute("fileNameCandidate");
									if(fileNameCandidate != null && !fileNameCandidate.equals(""))
									{
										fileNameCandidate = org.apache.commons.io.FilenameUtils.getName(fileNameCandidate);
										pageContext.setAttribute("fileNameCandidate", fileNameCandidate);
									}
								%>
								<content:digitalAssetParameter fileName="${fileNameCandidate}" assetKey="image" contentType="${fileItem.contentType}" fileItem="${fileItem}"/>
							</c:forEach>
						</content:updateContentVersion>
					</c:catch>
					
					<c:choose>
						<c:when test="${uploadError != null}">
							<p class="adminError"><structure:componentLabel mapKeyName="AnErrorOccuredWhenUploadingImage" />: <c:out value="${uploadError.message}"/> (<c:out value="${uploadError.class.name}"/>)</p>
						</c:when>
						<c:otherwise>
							<common:sendRedirect url="${currentPageUrl}" />
						</c:otherwise>
					</c:choose>
				</c:if> <%-- formParameters.userAction eq 'uploadImage' --%>
			</c:if> <%-- isAuthorized --%>
		</c:when> <%-- empty personDetailError and not empty xname --%>
	</c:choose>

	<c:choose>
		<c:when test="${(not empty xname or not empty person) and not empty personFolder}">
		
			<%-- Find the person's IG-description and image --%>
			 
			<c:if test="${not empty personContent}">
				<%-- Image should be language independent --%>
				<content:assetUrl id="imageUrl" contentId="${personContent.id}" assetKey="image" />
				<c:if test="${isAuthorized}">
					<management:language id="swedishVO" languageCode="sv"/>
					<management:language id="englishVO" languageCode="en"/>
					<content:contentVersion id="personContentSwedishVersion" useLanguageFallback="false" languageId="${swedishVO.languageId}" content="${personContent}" />
					<content:contentVersion id="personContentEnglishVersion" useLanguageFallback="false" languageId="${englishVO.languageId}" content="${personContent}" />
				</c:if>
				<%-- Person description is retrieved later --%>
			</c:if>

			<c:if test="${not empty param.userName}">
				<common:decrypt id="fullName" value="${param.userName}" />
			</c:if>

			<c:if test="${not empty persons[0].firstName or not empty persons[0].lastName}">
				<c:set var="fullName" value="${persons[0].firstName} ${persons[0].lastName}" />
			</c:if>
			
			<div class="personInformation">
				<c:if test="${not empty persons}">
					<c:set var="foundRecord" value="false" />
					<c:forEach var="person" items="${persons}" varStatus="loop">
										
						<%-------------------------------------------------%>
						<%-- Find the primary department for this person --%>
						<%-------------------------------------------------%>											
																
						<c:if test="${person['presentationOrder'] eq 1}">
							<c:set var="primaryDepartmentName" value="${person['departmentBottomName']}" />
							<c:set var="primaryDepartmentId" value="${person['departmentBottomId']}" />
						</c:if>
					
						<c:if test="${(person['departmentBottomId'] eq departmentId) or (empty departmentId and person['presentationOrder'] eq 1)}">
							<c:set var="foundRecord" value="true" />
							<div class="contactInformation">
								<p>
									<c:if test="${not empty fullName}">
										<span class="blockTitle"><c:out value="${fullName}" escapeXml="false" /></span><br/>
									</c:if>
									<c:if test="${not empty person.title}">
										<c:out value="${person.title}" escapeXml="false" /><br/>
									</c:if>
									<c:if test="${not empty person['email']}">
										<a href="mailto:<c:out value="${person['email']}" escapeXml="false" />"><c:out value="${person['email']}" escapeXml="false" /></a><br/>
									</c:if>
									<c:if test="${not empty person['phone']}">
										<structure:componentLabel mapKeyName="Phone"/>: <c:out value="${person['phone']}" escapeXml="false" /><br/>
									</c:if>
									<c:if test="${not empty person['mobile']}">
										<structure:componentLabel mapKeyName="Mobile"/>: <c:out value="${person['mobile']}" escapeXml="false" /><br/>
									</c:if>
								</p>
										
								<c:choose>
									<c:when test="${not empty dataBasePath}">
										<c:if test="${not empty person['departmentBottomId']}">	
											<c:set var="departmentId" value="${person['departmentBottomId']}" />
										</c:if>
										
										<c:choose>
											<c:when test="${empty departmentId and pc.isDecorated}">
												<p><structure:componentLabel mapKeyName="NoDepartmentId" /></p>
											</c:when>
											<c:when test="${not empty departmentId}">
												<c:catch var="departmentSearchException">
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
													<lucene:search id="departments" directory="${departmentDirectory}" query="departmentId:${departmentId}" />
												</c:catch>
												
												<c:if test="${not empty departmentSearchException}">
													<p class="adminError"><c:out value="${departmentSearchException}"/></p>
													<p class="adminError"><structure:componentLabel mapKeyName="IndexInitFailed"/> <c:out value="${departmentSearchException.message}"/> (<c:out value="${departmentSearchException.class.name}"/>)</p>
												</c:if>
											</c:when>
										</c:choose>
										
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
												
												<%-------------------------------------------------%>
												<%--          Print the department's data        --%>
												<%-------------------------------------------------%>
												
												<p>
													<span class="blockTitle"><c:out value="${department['departmentName']}" escapeXml="false"/></span>
													
													<common:urlBuilder id="departmentUrl" baseURL="${departmentDetailPageUrl}" includeCurrentQueryString="false">
														<common:parameter name="departmentId" value="${departmentId}" />
														<%--
															This code will create a duplicate languageId in Working but it is required
															for live to work.
														--%>
														<common:parameter name="languageId" value="${pc.languageId}" />
													</common:urlBuilder>
													
													(<a href="<c:out value="${departmentUrl}" />"><structure:componentLabel mapKeyName="MoreInfo"/></a>)
													<br/>
													<c:if test="${not empty department['postalAddress']}">
														<c:out value="${department['postalAddress']}" escapeXml="false"/><br/>
													</c:if>
													<c:if test="${not empty department['visitingAddress']}">
														<structure:componentLabel mapKeyName="VisitingAddress"/>: <c:out value="${department['visitingAddress']}" escapeXml="false"/><br/>
													</c:if>
													<c:if test="${not empty department['postalCode']}">
														<c:out value="${department['postalCode']}" escapeXml="false"/><br/>
													</c:if>
													<c:if test="${not empty department['webPage']}">
														<structure:componentLabel mapKeyName="WebPage"/>: <a href="<c:out value="${department['webPage']}" escapeXml="false"/>"><c:out value="${department['webPage']}" escapeXml="false"/></a><br/>
													</c:if>
													<c:if test="${not empty department['email']}">
														<structure:componentLabel mapKeyName="Email"/>: <a href="mailto:<c:out value="${department['email']}" escapeXml="false"/>"><c:out value="${department['email']}" escapeXml="false"/></a><br/>
													</c:if>
													<c:if test="${not empty department['phone']}">
														<structure:componentLabel mapKeyName="Phone"/>: <c:out value="${department['phone']}" escapeXml="false"/><br/>
													</c:if>
													<c:if test="${not empty department['fax']}">
														<structure:componentLabel mapKeyName="Fax"/>: <c:out value="${department['fax']}" escapeXml="false"/><br/>
													</c:if>
												</p>
											</c:otherwise>
										</c:choose>
									</c:when>
									<c:when test="${empty dataBasePath and pc.isDecorated}">
										<p><structure:componentLabel mapKeyName="NoKataGuOrgData"/></p>
									</c:when>
								</c:choose>
							</div>
						</c:if>
					</c:forEach>
					
					<c:if test="${not foundRecord and pc.isDecorated}">
						<div class="contactInformation">
							<p class="adminError">
								<structure:componentLabel mapKeyName="NoDepartmentAffiliationToShow"/>
							</p>
						</diV>
					</c:if>
					
					
					<c:if test="${not empty imageUrl or isAuthorized}">
						<div class="personImageDiv">
							<c:if test="${not empty imageUrl}">
								<div class="personImage" style="background-image: url(<c:out value="${imageUrl}"/>);"></div>
							</c:if>
							<c:if test="${isAuthorized and not empty personContents}">
								<form method="post" action="<c:out value="${currentPageUrl}" />" enctype="multipart/form-data">
									<fieldset>
										<input type="hidden" name="userAction" value="uploadImage" />
										<input type="hidden" name="selectedTab" value="<c:out value="${selectedTab}"/>" />
										<input type="hidden" name="contentId" value="<c:out value="${personContents[0].id}" />" />
										<input type="file" name="<structure:componentLabel mapKeyName="ChooseFile" />" value="<structure:componentLabel mapKeyName="ChooseFile" />" /><br/>
										<input type="submit" name="<structure:componentLabel mapKeyName="UploadFile" />" value="<structure:componentLabel mapKeyName="UploadFile" />" /><br/>
										<p>
											<structure:componentLabel mapKeyName="ImageInfo" />
										</p>
									</fieldset>
								</form>
							</c:if>
						</div>
					</c:if>
				</c:if>
			</div>

			<div class="personDescription">
				<c:choose>
					<c:when test="${not empty personContent}">
						<content:contentVersion id="personContentCurrentVersion" useLanguageFallback="false" languageId="${pc.languageId}" content="${personContent}" />
						<c:if test="${not empty personContentCurrentVersion}">
							<content:contentAttribute id="description" attributeName="Description" contentVersion="${personContentCurrentVersion}" useAttributeLanguageFallback="false" disableEditOnSight="true" />
						</c:if>

						<c:if test="${not empty description or isAuthorized}">
							<h2><structure:componentLabel mapKeyName="Description"/> <c:out value="${fullName}" escapeXml="false"/></h2>
							
							<div id="userDescriptionText">
								<c:out value="${description}" escapeXml="false" />
								<c:if test="${isAuthorized}">
									<form method="post" action="<c:out value="${currentPageUrl}" />">
										<fieldset>
											<input type="button" onclick="editUserText();" value="<structure:componentLabel mapKeyName="EditYourText" />" />
										</fieldset>
									</form>
								</c:if>
							</div>
							
							<%-- Notifies authorized users about missing language versions --%>
							<c:if test="${isAuthorized}">
								<management:language id="swedishVO" languageCode="sv"/>
								<management:language id="englishVO" languageCode="en"/>
								<%--
								Labels:
								MissingEnglishDescription_sv=Det finns ingen engelsk språkversion av din beskrivning. Besökare som visar denna sida på engelska kommer inte att se någon beskrivning.
MissingEnglishDescription_en=There is no english language version for your description. Visitors who view this site in english will not see a description.
MissingSwedishDescription_sv=Det finns ingen svensk spåkversion av din beskrivning. Besökare som visar denna sida på engelska kommer inte att se någon beskrivning.
MissingSwedishDescription_en=There is no swedish language version for your description. Visitors who view this site in svenska will not see a description.
								 --%>
								<c:choose>
									<c:when test="${pc.languageId eq swedishVO.languageId}">
										<c:if test="${empty personContentEnglishVersion}"><p class="missingDescription"><structure:componentLabel mapKeyName="MissingEnglishDescription"/></p></c:if>
									</c:when>
									<c:when test="${pc.languageId eq englishVO.languageId}">
										<c:if test="${empty personContentSwedishVersion}"><p class="missingDescription"><structure:componentLabel mapKeyName="MissingSwedishDescription"/></p></c:if>
									</c:when>
								</c:choose>
							</c:if>
						</c:if>
												
						<c:if test="${isAuthorized}">
							<div id="userDescriptionField">
								<form method="post" action="<c:out value="${currentPageUrl}" />">
									<fieldset>
										<input type="hidden" name="userDescriptionContentId" value="<c:out value="${personContents[0].id}"/>" />
										<input type="hidden" name="userAction" value="<c:out value="updatePersonalDescription"/>" />
										<input type="hidden" name="selectedTab" value="<c:out value="${selectedTab}"/>" />
										<input type="hidden" name="userName" value="<c:out value="${param.userName}"/>" />
										<textarea id="userDescription" name="userDescription" class="editDescriptionTextArea"><c:out value="${description}" escapeXml="false" /></textarea>
										<div class="editDescriptionControls">
											<input type="submit" value="<structure:componentLabel mapKeyName="SaveUserText" />" name="<structure:componentLabel mapKeyName="SaveUserText" />" />
											<input type="button" onclick="closeUserText();" value="<structure:componentLabel mapKeyName="Cancel" />" />
										</div>
									</fieldset>
								</form>
							</div>

							<script type="text/javascript">
								var oFCKeditor = new FCKeditor( 'userDescription' ) ;
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
								function editUserText()
								{
									$("#userDescriptionText").hide();
									$("#userDescriptionField").show();
								}
								
								function closeUserText()
								{
									$("#userDescriptionText").show();
									$("#userDescriptionField").hide();
								}
								<c:choose>
									<c:when test="${param.userAction eq 'hasCreatePersonalDescription'}">
										editUserText();
									</c:when>
									<c:otherwise>
										closeUserText();
									</c:otherwise>
								</c:choose>
							</script>
						</c:if>
					</c:when>
					<c:when test="${empty personContent and isAuthorized}">
						<h2><structure:componentLabel mapKeyName="Description"/> <c:out value="${fullName}" escapeXml="false"/></h2>
						<p><structure:componentLabel mapKeyName="NoTextCreateOne" /></p>
						
						<form method="post" action="<c:out value="${currentPageUrl}" />">
							<fieldset>
								<input type="hidden" name="primaryDepartmentId" value="<c:out value="${primaryDepartmentId}" />" />
								<input type="hidden" name="selectedTab" value="<c:out value="${selectedTab}"/>" />
								<input type="hidden" name="userAction" value="createPersonalDescription" />
								<input type="submit" value="<structure:componentLabel mapKeyName="CreateDescription" />" />
							</fieldset>
						</form>
					</c:when>
				</c:choose>
			</div>
			
			
		</c:when>
		<c:when test="${empty person}">
			<p><structure:componentLabel mapKeyName="PersonNotAffiliatedWithGU"/></p>
		</c:when>
	</c:choose>
</div>