package com.example.project_2019012606;

import java.sql.ResultSet;

public class Block {

    private String type;
    // day, time, space, classE, class
    private String name;
    private String color;




    public Block(String type, String name, String color) {
        this.type = type;
        this.name = name;
        this.color = color;

    }

    public boolean isSpace() {
        if(this.type.equals("space")) return true;
        else return false;
    }

    public String printBlock() {

        int fontSize = 20;
        if(this.type.equals("class")) fontSize = 10;

        int height = 130;
        if(this.type.equals("day")) height = 30;

        String color = this.color;
        String name = this.name;
        if(this.type.equals("space") || this.type.equals("classE")) {
            color = "white";
            name = "";
        }

        return String.format("<div style=\"background-color: %s; width: 130px; height: %dpx;" +
                "font: %dpx; font-weight: bold; color: white;" +
                "border:0.5px dotted gray;text-align: center;\">%s</div>\n",color,height,fontSize,name);
    }
}
