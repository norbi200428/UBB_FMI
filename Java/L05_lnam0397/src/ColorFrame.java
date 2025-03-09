import java.awt.*;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;
import java.util.Random;

public class ColorFrame extends Frame {

    private Choice colorChoice;
    private Random rand;

    public ColorFrame() {
        setBounds(100, 100, 450, 300);
        setLayout(new FlowLayout());
        setTitle("ColorFrame");

        rand = new Random();

        colorChoice = new Choice();
        colorChoice.add("red");
        colorChoice.add("green");
        colorChoice.add("blue");
        colorChoice.add("random");

        colorChoice.addItemListener(new ItemListener() {
            @Override
            public void itemStateChanged(ItemEvent e) {
                String selectedColor = colorChoice.getSelectedItem();

                switch (selectedColor) {
                    case "red":
                        setBackground(Color.RED);
                        break;
                    case "green":
                        setBackground(Color.GREEN);
                        break;
                    case "blue":
                        setBackground(Color.BLUE);
                        break;
                    case "random":
                        Color randColor = new Color(rand.nextInt(256), rand.nextInt(256), rand.nextInt(256));
                        setBackground(randColor);
                        break;
                }
            }
        });

        addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                dispose();
            }
        });
        add(colorChoice);
        setVisible(true);
    }


    public static void main(String[] args) {
        new ColorFrame();
    }
}

