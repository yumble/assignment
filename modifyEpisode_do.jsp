<%@ page contentType="text/html; charset=UTF-8" 
		import="java.util.*,myBean.multipart.*"
		import="java.sql.*, java.io.*"
%>
<%
request.setCharacterEncoding("utf-8");

String webtoonTitle = request.getParameter("dbname");
int episodeIdx = Integer.parseInt(request.getParameter("episodeIdx"));
String episodeTitle = request.getParameter("episodeTitle");
String episodeDate = request.getParameter("episodeDate");
String episodeAuthorSay = request.getParameter("episodeAuthorSay");
String episodeThumbnail = request.getParameter("episodeThumbnail");

ServletContext context = getServletContext();
String realFolder = context.getRealPath("upload");

//[문1]. Part API를 사용하여 클라이언트로부터 multipart/form-data 유형의 전송 받은 파일 저장
Collection<Part> parts = request.getParts();
MyMultiPart multiPart = new MyMultiPart(parts, realFolder);


Class.forName("org.mariadb.jdbc.Driver");
String url = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
Connection con = DriverManager.getConnection(url, "admin", "1234");
PreparedStatement pstmt = null;
ResultSet rs = null;
String sql = null;

if(multiPart.getMyPart("episodeThumbnail") != null) { //사용자가 새로운 파일을 지정한 경우
	//[문2] member 테이블에 저장된 idx 레코드의 파일명을 알아내어, 물리적 파일을 삭제함.
	sql = "SELECT episodeThumbnail FROM "+webtoonTitle+" WHERE episodeIdx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setInt(1,episodeIdx);
	rs = pstmt.executeQuery();
	rs.next();
	String oldFileName = rs.getString("episodeThumbnail");
	File oldFile = new File(realFolder + File.separator + oldFileName);
	oldFile.delete();		
	
	//[문3] 새로운 파일명(original file name, UUID 적용 file name)과 데이터로 member 테이블 수정
	sql = "UPDATE "+webtoonTitle
		+" SET episodeTitle=?, episodeDate=?, episodeAuthorSay=?, episodeThumbnail=? WHERE episodeIdx=?";
	pstmt=con.prepareStatement(sql);
	pstmt.setString(1,episodeTitle);
	pstmt.setString(2,episodeDate);
	pstmt.setString(3,episodeAuthorSay);
	pstmt.setString(4,multiPart.getSavedFileName("episodeThumbnail"));
	pstmt.setInt(5,episodeIdx);
	
} else { //fileName에 해당되는 Part 객체가 null이라면, 새로운 파일을 선택하지 않을 경우임
	//[문4]. 파일명을 제외한 id, name, pwd 정보 수정
	sql = "UPDATE "+webtoonTitle+" SET episodeTitle=?, episodeDate=?, episodeAuthorSay=? WHERE episodeIdx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setString(1,episodeTitle);
	pstmt.setString(2,episodeDate);
	pstmt.setString(3,episodeAuthorSay);
	pstmt.setInt(4,episodeIdx);
	
}

pstmt.executeUpdate(); // 쿼리 실행

if(multiPart.getMyPart("episodeImg") != null) { //사용자가 새로운 파일을 지정한 경우
	//[문2] member 테이블에 저장된 idx 레코드의 파일명을 알아내어, 물리적 파일을 삭제함.
	sql = "SELECT episodeImg FROM "+webtoonTitle+" WHERE episodeIdx=?";
	pstmt = con.prepareStatement(sql);
	pstmt.setInt(1,episodeIdx);
	rs = pstmt.executeQuery();
	rs.next();
	String oldFileName = rs.getString("episodeImg");
	File oldFile = new File(realFolder + File.separator + oldFileName);
	oldFile.delete();		
	
	//[문3] 새로운 파일명(original file name, UUID 적용 file name)과 데이터로 member 테이블 수정
	sql = "UPDATE "+webtoonTitle
		+" SET episodeImg=? WHERE episodeIdx=?";
	pstmt=con.prepareStatement(sql);
	pstmt.setString(1,multiPart.getSavedFileName("episodeImg"));
	pstmt.setInt(2,episodeIdx);
	
} else { 
	
}
pstmt.executeUpdate(); // 쿼리 실행

if(pstmt != null) pstmt.close();
if(rs != null) rs.close();
if(con != null) con.close();

request.getSession().setAttribute("dbname", webtoonTitle);
request.getSession().setAttribute("chk", "1");
response.sendRedirect("printEpisode.jsp");
%>