<%@ taglib prefix="c"         uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt"       uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="common"    uri="infoglue-common" %>
<%@ taglib prefix="content"   uri="infoglue-content" %>
<%@ taglib prefix="page"      uri="infoglue-page" %>
<%@ taglib prefix="structure" uri="infoglue-structure" %>
 
<page:pageContext id="pc"/>
<page:deliveryContext id="deliveryContext" disableNiceUri="false"/>

<structure:componentPropertyValue id="listTitle" propertyName="ListTitle" useInheritance="false"/>
<content:content id="itemFolder" propertyName="ItemFolder" useInheritance="false" />
<structure:componentLabel id="tableSummary" mapKeyName="TableSummary"/>

<c:if test="${empty listTitle}">
	<structure:componentLabel id="listTitle" mapKeyName="DefaultHeadline"/>
</c:if>

<content:childContents id="allItems" contentId="${itemFolder.id}" includeFolders="false"/>

<content:contentSort id="sortedItems" input="${allItems}" >
	<content:sortContentVersionAttribute name="Department" className="java.lang.String" ascending="true"/>
	<content:sortContentVersionAttribute name="Name" className="java.lang.String" ascending="true"/>
</content:contentSort>
 
<c:choose>
	<c:when test="${empty itemFolder}">
		<c:if test="${pc.isDecorated}">
			<h2><structure:componentLabel mapKeyName="DefaultHeadline"/></h2>
			<div class="adminMessage">
				<structure:componentLabel mapKeyName="NoFolderSelected"/>
			</div>
		</c:if>
	</c:when>
	<c:otherwise>
		<div class="contactDetailsList">
			<div class="innerContainer">
				<h2><c:out value="${listTitle}" escapeXml="false"/></h2>
				<table summary="<c:out value="${tableSummary}"/>">
					<tr>
						<th><structure:componentLabel mapKeyName="Name"/></th>
						<th><structure:componentLabel mapKeyName="ExternalTitle"/></th>
						<th><structure:componentLabel mapKeyName="ExternalPhone"/></th>
					</tr>
					<c:forEach var="item" items="${sortedItems}" varStatus="count">  
						<c:if test="${not empty item}">
							<content:contentAttribute id="name" contentId="${item.contentId}" attributeName="Name" disableEditOnSight="true"/>
					 	 	<content:contentAttribute id="externalTitle" contentId="${item.contentId}" attributeName="ExternalTitle" disableEditOnSight="true"/>
					 	 	<content:contentAttribute id="externalPhone" contentId="${item.contentId}" attributeName="ExternalPhone" disableEditOnSight="true"/>						
								 	 	
					 	 	<structure:pageUrl id="detailUrl" propertyName="DetailPage" contentId="${item.id}" useInheritance="false"/>
										
							<tr>
								<td>
									<c:out value="${name}" escapeXml="false"/>
								</td>
								<td>
									<c:out value="${externalTitle}" escapeXml="false"/>
								</td>
								<td>
									<c:out value="${externalPhone}" escapeXml="false"/>
								</td>
							</tr>
						</c:if>
					</c:forEach>
				</table>
			</div>
		</div>
	</c:otherwise>
</c:choose>
	