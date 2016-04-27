<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/sql" prefix="sql"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>
<%@ taglib tagdir="/WEB-INF/tags" prefix="ps"%>


<c:import url="header.jsp">
	<c:param name="title" value="viewImage"></c:param>
</c:import>


<sql:setDataSource var="dbConnection" driver="com.mysql.jdbc.Driver"
     url="jdbc:mysql://$OPENSHIFT_MYSQL_DB_HOST:$OPENSHIFT_MYSQL_DB_PORT/"
     user="adminct6HPJx"  password="VckbsR4P-neT"/>

	<sql:transaction dataSource="jdbc/webapp">

		<sql:query sql="select * from images where id=?" var="results">
			<sql:param>${param.image}</sql:param>
		</sql:query>

	<%-- Get the row for this image--%>
	<c:set scope="page" var="image" value="${results.rows[0]}"></c:set>

	<c:set scope="page" var="average_ranking"
		value="${image.average_ranking}" />

	<%-- If rate button had been clicked , rate the pic --%>
	<c:if test='${param.action == "rate"}'>
		<c:set scope="page" var="newRating"
			value="${(image.average_ranking * image.rankings + param.rating)/(image.rankings + 1)}" />

		<c:set scope="page" var="average_ranking" value="${newRating}" />

		<sql:update sql="update images set average_ranking=? where id=?">
			<sql:param>${newRating}</sql:param>
			<sql:param>${param.image}</sql:param>
		</sql:update>

		<sql:update sql="update images set rankings=? where id=?">
			<sql:param>${image.rankings+1}</sql:param>
			<sql:param>${param.image}</sql:param>
		</sql:update>

	</c:if>

</sql:transaction>

<%-- Turns the first letter into a capital  --%>
<H2>
	<c:out
		value="${fn:toUpperCase(fn:substring(image.stem, 0, 1))}${fn:toLowerCase(fn:substring(image.stem, 1, -1))}" />
</H2>
<span class="rating">Rated: <fmt:formatNumber
		value="${average_ranking}" maxFractionDigits="1" /></span>

<%-- Output the image and the rating --%>
<table style="border: none;">
	<tr>
		<td><ps:image width="200" stem="${image.stem}"
				extension="${image.image_extension}" /></td>
		<td>
			<form action='<c:url value="/gallery" />' method="post">
				<input type="hidden" name="action" value="rate" /> <input
					type="hidden" name="image" value="${image.id}" />

				<table style="padding: 20px; border: none;">
					<tr>
						<td><h3>
							Rate me!
							</h3></td>
					</tr>
					<tr>
						<td align="left"><input type="radio" name="rating" value="5">5
							- Perfect</td>
					</tr>
					<tr>
						<td align="left"><input type="radio" name="rating" value="4">4
							- Nice</td>
					</tr>
					<tr>
						<td align="left"><input type="radio" name="rating" value="3"
							checked="checked">3 - Average</td>
					</tr>
					<tr>
						<td align="left"><input type="radio" name="rating" value="2">2
							- Bad</td>
					</tr>
					<tr>
						<td align="left"><input type="radio" name="rating" value="1">1
							- Don't like it</td>
					</tr>
					<tr>
						<td align="left"><input type="submit" name="submit"
							value="OK"></td>
					</tr>
				</table>
			</form>
		</td>
	</tr>
</table>


<c:import url="footer.jsp"></c:import>



