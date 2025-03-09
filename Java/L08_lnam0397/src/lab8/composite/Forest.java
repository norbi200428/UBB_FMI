package lab8.composite;

import lab8.Plant;

import java.util.ArrayList;

public class Forest implements Plant {
    private ArrayList<Plant> list;

    public Forest() {
        list = new ArrayList<>();
    }

    public void add(Plant plant) {
        list.add(plant);
    }

    public void remove(Plant plant) {
        if (list.contains(plant)) {
            list.remove(plant);
        } else {
            System.out.println("Nincs ilyen noveny.");
        }
    }

    @Override
    public double getOxigenAmountPerYear() {
        double sum = 0;
        for (Plant i : list) {
            sum += i.getOxigenAmountPerYear();
        }
        return sum;
    }

    @Override
    public int getLifeTime() {
        int max = 0;
        for (Plant i : list) {
            if (i.getLifeTime() > max) max = i.getLifeTime();
        }
        return max;
    }

    @Override
    public String getRepresentation() {
        StringBuilder rep = new StringBuilder("{");
        for (Plant i : list) {
            rep.append(i.getRepresentation());
            rep.append(",");
        }
        if(rep.length() > 1) {
            rep.deleteCharAt(rep.length() - 1);
        }
        rep.append("}");

        return rep.toString();
    }
}
