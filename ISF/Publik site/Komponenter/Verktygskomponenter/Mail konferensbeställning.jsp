<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>

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
                <img alt="<structure:componentLabel mapKeyName="LogoAltTitle"/>" src="<c:out value="${logotypUrl}"/>" />
            </td>
        	<td class="header" valign="top">
                <h1><structure:componentLabel mapKeyName="OrderedReports"/></h1>
            </td>
        </tr>
        <tr>
        	<td colspan="2" class="info">
                <table width="100%" border="0" cellspacing="0" cellpadding="0">
                    <tr>
                        <td colspan="2" valign="top">
                            <h2>Beställda rapporter</h2>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" valign="top">
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr>
                                	<th valign="top">Nummer</th>
                                    <th valign="top" class="title">Titel</th>
                                    <th valign="top">Antal</th>
                                </tr>
                                <tr>
                                    <td valign="top">2011:2</td>
                                    <td valign="top" class="title">Informationsutvinning och profilering för effektivare förvaltning</td>
                                    <td valign="top">1</td>
                                </tr>
                                <tr>
                                    <td valign="top">2011:12</td>
                                    <td valign="top" class="title">Informationsutvinning och profilering för effektivare förvaltning  och profilering för effektivare förvaltning</td>
                                    <td valign="top">13</td>
                                </tr>
                                <tr>
                                    <td valign="top">2011:2</td>
                                    <td valign="top" class="title">Informationsutvinning och profilering för effektivare förvaltning</td>
                                    <td valign="top">1</td>
                                </tr>
                                <tr>
                                    <td valign="top">2011:2</td>
                                    <td valign="top" class="title">Informationsutvinning</td>
                                    <td valign="top">1</td>
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" valign="top">
                            <h2>Beställare</h2>
                        </td>
                    </tr>
                    <tr>
                        <td valign="top" class="label">För- och efternamn</td>
                        <td valign="top">Anna Andersson</td>
                    </tr>
                    <tr>
                        <td valign="top" class="label">Organisation</td>
                        <td valign="top">Socialdepartementet</td>
                    </tr>
                    <tr>
                        <td valign="top" class="label">Postadress</td>
                        <td valign="top">Box 123</td>
                    </tr>
                    <tr>
                        <td valign="top" class="label">Postnummer</td>
                        <td valign="top">123 45</td>
                    </tr>
                    <tr>
                        <td valign="top" class="label">Ort</td>
                        <td valign="top">Stockholm</td>
                    </tr>
                    <tr>
                        <td valign="top" class="label">E-postadress</td>
                        <td valign="top">anna.andersson@socialdepartementet.se</td>
                    </tr>
                </table>
            </td>
        </tr>
    </table>
</body>
</html>