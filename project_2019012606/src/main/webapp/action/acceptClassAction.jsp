<%@ page import="com.example.project_2019012606.DBManager" %><%--
  Created by IntelliJ IDEA.
  User: jeongsang-won
  Date: 2022/10/27
  Time: 10:28 PM
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
    String student_id = request.getParameter("student_id");

    int result = dbManager.acceptClass(class_id, student_id);

    if(result == -1) {
        out.println("<script>");
        out.println("history.back()");
        out.println("alert('DB error')");
        out.println("</script>");
    }

    else if(result == 0) {
        out.println("<script>");
        out.println("history.back()");
        out.println("alert('수강허용이 완료되었습니다.')");
        out.println("</script>");
    }

    else if(result == 1) {
        out.println("<script>");
        out.println("history.back()");
        out.println("alert('위 학생은 해당 수업을 등록할 수 없습니다.')");
        out.println("</script>");
    }

    else if(result == 2) {
        out.println("<script>");
        out.println("history.back()");
        out.println("alert('강의실 수용 인원 문제로 수업 정원을 증원할 수 없습니다.')");
        out.println("</script>");
    }

%>
</body>
</html>
