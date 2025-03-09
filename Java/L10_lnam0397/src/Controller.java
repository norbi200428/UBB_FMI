import java.util.List;
import java.util.Random;

public class Controller implements Runnable {
    private final List<Virag> flowers;
    private final View View;
    private Random random;

    public Controller(List<Virag> flowers, View View) {
        this.flowers = flowers;
        this.View = View;
    }

    @Override
    public void run() {
        random = new Random();
        for (Virag flower : flowers) {
            new Thread(() -> {
                while (flower.getHeight() < flower.getMaxHeight()) {
                    flower.grow(random.nextInt(30) + 1);
                    View.repaint();
                    try {
                        Thread.sleep(random.nextInt(1500));
                    } catch (InterruptedException e) {
                        Thread.currentThread().interrupt();
                    }
                }
            }).start();
        }
    }
}