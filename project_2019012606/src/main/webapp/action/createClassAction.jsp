<%@ page import="com.example.project_2019012606.DBManager" %><%--
  Created by IntelliJ IDEA.
  User: jeongsang-won
  Date: 2022/10/26
  Time: 12:00 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:useBean id="classInfo" class="com.example.project_2019012606.ClassInfo" scope="page" />
<jsp:setProperty name="classInfo" property="course_id" />
<jsp:setProperty name="classInfo" property="lecturer_id" />
<jsp:setProperty name="classInfo" property="room_id" />
<jsp:setProperty name="classInfo" property="capacity" />
<jsp:setProperty name="classInfo" property="day" />
<jsp:setProperty name="classInfo" property="begin" />
<jsp:setProperty name="classInfo" property="end" />

<html>
<head>
    <title>Title</title>
    <%
        DBManager dbManager = new DBManager();
        int result = dbManager.createClass(classInfo);

        if(result == -1) {
            out.println("<script>");
            out.println("history.back()");
            out.println("alert('DB error')");
            out.println("</script>");
        }
        else if(result == 0) {
            out.println("<script>");
            out.println("history.back()");
            out.println("alert('설강이 완료되었습니다.')");
            out.println("</script>");
        }

        else if(result == 1) {
            out.println("<script>");
            out.println("history.back()");
            out.println("alert('강의 시작 시간이 종료 시간보다 늦습니다.')");
            out.println("</script>");
        }

        else if(result == 2) {
            out.println("<script>");
            out.println("history.back()");
            out.println("alert('수업 정원을 강의실이 수용하지 못합니다.')");
            out.println("</script>");
        }

    %>
</head>
<body>

</body>
</html>
