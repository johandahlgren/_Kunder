<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>

<page:pageContext id="pc"/>

<structure:boundPage id="startPage" propertyName="StartPage"/>
<structure:boundPage id="mbasepage" propertyName="MenuBasePage" useInheritance="true" />
<structure:siteNode id="startnod" propertyName="MenuBasePage"/>
<management:language id="curLang" languageId="${pc.languageId}"/>			

<structure:componentLabel id="siteMapLabel" mapKeyName="siteMapLabel"/>
<structure:componentLabel id="siteMapTitle" mapKeyName="siteMapTitle"/>
<common:urlBuilder id="siteMapUrl" fullBaseUrl="true" excludedQueryStringParameters="adjust,feedbackForm,recipientName,email,returnAddress,siteMap,siteSearch">
	<common:parameter name="siteMap" value="true"/>
</common:urlBuilder>

<structure:componentPropertyValue id="showStartPageInCrumbtrail" propertyName="ShowStartPageInCrumbtrail"/>
<%!
			
void printNode(org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController templateLogic, 
			   java.lang.Integer siteNodeId, 
			   java.lang.Integer startNodeId, 
			   boolean skipSitePages, 
			   boolean skipMenuBasePages, 
			   String searchLabel, 
			   String siteMapLabel, 
			   String crumbtrailCurrentParentPageUrl,
			   String crumbtrailCurrentParentPageText,
			   String crumbtrailCurrentPageText, 
			   StringBuffer sb)
{
	try
  	{
		org.infoglue.cms.entities.structure.SiteNodeVO currentSiteNodeVO = templateLogic.getSiteNode(siteNodeId);

	  	org.infoglue.cms.entities.structure.SiteNodeVO newParentSiteNodeVO = templateLogic.getParentSiteNode(siteNodeId);
		/*
	  	Om man är på svenska isEnglish == false, så skall man gå upp i trädet tills parentSiteNode == null, då skall man hämta föräldra repositoriet.
	  	Om man är p Engelska, skall man inte hämta parentSite utan gå direkt på parentRepository.
	  	
	  	*/
	/*	if(newParentSiteNodeVO == null )
		{
			isOtherRepositoryPage = true;
		    Integer parentRepositoryId = templateLogic.getParentRepositoryId(currentSiteNodeVO.getRepositoryId());
		    if(parentRepositoryId != null)
		    {
	    	    newParentSiteNodeVO = templateLogic.getRepositoryRootSiteNode(parentRepositoryId);
		    }
		} 
		else if (isEnglish)
		{
		    Integer parentRepositoryId = templateLogic.getParentRepositoryId(currentSiteNodeVO.getRepositoryId());
		    if(parentRepositoryId != null)
		    {
	    	    newParentSiteNodeVO = templateLogic.getRepositoryRootSiteNode(parentRepositoryId);
	    	    if(newParentSiteNodeVO != null)
	    	    {
	    	    	org.infoglue.cms.entities.management.LanguageVO languageVO = templateLogic.getLanguage(templateLogic.getLanguageId());
	    	    	java.util.List languageVOList = templateLogic.getPageLanguages(newParentSiteNodeVO.getSiteNodeId());
	    	    	if(!languageVOList.contains(languageVO))
	    	    	{
	    	    		sb.append("<!--" + newParentSiteNodeVO.getName() + " had not language " + languageVO.getName() + "-->");
	    	    		org.infoglue.cms.entities.structure.SiteNodeVO altParentSiteNodeVO = templateLogic.getComponentLogic().getBoundSiteNode(newParentSiteNodeVO.getId(), "AlternateLanguageStartPage", false);
	    	    		if(altParentSiteNodeVO != null)
	    	    		{
	    	    			newParentSiteNodeVO = altParentSiteNodeVO;
	    	    		}
	    	    	}
	    	    }
	    	}
		}*/

		org.infoglue.cms.entities.structure.SiteNodeVO parentSiteNode = newParentSiteNodeVO;

	  	if(parentSiteNode != null) 
	  	{
	  		printNode(templateLogic, parentSiteNode.getId(), startNodeId, skipSitePages, skipMenuBasePages, searchLabel, siteMapLabel, crumbtrailCurrentParentPageUrl, crumbtrailCurrentParentPageText, crumbtrailCurrentPageText, sb);
   	  	} 	

		if(!skipSitePages || !skipMenuBasePages)
		{
			Integer metaInfoContentId = templateLogic.getMetaInformationContentId(siteNodeId);
			String navTitle = templateLogic.getContentAttributeUsingLanguageFallback(metaInfoContentId, "NavigationTitle", true);
			String crumbtrailName = templateLogic.getContentAttributeUsingLanguageFallback(metaInfoContentId, "CrumbtrailName", true); 
			String hidden = templateLogic.getContentAttribute(metaInfoContentId, "hideInNavigation", true);
			
			if(!skipSitePages || templateLogic.getComponentLogic().getHasDefinedProperty(siteNodeId, templateLogic.getLanguageId(), "MenuBasePage", false))  // &&  // || 
			{
				if(crumbtrailName != null && !crumbtrailName.equals(""))
					navTitle = crumbtrailName;
				
				if(!navTitle.trim().equals("--")) 
				{
					String url = templateLogic.getComponentLogic().getPageUrl(siteNodeId);
					org.infoglue.cms.applications.common.VisualFormatter vf = new org.infoglue.cms.applications.common.VisualFormatter();
					url = vf.escapeHTML(url);
					if(!siteNodeId.equals(templateLogic.getSiteNodeId()) || skipSitePages)
						sb.append("<li><a href=\"" + url + "\">");
					else
						sb.append("<li class=\"current\">");
		
					if(crumbtrailCurrentPageText != null)
					{
						if(!siteNodeId.equals(templateLogic.getSiteNodeId()) || skipSitePages)
							sb.append(navTitle);
						else
						{
							if(crumbtrailCurrentParentPageText != null && !crumbtrailCurrentPageText.equals(""))
							{
								sb.append("<li><a href=\"" + crumbtrailCurrentParentPageUrl + "\">" + crumbtrailCurrentParentPageText + "</a></li>");
							}

							sb.append(crumbtrailCurrentPageText);
						}
					}
					else
						sb.append(navTitle);
							
					if(!siteNodeId.equals(templateLogic.getSiteNodeId()) || skipSitePages)
						sb.append("</a></li>");
					else
						sb.append("</li>");
				}
			}
		}
		else if(sb.indexOf("class=\"current\"") == -1)
		{
			sb.append("<li class=\"current\">");
			if(templateLogic.getRequestParameter("siteSearch").equalsIgnoreCase("true"))
				sb.append(searchLabel);
			else if(templateLogic.getRequestParameter("siteMap").equalsIgnoreCase("true"))
				sb.append(siteMapLabel);
			sb.append("</li>");
		}
	}
	catch(Exception e)
	{
		e.printStackTrace();
		sb.append(e.toString());
	}
}
			
%>

<div id="crumbtrailComp">

	<c:set var="skipSitePages" value="false"/>
	<c:if test="${param.siteSearch == 'true' || param.siteMap == 'true'}">
		<c:set var="skipSitePages" value="true"/>
	</c:if>
	<c:set var="skipMenuBasePages" value="true"/>
	<c:if test="${param.siteMap == 'true'}">
		<c:set var="skipMenuBasePages" value="false"/>
	</c:if>
	
	<structure:componentLabel id="searchLabel" mapKeyName="searchLabel"/>
	<structure:componentLabel id="siteMapLabel" mapKeyName="siteMapLabel"/>
<%--
	<structure:componentPropertyValue id="headerType" propertyName="HeaderType"/>
	<structure:boundPage id="universityStartPage" propertyName="UniversityStartPage"/>
	<c:set var="universityStartPageSiteNodeId" value="${universityStartPage.siteNodeId}"/>

	<structure:pageUrl id="siteStartPageUrl" propertyName="SiteStartPage" useRepositoryInheritance="false"/>
	<c:if test="${empty siteStartPageUrl}">
		<structure:pageUrl id="siteStartPageUrl" propertyName="MenuBasePage" useRepositoryInheritance="false"/>
	</c:if>--%>

	<page:pageAttribute id="crumbtrailCurrentParentPageUrl" name="crumbtrailCurrentParentPageUrl" />
	<page:pageAttribute id="crumbtrailCurrentParentPageText" name="crumbtrailCurrentParentPageText" />
	<page:pageAttribute id="crumbtrailCurrentPageText" name="crumbtrailCurrentPageText" />
	<%--
	<c:if test="${empty headerType || headerType == 'false'}"><c:set var="headerType" value="standardGU"/></c:if>
	--%>
        <!--eri-desc-->

	<ul>
	<%--
		<c:if test="${headerType != 'level3page'}">--%>
		<%--
		<li>
        	<c:if test="${empty showStartPageInCrumbtrail || showStartPageInCrumbtrail != false}"> --%>
        	<%--
				<c:choose>
					<c:when test="${startnod.name eq 'English' || curLang eq 'English'}"> 
						<a <c:if test="${siteStartPageUrl eq startPage.url}">accesskey="1"</c:if> href="<c:out value="${startPage.url}"/>" title="<c:out value="${homeTitle}"/>">University of Gothenburg</a>
						<c:set var="startNodeId" value="${mbasepage.siteNodeId}"/>
					</c:when>
					<c:otherwise>--%>
					<%--<c:out value="${homeTitle}"/> --%>
					<%--
						<a <c:if test="${siteStartPageUrl eq startPage.url}">accesskey="1"</c:if> href="<c:out value="${startPage.url}"/>" title="<structure:componentLabel mapKeyName="HomeTitle"/>"><c:out value="${startPage.navigationTitle}"/></a>
						<c:set var="startNodeId" value=""/>--%>
					<%--
					</c:otherwise>
				</c:choose> --%>
	       	<%--
	       	</c:if>
		</li>--%>
			<%--
		</c:if> --%>
			
		<page:pageContext id="templateLogic"/>
		
		<% 
		org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController templateLogic = (org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");

 		StringBuffer sb = new StringBuffer();

		java.lang.Integer startNodeId = null;
		try 
		{
			if(pageContext.getAttribute("startNodeId").toString()!=null && !pageContext.getAttribute("startNodeId").toString().equals("")) 
			{
				startNodeId = Integer.parseInt(pageContext.getAttribute("startNodeId").toString());
			}
		}
		catch (Exception e) 
		{
		}
		
		boolean skipSitePages = false;
		if(pageContext.getAttribute("skipSitePages") != null && pageContext.getAttribute("skipSitePages").toString().equalsIgnoreCase("true"))
			skipSitePages = true;

		boolean skipMenuBasePages = true;
		if(pageContext.getAttribute("skipMenuBasePages") != null && pageContext.getAttribute("skipMenuBasePages").toString().equalsIgnoreCase("false"))
			skipMenuBasePages = false;
		
		String searchLabel = (String)pageContext.getAttribute("searchLabel");
		String siteMapLabel = (String)pageContext.getAttribute("siteMapLabel");
		/*
		String siteStartPageUrl = (String)pageContext.getAttribute("siteStartPageUrl");*/
		String crumbtrailCurrentParentPageUrl 	= (String)pageContext.getAttribute("crumbtrailCurrentParentPageUrl");
		String crumbtrailCurrentParentPageText 	= (String)pageContext.getAttribute("crumbtrailCurrentParentPageText");
		String crumbtrailCurrentPageText 		= (String)pageContext.getAttribute("crumbtrailCurrentPageText");
		
  		printNode(templateLogic, templateLogic.getSiteNodeId(), startNodeId, skipSitePages, skipMenuBasePages, searchLabel, siteMapLabel, crumbtrailCurrentParentPageUrl, crumbtrailCurrentParentPageText, crumbtrailCurrentPageText, sb);
		
		if(sb.indexOf("class=\"current\"") == -1)
		{
			if(templateLogic.getRequestParameter("siteSearch").equalsIgnoreCase("true"))
				sb.append("<li class=\"current\">" + searchLabel + "</li>");
			else if(templateLogic.getRequestParameter("siteMap").equalsIgnoreCase("true"))
				sb.append("<li class=\"current\">" + siteMapLabel + "</li>");
		}
		
		out.print(sb.toString());
		%>
	</ul>

	<!-- /eri-desc -->

	<%--
	<structure:componentPropertyValue id="showSiteMap" propertyName="ShowSiteMap" useInheritance="false"/>
	<c:if test="${empty showSiteMap || showSiteMap != 'false'}">
    	<a href="<c:out value="${siteMapUrl}"/>" id="sitemap" title="<c:out value="${siteMapTitle}" escapeXml="false"/>" accesskey="3"><c:out value="${siteMapLabel}" escapeXml="false"/></a>
    </c:if>
    --%>
    <div class="clr"></div>
</div>