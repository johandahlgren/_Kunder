<%@page import="se.gu.infoglue.gup.Category"%>
<%@page import="java.util.SortedSet"%>
<%@page import="java.util.TreeSet"%>
<%@page import="java.util.Comparator"%>
<%@page import="java.util.Collections"%>
<%@page import="org.apache.lucene.queryParser.ParseException"%>
<%@page import="java.io.IOException"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="org.infoglue.cms.applications.common.VisualFormatter"%>
<%@page import="org.infoglue.deliver.util.HttpHelper"%>
<%@page import="org.infoglue.cms.exception.SystemException"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.TemplateController"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.LinkedList"%>
<%@page import="java.util.List"%>
<%@page import="java.util.HashMap"%>
<%@page import="se.gu.infoglue.lucene.SiteLuceneController.SearchResult"%>
<%@page import="se.gu.infoglue.lucene.SiteLuceneController"%>
<%@ taglib prefix="c"          uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="fmt"        uri="http://java.sun.com/jstl/fmt" %>
<%@ taglib prefix="common"     uri="infoglue-common" %>
<%@ taglib prefix="content"    uri="infoglue-content" %>
<%@ taglib prefix="page"       uri="infoglue-page" %>
<%@ taglib prefix="structure"  uri="infoglue-structure" %>
<%@ taglib prefix="management" uri="infoglue-management" %>
<%@ taglib prefix="lucene"     uri="infoglue-lucene" %>
<%@ taglib prefix="gup"        uri="gup" %>

<%!
	class SubjectTreeNode
	{
		private Integer id;
		private String name;
		private boolean marked;
		private List<SubjectTreeNode> children;
		private int antal = 0;
		
		public void setId(Integer id)
		{
			this.id = id;
		}
		public Integer getId()
		{
			return id;
		}
		public void setName(String name)
		{
			this.name = name;
		}
		public String getName()
		{
			return name;
		}
		public List<SubjectTreeNode> getChildren()
		{
			return children;
		}
		public void addChild(SubjectTreeNode child)
		{
			if (children == null)
			{
				children = new LinkedList<SubjectTreeNode>();
			}
			children.add(child);
		}
		public boolean isMarked()
		{
			return marked;
		}
		public void setMarked(boolean marked)
		{
			this.marked = marked;
		}
		public void setAntal(int antal)
		{
			this.antal = antal;
		}
		public int getAntal()
		{
			return antal;
		}
		
		@Override
		public boolean equals(Object other)
		{
			if (other == null || !SubjectTreeNode.class.equals(other.getClass()))
			{
				return false;
			}
			SubjectTreeNode otherNode = (SubjectTreeNode)other;
			return otherNode.getId() == this.getId();
		}
		@Override
		public int hashCode()
		{
			return id;
		}
	}
	
	void appendChildNode(SubjectTreeNode node, Integer parentid, Map<Integer,SubjectTreeNode> subjectTable, Set<SubjectTreeNode> rootSet, TemplateController tc) throws IOException, ParseException
	{
		//Integer parentId = Integer.parseInt((String)nodeValues.get("parentid"));
		
		SubjectTreeNode parentNode = subjectTable.get(parentid);
		
		if (parentNode != null)
		{
			// Parent node is already in tree
			parentNode.addChild(node);
		}
		else
		{
			// Parent is not in tree
			// We are not interested in sorting or shortening the list so we pass null to those values
			SearchResult sr = SiteLuceneController.getController().search("subjectList", "catid:" + parentid, null, null, null, null);
			
			if (sr.result.size() == 0)
			{
				// Is root node
				rootSet.add(node);
			}
			else
			{
				// Is leaf node, append to parent
				// Assumtion: only one hit
				Map<String,Object> parentValues = (Map<String,Object>)sr.result.get(0);
				parentNode = createNode(parentValues, rootSet, tc);
				subjectTable.put(parentNode.getId(), parentNode);
				String grandParentIdString = (String)parentValues.get("parentid");
				if (!"IG_EMPTY".equals(grandParentIdString))
				{
					Integer grandParentId = Integer.parseInt(grandParentIdString);
					appendChildNode(parentNode, grandParentId, subjectTable, rootSet, tc);
				}
				parentNode.addChild(node);
			}
		}
	}
	
	SubjectTreeNode createNode(Map<String, Object> nodeValues, Set<SubjectTreeNode> rootSet, TemplateController tc)
	{
		SubjectTreeNode newNode = new SubjectTreeNode();
		Integer id = Integer.parseInt((String)nodeValues.get("catid"));
		String name = null;
		try 
		{
			name = (String)nodeValues.get(tc.getLocale().getLanguage() + "_name");
		}
		catch (SystemException ex)
		{
			// Failing silently is bad but I see no better way
		}
		if (name == null)
		{
			name = (String)nodeValues.get("en_name");
		}
		newNode.setName(name);
		newNode.setId(id);
		if ("root".equals(nodeValues.get("node_type")))
		{
			rootSet.add(newNode);
		}
		return newNode;
	}
	
	String toHTMLSubList(SubjectTreeNode node, String subjectUrl, String textLabel)
	{
		/* This method assums that the subjectUrl has been constructed to expect 
		   a number (id) at the end of the String.
		*/
		
		StringBuilder sb = new StringBuilder();
		VisualFormatter vf = new VisualFormatter();
		
		sb.append("<li class=\"treeNode\">");
		// div class=\"listIcon arrow\"
		//sb.append("<div class=\"listIcon relatedIcon\"></div>");
		/*if (node.isMarked())
		{*/
			sb.append("<a class=\"markedSubject\" href=\"" + vf.escapeHTML(subjectUrl + node.getId()) + "\">");
		//}
		// Starts by closing p-tag
		String subjectName = vf.escapeHTML(node.getName()).toLowerCase();
		subjectName = Character.toUpperCase(subjectName.charAt(0)) + subjectName.substring(1);
		sb.append(subjectName);
		
		/*if (node.isMarked())
		{*/
			sb.append("</a>");
		//}
		
		/* ------- NUMBER OF PUBLICATIONS FOR THIS SUBJECT --------
		if (node.isMarked())
		{
			sb.append(" (" + node.getAntal() + " " + textLabel + ")");
		}
		*/
		
		if (node.getChildren() != null)
		{
			sb.append("<ul class=\"relatedSubjectListNode\">");
			for (SubjectTreeNode child : node.getChildren())
			{
				sb.append(toHTMLSubList(child, subjectUrl, textLabel));
			}
			sb.append("</ul>");
		}
		sb.append("</li>");
		
		return sb.toString();
	}
%>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="title" propertyName="Title" useInheritance="false"/>
<structure:componentPropertyValue id="subjectIds" propertyName="SubjectIds" useInheritance="false"/>
<structure:componentPropertyValue id="subjectDataPath" propertyName="GUR_SubjectDataPath" useInheritance="true"/>
<structure:pageUrl id="subjectDetailPage" propertyName="GUR_SubjectDetailPage" useInheritance="true"/>
<structure:componentPropertyValue id="publicationListUrl" propertyName="GUR_GUPListPublicationsURL" useInheritance="true"/>
<structure:componentPropertyValue id="timeout" propertyName="GUR_LuceneCacheTimeout" useInheritance="true"/>
<structure:componentPropertyValue id="gupTimeout" propertyName="GUR_GUPTimeout" useStructureInheritance="true" useInheritance="true"/>
<structure:componentPropertyValue id="gupCacheTime" propertyName="GUR_GUPCacheTimeoutSubjects" useStructureInheritance="true" useInheritance="true"/>

<structure:componentPropertyValue id="departmentId" propertyName="DepartmentId" useStructureInheritance="false" useInheritance="true"/>
<structure:componentPropertyValue id="userId" propertyName="UserId" useStructureInheritance="false" useInheritance="true"/>
<structure:componentPropertyValue id="subjectId" propertyName="SubjectId" useStructureInheritance="false" useInheritance="true"/>
<structure:componentPropertyValue id="threshold" propertyName="Threshold" useStructureInheritance="false" useInheritance="false"/>

<c:if test="${empty title}">
	<structure:componentLabel id="title" mapKeyName="DefaultHeadline"/>
</c:if>

<c:if test="${not empty param.userId}">
    <c:set var="userId" value="${param.userId}" />
</c:if>
<c:if test="${not empty param.subjectId}">
    <c:set var="subjectId" value="${param.subjectId}" />
</c:if>
<c:if test="${not empty param.departmentId}">
    <c:set var="departmentId" value="${param.departmentId}" />
</c:if>
<c:if test="${not empty xname}">
   		<c:set var="userId" value="${xname}" />
</c:if>

<c:if test="${empty departmentId}">
	<structure:pageAttribute id="pageFunction" attributeName="PageFunction" disableEditOnSight="true" />
	<%
		String pageFunction = (String)pageContext.getAttribute("pageFunction");

		if (pageFunction.indexOf("-") > -1)
		{
			String pageType 	= pageFunction.substring(0, pageFunction.indexOf("-"));

			if (pageType.equals("enhetsdetalj"))
			{	
				String departmentId = pageFunction.substring(pageFunction.indexOf("-") + 1);
				pageContext.setAttribute("departmentId", departmentId);
			}
		}
	%>
</c:if>

<common:urlBuilder id="publicationListUrl" baseURL="${publicationListUrl}" includeCurrentQueryString="false" fullBaseUrl="true">
	<c:choose>
		<c:when test="${not empty userId}">
			<common:parameter name="userid" value="${userId}"/>
		</c:when>
		<c:when test="${not empty subjectId}">
			<common:parameter name="svepid" value="${subjectId}"/>
		</c:when>
		<c:when test="${not empty departmentId}">
			<common:parameter name="palassoid" value="${departmentId}"/>
		</c:when>
		<c:otherwise>
			<c:set var="noId" value="true" />
		</c:otherwise>
	</c:choose>
	
	<%-- We are only interested in the header so we get the minimum number of
	     publications. npost=0 seems to to give us all publications --%>
	     
	<common:parameter name="npost" value="1"/>
</common:urlBuilder>

<%-- Data retrieval --%>

<c:if test="${noId ne 'true'}">
	<common:import id="publicationsXml" url="${publicationListUrl}" timeout="${gupTimeout}" charEncoding="utf-8" useCache="true" cacheTimeout="${gupCacheTimeout}" useFileCacheFallback="true" fileCacheCharEncoding="utf-8"/>
</c:if>

<c:choose>
	<c:when test="${noId eq 'true' and pc.isDecorated}">
		<div class="relatedCategoriesTree">
			<h2><c:out value="${title}" escapeXml="false" /></h2>
			<p class="adminError"><structure:componentLabel mapKeyName="NoId"/></p>
		</div>
	</c:when>
	<c:when test="${empty publicationsXml and pc.isDecorated}">
		<div class="relatedCategoriesTree">
			<h2><c:out value="${title}" escapeXml="false" /></h2>
			<p class="adminError"><structure:componentLabel mapKeyName="NoDataFromGup"/></p>
		</div>
	</c:when>
	<c:when test="${not empty publicationsXml}">
	<%--
		<gup:getRelatedSubjects id="relatedSubjects" xmlData="${publicationsXml}"/> --%>
		<c:catch var="parseException">
			<gup:getGUPData xmlData="${publicationsXml}" id="xmlPage"/>
		</c:catch>
		<c:if test="${empty parseException and not empty xmlPage.relatedcategories}">
			<c:set var="relatedSubjects" value="${xmlPage.relatedcategories}"/>
		</c:if>
	</c:when>
</c:choose>

<c:if test="${not empty relatedSubjects}">

	<%-- HTML-component start --%>

	<!--eri-no-index-->

	<div class="guResearchComp relatedCategoriesTree">
		<c:catch var="indexException">
			<lucene:setupIndex id="subjectList" directoryCacheName="subjectList" path="${subjectDataPath}" indexes="catid,node_type" timeout="${timeout}" parser="se.gu.infoglue.lucene.GUCategoryParser" />
		</c:catch>
		
		<c:choose>
			<c:when test="${not empty indexException and pc.isDecorated}">
				<c:choose>
					<c:when test="${pc.componentLogic.infoGlueComponent.positionInSlot eq 0}">
						<h1><c:out value="${title}" escapeXml="false" /></h1>
					</c:when>
					<c:otherwise>
						<h2><c:out value="${title}" escapeXml="false" /></h2>
					</c:otherwise>
				</c:choose>
				<p class="adminError"><structure:componentLabel mapKeyName="IndexInitFailed"/> <c:out value="${indexException.message}"/> (<c:out value="${indexException.class.name}"/>)</p>
			</c:when>
			<c:when test="${empty indexException}">
				<%
					try
					{
						Map<Integer, SubjectTreeNode> subjectTable = new HashMap<Integer, SubjectTreeNode>();
						//new HashSet<SubjectTreeNode>();
						SortedSet<SubjectTreeNode> rootSet = new TreeSet<SubjectTreeNode>(new Comparator<SubjectTreeNode>()
						{
							@Override
							public int compare(SubjectTreeNode stn1, SubjectTreeNode stn2)
							{
								if (stn1 == null && stn2 != null) return -1;
								if (stn1 != null && stn2 == null) return 1;
								if (stn1 == null && stn2 == null) return 0;
								return stn1.getName().compareTo(stn2.getName());
							}
						});
						TemplateController tc = (TemplateController) pageContext.getRequest().getAttribute("org.infoglue.cms.deliver.templateLogic");

						List<Map<String,Object>> categories = (List<Map<String,Object>>)pageContext.getAttribute("relatedSubjects");
						String thresholdString = (String)pageContext.getAttribute("threshold");
						Integer threshold;
						if (thresholdString == null || "".equals(thresholdString))
						{
							%><p class="adminMessage"><structure:componentLabel mapKeyName="ThresholdFormatError"/> <%=thresholdString %></p><%
							threshold = 10;
						}
						else
						{
							threshold = Integer.parseInt(thresholdString);
						}
						//threshold = Math.round(threshold / 100.0f * categories.size());
						for (Map<String,Object> category : categories)
						{		
							Object antalObj = category.get("antal");
							Integer antal;
							if (antalObj instanceof Integer)
							{
								antal = (Integer)antalObj;
							}
							else
							{
								antal = new Integer((String)antalObj);
							}
							if (antal < threshold)
							{
								continue;
							}
							
							// We are not interested in sorting or shortening the list so we pass null to those values
							Object idObj = category.get("catid");
							Integer catid;
							if (idObj instanceof Integer)
							{
								catid = (Integer)idObj;
							}
							else
							{
								catid = new Integer((String)idObj);
							}
							SearchResult sr = SiteLuceneController.getController().search("subjectList", "catid:" + catid, null, null, null, null);
							if (sr.totalSize == 0)
							{
								// There exist subjects that are not SVEP and should not be displayed.
								/*%><p class="adminMessage"><structure:componentLabel mapKeyName="CouldNotFindSubjectError"/> <%=catid %></p><%*/
							}
							else
							{
								Map<String,Object> c = sr.result.get(0);
								Integer id = Integer.parseInt((String)c.get("catid"));
								SubjectTreeNode node = subjectTable.get(id);
								if (node != null)
								{
									// If the node is already in the tree we should mark it as a marked node
									node.setMarked(true);
									node.setAntal(antal);
								}
								else
								{
									String parentidString = (String)c.get("parentid");
									SubjectTreeNode newNode = createNode(c, rootSet, tc);
									if ("IG_EMPTY".equals(parentidString))
									{
										// Is root node
										rootSet.add(newNode);
									}
									else
									{
										Integer parentId = Integer.parseInt(parentidString);
										appendChildNode(newNode, parentId, subjectTable, rootSet, tc);
									}
									newNode.setMarked(true);
									newNode.setAntal(antal);
									subjectTable.put(id, newNode);
								}
							}
						}
						
						pageContext.setAttribute("rootCategories", rootSet);
					}
					catch(Exception ex)
					{
						%>
						<c:if test="${pc.isDecorated}">
							<p class="adminMessage"><structure:componentLabel mapKeyName="GenerateTreeError"/> <%=ex.getMessage() %> (<%=ex.getClass().getName() %>)
							<em><% ex.printStackTrace(); %></em></p>
						</c:if>
						<%
					}
				%>
				
				<c:if test="${not empty rootCategories}">
					<c:choose>
						<c:when test="${pc.componentLogic.infoGlueComponent.positionInSlot eq 0}">
							<h1><c:out value="${title}" escapeXml="false" /></h1>
						</c:when>
						<c:otherwise>
							<h2><c:out value="${title}" escapeXml="false" /></h2>
						</c:otherwise>
					</c:choose>
				</c:if>
				
				<structure:componentLabel id="publicationsText" mapKeyName="Publications"/>
				
				<%
					String textLabel = (String)pageContext.getAttribute("publicationsText");
				%>
				
				<ul class="relatedSubjectListNode topLevel">
					<c:forEach var="rootCategory" items="${rootCategories}" varStatus="loop">
						<%
							SubjectTreeNode rootCategory = (SubjectTreeNode)pageContext.getAttribute("rootCategory");
							String subjectDetailPage = (String)pageContext.getAttribute("subjectDetailPage");
							
							String url;
							if (subjectDetailPage.contains("?"))
							{
								url = subjectDetailPage + "&subjectId=";
							}
							else
							{
								url = subjectDetailPage + "?subjectId=";
							}
							out.print(toHTMLSubList(rootCategory, url, textLabel));
						%>
					</c:forEach>
				</ul>
			</c:when>
		</c:choose>
	</div>
	
	<!--/eri-no-index-->
	
</c:if>
