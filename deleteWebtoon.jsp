<%@ page contentType="text/html;charset=utf-8"
	import="java.sql.*, java.io.*" import="java.util.*,myBean.multipart.*"%>
<%
request.setCharacterEncoding("utf-8");

try {
	//사용자가 get방식으로 전달한 idx값 알아내기 
	String webtoonTitle = request.getParameter("dbname");

	//JDBC Driver 로드
	Class.forName("org.mariadb.jdbc.Driver");

	String DB_URL = "jdbc:mariadb://localhost:3306/webtoon?useSSL=false";
	String DB_USER = "admin";
	String DB_PASSWORD = "1234";

	//연결자 정보 획득
	Connection con = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

	//웹툰명과 일치하는 쿼리에 삭제할 파일명을 webtoonListDB 테이블에서 알아내기 위한 쿼리 문자열 구성
	String sql = "SELECT webtoonImg FROM webtoonListDB WHERE webtoonTitle=?";

	//PreparedStatement 객체 알아내기.
	PreparedStatement pstmt = con.prepareStatement(sql);

	//PreparedStatement 객체의 쿼리 문자열 중 첫번째인  idx 값 설정하기
	pstmt.setString(1, webtoonTitle);

	//쿼리 실행
	ResultSet rs = pstmt.executeQuery();

	//레코드 커서 이동시키기
	rs.next();
	
	//삭제할 webtoonImg 필드의 값 알아내기
	String filename = rs.getString("webtoonImg");

	//upload 이름을 가지는 실제 서버의 경로명 알아내기
	ServletContext context = getServletContext();
	String realFolder = context.getRealPath("upload");

	//앞에서 알아낸 서버의 경로명과 파일명으로 파일 객체 생성하기
	File file = new File(realFolder + File.separator + filename);

	//파일 삭제
	file.delete();

	//webtoonListDB 테이블에서 지정한 webtoonTitle 레코드를 삭제하기 위한 쿼리 문자열 구성하기
	sql = "DELETE FROM webtoonListDB WHERE webtoonTitle=?";

	//PreparedStatement 객체 알아내기
	pstmt = con.prepareStatement(sql);

	//PreparedStatement 객체의 쿼리 문자열 중 첫번째인  idx 값 설정하기
	pstmt.setString(1, webtoonTitle);

	//쿼리 실행
	pstmt.executeUpdate();
	
	//추가적으로 해당 웹툰의 테이블도 삭제.
	sql = "DROP TABLE " + webtoonTitle;

	
	pstmt = con.prepareStatement(sql);
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

response.sendRedirect("mainHome.jsp");
%>
