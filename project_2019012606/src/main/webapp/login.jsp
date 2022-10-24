<%--
  Created by IntelliJ IDEA.
  User: jeongsang-won
  Date: 2022/10/22
  Time: 9:16 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
  %>

  <form method="post" action="loginAction.jsp">
    <input type="text" class="form-control" placeholder="아이디" name="userId" maxlength="20">
    <input type="password" class="form-control" placeholder="비밀번호" name="userPassword" maxlength="20">
    <input type="submit" value="로그인">
  </form>

</body>
</html>
