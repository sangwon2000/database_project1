<%@ page import="com.example.project_2019012606.DBManager" %>
<%@ page import="java.sql.ResultSet" %><%--
  Created by IntelliJ IDEA.
  User: jeongsang-won
  Date: 2022/10/28
  Time: 12:02 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>OLAP</title>
  <meta name="viewport" content="width=device-width, initial-scale=1">

  <link href="assets/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="assets/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>


<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
  <div class="container-fluid">
    <a class="navbar-brand" href="#">한양대학교 수강신청</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse justify-content-between" id="navbarNavDropdown">
      <ul class="navbar-nav">
        <li class="nav-item"><a class="nav-link" href="main.jsp">메인으로</a></li>
      </ul>
    </div>
  </div>
</nav>
<br/>

<h4 style="color: gray">평점 평균과 특정 과목의 학점 간 차이 Top 10</h4>
<table class="table table-hover" style="text-align: center; width: 600px; border: 1px solid #dddddd; font-size: 10px">
  <thead>
  <tr>
    <th style="text-align: center;"> 순위 </th>
    <th style="text-align: center;">  학수번호  </th>
    <th style="text-align: center;">  과목이름  </th>
    <th style="text-align: center;">  평균평점과의 차이  </th>
  </tr>

  </thead>
  <tbody>



  <%
    DBManager dbManager = new DBManager();
    ResultSet rs = dbManager.OLAP();
    int i = 0;
    while(rs.next()) {
      i++;
  %>

  <tr>
    <td><%=i%></td>
    <td><%=rs.getString("course_id")%></td>
    <td><%=rs.getString("name")%></td>
    <td><%=rs.getString("d")%></td>
  </tr>

  <% } %>

  </tbody>
</table>
</body>
</html>
