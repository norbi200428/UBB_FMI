import javax.swing.*;
import java.awt.*;
import java.util.List;

public class View extends JPanel {
    private final List<Virag> flowers;

    public View(List<Virag> flowers) {
        this.flowers = flowers;
        setBackground(new Color(25, 45, 0));
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);

        g.setColor(new Color(139, 69, 19)); // Barna szín a "talajhoz"
        g.fillRect(0, getHeight() - 50, getWidth(), 50);

        for (Virag flower : flowers) {
            int flowerHeight = flower.getHeight();
            int x = flower.getXPosition();
            int y = getHeight() - 50 - flowerHeight;


            g.setColor(Color.GREEN);
            g.fillRect(x, y, 10, flowerHeight);

            g.setColor(Color.RED);
            g.fillOval(x - 10, y - 20, 30, 30);

        }
    }
}

class GardenFrame extends JFrame {
    public GardenFrame(View View, Controller controller) {
        setTitle("Viragoskert");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setResizable(false);
        add(View);
        setSize(600, 400);
        setVisible(true);

        new Thread(controller).start();
    }
}

