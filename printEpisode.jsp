<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.sql.*"%>
<%
 request.setCharacterEncoding("utf-8");
 String chk =(String)request.getSession().getAttribute("chk");
 String webtoonTitle;
 if(chk=="1"){
	 webtoonTitle = (String)request.getSession().getAttribute("dbname");
	 request.getSession().setAttribute("chk","0");
 }
 else{
	 webtoonTitle = request.getParameter("dbname");
 }
 
 Class.forName("org.mariadb.jdbc.Driver");
 String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
 String DB_USER = "admin";
 String DB_PASSWORD= "1234";
 

Connection con=null;
PreparedStatement pstmt = null;
ResultSet rs=null;
try {
	//[문1]. DB 연결자 정보를 획득한다.
	con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	
	
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8" name="viewport"
	content="width=device-width, initial-scale=1.0">
<title>Jun's Webtoon management</title>
<link rel="stylesheet" type="text/css" href="./resources/headerProperties.css">
<script>
function deleteFunc() {
	var str = "삭제하시겠습니까?";
	if(confirm(str)){
		
	}
	else{
		return false;
	}
}
</script>
<style>
/*section 구역 */

.registerTable{
	margin:50px;
} /* section 테이블 여백*/
.genreSpan{
	display:inline-block;
	height:30px;
	width:110px;
} /*genre체크하는 공*/
.genreLabel{
	padding:10px;
	color:#e6e6e6;
	font-size:15px;
	font-weight:bold;
} /* 장르 checkbox 글씨 */
.registerForm{
	padding:10px;
	text-align:left;
	width:150px;
	font-size:20px;
	vertical-align:top;
	color:white;
} /*table의 th의 관한 속성 */

.registerTextarea{
	background-color:#e6e6e6;
	padding: 8px;
	resize: none;
	border: 1px solid groove #808080"
} /*txt를 입력하는 글 상자 */
.registerTextarea::placeholder {
  color: #808080;
  font-weight: bold;
} /*txt를 입력하는 글 상자 */
.episodeAddButton {
	border: 1px solid gray;
	height: 40px;
	background-color: #262626;
	color:white;
	
}
.episodeAddButton:hover {
	background-color: red;
	color: white;
}
.theButton {
	position: relative;
	border: 1px solid gray;
	width:50px;
	height: 40px;
	background-color: #262626;
	color: #808080;
	margin:auto;
	
}
.theButton:hover {
	background-color: red;
	color: white;
}
#episodeListTable{
	position:absolute;
	left:200px;
	right:500px;
	text-align:center;
	font-size:18px;
	color:white;
	width:60%;
}

.episodeListTableRow:nth-child(2n+1) {
	background-color:#505050;
}
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
			
			
			<input id="searchInput" type="text" name=searchName placeholder="제목/작가로 검색할 수 있습니다.">
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
			<li class="active"><a href="./registerWebtoon.jsp">신규 웹툰 등록</a></li>
		</ul>
	</nav>
	<section id="main">
	<%
	//[문2]. member 테이블에서 모든 필드의 레코드를 가져오는 퀴리 문자열을 구성한다. 
		String sql = "SELECT * FROM webtoonListDB WHERE webtoonTitle=?";
		
		//[문3]. sql문을 실행하기 위한 PreparedStatement 객체를 생성한다.
		pstmt = con.prepareStatement(sql);
		
		pstmt.setString(1,webtoonTitle);

		//[문4]. 쿼리 실행
		rs = pstmt.executeQuery();
		rs.next();
	%>
		<table id="episodeListTable">
			<tr style="position:relative">
			<td style="text-align:left;width:220px;"> <img src="./upload/<%=rs.getString("webtoonImg")%>" width="200" height="200"></td>
				<td style="width:160px;font-size:12pt;text-align:right;vertical-align:bottom"> 웹툰 제목 : <br> 웹툰 작가 : <br> 웹툰 장르 : <br> 한 줄 소개 : <br> 줄거리 : 
				</td>
				<td style="width:310px;text-align:left;font-size:12pt;vertical-align:bottom;padding-left:10px;">
					<%=rs.getString("webtoonTitle")%> <br> <%=rs.getString("webtoonAuthor")%>  <br> 
					<%
							String str = rs.getString("webtoonGenre"); 
							String[] lst = str.split("/");
							
							for(int i = 0 ; i<lst.length;i++){
								%><%=lst[i]%> <%
						
							} 
							%>
							<br> <%=rs.getString("webtoonAuthorSay")%> <br> <%=rs.getString("webtoonPlot")%>
				</td>
				<td>
				<form method="POST" action="modifyWebtoon.jsp" enctype="multipart/form-data">
				<input type="submit" value="수정" class="theButton">
				<input type="hidden" name="dbname" value=<%=rs.getString("webtoonTitle")%> >
				</form>
				</td>
				<td>
				<form method="POST" action="deleteWebtoon.jsp" enctype="multipart/form-data">
				<input type="submit" value="삭제" class="theButton" onclick="return deleteFunc()">
				<input type="hidden" name="dbname" value=<%=rs.getString("webtoonTitle")%> >
				
				</form>
				</td>
			</tr>
			
		</table>
	
		<%
		//[문2]. member 테이블에서 모든 필드의 레코드를 가져오는 퀴리 문자열을 구성한다. 
		sql = "SELECT * FROM " + webtoonTitle +";";
		
		//[문3]. sql문을 실행하기 위한 PreparedStatement 객체를 생성한다.
		pstmt = con.prepareStatement(sql);

		//[문4]. 쿼리 실행
		rs = pstmt.executeQuery();
		%>
		<table id="episodeListTable" style="top:350px;">
			
			<tr class="episodeListTableRow">
				<th style="width:90px">썸네일</th>
				<th>회차제목</th>
				<th>회차번호</th>
				<th>등록일</th>
				<th>수정</th>
				<th>삭제</th>
			</tr>
			<%
					while(rs.next()) {
			%>
			<tr class="episodeListTableRow">
				<td>
					<img width=80px height=80px src="./upload/<%=rs.getString("episodeThumbnail")%>" style="padding:10px">   
				</td>
				<td> <%=rs.getString("episodeTitle")%> </td>
				<td> <%=rs.getInt("episodeIdx")%> </td>
				<td> <%=rs.getString("episodeDate")%></td>
				<td>
					<form action='modifyEpisode.jsp?episodeIdx=<%=rs.getInt("episodeIdx")%>' method="post" enctype="multipart/form-data">
					<input type="submit"  class="theButton" value="수정">
					<input type="hidden" name="dbname" value=<%=webtoonTitle%> >
					</form>
				</td>
				<td>
					<form method="POST" action="deleteEpisode.jsp?episodeIdx=<%=rs.getInt("episodeIdx")%>" enctype="multipart/form-data">
				<input type="submit" value="삭제" class="theButton" onclick="return deleteFunc()">
				<input type="hidden" name="dbname" value=<%=webtoonTitle%> >
				
				</form>
			</tr>
			<% } %>
			<tr>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td></td>
			<td>
			<form action='registerEpisode.jsp' method="post" enctype="multipart/form-data">
				<input type="submit" class="episodeAddButton" value="회차 추가">
				<input type="hidden" name="dbname" value=<%=webtoonTitle%> >
				</form>
			
			</td>
			</tr>
		</table>
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