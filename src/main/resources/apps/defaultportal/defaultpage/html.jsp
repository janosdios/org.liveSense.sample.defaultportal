<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
	"http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<%@page import="javax.jcr.NodeIterator"%>
<%@page import="javax.jcr.query.Query"%>
<%@page import="javax.jcr.query.QueryManager"%>
<%@page import="javax.jcr.Node"%>

<%@page import="java.util.Locale"%>

<%@page import="org.liveSense.service.languageselector.LanguageSelectorService" %>

<%@page import="org.liveSense.core.wrapper.RequestWrapper" %>

<%@page session="false"%>
<%@page contentType="text/html; charset=UTF-8" %> 
<%@taglib prefix="sling" uri="http://sling.apache.org/taglibs/sling/1.0"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@taglib prefix="json" uri="http://www.atg.com/taglibs/json"%>
<sling:defineObjects/>


<html xmlns="http://www.w3.org/1999/xhtml" dir="ltr" lang="en-US" xml:lang="en">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
    <meta http-equiv="X-UA-Compatible" content="IE=EmulateIE7" />
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <title><%= currentNode.getProperty("pageTitle").getValue().getString() %></title>
    
	<!-- Start Stylesheets -->
	<link rel="stylesheet" href="css/styles.css" />
    <link href="css/polyglot-language-switcher.css" type="text/css" rel="stylesheet">
	<!-- End Stylesheets -->

	<!-- Start Javascript -->
	<script type="text/javascript" src="js/jquery-1.7.min.js"></script>
	<script type="text/javascript" src="js/jquery.countdown.js"></script>
	<script type="text/javascript" src="js/custom.js"></script>
	<script type="text/javascript" src="js/twitter.js"></script>
	
    <script src="js/persist-min.js" type="text/javascript"></script>
    <script src="js/jquery.timer.js" type="text/javascript"></script>
    <script src="js/jquery.polyglot.language.switcher.js" type="text/javascript"></script>
    <script type="text/javascript">
        $(document).ready(function() {
            $('#polyglotLanguageSwitcher').polyglotLanguageSwitcher({
            	websiteType: 'dynamic',
            	effect: 'slide',
				openMode: 'hover',
                testMode: false,
                animSpeed: 400,
                callback: function(language_id){
                	<%	
            		final LanguageSelectorService lang_service = sling.getService(LanguageSelectorService.class);
            		final String storekey_name = lang_service.getStoreKeyName(); 
            		%>
            		var myForm = document.createElement("form");
              		myForm.method="post" ;
              		myForm.action = "/session/language";

              		var myInput = document.createElement("input") ;
              		myInput.setAttribute("name", "<%= storekey_name %>");
              		myInput.setAttribute("value", language_id);
              		myForm.appendChild(myInput) ;

              		document.body.appendChild(myForm) ;
              		myForm.submit() ;
              		document.body.removeChild(myForm) ;
              		return true;
                }
            });
        });	
    </script>
    <script src="/system/sling.js"></script>
	<!-- End Javascript -->
	
	<link rel="shortcut icon" href="images/misc/favicon.ico">
	<link rel="icon" href="images/misc/favicon.ico">
</head>

<body>

	<%
	Locale curr_locale = null;
	if (lang_service != null) {
		RequestWrapper rw = new RequestWrapper(request, lang_service.getLocaleByRequest(request));
		curr_locale = rw.getLocale();
		if (curr_locale != null) {
			request.setAttribute("curr_locale", curr_locale);
		}	
	}
	%>

    <div id="resize">
    
		<header class="clearfix">
		
			<a href="http://www.livesense.in" class="logo hidden">liveSense Home Page</a>
			
			<ul class="navigation">
                <%
                Node node = currentNode;
                NodeIterator siblings = node.getSession().getWorkspace().getQueryManager().
                createQuery("SELECT [menuName_hu] FROM [defaultportal:defaultpage]  WHERE [portalName] = 'defaultportal' ORDER BY [menuOrder]", Query.JCR_SQL2).execute().getNodes();
                while (siblings.hasNext()) {
                	node = siblings.nextNode();
                	if (currentNode.getName().equalsIgnoreCase(node.getName())) {
                %>
              	<li class="subnav current"><%} else {%><li class="subnav"><%}%>
              	<a href="<%= node.getName()+".html" %>"><%= node.getProperty("menuName_" + curr_locale.getLanguage()).getValue().getString() %></a></li>
                <%
                }
    			%>
			</ul><!-- End Navigation -->
			
			
    		<div id="polyglotLanguageSwitcher">
				<form action="#">
					<select id="polyglot-language-options">
						<option id="en" value="en_US"<%if (curr_locale.getLanguage().toString().equals("en")) out.print(" selected");%>></option>
						<option id="fr" value="fr_FR"<%if (curr_locale.getLanguage().toString().equals("fr")) out.print(" selected");%>></option>
						<option id="de" value="de_DE"<%if (curr_locale.getLanguage().toString().equals("de")) out.print(" selected");%>></option>
						<option id="es" value="es_ES"<%if (curr_locale.getLanguage().toString().equals("es")) out.print(" selected");%>></option>
						<option id="hu" value="hu_HU"<%if (curr_locale.getLanguage().toString().equals("hu")) out.print(" selected");%>></option>
					</select>
				</form>
			</div>
			
			
		</header><!-- End Header -->

		
		<div id="main_wrapper" class="clearfix">

		
		
			<div class="headline">
		
			<h1><%=currentNode.getProperty("title_" + curr_locale.getLanguage()).getValue().getString() %></h1>
			<p><%=currentNode.getProperty("content_" + curr_locale.getLanguage()).getValue().getString() %></p>	
			</div>

            <%
            Node sample_node = currentNode;
            String orig_text = null;
			long display_counter = 1;
			long columns = 3;
			
            String sql = "SELECT [title_hu] FROM [defaultportal:article]  WHERE [parentMenu] = '" + currentNode.getName() + "' ORDER BY [displayOrder]";
			
            NodeIterator sample_siblings = sample_node.getSession().getWorkspace().getQueryManager().createQuery(sql, Query.JCR_SQL2).execute().getNodes();
            if (sample_siblings.getSize() == 0) {
				out.print("<br/>");
			} else {
            	while (sample_siblings.hasNext()) {
            		sample_node = sample_siblings.nextNode();

					if (display_counter == 1) {
						out.print("<div class='clearfix'>");   
					}
			%>
					<div class="one-third">
		        		<h3><%=sample_node.getProperty("title_" + curr_locale.getLanguage()).getValue().getString() %></h3>
						<p><%=sample_node.getProperty("content_" + curr_locale.getLanguage()).getValue().getString() %></p>
					</div>
 			<%
					if ((display_counter == columns) || (!sample_siblings.hasNext())) {
						out.print("</div>");   
					}
					if (display_counter == columns) {
						out.print("<br/><br/>");   
					}
					display_counter = display_counter + 1;
					if (display_counter > columns) {
						display_counter = 1;
					}
            	}
     		}
			%>








<!--		
			<div id="countdown" class="clearfix"></div>	
			
			<form  class="emailform" method="post" action="subscribe.php">
			
				<input class="emailsubscribe left" type="text" name="mail" placeholder="What’s your email? We’ll tell you when we launch." onFocus="if(!this._haschanged){this.value=''};this._haschanged=true;" />
				<input type="hidden" name="do" value="mail" />
				<input class="emailsubmit hidden" type="submit" name="submit" value="Submit" />
					
			</form>
-->
		
		</div><!-- End main_wrapper -->



		
		<footer class="clearfix">



            <%
            Node footer_node = currentNode;
			long f_display_counter = 1;
			long f_columns = 3;
			
            String f_sql = "SELECT [title_hu] FROM [defaultportal:footer]  WHERE [portalName] = 'defaultportal' ORDER BY [displayOrder]";
			
            NodeIterator footer_siblings = sample_node.getSession().getWorkspace().getQueryManager().createQuery(f_sql, Query.JCR_SQL2).execute().getNodes();
            if (footer_siblings.getSize() == 0) {
				out.print("<br/>");
			} else {
            	while (footer_siblings.hasNext()) {
            		footer_node = footer_siblings.nextNode();

					if (f_display_counter == 1) {
						out.print("<div class='clearfix'>");   
					}
			%>
					<div class="one-third">
		        		<h3><%=footer_node.getProperty("title_" + curr_locale.getLanguage()).getValue().getString() %></h3>
						<p><%=footer_node.getProperty("content_" + curr_locale.getLanguage()).getValue().getString() %></p>
					</div>
 			<%
					if ((f_display_counter == f_columns) || (!footer_siblings.hasNext())) {
						out.print("<div class='one-third:last-child poweredby'><a href='http://www.livesense.in'><div class='poweredby_logo'></div></a>");
						out.print("</div>");   
					}
					f_display_counter = f_display_counter + 1;
					if (f_display_counter > f_columns) {
						f_display_counter = 1;
					}
            	}
     		}
			%>


		</footer>
			 
	</div><!-- End Resize -->

</body>
  
</html>
