package collection;

import core.Vehicle;

public class VehicleList {
    private int current;
    private Vehicle[] vehicles;

    public VehicleList(int size) {
        vehicles = new Vehicle[size];
        current = 0;
    }

    public void addVehicle(Vehicle vehicle) {
        if (current < vehicles.length) {
            vehicles[current++] = vehicle;
        } else {
            System.out.println("There's no space left in the list.");
        }
    }

    public class VehicleForwardIterator implements VehicleIterator {
        private int index;

        public VehicleForwardIterator() {
            index = 0;
        }

        @Override
        public boolean hasMoreElements() {
            return index < current;
        }

        @Override
        public Vehicle nextElement() {
            return vehicles[index++];
        }
    }

    class VehicleBackwardIterator implements VehicleIterator {
        private int index;

        public VehicleBackwardIterator() {
            index = current - 1;
        }

        @Override
        public boolean hasMoreElements() {
            return index >= 0;
        }

        @Override
        public Vehicle nextElement() {
            return vehicles[index--];
        }
    }

    public VehicleIterator getForwardIterator() {
        return new VehicleForwardIterator();
    }

    public VehicleIterator getBackwardIterator() {
        return new VehicleBackwardIterator();
    }
}


