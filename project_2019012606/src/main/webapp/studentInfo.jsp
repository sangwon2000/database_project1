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
    <title>Title</title>
</head>
<body>

    <button type="button" onclick="location.href='main.jsp'">메인화면</button>

    <%
        String userId = request.getParameter("userId");
        DBManager dbManager = new DBManager();
        ResultSet studentInfo = dbManager.studentInfo(userId);
        ResultSet gradeInfo = dbManager.gradeInfo(userId);
        ResultSet registerInfo = dbManager.registerInfo(userId);
        ResultSet scheduleInfo = dbManager.registerInfo(userId);

        studentInfo.next();
    %>
    <h1>정보</h1>
    <h3>학번: <%= studentInfo.getString("student_id") %></h3>
    <h3>이름: <%= studentInfo.getString("name") %></h3>
    <h3>전공: <%= studentInfo.getString("major") %></h3>
    <h3>학년: <%= studentInfo.getString("year") + "학년" %></h3>
    <h3>전담교수: <%= studentInfo.getString("lecturer") %></h3>
    <h3>상태: <%= studentInfo.getString("state") %></h3>


    <form action="updateStudentInfoAction.jsp">
        <select name="condition">
            <option value="password">비밀번호</option>
            <option value="state">상태</option>
        </select>
        <input type="text" name="value">
        <input type="submit" value="변경">
        <input type="hidden" name="userId" value="<%=userId%>">
    </form>


    <h1>성적</h1>
    <table class="table" style="text-align: center; width: 500px; border: 1px solid #dddddd">
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

    <h1>수강신청 내역</h1>
    <table class="table" style="text-align: center; width: 500px; border: 1px solid #dddddd">
        <thead>
        <tr>
            <th style="text-align: center;"> 수업번호 </th>
            <th style="text-align: center;"> 과목이름 </th>
            <th style="text-align: center;"> 학점 </th>
            <th style="text-align: center;"> 수강취소 </th>
        </tr>

        </thead>
        <tbody>

        <%
            while(registerInfo.next()) {
                String cancelParameter = "userId=" + userId + "&classId=" + registerInfo.getString("class_id");
        %>

        <tr>
            <td><%= registerInfo.getString("class_id")%></td>
            <td><%= registerInfo.getString("name")%></td>
            <td><%= registerInfo.getString("credit")%></td>
            <td><button onclick="location.href='cancelRegisterAction.jsp?<%=cancelParameter%>'">수강취소</button></td>
        </tr>

        <% } %>

        </tbody>
    </table>

    <h1>시간표</h1>
    <%
        Schedule schedule = new Schedule(scheduleInfo);
        out.println(schedule.printSchedule());
    %>



</body>
</html>
