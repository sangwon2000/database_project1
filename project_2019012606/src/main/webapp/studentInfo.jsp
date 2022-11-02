<%@ page import="java.sql.ResultSet" %>
<%@ page import="com.example.project_2019012606.DBManager" %>
<%@ page import="com.example.project_2019012606.Schedule" %><%--
  Created by IntelliJ IDEA.
  User: jeongsang-won
  Date: 2022/10/22
  Time: 10:32 PM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>학생정보</title>
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


    <%
        String student_id = request.getParameter("student_id");
        DBManager dbManager = new DBManager();
        ResultSet studentInfo = dbManager.studentInfo(student_id);
        ResultSet gradeInfo = dbManager.gradeInfo(student_id);
        ResultSet registerInfo = dbManager.registerInfo(student_id);
        ResultSet scheduleInfo = dbManager.registerInfo(student_id);

        studentInfo.next();
    %>

    <div>
        <div class="row">
            <div class ="col-md-4">
                <h4 style="color: gray;">학생정보 및 성적</h4>

                <ul class="list-group">
                    <li class="list-group-item"><%= studentInfo.getString("student_id") %></li>
                    <li class="list-group-item"><%= studentInfo.getString("name") %></li>
                    <li class="list-group-item"><%= studentInfo.getString("major") %></li>
                    <li class="list-group-item">전담교수: <%= studentInfo.getString("lecturer") %></li>
                    <li class="list-group-item"><%= studentInfo.getString("state") %></li>
                </ul>
                <br>
                <h6 style="color: gray;">정보 변경</h6>
                <form action="action/updateStudentInfoAction.jsp">
                    <select name="condition">
                        <option value="password">비밀번호</option>
                        <option value="state">상태</option>
                    </select>
                    <input type="text" name="value">
                    <input type="submit" value="변경">
                    <input type="hidden" name="student_id" value="<%=student_id%>">
                </form>
            </div>
            <div class ="col-md-8">
                <br/>
                <table class="table table-hover" style="font-size: 11px; text-align: center;">
                    <thead>
                    <tr>
                        <th style="text-align: center;"> 수강년도 </th>
                        <th style="text-align: center;"> 과목이름 </th>
                        <th style="text-align: center;"> 학점 </th>
                        <th style="text-align: center;"> 평점 </th>
                    </tr>

                    </thead>
                    <tbody>

                    <%
                        while(gradeInfo.next()) {
                    %>

                    <tr>
                        <td><%= gradeInfo.getString("year")%></td>
                        <td><%= gradeInfo.getString("name")%></td>
                        <td><%= gradeInfo.getString("credit")%></td>
                        <td><%= gradeInfo.getString("grade")%></td>
                    </tr>

                    <% } %>

                    </tbody>
                </table>
            </div>
        </div>
    </div>
    <br/>
    <hr/>
    <br/>
    <h4 style="color: gray;">수강신청 내역</h4>
    <table class="table table-hover" style="font-size: 11px; text-align: center;">
        <thead>
        <tr>
            <th style="text-align: center;"> 수업번호 </th>
            <th style="text-align: center;"> 과목이름 </th>
            <th style="text-align: center;"> 강의시간 </th>
            <th style="text-align: center;"> E-러닝 </th>
            <th style="text-align: center;"> 학점 </th>
            <th style="text-align: center;"> 수강취소 </th>
        </tr>

        </thead>
        <tbody>

        <%
            while(registerInfo.next()) {
                String cancelParameter = "user_id=" + student_id + "&class_id=" + registerInfo.getString("class_id");

                String days[] = {"", "월","화","수", "목", "금", "토"};

                String time = days[registerInfo.getInt("day")] + "요일 ";
                time += registerInfo.getString("begin") + " ~ " + registerInfo.getString("end");

                String isClassE = "";
                if(registerInfo.getString("day").equals("6") || registerInfo.getString("end").compareTo("06:00") > 0)
                    isClassE = "O";
        %>

        <tr>
            <td><%= registerInfo.getString("class_id")%></td>
            <td><%= registerInfo.getString("name")%></td>
            <td><%= time %></td>
            <td><%= isClassE %></td>
            <td><%= registerInfo.getString("credit")%></td>
            <td><button onclick="location.href='action/cancelRegisterAction.jsp?<%=cancelParameter%>'">수강취소</button></td>
        </tr>
        <% } %>
        </tbody>
    </table>

    <%
        Schedule schedule = new Schedule(scheduleInfo);
        out.println(schedule.printSchedule());
    %>

<div class="mb-5 container-fluid">
    <hr>
    <p>ⓒ CloudStudying | <a href="#">Privacy</a> | <a href="#">Terms</a></p>
</div>

</body>
</html>
