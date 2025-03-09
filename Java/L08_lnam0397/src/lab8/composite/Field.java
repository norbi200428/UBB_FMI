package lab8.composite;

import lab8.Plant;

import java.util.HashSet;

public class Field implements Plant {
    private HashSet<Plant> set;

    public Field() {
        set = new HashSet<Plant>();
    }

    public void add(Plant plant) {
        set.add(plant);
    }

    public void remove(Plant plant) {
        if (set.contains(plant)) {
            set.remove(plant);
        } else {
            System.out.println("Nincs ilyen noveny.");
        }
    }

    @Override
    public double getOxigenAmountPerYear() {
        double sum = 0;
        for (Plant i : set) {
            sum += i.getOxigenAmountPerYear();
        }
        return sum;
    }

    @Override
    public int getLifeTime() {
        int max = 0;
        for (Plant i : set) {
            if (i.getLifeTime() > max) max = i.getLifeTime();
        }
        return max;
    }

    @Override
    public String getRepresentation() {
        StringBuilder rep = new StringBuilder("[");
        for (Plant i : set) {
            rep.append(i.getRepresentation());
            rep.append(",");
        }
        if (rep.length() > 1) {
            rep.deleteCharAt(rep.length() - 1);
        }
        rep.append("]");
        return rep.toString();
    }
}
