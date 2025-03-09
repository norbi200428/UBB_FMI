import javax.swing.*;
import java.awt.*;
import java.awt.event.MouseAdapter;
import java.awt.event.MouseEvent;
import java.util.Random;

public class PushFrame extends JFrame {
    private JButton button;
    private Random rand;

    public PushFrame() {
        setTitle("Push me! game");
        setLayout(null);
        setResizable(true);
        setBounds(100, 100, 400, 400);
        setMinimumSize(new Dimension(200, 200));
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);

        button = new JButton("Push me!");
        button.setBounds(50, 50, 100, 50);
        add(button);

        rand = new Random();
        button.addMouseListener(new MouseAdapter() {
            @Override
            public void mouseEntered(MouseEvent e) {
                int randX, randY;
                do {
                    randX = rand.nextInt(getContentPane().getWidth() - button.getWidth());
                    randY = rand.nextInt(getContentPane().getHeight() - button.getHeight());
                } while (randX <= e.getX() + button.getX() && e.getX() + button.getX() <= randX + button.getWidth()
                        && randY <= e.getY() + button.getY() && e.getY() + button.getY() <= randY + button.getHeight());

                button.setLocation(randX, randY);
            }

        });
        setVisible(true);
    }


    public static void main(String[] args) {
        new PushFrame();
    }
}
