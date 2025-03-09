import javax.swing.*;
import java.awt.*;

public class MovePanel extends JPanel {
    private int pozX;
    private int pozY;
    private final int d = 70;

    public MovePanel() {
        this.pozX = 100;
        this.pozY = 100;
    }

    @Override
    protected void paintComponent(Graphics g) {
        super.paintComponent(g);
        g.setColor(Color.RED);
        g.fillOval(pozX, pozY, d, d);
    }

    public void moveUp() {
        if (pozY - 10 >= 0) {
            pozY -= 10;
            repaint();
        }
    }

    public void moveDown() {
        if (pozY < getHeight() - d - 10) {
            pozY += 10;
            repaint();
        }
    }

    public void moveRight() {
        if (pozX < getWidth() - d - 10) {
            pozX += 10;
            repaint();
        }
    }

    public void moveLeft() {
        if (pozX - 10 >= 0) {
            pozX -= 10;
            repaint();
        }
    }
}

