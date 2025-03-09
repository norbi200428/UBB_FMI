package collection;

import core.*;

public class MyHashMap {
    private Entry[] entries;

    public MyHashMap(Integer size) {
        entries = new Entry[size];
    }

    public void put(Integer key, Car value) {
        if (key >= 1000 && key <= 9999 && !containsKey(key)) {
            Entry ujElem = new Entry(key, value, entries[hashFunction(key)]);
            entries[hashFunction(key)] = ujElem;
        } else {
            System.out.println("Mar letezik ilyen kulcsu auto, vagy nem megfelelo a kulcs.");
        }
    }

    public Car get(Integer key) {
        if (key >= 1000 && key <= 9999) {
            Entry ujElem = entries[hashFunction(key)];
            while (ujElem != null) {
                if (ujElem.getKey().equals(key)) {
                    return ujElem.getValue();
                }
                ujElem = ujElem.getNext();
            }
        }
        return null;
    }

    public boolean containsKey(Integer key) {
//        Entry ujElem = entries[hashFunction(key)];
//        while (ujElem != null) {
//            if (ujElem.getKey().equals(key)) {
//                return true;
//            }
//            ujElem = ujElem.getNext();
//        }
//        return false;
        return get(key) != null;
    }


    private int hashFunction(Integer key) {
        return key % entries.length;
    }


}
