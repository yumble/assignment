<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*"%>
<%
 request.setCharacterEncoding("utf-8");
 
 Class.forName("org.mariadb.jdbc.Driver");
 String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
 String DB_USER = "admin";
 String DB_PASSWORD= "1234";
 

Connection con=null;
PreparedStatement pstmt = null;
ResultSet rs=null;
try {

	con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	
	//webtoonListDB 테이블에서 모든 필드의 레코드를 가져오는 퀴리 문자열을 구성한다. 
	String sql = "SELECT * FROM webtoonListDB;";
	
	//sql문을 실행하기 위한 PreparedStatement 객체를 생성한다.
	pstmt = con.prepareStatement(sql);

	// 쿼리 실행
	rs = pstmt.executeQuery();
%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" name="viewport"
	content="width=device-width, initial-scale=1.0">
<title>Jun's Webtoon management</title>
<link rel="stylesheet" type="text/css" href="./resources/headerProperties.css">
<style>
/*section 구역 */
.titleSpan {
	color:white;
}
.authorSpan {
	float: right;
	color:white;
} /* 작가명 오른쪽 정*/

ul.webtoonUl {
	list-style-type: none;
	list-style: none;
} /*main webtoon 화면 속성 */

li.webtoonLi {
	float: left;
	margin-right: 20px;
} /*main webtoon 화면 속성 */

div.webtoonDiv {
	display: inline;
	float: left;
	width: 220px;
	height: 270px;
	cursor: pointer;
} /*main webtoon 화면 속성 */

img.mainImg {
	width: 220px;
	height: 220px;
} /*main webtoon 화면 속성 */
select.searchBar {
	display:inline;
	background-color: #262626;
	color: #ffffff;
	width: 55px;
	height: 100%;
	border-left: 1px solid gray;
	outline: none;
	text-align:left;

}
</style>

</head>
<body>
	<header style="height:50px">
		<div>
			<img id="home" width="50" height="50" src="images/homeImg.png"
				alt="HOME" usemap="#home">
			<map name="home">
				<area shape="rect" coords="0, 0, 50, 50" href="./mainHome.jsp">
			</map>
		</div>
		<div id="searchDiv">
		
			<form action='search.jsp' method="post" enctype="multipart/form-data">
			
			
			<input id="searchInput" name="searchName" type="text" placeholder="제목/작가로 검색할 수 있습니다.">
			<input type="image" id="searchButton" onclick="search.jsp" src="images/searchIcon.png" style="width:40px;height80px">
			<div>
			<select name="select" class="searchBar" >
				<option value="웹툰명" selected>웹툰명</option>
				<option value="작가명">작가명</option> 
			</select>
			</div>
			</form>
		</div>

		<h1>Webtoon Homepage</h1>

	</header>
	<nav>
		<h1>Menu</h1>
		<ul class="menu">
			<li><a href="./registerWebtoon.jsp">신규 웹툰 등록</a></li>
		</ul>
	</nav>
	<section id="main">
		<article>
			<ul class="webtoonUl">
				<%
					while(rs.next()) {
				%>
				
				<li class="webtoonLi">
					<form action='printEpisode.jsp?webtoonTitle=<%=rs.getString("webtoonTitle")%>' method="post" enctype="multipart/form-data">
					
						<input type="image" class="mainImg" src="./upload/<%=rs.getString("webtoonImg")%>" width="200" height="200"> <br> 
							<span class="titleSpan">웹툰명 : <%=rs.getString("webtoonTitle")%></span> <br>
							<%
							String str = rs.getString("webtoonGenre"); 
							String[] lst = str.split("/");
							%>
							<span class="titleSpan">장르 : <%
							for(int i = 0 ; i<lst.length;i++){
								%><%=lst[i]%> <%
						
							} 
							%>
							</span> <br>
							<span class="authorSpan">작가명 : <%=rs.getString("webtoonAuthor") %></span> <br>
						<input type="hidden" name="dbname" value=<%=rs.getString("webtoonTitle")%> >
					</form>
				</li>
				
				<%
					}
				%>
			</ul>
		</article>
	</section>
</body>

<%
	rs.close();
	pstmt.close();
	con.close();
}catch(SQLException e){
	out.println(e);
}
%>
</html>




















