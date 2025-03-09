package lab8.simple;

import lab8.Plant;

public class Mushroom implements Plant {
    @Override
    public double getOxigenAmountPerYear() {
        return 30;
    }

    @Override
    public int getLifeTime() {
        return 30;
    }

    @Override
    public String getRepresentation() {
        return "M";
    }
}
