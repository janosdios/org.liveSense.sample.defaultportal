<%@tag body-content="empty" isELIgnored="false" display-name="Articles"%>

<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>

<%@ attribute name="node" rtexprvalue="true" required="true"
	type="org.liveSense.core.wrapper.JcrNodeWrapper"%>
<%@ attribute name="parentMenu" rtexprvalue="true" required="true"
	type="java.lang.String"%>
<%@ attribute name="jcrType" rtexprvalue="true" required="true"
	type="java.lang.String"%>
<%@ attribute name="isFooter" rtexprvalue="true" required="true"
	type="java.lang.Boolean"%>

<c:set var="display_counter" value="1" />
<c:set var="row_counter" value="1" />
<c:set var="columns" value="3" />

<c:set var="query_article"
	value="SELECT * FROM [${jcrType}] WHERE [parentMenu] = '${parentMenu}' ORDER BY [displayOrder]" />

<c:set var="items_article" value="${node.SQL2Query[query_article]}" />

<c:set var="row_num" value="${items_article.size div 3}" />
<fmt:formatNumber var="row_num" value="${row_num+(1-(row_num%1))%1}"
	maxFractionDigits="0" />


<c:choose>
	<c:when test="${items_article.size == 0}">
		<br />
	</c:when>
	<c:otherwise>
		<c:forEach var="n" items="${items_article}" varStatus="loop">

			<!-- Display first row specific things -->
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

			<!-- Display the current article -->
			<div class="col-md-4">
				<h3>${n.properties['title']}</h3>
				${n.properties['content']}
			</div>

			<!-- Display last row specific things -->
			<c:if test="${(display_counter == columns) || (loop.last)}">

				<c:if test="${(row_counter == row_num) && (isFooter)}">
					<div class="col-md-4"><a href="http://www.livesense.in"><img class="pull-right" src="/defaultportal/img/livesense_logo_v3_poweredby_2.png" alt="poweredby"/></a>
					</div>
				</c:if>

				</div><br /><br />
				<c:set var="row_counter" value="${row_counter+1}" />
			</c:if>
			
			<c:set var="display_counter" value="${display_counter+1}" />

			<c:if test="${display_counter > columns}">
				<c:set var="display_counter" value="1" />
			</c:if>
		</c:forEach>
	</c:otherwise>
</c:choose>


