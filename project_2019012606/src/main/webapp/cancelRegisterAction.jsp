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
        String userId = request.getParameter("userId");
        String classId = request.getParameter("classId");
        dbManager.cancel("register",userId,classId);

        out.println("<script>");
        out.println("alert('수강이 취소되었습니다.')");
        out.println("location.href='studentInfo.jsp?userId="+userId+"\'");
        out.println("</script>");
    %>
</body>
</html>
