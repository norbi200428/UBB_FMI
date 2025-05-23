import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

public class Salami extends PizzaIngredient{
    private final BufferedImage img;

    public Salami(Pizza pizza) {
        super(pizza);
        try {
            img = ImageIO.read(new File("img/salami.png"));
        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void bake(Graphics g) {
        super.bake(g);
        g.drawImage(img, 0, 0, null);
    }

    @Override
    public int getPrice() {
        return super.getPrice() + 5;
    }

    @Override
    public String getIngredients() {
        return super.getIngredients() + ", Salami";
    }
}
