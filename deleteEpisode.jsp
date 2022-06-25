<%@ page contentType="text/html;charset=utf-8"
	import="java.sql.*, java.io.*" import="java.util.*,myBean.multipart.*"%>
<%
request.setCharacterEncoding("utf-8");
String webtoonTitle = request.getParameter("dbname");
int episodeIdx = Integer.parseInt(request.getParameter("episodeIdx"));

try {
	
	Class.forName("org.mariadb.jdbc.Driver");

	String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD = "1234";

	
	Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

	//episodeIdx에 해당하는 삭제할 파일명을 해당 웹툰 테이블에서 알아내기 위한 쿼리 문자열 구성
	String sql = "SELECT episodeThumbnail, episodeImg FROM " + webtoonTitle + " WHERE episodeIdx=?";

	
	PreparedStatement pstmt = con.prepareStatement(sql);
	pstmt.setInt(1, episodeIdx);
	//쿼리 실행
	ResultSet rs = pstmt.executeQuery();
	//레코드 커서 이동 
	rs.next();
	
	//삭제할 episodeThumbnail 필드의 값 알아내기
	String filename = rs.getString("episodeThumbnail");

	//upload 이름을 가지는 실제 서버의 경로명 알아내기
	ServletContext context = getServletContext();
	String realFolder = context.getRealPath("upload");

	//앞에서 알아낸 서버의 경로명과 파일명으로 파일 객체 생성하기
	File file = new File(realFolder + File.separator + filename);

	//파일 삭제
	file.delete();
	
	//삭제할 episodeImg 필드의 값 알아내기
	filename = rs.getString("episodeImg");
	
	//앞에서 알아낸 서버의 경로명과 파일명으로 파일 객체 생성하기
	File file2 = new File(realFolder + File.separator + filename);

	//파일 삭제
	file2.delete();

	//webtoonTitle 테이블에서 지정한 idx의 레코드를 삭제하기 위한 쿼리 문자열 구성하기
	sql = "DELETE FROM "+webtoonTitle+" WHERE episodeIdx=?";

	//PreparedStatement 객체 알아내기
	pstmt = con.prepareStatement(sql);

	//PreparedStatement 객체의 쿼리 문자열 중 첫번째인  idx 값 설정하기
	pstmt.setInt(1,episodeIdx);

	//쿼리 실행
	pstmt.executeUpdate();

	rs.close();
	pstmt.close();
	con.close();
} catch (SQLException e) {
	//SQL에 대한 오류나, DB 연결 오류 등이 발생하면, 그 대처 방안을 코딩해 준다.
	out.println(e.toString());

} catch (Exception e) {
	//SQLException 이외의 오류에 대한 대처 방안을 코딩해 준다.
	out.println(e.toString());

}

//회차리스트로 돌아가기 - 돌아갈때 해당 웹툰의 title 정보도 같이 보내주기 ( db table 접근 위해 )
request.getSession().setAttribute("dbname", webtoonTitle);
request.getSession().setAttribute("chk", "1");
response.sendRedirect("printEpisode.jsp");
%>