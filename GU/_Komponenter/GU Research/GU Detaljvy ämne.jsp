<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="gup" prefix="gup" %>

<page:pageContext id="pc" />
<page:deliveryContext id="dc"/>
<page:deliveryContext id="dc" useFullUrl="true" disableNiceUri="false" trimResponse="true" operatingMode="0"/>

<structure:componentPropertyValue id="subjectId" propertyName="SubjectId" useInheritance="false"/>
<structure:pageUrl id="wysiwygConfigUrl" propertyName="WYSIWYGConfig" useInheritance="true" />
<content:content id="subjectDescriptionFolder" propertyName="SubjectDescriptionFolder" useInheritance="false"/>

<management:hasRole id="userIsAdmin" userName="${pc.principal.name}" roleName="Administrators" />
<management:hasRole id="userHasSubjectAdmin" userName="${pc.principal.name}" roleName="SubjectAdmin" />

<c:if test="${not empty param.subjectId}">
	<c:set var="subjectId" value="${param.subjectId}" />
</c:if>

<c:set var="slotName" value="${pc.componentLogic.infoGlueComponent.slotName}"/>
<%
	String slotName = (String)pageContext.getAttribute("slotName");
	String selectedTab = slotName.substring(slotName.length() - 1);
	pageContext.setAttribute("selectedTab", selectedTab);
%>

<c:set var="isAuthorized" value="${pc.isDecorated and (userHasSubjectAdmin or userIsAdmin)}"/>
<div class="guResearchComp subjectDetail">
	<c:choose>
		<c:when test="${empty subjectDescriptionFolder and pc.isDecorated}">
			<p class="adminError"><structure:componentLabel mapKeyName="NoFolderProvided" /></p>
		</c:when>
		<c:when test="${empty subjectId and pc.isDecorated}">
			<p class="adminError"><structure:componentLabel mapKeyName="NoSubject" /></p>
		</c:when>
		<c:when test="${not empty subjectId}">
			<c:if test="${isAuthorized}">
				<%-- Pad subjectId to equal length so that LIKE-search will work. --%>
				<%
					// When-tag guarentees that attribute exists
					Object subjectIdObject = pageContext.getAttribute("subjectId");
					if (subjectIdObject != null && subjectIdObject instanceof String)
					{
						Integer subjectId = 0;
						if (subjectIdObject instanceof String)
						{
							try 
							{
								subjectId = new Integer((String)subjectIdObject);
							}
							catch (NumberFormatException ex)
							{
								%><structure:componentLabel mapKeyName="SubjectIdMalformedString"/><%
								out.print((String)subjectIdObject);
							}
						}
						else if(subjectIdObject instanceof Integer)
						{
							subjectId = (Integer)subjectIdObject;
						}
						else
						{
							%><structure:componentLabel mapKeyName="SubjectIdUnknownType"/><%
							out.print(subjectIdObject.getClass().getName());
						}
						pageContext.setAttribute("subjectId", String.format("%010d", subjectId));
					}
				%>

				<page:pageAttribute id="subjectName" name="pageTitlePrefix" />
			
				<c:if test="${param.userAction eq 'createSubjectDescription'}">
					<structure:componentLabel id="defaultText" mapKeyName="DefaultDescriptionText" />
					<c:catch var="myException1">
						<content:contentTypeDefinition id="ctd" contentTypeDefinitionName="GU Amnesbeskrivning"/>			
						<content:remoteContentService id="rcs" operationName="createContents" principal="${pc.principal}">
							<content:contentParameter name="${subjectName}" parentContentId="${subjectDescriptionFolder.contentId}" contentTypeDefinitionId="${ctd.id}" repositoryId="${subjectDescriptionFolder.repositoryId}">
								<content:contentVersionParameter languageId="${dc.languageId}" allowHTMLContent="true" allowExternalLinks="false" allowAnchorSigns="true" allowDollarSigns="false">
									<content:contentVersionAttributeParameter name="SubjectId" value="${subjectId}"/>
									<content:contentVersionAttributeParameter name="Description" value="<p>${defaultText}</p>"/>
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
								<common:parameter name="userAction" value="hasCreateSubjectDescription"/>
							</common:urlBuilder>
							<common:sendRedirect url="${currentUrl}" />
						</c:otherwise>
					</c:choose>
				</c:if>
						
				<c:if test="${not empty param.subjectDescription}">
					<%
						String subjectDescription = (String)pageContext.getRequest().getParameter("subjectDescription");
						subjectDescription = subjectDescription.replaceAll("\\$(?!(\\.|\\(|templateLogic\\.(getPageUrl|getInlineAssetUrl|languageId)))", "&#36;");
						pageContext.setAttribute("subjectDescription", subjectDescription);
					%>
				
					<c:catch var="myException2">
						<content:updateContentVersion id="ucv" contentId="${param.subjectDescriptionContentId}" languageId="${dc.languageId}" stateId="1"
								allowHTMLContent="true" allowExternalLinks="true" allowAnchorSigns="true" allowDollarSigns="false">
							<content:contentVersionAttributeParameter name="SubjectId" value="${subjectId}"/> 
						    <content:contentVersionAttributeParameter name="Description" value="${subjectDescription}"/> 
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
	
			
			<c:choose>
				<c:when test="${not empty subjectId}">
					<content:matchingContents id="subjectList" freeText="${subjectId}" freeTextAttributeNames="SubjectId" 
						contentTypeDefinitionNames="GU Amnesbeskrivning" startNodeId="${subjectDescriptionFolder.contentId}" skipLanguageCheck="true" />
				    <c:set var="subjectContent" value="${subjectList[0]}" />
			        <c:choose>
				        <c:when test="${not empty subjectContent}">
							<content:contentAttribute id="description" contentId="${subjectContent.contentId}" attributeName="Description" disableEditOnSight="true"/>
							<h2><c:out value="${subjectName}" /></h2>
							
							<common:urlBuilder id="currentPageUrl" excludedQueryStringParameters="selectedTab" />

							<div id="subjectDescriptionText">
								<c:out value="${description}" escapeXml="false" />
								<c:if test="${isAuthorized}">
									<form method="post" action="<c:out value="${currentPageUrl}" />">
										<fieldset>
											<input type="button" onclick="editSubjectText();" value="<structure:componentLabel mapKeyName="EditYourText" />" />
										</fieldset>
									</form>
								</c:if>
							</div>
							
							<c:if test="${isAuthorized}">
								<div id="subjectDescriptionField">
									<form method="post" action="<c:out value="${currentPageUrl}" />">
										<fieldset>
											<input type="hidden" name="subjectDescriptionContentId" value="<c:out value="${subjectContent.id}"/>" />
											<input type="hidden" name="selectedTab" value="<c:out value="${selectedTab}"/>" />
											<textarea id="subjectDescription" name="subjectDescription" class="editDescriptionTextArea"><c:out value="${description}" escapeXml="false" /></textarea>
											<div class="editDescriptionControls">
												<input type="submit" value="<structure:componentLabel mapKeyName="SaveSubjectText" />" name="<structure:componentLabel mapKeyName="SaveSubjectText" />" />
												<input type="button" onclick="closeSubjectText();" value="<structure:componentLabel mapKeyName="Cancel" />" />
											</div>
										</fieldset>
									</form>
								</div>
								<script type="text/javascript">
									var oFCKeditor = new FCKeditor( 'subjectDescription' ) ;
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
									function editSubjectText()
									{
										$("#subjectDescriptionText").hide();
										$("#subjectDescriptionField").show();
									}
									
									function closeSubjectText()
									{
										$("#subjectDescriptionText").show();
										$("#subjectDescriptionField").hide();
									}
									<c:choose>
										<c:when test="${param.userAction eq 'hasCreateSubjectDescription'}">
											editSubjectText();
										</c:when>
										<c:otherwise>
											closeSubjectText();
										</c:otherwise>
									</c:choose>
								</script>
							</c:if>
						</c:when>
						<c:when test="${empty description and isAuthorized}">
							<h2><structure:componentLabel mapKeyName="SubjectDescription"/></h2>
							<p>
								<structure:componentLabel mapKeyName="NoTextCreateOne" />
							</p>
							<form method="post" action="<c:out value="${currentPageUrl}" />">
								<fieldset>
									<input type="hidden" name="userAction" value="createSubjectDescription" />
									<input type="hidden" name="selectedTab" value="<c:out value="${selectedTab}"/>" />
									<input type="submit" value="<structure:componentLabel mapKeyName="CreateDescription" />" />
								</fieldset>
							</form>
						</c:when>
					</c:choose>
				</c:when>
				<%-- Is this still used? -E
				<c:when test="${not empty subjectDetailError and pc.isDecorated}">
				    <p><c:out value="${subjectDetailError}" escapeXml="false" /></p>
				</c:when>--%>
			</c:choose>
		</c:when>
	</c:choose> <%-- empty subjectDescriptionFolder and pc.isDecorated --%>
</div>
