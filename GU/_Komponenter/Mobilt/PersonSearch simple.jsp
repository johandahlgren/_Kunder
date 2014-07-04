<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<page:deliveryContext id="dc" disablePageCache="true"/>

<c:set var="term" value="lindgren"/>
<c:if test="${not empty param.term}">
	<c:set var="term" value="${param.term}"/>
</c:if>
<common:URLEncode id="term" value="${term}" encoding="iso-8859-1"/>
<c:set var="startIndex" value="1"/>
<c:if test="${not empty param.startIndex}">
	<c:set var="startIndex" value="${param.startIndex}"/>
</c:if>
<c:set var="slotSize" value="10"/>
<c:if test="${not empty param.slotSize}">
	<c:set var="slotSize" value="${param.slotSize}"/>
</c:if>

<%
	String startIndexString = (String)pageContext.getAttribute("startIndex");
	String slotSizeString = (String)pageContext.getAttribute("slotSize");
	float batch = 1.0F;
	try
	{
		float startIndex = Float.parseFloat(startIndexString);
		float slotSize = Float.parseFloat(slotSizeString);
		if(startIndex > 0 && slotSize > 0)
		{
			batch = startIndex / slotSize;
			System.out.println("batch:" + batch);
			if(batch < 1)
				batch = 1;
			else if(Math.round(batch) < batch)
				batch = Math.round(batch) + 1;
			else if(Math.round(batch) > batch)
				batch = Math.round(batch);
		}	
	}
	catch(Exception e)
	{
		System.out.println("Could not parse startIndex of slotSize:" + e.getMessage());
	}
	pageContext.setAttribute("batch", (int)batch);
%>

<c:set var="queryUrl" value="https://dev.cms.it.gu.se/infoglueDeliverWorking/ViewPage.action?languageId=100000&categoryName=Personal&noCharactersInURL=97&site=test&batch=${batch}&searchCategory=105&isSubSelect=null&siteNodeId=112258&hn=${slotSize}&limitToUrl=false&all=false&mainCategory=&divId=personnel&searchDocumentType=0&sortOrder=relevance&spellSuggestion=no&uid=&searchText=${term}" />

<common:import charEncoding="utf-8" id="result" url="${queryUrl}"/>

<%--
query: <c:out value="${queryUrl}" /><br/>
result: <c:out value="${result}" escapeXml="false" /><br/>
--%>

<%!
	class Person {
		private String name = "";
		private String position = "";
		private String organisation = "";
		private String phone = "";
		private String email = "";
		
		void setName(String name) { this.name = name; }
		String getName() { return "" + name; }
		void setPosition(String position) { this.position = position; }
		String getPosition() { return "" + position; }
		void setOrganisation(String organisation) { this.organisation = organisation; }
		String getOrganisation() { return "" + organisation; }
		void setPhone(String phone) { this.phone = phone; }
		String getPhone() { return "" + phone; }
		void setEmail(String email) { this.email = email; }
		String getEmail() { return "" + email; }
		
	}
	
	class PersonComparator implements java.util.Comparator 
	{
  		public int compare(Object obj1, Object obj2) {
    		Person emp1 = (Person) obj1;
	    	Person emp2 = (Person) obj2;
	
	    	return emp1.getName().compareTo(emp2.getName());
	  	}
	}
%>

<%
	try
	{
		String xml = (String) pageContext.getAttribute("result");
		//out.println("XML1: " + xml + "<br/>");
		xml = org.apache.commons.lang.StringEscapeUtils.unescapeHtml(xml);
		//out.println("XML2: " + xml + "<br/>");
		org.infoglue.cms.util.dom.DOMBuilder domBuilder = new org.infoglue.cms.util.dom.DOMBuilder();
		org.dom4j.Document document = domBuilder.getDocument(xml);
		String nhits = document.selectSingleNode("//nhits").getText();
		pageContext.setAttribute("nhits", nhits);
	%>
	
	{
	    "version":"1.0",
		"status":"ok",
	    "hits":"<c:out value="${nhits}" escapeXml="false"/>",
	    "startIndex":0,
	    "slotSize":10,
	    "persons":
	    [

			<%	
				String dataHTML = document.selectSingleNode("//data").getText();
				//System.out.println("dataHTML:" + dataHTML);
				String dataXML = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" + dataHTML.substring(dataHTML.indexOf("<ol start"), dataHTML.indexOf("</ol>") + 5).trim();
				//System.out.println("dataXML:" + dataXML);
				dataXML = dataXML.replaceAll("<strong>","").replaceAll("</strong>", "");
				
				java.util.List<Person> persons = new java.util.ArrayList<Person>();
				org.dom4j.Document dataDocument = domBuilder.getDocument(dataXML);
				//System.out.println("dataDocument:" + dataDocument);
				java.util.List<org.dom4j.Node> liNodes = dataDocument.selectNodes("//li");
				//System.out.println("liNodes:" + liNodes.size());
				for(org.dom4j.Node liNode : liNodes)
				{
					Person person = new Person();
					liNode.selectNodes("span");
					
					java.util.List<org.dom4j.Node> spanNodes = liNode.selectNodes("span");
					//System.out.println("spanNodes:" + spanNodes.size());
					for(org.dom4j.Node spanNode : spanNodes)
					{
						org.dom4j.Element spanElement = (org.dom4j.Element)spanNode;
						if(spanElement.attributeCount() == 0)
						{
							String name = "" + spanElement.getText();
							person.setName(name.trim());
						}
						else
						{
							//System.out.println("Class:" + spanElement.attributeValue("class"));
							if(spanElement.attributeValue("class").equals("position"))
								person.setPosition(spanElement.getText().trim());
							if(spanElement.attributeValue("class").equals("organisation"))
								person.setOrganisation(spanElement.getText().trim());
							if(spanElement.attributeValue("class").equals("phone"))
								person.setPhone(spanElement.getText().trim());
							if(spanElement.attributeValue("class").equals("email"))
								person.setEmail(spanElement.getText().trim());
						}
					}
					
					persons.add(person);
				}
				
				java.util.Collections.sort(persons, new PersonComparator());
				
				
				System.out.println("persons:" + persons.size());
				pageContext.setAttribute("persons", persons);
			%>
			<c:forEach var="person" items="${persons}" varStatus="status">
	   		<c:if test="${status.count > 1}">,</c:if>
			{
				<%
				Person person = (Person)pageContext.getAttribute("person");
				%>
				"name":"<%= person.getName() %>",
	   			"phone":"<%= person.phone %>",
	   			"title":"<%= person.position %>",
	   			"address":"",
	   			"email":"<%= person.email %>",
	   			"serviceUnitId":"",
	   			"servicePlace":"<%= person.organisation %>"
	   		}
			</c:forEach>
	   	]
	} 
	<% 
}
catch(Exception e)
{
%>
	{
    "version":"1.0",
    "status":"nok",
    "errorMessage":"<%= e.getMessage() %>"
    }
<%
}
%>