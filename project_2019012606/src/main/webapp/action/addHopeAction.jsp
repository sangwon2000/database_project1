<%@ page import="com.example.project_2019012606.DBManager" %><%--
  Created by IntelliJ IDEA.
  User: jeongsang-won
  Date: 2022/10/24
  Time: 8:08 PM
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
    int result = dbManager.add("Hope",user_id,class_id);

    String alert = "";
    switch (result) {
        case -1: alert = "DB error"; break;
        case 0: alert = "희망 신청이 완료되었습니다"; break;
        case 5: alert = "관리자는 사용 불가한 기능입니다."; break;
        case 6: alert = "이미 등록된 수업입니다."; break;
    }

    out.println("<script>");
    out.println("alert('"+alert+"')");
    out.println("location.href='../main.jsp'");
    out.println("</script>");
%>

</body>
</html>
