<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>

<content:content id="logotyp" propertyName="Logotyp" useInheritance="true"/>
<content:assetUrls id="logotypUrls" contentId="${logotyp.id}" />
<c:set var="logotypUrl" value="${logotypUrls[0]}"/>

<c:if test="${not empty param.contentId}">
	<c:set var="conferenceId" value="${param.contentId}"/>
</c:if>

<content:contentAttribute id="title" attributeName="Title" contentId="${conferenceId}" disableEditOnSight="true" />
<content:contentAttribute id="timeExtra" attributeName="TimeExtra" contentId="${conferenceId}" disableEditOnSight="true" />
<content:contentAttribute id="place" attributeName="Place" contentId="${conferenceId}" disableEditOnSight="true" />
<content:contentAttribute id="placeExtra" attributeName="PlaceExtra" contentId="${conferenceId}" disableEditOnSight="true" />
<content:contentAttribute id="cost" attributeName="Cost" contentId="${conferenceId}" disableEditOnSight="true" />
<content:contentAttribute id="costExtra" attributeName="CostExtra" contentId="${conferenceId}" disableEditOnSight="true" />
<content:contentAttribute id="startDate" attributeName="StartDate" contentId="${conferenceId}" disableEditOnSight="true" />
<content:contentAttribute id="endDate" attributeName="EndDate" contentId="${conferenceId}" disableEditOnSight="true" />

<common:transformText id="name" text="${param.name}" htmlEncode="true" />
<common:transformText id="organisation" text="${param.organisation}" htmlEncode="true" />
<common:transformText id="address" text="${param.address}" htmlEncode="true" />
<common:transformText id="zipCode" text="${param.zipCode}" htmlEncode="true" />
<common:transformText id="city" text="${param.city}" htmlEncode="true" />
<common:transformText id="email" text="${param.email}" htmlEncode="true" />
<common:transformText id="invoiceAddress" text="${param.invoiceAddress}" htmlEncode="true" />
<common:transformText id="invoiceRef1" text="${param.invoiceRef1}" htmlEncode="true" />
<common:transformText id="invoiceRef2" text="${param.invoiceRef2}" htmlEncode="true" />
<common:transformText id="specialNeeds" text="${param.specialNeeds}" htmlEncode="true" />

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="sv" xml:lang="sv">
	<head>
	    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
	    <title><structure:componentLabel mapKeyName="ConferenceRegistrationMailTitle" /></title>
	</head>
	
	<body>
		<style type="text/css">
			<!--
				body { background: #fff; color: #000; }
				h1, h2, td, th { font-family: Arial, Verdana, Helvetica, sans-serif; font-size: 12px; margin: 0; padding: 0; }
				h1 { font-size: 24px; font-weight: normal; margin: 30px 0 0; }
				h2 { margin: 10px 0 0; }
				.container { margin: 10px }
				.logo { width: 200px; padding: 0 0 10px 0; }
				.header { width: 400px; text-align: center; }
				.info { background-color: #e7e7e5; padding: 0 10px 10px; }
				.info table tr td { padding: 5px 0; }
				.info table tr td.label { width: 190px; font-style: italic; }
				.info table table .title { padding-left: 10px; padding-right: 10px; }
				.info table table td { border-bottom: 1px solid #fff; }
				table th { text-align: left; border-bottom: 1px solid #fff; padding-bottom: 5px; font-size: 11px; }
			-->
	    </style>
	    <table class="container" border="0" cellspacing="0" cellpadding="0" width="600">
	        <tr>
	        	<td class="logo" valign="top">
	                <img alt="<structure:componentLabel mapKeyName="LogoAltTitle"/>" src="<c:out value="${pageContext.request.scheme}"/>://<c:out value="${pageContext.request.serverName}"/><c:out value="${logotypUrl}"/>" />
	            </td>
	        	<td class="header" valign="top">
	                <h1><structure:componentLabel mapKeyName="MailTitle" /></h1>
	            </td>
	        </tr>
	        <tr>
	        	<td colspan="2" class="info">
	                <table width="100%" border="0" cellspacing="0" cellpadding="0">
	                    <tr>
	                        <td colspan="2" valign="top">
	                            <h2><structure:componentLabel mapKeyName="MailConferenceFacts" /></h2>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td valign="top" class="label"><structure:componentLabel mapKeyName="MailConference"/></td>
	                        <td valign="top"><c:out value="${title}" /></td>
	                    </tr>
	                    <tr>
	                        <td valign="top" class="label"><structure:componentLabel mapKeyName="MailStartDate"/></td>
	                        <td valign="top">
								<common:formatter value="${startDate}" pattern="dd MMMM yyyy"/>
								<common:formatter value="${startDate}" pattern="hh:mm"/>
							</span>
	                        </td>
	                    </tr>
	                   <tr>
	                        <td valign="top" class="label"><structure:componentLabel mapKeyName="MailEndDate"/></td>
	                        <td valign="top">
								<common:formatter value="${endDate}" pattern="dd MMMM yyyy"/>
								<common:formatter value="${endDate}" pattern="hh:mm"/>
							</span>
	                        </td>
	                    </tr>
	                    <tr>
	                        <td valign="top" class="label"><structure:componentLabel mapKeyName="MailPlace"/></td>
	                        <td valign="top">
	                        	<c:out value="${place}" /><br/>
	                        	<c:out value="${placeExtra}" />
	                        </td>
	                    </tr>
	                    <tr>
	                        <td valign="top" class="label"><structure:componentLabel mapKeyName="MailCost"/></td>
	                        <td valign="top">
	                        	<c:out value="${cost}" /><br/>
	                        	<c:out value="${costExtra}" />
	                         </td>
	                    </tr>
	                    <tr>
	                        <td colspan="2" valign="top">
	                            <h2><structure:componentLabel mapKeyName="MailParticipants"/></h2>
	                        </td>
	                    </tr>
	                    <tr><td><structure:componentLabel mapKeyName="NameLabel" /></td><td><c:out value="${name}" escapeXml="false"/></td></tr>
						<tr><td><structure:componentLabel mapKeyName="OrganisationLabel" /></td><td><c:out value="${organisation}" escapeXml="false"/></td></tr>
						<tr><td><structure:componentLabel mapKeyName="AddressLabel" /></td><td><c:out value="${address}" escapeXml="false"/></td></tr>
						<tr><td><structure:componentLabel mapKeyName="ZipCodeLabel" /></td><td><c:out value="${zipCode}" escapeXml="false"/></td></tr>
						<tr><td><structure:componentLabel mapKeyName="CityLabel" /></td><td><c:out value="${city}" escapeXml="false"/></td></tr>
						<tr><td><structure:componentLabel mapKeyName="EmailLabel" /></td><td><c:out value="${email}" escapeXml="false"/></td></tr>
						<tr><td><structure:componentLabel mapKeyName="InvoiceAddressabel" /></td><td><c:out value="${invoiceAddress}" escapeXml="false"/></td></tr>
						<tr><td><structure:componentLabel mapKeyName="InvoiceRefLabel" /></td><td><c:out value="${invoiceRef1}" escapeXml="false"/></td></tr>
						<tr><td><structure:componentLabel mapKeyName="InvoiceRef2Label" /></td><td><c:out value="${invoiceRef2}" escapeXml="false"/></td></tr>
						<tr><td><structure:componentLabel mapKeyName="SpecialNeedsLabel" /></td><td><c:out value="${specialNeeds}" escapeXml="false"/></td></tr>
	                    <tr>
	                        <td colspan="2" valign="top">
	                            <h2><structure:componentLabel mapKeyName="MailExtraParticipants"/></h2>
	                        </td>
	                    </tr>
	                   <c:if test="${not empty param.name1}">
							<common:transformText id="name1" text="${param.name1}" htmlEncode="true" />
							<common:transformText id="email1" text="${param.email1}" htmlEncode="true" />
							<tr>
								<td valign="top" class="label"><structure:componentLabel mapKeyName="Participant1" /></td>
								<td valign="top"><c:out value="${name1}" escapeXml="false"/>, <c:out value="${email1}" escapeXml="false"/></td>
							</tr>
						</c:if>
						<c:if test="${not empty param.name2}">
							<common:transformText id="name2" text="${param.name2}" htmlEncode="true" />
							<common:transformText id="email2" text="${param.email2}" htmlEncode="true" />
							<tr>
								<td valign="top" class="label"><structure:componentLabel mapKeyName="Participant2" /></td>
								<td valign="top"><c:out value="${name2}" escapeXml="false"/>, <c:out value="${email2}" escapeXml="false"/></td>
							</tr>
						</c:if>
						<c:if test="${not empty param.name3}">
							<common:transformText id="name3" text="${param.name3}" htmlEncode="true" />
							<common:transformText id="email3" text="${param.email3}" htmlEncode="true" />
							<tr>
								<td valign="top" class="label"><structure:componentLabel mapKeyName="Participant3" /></td>
								<td valign="top"><c:out value="${name3}" escapeXml="false"/>, <c:out value="${email3}" escapeXml="false"/></td>
							</tr>
						</c:if>
						<c:if test="${not empty param.name4}">
							<common:transformText id="name4" text="${param.name4}" htmlEncode="true" />
							<common:transformText id="email4" text="${param.email4}" htmlEncode="true" />
							<tr>
								<td valign="top" class="label"><structure:componentLabel mapKeyName="Participant4" /></td>
								<td valign="top"><c:out value="${name4}" escapeXml="false"/>, <c:out value="${email4}" escapeXml="false"/></td>
							</tr>
						</c:if>
	                </table>
	            </td>
	        </tr>
	    </table>
	</body>
</html>