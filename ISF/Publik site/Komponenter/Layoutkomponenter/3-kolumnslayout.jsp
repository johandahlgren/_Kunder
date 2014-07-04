<%@ taglib prefix="c"         	uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="structure" 	uri="infoglue-structure" %>
<%@ taglib prefix="page" 		uri="infoglue-page" %>

<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController" %>
<%@page import="org.infoglue.cms.entities.structure.SiteNodeVO" %>

<%!
	public int getCurrentDepth(BasicTemplateController tc, SiteNodeVO siteNode, int depth) 
	{	
		Integer parentId = siteNode.getParentSiteNodeId();
		
		if (parentId != null)
		{
			org.infoglue.cms.entities.structure.SiteNodeVO parent = tc.getSiteNode(siteNode.getParentSiteNodeId());
			
			if(parent != null) 
			{
				depth++;
				return getCurrentDepth(tc, parent, depth);
			}
		}
		
		return depth;
	}
%>

<%
	BasicTemplateController tc = (BasicTemplateController)pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");
	int currentDepth = getCurrentDepth(tc, tc.getSiteNode(), 0);
	
	if (currentDepth == 1)
	{
		pageContext.setAttribute("extraClass", "class=\"subStartPage\"");
	}
%>

<div id="mainContentContainer" <c:out value="${extraClass}" escapeXml="false"/>>
	<div class="innerContainer">
		<a id="content"></a>
		<div id="navColContainer">
			<div class="innerContainer">
				<ig:slot id="left" allowedComponentGroupNames="Navigation"></ig:slot>
			</div>
		</div>
	
		<div id="mainColContainer">
			<div class="innerContainer">
				<div id="breadcrumbs">
					<ig:slot id="crumbtrail" inherit="true" allowedComponentNames="Smulnavigering"></ig:slot>
				</div>
				<ig:slot id="main" inherit="false" allowedComponentGroupNames="MainColumn"></ig:slot>
			</div>
		</div>
	
		<div id="sideColContainer">
			<div class="innerContainer">
				<ig:slot id="right" inherit="false" allowedComponentGroupNames="RightColumn"></ig:slot>
			</div>
		</div>
	</div>
</div>