<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-content" prefix="content" %>

<content:content id="logotyp" propertyName="Logotyp" useInheritance="true"/>
<content:assetUrls id="logotypUrls" contentId="${logotyp.id}" />
<c:set var="logotypUrl" value="${logotypUrls[0]}"/>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" lang="sv" xml:lang="sv">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
    <title><structure:componentLabel mapKeyName="OrderedReports"/></title>
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
                <h1><structure:componentLabel mapKeyName="ReportOrder"/></h1>
            </td>
        </tr>
        <tr>
        	<td colspan="2" class="info">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td colspan="2" valign="top">
                            <h2><structure:componentLabel mapKeyName="OrderedReports"/></h2>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" valign="top">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                    <th><structure:componentLabel mapKeyName="ReportNumber"/></th>
									<th><structure:componentLabel mapKeyName="Title"/></th>
									<th><structure:componentLabel mapKeyName="Amount"/></th>
                                </tr>
                               	<c:forEach var="requestVar" items="${param}" varStatus="loop">
									<c:set var="myKey" value="${requestVar.key}" />
									<c:set var="myVal" value="${requestVar.value}" />
									<%
										String myKey 	= (String)pageContext.getAttribute("myKey");
										String myVal 	= (String)pageContext.getAttribute("myVal");
										String reportId	= "";
									
										if (myKey.startsWith("report_"))
										{
											
											reportId = myKey.substring(myKey.indexOf("_") + 1);
											pageContext.setAttribute("reportId", reportId);
											%>
												<content:contentAttribute id="reportName" contentId="${reportId}" attributeName="Title" disableEditOnSight="true" />
												<content:contentAttribute id="reportNumber" contentId="${reportId}" attributeName="ReportNumber" disableEditOnSight="true" />
												<tr>
													<td><c:out value="${reportNumber}" /></td>
													<td><c:out value="${reportName}" /></td>
													<td><c:out value="${requestVar.value}" /><structure:componentLabel mapKeyName="Pieces"/></td>
												</tr>
											<%
										}
									%>
								</c:forEach>
                            </table>
                        </td>
                    </tr>
                    <tr>
                    	<td colspan="2" valign="top">
		                    <h2><structure:componentLabel mapKeyName="Orderee"/></h2>
		                </td>
		            </tr>
					<tr>
						<td><structure:componentLabel mapKeyName="Name"/>:</td>
						<td><c:out value="${param.name}" /></td>
					</tr>
					<tr>
						<td><structure:componentLabel mapKeyName="Organisation"/>:</td>
						<td><c:out value="${param.organisation}" /></td>
					</tr>
					<tr>
						<td><structure:componentLabel mapKeyName="Address"/>:</td>
						<td><c:out value="${param.address}" /></td>
					</tr>
					<tr>
						<td><structure:componentLabel mapKeyName="ZipCode"/>:</td>
						<td><c:out value="${param.zipCode}" /></td>
					</tr>
					<tr>
						<td><structure:componentLabel mapKeyName="City"/>:</td>
						<td><c:out value="${param.city}" /></td>
					</tr>
					<tr>
						<td><structure:componentLabel mapKeyName="Email"/>:</td>
						<td><c:out value="${param.email}" /></td>
					</tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>