<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>


<c:import url="header.jsp">
	<c:param name="title" value="pictureRater Home"></c:param>
</c:import>

<p>Welcome to imageRater.com :)</p>
<p>This is very simple project using some Java , HTML , JSP ,
	Servlets , JSTL , MySQL</p><br/>
	<p>Select a picture and rate it</p>

<sql:setDataSource var="ds" dataSource="jdbc/webapp"></sql:setDataSource>

<sql:query dataSource="${ds}" sql="select * from images limit 10"
	var="results" />

<table class="images">

	<c:set var="tablewidth" value="8" />

	<c:forEach var="image" items="${results.rows}" varStatus="row">

		<c:if test="${row.index % tablewidth == 0}">
			<tr>
		</c:if>

		<c:set scope="page" var="imagename"
			value="${image.stem}${image.image_extension}" />

		<td><a
			href="<c:url value = "/gallery?action=image&image=${image.id}"  />">
				<img width="80"
				src="${pageContext.request.contextPath}/pics/${imagename}" />
		</a></td>

		<c:if test="${row.index + 1 % tablewidth == 0}">
			<tr>
		</c:if>

	</c:forEach>

</table>

<c:import url="footer.jsp"></c:import>
