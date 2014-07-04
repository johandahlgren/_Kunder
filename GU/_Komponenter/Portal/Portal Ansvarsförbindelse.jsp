<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<page:pageContext id="pc"/>

<content:contentAttribute id="contractText" attributeName="FullText" propertyName="PortalContract" disableEditOnSight="true"/>
<content:contentAttribute id="contractTitle" attributeName="Title" propertyName="PortalContract" disableEditOnSight="true"/>
<content:content id="eulaList" propertyName="EULAList" useInheritance="true" />
<management:language id="saveLanguage" languageCode="sv"/>
<common:urlBuilder id="currentPageUrl" excludedQueryStringParameters="userAction,confirmed,refresh" />
<content:contentAttribute id="approvedUsers" contentId="${eulaList.contentId}" attributeName="ApprovedUsers" disableEditOnSight="true"/>
<c:set var="principal" value="${pc.principal.name}" />

<c:if test="${param.confirmed eq 'on'}">
	<c:catch var="myException">
	<%
		String userName 		= (String) pageContext.getAttribute("principal");
		String approvedUsers 	= (String) pageContext.getAttribute("approvedUsers");
		
		if(userName != null && approvedUsers != null){
			approvedUsers += userName+",";
			pageContext.setAttribute("approvedUsers", approvedUsers);
		}
	%>
		<content:updateContentVersion id="ucv" contentId="${eulaList.contentId}" languageId="${saveLanguage.id}" stateId="1" keepExistingAttributes="true" allowHTMLContent="true" allowExternalLinks="true" allowAnchorSigns="true" allowDollarSigns="false">
			<content:contentVersionAttributeParameter name="ApprovedUsers" value="${approvedUsers}"/> 
		</content:updateContentVersion>
	</c:catch>
	
	<c:choose>
		<c:when test="${myException != null}">
			<structure:componentLabel mapKeyName="AnErrorOccuredWhenResetingContent" />: <c:out value="${myException.message}"/>
		</c:when>
		<c:otherwise>
			<common:urlBuilder id="url" excludedQueryStringParameters="confirmed,refresh,userAction" >
				<common:parameter name="refresh" value="true" />
			</common:urlBuilder>
			<common:sendRedirect url="${url}" />
		</c:otherwise>
	</c:choose>				
</c:if>

<div class="col25">
<%--
	<div id="menuComp">
	</div>
 --%>
</div>

<div class="col50">
	<a name="content"></a>
	<div class="eulaAgreement">
		<structure:componentLabel id="submitLabel" mapKeyName="ContractSubmitButton"/>
		<structure:componentLabel id="cancelLabel" mapKeyName="ContractCancelButton"/>
	
		<c:if test="${(empty param.confirmed and param.userAction eq submitLabel) or param.userAction eq cancelLabel}">
			<p class="red">
				<structure:componentLabel mapKeyName="ContractNotConfirmed"/>
			</p>		
		</c:if>
		
		<h1><c:out value="${contractTitle}" escapeXml="false" /><%--<structure:componentLabel mapKeyName="DefaultTitle"/>--%></h1>
		
		<p><c:out value="${contractText}" escapeXml="false" /></p>
		
		
		<form method="post" action="<c:out value="${currentPageUrl}"/>">
			<fieldset>
				<input type="checkbox" name="confirmed">
				<label for="confirmed"><structure:componentLabel mapKeyName="ContractConfirmLabel"/></label>
				<div>
					<input type="submit" value="<c:out value="${submitLabel}" />" name="userAction"/>
					<input type="submit" value="<c:out value="${cancelLabel}" />" name="userAction"/>
				</div>
			</fieldset>
		</form>
	</div>
</div>

<div class="col25">
	
</div>

	