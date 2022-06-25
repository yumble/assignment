<%@ page contentType="text/html;charset=utf-8" 
	import="java.sql.*"
	import="java.util.*,myBean.multipart.*" 
%>

<%
request.setCharacterEncoding("utf-8");
String webtoonTitle = request.getParameter("dbname");
Class.forName("org.mariadb.jdbc.Driver");
String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
String DB_USER = "admin";
String DB_PASSWORD= "1234";

//registerEpisode에서 정보 받아오기 
String episodeTitle = request.getParameter("episodeTitle");
String episodeDate = request.getParameter("episodeDate");
String episodeAuthorSay = request.getParameter("episodeAuthorSay");
String episodeThumbnail = request.getParameter("episodeThumbnail");
String episodeImg = request.getParameter("episodeImg");

//upload 이름을 가지는 실제 서버의 경로명 알아내기 
ServletContext context = getServletContext();
String realFolder = context.getRealPath("upload");

//multipart/form-data 유형의 클라이언트 요청에 대한 모든 Part 구성요소를 가져옴.
Collection<Part> parts = request.getParts();
MyMultiPart multiPart = new MyMultiPart(parts,realFolder);

String originalEpisodeThumbnail="";
String savedEpisodeThumbnail="";

//클라이언트에서 업로드한 파일이 없으면 null 임
if(multiPart.getMyPart("episodeThumbnail") != null) { 

	originalEpisodeThumbnail = multiPart.getOriginalFileName("episodeThumbnail");
	savedEpisodeThumbnail =  multiPart.getSavedFileName("episodeThumbnail");
}


String originalEpisodeImg="";
String savedEpisodeImg="";

//클라이언트에서 업로드한 파일이 없으면 NULL 임
if(multiPart.getMyPart("episodeImg") != null) { 
	
	originalEpisodeImg = multiPart.getOriginalFileName("episodeImg");
	savedEpisodeImg =  multiPart.getSavedFileName("episodeImg");
}

//DB 연결자 생성
Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
	
// 새로운 에피소드 등록하는 sql
String sql = "INSERT INTO " + webtoonTitle + "(episodeTitle, episodeDate, episodeAuthorSay, episodeThumbnail, episodeImg) VALUES(?,?,?,?,?);"; 
	
PreparedStatement pstmt = con.prepareStatement(sql);

// pstmt의 SQL 쿼리 구성
pstmt.setString(1, episodeTitle);
pstmt.setString(2, episodeDate);
pstmt.setString(3, episodeAuthorSay);
pstmt.setString(4, savedEpisodeThumbnail);
pstmt.setString(5, savedEpisodeImg);

//쿼리 실행
pstmt.executeUpdate();

pstmt.close();
con.close();

// 회차리스트로 돌아가기 - 돌아갈때 해당 웹툰의 title 정보도 같이 보내주기 ( db table 접근 위해)
request.getSession().setAttribute("dbname", webtoonTitle);
request.getSession().setAttribute("chk", "1");
response.sendRedirect("printEpisode.jsp");

%>





