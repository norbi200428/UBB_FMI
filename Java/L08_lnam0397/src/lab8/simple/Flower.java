package lab8.simple;

import lab8.Plant;

public class Flower implements Plant {
    @Override
    public double getOxigenAmountPerYear() {
        return 10;
    }

    @Override
    public int getLifeTime() {
        return 10;
    }

    @Override
    public String getRepresentation() {
        return "F";
    }
}
