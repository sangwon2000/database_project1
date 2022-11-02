<%@ page import="com.example.project_2019012606.DBManager" %>
<%@ page import="java.sql.ResultSet" %>
<%@ page import="java.nio.file.attribute.UserPrincipalLookupService" %><%--
  Created by IntelliJ IDEA.
  User: jeongsang-won
  Date: 2022/10/26
  Time: 10:28 AM
  To change this template use File | Settings | File Templates.
--%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<html>
<head>
    <title>수업관리</title>
    <meta name="viewport" content="width=device-width, initial-scale=1">

    <link href="assets/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="assets/dist/js/bootstrap.bundle.min.js"></script>
</head>
<body>
<%
    DBManager dbManager = new DBManager();

%>

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


<div>
    <div class="row">
        <div class="col-md-6">
            <h4 style="color: gray;">설강</h4>
            <form action="action/createClassAction.jsp">
                과목: <%=dbManager.selectList("course")%><br/>
                강사: <%=dbManager.selectList("lecturer")%><br/>
                강의실: <%=dbManager.selectList("room")%><br/>
                정원: <input type="number" min="0" name="capacity" value="0"><br/>

                강의시간: <select name="day">
                <option value="1">월요일</option>
                <option value="2">화요일</option>
                <option value="3">수요일</option>
                <option value="4">목요일</option>
                <option value="5">금요일</option>
                <option value="6">토요일</option>
            </select>

                <select name="begin">
                    <%
                        for(int i=0; i<25; i++) {
                            int hour = i / 2;
                            int minute = i % 2;
                            String value = "";
                            if(hour < 10) value += "0" + hour + ":";
                            else value += hour + ":";
                            if(minute == 0) value += "00";
                            else value += "30";

                            out.println(String.format("<option value=\"%s\">%s</option>",value,value));
                        }
                    %>
                </select> ~

                <select name="end">
                    <%
                        for(int i=0; i<25; i++) {
                            int hour = i / 2;
                            int minute = i % 2;
                            String value = "";
                            if(hour < 10) value += "0" + hour + ":";
                            else value += hour + ":";
                            if(minute == 0) value += "00";
                            else value += "30";

                            out.println(String.format("<option value=\"%s\">%s</option>",value,value));
                        }
                    %>
                </select><br/>
                <input type="submit" class="btn btn-primary" value="설강">
            </form>
        </div>
        <div class="col-md-6">
            <h4 style="color: gray;">증원</h4>
            <form action="action/increaseCapacityAction.jsp">
                강의: <%=dbManager.selectList("class")%><br/>
                증원양:<input type="number" min="0" name="amount" value="0"><br/>
                <input type="submit" class="btn btn-primary" value="증원">
            </form>
        </div>
    </div>
    <div class="row">
        <div class="col-md-6">
            <h4 style="color: gray;">수강허용</h4>
            <form action="action/acceptClassAction.jsp">
                강의: <%=dbManager.selectList("class")%><br/>
                학생: <%=dbManager.selectList("student")%><br/>
                <input type="submit" class="btn btn-primary" value="허용">
            </form>
        </div>
        <div class="col-md-6">
            <h4 style="color: gray;">폐강</h4>
            <form action="action/deleteClassAction.jsp">
                강의: <%=dbManager.selectList("class")%><br/>
                <input type="submit" class="btn btn-primary" value="폐강">
            </form>
        </div>
    </div>
</div>


</body>
</html>
