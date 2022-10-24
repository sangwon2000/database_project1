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
    <title>Title</title>
</head>
<body>

<%
    if(session.getAttribute("userId") == null) {
        out.println("<script>");
        out.println("location.href = 'login.jsp'");
        out.println("</script>");
    }

    String userId = (String)session.getAttribute("userId");
%>


<%
    DBManager dbManager = new DBManager();

    if(userId == "admin") {
%>
<button type="button" onclick="location.href='logoutAction.jsp'">로그아웃</button>
<%
    } else {
%>
<button type="button" onclick="location.href='studentInfo.jsp?userId=<%=userId%>'">내 정보</button>
<button type="button" onclick="location.href='logoutAction.jsp'">로그아웃</button>

<h3>현재 신청 학점: <%=dbManager.sumCredit(userId)%> / 18</h3>
<h1>희망목록</h1>
<table class="table" style="text-align: center; width: 1000px; border: 1px solid #dddddd; font-size: 10px">
    <thead>
    <tr>
        <th style="text-align: center;"> 수업번호 </th>
        <th style="text-align: center;">  학수번호  </th>
        <th style="text-align: center;">  교과목명  </th>
        <th style="text-align: center;">  강사명  </th>
        <th style="text-align: center;">  강의 시간  </th>
        <th style="text-align: center;">  정원  </th>
        <th style="text-align: center;">  강의실  </th>
        <th style="text-align: center;">  수강신청  </th>
        <th style="text-align: center;">  희망삭제  </th>
    </tr>

    </thead>
    <tbody>

    <%
        ResultSet rs = dbManager.hopeList(userId);

        while(rs.next()) {
            String time = "";

            switch (rs.getString("day")) {
                case "1": time = "월요일 "; break;
                case "2": time = "화요일 "; break;
                case "3": time = "수요일 "; break;
                case "4": time = "목요일 "; break;
                case "5": time = "금요일 "; break;
                case "6": time = "토요일 "; break;
                case "0": time = "E-러닝 강의"; break;
            }

            if(!rs.getString("day").equals("0"))
                time += rs.getString("begin") + " ~ " + rs.getString("end");

            String parameter = "userId="+ userId+"&classId="+rs.getString("class_id");
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
        <td><%= rs.getString("register") + "/" + rs.getString("capacity")%></td>
        <td><%= rs.getString("building") + " " + rs.getString("room") +"호"%></td>
        <td><button type="button" onclick="location.href='addRegisterAction.jsp?<%=parameter%>'"><%=registerButton%></button></td>
        <td><button type="button" onclick="location.href='cancelHopeAction.jsp?<%=parameter%>'">희망삭제</button></td>
    </tr>

    <% } %>

    </tbody>
</table>


<%
    }
%>


<h1>수강편람</h1>

<form>
    <select name="condition">
        <option value="class_id">수업번호</option>
        <option value="course_id">학수번호</option>
        <option value="name">과목 이름</option>
    </select>
    <input type="text" name="value">
    <input type="submit" value="검색">
</form>

<table class="table" style="text-align: center; width: 1000px; border: 1px solid #dddddd; font-size: 10px">
    <thead>
    <tr>
        <th style="text-align: center;"> 수업번호 </th>
        <th style="text-align: center;">  학수번호  </th>
        <th style="text-align: center;">  교과목명  </th>
        <th style="text-align: center;">  강사명  </th>
        <th style="text-align: center;">  강의 시간  </th>
        <th style="text-align: center;">  정원  </th>
        <th style="text-align: center;">  강의실  </th>
        <th style="text-align: center;">  수강신청  </th>
        <th style="text-align: center;">  희망신청  </th>
    </tr>

    </thead>
    <tbody>

    <%
        ResultSet rs = dbManager.search(condition);

        while(rs.next()) {
            String time = "";

            switch (rs.getString("day")) {
                case "1": time = "월요일 "; break;
                case "2": time = "화요일 "; break;
                case "3": time = "수요일 "; break;
                case "4": time = "목요일 "; break;
                case "5": time = "금요일 "; break;
                case "6": time = "토요일 "; break;
                case "0": time = "E-러닝 강의"; break;
            }

            if(!rs.getString("day").equals("0"))
                time += rs.getString("begin") + " ~ " + rs.getString("end");

            String parameter = "userId="+ userId+"&classId="+rs.getString("class_id");
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
        <td><%= rs.getString("register") + "/" + rs.getString("capacity")%></td>
        <td><%= rs.getString("building") + " " + rs.getString("room") +"호"%></td>
        <td><button type="button" onclick="location.href='addRegisterAction.jsp?<%=parameter%>'"><%=registerButton%></button></td>
        <td><button type="button" onclick="location.href='addHopeAction.jsp?<%=parameter%>'">희망신청</button></td>
    </tr>

    <% } %>

    </tbody>
</table>

</body>
</html>
