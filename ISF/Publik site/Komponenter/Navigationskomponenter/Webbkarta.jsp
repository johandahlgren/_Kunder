<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<%@ page import="org.infoglue.cms.util.sorters.PageComparator"%>
<%@ page import="org.infoglue.cms.util.sorters.HardcodedPageComparator"%>
<%@ page import="org.infoglue.cms.applications.common.VisualFormatter"%>
<%@ page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController"%>
<%@ page import="java.util.*"%>
<%@ page import="org.infoglue.deliver.applications.databeans.WebPage"%>
<%@ page import="org.infoglue.cms.entities.structure.*"%>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentLabel id="defaultTitle" mapKeyName="Title"/>
<structure:boundPage id="startPage" propertyName="StartPage"/>
<structure:boundPages id="miscellaneousPages" propertyName="MiscellaneousPages"/>

<%!
	//-----------------------------------------------------
	// Inner class for sorting entries by navigationTitle.
	//-----------------------------------------------------
	
	final class OrderMenuItemsByName implements Comparator
	{
	    public int compare(final Object aObj, final Object bObj)
	    {
	        final String title1 = ((WebPage)aObj).getNavigationTitle();	        
	        final String title2 = ((WebPage)bObj).getNavigationTitle();
	        
	        int compare = (title1 == null) ? 1 : (title2 == null) ? -1 : title1.compareToIgnoreCase(title2);
	        
	        return compare;
	    }
	}

	//-----------------------------------------------
	// Inner class for sorting entries by sortOrder.
	//-----------------------------------------------
	
	final class OrderMenuItemsBySortOrder implements Comparator
	{
		BasicTemplateController tc;
		
		OrderMenuItemsBySortOrder(BasicTemplateController aTc)
		{
			this.tc = aTc;
		}
		
	    public int compare(final Object aObj, final Object bObj)
	    {
	    	WebPage wp1					= (WebPage)aObj;
	    	WebPage wp2					= (WebPage)bObj;
	    	
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

	public StringBuffer printChildPages(BasicTemplateController tc, List siblings, int currentDepth, int groupCounter, double halfCount, StringBuffer buf) 
	{	
		String childDisplay			= "";
		Integer siteNodeId 			= tc.getSiteNodeId();
		String iconString			= "";
		boolean hasChildren			= false;
		boolean displayChildren		= false;
		boolean showNode			= false;
		String showInNavigation		= "";
		String showChild			= "";
				
		WebPage[] sortedEntries 	= new WebPage[siblings.size()];
		sortedEntries 				= (WebPage[])siblings.toArray(sortedEntries);		

		Arrays.sort(sortedEntries, new PageComparator("NavigationTitle", "asc", false, tc));		
		
		String sortProperty 		= "SortOrder";
		String sortOrder 			= "asc";
		String namesInOrderString 	= "Aktuellt,Utbildning,Forskarutbildning,Forskning,Samverkan,Handbokssida";
		String nameProperty 		= "NavigationTitle";
		
		Arrays.sort(sortedEntries, new HardcodedPageComparator(sortProperty, sortOrder, true, nameProperty, namesInOrderString, tc));
				
		//-----------------------------
		// Add tabs to format the code
		//-----------------------------
		
		String tabs = "";
		for (int x = 0; x < currentDepth; x ++)
		{
			tabs += "\t";
		}
		
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
				
				if (showInNavigation == null || showInNavigation.trim().equals("") || showInNavigation.equalsIgnoreCase("ja"))
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
						
						if (showChild == null || showChild.trim().equals("") || showChild.trim().equalsIgnoreCase("ja"))
						{
							displayChildren = true;
							break;
						}
					}
					
					//-------------------------------------------------------------------------------
					// Add the link to the string
					// Start by HTML encoding all special characters to avoid W3C-validation errors.
					//-------------------------------------------------------------------------------
					
					VisualFormatter vf 	= new VisualFormatter();
					String fixedUrl 	= vf.escapeExtendedHTML(wp.getUrl());
					
					if (currentDepth == 0)
					{
						buf.append(tabs + "<h2><a href=\"" + fixedUrl + "\">" + wp.getNavigationTitle() + "</a></h2>\n");
					}
					else
					{
						buf.append(tabs + "<li>\n");
						buf.append(tabs + "\t<a href=\"" + fixedUrl + "\">" + wp.getNavigationTitle() + "</a>\n");
					}
					
					//--------------------------------------------------------------------------
					// If this node has children, call this method recursively to display them.
					//--------------------------------------------------------------------------
					
					
					if(hasChildren && displayChildren) 
					{		
						buf.append(tabs + "<ul>\n");
						printChildPages(tc, children, currentDepth + 1, groupCounter, halfCount, buf);
						buf.append(tabs + "</ul>\n");
					}	
					
					if (currentDepth > 0)
					{
						buf.append(tabs + "</li>\n");
					}
					
					if (currentDepth == 0)
					{
						if (groupCounter == halfCount)
						{
							buf.append(tabs + "</div><div id=\"col-2\">");
						}
						groupCounter ++;
					}
				}
			}			
		}		
		
		return buf;
	}
%>

<!-- eri-no-index -->

<c:choose>
	<c:when test="${startPage == null || startPage == 'undefined'}">		
		<structure:siteNode id="rootNode" siteNodeId="${pc.repositoryRootSiteNode.siteNodeId}"/>
	</c:when>
	<c:otherwise>		
		<structure:siteNode id="rootNode" siteNodeId="${startPage.siteNodeId}"/>
	</c:otherwise>
</c:choose>

<c:if test="${empty title}">
	<c:set var="title" value="${defaultTitle}"/>
</c:if>

<c:choose>
	<c:when test="${empty rootNode}">
		<c:if test="${pc.isDecorated}">
			<h1><c:out value="${title}" escapeXml="false"/></h1>
			<div class="message">
				<structure:componentLabel mapKeyName="NoBasePageSelected"/>
			</div>
		</c:if>
	</c:when>
	<c:otherwise>
		<div class="sitemap">
			<structure:childPages id="childPages" siteNodeId="${rootNode.siteNodeId}"/>
			<structure:sortPages id="childPages" sortProperty="SortOrder" input="${childPages}"/>
			
			 <%
			 	int childCounter = 0;
			 %>

			 <c:forEach var="childPage" items="${childPages}">
				<content:contentAttribute id="showInNavigation" contentId="${childPage.metaInfoContentId}" attributeName="VisaINavigering" disableEditOnSight="true"/>
				<c:if test="${empty showInNavigation || showInNavigation eq 'Ja'}">
					<%
						childCounter++;
					%>
				</c:if>
			</c:forEach>
			
			<c:if test="${empty pageTitle}">
				<structure:componentLabel id="pageTitle" mapKeyName="DefaultHeadline"/>
			</c:if>
			
			<h1><c:out value="${title}" escapeXml="false"/></h1>
			
			<div id="col-1">
				<c:set var="counter" value="0"/>
				
				<%
					double halfCount			= Math.floor(childCounter / 2);
					BasicTemplateController tc 	= (BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
					StringBuffer buf 			= new StringBuffer();			
					SiteNodeVO rootNode 		= (SiteNodeVO)pageContext.getAttribute("rootNode");				
					List children 				= tc.getChildPages(rootNode.getId());
							
					out.println("\t\t" + printChildPages(tc, children, 0, 1, halfCount, buf));
				%>
				
				<h2>
					<structure:componentLabel mapKeyName="MiscellaneousPagesTitle"/>
				</h2>
				
				<ul>
					<c:forEach var="miscellaneousPage" items="${miscellaneousPages}">		
						<common:urlBuilder id="pageUrl" baseURL="${miscellaneousPage.url}"></common:urlBuilder>
					    <content:contentAttribute id="pageTitle" contentId="${miscellaneousPage.metaInfoContentId}" attributeName="Title" disableEditOnSight="true"/> 		        
					    <li>
							<a title="<c:out value="${pageTitle}" escapeXml="false"/>" href="<c:out value="${pageUrl}" escapeXml="true"/>"><c:out value="${pageTitle}" escapeXml="false"/></a>
			            </li>                       
					</c:forEach>
				</ul>
			</div>
		</div>
	</c:otherwise>
</c:choose>			

<!-- /eri-no-index -->