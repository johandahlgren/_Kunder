<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-content" prefix="content" %> 
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page"%>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<c:if test="${!pc.isInPageComponentMode}">
	<script type="text/javascript" src="<c:out value="${pageContext.request.contextPath}"/>/script/jquery/jquery-1.2.6.min.js"></script>
</c:if> 
<c:if test="${param.sendOrder == 'true'}">
<script type="text/javascript">
<!--
	$(document).ready(function(){
     		$("#ansvarsnummer").focus();
    	});
-->
</script>
</c:if>

<c:catch var="myError">
	<content:boundContents id="inventoryList" propertyName="Profilvaror"/>
	
	<structure:componentLabel id="responsibilityNumberLabel" mapKeyName="responsibilityNumberLabel"/>
	<structure:componentLabel id="emailLabel" mapKeyName="emailLabel"/>
	<structure:componentLabel id="ordererNameLabel" mapKeyName="ordererNameLabel"/>
	<structure:componentLabel id="postAddressLabel" mapKeyName="postAddressLabel"/>
	<structure:componentLabel id="deliveryAddressLabel" mapKeyName="deliveryAddressLabel"/>
	<structure:componentLabel id="orgUnitLabel" mapKeyName="orgUnitLabel"/>
	<structure:componentLabel id="phoneLabel" mapKeyName="phoneLabel"/>
	<structure:componentLabel id="messageLabel" mapKeyName="messageLabel"/>
	
	<c:set var="catpchaTextVariableName" value="${param.captchaTextVariableName}"/>
	<%
		if (pageContext.getAttribute("catpchaTextVariableName") != null)
		{
			String catpchaTextVariableName = (String)pageContext.getAttribute("catpchaTextVariableName");
			if (request.getSession().getAttribute(catpchaTextVariableName) != null)
			{
				String correctCaptchaText = (String)request.getSession().getAttribute(catpchaTextVariableName);
				pageContext.setAttribute("correctCatpchaText", correctCaptchaText);
			}
		}
	%>
	<c:set var="correctCatpchaText"><c:out value="${correctCatpchaText}"/></c:set>
	<% 
		String correctCatpchaText = null;
		
		if (pageContext.getAttribute("correctCatpchaText") != null)
		{
			correctCatpchaText = (String)pageContext.getAttribute("correctCatpchaText");
		}
		
		if(correctCatpchaText != null)
			pageContext.setAttribute("correctCatpchaText", correctCatpchaText.toLowerCase());
	
		String userCaptchaText = request.getParameter("captchaText");
		if(userCaptchaText != null)
			pageContext.setAttribute("userCaptchaText", userCaptchaText.toLowerCase());
	%>
	
	<c:choose>
		<c:when test="${param.sendOrder == 'true' && not empty param.email && not empty param.namn && not empty param.telefon && correctCatpchaText == userCaptchaText}">
	
			<structure:componentPropertyValue id="mailrecipient" propertyName="Recipient"/>
			<structure:componentPropertyValue id="pHeader" propertyName="PageHeader"/>
			<structure:componentPropertyValue id="messageSubject" propertyName="MessageSubject"/>
			<structure:componentPropertyValue id="mess" propertyName="Message"/>
	        <c:if test="${empty mailrecipient}">
				<structure:siteNode id="nextPage" propertyName="NextPage"/>
	            <c:if test="${not empty nextPage}">
					<structure:componentPropertyValue id="mailrecipient" propertyName="Recipient" siteNodeId="${nextPage.siteNodeId}"/>
					<structure:componentPropertyValue id="pHeader" propertyName="PageHeader" siteNodeId="${nextPage.siteNodeId}"/>
					<structure:componentPropertyValue id="messageSubject" propertyName="MessageSubject" siteNodeId="${nextPage.siteNodeId}"/>
					<structure:componentPropertyValue id="mess" propertyName="Message" siteNodeId="${nextPage.siteNodeId}"/>
				</c:if>
	        </c:if>
			<%!
				void replyString(javax.servlet.http.HttpServletRequest request, StringBuffer sb, 
					String responsibilityNumberLabel, 
					String emailLabel, 
					String ordererNameLabel,
					String postAddressLabel,
					String deliveryAddressLabel,
					String orgUnitLabel,
					String phoneLabel,
					String messageLabel)
				{
				 	String[] selections = request.getParameterValues("orders");
					if(selections != null)
			        {
			 			for(int x = 0; x < selections.length; x++) 
			 			{
			            	String selectionParameter = request.getParameter(selections[x]);
			                if(selectionParameter != null && !selectionParameter.equals(""))
			                {
							    int numberOfItems = Integer.parseInt(selectionParameter );
							    if(numberOfItems>0)
							    {
									sb.append( "<p><b>"+selections[x] +" : </b>");
									sb.append( selectionParameter +" st </p>");
							    }
			               	}
						} 
			        }
					sb.append( "<p><b>" + responsibilityNumberLabel + ": </b>" + request.getParameter("ansvarsnummer") +"  </p>");
					sb.append( "<p><b>" + ordererNameLabel + ": </b>" + request.getParameter("namn") +"</p>");
					sb.append( "<p><b>" + postAddressLabel + ": </b>" + request.getParameter("postadress") +"</p>");
					sb.append( "<p><b>" + deliveryAddressLabel + ": </b>" + request.getParameter("leveransadress") +"</p>");
					sb.append( "<p><b>" + orgUnitLabel + ": </b>" + request.getParameter("institution") +" </p> ");
					sb.append( "<p><b>" + phoneLabel + ": </b>" + request.getParameter("telefon") +" </p>" );
					sb.append( "<p><b>" + emailLabel + ": </b>" + request.getParameter("email") +" </p>" );
					sb.append( "<p><b>" + messageLabel + ": </b>" + request.getParameter("message") +" </p>" );
				}
				
				String getDateString(String format) 
				{
					java.util.Locale loc = new java.util.Locale("sv");
			
				    java.text.SimpleDateFormat df = new java.text.SimpleDateFormat(format,loc);
				    return df.format(new java.util.Date());
			  	}			
			%>
			
			<%
			String aDate = getDateString("EEEE, MMMM dd, yyyy : HH:mm") ;
			%>
			
			<common:transformText id="body" text="${param.body}" replaceLineBreaks="true" lineBreakReplacer="<br/>"/>
			<c:set var="message">
				<div><strong>Below is the result of your orderform. it was submitted by (<c:out value="${param.email}"/> ) on <%=aDate%> </strong><br /><br /></div>
				---------------------------------------------------------------
			   	<div><pre><c:out value="${body}" escapeXml="false"/><br/></pre></div>
			   	<%
			   	StringBuffer sb = new StringBuffer();
				replyString(request ,sb, 
							(String)pageContext.getAttribute("responsibilityNumberLabel"), 
							(String)pageContext.getAttribute("emailLabel"),
							(String)pageContext.getAttribute("ordererNameLabel"),
							(String)pageContext.getAttribute("postAddressLabel"),
							(String)pageContext.getAttribute("deliveryAddressLabel"),
							(String)pageContext.getAttribute("orgUnitLabel"),
							(String)pageContext.getAttribute("phoneLabel"),
							(String)pageContext.getAttribute("messageLabel"));
				out.print(sb.toString());
			   	%>
			   	--------------------------------------------------------------- 
			   	<div>IP-nummer: <%= request.getRemoteAddr() %></div> 
			</c:set>
			
			<common:mail id="mailStatus" from="no-reply@gu.se" to="${mailrecipient}" cc="${param.email}" subject="${messageSubject}" type="text/html" charset="utf-8" message="${message}"/>
			
			<div id="GUshopComp" class="reciept">
			
				<c:choose>
					<c:when test="${mailStatus}">
						<h1><c:out value="${pHeader}"/></h1>
				
						<%
						StringBuffer sb = new StringBuffer();
						replyString(request, sb, 
									(String)pageContext.getAttribute("responsibilityNumberLabel"), 
									(String)pageContext.getAttribute("emailLabel"),
									(String)pageContext.getAttribute("ordererNameLabel"),
									(String)pageContext.getAttribute("postAddressLabel"),
									(String)pageContext.getAttribute("deliveryAddressLabel"),
									(String)pageContext.getAttribute("orgUnitLabel"),
									(String)pageContext.getAttribute("phoneLabel"),
									(String)pageContext.getAttribute("messageLabel"));
						out.print(sb.toString());
						%>
						<p><em><c:out value="${mess}"/> <%=aDate%> </em></p>
											
					</c:when>
					<c:otherwise>
						<h1>Error / Fel</h1>
						
						<c:choose>
							<c:when test="${commonMailTagException.class.name == 'javax.mail.internet.AddressException'}">
								<h2><c:out value="${commonMailTagException.message}"/></h2>
								<p><a href="javascript:history.go(-1);">Tillbaka</a></p>
							</c:when>
							<c:otherwise>
								<h2>Error sending orderform / Fel vid skickande av formul&auml;r</h2>
								<p>Ordern kunde inte skickas - var god kontakta oss per telefon (031-773 1000) och p&aring;tala felet. Felet som rapporterades var: <c:out value="${commonMailTagException.message}"/></p>
							</c:otherwise>
						</c:choose>
	
					</c:otherwise>
				</c:choose>
					
			</div>
			
		</c:when>
		<c:otherwise>
		
			<page:deliveryContext id="dc" disablePageCache="true"/>
			<common:gapcha id="catpchaImageUrl" textVariableName="catpchaText" numberOfCharacters="4" fontName="Courier" fontSize="20" 
				fontStyle="0" fgColor="10:10:10:255" bgColor="255:255:255:255" padTop="4" padBottom="4" renderWidth="107" padLeft="5" 
				twirlAngle="0.2" marbleXScale="0.8"  marbleYScale="0.8" marbleTurbulence="0.5" marbleAmount="1.2" allowedCharacters="ABDEFHKMRT"/>
			
			<div id="GUshopComp" class="order">
				
				<form name="orderForm" action="#GUshopCompAnchor" method="post" >
					<input type="hidden" name="sendOrder" value="true"/>
					
					<h1><structure:componentLabel mapKeyName="orderHeadline"/></h1>
					
					<c:forEach var="inventory" items="${inventoryList}" varStatus="count">
			
						<content:assetUrl id="url" assetKey="ProductImage" contentId="${inventory.contentId}" />  
						<content:contentAttribute id="rubrik" contentId="${inventory.contentId}" attributeName="Title" parse="false" disableEditOnSight="true"/>
						<content:contentAttribute id="beskrivning" contentId="${inventory.contentId}" attributeName="Description" disableEditOnSight="true"/>
						<content:contentAttribute id="prodId" contentId="${inventory.contentId}" attributeName="ProductId" parse="false" disableEditOnSight="true"/>
	<common:transformText id="prodId" text="${prodId}" replaceString="[\',\"]" replaceWithString=""/>
					
						<div class="record">
							<img src="<c:out value='${url}' />" alt="" />
							<c:out value="${beskrivning}" escapeXml="false"/>
							<br />
							<label for="amount<c:out value="${count.count}"/>"><structure:componentLabel mapKeyName="orderLabel"/> </label>
							<input type="text" name="<c:out value="${prodId}" escapeXml="true"/>" value="<c:out value="${param[prodId]}" default="0"/>" id="amount<c:out value="${count.count}"/>" size="6" maxlength="3" />
							<%--<label><structure:componentLabel mapKeyName="piecesLabel"/></label>--%>
							<input type="hidden" name="orders" value="<c:out value="${prodId}" escapeXml="true"/>" />
						</div>
					</c:forEach>
			
					<a name="GUshopCompAnchor"></a>
					<h2><structure:componentLabel mapKeyName="orderPlacer"/></h2>             
			      
					<label for="ansvarsnummer"><structure:componentLabel mapKeyName="responsibilityNumberLabel"/></label><br />
					<input id="ansvarsnummer" name="ansvarsnummer" class="small" maxlength="4" value="<c:out value="${param.ansvarsnummer}"/>"/><br />
			
					<label for="email" <c:if test="${param.sendOrder == 'true' && empty param.email}">class="red"</c:if>><structure:componentLabel mapKeyName="emailLabel"/><c:if test="${empty param.sendOrder || not empty param.email}"><span class="red"></span></c:if></label><br />
					<input id="email" name="email" class="medium" maxlength="60" value="<c:out value="${param.email}"/>"/><br />
			
					<label for="namn" <c:if test="${param.sendOrder == 'true' && empty param.namn}">class="red"</c:if>><structure:componentLabel mapKeyName="ordererNameLabel"/><c:if test="${empty param.sendOrder || not empty param.namn}"><span class="red"></span></c:if></label><br />
					<input id="namn" class="medium" name="namn" maxlength="60" value="<c:out value="${param.namn}"/>"/><br />
							 
					<label for="postadress"><structure:componentLabel mapKeyName="postAddressLabel"/></label><br />
					<input id="postadress" class="medium" name="postadress" maxlength="60" value="<c:out value="${param.postadress}"/>"/><br />
			
					<label for="leveransadress"><structure:componentLabel mapKeyName="deliveryAddressLabel"/></label><br />
					<input id="leveransadress" class="medium" name="leveransadress" maxlength="60" value="<c:out value="${param.leveransadress}"/>"/><br />
			
					<label for="institution"><structure:componentLabel mapKeyName="orgUnitLabel"/></label><br />
					<input id="institution" class="medium" name="institution" maxlength="80" value="<c:out value="${param.institution}"/>"/><br />
					
					<label for="telefon" <c:if test="${param.sendOrder == 'true' && empty param.telefon}">class="red"</c:if>><structure:componentLabel mapKeyName="phoneLabel"/><c:if test="${empty param.sendOrder || not empty param.telefon}"><span class="red"></span></c:if></label><br />
					<input id="telefon" class="small" name="telefon" maxlength="12" value="<c:out value="${param.telefon}"/>"/><br />
			
					<label for="message"><structure:componentLabel mapKeyName="messageLabel"/></label><br />
					<textarea name="message" id="message" title="<structure:componentLabel mapKeyName="messageTitle"/>" rows="10" cols="46" class="medium"><c:out value="${param.message}"/></textarea><br />
			
					<label for="captchaText" <c:if test="${param.sendOrder == 'true' && correctCatpchaText != param.captchaText}">class="red"</c:if>><structure:componentLabel mapKeyName="stateCaptchaLabel"/> <c:if test="${empty param.sendOrder}"><span class="red"></span></c:if></label><br />
				 	<input type="hidden" id="captchaTextVariableName" name="captchaTextVariableName" value="<c:out value="${catpchaText}" escapeXml="false"/>"/>
				 	<input type="text" id="captchaText" class="small" style="width: 110px;" name="captchaText" maxlength="10"/> <br/> 
				 	<img src="<c:out value="${catpchaImageUrl}" escapeXml="false"/>" style="border: 1px solid #333;" alt="captcha"/><br /><br />
	
					<p class="OBSmessage"><span class="red"></span> = <structure:componentLabel mapKeyName="obsLabel"/></p>
			
					<input type="reset" name="Reset" id="Reset" value="<structure:componentLabel mapKeyName="resetLabel"/>"/>                   
					<input value="<structure:componentLabel mapKeyName="submitLabel"/>" id="Submit" name="Submit" type="submit"/>
			
				</form>
				
			</div>
		
		</c:otherwise>
	</c:choose>
</c:catch>

<c:if test="${not empty myError}">
	<p>
		An error has occured: <c:out value="${myError}"/>
		<%
			Throwable myException = (Throwable)pageContext.getAttribute("myError");
			java.io.StringWriter sw = new java.io.StringWriter();
			java.io.PrintWriter pw 	= new java.io.PrintWriter(sw);
			myException.printStackTrace(pw);
			System.out.print(sw.toString());
		%>
	</p>
</c:if>