<%@ page import="com.example.project_2019012606.DBManager" %><%--
  Created by IntelliJ IDEA.
  User: jeongsang-won
  Date: 2022/10/24
  Time: 7:24 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>

    <%
        DBManager dbManager = new DBManager();
        String user_id = request.getParameter("user_id");
        String class_id = request.getParameter("class_id");
        int result = dbManager.cancel("register",user_id,class_id);

        if(result == -1) {
            out.println("<script>");
            out.println("history.back()");
            out.println("alert('DB error')");
            out.println("</script>");
        }

        else if(result == 0) {
            out.println("<script>");
            out.println("alert('수업 신청을 취소하였습니다.')");
            out.println("location.href='../studentInfo.jsp?student_id="+user_id+"\'");
            out.println("</script>");
        }
    %>

</body>
</html>
