package collection;

import core.Vehicle;

public interface VehicleIterator {
    boolean hasMoreElements();

    Vehicle nextElement();
}
