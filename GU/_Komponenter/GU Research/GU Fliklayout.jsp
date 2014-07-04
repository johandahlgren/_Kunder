<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>

<% long startTime = System.currentTimeMillis(); %>

<page:pageContext id="pc"/>

<script type="text/javascript">
	function displayTabAndTabContent(aTabId)
	{
		jQuery(".tab").removeClass("tabSelected");
		jQuery("#tab" + aTabId).addClass("tabSelected");
		
		jQuery(".tabContent").hide();
		jQuery("#tabContent" + aTabId).show();
	}
</script>

<structure:componentPropertyValue id="tabNames" propertyName="TabNames" useInheritance="false" />
<structure:componentPropertyValue id="tabNamesEnglish" propertyName="TabNamesEnglish" useInheritance="false" />
<structure:componentPropertyValue id="tabTextMaxLength" propertyName="TabTextMaxLength" useInheritance="false" />

<c:if test="${pc.locale.language eq 'en'}">
	<c:set var="tabNames" value="${tabNamesEnglish}" />
</c:if>

<%
	String tabNamesString = (String)pageContext.getAttribute("tabNames");
	int tabTextMaxLength = Integer.parseInt((String)pageContext.getAttribute("tabTextMaxLength"));
	String[] tabs = tabNamesString.split(",");
	
	for (int i = 0; i < tabs.length; i ++)
	{
		if (tabs[i].length() > tabTextMaxLength)
		{
			tabs[i] = tabs[i].substring(0, tabTextMaxLength) + "...";
		}
	}
	
	pageContext.setAttribute("tabs", tabs);
%>

<ig:slot id="tabHeader" inherit="false" allowedComponentGroupNames="Single Content,Content Iterators,Other,Search,Form elements"></ig:slot>

<div class="tabContainer">
	<%
		String tabName = "";
				
		for (int i = 1; i < 6; i ++)
		{
			try
			{
				tabName = tabs[i -1];
			}
			catch (Exception e)
			{
				tabName = "UNDEFINED";
			}
//			out.print("<div id=\"tab" + i + "\" class=\"tab\" onclick=\"displayTabAndTabContent(" + i + ");\"><a tabindex=\"0\" onclick=\"lostFocus();\" href=\"#tabContentAnchor" + i + "\">" + tabName + "</a></div>");
			out.print("<a id=\"tab" + i + "\" class=\"tab\" onclick=\"displayTabAndTabContent(" + i + ");blur();\" tabindex=\"0\" href=\"#tabContentAnchor" + i + "\">" + tabName + "</a>");
		}
	%>
</div>

<noscript>
	<p>
		<%
			String tabNameNoScript = "";
					
			for (int i = 1; i < 6; i ++)
			{
				try
				{
					tabNameNoScript = tabs[i -1];
					out.print("<a tabindex=\"0\" href=\"#tabContentAnchor" + i + "\">" + tabNameNoScript + "</a> | ");
				}
				catch (Exception e)
				{
					// Do nothing
				}
			}
		%>
	</p>
</noscript>

<script type="text/javascript">
	$(".tabContainer").show();
	$(".tabContainer").css("visibility", "visible");
</script>

<div class="tabContents">
	<div id="tabContent1" class="tabContent <c:if test="${selectedTab eq '1'}">tabContentSelected</c:if>">
		<noscript>
			<a name="tabContentAnchor1"></a>
			<h2><c:out value="${tabs[0]}" /></h2>
		</noscript>
		<ig:slot id="tabSlot1" inherit="false" allowedComponentGroupNames="ResearchComponents"></ig:slot>
	</div>
	<div id="tabContent2" class="tabContent <c:if test="${selectedTab eq '2'}">tabContentSelected</c:if>">
		<noscript>
			<a name="tabContentAnchor2"></a>
			<h2><c:out value="${tabs[1]}" /></h2>
		</noscript>
		<ig:slot id="tabSlot2" inherit="false" allowedComponentGroupNames="ResearchComponents"></ig:slot>
	</div>
	<div id="tabContent3" class="tabContent <c:if test="${selectedTab eq '3'}">tabContentSelected</c:if>">
		<noscript>
			<a name="tabContentAnchor3"></a>
			<h2><c:out value="${tabs[2]}" /></h2>
		</noscript>
		<ig:slot id="tabSlot3" inherit="false" allowedComponentGroupNames="ResearchComponents"></ig:slot>
	</div>
	<div id="tabContent4" class="tabContent <c:if test="${selectedTab eq '4'}">tabContentSelected</c:if>">
		<noscript>
			<a name="tabContentAnchor4"></a>
			<h2><c:out value="${tabs[3]}" /></h2>
		</noscript>
		<ig:slot id="tabSlot4" inherit="false" allowedComponentGroupNames="ResearchComponents"></ig:slot>
	</div>
	<div id="tabContent5" class="tabContent <c:if test="${selectedTab eq '5'}">tabContentSelected</c:if>">
		<noscript>
			<a name="tabContentAnchor5"></a>
			<h2><c:out value="${tabs[4]}" /></h2>
		</noscript>
		<ig:slot id="tabSlot5" inherit="false" allowedComponentGroupNames="ResearchComponents"></ig:slot>
	</div>
	
	<script type="tyext/javascript">
		$(".tabContent").hide();
	</script>
</div>

<script type="text/javascript">

	function getHash() {
	    var currentUrl = "" + document.location;
	    var hash = "";
	    var parts = currentUrl.split("#");
	    if (parts.length > 1) {
	        hash = parts[1];
	    }
	    return hash;
	}

	function showTabIfNotEmpty(aTabId)
	{
		$("#tabContent" + aTabId + " div.guResearchComp").each(function() {
			if (jQuery.trim($(this).html()).length > 0)
			{
				$("#tab" + aTabId).show();
				displayTabAndTabContent(aTabId);
			}
		});
	}
	
	for (i = 5; i >= 1; i --)
	{
		showTabIfNotEmpty(i);
	}
	
	var hash = getHash();
	var selectedTab = "<c:out value="${param.selectedTab}"/>";
	var pageId = "";
	if (hash != "") {
		var id = hash.substring(hash.length - 1);
		if (!isNaN(id))
		{
			pageId = id;
		}
	}

	if (pageId == "") {
		if (selectedTab != "") {
			if (!isNaN(selectedTab)) {
				pageId = selectedTab;
			}
		}
	}

	if (pageId != "")
	{
		displayTabAndTabContent(pageId);
	}
	
	window.addEventListener("hashchange", function() {
		var hash = getHash();
		var pageId = "";
		if (hash != "") {
			var id = hash.substring(hash.length - 1);
			if (!isNaN(id))
			{
				pageId = id;
			}
		}
		if (pageId != "")
		{
			displayTabAndTabContent(pageId);
		}
	}, false);
	

</script>

<structure:componentPropertyValue id="doLogging" propertyName="DoLogging" useInheritance="true"/>
<c:if test="${doLogging eq 'true'}">
<% 
  long endTime = System.currentTimeMillis();
  org.apache.log4j.Logger logger = org.apache.log4j.Logger.getLogger("fliklayout");
  org.apache.log4j.FileAppender fa = new org.apache.log4j.FileAppender(new  org.apache.log4j.PatternLayout("%d#%c - %m%n"), "/appl/cms/webapps/infoglueCMS/researchFiles/timings.log");
  logger.removeAllAppenders();
  logger.addAppender(fa);
  logger.setLevel(org.apache.log4j.Level.INFO);
  logger.info("comp= took:'" + (endTime - startTime) + "' params:'" + request.getQueryString()  + "'");
%>
</c:if>