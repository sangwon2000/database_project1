package com.example.project_2019012606;

import java.sql.ResultSet;

public class Schedule {

    Block[][] matrix;

    public Schedule(ResultSet rs) {

        try {
            String[] colorList = {
                    "#F2C46D",
                    "#F28177",
                    "#75BF80",
                    "#84D9C9",
                    "#9784D9",
                    "#EEA86E",
                    "#D095E8",
                    "#7BA2E5",
                    "#AAC973" };

            this.matrix = new Block[25][7];

            int dayHeight = 20;
            int height = 70;

            this.matrix[0][0] = new Block("", "black", 20, dayHeight);
            this.matrix[0][1] = new Block("월", "gray", 20,dayHeight);
            this.matrix[0][1] = new Block("월", "gray", 20,dayHeight);
            this.matrix[0][2] = new Block("화", "gray", 20,dayHeight);
            this.matrix[0][3] = new Block("수", "gray", 20,dayHeight);
            this.matrix[0][4] = new Block("목", "gray", 20,dayHeight);
            this.matrix[0][5] = new Block("금", "gray", 20,dayHeight);
            this.matrix[0][6] = new Block("토", "gray", 20,dayHeight);

            for(int i=1; i<25; i++) {
                int hour = (i-1)/2;
                String minute = (i % 2 == 1) ? ":00" : ":30";
                this.matrix[i][0] = new Block(hour + minute, "gray", 20,height);
            }


            for(int k=1;k<25; k++) {
                for(int g=1;g<7; g++) {
                    this.matrix[k][g] = new Block("", "white", 10,height);
                }
            }

            int i = 0;
            while(rs.next()) {

                String name = rs.getString("name");
                int day = Integer.parseInt(rs.getString("day"));
                int begin = timeToIndex(rs.getString("begin"));
                int end = timeToIndex(rs.getString("end"));

                if(day == 0) continue;

                this.matrix[begin][day] = new Block(name,colorList[i],10,height);
                for(int j=begin+1; j<end; j++)
                    this.matrix[j][day] = new Block("",colorList[i],10,height);

                i++;
                if(i == colorList.length) i = 0;
            }
        }
        catch(Exception e) {
            e.printStackTrace();
        }

    }

    public String printSchedule() {
        String result = "<div style=\"display:flex; flex-direction:column\">\n";

        for(int k=0;k<25; k++) {
            result += "<div style=\"display:flex\">\n";
            for(int g=0;g<7; g++) {
                result += this.matrix[k][g].printBlock();
            }
            result += "</div>\n";
        }
        result += "</div>\n";
        return result;
    }

    public int timeToIndex(String time) {
        int hour = Integer.parseInt(time.substring(0,2));
        int minute = 0;
        if(Integer.parseInt(time.substring(3,5)) == 30) minute = 1;
        System.out.println(hour*2 + minute + 1);
        return hour*2 + minute + 1;
    }

    public boolean canRegister(String _day, String _begin, String _end) {

        int day = Integer.parseInt(_day);
        int begin = timeToIndex(_begin);
        int end = timeToIndex(_end);

        for(int i=begin; i<end; i++) {
            if(matrix[i][day].isSpace() == false) return false;
        }

        return true;
    }
}
