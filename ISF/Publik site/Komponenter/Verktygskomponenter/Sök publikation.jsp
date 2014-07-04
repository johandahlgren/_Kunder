<%@page import="java.util.TreeMap"%>
<%@page import="java.util.HashMap"%>
<%@page import="org.w3c.dom.Node"%>
<%@page import="javax.xml.xpath.XPathConstants"%>
<%@page import="org.w3c.dom.NodeList"%>
<%@page import="javax.xml.xpath.XPath"%>
<%@page import="java.util.Iterator"%>
<%@page import="java.util.LinkedList"%>
<%@page import="javax.xml.namespace.NamespaceContext"%>
<%@page import="org.infoglue.deliver.util.HttpUtilities"%>
<%@page import="javax.xml.xpath.XPathFactory"%>
<%@page import="javax.xml.xpath.XPathExpression"%>
<%@page import="org.w3c.dom.Document"%>
<%@page import="java.io.StringReader"%>
<%@page import="org.xml.sax.InputSource"%>
<%@page import="javax.xml.parsers.DocumentBuilder"%>
<%@page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@page import="org.infoglue.deliver.controllers.kernel.impl.simple.BasicTemplateController"%>
<%@page import="java.util.List"%>
<%@page import="org.infoglue.cms.entities.management.CategoryVO"%>
<%@page import="org.infoglue.cms.controllers.kernel.impl.simple.CategoryController"%>
<%@page import="java.util.HashSet"%>
<%@page import="java.util.Set"%>
<%@page import="org.infoglue.cms.entities.structure.SiteNodeVO" %>
<%@ taglib prefix="c"         uri="http://java.sun.com/jstl/core" %>
<%@ taglib prefix="page"      uri="infoglue-page" %>
<%@ taglib prefix="structure" uri="infoglue-structure" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib prefix="content"   uri="infoglue-content" %>
<%@ taglib prefix="common"   uri="infoglue-common" %>

<page:pageContext id="pc"/>

<structure:componentPropertyValue id="searchButtonLabel" propertyName="SearchButtonLabel" />

<c:if test="${empty searchButtonLabel}">
	<structure:componentLabel id="searchButtonLabel" mapKeyName="DefaultSearchButtonLabel"/>
</c:if>

<structure:componentLabel id="freeTextLabel" mapKeyName="DefaultFreeTextLabel"/>

<structure:pageUrl id="resultPage" propertyName="ResultPage" useInheritance="true"/>

<content:contentTypeDefinition id="contentDefinition" contentTypeDefinitionName="ISF Publikation" />
<management:contentTypeDefinitionCategories schemaValue="${contentDefinition.schemaValue}" id="categories" />

<%-- ######################################################### --%>
<%-- ####  Retrieve data from Findwise  ###################### --%>
<%-- ######################################################### --%>
<%!
public class HardcodedNamespaceResolver implements NamespaceContext {
	public String getNamespaceURI(String prefix) {
		return "http://www.findwise.com/jellyfish/searchservice";
	}
	
	public String getPrefix(String namespaceURI) {
	    return "fw";
	}
	
	public Iterator getPrefixes(String namespaceURI) {
	    return new LinkedList<String>() {{this.add("http://www.findwise.com/jellyfish/searchservice");}}.iterator();
	}
}
%>

<%
	try
	{
		/* Findwise says: Notera att det finns en känd bug i xml-responsen, där headern säger ISO-8859-1, men responsen egentligen är utf-8. */
		String xmlData = HttpUtilities.getUrlContent("http://localhost/searchws/ident/isf/searcher/pre/search.xml?q=*", "UTF-8");
	
		DocumentBuilderFactory dbf = DocumentBuilderFactory.newInstance();
		DocumentBuilder db = dbf.newDocumentBuilder();
		Document doc = db.parse(new InputSource(new StringReader(xmlData)));
		
		XPath xpath = XPathFactory.newInstance().newXPath();
		xpath.setNamespaceContext(new HardcodedNamespaceResolver());
		//                                                     //displayName[text()="Författare"]/../selectableItems/*
		XPathExpression authorExpression = xpath.compile("//fw:displayName[text()=\"F\u00f6rfattare\"]/../fw:selectableItems/*");
		NodeList nodeList = (NodeList) authorExpression.evaluate(doc, XPathConstants.NODESET);
		Node n = null;

		TreeMap<String,String> authors = new TreeMap<String,String>();
		for (int i = 0; i < nodeList.getLength(); i++)
		{
			n = nodeList.item(i);
			if (n != null && n.getNodeType() == Node.ELEMENT_NODE)
			{
				NodeList itemChildren = n.getChildNodes();
				Node val = null;
				String id = "";
				String name = "";
				for (int j = 0; j < itemChildren.getLength(); j++)
				{
					val = itemChildren.item(j);
					if (val != null && val.getNodeType() == Node.ELEMENT_NODE)
					{
						if ("displayName".equals(val.getNodeName()))
						{
							name = val.getFirstChild().getNodeValue();
						}
						else if ("params".equals(val.getNodeName()))
						{
							NodeList paramNodeList = val.getChildNodes();
							Node param = null;
							for (int k = 0; k < paramNodeList.getLength(); k++)
							{
								param = paramNodeList.item(k);
								//out.print("param.name: " + param.getNodeName() + "<br/>");
								//out.print("param.param: " + param.getAttributes().getNamedItem("name").getFirstChild().getNodeValue() + "<br/>");
								if (param != null && param.getNodeType() == Node.ELEMENT_NODE && "param".equals(param.getNodeName()) && "author_facet".equals(param.getAttributes().getNamedItem("name").getFirstChild().getNodeValue()))
								{
									Node x = null;
									for (int l = 0; l < param.getChildNodes().getLength(); l++)
									{
										x = param.getChildNodes().item(k);
										if (x != null && x.getNodeType() == Node.ELEMENT_NODE && "value".equals(x.getNodeName()))
										{
											id = x.getFirstChild().getNodeValue();
										}
									}
								}
							}
						}
					}
				}
				authors.put(name, id);
			}
		}
		pageContext.setAttribute("authors", authors);
		
		/* #################################################################
		 * ####  Ämnesområden  #############################################
		 * ################################################################# */
		XPathExpression areasExpression = xpath.compile("//fw:displayName[text()=\"\u00c4mnesomr\u00e5den\"]/../fw:selectableItems/*");
		NodeList areasExpressionNodeList = (NodeList) areasExpression.evaluate(doc, XPathConstants.NODESET);
		Node an = null;

		HashMap<String,String> areas = new HashMap<String,String>();
		for (int i = 0; i < areasExpressionNodeList.getLength(); i++)
		{
			an = areasExpressionNodeList.item(i);
			if (an != null && an.getNodeType() == Node.ELEMENT_NODE)
			{
				NodeList itemChildren = an.getChildNodes();
				Node val = null;
				String id = "";
				String name = "";
				for (int j = 0; j < itemChildren.getLength(); j++)
				{
					val = itemChildren.item(j);
					if (val != null && val.getNodeType() == Node.ELEMENT_NODE)
					{
						if ("displayName".equals(val.getNodeName()))
						{
							name = val.getFirstChild().getNodeValue();
						}
						else if ("params".equals(val.getNodeName()))
						{
							NodeList paramNodeList = val.getChildNodes();
							Node param = null;
							for (int k = 0; k < paramNodeList.getLength(); k++)
							{
								param = paramNodeList.item(k);
								//out.print("param.name: " + param.getNodeName() + "<br/>");
								//out.print("param.param: " + param.getAttributes().getNamedItem("name").getFirstChild().getNodeValue() + "<br/>");
								if (param != null && param.getNodeType() == Node.ELEMENT_NODE && "param".equals(param.getNodeName()) && "fac_top".equals(param.getAttributes().getNamedItem("name").getFirstChild().getNodeValue()))
								{
									Node x = null;
									for (int l = 0; l < param.getChildNodes().getLength(); l++)
									{
										x = param.getChildNodes().item(k);
										if (x != null && x.getNodeType() == Node.ELEMENT_NODE && "value".equals(x.getNodeName()))
										{
											id = x.getFirstChild().getNodeValue();
										}
									}
								}
							}
						}
					}
				}
				areas.put(id, name);
			}
		}
		pageContext.setAttribute("areas", areas);
	}
	catch (Exception ex)
	{
		out.print("<div class=\"adminMessage\">" + ex.getMessage() + "</div>");
	}
%>

<structure:componentPropertyValue id="pageCategory" propertyName="PageCategory" useInheritance="true"/>
<%
	String pageCategory = (String)pageContext.getAttribute("pageCategory");

	if (pageCategory != null && !"".equals(pageCategory.trim()))
	{
		CategoryVO vo = CategoryController.getController().findByPath("/ISFArea/" + pageCategory);
		pageContext.setAttribute("pageAreaVO", vo);
	}
%>
<c:if test="${not empty pageAreaVO}">
	<management:categoryDisplayName id="pageArea" categoryVO="${pageAreaVO}"/>
</c:if>

<c:if test="${empty pageCategory}">
	<c:set var="pageCategory" value="Startsida" />
</c:if>

<!-- eri-no-index -->
<div id="publicationSearch">
	<div class="innerContainer">
    	<h2><structure:componentLabel mapKeyName="SearchPublicationTitle"/></h2>
		<form class="searchPublicationForm" action="<c:out value="${resultPage}" />" method="get" accept-charset="utf-8">
	        <fieldset>
	            <legend><structure:componentLabel mapKeyName="SearchPublicationLegend"/></legend>
	            <input type="hidden" class="emptyQuery" name="emptyQuery" value="no" />
	            <input type="hidden" name="searchClient" value="isf_pub" />
	            <label for="textField"><c:out value="${freeTextLabel}" /></label>
	            <input id="textField" name="q" type="text" <c:out value="${param[freeText]}" /> /> 
	            <label for="section"><structure:componentLabel mapKeyName="DefaultCategoryLabel"/></label>
	            <select id="section" name="fac_top">
	            	<option value=""><structure:componentLabel mapKeyName="DefaultCategoryLabel"/></option>
	            	<c:forEach var="area" items="${areas}">
						<c:if test="${area.value ne 'Startsida'}">
							<option value="<c:out value="${area.key}" />" <c:if test="${pageArea eq area.value}">selected="selected"</c:if>><c:out value="${area.value}" /></option>
						</c:if>
					</c:forEach>
	            </select>
	            <label for="author_facet"><structure:componentLabel mapKeyName="DefaultAuthorLabel"/></label>
	            <select name="author_facet">
	            	<option selected="selected" value=""><structure:componentLabel mapKeyName="DefaultAuthorLabel"/></option>
		            <c:forEach var="author" items="${authors}">
		            	<option value="<c:out value="${author.value}"/>"><c:out value="${author.key}"/></option>
		            </c:forEach>
	            </select>
	            <%-- 
	            <input type="text"  id="author" name="author" class="searchHint" />--%>
	            <input type="submit" class="searchButton" value="<c:out value="${searchButtonLabel}" />" />
	        </fieldset>
		</form>
    </div>
</div>
<!-- /eri-no-index -->
