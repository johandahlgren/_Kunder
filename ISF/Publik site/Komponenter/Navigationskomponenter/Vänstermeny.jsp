<%@page import="org.infoglue.cms.util.XMLHelper"%>
<%@ taglib prefix="c"         	uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="x"         	uri="http://java.sun.com/jstl/xml" %>
<%@ taglib prefix="common"    	uri="infoglue-common" %>
<%@ taglib prefix="management"	uri="infoglue-management" %>
<%@ taglib prefix="content"    	uri="infoglue-content" %>
<%@ taglib prefix="structure" 	uri="infoglue-structure" %>
<%@ taglib prefix="page" 		uri="infoglue-page" %>

<%@ page import="org.infoglue.cms.util.sorters.PageComparator,org.infoglue.cms.util.sorters.HardcodedPageComparator, org.infoglue.cms.applications.common.VisualFormatter, org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController, java.util.*, org.infoglue.deliver.applications.databeans.WebPage, org.infoglue.cms.entities.structure.*"%>

<page:pageContext id="pc"/>
<page:deliveryContext id="dc"/>

<structure:boundPage id="menuBasePage" propertyName="MenuBasePage"/>

<c:choose>
	<c:when test="${menuBasePage == null || menuBasePage == 'undefined'}">		
		<structure:siteNode id="rootNode" siteNodeId="${pc.repositoryRootSiteNode.siteNodeId}"/>
	</c:when>
	<c:otherwise>		
		<structure:siteNode id="rootNode" siteNodeId="${menuBasePage.siteNodeId}"/>
	</c:otherwise>
</c:choose>

<structure:pageUrl id="rootPageUrl" siteNodeId="${rootNode.siteNodeId}"/>

<content:assetUrl id="arrowClosed" propertyName="Global Images" assetKey="arrow_close"/>
<content:assetUrl id="arrowOpen" propertyName="Global Images" assetKey="arrow_open"/>
<content:assetUrl id="arrowNone" propertyName="Global Images" assetKey="arrow_none"/>

<%!
	//-----------------------------------------------------
	// Inner class for sorting entries by navigationTitle.
	//-----------------------------------------------------
	
	final class OrderMenuItemsByName implements Comparator<WebPage>
	{
	    public int compare(final WebPage aObj, final WebPage bObj)
	    {
	        final String title1 = aObj.getNavigationTitle();	        
	        final String title2 = bObj.getNavigationTitle();
	        
	        int compare = (title1 == null) ? 1 : (title2 == null) ? -1 : title1.compareToIgnoreCase(title2);
	        
	        return compare;
	    }
	}

	//-----------------------------------------------
	// Inner class for sorting entries by sortOrder.
	//-----------------------------------------------
	
	final class OrderMenuItemsBySortOrder implements Comparator<WebPage>
	{
		BasicTemplateController tc;
		
		OrderMenuItemsBySortOrder(BasicTemplateController aTc)
		{
			this.tc = aTc;
		}
		
	    public int compare(final WebPage wp1, final WebPage wp2)
	    {
	    	//WebPage wp1					= (WebPage)aObj;
	    	//WebPage wp2					= (WebPage)bObj;
	    	
	        String sortOrder1 	= tc.getContentAttribute(wp1.getMetaInfoContentId(), "SortOrder", true);      
	        String sortOrder2 	= tc.getContentAttribute(wp2.getMetaInfoContentId(), "SortOrder", true);
	        
	        int compare = 0;
	        	        
	        //-------------------------
	        // Compare the two objects
	        //-------------------------
	        
	        if ((sortOrder1.trim().equals("") || sortOrder1.equals("99999")) && !(sortOrder2.trim().equals("") || sortOrder2.equals("99999")))
	        {
	        	compare = 1;
	        }
	        else if ((sortOrder2.trim().equals("") || sortOrder2.equals("99999")) && !(sortOrder1.trim().equals("") || sortOrder1.equals("99999")))
		    {
	        	compare = -1;
	        }
	        else if ((sortOrder2.trim().equals("") || sortOrder2.equals("99999") && (sortOrder1.trim().equals("") || sortOrder1.equals("99999"))))
	        {
	        	compare = 0;
	        }
	        else
	        {	        	
	        	compare = sortOrder1.compareToIgnoreCase(sortOrder2);
	        }
	        
	        return compare;
	    }
	}

	//------------------------------------------
	// Method for printing the menu recursively
	//------------------------------------------

	public StringBuffer printChildPages(BasicTemplateController tc, List<WebPage> siblings, String[] menuClasses, int currentDepth, StringBuffer buf) 
	{	
		String arrowClosed 			= "";
		String arrowOpen 			= "";
		String arrowNone 			= "";		
		String liClass				= "";
		String childDisplay			= "";
		Integer siteNodeId 			= tc.getSiteNodeId();
		String iconString			= "";
		boolean hasChildren			= false;
		boolean isSelected			= false;
		boolean isSelectedsParent	= false;
		boolean displayChildren		= false;
		boolean showNode			= false;
		String showInNavigation		= "";
		String showChild			= "";
				
		WebPage[] sortedEntries 	= new WebPage[siblings.size()];
		sortedEntries 				= (WebPage[])siblings.toArray(sortedEntries);		

		Arrays.sort(sortedEntries, new PageComparator("NavigationTitle", "asc", false, tc));		
		
		String sortProperty 		= "SortOrder";
		String sortOrder 			= "asc";
		//String namesInOrderString 	= "Aktuellt,Utbildning,Forskarutbildning,Forskning,Samverkan,Handbokssida";
		String nameProperty 		= "NavigationTitle";
		
		//Arrays.sort(sortedEntries, new HardcodedPageComparator(sortProperty, sortOrder, true, nameProperty, namesInOrderString, tc));
		Arrays.sort(sortedEntries, new OrderMenuItemsBySortOrder(tc));
				
		if(sortedEntries != null && sortedEntries.length > 0) 
		{
			for(int i = 0; i < sortedEntries.length; i ++) 
			{				
				WebPage wp 			= sortedEntries[i];					
				List children 		= tc.getChildPages(wp.getSiteNodeId());		
				
				//---------------------------------------------------------------
				// Make sure this node has the property ShowInNavigation == ja
				// Otherwise ignore it.
				//---------------------------------------------------------------
				
				showInNavigation = tc.getContentAttribute(wp.getMetaInfoContentId(), "VisaINavigering", true);
				
				if (showInNavigation == null || showInNavigation.trim().equals("") || showInNavigation.equalsIgnoreCase("Ja"))
				{
					showNode = true;
				}
				else
				{
					showNode = false;
				}

				if (showNode)
				{
					//----------------------------------
					// Check if this node has children.
					//----------------------------------
					
					hasChildren = false;
					
					if (children != null && children.size() > 0)
					{
						hasChildren = true;
					}
					
					//------------------------------------
					// Check if this is the selected node
					//------------------------------------
					
					isSelected = false;
					
					if (wp.getSiteNodeId().equals(siteNodeId))
					{
						isSelected = true;
					}
					
					//--------------------------------------------------------
					// Check if this node is the parent of the selected node.
					//--------------------------------------------------------
					
					isSelectedsParent = false;
					
					if (tc.getIsParentToCurrent(wp.getSiteNodeId()))
					{
						isSelectedsParent = true;
					}
					
					//-----------------------------------------------------------
					// Check if at least one of the children is to be displayed,
					// i.e. does NOT have "showInNavigation=false".
					//-----------------------------------------------------------	
					
					displayChildren = false;							
					Iterator iter2 	= children.iterator();
					
					while(iter2.hasNext()) 
					{
						WebPage temp 			= (WebPage)iter2.next();
						int metaInfoContentId 	= temp.getMetaInfoContentId();								
						showChild 				= tc.getContentAttribute(metaInfoContentId, "VisaINavigering", true);
						
						if (showChild == null || showChild.trim().equals("") || showChild.trim().equalsIgnoreCase("Ja"))
						{
							displayChildren = true;
							break;
						}
					}
										
					//----------------------------------------------------
					// Mark the selected menu choice by setting:
					// Class "selected", i.e. marked as selected.				
					//----------------------------------------------------
					
					if(isSelected) 
					{					
						liClass = "selected";
					}
					else
					{
						liClass = "";
					}
					
					if (hasChildren && displayChildren)
					{
						if (isSelectedsParent)
						{
							liClass += " has-children expanded";
						}
						else
						{
							liClass += "has-children";
						}
					}
					else if(hasChildren && isSelectedsParent && !displayChildren && !isSelected)
					{
						liClass = "selected";
					}
					
					
					buf.append("<li class=\"" + liClass + "\">");
					
					//-------------------------------------------------------------------------------
					// Add the link to the string
					// Start by HTML encoding all special characters to avoid W3C-validation errors.
					//-------------------------------------------------------------------------------
					
					VisualFormatter vf 			= new VisualFormatter();
					String fixedUrl 			= wp.getUrl();//vf.escapeExtendedHTML(wp.getUrl());
					String fixedNavigationTitle = vf.escapeExtendedHTML(wp.getNavigationTitle());
					
					if (currentDepth == 0)
					{
						buf.append("<span><a href=\"" + fixedUrl + "\">" + fixedNavigationTitle + "</a></span>");
					}
					else
					{
						buf.append("<a href=\"" + fixedUrl + "\">" + wp.getNavigationTitle() + "</a>");
					}
					

					//--------------------------------------------------------------------------
					// If this node has children, call this method recursively to display them.
					//--------------------------------------------------------------------------
					
					if (currentDepth < menuClasses.length)
					{						
						if(hasChildren && isSelectedsParent) 
						{		
							if (displayChildren)
							{		
								buf.append("<ul class=\"" + menuClasses[currentDepth] + "\">");
								printChildPages(tc, children, menuClasses, currentDepth + 1, buf);
								buf.append("</ul>\n");
							}
						}						
					}
					buf.append("</li>");
				}
			}			
		}		
		
		return buf;
	}
%>

<!-- eri-no-index -->

<c:choose>
	<c:when test="${empty menuBasePage && pc.isDecorated eq 'true'}">
		<div class="adminMessage">
			<structure:componentLabel mapKeyName="SelectRootNode"/>
		</div>
	</c:when>
	<c:otherwise>
		<div id="navMenuContainer">
	   		<div class="innerContainer">
	       		<%-- samma som intranätet till att börja med, vi får ändra sen om det behövs --%>
	       		
	       		<%
					BasicTemplateController tc 	= (BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
					StringBuffer buf 			= new StringBuffer();			
					String[] menuClasses 		= new String[2];							
					menuClasses[0] 				= "menu";
					menuClasses[1] 				= "submenu";						
					SiteNodeVO rootNode 		= (SiteNodeVO)pageContext.getAttribute("rootNode");				
					List children 				= tc.getChildPages(rootNode.getId());
							
					pageContext.setAttribute("menuString", printChildPages(tc, children, menuClasses, 0, buf));					
				%>

		        <ul class="bigmenu">
		        	<c:out value="${menuString}" escapeXml="false"/>
		        </ul>
		    </div>
		</div> <!-- slut navMenuContainer -->
	</c:otherwise>
</c:choose>

<!-- /eri-no-index -->