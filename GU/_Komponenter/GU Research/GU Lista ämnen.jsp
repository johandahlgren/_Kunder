<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-lucene" prefix="lucene" %>

<%@page import="java.util.Map" %>
<%@page import="org.apache.lucene.store.Directory" %>
<%@page import="se.gu.infoglue.lucene.SiteLuceneController.SearchResult" %>
<%@page import="se.gu.infoglue.lucene.SiteLuceneController" %>
<%@page import="org.infoglue.cms.applications.common.VisualFormatter" %>

<page:pageContext id="pc" />

<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="subjectId" propertyName="SubjectId" useInheritance="true" />
<structure:componentPropertyValue id="dataBasePath" propertyName="GUR_DataBasePath" useInheritance="true"/>
<structure:componentPropertyValue id="timeout" propertyName="GUR_LuceneCacheTimeout" useInheritance="true"/>

<structure:componentLabel id="showTitleText" mapKeyName="ShowTitleText"/>
<structure:componentLabel id="hideTitleText" mapKeyName="HideTitleText"/>
<structure:componentLabel id="showAltText" mapKeyName="ShowAltText"/>
<structure:componentLabel id="hideAltText" mapKeyName="HideAltText"/>
<content:assetUrl id="expandImageUrl" propertyName="Mallbilder" assetKey="expandTreeNode"/>
<content:assetUrl id="closeImageUrl" propertyName="Mallbilder" assetKey="closeTreeNode"/>

<%-- 
<structure:pageUrl id="subjectDetailUrl" propertyName="GUR_SubjectDetailPage" useInheritance="true" />--%>

<c:set var="langCode" value="${pc.locale.language}" />
<c:choose>
	<c:when test="${langCode eq 'en'}">
		<structure:pageUrl id="subjectDetailUrl" propertyName="GUR_EnglishSubjectDetailPage" useInheritance="true" />
	</c:when>
	<c:otherwise>
		<structure:pageUrl id="subjectDetailUrl" propertyName="GUR_SubjectDetailPage" useInheritance="true" />
	</c:otherwise>
</c:choose>

<style type="text/css">
li.treeNode div.listIcon {margin-right:5px;}
</style>

<%!
	public void generateTree(Directory aDirectory, String aParentId, String aLanguageCode, StringBuffer aStringBuffer, int aLevel, Integer aSafetyCounter, String aSubjectDetailUrl, boolean topLevel, String aShowTitleText, String aShowAltText, String aExpandImageUrl) throws Exception
	{
		String query 			= "parentid:" + aParentId;
		Integer startIndex 		= null;
		Integer count 			= null;
		String[] sortFields 	= new String[1];
		sortFields[0]			= aLanguageCode + "_name";
		boolean sortAscending 	= true;
		SearchResult subjects	= SiteLuceneController.getController().search(aDirectory, query, startIndex, count, null, sortAscending);				
		String catId			= "";
		String svepId			= "";
		int currentLevel		= aLevel;
		String subjectName		= "";
		String subjectType		= "";
		String subjectDetailUrl = "";
		String divider			= "";
		VisualFormatter vf 		= new VisualFormatter();
		
		aSafetyCounter = aSafetyCounter + 1;
		
		if (aSafetyCounter > 10)
		{
			aStringBuffer.append("TRIGGERED SAFETY COUNTER: SOMETHING IS WRONG...");
			return;
		}

		StringBuffer tempBuffer = new StringBuffer();

		for (Map<String, Object> subject : subjects.result)
		{
			tempBuffer 	= new StringBuffer();
			catId 		= (String)subject.get("catid");
			svepId 		= (String)subject.get("svepid");
			subjectName = ((String)subject.get(aLanguageCode + "_name")).toLowerCase();
			subjectName = Character.toUpperCase(subjectName.charAt(0)) + subjectName.substring(1);
			subjectType = (String)subject.get("category_type");
						
			if (subjectType != null && subjectType.equalsIgnoreCase("svep"))
			{
				if (aSubjectDetailUrl.indexOf("?") > -1)
				{
						divider = "&";
				}
				else
				{
						divider = "?";
				}
				subjectDetailUrl = aSubjectDetailUrl + divider + "subjectId=" + svepId;
				aStringBuffer.append("<li class=\"treeNode\">");
				
				generateTree(aDirectory, catId, aLanguageCode, tempBuffer, currentLevel++, aSafetyCounter, aSubjectDetailUrl, false, aShowTitleText, aShowAltText, aExpandImageUrl);
				
				if (tempBuffer.length() > 0) // i.e. this tree node has children
				{
					// <div class=\"listIcon arrow\"></div>
					// style=\"display:block;width: 12px; height: 16px;\"
					aStringBuffer.append("<a href=\"#\" class=\"listIcon\" tabindex=\"0\" title=\"" + aShowTitleText + " " + vf.escapeHTML(subjectName) + "\" data-subject-name=\"" + vf.escapeHTML(subjectName) + "\"><img src=\"" + aExpandImageUrl + "\" alt=\"" + aShowAltText + "\" /></a><a tabindex=\"0\" href=\"" + vf.escapeHTML(subjectDetailUrl) + "\">" + vf.escapeHTML(subjectName) + "</a>");
					aStringBuffer.append("<ul class=\"subjectListNode level" + aLevel + "\">");
					aStringBuffer.append(tempBuffer);
					aStringBuffer.append("</ul>");
				}
				else // i.e. this tree node has NO children
				{
					// <div class=\"listIcon\"></div>
					if (topLevel)
					{
						aStringBuffer.append("<a class=\"listTopLevelLink\" tabindex=\"0\" href=\"" + vf.escapeHTML(subjectDetailUrl) + "\">" + vf.escapeHTML(subjectName) + "</a>");						
					}
					else
					{
						aStringBuffer.append("<div class=\"listIcon\"></div><a tabindex=\"0\" href=\"" + vf.escapeHTML(subjectDetailUrl) + "\">" + vf.escapeHTML(subjectName) + "</a>");
					}
						
				}
								
				aStringBuffer.append("</li>");	
			}		
		}
	}
%>

<script type="text/javascript">
	$(document).ready(function () {
		$(".listTopLevelLink").each(function() {
			
			if ($(this).parent().siblings().children("a.arrow").get().length > 0) {
				$(this).parent().prepend("<div/>");
				$(this).parent().children("div").addClass("listIcon");
				$(this).parent().children("div").show();
			}
			
			
			//console.log("hej:" + $(this).siblings(".arrow").get().length);
		});
		
		$(".listIcon").click(function (e) {	
			e.preventDefault();
			var href = $(this);
			var treeImage = $(this).children("img");
			$(this).siblings("ul.subjectListNode").slideToggle(100, function() {
				if ($(this).parent().children("ul.subjectListNode").is(":visible"))
				{
					console.log("Ändrar till streck");
					console.log(treeImage.attr("src"));
					href.attr("title", "<c:out value="${hideTitleText}" /> " + href.attr("data-subject-name"));
					treeImage.attr("src", "<c:out value="${closeImageUrl}" />");
					treeImage.attr("alt", "<c:out value="${hideAltText}" />");
				}
				else
				{
					console.log("Ändrar till plus");
					href.attr("title", "<c:out value="${showTitleText}" /> " + href.attr("data-subject-name"));
					treeImage.attr("src", "<c:out value="${expandImageUrl}" />");
					treeImage.attr("alt", "<c:out value="${showAltText}" />");
				}
				console.log("img: " + treeImage.attr("src"));
				console.log("alt: " + treeImage.attr("alt"));
				return false;
			});
		});		
	});
</script>

<c:if test="${empty title}">
	<structure:componentLabel id="title" mapKeyName="DefaultTitle"/>
</c:if>


<structure:componentLabel id="searchErrorMessage" mapKeyName="SearchErrorMessage"/>

<c:catch var="luceneError">
	<c:set var="subjectDataPath" value="${dataBasePath}/lucene_category.txt"/>
	<lucene:setupIndex id="subjectList" directoryCacheName="subjectList" path="${subjectDataPath}" indexes="catid,svepid,node_type,parentid" timeout="${timeout}" parser="se.gu.infoglue.lucene.GUCategoryParser" />
</c:catch>

<c:choose>
	<c:when test="${pc.isDecorated and not empty luceneError}">
		<div class="guResearchComp listSubjects">
			<h2><c:out value="${title}" /></h2>
			<p class="adminMessage"><c:out value="${searchErrorMessage}"/></p>
		</div>
	</c:when>
	<c:otherwise>
		<c:if test="${not empty param.subjectId}">
		    <c:set var="subjectId" value="${param.subjectId}" />
		</c:if>
		
		<c:if test="${empty subjectId}">
			<c:set var="subjectId" value="IG_EMPTY" />
		</c:if>
		
		<%-- Translate the received svep-id to a cat-id so we can get the child subjects (the parentId on a subject is a cat-id...) --%>
				
		<c:if test="${subjectId ne 'IG_EMPTY'}">
			<c:set var="luceneQuery" value="svepid:${subjectId}" />
			<c:catch var="translationError">
				<lucene:search id="subjects" directory="${subjectList}" query="svepid:${subjectId}" />
				<c:set var="foundSubject" value="${subjects[0]}" />
				<c:set var="subjectId" value="${foundSubject.catid}" />
			</c:catch>
		</c:if>
						
		<c:choose>
			<c:when test="${not empty translationError}">
				Fel i konvertering: <c:out value="${translationError.message}" />
			</c:when>
			<c:otherwise>
				<%
					String searchErrorMessage 	= (String)pageContext.getAttribute("searchErrorMessage");
					String langCode 			= (String)pageContext.getAttribute("langCode");
					String subjectId 			= (String)pageContext.getAttribute("subjectId");
					String subjectDetailUrl		= (String)pageContext.getAttribute("subjectDetailUrl");
					Directory directory 		= (Directory)pageContext.getAttribute("subjectList");
					StringBuffer sb 			= new StringBuffer();
					
					String showTitleText		= (String)pageContext.getAttribute("showTitleText");
					String showAltText			= (String)pageContext.getAttribute("showAltText");
					String hideAltText			= (String)pageContext.getAttribute("hideAltText");
					String expandImageUrl		= (String)pageContext.getAttribute("expandImageUrl");
						
					try
					{
						// IG_EMPTY means nodes nodes that do not have a parent. 
						// IG_EMPTY is set by the parser and is required 
						// since you can't search for empty strings in Lucene
						
						generateTree(directory, subjectId, langCode, sb, 1, 0, subjectDetailUrl, true, showTitleText, showAltText, expandImageUrl);
					}
					catch (Exception e)
					{
						out.print("<p class\"adminMessage\">" + searchErrorMessage + "</p>");
					}
						
					if (sb.toString().trim().length() > 0)
					{
						%>
							<!--eri-no-index-->
							<div class="guResearchComp listSubjects">
								<h2><c:out value="${title}" /></h2>
								<ul class="subjectListNode topLevel">
									<% out.print(sb.toString()); %>
								</ul>
							</div>
							
							<!--/eri-no-index-->
						<%
					}
				%>
			</c:otherwise>
		</c:choose>
		
		<script type="text/javascript">
			$("ul.subjectListNode ul").hide();
			$(".listIcon").show();
		</script>
	</c:otherwise>
</c:choose>