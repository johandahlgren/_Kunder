<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>

<page:pageContext id="pc"/>

<common:getCookie id="isfSelectedContrast" name="isfSelectedContrast"/>

<c:set var="highSelected" value=""/>

<c:if test="${isfSelectedContrast eq 'high' || param.contrast eq 'high'}">
	<c:set var="highSelected" value="selected='selected'"/>
</c:if>

<c:if test="${not empty param.resetStyles || param.contrast eq 'standard'}">
	<c:set var="highSelected" value=""/>
</c:if>

<%
	out.print("<!-- timestamp: " + System.currentTimeMillis() + " -->");
%>

<!-- eri-no-index -->
<div class="contrastSwitchContainer">
	<div id="contrastSwitch">
		<div class="innerContainer">
			<form action="<c:out value="${pc.currentPageUrl}"/>" method="post">
				<fieldset>
					<input type="hidden" id="resetStyles" name="resetStyles" value="">
					<legend><structure:componentLabel mapKeyName="Legend"/></legend>
					<div class="fieldCol">
						<label for="contrastSetting"><structure:componentLabel mapKeyName="ContrastMode"/></label>
						<select name="contrast" id="contrastSetting">
							<option value="standard"><structure:componentLabel mapKeyName="Standard"/></option>
							<option value="high" <c:out value="${highSelected}" />><structure:componentLabel mapKeyName="High"/></option>
						</select>
					</div>
					<div class="buttonCol">
						<input name="save" type="submit" value="<structure:componentLabel mapKeyName="SaveText"/>" class="button save" title="<structure:componentLabel mapKeyName="SaveTitleText"/>" />
						<input name="reset" type="submit" value="<structure:componentLabel mapKeyName="ResetText"/>" title="<structure:componentLabel mapKeyName="ResetTitleText"/>" class="button reset" onclick="$('#resetStyles').val('true');"/>
					</div>
				</fieldset>
			</form> 
		</div>
	</div> 
</div>
<!-- /eri-no-index --> 