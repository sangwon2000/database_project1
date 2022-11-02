<%--
  Created by IntelliJ IDEA.
  User: jeongsang-won
  Date: 2022/10/21
  Time: 11:50 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.example.project_2019012606.DBManager" %>
<%@ page import="java.sql.*" %>
<%@ page import="java.awt.print.PrinterException" %>
<%@ page import="java.io.PrintWriter" %>
<jsp:useBean id="condition" class="com.example.project_2019012606.Condition" scope="page" />
<jsp:setProperty name="condition" property="condition" />
<jsp:setProperty name="condition" property="value" />
<html>
<head>
    <title>메인화면</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="assets/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="assets/dist/js/bootstrap.bundle.min.js"></script>

</head>
<body>

<%
    if(session.getAttribute("userId") == null) {
        out.println("<script>");
        out.println("location.href = 'login.jsp'");
        out.println("</script>");
    }

    String userId = (String)session.getAttribute("userId");
    DBManager dbManager = new DBManager();
%>

<nav class="navbar navbar-expand-lg navbar-dark bg-primary">
    <div class="container-fluid">
        <a class="navbar-brand" href="#">한양대학교 수강신청</a>
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNavDropdown" aria-controls="navbarNavDropdown" aria-expanded="false" aria-label="Toggle navigation">
            <span class="navbar-toggler-icon"></span>
        </button>
        <div class="collapse navbar-collapse justify-content-between" id="navbarNavDropdown">

                <%
                    if(userId == "admin") {
                %>
                <ul class="navbar-nav">
                    <li class="nav-item"><a class="nav-link" href="manageClass.jsp">수업관리</a></li>
                    <li class="nav-item"><a class="nav-link" href="OLAP.jsp">OLAP</a></li>
                    <li class="nav-item"><a class="nav-link" href="action/logoutAction.jsp">로그아웃</a></li>
                </ul>
                <%
                    } else {
                %>
                <ul class="navbar-nav">
                    <li class="nav-item"><a class="nav-link" href="studentInfo.jsp?student_id=<%=userId%>">내정보</a></li>
                    <li class="nav-item"><a class="nav-link" href="action/logoutAction.jsp">로그아웃</a></li>
                </ul>
                <ul class="navbar-nav">
                    <li class="nav-item"><a class="nav-link" href="#">현재 신청 학점: <%=dbManager.sumCredit(userId)%> / 18</a></li>
                </ul>
                <%
                    }
                %>
            </ul>
        </div>
    </div>
</nav>
<br/>

<%------------------------------- 관리자 --------------------------------%>
<%
    if(userId == "admin") {

    ResultSet studentList = dbManager.studentList();
%>

<h4 style="color: gray;">학생목록</h4>
<table class="table table-hover" style="font-size: 11px; text-align: center;">
    <thead>
    <tr>
        <th> 학번 </th>
        <th>  이름  </th>
        <th>  전공  </th>
        <th>  학년  </th>
        <th>  전담교수  </th>
        <th>  상태  </th>
        <th>  자세히  </th>
    </tr>
    </thead>
    <tbody>

    <%
        while(studentList.next()) {
            String parameter = "student_id="+ studentList.getString("student_id");
    %>

    <tr>
        <td><%= studentList.getString("student_id")%></td>
        <td><%= studentList.getString("name")%></td>
        <td><%= studentList.getString("major")%></td>
        <td><%= studentList.getString("year")%>학년</td>
        <td><%= studentList.getString("lecturer")%></td>
        <td><%= studentList.getString("state")%></td>
        <td><button type="button" onclick="location.href='studentInfo.jsp?<%=parameter%>'">자세히</button></td>
    </tr>

    <% } %>

    </tbody>
</table>
<%
    }

    else {
%>

<%------------------------------- 학생 --------------------------------%>

<div style="text-align: right"></div>
<h4 style="color: gray;">희망목록</h4>
<table class="table table-hover" style="font-size: 11px; text-align: center;">
    <thead>
    <tr>
        <th> 수업번호 </th>
        <th>  학수번호  </th>
        <th>  교과목명  </th>
        <th>  강사명  </th>
        <th>  강의시간  </th>
        <th>  E-러닝  </th>
        <th>  정원  </th>
        <th>  강의실  </th>
        <th>  수강신청  </th>
        <th>  희망삭제  </th>
    </tr>

    </thead>
    <tbody>

    <%
        ResultSet rs = dbManager.hopeList(userId);

        while(rs.next()) {

            String days[] = {"", "월","화","수", "목", "금", "토"};

            String time = days[rs.getInt("day")] + "요일 ";
            time += rs.getString("begin") + " ~ " + rs.getString("end");

            String isClassE = "";
            if(rs.getString("day").equals("6") || rs.getString("end").compareTo("06:00") > 0)
                isClassE = "O";

            String parameter = "user_id="+ userId+"&class_id="+rs.getString("class_id");
            String registerButton = "수강신청";
            if(dbManager.checkRetake(userId,rs.getString("course_id")) >= 1)
                registerButton = "재수강";
    %>

    <tr>
        <td><%= rs.getString("class_id")%></td>
        <td><%= rs.getString("course_id")%></td>
        <td><%= rs.getString("name")%></td>
        <td><%= rs.getString("lecturer")%></td>
        <td><%= time%></td>
        <td><%= isClassE %></td>
        <td><%= rs.getString("register") + "/" + rs.getString("capacity")%></td>
        <td><%= rs.getString("building") + " " + rs.getString("room") +"호"%></td>
        <td><button type="button" onclick="location.href='action/addRegisterAction.jsp?<%=parameter%>'"><%=registerButton%></button></td>
        <td><button type="button" onclick="location.href='action/cancelHopeAction.jsp?<%=parameter%>'">희망삭제</button></td>
    </tr>

    <% } %>

    </tbody>
</table>
<%
    }
%>

<%------------------------------- 수강편람 --------------------------------%>
<h4 style="color: gray;">수강편람</h4>
<form>
    <select name="condition">
        <option value="class_id">수업번호</option>
        <option value="course_id">학수번호</option>
        <option value="name">과목 이름</option>
    </select>
    <input type="text" name="value">
    <input type="submit" value="검색">
</form>
<table class="table table-hover" style="font-size: 11px; text-align: center;">
    <thead>
    <tr>
        <th> 수업번호 </th>
        <th>  학수번호  </th>
        <th>  교과목명  </th>
        <th>  강사명  </th>
        <th>  강의시간  </th>
        <th>  E-러닝  </th>
        <th>  정원  </th>
        <th>  강의실  </th>
        <th>  수강신청  </th>
        <th>  희망신청  </th>
    </tr>

    </thead>
    <tbody>

    <%
        ResultSet rs = dbManager.search(condition);

        while(rs.next()) {

            String days[] = {"", "월","화","수", "목", "금", "토"};

            String time = days[rs.getInt("day")] + "요일 ";
            time += rs.getString("begin") + " ~ " + rs.getString("end");

            String isClassE = "";
            if(rs.getString("day").equals("6") || rs.getString("end").compareTo("06:00") > 0)
                isClassE = "O";

            String parameter = "user_id="+ userId+"&class_id="+rs.getString("class_id");
            String registerButton = "수강신청";
            if(dbManager.checkRetake(userId,rs.getString("course_id")) >= 1)
                registerButton = "재수강";
    %>

    <tr>
        <td><%= rs.getString("class_id")%></td>
        <td><%= rs.getString("course_id")%></td>
        <td><%= rs.getString("name")%></td>
        <td><%= rs.getString("lecturer")%></td>
        <td><%= time %></td>
        <td><%= isClassE %></td>
        <td><%= rs.getString("register") + "/" + rs.getString("capacity")%></td>
        <td><%= rs.getString("building") + " " + rs.getString("room") +"호"%></td>
        <td><button type="button" onclick="location.href='action/addRegisterAction.jsp?<%=parameter%>'"><%=registerButton%></button></td>
        <td><button type="button" onclick="location.href='action/addHopeAction.jsp?<%=parameter%>'">희망신청</button></td>
    </tr>

    <% } %>

    </tbody>
</table>

<div class="mb-5 container-fluid">
    <hr>
    <p>ⓒ CloudStudying | <a href="#">Privacy</a> | <a href="#">Terms</a></p>
</div>

</body>
</html>
