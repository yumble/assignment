<%@ page contentType="text/html;charset=utf-8"
		import="java.sql.*" import="java.util.*" %>
<%-- [문1] error.jsp 파일 생성 --%>
<%
request.setCharacterEncoding("utf-8");

String webtoonTitle = request.getParameter("dbname");

Class.forName("org.mariadb.jdbc.Driver");
String url = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";

Connection con = DriverManager.getConnection(url, "admin", "1234");

//[문2] member테이블에서 idx에 해당하는 레코드 검색하기 위한 SQL문 구성 
String sql = "SELECT * FROM webtoonListDB WHERE webtoonTitle=?;";
PreparedStatement pstmt = con.prepareStatement(sql);
pstmt.setString(1,webtoonTitle);

//[문3] 쿼리 실행
ResultSet rs = pstmt.executeQuery();

//[문4] 레코드 오프셋 커서 이동
rs.next();

String tmp = rs.getString("webtoonGenre");
String check[] = tmp.split("/");
String genreEng[] ={"daily","comic","fantasy","action","drama","thrill","history","sport"};
String genre[] = {"일상", "개그", "판타지", "액션", "드라마", "스릴러", "무협/사극", "스포츠"};
String result[] = {"0", "0", "0", "0", "0", "0", "0", "0"};
for(int i = 0 ; i<check.length;i++){
	for(int j = 0; j<genre.length;j++){
		if( check[i].equals(genre[j])){
			result[i] = "1";
		}
	}
}
String authorsay = rs.getString("webtoonAuthorSay");

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
.registerTable{
	margin:50px;
} /* section 테이블 여백*/
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
<script>
/*
 * 빈칸일시 입력하라는 alert 출력 필요 focus 이용
 * 웹툰 회차 화면...구성.....
 */
function splitFileName(obj) {
	var splitUrl = obj.value.split("\\"); //   "/" 로 전체 url 을 나눈다
	var urlLength = splitUrl.length;
	var dotFilename = splitUrl[urlLength-1];   // 나누어진 배열의 맨 끝이 파일명이다
	var fileName = dotFilename.split(".");   // 파일명을 다시 "." 로 나누면 파일이름과 확장자로 나뉜다
	fileName = fileName[0];         // 파일이름
	return fileName;
}

function showUserData() {
	var objTitle = document.getElementById("titleId");
	
	var objAuthor = document.getElementById("authorId");
	var objGenreInput = document.getElementsByName("webtoonGenre");
	
	var tmp="";
	for(var idx in objGenreInput) {
		if(objGenreInput[idx].checked)
			tmp += objGenreInput[idx].value + " ";
	}
	
	var objAuthorSay = document.getElementById("authorSayId");
	var objPlot = document.getElementById("plotId");
	var objImage = document.getElementById("fileId");
	var str = "신규 웹툰을 등록하시겠습니까?\n";
	str += "만화타이틀: " + objTitle.value + "\n";
	str += "작가명: " +objAuthor.value + "\n";
	str += "장르: " + tmp +"\n";
	str += "작가의 말(소개): " + objAuthorSay.value + "\n";
	str += "줄거리: " + objPlot.value + "\n";
	
	var splitUrl = objImage.value.split("\\"); //   "/" 로 전체 url 을 나눈다
	var urlLength = splitUrl.length;
	var dotFilename = splitUrl[urlLength-1];   // 나누어진 배열의 맨 끝이 파일명이다
	var fileName = dotFilename.split(".");   // 파일명을 다시 "." 로 나누면 파일이름과 확장자로 나뉜다
	fileName = fileName[0];         // 파일이름
	
	str += "그림 파일 이름: " + fileName;
	
	var result = confirm(str);
	if (result){
		
	}
	else{
		return false;
	}
	// 이거는onsubmit결과 후 action url 로 이동 
	//but 현재는  url 지정x >> error 
	//지금 당장은 따라서 showUserData return 값을 false로 만들어준것.
	//과제는 그렇게 하면 안되지 action으로 이동해야하니
	
	
}
function resetFunc() {
	var str = "취소하시겠습니까?";
	if(confirm(str)){
		
	}
	else{
		return false;
	}
}

 
 
 
 
</script>
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
	<form action="modifyWebtoon_do.jsp" method="post" onsubmit="return showUserData()" enctype="multipart/form-data">
	<section id="main">
		<input type="hidden" name="idx" value=<%=rs.getInt("idx")%> >
		<input type="hidden" name="dbname" value=<%=rs.getString("webtoonTitle")%> >
		<table class="registerTable">
			<tr>
				<th class="registerForm" colspan="2"> * 신규 웹툰 수정 *</th>
			</tr>
			<tr>
				<th class="registerForm">만화타이틀</th>
				<td><input type="text" class=registerTextarea id="titleId"
						name="webtoonTitle" value=<%=rs.getString("webtoonTitle")%>></td>
			</tr>
			<tr>
				<th class="registerForm">작가명</th>
				<td><input type="text" class=registerTextarea id="authorId"
						name="webtoonAuthor" value=<%=rs.getString("webtoonAuthor")%>></td>
			</tr>
			<tr>
				<th class="registerForm">장르</th>
				<td>
					<% for(int i=0; i<8;i++) { %>
						<span class="genreSpan"> <input type="checkbox" id=<%=genreEng[i]%>
							name="webtoonGenre"value=<%=genre[i]%>
							<% if(result[i]=="1"){ %>checked<%}
							else{} %>> <label for="<%=genreEng[i]%>"
							class="genreLabel"><%=genre[i]%></label>
						</span> 
						<% } %>
					
				</td>
			</tr>
			<tr>
				<th class="registerForm">작가의 말(소개)</th>
				<td><input type="text" class=registerTextarea id="authorSayId"
						name="webtoonAuthorSay" value=<%=authorsay%> size=50></td>
			</tr>
			<tr>
				<th class="registerForm">줄거리</th>
				<td><input type="text" class=registerTextarea id="plotId"
						name="webtoonPlot" value=<%=rs.getString("webtoonPlot")%>></td>
			</tr>
			<tr>
				<th class="registerForm">대표이미지</th>
				<td>
				<p style="font-size:13px">500x500 png파일로 업로드해주시길 바랍니다</p>
				<p style="font-size:13px">현재 그림 : </p>
				<img src="./upload/<%=rs.getString("webtoonImg")%>" width="100" height="100"> <br><br>
				<input type="file" accept="image/jpg, image/png" id="fileId" name="webtoonImg" value=<%=rs.getString("webtoonImg")%>></td>
			</tr>
			<tr>
				<td colspan="2" align="right">
					<input type="reset" value="취소" onclick="return resetFunc()">
					<input type="submit" value="전송" style="margin-right:20px">
				</td>
			</tr>
			
		</table>
	</section>
	</form>
</body>
</html>

<%
rs.close();
pstmt.close();
con.close();
%>