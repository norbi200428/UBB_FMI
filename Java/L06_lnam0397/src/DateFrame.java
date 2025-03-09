import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.time.LocalDate;
import java.time.LocalDateTime;

public class DateFrame extends JFrame {
    private JLabel label;
    private JButton button;

    public DateFrame() {
        setDefaultCloseOperation(DISPOSE_ON_CLOSE);
        setBounds(100, 100, 450, 450);
        setLayout(new FlowLayout());

        label = new JLabel("Click the button!");
        add(label);

        button = new JButton("Date button");

        button.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                label.setText(String.valueOf(LocalDateTime.now()));
            }
        });

        add(button);
        setVisible(true);
    }

    public static void main(String[] args) {
        new DateFrame();
    }

}
