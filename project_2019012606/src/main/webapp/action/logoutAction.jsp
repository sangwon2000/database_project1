<%--
  Created by IntelliJ IDEA.
  User: jeongsang-won
  Date: 2022/10/22
  Time: 10:13 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>Title</title>
</head>
<body>
    <%
        if(session.getAttribute("userId") != null)
            session.removeAttribute("userId");

        out.println("<script>");
        out.println("location.href = '../login.jsp'");
        out.println("</script>");
    %>
</body>
</html>
