import javax.imageio.stream.ImageInputStream;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

public class TextFilterFrame extends Frame {
    private TextField textField;
    private TextArea textArea;

    private void filterText() {
        String selectedText = textArea.getSelectedText();

        String wordFiltered = textField.getText();

        if (selectedText != null && !wordFiltered.isEmpty()) {

            String filteredText = selectedText.replace(wordFiltered, "");

            textArea.setText(filteredText);
        } else {
            System.out.println("Select the text and type a word.");
        }
    }

    public TextFilterFrame() {
        setBounds(100, 100, 450, 450);
        setLayout(new FlowLayout());
        setTitle("TextFilterFrame");

        textField = new TextField(50);
        add(textField);

        Button filterButton = new Button("Filter");
        add(filterButton);

        textArea = new TextArea(10, 50);
        textArea.setEditable(true);
        add(textArea);

        filterButton.addActionListener(new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                filterText();
            }

        });

        addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                dispose();
            }
        });

        setVisible(true);

    }

    public static void main(String[] args) {
        new TextFilterFrame();
    }
}
