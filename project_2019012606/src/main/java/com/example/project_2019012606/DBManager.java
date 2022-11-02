package com.example.project_2019012606;

import javax.swing.plaf.basic.BasicInternalFrameTitlePane;
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

    //-------------------------------------------------------------------------

    /**
     *
     * @param user 로그인 정보
     * @return 로그인 결과를 리턴 (-1: 디비에러) (0: 일치하는 로그인 정보 없음) (1: 관리자 계정으로 로그인) (2: 학생 계정으로 로그인)
     */
    public int login(User user) {

        String id = user.getUserId();
        String password = user.getUserPassword();

        try {
            // 관리자 계정인 경우
            String sql = String.format("select * from admin where admin_id = \"%s\" and password = \"%s\"", id, password);
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            if(rs.next()) return 1;
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }

        try {
            // 학생 계정인 경우
            String sql = String.format("select * from student where student_id = \"%s\" and password = \"%s\"", id, password);
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            if(rs.next()) return 2;

                // 해당하는 로그인 정보가 없는 경우
            else return 0;
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    //-------------------------------------------------------------------------

    /**
     *
     * @param condition 검색조건
     * @return 모든 수업 목록을 테이블로 리턴, 검색조건 입력 시 조건에 맞는 수업들만 필터링해서 리턴 (null: 디비에러)
     */
    public ResultSet search(Condition condition) {

        String sql = "select class.class_id as class_id, course.course_id as course_id,\n" +
                "course.name as name,lecturer.name as lecturer, class.day as day,\n" +
                "class.begin as begin, class.end as end, T.count as register,\n" +
                "class.capacity as capacity, room.number as room, building.name as building\n" +
                "\n" +
                "from class, course, room, building, lecturer,\n" +
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
                "and class.class_id = T.class_id";

        // 수강 편람 필터 적용 시
        if(condition.getCondition() != null && condition.getValue() != null) {
            // 학수번호로 필터링
            if(condition.getCondition().equals("course_id"))
                sql += " and course.course_id = \"" + condition.getValue() + "\"";
                // 수업번호로 필터링
            else if(condition.getCondition().equals("class_id"))
                sql += " and class.class_id = \"" + condition.getValue() + "\"";
                // 과목이름으로 필터링
            else  if(condition.getCondition().equals("name"))
                sql += " and course.name like \"%" + condition.getValue() + "%\"";
        }
        sql += " order by class.class_id";

        try {
            Statement st = conn.createStatement();
            return st.executeQuery(sql);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     *
     * @param student_id 학번
     * @return 해당 학생이 장바구니에 담은 수업목록을 테이블로 리턴 (null: 디비에러)
     */
    public ResultSet hopeList(String student_id) {

        String sql = "select class.class_id as class_id, course.course_id as course_id,\n" +
                "course.name as name,lecturer.name as lecturer, class.day as day,\n" +
                "class.begin as begin, class.end as end, T.count as register,\n" +
                "class.capacity as capacity, room.number as room, building.name as building\n" +
                "\n" +
                "from class, course, room, building, lecturer,\n" +
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
                "and class.class_id = T.class_id";

        // 수강편람 중에서 학생이 장바구니에 담은 강의만 출력
        sql += " and class.class_id\n" +
                "in (select class_id\n" +
                "from hope\n" +
                "where student_id = \"" + student_id + "\")";
        sql += " order by class.class_id";

        try {
            Statement st = conn.createStatement();
            return st.executeQuery(sql);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     *
     * @return 전체 학생 목록을 테이블로 리턴 (null: 디비에러)
     */
    public ResultSet studentList() {
        try {
            String sql = "select student.student_id as student_id,student.name as name,\n" +
                    "major.name as major, student.year as year,\n" +
                    "lecturer.name as lecturer, student.state\n" +
                    "from student, lecturer, major\n" +
                    "where student.lecturer_id = lecturer.lecturer_id\n" +
                    "and student.major_id = major.major_id order by student.student_id";

            Statement st = conn.createStatement();
            return st.executeQuery(sql);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    //-------------------------------------------------------------------------

    /**
     *
     * @param student_id 학번
     * @return 해당 학생의 정보를 테이블로 반환 (null: 디비에러)
     */
    public ResultSet studentInfo(String student_id) {
        try {

            String sql = "select student.student_id as student_id,student.name as name,\n" +
                    "major.name as major, student.year as year,\n" +
                    "lecturer.name as lecturer, student.state\n" +
                    "from student, lecturer, major\n" +
                    "where student.lecturer_id = lecturer.lecturer_id\n" +
                    "and student.major_id = major.major_id and student_id = \"" + student_id + "\"";

            Statement st = conn.createStatement();
            return st.executeQuery(sql);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     *
     * @param student_id 학번
     * @return 해당 학생의 성적 정보를 테이블로 반환 (null: 디비에러)
     */
    public ResultSet gradeInfo(String student_id) {
        try {
            String sql = "select grade.year as year, course.name as name,\n" +
                    "course.credit as credit, grade.grade as grade\n" +
                    "from grade, course\n" +
                    "where grade.course_id = course.course_id\n" +
                    "and grade.student_id = \"" + student_id + "\"\n" +
                    "order by grade.year, course.name;";

            Statement st = conn.createStatement();
            return st.executeQuery(sql);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     *
     * @param student_id 학번
     * @return 해당 학생의 수강 신청 정보를 테이블로 반환 (null: 디비에러)
     */
    public ResultSet registerInfo(String student_id) {
        try {
            String sql = "select class.class_id as class_id, course.name as name, course.credit as credit,\n" +
                    "class.day as day, class.begin as begin, class.end as end\n" +
                    "from register, class, course\n" +
                    "where register.class_id = class.class_id and\n" +
                    "class.course_id = course.course_id and\n" +
                    "register.student_id = \""+ student_id +"\"\n" +
                    "order by class.class_id";

            Statement st = conn.createStatement();
            return st.executeQuery(sql);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    //-------------------------------------------------------------------------

    /**
     *
     * @param table 테이블
     * @param user_id 학번
     * @param class_id 수업번호
     * @return 해당 테이블에 신청 정보 기입후 결과 리턴 (-1: 디비에러) (0: 성공)
     * (1: 재수강 불가) (2: 수강 인원 초과) (3: 동시간 수업 존재) (4: 18학점 초과) (5: 관리자 계정으로 접근)
     */
    public int add(String table, String user_id, String class_id) {

        if(user_id.equals("admin")) return 5;

        try {
            Statement st = conn.createStatement();

            // 이미 등록된 수업일 경우
            String sql = "select * from " + table + " where student_id = " + user_id + " and class_id = " + class_id;
            if(st.executeQuery(sql).next()) return 6;

            if(table.equals("register")) {
                int checkResult = checkRegistrable(user_id, class_id);
                if(checkResult != 0) return checkResult;
            }

            sql = String.format("insert into %s values(\"%s\", \"%s\");", table, user_id, class_id);
            st.executeUpdate(sql);
            return 0;
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     *
     * @param table 테이블
     * @param student_id 학번
     * @param class_id 수업번호
     * @return 해당 테이블에 있는 신청 정보를 삭제한 후 결과 리턴 (-1: 디비에러) (0: 성공)
     */
    public int cancel(String table, String student_id, String class_id) {
        try {
            String sql = "delete from "+ table +"\n" +
                    "where student_id = \""+student_id+"\" and class_id = " + class_id;
            Statement st = conn.createStatement();
            st.executeUpdate(sql);
            return 0;
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     *
     * @param student_id 학번
     * @param condition 변경할 정보 타입과 값
     * @return 전달 받은 정보에 맞게 학생의 정보를 변경시킨 후 결과 리턴(-1: 디비에러) (0: 변경 성공)
     */
    public int updateStudentInfo(String student_id, Condition condition) {
        try {
            String sql = "update student\n" +
                    "set " + condition.getCondition() + " = \"" + condition.getValue() + "\"\n" +
                    "where student_id = \"" + student_id + "\"";
            Statement st = conn.createStatement();
            st.executeUpdate(sql);
            return 0;
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    //-------------------------------------------------------------------------

    /**
     *
     * @param table 테이블
     * @return 테이블에 대한 select 태그 생성 (null: 디비에러)
     */
    public String selectList(String table) {
        try {

            // 강의실을 건물 이름과 같이, 수업을 과목이름과 같이 표시하기 위한 자연 조인
            String etc = "";
            if(table.equals("room")) etc += " natural join building";
            if(table.equals("class")) etc += " natural join course";

            String sql = "select *\n" +
                    "from " + table + etc + " order by " + table + "_id";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            //해당 테이블의 기본키를 form의 제출 값으로 갖는 select 태그 생성
            String result = "<select name = \""+ table +"_id\">\n";

            while(rs.next()) {
                String id = rs.getString(table+"_id");
                String name = "";

                // name: 항목에 표시할 이름
                if(table.equals("room")) {
                    String building = rs.getString("name");
                    String number = rs.getString("number");
                    name = building + " " + number + "호";
                }
                else name = rs.getString("name");

                // 기본키를 값으로 갖고, 기본키_이름을 option의 표시 값으로 지정
                result += String.format("<option value=\"%s\">%s</option>\n",id, id + "_" + name);
            }
            result += "</select>\n";
            return result;

        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    /**
     *
     * @param classInfo 수업 정보
     * @return 전달 받은 수업 정보에 맞게 설강하고 그 결과를 리턴
     * (-1: 디비에러) (0: 설강 완료) (1: 강의 시간 오류) (2: 강의실 정원 오류)
     */
    public int createClass(ClassInfo classInfo) {

        // 강의 시작 시간이 강의 마치는 시간보다 늦는 경우
        if(classInfo.getBegin().compareTo(classInfo.getEnd()) > 0) return 1;
        // 강의실이 전달 받은 인원 수를 소용할 수 없는 경우
        if(checkRoom(classInfo.getRoom_id(), classInfo.getCapacity()) == false) return 2;

        try {
            // 수업 번호 생성
            String sql = "select max(class_id) from class";
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            rs.next();
            int key = rs.getInt("max(class_id)") + 1;

            sql = "insert into class values(" + key +"," + classInfo.print() +")";
            st.executeUpdate(sql);
            return 0;
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     *
     * @param class_id 수업번호
     * @return 해당 수업을 모든 테이블에서 삭제 시킨 후 결과 리턴 (-1: 디비에러) (0: 삭제 성공)
     */
    public int deleteClass(String class_id) {
        try {
            Statement st = conn.createStatement();


            // 신청 목록에서 삭제
            String sql = "delete from register where class_id = \""+class_id+"\"";
            st.executeUpdate(sql);
            // 장바구니에서 삭제
            sql = "delete from hope where class_id = \""+class_id+"\"";
            st.executeUpdate(sql);
            // 수업 삭제
            sql = "delete from class where class_id = \""+class_id+"\"";
            st.executeUpdate(sql);

            return 0;
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     *
     * @param class_id 수업번호
     * @param student_id 학번
     * @return 학생을 수업에 등록시킨 후 그 결과 리턴
     * (-1: 디비에러) (0: 등록 성공) (1: 증원 상관 없이 등록 불가) (2: 강의실 제한으로 증원 불가)
     */
    public int acceptClass(String class_id, String student_id) {

        int check = checkRegistrable(student_id,class_id);

        // 해당 학생이 수업 수강이 가능한 경우
        if(check == 0) {
            add("register",student_id,class_id);
            return 0;
        }
        // 해당 학생이 수업 정원 제한 때문에 수강이 불가능한 경우
        else if(check == 3) {
            // 수업 정원 증원이 가능한 경우
            if(increaseCapacity(class_id,1) == 0) {
                add("register",student_id,class_id);
                return 0;
            }
            // 수업 정원 증원이 불가능한 경우
            else return 2;
        }
        // 해당 학생이 증원과 상관 없이 수강이 불가능한 경우
        else return 1;
    }

    /**
     *
     * @param class_id 수업번호
     * @param amount 인원 수
     * @return 해당 수업을 전달 받은 인원 수 만큼 증원시킨 후 그 결과를 리턴
     * (-1: 디비에러) (0: 증원 성공) (1: 강의실이 해당 인원 수용 불가능)
     */
    public int increaseCapacity(String class_id, int amount) {
        try {
            String sql = "select room_id, capacity from class where class_id = \""+class_id+"\"";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            rs.next();

            String roomId = rs.getString("room_id");
            int toCapacity = rs.getInt("capacity") + amount;

            // 강의실이 수용 가능한 경우
            if(checkRoom(roomId,toCapacity)) {
                sql = "update class set capacity = \""+ toCapacity +"\" where class_id = \"" + class_id + "\"";
                st.executeUpdate(sql);
                return 0;
            }
            // 강의실이 수용 불가능한 경우
            else return 1;
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     *
     * @param room_id 강의실 번호
     * @param capacity 인원 수
     * @return 전달한 인원 수를 해당 강의실이 수용할 수 있는지 여부 리턴
     */
    public boolean checkRoom(String room_id, int capacity) {
        try {
            String sql = "select * from room where room_id = " + room_id;

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            rs.next();
            return (rs.getInt("capacity") >= capacity);
        }
        catch (Exception e) {
            e.printStackTrace();
            return false;
        }
    }

    //-------------------------------------------------------------------------

    /**
     *
     * @param student_id 학번
     * @param class_id 수업번호
     * @return 해당 학생이 위 수업을 수강할 수 있는지 판단하는 함수입니다.
     * (0: 수강 가능) (1: 재수강 불가) (2: 수강 인원 초과) (3: 동시간 수업 존재) (4: 18학점 초과) (-1: 디비에러)
     */
    public int checkRegistrable(String student_id, String class_id) {
        try {
            String sql = "select * from class, course where class.course_id = course.course_id and class_id = " + class_id;
            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            rs.next();
            Schedule schedule = new Schedule(registerInfo(student_id));

            // 1: 재수강 불가능
            if(checkRetake(student_id,rs.getString("course_id")) == -1 || checkRetake(student_id,rs.getString("course_id")) == 2) return 1;
            // 2: 수강 인원 초과
            if(getCount(class_id) == rs.getInt("capacity")) return 2;
            // 3: 동시간에 기존 신청 수업 존재
            if(schedule.canRegister(rs.getString("day"),rs.getString("begin"),rs.getString("end")) == false) return 3;
            // 4: 18학점 초과 신청
            if(sumCredit(student_id) + rs.getInt("credit") > 18) return 4;
            // 0: 수강 가능
            return 0;
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     *
     * @param student_id 학번
     * @param course_id 학수번호
     * @return 수강 가능 여부를 판단하는 함수입니다.
     * (-1: 디비에러) (0: 수강 이력 없음) (1: 재수강 가능) (2: 재수강 불가능)
     */
    public int checkRetake(String student_id, String course_id) {
        try {
            String sql = "select min(grade) as minGrade\n" +
                    "from grade\n" +
                    "where student_id = \""+student_id+"\"\n" +
                    "and course_id = \""+course_id+"\"";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            rs.next();
            String minGrade = rs.getString("minGrade");

            if(minGrade == null) return 0; // 수강 이력 없음
            if(minGrade.compareTo("B0") > 0) return 1; // 재수강 가능 (B0 미만으로 받았을시)
            else return 2; // 재수강 불가능

        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     *
     * @param class_id 수업번호
     * @return 해당 수업 수강하는 인원 수 리턴 (-1: 디비에러)
     */
    private int getCount(String class_id) {

        try {
            String sql = "select count(register.student_id) as count\n" +
                    "from class natural left outer join register\n" +
                    "where class.class_id = \""+ class_id +"\"\n";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);
            rs.next();

            return rs.getInt("count"); // 해당 수업 수강하는 인원 수 리턴
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    /**
     *
     * @param student_id 학번
     * @return 해당 학생이 수강하고 있는 총 학점 수 리턴 (-1: 디비에러)
     */
    public int sumCredit(String student_id) {
        try {
            String sql = "select sum(credit) as sum\n" +
                    "from register, class, course\n" +
                    "where register.class_id = class.class_id\n" +
                    "and class.course_id = course.course_id\n" +
                    "and register.student_id = \""+student_id+"\"";

            Statement st = conn.createStatement();
            ResultSet rs = st.executeQuery(sql);

            rs.next();
            String sum = rs.getString("sum");
            if(sum == null) return 0;
            return Integer.parseInt(sum); // 해당 학생이 현재 수강하고 있는 총 학점 수 리턴
        }
        catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    //-------------------------------------------------------------------------

    /**
     *
     * @return 평점평균에서 특정과목의 학점을 뺀 값을 내림차순으로 정렬한 Top 10 목록을 테이블로 리턴 (null: 디비에러)
     */
    public ResultSet OLAP() {
        try {
            String sql = "select A.course_id,C.name, B.m - A.m as d from course as C,\n" +
                    "(\n" +
                    "\tselect course_id, avg(F) as m\n" +
                    "\tfrom grade, G2F\n" +
                    "\twhere grade = G\n" +
                    "\tgroup by course_id\n" +
                    ") as A,\n" +
                    "(\n" +
                    "\tselect avg(F) as m\n" +
                    "\tfrom grade, G2F\n" +
                    "\twhere grade = G\n" +
                    ") as B\n" +
                    "where A.course_id = C.course_id\n" +
                    "order by d desc limit 10;";

            Statement st = conn.createStatement();
            return st.executeQuery(sql);
        }
        catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

}
