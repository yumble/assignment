<%@ page contentType="text/html;charset=utf-8" 
	import="java.sql.*"
	import="java.util.*,myBean.multipart.*" 
%>

<%
request.setCharacterEncoding("utf-8");

Class.forName("org.mariadb.jdbc.Driver");
String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
String DB_USER = "admin";
String DB_PASSWORD= "1234";

//registerWebtoon 에서 정보 받아오기 
String webtoonTitle = request.getParameter("webtoonTitle");
String webtoonAuthor = request.getParameter("webtoonAuthor");
String webtoonGenreList[];
webtoonGenreList = request.getParameterValues("webtoonGenre");
String webtoonAuthorSay = request.getParameter("webtoonAuthorSay");
String webtoonPlot = request.getParameter("webtoonPlot");
String webtoonImg = request.getParameter("webtoonImg");

//장르 출력
String webtoonGenre ="";
if(webtoonGenreList != null){
	for(int i=0;i<webtoonGenreList.length;i++){
		webtoonGenre += webtoonGenreList[i];
		webtoonGenre += "/";
	}
}

// upload 이름을 가지는 실제 서버의 경로명 알아내기 
ServletContext context = getServletContext();
String realFolder = context.getRealPath("upload");

//multipart/form-data 유형의 클라이언트 요청에 대한 모든 Part 구성요소를 가져옴.
Collection<Part> parts = request.getParts();
MyMultiPart multiPart = new MyMultiPart(parts,realFolder);

String originalFileName="";
String savedFileName="";

if(multiPart.getMyPart("webtoonImg") != null) {  
	originalFileName = multiPart.getOriginalFileName("webtoonImg");
	savedFileName =  multiPart.getSavedFileName("webtoonImg");
}

Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

// 새로 등록할 webtoon insert sql문 작성
String sql = "INSERT INTO webtoonListDB(webtoonTitle, webtoonAuthor, webtoonGenre, webtoonAuthorSay, webtoonPlot, webtoonImg) VALUES(?,?,?,?,?,?)"; 
		
	
PreparedStatement pstmt = con.prepareStatement(sql);

//pstmt의 SQL 쿼리 구성
pstmt.setString(1, webtoonTitle);
pstmt.setString(2, webtoonAuthor);

pstmt.setString(3, webtoonGenre);
pstmt.setString(4, webtoonAuthorSay);
pstmt.setString(5, webtoonPlot);
pstmt.setString(6, savedFileName);
// 쿼리 실행
pstmt.executeUpdate();

//해당 웹툰에 대한 테이블 생성
//테이블 네임은 웹툰제목으로..!!

sql = "CREATE TABLE "+ webtoonTitle + "(" 
	+ "episodeIdx INT(10) not null auto_increment,"
	+ "episodeTitle CHAR(10) CHARACTER SET utf8,"
	+ "episodeDate DATE,"
	+ "episodeAuthorSay CHAR(100),"
	+ "episodeThumbnail CHAR(100),"
	+ "episodeImg CHAR(100),"
	+ "primary key(episodeIdx));";
pstmt = con.prepareStatement(sql);
pstmt.executeUpdate();
pstmt.close();
con.close();

response.sendRedirect("mainHome.jsp");

%>





