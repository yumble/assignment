<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%
String webtoonTitle = request.getParameter("dbname");
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
window.onload = function(){
	
	document.getElementById('registerDate').value = new Date().toISOString().substring(0, 10);
}


function splitFileName(obj) {
	var splitUrl = obj.value.split("\\"); //   "/" 로 전체 url 을 나눈다
	var urlLength = splitUrl.length;
	var dotFilename = splitUrl[urlLength-1];   // 나누어진 배열의 맨 끝이 파일명이다
	var fileName = dotFilename.split(".");   // 파일명을 다시 "." 로 나누면 파일이름과 확장자로 나뉜다
	fileName = fileName[0];         // 파일이름
	return fileName;
}

function showUserData() {
	var str = "신규 회차를 등록하시겠습니까?\n";
	var objTitle = document.getElementById("titleId");
	str += "회차 제목: " +objTitle.value + "\n";
	
	var objRegisterDate = document.getElementById("registerDate");
	str += "등록 날짜: " +objRegisterDate.value + "\n";
	
	var objAuthorSay = document.getElementById("authorSayId");
	str += "작가의 말: " +objAuthorSay.value + "\n";
	
	var objThumbnail = document.getElementById("thumbnailId");
	var strThumbnail = splitFileName(objThumbnail);
	str += "대표 썸네일: " +strThumbnail + "\n";
	
	var objFilename = document.getElementById("fileId");	
	var strFilename = splitFileName(objFilename);
	str += "웹툰 그림 파일: " +strFilename ;
	
	var result = confirm(str);
	if (result){
		
	}
	else{
		return false;
	}
}
	// 이거는onsubmit결과 후 action url 로 이동 
	//but 현재는  url 지정x >> error 
	//지금 당장은 따라서 showUserData return 값을 false로 만들어준것.
	//과제는 그렇게 하면 안되지 action으로 이동해야하니
	
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
	<form action="addEpisode.jsp" method="post" onsubmit="return showUserData()" enctype="multipart/form-data">
	<section id="main">
		
  		<input type="hidden" name="dbname" value=<%=webtoonTitle%> >
		<table class="registerTable">
			<tr>
				<th class="registerForm" colspan="2"> * 웹툰 회차 추가 *</th>
			</tr>
			<tr>
				<th class="registerForm">회차 제목</th>
				<td><textarea class=registerTextarea cols="50" rows="1" id="titleId"
						name="episodeTitle" placeholder="제목을 입력하세요"></textarea></td>
			</tr>
			<tr>
				<th class="registerForm">등록일</th>
				<td><input type="date" name="episodeDate" id="registerDate"></td>
			</tr>
			<tr>
				<th class="registerForm">작가의 말(소개)</th>
				<td><textarea class=registerTextarea cols="50" rows="3" id="authorSayId"
						name="episodeAuthorSay" placeholder="텍스트를 입력하세요"></textarea></td>
			</tr>
			<tr>
				<th class="registerForm">회차썸네일</th>
				<td>
				<p style="font-size:13px">500x500 png파일로 업로드해주시길 바랍니다</p>
				<input type="file" accept="image/jpg, image/png" id="thumbnailId" name="episodeThumbnail"></td>
			</tr>
			<tr>
				<th class="registerForm">웹툰 그림파일 </th>
				<td>
				<p style="font-size:13px">500x500 png파일로 업로드해주시길 바랍니다</p>
				<input type="file" accept="image/jpg, image/png" id="fileId" name="episodeImg"></td>
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