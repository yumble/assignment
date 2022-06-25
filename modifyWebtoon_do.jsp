<%@ page contentType="text/html; charset=UTF-8" 
		import="java.util.*,myBean.multipart.*"
		import="java.sql.*, java.io.*"
%>
<%
request.setCharacterEncoding("utf-8");

Class.forName("org.mariadb.jdbc.Driver");
String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
String DB_USER = "admin";
String DB_PASSWORD= "1234";

//[문2]. 사용자가 id, name, pwd 파라미터에 전송한 값 알아내기
int idx = Integer.parseInt(request.getParameter("idx"));
String webtoonTitle = request.getParameter("webtoonTitle");
String webtoonAuthor = request.getParameter("webtoonAuthor");
String webtoonGenreList[];
webtoonGenreList = request.getParameterValues("webtoonGenre");
String webtoonAuthorSay = request.getParameter("webtoonAuthorSay");
String webtoonPlot = request.getParameter("webtoonPlot");
String webtoonImg = request.getParameter("webtoonImg");

String webtoonGenre ="";
if(webtoonGenreList != null){
	for(int i=0;i<webtoonGenreList.length;i++){
		webtoonGenre += webtoonGenreList[i];
		webtoonGenre += "/";
	}
}

//[문3]. upload 이름을 가지는 실제 서버의 경로명 알아내기 
ServletContext context = getServletContext();
String realFolder = context.getRealPath("upload");

//[문4]. multipart/form-data 유형의 클라이언트 요청에 대한 모든 Part 구성요소를 가져옴.
Collection<Part> parts = request.getParts();
MyMultiPart multiPart = new MyMultiPart(parts,realFolder);
Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);
PreparedStatement pstmt = null;
ResultSet rs = null;
String sql = null;

sql="SELECT webtoonTitle FROM webtoonListDB WHERE idx=?";
pstmt = con.prepareStatement(sql);
pstmt.setInt(1,idx);
rs = pstmt.executeQuery();
rs.next();
String originalWebtoonTitle = rs.getString("webtoonTitle");
if(!(originalWebtoonTitle.equals(webtoonTitle))){
	sql = "RENAME TABLE " + originalWebtoonTitle + " TO " + webtoonTitle;
	pstmt = con.prepareStatement(sql);
	pstmt.executeUpdate();
}

if(multiPart.getMyPart("webtoonImg") != null) { //사용자가 새로운 파일을 지정한 경우
	//[문2] member 테이블에 저장된 idx 레코드의 파일명을 알아내어, 물리적 파일을 삭제함.
	sql = "SELECT webtoonImg FROM webtoonListDB WHERE idx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setInt(1,idx);
	rs = pstmt.executeQuery();
	rs.next();
	String oldFileName = rs.getString("webtoonImg");
	File oldFile = new File(realFolder + File.separator + oldFileName);
	oldFile.delete();		
	
	//[문3] 새로운 파일명(original file name, UUID 적용 file name)과 데이터로 member 테이블 수정
	sql = "UPDATE webtoonListDB SET webtoonTitle=?, webtoonAuthor=?, webtoonGenre=?, webtoonAuthorSay=?, webtoonPlot=?, webtoonImg=? WHERE idx=?;";
	pstmt=con.prepareStatement(sql);
	pstmt.setString(1,webtoonTitle);
	pstmt.setString(2,webtoonAuthor);
	pstmt.setString(3,webtoonGenre);
	pstmt.setString(4,webtoonAuthorSay);
	pstmt.setString(5,webtoonPlot);
	pstmt.setString(6,multiPart.getSavedFileName("webtoonImg"));
	pstmt.setInt(7,idx);
	
} else { //fileName에 해당되는 Part 객체가 null이라면, 새로운 파일을 선택하지 않을 경우임
	//[문4]. 파일명을 제외한 id, name, pwd 정보 수정
	sql = "UPDATE webtoonListDB SET webtoonTitle=?, webtoonAuthor=?, webtoonGenre=?, webtoonAuthorSay=?, webtoonPlot=? WHERE idx=?;";
	pstmt=con.prepareStatement(sql);
	pstmt.setString(1,webtoonTitle);
	pstmt.setString(2,webtoonAuthor);
	pstmt.setString(3,webtoonGenre);
	pstmt.setString(4,webtoonAuthorSay);
	pstmt.setString(5,webtoonPlot);
	pstmt.setInt(6,idx);
	
}

pstmt.executeUpdate(); // 쿼리 실행

if(pstmt != null) pstmt.close();
if(rs != null) rs.close();
if(con != null) con.close();

request.getSession().setAttribute("dbname", webtoonTitle);
request.getSession().setAttribute("chk", "1");
response.sendRedirect("printEpisode.jsp");
%>