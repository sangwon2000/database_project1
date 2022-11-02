<%@ page import="com.example.project_2019012606.DBManager" %><%--
  Created by IntelliJ IDEA.
  User: jeongsang-won
  Date: 2022/10/27
  Time: 9:52 PM
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
    String class_id = request.getParameter("class_id");
    int amount = Integer.parseInt(request.getParameter("amount"));
    int result = dbManager.increaseCapacity(class_id, amount);

    if(result == -1) {
        out.println("<script>");
        out.println("history.back()");
        out.println("alert('DB error')");
        out.println("</script>");
    }
    else if(result == 0) {
        out.println("<script>");
        out.println("history.back()");
        out.println("alert('증원이 완료되었습니다.')");
        out.println("</script>");
    }

    else if(result == 1) {
        out.println("<script>");
        out.println("history.back()");
        out.println("alert('강의실이 정원을 수용하지 못합니다.')");
        out.println("</script>");
    }

%>
</body>
</html>
