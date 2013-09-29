<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="org.liveSense.service.languageselector.LanguageSelectorService"%>
<%@page import="javax.security.auth.callback.LanguageCallback"%>
<%@page import="org.liveSense.core.wrapper.RequestWrapper"%>
<%@page import="java.util.Locale"%>
<%@page import="org.liveSense.service.markdown.MarkdownWrapper"%>
<%@page import="org.liveSense.core.wrapper.JcrNodeWrapper"%>
<%@page import="javax.jcr.NodeIterator"%>
<%@page import="javax.jcr.query.Query"%>
<%@page import="javax.jcr.query.QueryManager"%>
<%@page import="javax.jcr.Node"%>
<%@page import="org.liveSense.service.markdown.MarkdownService"%>

<%@page session="false"%>
<%@page contentType="text/html; charset=UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.1"%>
<%@taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<%@taglib tagdir="/WEB-INF/tags/apps/defaultportal/components/tags" prefix="custom" %>

<sling:defineObjects />

<%
	// Get Node wrapper
	LanguageSelectorService languageSelectorService = sling.getService(LanguageSelectorService.class);
	Locale locale =  languageSelectorService.getLocaleByRequest(request);
	JcrNodeWrapper node = new JcrNodeWrapper(currentNode, locale, true);

	pageContext.setAttribute("markdown", new MarkdownWrapper(sling.getService(MarkdownService.class)));
	pageContext.setAttribute("node", node);
	
	//One Page settings
	boolean onepage =  (request.getParameter("onepage") != null) ? Boolean.valueOf(request.getParameter("onepage")).booleanValue() : false;
	request.setAttribute("onepage", onepage);	
%>

<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US" xml:lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8" >
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0" />

    <title>${node.properties['pageTitle']}</title>

	<link href="/defaultportal/css/custom-bootstrap.css" rel="stylesheet" />
	<link rel="shortcut icon" href="/defaultportal/img/favicon.ico" />
	<link rel="icon" href="/defaultportal/img/favicon.ico" />
</head>

<body class="preview" id="top" data-spy="scroll" data-target="header-menu" data-offset="60">

	<!-- Main menu -->

	<custom:navbar node="${node}" jcrType="defaultportal:defaultpage" portalName="defaultportal" scrollSpy="${onepage}" />


	<!-- Content -->
	
	<c:choose>
		<c:when test="${onepage}">
			
			<!-- One Page Layout -->
			<c:set var="query_section" value="SELECT * FROM [defaultportal:defaultpage] WHERE [portalName] = 'defaultportal' AND [menuLevel] = '1' AND [menuLink] IS NOT NULL AND [menuLink] <> '' ORDER BY [menuOrder]" />
			<c:forEach var="z" items="${node.SQL2Query[query_section]}">
				<custom:section node="${z}" needId="${onepage}" />
			</c:forEach>
		</c:when>
		<c:otherwise>

			<!-- Multi page Layout -->
			<custom:section node="${node}" needId="${onepage}" />
		</c:otherwise>
	</c:choose>


	<!-- Footer -->		
		
	<footer id="footer">

		<div class="container">

        	<div class="row">

            	<div class="col-md-12">

					<custom:articles node="${node}" parentMenu="index" jcrType="defaultportal:footer" isFooter="true" />

				</div>

			</div>

		</div>

	</footer>
	
	<!-- Javascript Section -->	

	<script type="text/javascript">
	function post_language(lang_code) {
		<%	
		final LanguageSelectorService lang_service = sling.getService(LanguageSelectorService.class);
		final String storekey_name = lang_service.getStoreKeyName(); 
		%>
		var myForm = document.createElement("form");
  		myForm.method="post" ;
  		myForm.action = "/session/language";

  		var myInput = document.createElement("input") ;
  		myInput.setAttribute("name", "<%= storekey_name %>");
  		myInput.setAttribute("value", lang_code);
  		myForm.appendChild(myInput) ;

  		document.body.appendChild(myForm) ;
  		myForm.submit() ;
  		document.body.removeChild(myForm) ;
	}
	</script> 

    <script src="/defaultportal/js/jquery-1.10.2.min.js"></script>
    <script src="/defaultportal/js/bootstrap.min.js"></script>
    <script type="text/javascript" src="/defaultportal/js/jquery.smooth-scroll.min.js"></script>
    <script type="text/javascript" src="/defaultportal/js/collapse.js"></script>
    <script type="text/javascript" src="/defaultportal/js/scrollspy.js"></script>
</body>
  
</html>
