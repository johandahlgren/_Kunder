<%@page import="java.net.URLEncoder"%>
<%@page import="org.infoglue.deliver.util.Timer"%>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<page:pageContext id="pc"/>
<page:deliveryContext id="dc" disablePageCache="true"/>

<c:catch var ="error">

<c:set var="suffix" value=""/>
<c:if test="${pc.locale.language == 'en'}">
    <c:set var="suffix" value="_E"/>
</c:if>

<common:urlBuilder id="currentUrl" excludedQueryStringParameters="ref,Type,Dnr"/>
<c:set var="separator" value="?"/>
<%
String currentUrl = (String)pageContext.getAttribute("currentUrl");
if(currentUrl.indexOf("?") > -1)
    pageContext.setAttribute("separator", "&");
%>

<c:set var="devMode" value="false"/>
<%
String hostName = request.getServerName();
if(hostName.indexOf("dev.cms.it.gu.se") > -1)
	pageContext.setAttribute("devMode", "true");
%>

<c:choose>
	<c:when test="${not empty param.ref}">
			<c:set var="relatedContent" value=""/>

		<c:choose>
			<c:when test="${devMode == true}">
				<common:import id="ledigaTjanster" url="http://gudok.test.gu.se/E-rek_ANS/Utdata/TjansterIKategori${suffix}.aspx?ref=${param.ref}" timeout="20000" useCache="true" cacheName="ledigaTjanster" cacheTimeout="60000" charEncoding="iso-8859-1"/>
				<%
				String ledigaTjanster = (String)pageContext.getAttribute("ledigaTjanster");
				//System.out.println("ledigaTjanster:" + ledigaTjanster);
				%>
		  		<common:transformText id="ledigaTjanster" text="${ledigaTjanster}" replaceString="http://gudok.test.gu.se/E-rek_ANS/Utdata/TjanstInfo\.aspx" replaceWithString="${currentUrl}${separator}"/>
		  		<common:transformText id="ledigaTjanster" text="${ledigaTjanster}" replaceString="http://dev.cms.it.gu.se/infoglueDeliverWorking/ViewPage.action\\?siteNodeId=130738" replaceWithString="${currentUrl}${separator}"/>
			</c:when>
			<c:otherwise>
				<common:import id="ledigaTjanster" url="https://gudok.gu.se/E-rek_ANS/Utdata/TjansterIKategori${suffix}.aspx?ref=${param.ref}" timeout="20000" useCache="true" cacheName="ledigaTjanster" cacheTimeout="60000" charEncoding="iso-8859-1"/>
				<%
				String ledigaTjanster = (String)pageContext.getAttribute("ledigaTjanster");
				//System.out.println("ledigaTjanster:" + ledigaTjanster);
				%>
		  		<common:transformText id="ledigaTjanster" text="${ledigaTjanster}" replaceString="https://gudok.gu.se/E-rek_ANS/Utdata/TjanstInfo\.aspx" replaceWithString="${currentUrl}${separator}"/>
		  		<%-- <page:pageAttribute name="ledigaTjansterDebug" value="${ledigaTjanster}"/>--%>
		  		<common:transformText id="ledigaTjanster" text="${ledigaTjanster}" replaceString="http://www.gu.se/omuniversitetet/aktuellt/ledigaanstallningar/annonser-i-sokandeportalen/" replaceWithString="${currentUrl}${separator}"/>
			</c:otherwise>		
		</c:choose>

		<%--<structure:componentLabel id="ledigaTjansterTitle" mapKeyName="ledigaTjansterTitle"/>--%>

		<content:content id="moreInformationArticleContent" propertyName="moreInformationArticle" useInheritance="false"/>
		<c:if test="${not empty moreInformationArticleContent && param.ref == 'L'}">
			<c:set var="relatedContent">
				<h1><content:contentAttribute attributeName="Title" propertyName="moreInformationArticle" useInheritance="false"/></h1>
				<content:contentAttribute attributeName="Text" propertyName="moreInformationArticle" useInheritance="false"/>
			</c:set>
		</c:if>
		<content:content id="loginInfoArticleContent" propertyName="loginInfoArticle" useInheritance="false"/>
		<c:if test="${not empty loginInfoArticleContent}">
			<c:set var="relatedContent">
				<c:out value="${relatedContent}" escapeXml="false"/>
				<h1><content:contentAttribute attributeName="Title" propertyName="loginInfoArticle" useInheritance="false"/></h1>
				<content:contentAttribute attributeName="Text" propertyName="loginInfoArticle" useInheritance="false"/>
			</c:set>
		</c:if>

		<page:pageAttribute name="w3d3RelatedInfo" value="${relatedContent}"/>

		<c:set var="ledigaTjansterTitle" value=""/>
		<c:if test="${not empty param.tjanstNamn}">
			<c:set var="ledigaTjansterTitle" value="${param.tjanstNamn}"/>
		</c:if>
		<page:pageAttribute name="title" value="${ledigaTjansterTitle}"/>
		<page:pageAttribute name="content" value="${ledigaTjanster}"/>
	</c:when>
	<c:when test="${not empty param.Type && not empty param.Dnr}">
		
<c:if test="${param.disableRedirect != 'true' && ((param.Type == 'E' && pc.locale.language != 'en') || (param.Type == 'S' && pc.locale.language != 'sv'))}">
			
			<common:urlBuilder id="currentLangUrlRedirect" fullBaseUrl="true" excludedQueryStringParameters="siteNodeId,languageId,contentId,disableRedirect,returnUrl"/>
			<common:URLEncode id="currentLangUrlRedirect" value="${currentLangUrlRedirect}"/>
			<structure:boundPage id="alternateLanguageStartPageRedirect" propertyName="AlternateLanguageStartPage" useRepositoryInheritance="false"/>
			<structure:pageUrl id="alternateLanguageStartPageUrlRedirect" propertyName="AlternateLanguageStartPage" languageId="${alternativeLanguage.id}" useRepositoryInheritance="false"/>
			<common:urlBuilder id="alternateLanguageStartPageUrlRedirect" baseURL="${alternateLanguageStartPageUrlRedirect}" excludedQueryStringParameters="disableRedirect,returnUrl">
				<common:parameter name="disableRedirect" value="true"/>
				<%--<common:parameter name="returnUrl" value="${currentLangUrl}"/>--%>
			</common:urlBuilder>
        	<%
        	System.out.println("Redirecting to:" + pageContext.getAttribute("alternateLanguageStartPageUrlRedirect"));
        	%>
            <common:sendRedirect url="${alternateLanguageStartPageUrlRedirect}"/>
        </c:if>

		<c:set var="type" value="S"/>
		<c:if test="${pc.locale.language == 'en'}">
			<c:set var="type" value="E"/>
		</c:if>
		<c:choose>
			<c:when test="${devMode == true}">
	  			<common:import id="ledigaTjanster" url="http://gudok.test.gu.se/E-rek_ANS/Utdata/TjanstInfo_XML.aspx?Dnr=${param.Dnr}&Type=${type}" timeout="20000" useCache="true" cacheName="ledigaTjanster" cacheTimeout="60000" charEncoding="iso-8859-1"/>
			</c:when>
			<c:otherwise>
	  			<common:import id="ledigaTjanster" url="https://gudok.gu.se/E-rek_ANS/Utdata/TjanstInfo_XML.aspx?Dnr=${param.Dnr}&Type=${type}" timeout="20000" useCache="true" cacheName="ledigaTjanster" cacheTimeout="60000" charEncoding="iso-8859-1"/>
			</c:otherwise>		
		</c:choose>
		
		<%
		Timer t = new Timer();

		String ledigaTjanster = (String)pageContext.getAttribute("ledigaTjanster");
		//System.out.println("ledigaTjanster:" + ledigaTjanster);
		ledigaTjanster = ledigaTjanster.replaceAll("<BR>","");
		ledigaTjanster = ledigaTjanster.replaceAll("&amp;","&").replaceAll("&","&amp;");
		ledigaTjanster = ledigaTjanster.replaceAll("<P>","<p>").replaceAll("</P>","</p>");
		ledigaTjanster = ledigaTjanster.replaceAll("<br>","<br/>").replaceAll("<BR>","<br/>");
		//System.out.println("ledigaTjanster:" + ledigaTjanster);
		int tjanstdataStart = ledigaTjanster.indexOf("<tjanstdata>");
		String tjanstdata = ledigaTjanster.substring(tjanstdataStart, ledigaTjanster.indexOf("</tjanstdata>", tjanstdataStart) + 13);
		//System.out.println("tjanstdata:" + tjanstdata);
		org.infoglue.cms.util.dom.DOMBuilder domBuilder = new org.infoglue.cms.util.dom.DOMBuilder();
		org.dom4j.Document document = domBuilder.getDocument(tjanstdata);
		
		//t.printElapsedTime("Parsing XML took...");

		String rubrik = document.selectSingleNode("//div[@id='rubrik']").getText();
		String anstallningsform = document.selectSingleNode("//div[@id='anstallningsform']").getText();
        String omfattning = document.selectSingleNode("//div[@id='omfattning']").getText();
        String placering = document.selectSingleNode("//div[@id='placering']").getText();
        String tilltrade = document.selectSingleNode("//div[@id='tilltrade']").getText();
        if(tilltrade != null)
            tilltrade = tilltrade.replaceAll("SnarastProvanst", "Snarast<br/>Provanst").replaceAll("possibleApply", "possible<br/>Apply").replaceAll("possibleProbationary", "possible<br/>Probationary");

        String diarieNummer = document.selectSingleNode("//div[@id='diarieNummer']").getText();
        String amne = document.selectSingleNode("//div[@id='amne']").getText();
        //String amnesbeskrivning = document.selectSingleNode("//div[@id='amnesbeskrivning']").getText();
        String amnesbeskrivning = document.selectSingleNode("//div[@id='amnesbeskrivning']").asXML().replaceAll("<div.*?>", "").replaceAll("</div>", "").replaceAll("<P/>", "").replaceAll("<p/>", "");

        String introduktion = document.selectSingleNode("//div[@id='introduktion']").asXML().replaceAll("<div.*?>", "").replaceAll("</div>", "");
       	//System.out.println("introduktion:" + introduktion);
		int commaStart = introduktion.indexOf(":");
		introduktion = introduktion.substring(commaStart + 1);
		//System.out.println("introduktion:" + introduktion);
		
        String arbetsuppgifter = document.selectSingleNode("//div[@id='arbetsuppgifter']").asXML().replaceAll("<div.*?>", "").replaceAll("</div>", "").replaceAll("<P/>", "").replaceAll("<p/>", "");
       	//System.out.println("arbetsuppgifter:" + arbetsuppgifter);
       	
       	String kvalifikationer = document.selectSingleNode("//div[@id='kvalifikationer']").asXML().replaceAll("<div.*?>", "").replaceAll("</div>", "").replaceAll("<P/>", "").replaceAll("<p/>", "");
       	//System.out.println("kvalifikationer:" + kvalifikationer);
       	
        String employer = document.selectSingleNode("//div[@id='employer']").asXML().replaceAll("<div.*?>", "").replaceAll("</div>", "").trim();
       	//System.out.println("employer:" + employer);
	if(employer.startsWith("<br/>"))
        	employer = employer.substring(5);
       	employer = employer.replaceAll("<br/>\\s*?(\\r\\n|\\r|\\n|\\n\\r)\\s*?<br/><a", "<br/><a");
	
	String kontaktUppgifter = document.selectSingleNode("//div[@id='kontaktUppgifter']").getText();
				
        String ovrigText = document.selectSingleNode("//div[@id='ovrigText']").asXML().replaceAll("<div.*?>", "").replaceAll("</div>", "");
       	//System.out.println("ovrigText:" + ovrigText);
		
        String ansokningsForfarande = document.selectSingleNode("//div[@id='ansokningsForfarande']").asXML().replaceAll("<div.*?>", "").replaceAll("</div>", "");
       	//System.out.println("ansokningsForfarande:" + ansokningsForfarande);

        String ovrigStandardtext = document.selectSingleNode("//div[@id='ovrigStandardtext']").asXML().replaceAll("<div.*?>", "").replaceAll("</div>", "");
       	//System.out.println("ovrigStandardtext:" + ovrigStandardtext);

        String fackligData = document.selectSingleNode("//div[@id='fackligData']").asXML().replaceAll("<div.*?>", "").replaceAll("</div>", "").trim();
	fackligData = org.apache.commons.lang.StringUtils.remove(fackligData, "<a href=\"mailto:\" target=\"_blank\"/><br/>");
        if(fackligData.startsWith("<br/>"))
        	fackligData = fackligData.substring(5);
        //System.out.println("fackligData 1:" + fackligData);
        
        org.dom4j.Node node = document.selectSingleNode("//div[@id='behorighet']/*");
        if(node == null)
        	node = document.selectSingleNode("//div[@id='behorighet']");
        String behorighet = (node.getText().equals("") ? "" : node.asXML());

        String bedomningsgrund = document.selectSingleNode("//div[@id='bedomningsgrund']").asXML().replaceAll("<div.*?>", "").replaceAll("</div>", "").replaceAll("<P/>", "").replaceAll("<p/>", "").trim();

		/*
        node = document.selectSingleNode("//div[@id='bedomningsgrund']/*");
        if(node == null)
        	node = document.selectSingleNode("//div[@id='bedomningsgrund']");
        String bedomningsgrund = (node.getText().equals("") ? "" : node.asXML());
        node = document.selectSingleNode("//div[@id='fackligData']/*");
        if(node == null)
        	node = document.selectSingleNode("//div[@id='fackligData']");
        String fackligData = (node.getText().equals("") ? "" : node.asXML());
		*/
		//String fackligData = document.selectSingleNode("//div[@id='fackligData']").getText();
		
		String relatedInfo = document.selectSingleNode("//div[@id='relatedInfo']").getText();
        String siteLink = document.selectSingleNode("//div[@id='siteLink']").getText();
        if(siteLink != null)
        siteLink = siteLink.replaceAll("http://","");
		String lastApplyDate = document.selectSingleNode("//div[@id='lastApplyDate']").getText();
		String ansokLink = document.selectSingleNode("//div[@id='ansokLink']").getText();
        String jamstalldhet = document.selectSingleNode("//div[@id='jamstalldhet']").getText();
        String infoLonesattning = document.selectSingleNode("//div[@id='infoLonesattning']").getText();
        String gallring = document.selectSingleNode("//div[@id='gallring']").getText();
        //t.printElapsedTime("Parsing all attributes took...");

        pageContext.setAttribute("anstallningsform", anstallningsform);
        pageContext.setAttribute("omfattning", omfattning);
        pageContext.setAttribute("placering", placering);
        pageContext.setAttribute("tilltrade", tilltrade);

        pageContext.setAttribute("diarieNummer", diarieNummer);
        pageContext.setAttribute("introduktion", introduktion);
        pageContext.setAttribute("amne", amne);
        pageContext.setAttribute("amnesbeskrivning", amnesbeskrivning);
        pageContext.setAttribute("arbetsuppgifter", arbetsuppgifter);
        
        pageContext.setAttribute("kvalifikationer", kvalifikationer);
        pageContext.setAttribute("behorighet", behorighet);
        pageContext.setAttribute("bedomningsgrund", bedomningsgrund);
        pageContext.setAttribute("ovrigText", ovrigText);

        pageContext.setAttribute("relatedInfo", relatedInfo);
        pageContext.setAttribute("ansokningsForfarande", ansokningsForfarande);

        pageContext.setAttribute("kontaktUppgifter", kontaktUppgifter);
        pageContext.setAttribute("employer", employer);
        pageContext.setAttribute("siteLink", siteLink);
        pageContext.setAttribute("fackligData", fackligData);
        pageContext.setAttribute("lastApplyDate", lastApplyDate);
        pageContext.setAttribute("ansokLink", ansokLink);
        pageContext.setAttribute("jamstalldhet", jamstalldhet);
        pageContext.setAttribute("infoLonesattning", infoLonesattning);
        pageContext.setAttribute("gallring", gallring);
		%>
		<c:set var="content">
		
			<h1><%=rubrik%></h1>
			<p>
				<structure:componentLabel mapKeyName="anstallningsform"/>: <%= anstallningsform %><br/>
				<structure:componentLabel mapKeyName="omfattning"/>: <%= omfattning %> %<br/>
				<structure:componentLabel mapKeyName="placering"/>: <%= placering %><br/>
				<structure:componentLabel mapKeyName="tilltrade"/>: <%= tilltrade %><br/>
				<structure:componentLabel mapKeyName="diarieNummer"/>: <%= diarieNummer %><br/>
			</p> 
			<c:if test="${not empty introduktion}">
			<%= introduktion %>
			</c:if>			
			<c:if test="${not empty amne}">
		        <h3><structure:componentLabel mapKeyName="amne"/></h3>
			<p><%= amne %></p>
			</c:if>	
			<c:if test="${not empty amnesbeskrivning}">
		        <h3><structure:componentLabel mapKeyName="amnesbeskrivning"/></h3>
				<%= amnesbeskrivning %>
			</c:if>	
			<c:if test="${not empty arbetsuppgifter}">
		        <h3><structure:componentLabel mapKeyName="arbetsuppgifter"/></h3>
		        <p><%= arbetsuppgifter %></p>
		    </c:if>
			<c:if test="${not empty kvalifikationer}">
				<div class="kvalifikationerSection">
					<h3><structure:componentLabel mapKeyName="kvalifikationer"/></h3>
					<p><%= kvalifikationer %></p>
				</div>
			</c:if>
			<c:if test="${not empty behorighet}">
				<div class="behorighetSection">
					<h3><structure:componentLabel mapKeyName="behorighet"/></h3>
					<p><%= behorighet %></p>
				</div>
			</c:if>
			<c:if test="${not empty bedomningsgrund}">
				<div class="bedomningsgrundSection">
					<h3><structure:componentLabel mapKeyName="bedomningsgrund"/></h3>
					<p><%= bedomningsgrund %></p>
				</div>
			</c:if>
			<c:if test="${not empty ovrigText}">
		        <div class="ovrigTextSection">
		        	<h3><structure:componentLabel mapKeyName="ovrigText"/></h3>
		        	<p><%= ovrigText %></p>
				</div>
			</c:if>
		</c:set>
		<c:set var="relatedContent">
			<c:if test="${not empty relatedInfo}"><h1><%= relatedInfo %></h1></c:if>
			<c:if test="${not empty employer}">
				<h2><structure:componentLabel mapKeyName="kontaktUppgifter"/></h2>
				<p>
					<%= employer %><br/>
			<c:if test="${not empty siteLink}">
					<a href="http://<%= siteLink %>"><%= siteLink %></a>
			</c:if>
				</p>
			</c:if>
			<c:if test="${not empty fackligData}">
				<h2><structure:componentLabel mapKeyName="fackligData"/></h2>
				<p>
					<%= fackligData %><br/>
				</p>
			</c:if>
			<h2><structure:componentLabel mapKeyName="lastApplyDate"/></h2>
			<p>
				<%= lastApplyDate %><br/>
				<c:set var="type" value="S"/>
				<c:if test="${pc.locale.language == 'en'}">
					<c:set var="type" value="E"/>
				</c:if>
				<c:choose>
					<c:when test="${devMode == true}">
				    	<input type="button" id="${param.Dnr}" class="button"  style="font-size: 100%;" name="applyButton" value="<structure:componentLabel mapKeyName="applyOnline"/>" onclick="window.open('http://gudok.test.gu.se/E-rek_CV/Login.aspx?Dnr=<c:out value="${param.Dnr}"/>&type=<c:out value="${type}"/>', 'CustomPopUp') ">
					</c:when>
					<c:otherwise>
				    	<input type="button" id="${param.Dnr}" class="button"  style="font-size: 100%;" name="applyButton" value="<structure:componentLabel mapKeyName="applyOnline"/>" onclick="window.open('https://gudok.gu.se/E-rek_CV/Login.aspx?Dnr=<c:out value="${param.Dnr}"/>&type=<c:out value="${type}"/>', 'CustomPopUp') ">
					</c:otherwise>		
				</c:choose>
			</p>
			<c:if test="${not empty ansokningsForfarande}">
				<h2><structure:componentLabel mapKeyName="ansokningsForfarande"/></h2>
				<p>
					<%= ansokningsForfarande %><br/>
				</p>
			</c:if>
			<c:if test="${not empty jamstalldhet}"><p><%= jamstalldhet %><br/></p></c:if>
			<c:if test="${not empty infoLonesattning}"><p><%= infoLonesattning %><br/></p></c:if>
			<c:if test="${not empty gallring}"><p><%= gallring %><br/></p></c:if>
			<c:if test="${not empty ovrigStandardtext}"><p><%= ovrigStandardtext %><br/></p></c:if>
		</c:set>
		
		<%
		pageContext.setAttribute("tjanstdata", tjanstdata);
		pageContext.setAttribute("tjanstdataDocument", document);
		pageContext.setAttribute("ledigaTjanster", org.apache.commons.lang.StringUtils.replace(ledigaTjanster, tjanstdata, ""));
		%>
		<page:pageAttribute name="content" value="${content}"/>
		<page:pageAttribute name="w3d3RelatedInfo" value="${relatedContent}"/>
	</c:when>
	<c:otherwise>

		<c:choose>
			<c:when test="${devMode == true}">
		        <c:set var="url">http://gudok.test.gu.se/E-rek_ANS/Utdata/TjansterPerKategori<c:out value="${suffix}"/>.aspx</c:set>
			  	<common:import id="ledigaTjanster" url="${url}" timeout="20000" useCache="false" cacheName="ledigaTjanster" cacheTimeout="60000" charEncoding="iso-8859-1"/>
			</c:when>
			<c:otherwise>
		        <c:set var="url">https://gudok.gu.se/E-rek_ANS/Utdata/TjansterPerKategori<c:out value="${suffix}"/>.aspx</c:set>
			  	<common:import id="ledigaTjanster" url="${url}" timeout="20000" useCache="false" cacheName="ledigaTjanster" cacheTimeout="60000" charEncoding="iso-8859-1"/>
			</c:otherwise>		
		</c:choose>

		<structure:componentLabel id="noItems" mapKeyName="noItems"/>
		
		<%
		String noItems = (String)pageContext.getAttribute("noItems");
		String ledigaTjanster = (String)pageContext.getAttribute("ledigaTjanster");
		//System.out.println("ledigaTjanster:" + ledigaTjanster);
		int startIndex = ledigaTjanster.indexOf("<ul");
		int endIndex = ledigaTjanster.indexOf("</ul>");
		if(startIndex > 0 && endIndex > startIndex)
			ledigaTjanster = ledigaTjanster.substring(startIndex, endIndex + 5);
		
		java.util.Map<String,String> changes = new java.util.HashMap<String,String>();
		int indexOfHref = ledigaTjanster.indexOf("href");
		while(indexOfHref > -1)
		{
			int startName = ledigaTjanster.indexOf(">", indexOfHref) + 1;
			int endName = ledigaTjanster.indexOf("</a>", startName);
			String name = ledigaTjanster.substring(startName, endName).trim().replaceAll(" \\([0-9]{1,3}\\)", "");
			//System.out.println("name:" + name);
			int startPos = indexOfHref + 6;
			int endPos = ledigaTjanster.indexOf("'", startPos);
			//System.out.println("startPos:" + startPos);
			//System.out.println("endPos:" + endPos);
			String href = ledigaTjanster.substring(indexOfHref + 6, endPos);
			//System.out.println("Adding:" + name + " to " + href);
			changes.put(href, name);
			
			indexOfHref = ledigaTjanster.indexOf("href", endName);
		}
		
		for (java.util.Map.Entry<String, String> entry : changes.entrySet())
		{
		    //System.out.println("Replacing " + entry.getKey() + " with " + entry.getValue());
			ledigaTjanster = org.apache.commons.lang.StringUtils.replace(ledigaTjanster, entry.getKey(), entry.getKey() + "&tjanstNamn=" + URLEncoder.encode(entry.getValue(), "utf-8"));
			//System.out.println("ledigaTjanster after:" + ledigaTjanster);
		}
		ledigaTjanster = org.apache.commons.lang.StringUtils.replace(ledigaTjanster, "(0)", "(" + noItems + ")");
		
		//System.out.println("ledigaTjanster:" + ledigaTjanster);
		pageContext.setAttribute("ledigaTjanster", ledigaTjanster);
		%>
		
		<c:choose>
			<c:when test="${devMode == true}">
			  	<common:transformText id="ledigaTjanster" text="${ledigaTjanster}" replaceString="http://gudok.test.gu.se/E-rek_ANS/Utdata/TjansterIKategori\.aspx" replaceWithString="${currentUrl}${separator}"/>
			</c:when>
			<c:otherwise>
			  	<common:transformText id="ledigaTjanster" text="${ledigaTjanster}" replaceString="https://gudok.gu.se/E-rek_ANS/Utdata/TjansterIKategori\.aspx" replaceWithString="${currentUrl}${separator}"/>
			</c:otherwise>		
		</c:choose>
		
		<%--<structure:componentLabel id="ledigaTjansterTitle" mapKeyName="ledigaTjansterTitle"/>--%>
		<c:set var="ledigaTjansterTitle" value=""/>

		<content:content id="loginInfoArticleContent" propertyName="loginInfoArticle" useInheritance="false"/>
		<c:if test="${not empty loginInfoArticleContent}">
			<c:set var="relatedContent">
				<h1><content:contentAttribute attributeName="Title" propertyName="loginInfoArticle" useInheritance="false"/></h1>
				<content:contentAttribute attributeName="Text" propertyName="loginInfoArticle" useInheritance="false"/>
			</c:set>
			<page:pageAttribute name="w3d3RelatedInfo" value="${relatedContent}"/>
		</c:if>
		
		<page:pageAttribute name="title" value="${ledigaTjansterTitle}"/>
		<page:pageAttribute name="content" value="${ledigaTjanster}"/>
		<page:pageAttribute name="showTexts" value="true"/>
	</c:otherwise>
</c:choose>

</c:catch>
  <c:if test = "${error!=null}">
  	<c:set var="errorMessage"><!-- The exception is ${error}--></c:set>
        <page:pageAttribute name="content" value="${error}"/> 
<%
System.out.println("Error:" + pageContext.getAttribute("error"));
%>
  </c:if>