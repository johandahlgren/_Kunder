<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-management" prefix="management" %>

<%@page import="java.util.Calendar"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<page:pageContext id="pc"/>

<content:content id="conference" propertyName="Conference" useInheritance="false" />
<structure:componentPropertyValue id="onlyShowEssentialData" propertyName="OnlyShowEssentialData" useInheritance="true"/>

<c:if test="${not empty param.contentId}">
	<content:content id="conference" contentId="${param.contentId}" />
</c:if>

<c:choose>
	<c:when test="${empty conference and pc.isDecorated}">
		<div class="adminMessage"><structure:componentLabel mapKeyName="NoConferenceSelected"/></div>
	</c:when>
	<c:otherwise>
		<content:contentAttribute id="title" attributeName="Title" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="timeExtra" attributeName="TimeExtra" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="place" attributeName="Place" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="placeExtra" attributeName="PlaceExtra" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="cost" attributeName="Cost" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="costExtra" attributeName="CostExtra" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="startDate" attributeName="StartDate" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="endDate" attributeName="EndDate" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="contactPersonName" attributeName="ContactPersonName" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="contactPersonPhone" attributeName="ContactPersonPhone" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="registrationEndDate" attributeName="RegistrationEndDate" contentId="${conference.id}" disableEditOnSight="true" />
		<content:contentAttribute id="conferenceProgrammeFileName" attributeName="ConferenceProgrammeFileName" contentId="${conference.id}" disableEditOnSight="true" />
		<content:assets id="assets" contentId="${conference.id}" />		
		
		<%
			try
			{
				SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		        Date myDate = formatter.parse((String)pageContext.getAttribute("startDate"));
		        pageContext.setAttribute("startDate", myDate);
		    }
			catch (Exception e)
			{
				//Do nothing. Use the original value.
			}
			
			try
			{  
		        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm");
		        Date myDate = formatter.parse((String)pageContext.getAttribute("endDate"));
		        pageContext.setAttribute("endDate", myDate);
			}
			catch (Exception e)
			{
				//Do nothing. Use the original value.
			}
		%>
	
		<div class="textBox">
			<div class="innerContainer">
				<div id="conferenceDetails">
					<h2><structure:componentLabel mapKeyName="ConferenceFacts"/></h2>
					<c:if test="${onlyShowEssentialData eq 'yes'}">
						<h3><structure:componentLabel mapKeyName="SelectedConference"/></h3>
						<c:out value="${title}" />
					</c:if>
					<h3><structure:componentLabel mapKeyName="DateAndTime"/></h3>
					<p>
						<span>
							<common:formatter value="${startDate}" pattern="dd MMMM yyyy"/>
						</span>
						<span>
							<common:formatter value="${startDate}" pattern="HH:mm"/> &ndash; <common:formatter value="${endDate}" pattern="HH:mm"/>
						</span>
						<span class="extraInfo"><c:out value="${timeExtra}"/></span>
					</p>
					<%--<p>
						<span>
							<common:formatter value="${endDate}" pattern="dd MMMM yyyy"/>
						</span>
						<span>
							
						</span>
						<span class="extraInfo"><c:out value="${timeExtra}"/></span>
					</p>--%>
					<h3><structure:componentLabel mapKeyName="Location"/></h3>
					<p>
						<span><c:out value="${place}"/></span>
						<span class="extraInfo"><c:out value="${placeExtra}"/></span>
					</p>
					<c:if test="${onlyShowEssentialData ne 'yes'}">
						<h3><structure:componentLabel mapKeyName="Fee"/></h3>
						<p>
							<c:choose>
								<c:when test="${not empty cost}">
									<span><c:out value="${cost}"/></span>
									<span class="extraInfo"><c:out value="${costExtra}"/></span>
								</c:when>
								<c:otherwise>
									<structure:componentLabel mapKeyName="FreeConference"/>
								</c:otherwise>
							</c:choose>
						</p>
						<h3><structure:componentLabel mapKeyName="ContactPerson"/></h3>
						<p>
							<span>
								<c:out value="${contactPersonName}"/>
							</span>
							<span>
								<structure:componentLabel mapKeyName="Phone"/>: <c:out value="${contactPersonPhone}"/>
							</span>
						</p>                                            
						<h3><structure:componentLabel mapKeyName="ConferenceProgram"/></h3>
						<ul>
							<c:forEach var="asset" items="${assets}">
								<content:assetFilePath id="assetPath" digitalAssetId="${asset.id}" />
								<content:assetUrl id="assetUrl" digitalAssetId="${asset.id}" />
								<c:if test="${asset.assetKey eq conferenceProgrammeFileName}">
									<common:formatter id="assetFileSize" type="fileSize" value="${asset.assetFileSize}" />
									<li><a href="<c:out value="${assetUrl}" />" class="pdfLink" target="_blank"><structure:componentLabel mapKeyName="DownloadPdf"/> (<c:out value="${assetFileSize}" />)</a></li>
								</c:if>
							</c:forEach>
						</ul>
						<!-- eri-no-index -->
						<h3><structure:componentLabel mapKeyName="Application"/></h3>
						
						<%
							String registrationEndDateString = (String)pageContext.getAttribute("registrationEndDate");
							SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
							if (registrationEndDateString != null && !"".equals(registrationEndDateString))
							{
								try
								{
									Date date = sdf.parse(registrationEndDateString);
									Calendar cal = Calendar.getInstance();
									cal.setTime(date);
									cal.set(Calendar.HOUR_OF_DAY, 23);
									cal.set(Calendar.MINUTE, 59);
									cal.set(Calendar.SECOND, 59);
									pageContext.setAttribute("registrationEndDate", cal.getTime());
									
									Date todaysDate = new Date();
									pageContext.setAttribute("todaysDate", todaysDate);
								}
								catch (ParseException ex)
								{
									%><div class="adminMessage"><structure:componentLabel mapKeyName="RegistrationDateParseError" />: <c:out value="${registrationEndDateString}"/></div><%
								}
							}
						%>

						<c:choose>
							<c:when test="${registrationEndDate > todaysDate}">
								<p><structure:componentLabel mapKeyName="Latest"/> <common:formatter value="${registrationEndDate}" pattern="dd MMMM yyyy"/></p>
								<ul>
									<structure:pageUrl id="applicationUrl" propertyName="ConferenceApplicationPage" contentId="${conference.contentId}" />
									<li><a href="<c:out value="${applicationUrl}" escapeXml="false" />"><structure:componentLabel mapKeyName="Apply"/></a></li>
								</ul>
							</c:when>
							<c:otherwise>
								<p><structure:componentLabel mapKeyName="ApplicationDateHasPassed"/></p>
							</c:otherwise>
						</c:choose>
						<!-- /eri-no-index -->
					</c:if>
				</div>
			</div>
		</div>
		
	</c:otherwise>
</c:choose>
