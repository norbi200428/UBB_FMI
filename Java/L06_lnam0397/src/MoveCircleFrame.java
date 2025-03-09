import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class MoveCircleFrame extends JFrame {
    private Button upArrow;
    private Button downArrow;
    private Button leftArrow;
    private Button rightArrow;
    private MovePanel myPanel;

    public MoveCircleFrame() {
        setBounds(100, 100, 450, 450);
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);
        setLayout(new BorderLayout());
        setResizable(false);

        myPanel = new MovePanel();
        add(myPanel, BorderLayout.CENTER);

        upArrow = new Button("↑");
        add(upArrow, BorderLayout.NORTH);
        upArrow.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                myPanel.moveUp();
            }
        });

        downArrow = new Button("↓");
        add(downArrow, BorderLayout.SOUTH);
        downArrow.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                myPanel.moveDown();
            }
        });

        leftArrow = new Button("←");
        add(leftArrow, BorderLayout.WEST);
        leftArrow.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                myPanel.moveLeft();
            }
        });

        rightArrow = new Button("→");
        add(rightArrow, BorderLayout.EAST);
        rightArrow.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                myPanel.moveRight();
            }
        });

        setVisible(true);
    }

    public static void main(String[] args) {
        new MoveCircleFrame();
    }
}
