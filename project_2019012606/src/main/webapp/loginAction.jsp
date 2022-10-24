<%@ page import="com.example.project_2019012606.DBManager" %>
<%@ page import="java.sql.*" %><%--
  Created by IntelliJ IDEA.
  User: jeongsang-won
  Date: 2022/10/22
  Time: 9:25 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<jsp:useBean id="user" class="com.example.project_2019012606.User" scope="page" />
<jsp:setProperty name="user" property="userId" />
<jsp:setProperty name="user" property="userPassword" />

<html>
<head>
    <title>Title</title>
</head>
<body>

<%
    if(session.getAttribute("userId") != null) {
        out.println("<script>");
        out.println("location.href = 'main.jsp'");
        out.println("</script>");
    }


    if(user.getUserId() == null || user.getUserPassword() == null) {
        out.println("<script>");
        out.println("alert('아이디와 비밀번호를 입력해주세요.')");
        out.println("location.href = 'login.jsp'");
        out.println("</script>");
    }
    else {
        DBManager dbManager = new DBManager();
        int key = dbManager.login(user);

        if(key == 1) {
            session.setAttribute("userId", user.getUserId());
            out.println("<script>");
            out.println("location.href = 'main.jsp'");
            out.println("</script>");
        }

        else if(key == 2) {
            session.setAttribute("userId", "admin");
            out.println("<script>");
            out.println("location.href = 'main.jsp'");
            out.println("</script>");
        }

        else if(key == 0) {
            out.println("<script>");
            out.println("alert('아이디 또는 비밀번호가 틀립니다.')");
            out.println("history.back()");
            out.println("</script>");
        }

    }
%>

</body>
</html>
