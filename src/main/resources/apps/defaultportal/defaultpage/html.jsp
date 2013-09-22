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
<sling:defineObjects />

<%
	// Get Node wrapper
	LanguageSelectorService languageSelectorService = sling.getService(LanguageSelectorService.class);
	Locale locale =  languageSelectorService.getLocaleByRequest(request);
	JcrNodeWrapper node = new JcrNodeWrapper(currentNode, locale, true);

	pageContext.setAttribute("markdown", new MarkdownWrapper(sling.getService(MarkdownService.class)));
	pageContext.setAttribute("node", node);
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

<body class="preview" id="top" data-spy="scroll" data-target=".subnav" data-offset="80">

	<!-- Navbar Begin -->

	<nav class="navbar navbar-default navbar-static-top" role="navigation">

		<div class="container">

    		<div class="navbar-header">

				<button type="button" class="navbar-toggle" data-toggle="collapse" data-target=".navbar-ex1-collapse">
      				<span class="sr-only">Toggle navigation</span>
      				<span class="icon-bar"></span>
      				<span class="icon-bar"></span>
      				<span class="icon-bar"></span>
    			</button>

      			<a class="navbar-brand" href="#"><img src="/defaultportal/img/livesense_logo_v3_defaultportal.png" alt="logo"/></a>

 	 		</div>

			<!-- Collect the nav links, forms, and other content for toggling -->
	  		<div class="collapse navbar-collapse navbar-ex1-collapse" id="main-menu">

    			<ul class="nav navbar-nav pull-right" id="main-menu-right">
			
					<c:set var="query_level1" value="SELECT * FROM [defaultportal:defaultpage] WHERE [portalName] = 'defaultportal' AND [menuLevel] = '1' ORDER BY [menuOrder]"/>
					<c:forEach var="n" items="${node.SQL2Query[query_level1]}">
						<c:set var="link_level1" value = "#" />
						<c:if test="${n.properties['islink'].boolean}">
							<c:set var="link_level1" value = "${n.name}.html" />
						</c:if>
					
						<c:if test="${n.properties['jstorun'] != ''}">
							<c:set var="link_level1" value = "javascript: ${n.properties['jstorun']}" />
						</c:if>

						<c:set var="current_li_class_1" value = "${((n.name == node.name) || (node.properties['menuLevel2Parent'] == n.name)) ? 'active' : ''}" />

						<!-- Selecting menu level 2 -->
						<c:set var="query_level2" value="SELECT * FROM [defaultportal:defaultpage] WHERE [portalName] = 'defaultportal' AND [menuLevel2Parent] ='${n.name}' AND [menuLevel] = '2' ORDER BY [menuOrder]"/>
						<c:set var="items_level2" value = "${node.SQL2Query[query_level2]}" />

						<c:choose>
							<c:when test="${items_level2.size != 0}">

          						<li class="dropdown">
            						<a class="dropdown-toggle" data-toggle="dropdown" href="#">${n.properties['menuName']} <b class="caret"></b></a>
            						<ul class="dropdown-menu" id="swatch-menu">

										<c:forEach var="j" items="${items_level2}">
											<c:set var="link_level2" value = "#" />
											<c:if test="${j.properties['islink'].boolean}">
												<c:set var="link_level2" value = "${j.properties['menuLink']}" />
											</c:if>

											<c:if test="${j.properties['jstorun'] != ''}">
												<c:set var="link_level2" value = "javascript: ${j.properties['jstorun']}" />
											</c:if>
									
											<c:choose>
												<c:when test="${j.properties['isdivider'].boolean}">
													<li class="divider"></li>
												</c:when>
												<c:otherwise>
													<li><a href="${link_level2}">${j.properties['menuName']}</a></li>									
												</c:otherwise>
											</c:choose>
										</c:forEach>
									</ul>
          						</li>

							</c:when>
							<c:otherwise>
								
								<c:choose>
									<c:when test="${n.properties['isdivider'].boolean}">
										<li class="divider"></li>
									</c:when>
									<c:otherwise>
										<li class="subnav ${current_li_class_1}">
											<a href="${link_level1}">${n.properties['menuName']}</a>
										</li>
									</c:otherwise>
								</c:choose>
									
							</c:otherwise>
						</c:choose>

					</c:forEach>

				</ul>
						
			</div>
		</div>
	</nav>

	<!-- Navbar End -->
		
	<section id="main_content">

		<div class="container">

			<!-- Content Header -->

			<div class="row">

				<div class="col-md-12">
  			
  					<div class="page-header">
						<h1>${node.properties['title']}</h1>
						<p>${node.properties['content']}</p>	
					</div>

				</div>

			</div>

			<!-- Content Details -->

			<div class="row">

				<div class="col-md-12">


					<!-- Articles -->

					<c:set var="display_counter" value = "1"/>
					<c:set var="row_counter" value = "1"/>
					<c:set var="columns" value = "3"/>
			
					<c:set var="query_article" value="SELECT * FROM [defaultportal:article] WHERE [parentMenu] = '${node.name}' ORDER BY [displayOrder]"/>
					<c:set var="items_article" value = "${node.SQL2Query[query_article]}" />

					<c:set var="row_num" value = "${items_article.size div 3}"/>
					<fmt:formatNumber var="row_num" value = "${row_num+(1-(row_num%1))%1}" maxFractionDigits="0"/>

  					<c:choose>
						<c:when test="${items_article.size == 0}">
							<br/>
						</c:when>
						<c:otherwise>
  							<c:forEach var="n" items="${items_article}" varStatus="loop">

								<c:if test="${display_counter == 1}">
									<c:choose>
										<c:when test="${row_counter == row_num}">
											<div class="row">
										</c:when>
										<c:otherwise>
											<div class="row endrow">
										</c:otherwise>
									</c:choose>
								</c:if>

								<div class="col-md-4">
		        					<h3>${n.properties['title']}</h3>
									${n.properties['content']}
								</div>

								<c:if test="${(display_counter == columns) || (loop.last)}">
									</div>
									<c:set var="row_counter" value = "${row_counter+1}"/>
								</c:if>

								<c:if test="${display_counter == columns}">
									<br/><br/>
								</c:if>
								<c:set var="display_counter" value = "${display_counter+1}"/>

								<c:if test="${display_counter > columns}">
									<c:set var="display_counter" value = "1"/>
								</c:if>
							</c:forEach>
  						</c:otherwise>
  					</c:choose>

					<!-- End Articles -->

				</div>

			</div>

		</div>
		
	</section>

		
	<!-- Footer -->		
		
	<footer id="footer">

		<div class="container">

        	<div class="row">

            	<div class="col-md-12">

					<!-- Footer Content -->

					<c:set var="display_counter" value = "1"/>
					<c:set var="columns" value = "3"/>
					<c:set var="query_footer" value="SELECT * FROM [defaultportal:footer] WHERE [portalName] = 'defaultportal' ORDER BY [displayOrder]"/>
					<c:set var="items_footer" value = "${node.SQL2Query[query_footer]}" />
  					<c:choose>
						<c:when test="${items_footer.size == 0}">
							<br/>
						</c:when>
						<c:otherwise>
  							<c:forEach var="n" items="${items_footer}" varStatus="loop">

								<c:if test="${display_counter == 1}">
									<div class="row">
								</c:if>

								<div class="col-md-4">
		        					<h3>${n.properties['title']}</h3>
									<p>${n.properties['content']}</p>
								</div>

								<c:if test="${(display_counter == columns) || (loop.last)}">
									<div class="col-md-4"><a href="http://www.livesense.in"><img class="pull-right" src="/defaultportal/img/livesense_logo_v3_poweredby_2.png" alt="poweredby"/></a>
									</div>
								</c:if>

								<c:set var="display_counter" value = "${display_counter+1}"/>

								<c:if test="${display_counter > columns}">
									<c:set var="display_counter" value = "1"/>
								</c:if>
							</c:forEach>
  						</c:otherwise>
  					</c:choose>

					<!-- End Footer Content -->

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
</body>
  
</html>
