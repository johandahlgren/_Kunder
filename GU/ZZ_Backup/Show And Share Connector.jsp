<%@page import="sun.misc.JavaUtilJarAccess"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Date"%>

<%@page import="org.xml.sax.InputSource"%>
<%@page import="java.io.StringReader"%>

<%@page import="javax.xml.parsers.DocumentBuilder"%>
<%@page import="javax.xml.parsers.DocumentBuilderFactory"%>
<%@page import="se.gu.infoglue.gup.GUPMapConverter.GUPMap"%>
<%@page import="java.util.List"%>
<%@page import="java.util.Map"%>
<%@page import="java.util.HashMap"%>
<%@page import="java.util.Arrays"%>
<%@page import="java.util.ArrayList"%>
<%@page import="se.gu.infoglue.gup.GUPMapConverter"%>
<%@ page import="javax.net.ssl.SSLContext" %>
<%@ page import="javax.net.ssl.X509TrustManager" %>
<%@ page import="javax.net.ssl.TrustManager" %>

<%@ page import="javax.net.ssl.HttpsURLConnection" %>
<%@ page import="java.net.MalformedURLException" %>
<%@ page import="java.io.IOException" %>
<%@ page import="java.io.InputStreamReader" %>
<%@ page import="java.net.URL" %>
<%@ page import="java.net.URLConnection" %>
<%@ page import="java.io.OutputStreamWriter" %>
<%@ page import="java.io.BufferedReader" %>

<%@ page import="org.infoglue.cms.util.dom.DOMBuilder" %>
<%@ page import="org.dom4j.Document" %>
<%@ page import="org.dom4j.Node" %>
<%@ page import="org.dom4j.Element" %>
<%@ page import="org.dom4j.XPath" %>
<%@ page import="org.dom4j.DocumentHelper" %>

<%@ page import="org.infoglue.deliver.util.CacheController" %>

<%@ taglib uri="http://java.sun.com/jstl/core" prefix="c" %>
<%@ taglib uri="infoglue-structure" prefix="structure" %>
<%@ taglib uri="infoglue-page" prefix="page"%>

<page:httpHeader name="Cache-Control" value="no-cache, no-store, must-revalidate" />
<page:httpHeader name="Pragma" value="no-cache" />
<page:httpHeader name="Expires" value="0" />

<%!	
	private static String getStringValue(Node aElement, String aXPath)
	{		
		String returnValue = "";
		
		if (aElement != null)
		{
			Node temp = aElement.selectSingleNode(aXPath);
						
			if (temp != null)
			{
				returnValue = temp.getText();
			}
		}
				
		return returnValue;
	}

	private static String findBestValue(Node aElement, String aXPath, List<String> aValues)
	{
		String currentValue = "";
		String currentXPath = "";
		String temp = "";
		
		for (int i = 0; i < aValues.size(); i ++)
		{
			currentValue = aValues.get(i);
			currentXPath = aXPath.replaceAll("XXX", currentValue);
			temp = getStringValue(aElement, currentXPath);
			if (temp.length() > 0)
			{
				return temp;
			}
		}
		return "";
	}
	
	private HashMap<String, String> extractMovieData(Node dataElement, String aRequestedThumbnailHeight, String aRequestedLargeImageHeight, String aRequestedMovieHeight)
	{
		HashMap<String, String> itemMap = new HashMap<String, String>();
		
		itemMap.put("videoId", getStringValue(dataElement, "id/ccsid"));
		itemMap.put("title", getStringValue(dataElement, "title"));
		itemMap.put("text", getStringValue(dataElement, "description"));
		
		String unixDateString			= getStringValue(dataElement, "contentattribute[key='addedDate']/value");
		Date publishDate 				= new Date(new Long(unixDateString).longValue());
		SimpleDateFormat sdf			= new SimpleDateFormat("yyyy-MM-dd");
		String formattedDate 			= sdf.format(publishDate);
		itemMap.put("publishDate", formattedDate);

		itemMap.put("publishedBy", getStringValue(dataElement, "author/username"));
		itemMap.put("duration", getStringValue(dataElement, "contentattribute[key='duration']/value"));
		itemMap.put("internalLink", "");
		itemMap.put("externalLink", "");
		itemMap.put("linkText", "");
		itemMap.put("isInfoglueContent", "false");
		
		getStringValue(dataElement, "author/username");
		
		List<String> smallThumbnailSizes = Arrays.asList("360", "288", "136");
		itemMap.put("imageUrl", findBestValue(dataElement, "contentthumbnail/imageasset[height='XXX']/uri/urivalue", smallThumbnailSizes));

		List<String> largeThumbnailSizes = Arrays.asList("768", "720", "576", "480", "360", "288", "136");
		itemMap.put("largeImageUrl", findBestValue(dataElement, "contentthumbnail/imageasset[height='XXX']/uri/urivalue", largeThumbnailSizes));
		
		/*-------------------------------------------
		 If there is a video node in the XML we want 
		 to extract it and add it to the response
		 ------------------------------------------*/
		 
		if (dataElement.selectSingleNode("video") != null)
		{
			List<String> movieSizes = Arrays.asList("720", "576", "480", "360");
			String fullMovieUrl 	= findBestValue(dataElement, "video/videoasset[height='XXX']/uri[1]/urivalue", movieSizes);
			
			List<String> fallbackSizes = Arrays.asList("576", "480", "360", "720");
			String fallbackUrl 		= findBestValue(dataElement, "video/videoasset[height='XXX']/uri[2]/urivalue", fallbackSizes);
			
			if (fullMovieUrl.length() > 0)
			{
				String temp 			= fullMovieUrl.substring(0, fullMovieUrl.lastIndexOf("/"));
				int breakPoint 			= temp.lastIndexOf("/") + 1;
				String netConnectionUrl = fullMovieUrl.substring(0, breakPoint);
				String movieUrl 		= fullMovieUrl.substring(breakPoint);
				
				itemMap.put("fullMovieUrl", fullMovieUrl);
				itemMap.put("netConnectionUrl", netConnectionUrl);
				itemMap.put("movieUrl", movieUrl);
				itemMap.put("fallbackUrl", fallbackUrl);
			}
		}
		else
		{
			itemMap.put("movieUrl", "showAndShareMovie");
		}
		
		return itemMap;
	}
%>


<%-------------------------


     Code starts here


-------------------------%>


<c:set var="searchType" value="searchFreeText" />

<c:set var="showAndShareUrl" value="${showAndShareUrl}" />
<c:set var="textQuery" value="${textQuery}" />
<c:set var="categoryQuery" value="${categoryQuery}" />
<c:set var="authorQuery" value="${authorQuery}" />
<c:set var="mediaId" value="${mediaId}" />
<c:set var="showAndShareCacheTimeout" value="${showAndShareCacheTimeout}" />

<!--
QUERY PARAMS: 

showAndShareUrl: <c:out value="${showAndShareUrl}" /><br/>
textQuery: <c:out value="${textQuery}" /><br/>
categoryQuery: <c:out value="${categoryQuery}" /><br/>
authorQuery: <c:out value="${authorQuery}" /><br/>
mediaId: <c:out value="${mediaId}" /><br/>
-->

<%
	long start = System.currentTimeMillis();

	out.print("<!-- Timestamp in the S&S connector: " + start + " -->");

	String showAndShareUrl 			= (String)pageContext.getAttribute("showAndShareUrl");
	String textQuery 				= (String)pageContext.getAttribute("textQuery");
	String categoryQuery 			= (String)pageContext.getAttribute("categoryQuery");
	String authorQuery 				= (String)pageContext.getAttribute("authorQuery");
	String mediaId 					= (String)pageContext.getAttribute("mediaId");
	String showAndShareCacheTimeout = (String)pageContext.getAttribute("showAndShareCacheTimeout");
	String cacheName 				= "ShowAndShareConnectorCache";
	String cacheKey 				= showAndShareUrl + "_" + textQuery + "_" + categoryQuery + "_" + authorQuery + "_" + mediaId;
	int timeout 					= 60 * 60; // Timeout 1h
	
	try
	{
		timeout = Integer.parseInt(showAndShareCacheTimeout);
	}
	catch (NumberFormatException nfe)
	{
		out.print("Invalid cache timeout sent to the connector: " + nfe.getMessage());
	}
	
	Object objectFromCache 	= CacheController.getCachedObjectFromAdvancedCache(cacheName, cacheKey, timeout);
		
	if (objectFromCache != null)
	{
		pageContext.setAttribute("mediaItems", (ArrayList<HashMap<String, String>>)objectFromCache);
		
		out.print("<!-- Using cached value in the S&S connector. Timeout: " + timeout + " s -->");
	}
	else
	{
		%>
		<c:choose>
			<c:when test="${not empty mediaId}">
				<c:set var="requestXml">
					<xml-fragment xmlns:vp="http://model.data.core.vportal.cisco.com/vp_ns">
						<vp:vportal>
							<vportal_id>1</vportal_id>
						</vp:vportal>
						<vp:vprequest>
							<query>getContentById</query>
						</vp:vprequest>
						<vp:vportal>
							<vportal_id>1</vportal_id>
						</vp:vportal>
						<vp:vpcontent>
							<id>
								<ccsid><c:out value="${mediaId}" /></ccsid>
							</id>
						</vp:vpcontent>
					</xml-fragment>
				</c:set>
			</c:when>
			<c:when test="${not empty textQuery or not empty categoryQuery or not empty authorQuery}">
				<c:set var="requestXml">
					<xml-fragment xmlns:vp="http://model.data.core.vportal.cisco.com/vp_ns">
						<vp:vportal>
							<vportal_id>1</vportal_id>
						</vp:vportal>
						<vp:vprequest>
							<query>searchContent</query>
						</vp:vprequest>
						<vp:vpcontentsearch>
							<locale>en_US</locale>
							<start>0</start>
							<limit>10</limit>
							<contentType>VIDEO_PORTAL</contentType>
							<searchQuery>
								<searchText><c:out value="${textQuery}" /></searchText>
								<fields>
									<field>title</field>
									<field>description</field>
									<field>author</field>
									<field>com.cisco.vportal.1.tags</field>
								</fields>
								<searchParamList>
									<searchParam>
										<fieldName>searchType</fieldName>
										<fieldValue>content/composite/vp</fieldValue>
										<paramClause>EQUAL</paramClause>
										<boost>0.9</boost>
									</searchParam>
									<c:if test="${not empty authorQuery}">
										<searchParam>
											<fieldName>author</fieldName>
											<fieldValue><c:out value="${authorQuery}" /></fieldValue>
											<paramClause>EQUAL</paramClause>
											<boost>0.9</boost>
										</searchParam>
									</c:if>
								</searchParamList>
								<sortCriteriaList>
									<sortCriteria>
										<fieldName>com.cisco.vportal.1.addedDate</fieldName>
										<sortingOrder>DESCENDING</sortingOrder>
										<sortingPriority>0.1</sortingPriority>
									</sortCriteria>
								</sortCriteriaList>
								<queryRangeList/>
								<queryPhraseList/>
								<sortCriteriaList/>
							</searchQuery>
							<contentGroupId><c:out value="${categoryQuery}" /></contentGroupId>
						</vp:vpcontentsearch>
					</xml-fragment>
				</c:set>
			</c:when>
			<c:otherwise>
				Ingen s&ouml;ktyp hittades...<br/>
			</c:otherwise>
		</c:choose>
		
		
		<%
			try
			{
				//-------------------------------------------------
				// Set up a cert manager that trusts strange sites
				//-------------------------------------------------
				
				TrustManager[] trustAllCerts = new TrustManager[]{
				    new X509TrustManager() {
				        public java.security.cert.X509Certificate[] getAcceptedIssuers() {
				            return null;
				        }
				        public void checkClientTrusted(
				            java.security.cert.X509Certificate[] certs, String authType) {
				        }
				        public void checkServerTrusted(
				            java.security.cert.X509Certificate[] certs, String authType) {
				        }
				    }
				};
				
				//----------------------------------------
				// Install the all-trusting trust manager
				//----------------------------------------
				
				try 
				{
				    SSLContext sc = SSLContext.getInstance("SSL");
				    sc.init(null, trustAllCerts, new java.security.SecureRandom());
				    HttpsURLConnection.setDefaultSSLSocketFactory(sc.getSocketFactory());
				} 
				catch (Exception e) 
				{
				}
				
				//------------------------------------
				// Connect to the Show & Share server
				//------------------------------------
				
				StringBuffer sasResponse 	= new StringBuffer();
				String requestXml 			= (String)pageContext.getAttribute("requestXml");
				HttpsURLConnection conn		= null;
				URL url						= null;
				String line					= null;
				OutputStreamWriter writer	= null;
				BufferedReader reader		= null;
					
				try
				{
					url = new URL(showAndShareUrl);
					
				}
				catch (MalformedURLException mue)
				{
					out.print("Error setting up URL: " + mue.getMessage() + "<br/>The UrL was: " + showAndShareUrl);
				}
				
				try
				{
					conn = (HttpsURLConnection)url.openConnection();
				}
				catch (IOException ioe)
				{
					out.print("Error connecting to the server: " + ioe.getMessage() + "<br/>");
				}
				
				if (conn != null)
				{
					conn.setDoOutput(true);
					conn.setRequestProperty("Content-Type", "application/xml");
					
					try 
					{
						writer = new OutputStreamWriter(conn.getOutputStream());
					}
					catch (Exception e)
					{
						out.print("Error getting output stream: " + e.getMessage() + "<br/>");
					}
			
					if (requestXml != null && !requestXml.trim().equals(""))
					{
						if (writer != null)
						{
							try
							{
								writer.write(requestXml);
								writer.flush();
							}
							catch (IOException ioe)
							{
								out.print("Error writing query: " + ioe.getMessage() + "<br/>");
							}
							
							try
							{
								reader = new BufferedReader(new InputStreamReader(conn.getInputStream()));
								
								while ((line = reader.readLine()) != null) 
								{
									sasResponse.append(line);
								}
							}
							catch (IOException ioe)
							{
								out.print("Error reading from source: " + ioe.getMessage() + "<br/>");
							}
						}
					}
					else
					{
						out.print("No input...");
					}
					
					if (writer != null) writer.close();
					if (reader != null) reader.close(); 
				}
				
				try
				{
				    ArrayList<HashMap<String, String>> movieList 	= new ArrayList<HashMap<String, String>>();
				    
				    DOMBuilder builder = new DOMBuilder();
				    Document document = builder.getDocument(sasResponse.toString());
				    
				    Map<String, String> namespaceUris = new HashMap<String, String>();  
				    namespaceUris.put("vp", "http://model.data.core.vportal.cisco.com/vp_ns");
				    
				    XPath xPath = DocumentHelper.createXPath("//vp:vpcontent");  
				    xPath.setNamespaceURIs(namespaceUris);
				    
				    List<Node> movieNodes = xPath.selectNodes(document);
					
					for (int temp = 0; temp < movieNodes.size(); temp++) 
					{
						Node movieNode = movieNodes.get(temp);
						
						if (movieNode.getNodeType() == Node.ELEMENT_NODE) 
						{
							HashMap<String, String> movieItem = extractMovieData(movieNode, "136", "720", "576");
							if (movieItem != null)
							{
								movieList.add(movieItem);
							}
						}
					}
				    
					CacheController.cacheObjectInAdvancedCache(cacheName, cacheKey, movieList);
					
					out.print("<!-- Storing new value in cache in the S&S connector. Timeout: " + timeout + " s -->");
					
					pageContext.setAttribute("mediaItems", movieList);
				}
				catch (Exception e)
				{
					out.print("An error occured when parsing response: " + e.getMessage());
					System.out.println("Exception in GU Videogalleri while parsing response: " + e.getMessage());
				}
			}
			catch (Throwable t)
			{
				out.print("Nu blev det fel... " + t.getMessage());
				System.out.println("Throwable in GU Videogalleri: " + t.getMessage());
			}
	}
	
	long end = System.currentTimeMillis();
	
	out.print("<!-- Took: " + (end - start) + " ms -->");
		
	%>

<c:set var="mediaItemsFromConnector" value="${mediaItems}" scope="request" />