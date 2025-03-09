import javax.swing.*;
import java.awt.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Random;

public class Main{
    public static void main(String[] args) {
        List<Virag> flowers = new ArrayList<>();
        Random random = new Random();

        for (int i = 0; i < 5; i++) {
            flowers.add(new Virag(50 + i * 50, 100 + random.nextInt(150)));
        }

        View gardenPanel = new View(flowers);
        Controller controller = new Controller(flowers, gardenPanel);
        new GardenFrame(gardenPanel, controller);
    }
}
