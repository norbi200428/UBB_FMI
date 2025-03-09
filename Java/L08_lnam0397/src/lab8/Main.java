package lab8;

import lab8.simple.*;
import lab8.composite.*;

public class Main {
    public static void main(String[] args) {
        Flower f = new Flower();
        Grass g = new Grass();
        Mushroom m1 = new Mushroom();
        Mushroom m2 = new Mushroom();
        PineTree p = new PineTree();
        OakTree o = new OakTree();
        Field myField1 = new Field();
        Field myField2 = new Field();
        Forest myForest = new Forest();
        myField1.add(g);
        myField1.add(f);
        myField2.add(m1);
        myField2.add(m2);
        myForest.add(myField1);
        myForest.add(myField2);
        myForest.add(p);
        myForest.add(o);
        System.out.println(myForest.getRepresentation());
    }
}