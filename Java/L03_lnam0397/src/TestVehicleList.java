import collection.*;
import core.*;

public class TestVehicleList {
    public static void main(String[] args) {

        Vehicle repulo1 = new Airplane("Boening", 5, 10);
        Vehicle repulo2 = new Airplane("Lufthansa", 15, 20);
        Vehicle car1 = new Car("VW", 5);
        Vehicle car2 = new Car("BMW", 15);

        VehicleList lista = new VehicleList(40);
        lista.addVehicle(repulo1);
        lista.addVehicle(repulo2);
        lista.addVehicle(car1);
        lista.addVehicle(car2);

        VehicleIterator forwardIterator = lista.getForwardIterator();
        System.out.println();
        while (forwardIterator.hasMoreElements()) {
            Vehicle v = forwardIterator.nextElement();
            System.out.println(v);
            v.numberOfWheels();
        }

        System.out.println();

        VehicleIterator backwardIterator = lista.getBackwardIterator();
        System.out.println();
        while (backwardIterator.hasMoreElements()) {
            Vehicle v = backwardIterator.nextElement();
            System.out.println(v);
            v.numberOfWheels();
        }
    }
}