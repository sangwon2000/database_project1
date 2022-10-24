<%@ page import="com.example.project_2019012606.DBManager" %><%--
  Created by IntelliJ IDEA.
  User: jeongsang-won
  Date: 2022/10/24
  Time: 6:46 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:useBean id="condition" class="com.example.project_2019012606.Condition" scope="page" />
<jsp:setProperty name="condition" property="condition" />
<jsp:setProperty name="condition" property="value" />

<html>
<head>
    <title>Title</title>
</head>
<body>

    <%
        DBManager dbManager = new DBManager();
        String userId = request.getParameter("userId");
        dbManager.updateStudentInfo(userId,condition);

        out.println("<script>");
        out.println("alert('변경이 완료되었습니다.')");
        out.println("location.href='studentInfo.jsp?userId="+userId+"\'");
        out.println("</script>");
    %>

</body>
</html>
