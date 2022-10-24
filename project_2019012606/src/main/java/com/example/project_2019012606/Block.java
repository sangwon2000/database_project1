package com.example.project_2019012606;

import java.sql.ResultSet;

public class Block {

    private String name;
    private String color;

    private int fontSize;
    private int height;

    public boolean isSpace() {
        if(this.color == "white") return true;
        else return false;
    }

    public Block(String name, String color, int fontSize, int height) {
        this.name = name;
        this.color = color;
        this.fontSize = fontSize;
        this.height = height;
    }

    public String printBlock() {

        return String.format("<div style=\"background-color: %s; width: 100px; height: %dpx;" +
                "font: %dpx; font-weight: bold; color: white;" +
                "border:0.5px dotted gray;text-align: center;\">%s</div>\n",this.color,this.height,this.fontSize,this.name);
    }
}
