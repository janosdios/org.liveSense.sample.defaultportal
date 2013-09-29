<%@tag body-content="empty" isELIgnored="false" display-name="Section"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@taglib tagdir="/WEB-INF/tags/apps/defaultportal/components/tags" prefix="custom" %>

<%@ attribute name="node" rtexprvalue="true" required="true"
	type="org.liveSense.core.wrapper.JcrNodeWrapper"%>
<%@ attribute name="needId" rtexprvalue="true" required="true"
	type="java.lang.Boolean"%>

<c:choose>
	<c:when test="${needId}">
		<c:set var="sectionId" value="${node.name}" />
	</c:when>
	<c:otherwise>
		<c:set var="sectionId" value="index" />
	</c:otherwise>
</c:choose>


<section id="${sectionId}">

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

				<custom:articles node="${node}" parentMenu="${node.name}"
					jcrType="defaultportal:article" isFooter="false" />

			</div>

		</div>

	</div>

</section>
