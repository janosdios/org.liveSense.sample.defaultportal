<%@tag body-content="empty" isELIgnored="false" display-name="Navbar"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@ attribute name="node" rtexprvalue="true" required="true"
	type="org.liveSense.core.wrapper.JcrNodeWrapper"%>
<%@ attribute name="jcrType" rtexprvalue="true" required="true"
	type="java.lang.String"%>
<%@ attribute name="portalName" rtexprvalue="true" required="true"
	type="java.lang.String"%>
<%@ attribute name="scrollSpy" rtexprvalue="true" required="true"
	type="java.lang.Boolean"%>


<nav id="header-menu" class="navbar navbar-default navbar-static-top" role="navigation">

	<div class="container">

		<div class="navbar-header">

			<button type="button" class="navbar-toggle" data-toggle="collapse"
				data-target=".navbar-ex1-collapse">
				<span class="sr-only">Toggle navigation</span> <span
					class="icon-bar"></span> <span class="icon-bar"></span> <span
					class="icon-bar"></span>
			</button>

			<a class="navbar-brand" href="#"><img
				src="/defaultportal/img/livesense_logo_v3_defaultportal.png"
				alt="logo" /></a>

		</div>

		<!-- Collect the nav links, forms, and other content for toggling -->
		<div class="collapse navbar-collapse navbar-ex1-collapse"
			id="main-menu">

			<ul class="nav navbar-nav pull-right" id="main-menu-right">

				<c:set var="query_level1"
					value="SELECT * FROM [${jcrType}] WHERE [portalName] = '${portalName}' AND [menuLevel] = '1' ORDER BY [menuOrder]" />
				<c:forEach var="n" items="${node.SQL2Query[query_level1]}">
					<c:set var="link_level1" value="#" />
					<c:if test="${n.properties['islink'].boolean}">
						<c:choose>
							<c:when test="${scrollSpy}">
								<c:set var="link_level1" value="${link_level1}${n.name}" />
							</c:when>
							<c:otherwise>					
								<c:set var="link_level1" value="${n.name}.html" />
							</c:otherwise>
						</c:choose>
					</c:if>

					<c:if test="${n.properties['jstorun'] != ''}">
						<c:set var="link_level1"
							value="javascript: ${n.properties['jstorun']}" />
					</c:if>

					<c:set var="current_li_class_1"
						value="${((n.name == node.name) || (node.properties['menuLevel2Parent'] == n.name)) ? 'active' : ''}" />

					<!-- Selecting menu level 2 -->
					<c:set var="query_level2"
						value="SELECT * FROM [${jcrType}] WHERE [portalName] = '${portalName}' AND [menuLevel2Parent] ='${n.name}' AND [menuLevel] = '2' ORDER BY [menuOrder]" />
					<c:set var="items_level2" value="${node.SQL2Query[query_level2]}" />

					<c:choose>
						<c:when test="${items_level2.size != 0}">

							<li class="dropdown"><a class="dropdown-toggle"
								data-toggle="dropdown" href="#">${n.properties['menuName']}
									<b class="caret"></b>
							</a>
								<ul class="dropdown-menu" id="swatch-menu">

									<c:forEach var="j" items="${items_level2}">
										<c:set var="link_level2" value="#" />
										<c:if test="${j.properties['islink'].boolean}">
											<c:set var="link_level2" value="${j.properties['menuLink']}" />
										</c:if>

										<c:if test="${j.properties['jstorun'] != ''}">
											<c:set var="link_level2"
												value="javascript: ${j.properties['jstorun']}" />
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
								</ul></li>

						</c:when>
						<c:otherwise>

							<c:choose>
								<c:when test="${n.properties['isdivider'].boolean}">
									<li class="divider"></li>
								</c:when>
								<c:otherwise>
									<li class="subnav ${current_li_class_1}"><a
										href="${link_level1}">${n.properties['menuName']}</a></li>
								</c:otherwise>
							</c:choose>

						</c:otherwise>
					</c:choose>

				</c:forEach>

			</ul>

		</div>
	</div>
</nav>
