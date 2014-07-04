<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-management" prefix="management" %>
<%@ taglib uri="infoglue-content" prefix="content" %>
<%@ taglib uri="infoglue-common" prefix="common" %>
<%@ taglib uri="infoglue-page" prefix="page" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ page contentType="text/xml; charset=UTF-8"%>

<page:deliveryContext id="deliveryContext" disableNiceUri="false" trimResponse="true" />

<page:httpHeader name="Cache-Control" value="no-cache"/>
<page:httpHeader name="Pragma" value="no-cache"/>
<page:httpHeader name="Expires" value="0"/>

<%-- Default values --%> 
<%
	float transTimeDefault = 1.5f;
	float textTransTimeDefault = 1.0f;
	int textMarginDefault = 13;
	int fontSizeDefault = 19;
	int textMarginVerticalDefault = 8;
	
	float plateAlphaDefault = 0.4f;
%> 
<structure:componentPropertyValue id="transTime" siteNodeId="${param.originalSiteNodeId}" propertyName="TransTime"/>
<structure:componentPropertyValue id="textTransTime" siteNodeId="${param.originalSiteNodeId}" propertyName="TextTransTime"/>
<structure:componentPropertyValue id="textMargin" siteNodeId="${param.originalSiteNodeId}" propertyName="TextMargin"/>
<structure:componentPropertyValue id="fontSize" siteNodeId="${param.originalSiteNodeId}" propertyName="FontSize"/>
<structure:componentPropertyValue id="textMarginVertical" siteNodeId="${param.originalSiteNodeId}" propertyName="TextMarginVertical"/>
<structure:componentPropertyValue id="randomList" siteNodeId="${param.originalSiteNodeId}" propertyName="RandomFlashImages"/>

<content:boundContents id="flashImages" siteNodeId="${param.originalSiteNodeId}" propertyName="GUFlashImages"/>

<%-- Check properties --%>
<%-- Check property transTime --%> <%
	String transTime = (String)pageContext.getAttribute("transTime");
	try 
	{
		Float.parseFloat(transTime);
	} 
	catch(Exception nfe) 
	{
		pageContext.setAttribute("transTime", ""+transTimeDefault);
	}
%><%-- Check property textTransTime --%><%
	String textTransTime = (String)pageContext.getAttribute("textTransTime");
	try 
	{
		Float.parseFloat(textTransTime);
	} 
	catch(Exception nfe) 
	{
		pageContext.setAttribute("textTransTime", ""+textTransTimeDefault);
	}
%><%-- Check property textMargin --%><%
	String textMargin = (String)pageContext.getAttribute("textMargin");
	try 
	{
		Integer.parseInt(textMargin);
	} 
	catch(Exception nfe) 
	{
		pageContext.setAttribute("textMargin", ""+textMarginDefault);
	}
%><%-- Check property fontSize --%><%
	String fontSize = (String)pageContext.getAttribute("fontSize");
	try 
	{
		Integer.parseInt(fontSize);
	} 
	catch(Exception nfe) 
	{
		pageContext.setAttribute("fontSize", ""+fontSizeDefault);
	}
%> <%-- Check property textMarginVertical --%> <%
	String textMarginVertical = (String)pageContext.getAttribute("textMarginVertical");
	try 
	{
		Integer.parseInt(textMarginVertical);
	} 
	catch(Exception nfe) 
	{
		pageContext.setAttribute("textMarginVertical", ""+textMarginVerticalDefault);
	}
%>	<%-- Check property randomList --%> <%
	String randomList = (String)pageContext.getAttribute("randomList");
	try
	{
		pageContext.setAttribute("randomList", Boolean.parseBoolean(randomList));
	}
	catch(Exception nfe)
	{
		pageContext.setAttribute("randomList",false);
	}
%>
<root>
  <general transTime="<c:out value="${transTime}" />" textTransTime="<c:out value="${textTransTime}" />" textMargin="<c:out value="${textMargin}" />" fontSize="<c:out value="${fontSize}" />" textMarginVertical="<c:out value="${textMarginVertical}" />" randomList="<c:out value="${randomList}" />"/>
  <images>
	<c:forEach var="image" items="${flashImages}">
		<content:contentAttribute id="plateAlpha" contentId="${image.contentId}" attributeName="PlateAlpha" disableEditOnSight="true"/>
		<content:contentAttribute id="URL" contentId="${image.contentId}" attributeName="URL" disableEditOnSight="true"/>
		<content:contentAttribute id="txt" contentId="${image.contentId}" attributeName="Txt" disableEditOnSight="true"/> <%
		String plateAlpha = (String)pageContext.getAttribute("plateAlpha");
		try 
		{
			Float.parseFloat(plateAlpha);
		} 
		catch(Exception nfe) 
		{
			pageContext.setAttribute("plateAlpha", ""+plateAlphaDefault);
		}
		%>
		<content:assetUrl id="imageUrl" contentId="${image.contentId}"/>
		<image src="<c:out value="${imageUrl}" />" txtAlign="left" txt="<c:out value="${txt}" />" txtColor="0xFFFFFF" timer="7" plateColor="0x000000" plateAlpha="<c:out value="${plateAlpha}" />" url="<c:out value="${URL}" />"/>
	</c:forEach>
  </images>
</root>