package lab8.simple;

import lab8.Plant;

public class PineTree implements Plant {
    @Override
    public double getOxigenAmountPerYear() {
        return 40;
    }

    @Override
    public int getLifeTime() {
        return 40;
    }

    @Override
    public String getRepresentation() {
        return "P";
    }
}
