package com.example.project_2019012606;

import javax.xml.transform.Result;
import java.sql.*;
import java.io.PrintWriter;

public class DBManager {

    private Connection conn;

    public DBManager()
    {
        try{
            String dbURL = "jdbc:mysql://localhost:3306/DB2019012606?serverTimezone=Asia/Seoul";
            String dbID = "root";
            String dbPassword = "ju05140514!@!@";
            Class.forName("com.mysql.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbID, dbPassword);
        } catch (Exception e){
            e.printStackTrace();
        }
    }


    public int add(String type,String userId, String classId) {

        if(type == "register") {
            int checkResult = checkRegistrable(userId, classId);
            if(checkResult != 0) return checkResult;
        }

        try {
            String sql = String.format("insert into %s values(\"%s\", \"%s\");", type, userId, classId);
            System.out.println(sql);
            Statement st = conn.createStatement();
            st.executeUpdate(sql);
            return 0;
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public void cancel(String type,String userId, String classId) {
        try {
            String sql = "delete from "+ type +"\n" +
                    "where student_id = \""+userId+"\" and class_id = " + classId;
            System.out.println(sql);
            Statement st = conn.createStatement();
            st.executeUpdate(sql);
            return;
        }
        catch (Exception e) {
            e.printStackTrace();
            return;
        }
    }

    public void updateStudentInfo(String userId, Condition condition) {
        try {
            String sql = "update student\n" +
                    "set " + condition.getCondition() + " = \"" + condition.getValue() + "\"\n" +
                    "where student_id = \"" + userId + "\"";
            System.out.println(sql);
            Statement st = conn.createStatement();
            st.executeUpdate(sql);
            return;
        } catch (Exception e) {
            e.printStackTrace();
            return;
        }
    }

    public ResultSet registerInfo(String userId) {
        try {
            String sql = "select class.class_id as class_id, course.name as name, course.credit as credit,\n" +
                    "class.day as day, class.begin as begin, class.end as end\n" +
                    "from register, class, course\n" +
                    "where register.class_id = class.class_id and\n" +
                    "class.course_id = course.course_id and\n" +
                    "register.student_id = \""+ userId +"\"\n" +
                    "order by class.class_id";

            Statement st = conn.createStatement();
            return st.executeQuery(sql);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public ResultSet gradeInfo(String userId) {
        try {
            String sql = "select grade.year as year, course.name as name,\n" +
                    "course.credit as credit, grade.grade as grade\n" +
                    "from grade, course\n" +
                    "where grade.course_id = course.course_id\n" +
                    "and grade.student_id = \"" + userId + "\"\n" +
                    "order by grade.year, course.name;";

            Statement st = conn.createStatement();
            return st.executeQuery(sql);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public ResultSet studentInfo(String userId) {
        try {

            String sql = "select student.student_id as student_id,student.name as name,\n" +
                    "major.name as major, student.year as year,\n" +
                    "lecturer.name as lecturer, student.state\n" +
                    "from student, lecturer, major\n" +
                    "where student.lecturer_id = lecturer.lecturer_id\n" +
                    "and student.major_id = major.major_id and student_id = \"" + userId + "\"";

            Statement st = conn.createStatement();
            return st.executeQuery(sql);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public int login(User user) {

        String id = user.getUserId();
        String password = user.getUserPassword();

        try {

            String sql = String.format("select * from admin where admin_id = \"%s\" and password = \"%s\"", id, password);
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            if(rs.next()) return 2;
        }
        catch (Exception e) {
            e.printStackTrace();
            return 0;
        }

        try {
            String sql = String.format("select * from student where student_id = \"%s\" and password = \"%s\"", id, password);
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            if(rs.next()) return 1;
            else return 0;
        }
        catch (Exception e) {
            return 0;
        }
    }

    public ResultSet hopeList(String userId) {

        String sql = "select class.class_id as class_id, course.course_id as course_id,\n" +
                "course.name as name,lecturer.name as lecturer, class.day as day,\n" +
                "class.begin as begin, class.end as end, T.count as register,\n" +
                "class.capacity as capacity, room.number as room, building.name as building\n" +
                "\n" +
                "from class, course, room, building, lecturer, major,\n" +
                "(\n" +
                "\tselect class.class_id as class_id, count(register.student_id) as count\n" +
                "\tfrom class natural left outer join register\n" +
                "\tgroup by class.class_id\n" +
                ") as T\n" +
                "\n" +
                "where class.course_id =  course.course_id\n" +
                "and class.room_id = room.room_id\n" +
                "and room.building_id = building.building_id\n" +
                "and class.lecturer_id = lecturer.lecturer_id\n" +
                "and class.major_id = major.major_id\n" +
                "and class.class_id = T.class_id";

        sql += " and class.class_id\n" +
                "in (select class_id\n" +
                "from hope\n" +
                "where student_id = \"" + userId + "\")";

        System.out.println(sql);

        try {
            Statement st = conn.createStatement();
            return st.executeQuery(sql);
        }
        catch (Exception e) {
            return null;
        }
    }

    public ResultSet search(Condition condition) {

        String sql = "select class.class_id as class_id, course.course_id as course_id,\n" +
                "course.name as name,lecturer.name as lecturer, class.day as day,\n" +
                "class.begin as begin, class.end as end, T.count as register,\n" +
                "class.capacity as capacity, room.number as room, building.name as building\n" +
                "\n" +
                "from class, course, room, building, lecturer, major,\n" +
                "(\n" +
                "\tselect class.class_id as class_id, count(register.student_id) as count\n" +
                "\tfrom class natural left outer join register\n" +
                "\tgroup by class.class_id\n" +
                ") as T\n" +
                "\n" +
                "where class.course_id =  course.course_id\n" +
                "and class.room_id = room.room_id\n" +
                "and room.building_id = building.building_id\n" +
                "and class.lecturer_id = lecturer.lecturer_id\n" +
                "and class.major_id = major.major_id\n" +
                "and class.class_id = T.class_id";

        if(condition.getCondition() != null && condition.getValue() != null) {
            if(condition.getCondition().equals("course_id"))
                sql += " and course.course_id = \"" + condition.getValue() + "\"";
            else if(condition.getCondition().equals("class_id"))
                sql += " and class.class_id = \"" + condition.getValue() + "\"";
            else  if(condition.getCondition().equals("name"))
                sql += " and course.name like \"%" + condition.getValue() + "%\"";
        }

        System.out.println(sql);

        try {
            Statement st = conn.createStatement();
            return st.executeQuery(sql);
        }
        catch (Exception e) {
            return null;
        }
    }

    public int checkRetake(String userId, String courseId) {
        try {
            String sql = "select min(grade) as minGrade\n" +
                    "from grade\n" +
                    "where student_id = \""+userId+"\"\n" +
                    "and course_id = \""+courseId+"\"";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            rs.next();
            String minGrade = rs.getString("minGrade");

            if(minGrade == null) return 0;
            if(minGrade.compareTo("B0") > 0) return 1;
            else return 2;

        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public int sumCredit(String userId) {
        try {
            String sql = "select sum(credit) as sum\n" +
                    "from register, class, course\n" +
                    "where register.class_id = class.class_id\n" +
                    "and class.course_id = course.course_id\n" +
                    "and register.student_id = \""+userId+"\"";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            rs.next();
            String sum = rs.getString("sum");
            if(sum == null) return 0;
            return Integer.parseInt(sum);
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public int checkRegistrable(String userId, String classId) {

        try {

            String sql = "select * from class, course where class.course_id = course.course_id and class_id = " + classId;
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            rs.next();
            Schedule schedule = new Schedule(registerInfo(userId));

            if(checkRetake(userId,rs.getString("course_id")) == 2) return 1;
            if(getCount(classId) == Integer.parseInt(rs.getString("capacity"))) return 2;
            if(schedule.canRegister(rs.getString("day"),rs.getString("begin"),rs.getString("end")) == false) return 3;
            if(sumCredit(userId) + Integer.parseInt(rs.getString("credit")) > 18) return 4;

            return 0;
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    private int getCount(String classId) {

        try {
            String sql = "select count(register.student_id) as count\n" +
                    "from class natural left outer join register\n" +
                    "where class.class_id = \""+classId+"\"\n";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            rs.next();
            return Integer.parseInt(rs.getString("count"));
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

}
