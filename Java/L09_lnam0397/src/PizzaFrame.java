import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

public class PizzaFrame extends JFrame {
    private final PizzaPanel pizzaPanel;

    public PizzaFrame() throws IOException {
        BufferedImage img = ImageIO.read(new File("img/pizza_base.png"));
        setTitle("Decorator pizza");
        setSize(img.getWidth(),img.getHeight());
        setDefaultCloseOperation(EXIT_ON_CLOSE);

        Pizza pizza = new PizzaBase();

        pizza = new Tomato(pizza);
        pizza = new Salami(pizza);
        pizza = new Mushroom(pizza);
        pizza = new Olive(pizza);
        pizza = new Corn(pizza);

        pizzaPanel = new PizzaPanel(pizza);
        add(pizzaPanel);

        System.out.println("A pizza ara: " + pizza.getPrice());
        System.out.println("A pizza osszetevoi: " + pizza.getIngredients());

        setVisible(true);
    }

    public static void main(String[] args) throws IOException {
        new PizzaFrame();
    }
}
