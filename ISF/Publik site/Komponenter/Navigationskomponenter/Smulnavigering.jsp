<%@ taglib prefix="fmt" uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="maxStringLength" propertyName="MaxStringLength" useInheritance="true"/>
<structure:boundPage id="basePage" propertyName="BasePage" useInheritance="true"/>

<%!
	//-----------------------------
	// calculate the current depth
	//-----------------------------
	
	public int getCurrentDepth(org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController tc, org.infoglue.cms.entities.structure.SiteNodeVO siteNode,int depth) 
	{	
		Integer parentId = siteNode.getParentSiteNodeId();
		
		if (parentId != null)
		{
			org.infoglue.cms.entities.structure.SiteNodeVO parent = tc.getSiteNode(siteNode.getParentSiteNodeId());
			
			if(parent != null) 
			{
				depth++;
				return getCurrentDepth(tc ,parent, depth);
			}
		}
		
		return depth;
	}
				
	void printNode(org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController templateController, java.lang.Integer siteNodeId, StringBuffer sb, PageContext aPageContext, java.lang.Integer basePageId, boolean aIsFirstNode, String aExtraTitle)
	{
		try
	  	{
			org.infoglue.cms.entities.structure.SiteNodeVO currentSiteNodeVO 		= templateController.getSiteNode(siteNodeId);
		  	org.infoglue.cms.entities.structure.SiteNodeVO newParentSiteNodeVO 		= templateController.getParentSiteNode(siteNodeId);
		  	org.infoglue.cms.entities.structure.SiteNodeVO grandParentSiteNodeVO 	= null;
	
			String extra = "";
	
		  	if(newParentSiteNodeVO == null)
			{
			    Integer parentRepositoryId = templateController.getParentRepositoryId(currentSiteNodeVO.getRepositoryId());
			    if(parentRepositoryId != null)
			    {
			        newParentSiteNodeVO = templateController.getRepositoryRootSiteNode(parentRepositoryId);
			    }
			}
		  	else
		  	{
		  		grandParentSiteNodeVO 	=  templateController.getParentSiteNode(newParentSiteNodeVO.getId());
		  	}
	
			org.infoglue.cms.entities.structure.SiteNodeVO parentSiteNode = newParentSiteNodeVO;
	
		  	if(parentSiteNode != null && currentSiteNodeVO.getSiteNodeId().intValue() != basePageId.intValue()) 
		  	{
				printNode(templateController, parentSiteNode.getId(), sb, aPageContext, basePageId, false, null);
				extra = "<span class=\"separator\">/</span>";
	   	  	} 
	
			Integer metaInfoContentId 	= templateController.getMetaInformationContentId(siteNodeId);
			String crumbtrailName 		= templateController.getContentAttributeUsingLanguageFallback(metaInfoContentId, "CrumbtrailName", false); 
			
			if(crumbtrailName == null || crumbtrailName.equals(""))
			{
				crumbtrailName = templateController.getContentAttributeUsingLanguageFallback(metaInfoContentId, "NavigationTitle", false);
			}
			
			//------------------------------------------------------
			// If another page title has been set in a pretemplate 
			// (i.e. if this is a detail page with a content on it)
			// we set this value as the crumbtrail name instead.
			//------------------------------------------------------
			
			if (aExtraTitle != null && !aExtraTitle.trim().equals(""))
			{
				crumbtrailName = aExtraTitle;
			}
			
			//---------------------------------------------
			// Maximise the string length to a fixed value
			//---------------------------------------------
			
			int stringLength 	= 0;
			String temp 		= (String)aPageContext.getAttribute("maxStringLength");
			try
			{
				stringLength = Integer.parseInt(temp);
			}
			catch (NumberFormatException nfe)
			{
				stringLength = 9999;
			}
			
			if (crumbtrailName.length() > stringLength)
			{
				crumbtrailName = crumbtrailName.substring(0, stringLength) + "...";
			}
			
			//------------------------------------------
			// Check if this node is "hideInNavigation.
			//------------------------------------------
			
			String visible = templateController.getContentAttribute(metaInfoContentId, "VisaINavigering", true);
					
			//-------------------------------------------------
			// If this node is also the BasePage we want 
			// to display it even if it is "hideInNavigation".
			//-------------------------------------------------
			
			if (currentSiteNodeVO.getSiteNodeId().intValue() == basePageId.intValue())
			{
				visible = "Ja";
			}
			
			//------------------------------------------------
			// If this is a detail page, we want to
			// display it even if it is VisaINavigering = Nej
			//------------------------------------------------
			
			if (aIsFirstNode)
			{
				visible = "Ja";
			}
						
			//--------------------------------
			// Add the page to the crumbtrail
			//--------------------------------
					
			if (visible == null || visible.trim().equals("") || visible.equals("Ja"))
			{
				if (getCurrentDepth(templateController, currentSiteNodeVO, 0) < 5)
				{
					String url = templateController.getComponentLogic().getPageUrl(siteNodeId);
					if (aIsFirstNode)
					{
						sb.append(extra + crumbtrailName);
					}
					else
					{
						sb.append(extra + "<a href=\"" + url + "\">" + crumbtrailName + "</a>");
					}
				}
			}
			else
			{
				Object extraNavigationTitleObject = aPageContext.getAttribute("extraNavigationTitle");
				if (extraNavigationTitleObject != null && !extraNavigationTitleObject.toString().equals("") && aIsFirstNode)
				{
					sb.append(extra + extraNavigationTitleObject.toString());
				}
			}
			
		}
		catch(Exception e)
		{
			e.printStackTrace();
			sb.append(e.toString());
		}
	}			
%>

<!-- eri-no-index -->

<c:set var="basePageId" value="${basePage.siteNodeId}"/>
<c:set var="contentId" value="${param.contentId}"/>

<c:if test="${not empty contentId}">
<%--
	<content:contentTypeDefinition id="contentTypeDef" contentId="${param.contentId}" />
		
	<c:choose>
		<c:when test="${contentTypeDef.name eq 'ISF Artikel' or contentTypeDef.name eq 'ISF Nyhet'}">
			<content:contentAttribute id="extraNavigationTitle" contentId="${param.contentId}" attributeName="Rubrik" disableEditOnSight="true" />		
		</c:when>
		<c:when test="${contentTypeDef.name eq 'ISF Pressmeddelande' or contentTypeDef.name eq 'ISF Presstraff' or contentTypeDef.name eq 'ISF Projekt' or contentTypeDef.name eq 'ISF Rapport' or contentTypeDef.name eq 'ISF Remissvar'}">
			<content:contentAttribute id="extraNavigationTitle" contentId="${param.contentId}" attributeName="Title" disableEditOnSight="true" />
		</c:when>
	</c:choose>--%>
	
	<content:contentAttribute id="extraNavigationTitle" contentId="${contentId}" attributeName="Title" disableEditOnSight="true" />
	<%-- Handle poor design decision --%>
	<c:if test="${empty extraNavigationTitle}">
		<content:contentAttribute id="extraNavigationTitle" contentId="${contentId}" attributeName="Rubrik" disableEditOnSight="true" />		
	</c:if>
</c:if>

<strong><structure:componentLabel mapKeyName="YouAreHere"/></strong>

<% 
	String contentId	= (String)pageContext.getAttribute("contentId");
	String extraTitle	= (String)pageContext.getAttribute("extraNavigationTitle");
	boolean isFirstNode	= true;
	
	org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController templateLogic = (org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
	StringBuffer sb 	= new StringBuffer();
	Integer basePageId 	= new Integer(0);
	Object temp 		= pageContext.getAttribute("basePageId");
	
	if (temp != null)
	{
		basePageId 		= (Integer)pageContext.getAttribute("basePageId");
	}
	
	printNode(templateLogic, templateLogic.getSiteNodeId(),sb, pageContext, basePageId, isFirstNode, extraTitle);
	out.print(sb.toString());
%>

<!-- /eri-no-index -->