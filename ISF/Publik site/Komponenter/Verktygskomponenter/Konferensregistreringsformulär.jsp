<%@page import="java.util.Random"%>
<%@page import="java.util.Calendar"%>
<%@page import="java.text.ParseException"%>
<%@page import="java.util.Date"%>
<%@page import="java.text.SimpleDateFormat"%>

<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="publicationCategory" propertyName="PublicationCategory" useInheritance="false"/>
<structure:componentPropertyValue id="description" propertyName="Description" useInheritance="false"/>
<structure:componentPropertyValue id="hideTypeText" propertyName="HideTypeText" useInheritance="false"/>
<structure:componentPropertyValue id="maxItems" propertyName="MaxItems" useInheritance="false"/>
<structure:componentPropertyValue id="registrationEndDateString" propertyName="RegistrationEndDate" useInheritance="false"/>
<structure:componentPropertyValue id="conferenceId" propertyName="ConferenceId" useInheritance="false"/>
<structure:componentPropertyValue id="emailRecipient" propertyName="EmailRecipient" useInheritance="false"/>

<c:if test="${not empty param.contentId}">
	<c:set var="conferenceId" value="${param.contentId}"/>
</c:if>

<c:if test="${empty emailRecipient and pc.isDecorated}">
	<div class="adminMessage">
		<structure:componentLabel mapKeyName="NoEmailRecipient"/>
	</div>
</c:if>

<c:if test="${not empty param.isPOSTBACK}">
	<c:if test="${not empty param.isPOSTBACK and empty param.name}">
		<c:set var="hasError" value="true"/>
		<c:set var="formError_name"><span class="formError"><structure:componentLabel mapKeyName="MissingValue" /></span></c:set>
	</c:if>
	<c:if test="${not empty param.isPOSTBACK and empty param.organisation}">
		<c:set var="hasError" value="true"/>
		<c:set var="formError_organisation"><span class="formError"><structure:componentLabel mapKeyName="MissingValue" /></span></c:set>
	</c:if>
	<c:if test="${not empty param.isPOSTBACK and empty param.address}">
		<c:set var="hasError" value="true"/>
		<c:set var="formError_address"><span class="formError"><structure:componentLabel mapKeyName="MissingValue" /></span></c:set>
	</c:if>
	<c:if test="${not empty param.isPOSTBACK and empty param.zipCode}">
		<c:set var="hasError" value="true"/>
		<c:set var="formError_zipCode"><span class="formError"><structure:componentLabel mapKeyName="MissingValue" /></span></c:set>
	</c:if>
	<c:if test="${not empty param.isPOSTBACK and empty param.city}">
		<c:set var="hasError" value="true"/>
		<c:set var="formError_city"><span class="formError"><structure:componentLabel mapKeyName="MissingValue" /></span></c:set>
	</c:if>
	<c:if test="${not empty param.isPOSTBACK and empty param.email}">
		<c:set var="hasError" value="true"/>
		<c:set var="formError_email"><span class="formError"><structure:componentLabel mapKeyName="MissingValue" /></span></c:set>
	</c:if>
	<%--<c:if test="${not empty param.isPOSTBACK and empty param.invoiceAddress}">
		<c:set var="hasError" value="true"/>
		<c:set var="formError_invoiceAddress"><span class="formError"><structure:componentLabel mapKeyName="MissingValue" /></span></c:set>
	</c:if>--%>
	<c:if test="${not empty param.isPOSTBACK and empty param.invoiceRef1}">
		<c:set var="hasError" value="true"/>
		<c:set var="formError_invoiceRef1"><span class="formError"><structure:componentLabel mapKeyName="MissingValue" /></span></c:set>
	</c:if>
	<%--<c:if test="${not empty param.isPOSTBACK and empty param.invoiceRef2}">
		<c:set var="hasError" value="true"/>
		<c:set var="formError_invoiceRef2"><span class="formError"><structure:componentLabel mapKeyName="MissingValue" /></span></c:set>
	</c:if>
	<c:if test="${not empty param.isPOSTBACK and empty param.specialNeeds}">
		<c:set var="hasError" value="true"/>
		<c:set var="formError_specialNeeds"><span class="formError"><structure:componentLabel mapKeyName="MissingValue" /></span></c:set>
	</c:if>--%>
</c:if>

<div id="pageMainContent"><!-- OBS: nytt innehåll -->
	<div class="innerContainer">
		<c:if test="${not empty hasError}">
			<div class="errorMessage">
				<h2><structure:componentLabel mapKeyName="FormErrorTitle" /></h2>
				<p><structure:componentLabel mapKeyName="FormErrorTextLine1" /></p>
				<p><structure:componentLabel mapKeyName="FormErrorTextLine2" /></p>
			</div>
		</c:if>
	</div>
</div>

<%-- For the logic in this component to work the registrationEndDate needs to be set
     Even if the conferenceConditions-DIV is not displayed --%>
     
<c:if test="${not empty conferenceId}">
	<content:contentAttribute id="registrationEndDateString" attributeName="RegistrationEndDate" contentId="${conferenceId}" disableEditOnSight="true" />
	<content:contentAttribute id="cost" attributeName="Cost" contentId="${conferenceId}" disableEditOnSight="true" />
	<content:contentAttribute id="costExtra" attributeName="CostExtra" contentId="${conferenceId}" disableEditOnSight="true" />

	<%
	String registrationEndDateString = (String)pageContext.getAttribute("registrationEndDateString");
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
		}
		catch (ParseException ex)
		{
			// Observ the c:set!!!
			%><c:set var="conferenceError"><div class="adminMessage"><structure:componentLabel mapKeyName="RegistrationDateParseError" />: <c:out value="${registrationEndDateString}"/></div></c:set><%
		}
	}
	%>
</c:if>     

<c:if test="${empty param.isPOSTBACK or not empty hasError}">
	<div id="conferenceConditions">
		<div class="innerContainer">
			<c:choose>
				<c:when test="${empty conferenceId and pc.isDecorated}">
					<structure:componentLabel mapKeyName="NoConferenceId" />
				</c:when>
				<c:when test="${not empty conferenceId}">
					<h2><structure:componentLabel mapKeyName="RegistrationTerms" /></h2>
					<h3><structure:componentLabel mapKeyName="Fee" /></h3>

					<p>
						<span>
							<c:choose>
								<c:when test="${empty cost}">
									<structure:componentLabel mapKeyName="FreeFee" />
								</c:when>
								<c:otherwise>
									<c:out value="${cost}" escapeXml="false" />&nbsp;<structure:componentLabel mapKeyName="FeeText" />
								</c:otherwise>
							</c:choose>
						</span>
						<c:if test="${not empty costExtra}">
							<span class="extraInfo"><c:out value="${costExtra}" escapeXml="false"/></span>					
						</c:if>
					</p>
					
					<h3><structure:componentLabel mapKeyName="CancellationTitle" /></h3>
			
					<structure:componentLabel id="cancellationText" mapKeyName="CancellationText" />
					<c:out value="${conferenceError}" escapeXml="false" />
					<c:if test="${not empty cancellationText and not empty registrationEndDate}">
						<p>
							<%
								String cancelDate = new SimpleDateFormat("dd MMMM yyyy").format((Date)pageContext.getAttribute("registrationEndDate"));
								out.print(String.format(pageContext.getAttribute("cancellationText").toString(), cancelDate));
							%>
						</p>
					</c:if>
				</c:when>
			</c:choose>
		</div>
	</div>
</c:if>

<c:if test="${empty param.isPOSTBACK or not empty hasError}">
	<div id="conferenceForm">
		<div class="innerContainer">
			<common:urlBuilder id="currentUrl" />
			<script type="text/javascript">
				function setKey()
				{
					$("#topphemligNyckel").val("nobot");
				}
			</script>
			<form method="POST" action="<c:out value="${currentUrl}"/>" onsubmit="setKey();">
				<input type="hidden" name="isPOSTBACK" value="1"/>
				<input type="hidden" name="contentId" value="<c:out value="${conferenceId}" />"/>
				<fieldset>
					<legend><structure:componentLabel mapKeyName="FormLegend" /></legend> <%-- Anmälningsformulär --%>
					<div class="fieldCol<c:if test="${not empty param.isPOSTBACK and empty param.name}"> errorField</c:if>">
						<label for="name">
							<structure:componentLabel mapKeyName="NameLabel" />
							<c:out value="${formError_name}" escapeXml="false"/>
						</label>
						<input type="text" id="name" name="name" <c:if test="${not empty param.name}"><c:out value="value=\"${param.name}\"" escapeXml="false" /></c:if> /> <%--För- och efternamn --%>
					</div>
					
					<div class="fieldCol<c:if test="${not empty param.isPOSTBACK and empty param.organisation}"> errorField</c:if>">
						<label for="organisation">
							<structure:componentLabel mapKeyName="OrganisationLabel" />
							<c:out value="${formError_organisation}" escapeXml="false"/>
						</label>
						<input type="text" id="organisation" name="organisation" <c:if test="${not empty param.organisation}"><c:out value="value=\"${param.organisation}\"" escapeXml="false" /></c:if>  />
						<%--Organisation eller motsvarande --%>
					</div>
					
					<div class="fieldCol<c:if test="${not empty param.isPOSTBACK and empty param.address}"> errorField</c:if>">
						<label for="address">
							<structure:componentLabel mapKeyName="AddressLabel" />
							<c:out value="${formError_organisation}" escapeXml="false"/>
						</label>
						<input type="text" id="address" name="address" <c:if test="${not empty param.address}"><c:out value="value=\"${param.address}\"" escapeXml="false" /></c:if> />
						<%-- Postadress--%>
					</div>
					
					<div class="fieldCol zipCode<c:if test="${not empty param.isPOSTBACK and empty param.zipCode}"> errorField</c:if>">
						<label for="zipCode">
							<structure:componentLabel mapKeyName="ZipCodeLabel" />
							<c:out value="${formError_organisation}" escapeXml="false"/>
						</label>
						<input type="text" id="zipCode" name="zipCode" <c:if test="${not empty param.zipCode}"><c:out value="value=\"${param.zipCode}\"" escapeXml="false" /></c:if> />
						<%-- Postnummer--%>
					</div>
					
					<div class="fieldCol city<c:if test="${not empty param.isPOSTBACK and empty param.city}"> errorField</c:if>">
						<label for="city">
							<structure:componentLabel mapKeyName="CityLabel" />
							<c:out value="${formError_city}" escapeXml="false"/>
						</label> <input type="text" id="city" name="city" <c:if test="${not empty param.city}"><c:out value="value=\"${param.city}\"" escapeXml="false" /></c:if> />
						<%-- Ort--%>
					</div>
		
					<div class="fieldCol<c:if test="${not empty param.isPOSTBACK and empty param.email}"> errorField</c:if>">
						<label for="email">
							<structure:componentLabel mapKeyName="EmailLabel" />
							<c:out value="${formError_email}" escapeXml="false"/>
						</label>
						<input type="text" id="email" name="email" <c:if test="${not empty param.email}"><c:out value="value=\"${param.email}\"" escapeXml="false" /></c:if> />
						<%-- E-postadress--%>
					</div>
		
					<div class="fieldCol">
						<label for="invoiceAddress">
							<structure:componentLabel mapKeyName="InvoiceAddressabel" />
						</label>
						<input type="text" id="invoiceAddress" name="invoiceAddress" <c:if test="${not empty param.invoiceAddress}"><c:out value="value=\"${param.invoiceAddress}\"" escapeXml="false" /></c:if> />
						<%-- Fakturaadress (om annan än ovan) --%>
					</div>
		
					<div class="fieldCol<c:if test="${not empty param.isPOSTBACK and empty param.invoiceRef1}"> errorField</c:if>">
						<label for="invoiceRef1">
							<structure:componentLabel mapKeyName="InvoiceRefLabel" />
							<c:out value="${formError_invoiceRef1}" escapeXml="false"/>
						</label>
						<input type="text" id="invoiceRef1" name="invoiceRef1" <c:if test="${not empty param.invoiceRef1}"><c:out value="value=\"${param.invoiceRef1}\"" escapeXml="false" /></c:if> /> 
						<span><structure:componentLabel mapKeyName="InvoiceRefText" /></span>
						<%-- Fakturareferens1 --%>
						<%-- Betalningsreferensen är den kod, referens eller kostnadsställe som er egen myndighet kräver för att fakturan ska kunna hamna hos rätt person för betalning i rätt tid. Om du inte känner till den, så ta kontakt med din myndighets ekonomiavdelning. Det är olika vad myndigheterna kräver, men ett exempel på hur det kan se ut är: ZZ1234XXXX. --%>
					</div>
		
					<div class="fieldCol">
						<label for="invoiceRef2">
							<structure:componentLabel mapKeyName="InvoiceRef2Label" />
						</label>
						<input type="text" id="invoiceRef2" name="invoiceRef2" <c:if test="${not empty param.invoiceRef2}"><c:out value="value=\"${param.invoiceRef2}\"" escapeXml="false" /></c:if> />
						<%-- Fakturareferens 2 (valfritt) --%>
					</div>
					
					<div class="fieldCol">
						<label for="specialNeeds">
							<structure:componentLabel mapKeyName="SpecialNeedsLabel" />
						</label>
						<textarea id="specialNeeds" cols="50" rows="3" name="specialNeeds"> <c:if test="${not empty param.name1}"><c:out value="${param.specialNeeds}" escapeXml="false" /></c:if></textarea>
						<span><structure:componentLabel mapKeyName="SpecialNeedsText" /></span>
						<%-- Övriga önskemål (valfritt) --%>
						<%-- Vänligen ange om du har en funktionsnedsättning som ställer
						speciella krav på tillgängligheten eller speciella behov gällande kost.
						Vid lunchbuffén serveras såväl kött, fisk som vegetariskt. --%>
					</div>
					
					<div class="additionalParticipant id1"><strong><structure:componentLabel mapKeyName="Participant2" /></strong> <span><structure:componentLabel mapKeyName="OptionalFieldsLabel" /></span>
						<div class="fieldCol"><label for="name1"><structure:componentLabel mapKeyName="NameLabel" /></label> <input type="text" id="name1" name="name1" <c:if test="${not empty param.name1}"><c:out value="value=\"${param.name1}\"" escapeXml="false" /></c:if> /></div>
						<div class="fieldCol"><label for="email1"><structure:componentLabel mapKeyName="EmailLabel" /></label></label> <input type="text" id="email1" name="email1" <c:if test="${not empty param.email1}"><c:out value="value=\"${param.email1}\"" escapeXml="false" /></c:if> /></div>
					</div>
					
					<div class="additionalParticipant id2"><strong><structure:componentLabel mapKeyName="Participant3" /></strong> <span><structure:componentLabel mapKeyName="OptionalFieldsLabel" /></span>
						<div class="fieldCol"><label for="name2"><structure:componentLabel mapKeyName="NameLabel" /></label> <input type="text" id="name2" name="name2" <c:if test="${not empty param.name2}"><c:out value="value=\"${param.name2}\"" escapeXml="false" /></c:if> /></div>
						<div class="fieldCol"><label for="email2"><structure:componentLabel mapKeyName="EmailLabel" /></label></label> <input type="text" id="email2" name="email2" <c:if test="${not empty param.email2}"><c:out value="value=\"${param.email2}\"" escapeXml="false" /></c:if> /></div>
					</div>
		
					<div class="additionalParticipant id3"><strong><structure:componentLabel mapKeyName="Participant4" /></strong> <span><structure:componentLabel mapKeyName="OptionalFieldsLabel" /></span>
						<div class="fieldCol"><label for="name3"><structure:componentLabel mapKeyName="NameLabel" /></label> <input type="text" id="name3" name="name3" <c:if test="${not empty param.name3}"><c:out value="value=\"${param.name3}\"" escapeXml="false" /></c:if> /></div>
						<div class="fieldCol"><label for="email3"><structure:componentLabel mapKeyName="EmailLabel" /></label></label> <input type="text" id="email3" name="email3" <c:if test="${not empty param.email3}"><c:out value="value=\"${param.email3}\"" escapeXml="false" /></c:if> /></div>
					</div>
		
					<div class="additionalParticipant id4"><strong><structure:componentLabel mapKeyName="Participant5" /></strong> <span><structure:componentLabel mapKeyName="OptionalFieldsLabel" /></span>
						<div class="fieldCol"><label for="name4"><structure:componentLabel mapKeyName="NameLabel" /></label> <input type="text" id="name4" name="name4" <c:if test="${not empty param.name4}"><c:out value="value=\"${param.name4}\"" escapeXml="false" /></c:if> /></div>
						<div class="fieldCol"><label for="email4"><structure:componentLabel mapKeyName="EmailLabel" /></label></label> <input type="text" id="email4" name="email4" <c:if test="${not empty param.email4}"><c:out value="value=\"${param.email4}\"" escapeXml="false" /></c:if> /></div>
					</div>
		
					<div class="addMoreParticipants">
						<a href="#" class="id1"><structure:componentLabel mapKeyName="AddMoreParticipantsLabel" /></a>
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
						<div class="fieldCol">
							<input type="hidden" id="hemligValideringskod" name="hemligValideringskod" value="<c:out value="${secretCode}"/>"/>
							<label for="publikValideringskod"><structure:componentLabel mapKeyName="CaptchaText"/><span class="captcha"><c:out value="${secretCode}"/></span></label>
							<input type="text" id="publikValideringskod" name="publikValideringskod" />
						</div>
					</noscript>
		
					<div class="buttonCol">
						<input name="send" type="submit" value="<structure:componentLabel mapKeyName="SubmitValue" />" class="button" title="<structure:componentLabel mapKeyName="SubmitTitle" />" />
					</div>
				</fieldset>
			</form>
		</div>
	</div>
</c:if>

<c:if test="${not empty param.isPOSTBACK and empty hasError}">
	<%
		Date todaysDate = new Date();
		pageContext.setAttribute("todaysDate", todaysDate);
	%>

	<c:choose>
		<c:when test="${registrationEndDate < todaysDate}">
			<p><structure:componentLabel mapKeyName="ApplicationDateHasPassed"/></p>
		</c:when>
		<c:otherwise>
			<c:set var="emailBody">
				<common:include relationAttributeName="RelatedComponents" contentName="Mail konferensanmälan" />
			</c:set>

			<structure:componentLabel id="emailSubject" mapKeyName="EmailSubject"/>

			<common:mail id="mailStatus" from="${param.email}" to="${emailRecipient}" subject="${emailSubject}" type="text/html" charset="utf-8" message="${emailBody}"/>
			
			<c:choose>
				<c:when test="${mailStatus}">
					<div id="confirmationMessage">
						<div class="innerContainer">
							<h2><structure:componentLabel mapKeyName="ConfirmationTitle" /></h2>
							<p><structure:componentLabel mapKeyName="ConfirmationText" /></p>
						</div>
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
		</c:otherwise>
	</c:choose>
</c:if>
