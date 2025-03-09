package core;

public class Airplane implements Vehicle {
    private String type;
    private int age;
    private float length;

    public Airplane(String type, int age, float length) {
        this.type = type;
        this.age = age;
        this.length = length;
    }

    public String toString() {
        return "Airplane [type=" + type + ", age=" + age + ", length=" + length + "]";
    }

    @Override
    public void numberOfWheels() {
        System.out.println("The airplane has 6 wheels.");
    }
}
