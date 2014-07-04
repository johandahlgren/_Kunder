<%@ page import="java.util.*,java.io.*"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jstl/core"%>
<%@ taglib prefix="common" uri="infoglue-common"%>
<%@ taglib prefix="content" uri="infoglue-content"%>
<%@ taglib prefix="page" uri="infoglue-page"%>
<%@ taglib prefix="structure" uri="infoglue-structure"%>
<%@ taglib uri="infoglue-management" prefix="management"%>

<page:pageContext id="pc" />
<page:deliveryContext id="dc" operatingMode="0"/>

<management:language id="saveLanguage" languageCode="sv"/>

<content:content id="personFolder" propertyName="PersonFolder" />

<h2>
	<structure:componentLabel mapKeyName="titleLabel" />
</h2>
<%--
<c:if test="${empty personFolder}">
	<structure:componentLabel mapKeyName="NoPersonFolderSelected" />
</c:if>
 --%>
<content:contentTypeDefinition id="ctd"	contentTypeDefinitionName="GUPersonal" />
<common:urlBuilder id="currentPageUrl" excludedQueryStringParameters="userAction,linkToRemove,newLinkURL,newLinkTitle" />


<management:principalProperty id="userLinks" principal="${pc.principal}" attributeName="Links" />


<%-- Find the user's content so we can read and store data on it --%>
	<%--	
<content:matchingContents id="personContents" freeText="Portal_${pc.principal.name}" freeTextAttributeNames="UserId" contentTypeDefinitionNames="GUPersonal" skipLanguageCheck="true" startNodeId="${personFolder.contentId}" />
<c:if test="${not empty personContents}">
	<c:set var="personContentId" value="${personContents[0].id}" />
	<content:contentAttribute id="userLinks" attributeName="Links" contentId="${personContentId}" disableEditOnSight="true"/>
</c:if>
--%>
<%
	String links 			= (String)pageContext.getAttribute("userLinks");
	String newLinkUrl		= (String)request.getParameter("newLinkURL");
	String newLinkTitle		= (String)request.getParameter("newLinkTitle");
	Integer linkToRemove 	= null;
	if (request.getParameter("linkToRemove") != null)
	{
		linkToRemove 		= new Integer((String)request.getParameter("linkToRemove"));
	}

	if (links == null)
	{
		links = "";
	}
%>

<c:if test="${param.userAction eq 'addLink' or param.userAction eq 'removeLink'}">	
	<c:choose>
		<c:when test="${param.userAction eq 'addLink'}">
			<% 
				if(links != null && !newLinkUrl.isEmpty() && !newLinkTitle.isEmpty())
				{
					links += newLinkTitle + "," + newLinkUrl + "|";
				}
				pageContext.setAttribute("updateLinks", links);
			%>
		</c:when>
		<c:when test="${param.userAction eq 'removeLink'}">
			<%
				if(linkToRemove != null)
				{
					StringTokenizer st = new StringTokenizer(links, "|");
					int index = 0;
					String temp = "";
					while (st.hasMoreTokens()) 
					{
						String token 	= st.nextToken();
						if (index != linkToRemove.intValue())
						{
							temp += token + "|";
						}
						index ++;
					}
					pageContext.setAttribute("updateLinks", temp);
				}
			%>
		</c:when>
	</c:choose>	

	
	
	<management:remoteUserPropertiesService principal="${pc.principal}" id="result" contentTypeDefinitionId="${ctd.contentTypeDefinitionId}"  operationName="updateUserProperties" forcePublication="true" languageId="${pc.languageId}" keepExistingAttributes="true">
		<management:userPropertiesAttributeParameter name="Links" value="${updateLinks}" />
	</management:remoteUserPropertiesService>
	
	<c:choose>
		<c:when test="${result ne true}">
	    	result: <c:out value="${result}" />
			<br />
		</c:when>
		<c:otherwise>
			<common:urlBuilder id="url" excludedQueryStringParameters="userAction,refresh" >
				<common:parameter name="userAction" value="editLinks" />
				<common:parameter name="refresh" value="true" />
			</common:urlBuilder>
			<common:sendRedirect url="${url}" />
		</c:otherwise>
	</c:choose>
	
		<%--
	<c:catch var="myException">
		<c:choose>
			<c:when test="${empty personContentId}">
				
				<%-- If the user's content does not yet exist, we create it --%>
				<%--
				<content:contentTypeDefinition id="ctd" contentTypeDefinitionName="GUPersonal"/>			
				<content:remoteContentService id="rcs" operationName="createContents" principal="${pc.principal}">
					<content:contentParameter name="Portal_${pc.principal.name}" parentContentId="${personFolder.contentId}" contentTypeDefinitionId="${ctd.id}" repositoryId="${personFolder.repositoryId}">
						<content:contentVersionParameter languageId="${saveLanguage.id}" allowHTMLContent="true" allowExternalLinks="true" allowAnchorSigns="true" allowDollarSigns="false">
							<content:contentVersionAttributeParameter name="UserId" value="Portal_${pc.principal.name}"/>
							<content:contentVersionAttributeParameter name="Links" value="${updateLinks}"/>
						</content:contentVersionParameter>
					</content:contentParameter>
				</content:remoteContentService>
			</c:when>
			<c:otherwise>
			
				<%-- Store the links on the user's content --%>
				<%--
				<content:updateContentVersion id="ucv" contentId="${personContentId}" languageId="${saveLanguage.id}" stateId="1" keepExistingAttributes="true" allowHTMLContent="true" allowExternalLinks="true" allowAnchorSigns="true" allowDollarSigns="false">
					<content:contentVersionAttributeParameter name="Links" value="${updateLinks}"/> 
				</content:updateContentVersion>
			</c:otherwise>
		</c:choose>
	</c:catch>
	
	<c:choose>
		<c:when test="${myException != null}">
			<structure:componentLabel mapKeyName="AnErrorOccuredWhenSavingContent" />: <c:out value="${myException.message}"/>
		</c:when>
		<c:otherwise>
			<common:urlBuilder id="url" excludedQueryStringParameters="userAction,refresh" >
				<common:parameter name="userAction" value="editLinks" />
				<common:parameter name="refresh" value="true" />
			</common:urlBuilder>
			<common:sendRedirect url="${url}" />
		</c:otherwise>
	</c:choose>--%>
</c:if>

<c:if test="${param.refresh eq 'true'}">
	<page:deliveryContext id="dc" disablePageCache="true" />
</c:if>

<div class="portalLinks">
	<c:if test="${not empty userLinks}">
		<ul class="portalLinks">
			<%
				if (links != null) 
				{
					StringTokenizer st = new StringTokenizer(links, "|");
					int index = 0;
					while (st.hasMoreTokens()) 
					{
						String token 	= st.nextToken();
						String[] link 	= token.split(",");
						String linkText = link[0];
						String linkUrl	= link[1];
						if (!linkUrl.startsWith("http://")) 
						{
							linkUrl = "http://" + linkUrl;
						}
						pageContext.setAttribute("linkText", linkText);
						pageContext.setAttribute("linkUrl", linkUrl);
						pageContext.setAttribute("index", index);
						%>
						<li>
							<a href="<c:out value="${linkUrl}" />" target="_blank" class="portalLink"><c:out value="${linkText}" /></a>
							<%--<c:if test="${param.userAction eq 'editLinks'}">--%>
								<common:urlBuilder id="removeUrl" excludedQueryStringParameters="userAction" >
									<common:parameter name="userAction" value="removeLink" />
									<common:parameter name="linkToRemove" value="${index}" />
								</common:urlBuilder>
							
								<a href="<c:out value="${removeUrl}" />" class="removeLink" title="<structure:componentLabel mapKeyName="DeleteLinkTitleText" />">
									<img src="<content:assetUrl assetKey="cross_delete" propertyName="ImageAssets"/>" alt="<structure:componentLabel mapKeyName="DeleteLinkAltText" />" 
										onmouseover="this.src='<content:assetUrl assetKey="cross_delete_hover" propertyName="ImageAssets"/>'"
										onmouseout="this.src='<content:assetUrl assetKey="cross_delete" propertyName="ImageAssets"/>'"
										onmousedown="this.src='<content:assetUrl assetKey="cross_delete_active" propertyName="ImageAssets"/>'"
										onmouseup="this.src='<content:assetUrl assetKey="cross_delete" propertyName="ImageAssets"/>'"
									/>
								</a>
							<%--</c:if>--%>
						</li>
						<%
						index ++;
					}
				}												
			%>
		</ul>
	</c:if>
	
	<div class="portalLinksForm">
		<%--
		<c:choose>
			<c:when test="${param.userAction eq 'editLinks'}">
		--%>
				<form method="post" action="<c:out value="${currentPageUrl}" />">
					<fieldset>
						<input type="hidden" name="userAction" value="addLink" />  
						<input id="linkTitleText" class="portalLinkField" type="text" name="newLinkTitle" value="<structure:componentLabel mapKeyName="NewLinkTitleLabel" />" title="<structure:componentLabel mapKeyName="NewLinkTitleLabel" />"/>
						<input id="linkText" class="portalLinkField" type="text" name="newLinkURL" value="<structure:componentLabel mapKeyName="NewLinkUrlLabel" />" title="<structure:componentLabel mapKeyName="NewLinkUrlLabel" />"/>
						<input type="submit" id="portalSaveButton" class="button portalButton" value="<structure:componentLabel mapKeyName="LinkButtonLabel" />" title="<structure:componentLabel mapKeyName="LinkButtonLabel" />"/>
					</fieldset>
				</form>
				<%--
				<form method="post" action="<c:out value="${currentPageUrl}" />" >
					<input type="hidden" name="userAction" value="displayLinks" />
					<input type="submit" class="portalButton" value="<structure:componentLabel mapKeyName="FinishedLabel" />" />
				</form>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${empty userLinks}">
						<structure:componentLabel id="buttonLabel" mapKeyName="CreateLinks" />
						<p>
							<structure:componentLabel mapKeyName="NoLinksCreateOne" />
						</p>
					</c:when>
					<c:otherwise>
						<structure:componentLabel id="buttonLabel" mapKeyName="EditLinks" />
					</c:otherwise>
				</c:choose>
				<form method="post" action="<c:out value="${currentPageUrl}" />">
					<fieldset>
						<input type="hidden" name="userAction" value="editLinks" />
						<input type="submit" class="portalButton" value="<c:out value="${buttonLabel}" />"	name="linkEdit" />
					</fieldset>
				</form>
			</c:otherwise>
		</c:choose>
		--%>
	</div>
</div>