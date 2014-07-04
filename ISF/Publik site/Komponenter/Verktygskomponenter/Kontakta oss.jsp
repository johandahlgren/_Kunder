<%@ taglib prefix="c"         uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="common"    uri="infoglue-common" %>
<%@ taglib prefix="structure" uri="infoglue-structure" %>

<common:urlBuilder id="currentUrl" fullBaseUrl="true"/>

<structure:componentPropertyValue id="fromAddress" propertyName="FromAddress" useInheritance="false"/>
<structure:componentPropertyValue id="toAddress" propertyName="ToAddress" useInheritance="false"/>

<c:choose>
	<c:when test="${param.sendMail eq 'yes'}">
			   
		<common:transformText id="message" text="${param.message}" replaceLineBreaks="true" lineBreakReplacer="<br/>"/>
		
		<c:if test="${param.sendCC == 'yes'}">
			<c:choose>
				<c:when test="${not empty param.senderEmail}">
					<common:mail id="mailStatus" from="${fromAddress}" to="${toAddress}" cc="${param.senderEmail}" subject="${decryptedSubject}" type="text/html" charset="utf-8" message="${message}"/>
				</c:when>
				<c:otherwise>
					<common:mail id="mailStatus" from="${fromAddress}" to="${toAddress}" subject="${decryptedSubject}" type="text/html" charset="utf-8" message="${message}"/>
				</c:otherwise>
			</c:choose>
		</c:if>
		
		<c:choose>
			<c:when test="${mailStatus}">												
				Gick ju bra!
			</c:when>
			<c:otherwise>
				<p>
					<h2><structure:componentLabel mapKeyName="MailSendErrorTitle"/>:</h2>
					<c:choose>
						<c:when test="${commonMailTagException.class.name eq 'javax.mail.internet.AddressException'}">
							<structure:componentLabel mapKeyName="MalformedEmailAddress"/>:<br/>
						</c:when>
						<c:otherwise>
							<structure:componentLabel mapKeyName="GenericEmailErrorMessage"/>
						</c:otherwise>
					</c:choose>
					<br/>
					<br/>
					<span class="errorMessage">
						<c:out value="${commonMailTagException.message}"/>
					</span>
				</p>
				<p>
					<a href="javascript:history.go(-1);"><structure:componentLabel mapKeyName="Back"/></a>
				</p>
			</c:otherwise>
		</c:choose>
	</c:when>
	<c:otherwise>
		<form method="post" action="<c:out value="${currentUrl}"/>">
			<input type="hidden" name="sendMail" value="yes">
			<table>
				<tr>
					<td><structure:componentLabel mapKeyName="Subject"/></td>
					<td><input type="text" name="subject" /></td>
				</tr>
				<tr>
					<td><structure:componentLabel mapKeyName="Message"/></td>
					<td><textarea name="message"></textarea></td>
				</tr>
				<tr>
					<td><structure:componentLabel mapKeyName="SendCC"/></td>
					<td><input type="checkbox" name="sendCC" value="yes"/></td>
				</tr>
				<tr>
					<td><structure:componentLabel mapKeyName="SenderEmail"/></td>
					<td><input type="text" name="senderEmail" /></td>
				</tr>
				<tr>
					<td colspan="2">
						<input type="submit" value="<structure:componentLabel mapKeyName="Send"/>"/>
					</td>
				</tr>
			</table>
		</form>
	</c:otherwise>
</c:choose>