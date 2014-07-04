<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-common" prefix="common" %>

<%@page import="java.util.HashMap"%>
<%@page import="java.util.ArrayList"%>
<%@page import="java.util.Collections"%>
<%@page import="java.util.Random"%>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="text" propertyName="Text" useInheritance="false"/>
<structure:componentPropertyValue id="emailRecipient" propertyName="EmailRecipient" useInheritance="false"/>

<!-- eri-no-index -->

<c:if test="${empty title}">
	<structure:componentLabel id="title" mapKeyName="DefaultTitle"/>
</c:if>
<c:if test="${empty text}">
	<structure:componentLabel id="text" mapKeyName="DefaultText"/>
</c:if>

<c:if test="${empty emailRecipient and pc.isDecorated}">
	<div class="adminMessage">
		<structure:componentLabel mapKeyName="NoEmailRecipient"/>
	</div>
</c:if>

<%-- Field validation --%>

<c:set var="errorHasOccured" value="false" />

<c:if test="${param.sendMail eq 'true'}">
	<c:set var="errorMessage">
		<c:if test="${empty param.name}"><c:set var="nameError" value="errorField" /><c:set var="errorHasOccured" value="true" /></c:if>
		<c:if test="${empty param.address}"><c:set var="addressError" value="errorField" /><c:set var="errorHasOccured" value="true" /></c:if>
		<c:if test="${empty param.zipCode}"><c:set var="zipCodeError" value="errorField" /><c:set var="errorHasOccured" value="true" /></c:if>
		<c:if test="${empty param.city}"><c:set var="cityError" value="errorField" /><c:set var="errorHasOccured" value="true" /></c:if>
		<c:if test="${empty param.email}"><c:set var="emailError" value="errorField" /><c:set var="errorHasOccured" value="true" /></c:if>
	</c:set>
		
	<c:if test="${param.topphemligNyckel ne 'nobot' and param.hemligValideringskod ne param.publikValideringskod}">
		<structure:componentLabel id="errorMessage" mapKeyName="BotAttack"/>
		<c:set var="captchaError" value="errorField" />
		<c:set var="errorHasOccured" value="true" />
	</c:if>
</c:if>

<div id="pageIntro">
	<div class="innerContainer">
		<c:if test="${not empty title}"><h1><c:out value="${title}" /></h1></c:if>
		<c:if test="${param.sendMail ne 'true'}">
			<c:if test="${not empty text}"><p><c:out value="${text}" /></p></c:if>
		</c:if>
	</div>
</div>
	
<div id="pageMainContent">
	<div class="innerContainer">
		<c:if test="${errorHasOccured}">
			<div class="errorMessage">
				<div class="formError">
					<h2><structure:componentLabel mapKeyName="ErrorHasOccured"/></h2>
					<p>
						<structure:componentLabel mapKeyName="ErrorMessage"/>
					</p>
				</div>			
			</div>
		</c:if>
	</div>
</div>

<c:choose>
	<c:when test="${param.sendMail eq 'true' and not errorHasOccured}">
		<structure:componentLabel id="emailSubject" mapKeyName="EmailSubject"/>
		
		<c:set var="message">
			<common:include relationAttributeName="RelatedComponents" contentName="Mail rapportbeställning" />
		</c:set>
				
		<common:mail id="mailStatus" from="${param.email}" to="${emailRecipient}" subject="${emailSubject}" type="text/html" charset="utf-8" message="${message}"/>
		
		<c:choose>
			<c:when test="${mailStatus}">
				<div id="confirmationMessage">
					<div class="innerContainer">             
						<h2><structure:componentLabel mapKeyName="ThankYouTitle"/></h2>
						<p><structure:componentLabel mapKeyName="ThankYouText"/></p>
					</div>
					<script type="text/javascript">
						$(document).ready(function() 
						{
							deleteCookie("ISF_rapportkorg");
							updateShoppingBasket(false, false);
						});
					</script>
				</div>
			</c:when>
			<c:otherwise>
				<c:choose>
					<c:when test="${commonMailTagException.class.name eq 'javax.mail.internet.AddressException'}">
						<h1><c:out value="${commonMailTagException.message}"/></h1>
						<p>
							<a href="javascript:history.go(-1);"><structure:componentLabel mapKeyName="Back"/></a>
						</p>
					</c:when>
					<c:otherwise>
						<p>
							<structure:componentLabel mapKeyName="ErrorMessage"/>
						</p>
						<p>
							(<c:out value="${commonMailTagException.message}"/>)
						</p>
						<p>
							<a href="javascript:history.go(-1);"><structure:componentLabel mapKeyName="Back"/></a>
						</p>
					</c:otherwise>
				</c:choose>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<script type="text/javascript">
			function setKey()
			{
				$("#topphemligNyckel").val("nobot");
			}
		</script>
		
		<common:urlBuilder id="currentPage" />
		
		<form onsubmit="setKey();" action="<c:out value="${currentPage}"/>" method="post">
			<div id="orderList">
				<div class="innerContainer">
					<h2><structure:componentLabel mapKeyName="ReportsInTheBasket"/></h2>
					<table summary="Tabellen presenterar de publikationer som lagts i beställningskorgen">
						<tr>
							<th scope="col"><structure:componentLabel mapKeyName="Title"/></th>
							<th scope="col"><structure:componentLabel mapKeyName="ReportNumber"/></th>
							<th scope="col"><structure:componentLabel mapKeyName="Amount"/></th>
							<th scope="col" class="remove" style="display: table-cell;"><span><structure:componentLabel mapKeyName="Remove"/></span></th>
						</tr>
						
						<c:choose>
							<c:when test="${not empty param.directOrderReport}">
								<c:set var="reportId" value="${param.directOrderReport}" />
								<content:contentAttribute id="reportName" contentId="${reportId}" attributeName="Title" disableEditOnSight="true" />
								<content:contentAttribute id="reportNumber" contentId="${reportId}" attributeName="ReportNumber" disableEditOnSight="true" />
								<c:set var="reportAmount" value="1" />
								<tr>
									<structure:pageUrl id="detailPageUrl" propertyName="PublicationDetailPage" contentId="${reportId}" useInheritance="true"/>
									
									<td><a href="<c:out value="${detailPageUrl}" />"><c:out value="${reportName}" /></a></td>
									<td><c:out value="${reportNumber}" /></td>
									<td><input type="text" name="report_<c:out value="${reportId}" />" value="<c:out value="${reportAmount}" />" /></td>
									<td class="remove" style="display: table-cell;"><a href="#" data-reportid="<c:out value="${reportId}" />"><structure:componentLabel mapKeyName="Remove"/></a></td>
								</tr>
							</c:when>
							<c:otherwise>
								<common:getCookie id="cookieValues" name="ISF_rapportkorg"/>	
								<%
									String temp = (String)pageContext.getAttribute("cookieValues");
																														
									if (temp != null && !temp.trim().equals(""))
									{
										String[] reports 				= temp.split("\\|");
										ArrayList<String[]> myArrayList = new ArrayList<String[]>();
										String[] item					= null;
																								
										for (int i = 0; i < reports.length; i++)
										{
											item = reports[i].split("#");
											if (item.length > 1 && !item[1].equals("0"))
											{
												myArrayList.add(item);
											}
										}
										
										pageContext.setAttribute("reports", myArrayList);
									}
								%>
								<c:forEach var="report" items="${reports}" varStatus="loop">
									<c:remove var="reportSize"/>
									<%
										String[] tempReport = (String[])pageContext.getAttribute("report");
										pageContext.setAttribute("includeReport", false);
										if (tempReport != null && tempReport instanceof Object[])
										{
											if (tempReport.length == 2)
											{
												try
												{
													Object reportIdObj = Integer.parseInt(tempReport[0]);
													pageContext.setAttribute("includeReport", true);
												}
												catch (NumberFormatException ex)
												{ /* Do not set includeReport=true if reportId was not a number */ }
											}
										}
									%>
									<c:if test="${includeReport}">
										<c:set var="reportId" value="${report[0]}" />
										<c:set var="reportAmount" value="${report[1]}" />
										
										<content:contentAttribute id="reportName" contentId="${reportId}" attributeName="Title" disableEditOnSight="true" />
										<content:contentAttribute id="reportNumber" contentId="${reportId}" attributeName="ReportNumber" disableEditOnSight="true" />
																			
										<tr>
											<structure:pageUrl id="detailPageUrl" propertyName="PublicationDetailPage" contentId="${reportId}" useInheritance="true"/>
											
											<td><a href="<c:out value="${detailPageUrl}" escapeXml="false" />"><c:out value="${reportName}" /></a></td>
											<td><c:out value="${reportNumber}" /></td>
											<td><input id="report_<c:out value="${reportId}" />" type="text" name="report_<c:out value="${reportId}" />" value="<c:out value="${reportAmount}" />" onkeyup="setNumberOfReports(<c:out value="${reportId}" />, this.value, false);"/></td>
											<td class="remove" style="display: table-cell;"><a href="#" data-reportid="<c:out value="${reportId}" />"><structure:componentLabel mapKeyName="Remove"/></a></td>
										</tr>
									</c:if>
								</c:forEach>
							</c:otherwise>
						</c:choose>
					</table>
				</div>
			</div>
				
			<div id="orderForm">
				<div class="innerContainer">
					<fieldset>
						<input type="hidden" name="sendMail" value="true" />
						<input id="topphemligNyckel" name="topphemligNyckel" type="hidden" value="" />
						
						<legend><structure:componentLabel mapKeyName="Legend"/></legend>
						
						<div class="fieldCol <c:out value="${nameError}" />">
							<label for="name"><structure:componentLabel mapKeyName="Name"/> <c:if test="${not empty nameError}"><span class="formError">(<structure:componentLabel mapKeyName="MandatoryField"/>)</span></c:if></label>
							<input type="text" id="name" name="name" value="<c:out value="${param.name}" />" />
						</div>
						<div class="fieldCol">
							<label for="organisation"><structure:componentLabel mapKeyName="Organisation"/></label>
							<input type="text" id="organisation" name="organisation" value="<c:out value="${param.organisation}" />" />
						</div>
						<div class="fieldCol <c:out value="${addressError}" />">
							<label for="address"><structure:componentLabel mapKeyName="Address"/> <c:if test="${not empty addressError}"><span class="formError">(<structure:componentLabel mapKeyName="MandatoryField"/>)</span></c:if></label>
							<input type="text" id="address" name="address" value="<c:out value="${param.address}" />" />
						</div>
						<div class="fieldCol zipCode <c:out value="${zipCodeError}" />">
							<label for="zipCode"><structure:componentLabel mapKeyName="ZipCode"/> <c:if test="${not empty zipCodeError}"><span class="formError">(<structure:componentLabel mapKeyName="MandatoryField"/>)</span></c:if></label>
							<input type="text" id="zipCode" name="zipCode" value="<c:out value="${param.zipCode}" />" />
						</div>
						<div class="fieldCol city <c:out value="${cityError}" />">
							<label for="city"><structure:componentLabel mapKeyName="City"/> <c:if test="${not empty cityError}"><span class="formError">(<structure:componentLabel mapKeyName="MandatoryField"/>)</span></c:if></label>
							<input type="text" id="city" name="city" value="<c:out value="${param.city}" />" />
						</div>
						<div class="fieldCol <c:out value="${emailError}" />">
							<label for="email"><structure:componentLabel mapKeyName="Email"/> <c:if test="${not empty emailError}"><span class="formError">(<structure:componentLabel mapKeyName="MandatoryField"/>)</span></c:if></label>
							<input type="text" id="email" name="email" value="<c:out value="${param.email}" />" />
						</div>
						<noscript>
							<%
								String AB 	= "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
								Random rnd 	= new Random();
								int stringLength	= 3;
								
								StringBuilder sb = new StringBuilder(stringLength);
								for(int i = 0; i < stringLength; i++) 
								{
									sb.append(AB.charAt(rnd.nextInt(AB.length())));
								}
								pageContext.setAttribute("secretCode", sb.toString());
							%>
							<div class="fieldCol <c:out value="${captchaError}" />">
								<input type="hidden" id="hemligValideringskod" name="hemligValideringskod" value="<c:out value="${secretCode}"/>"/>
								<label for="publikValideringskod">
									<structure:componentLabel mapKeyName="CaptchaText"/>
									<span class="captcha"><c:out value="${secretCode}"/></span>
								</label>
								<input type="text" id="publikValideringskod" name="publikValideringskod" />
							</div>
						</noscript>
						<div class="buttonCol">
							<input name="send" type="submit" value="<structure:componentLabel mapKeyName="Send"/>" class="button" title="<structure:componentLabel mapKeyName="TitleSend"/>" />
						</div>
					</fieldset>
				</div>
			</div>
		</form>
	</c:otherwise>
</c:choose>
<!-- /eri-no-index -->
