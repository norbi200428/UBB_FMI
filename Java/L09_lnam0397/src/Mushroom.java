import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.File;
import java.io.IOException;

public class Mushroom extends PizzaIngredient{
    private final BufferedImage img;

    public Mushroom(Pizza pizza) {
        super(pizza);
        try {
            img = ImageIO.read(new File("img/mushroom.png"));
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
        return super.getPrice() + 2;
    }

    @Override
    public String getIngredients() {
        return super.getIngredients() + ", Mushroom";
    }
}
