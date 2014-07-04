<%@page import="java.io.*"%>

<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>

<form method="post">
	<textarea name="text"></textarea><br/>
	<input type="submit" value="Skicka"/>
</form>

<c:set var="text" value="${param.text}"/>

<%
	String myText = (String)pageContext.getAttribute("text");
	
	if (myText != null && !myText.trim().equals(""))
	{
		//String filePath = "/appl/cms/webapps/infoglueCalendar/jsp/portlet/test.jsp";
		String filePath = "/appl/cms/webapps/ROOT/digitalAssets/captcha.txt";
		
		out.print("Fil att uppdatera: " + filePath + "<br/>");
		out.print("Text: " + myText + "<br/>");
			
		BufferedWriter bufferedWriter = null;
	        
		try 
		{
			bufferedWriter = new BufferedWriter(new FileWriter(filePath));
			bufferedWriter.write(myText);
			
			out.print("<br/>Det gick ju fint!<br/>");
		} 
		catch (FileNotFoundException ex) 
		{
			out.print(ex.getMessage());
		} 
		catch (IOException ex) 
		{
			out.print(ex.getMessage());
		} 
		finally 
		{
			//Close the BufferedWriter
			try 
			{
				if (bufferedWriter != null) 
				{
					bufferedWriter.flush();
					bufferedWriter.close();
				}
			} 
			catch (IOException ex) 
			{
				out.print(ex.getMessage());
			}
		}
	}
%>