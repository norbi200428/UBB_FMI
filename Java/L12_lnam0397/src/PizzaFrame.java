import javax.imageio.ImageIO;
import javax.swing.*;
import java.awt.*;
import java.awt.event.ItemEvent;
import java.awt.event.ItemListener;
import java.awt.image.BufferedImage;
import java.io.*;
import java.util.ArrayList;
import java.util.List;

public class PizzaFrame extends JFrame {
    private PizzaPanel pizzaPanel;
    private JLabel priceLabel;
    private JLabel ingredientsLabel;
    private JCheckBox tomatoBox, salamiBox, mushroomBox, oliveBox, cornBox;
    private Pizza currentPizza;

    public PizzaFrame() throws IOException {
        currentPizza = new PizzaBase();
        pizzaPanel = new PizzaPanel(currentPizza);

        setLayout(new BorderLayout());
        add(pizzaPanel, BorderLayout.CENTER);

        // Kontrollpanel hozzávalókhoz
        JPanel controlPanel = new JPanel();
        controlPanel.setLayout(new GridLayout(6,6));
        controlPanel.setPreferredSize(new Dimension(500,500));

        tomatoBox = createCheckbox("Tomato");
        salamiBox = createCheckbox("Salami");
        mushroomBox = createCheckbox("Mushroom");
        oliveBox = createCheckbox("Olive");
        cornBox = createCheckbox("Corn");

        controlPanel.add(tomatoBox);
        controlPanel.add(salamiBox);
        controlPanel.add(mushroomBox);
        controlPanel.add(oliveBox);
        controlPanel.add(cornBox);


        priceLabel = new JLabel("Price: " + currentPizza.getPrice());
        ingredientsLabel = new JLabel("Ingredients: " + currentPizza.getIngredients());
        controlPanel.add(priceLabel);
        controlPanel.add(ingredientsLabel);

        add(controlPanel, BorderLayout.EAST);

        JMenuBar menuBar = new JMenuBar();
        JMenu fileMenu = new JMenu("File");
        JMenuItem saveItem = new JMenuItem("Save");
        JMenuItem loadItem = new JMenuItem("Load");

        saveItem.addActionListener(e -> savePizza());
        loadItem.addActionListener(e -> loadPizza());

        fileMenu.add(saveItem);
        fileMenu.add(loadItem);
        menuBar.add(fileMenu);
        setJMenuBar(menuBar);

        setTitle("Pizza Game");
        setSize(1000, 1000);
        setResizable(false);
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setVisible(true);
    }

    private JCheckBox createCheckbox(String ingredient) {
        JCheckBox box = new JCheckBox(ingredient);
        box.addItemListener(new ItemListener() {
            @Override
            public void itemStateChanged(ItemEvent e) {
                updatePizza(ingredient, e.getStateChange() == ItemEvent.SELECTED);
            }
        });
        return box;
    }

    private void updatePizza(String ingredient, boolean add) {
        switch (ingredient) {
            case "Tomato":
                currentPizza = add ? new Tomato(currentPizza) : removeIngredient("Tomato");
                break;
            case "Salami":
                currentPizza = add ? new Salami(currentPizza) : removeIngredient("Salami");
                break;
            case "Mushroom":
                currentPizza = add ? new Mushroom(currentPizza) : removeIngredient("Mushroom");
                break;
            case "Olive":
                currentPizza = add ? new Olive(currentPizza) : removeIngredient("Olive");
                break;
            case "Corn":
                currentPizza = add ? new Corn(currentPizza) : removeIngredient("Corn");
                break;
        }

        pizzaPanel.setPizza(currentPizza);
        updateLabels();
    }

    private Pizza removeIngredient(String ingredient) {
        Pizza base = new PizzaBase();
        List<String> ingredients = List.of(currentPizza.getIngredients().split(", "));
        for (String ing : ingredients) {
            if (!ing.equals("Pizza base") && !ing.equals(ingredient)) {
                switch (ing) {
                    case "Tomato":
                        base = new Tomato(base);
                        break;
                    case "Salami":
                        base = new Salami(base);
                        break;
                    case "Mushroom":
                        base = new Mushroom(base);
                        break;
                    case "Olive":
                        base = new Olive(base);
                        break;
                    case "Corn":
                        base = new Corn(base);
                        break;
                }
            }
        }
        return base;
    }

    private void updateLabels() {
        priceLabel.setText("Price: " + currentPizza.getPrice());
        ingredientsLabel.setText("Ingredients " + currentPizza.getIngredients());
    }

    private void savePizza() {
        JFileChooser fileChooser = new JFileChooser();
        if (fileChooser.showSaveDialog(this) == JFileChooser.APPROVE_OPTION) {
            File file = fileChooser.getSelectedFile();
            try (BufferedWriter writer = new BufferedWriter(new FileWriter(file))) {
                writer.write(currentPizza.getIngredients());
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void loadPizza() {
        JFileChooser fileChooser = new JFileChooser();
        if (fileChooser.showOpenDialog(this) == JFileChooser.APPROVE_OPTION) {
            File file = fileChooser.getSelectedFile();
            try (BufferedReader reader = new BufferedReader(new FileReader(file))) {
                String ingredients = reader.readLine();
                resetPizza();
                for (String ingredient : ingredients.split(", ")) {
                    if (!ingredient.equals("Pizza base")) {
                        switch (ingredient) {
                            case "Tomato":
                                tomatoBox.setSelected(true);
                                break;
                            case "Salami":
                                salamiBox.setSelected(true);
                                break;
                            case "Mushroom":
                                mushroomBox.setSelected(true);
                                break;
                            case "Olive":
                                oliveBox.setSelected(true);
                                break;
                            case "Corn":
                                cornBox.setSelected(true);
                                break;
                        }
                    }
                }
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }

    private void resetPizza() {
        currentPizza = new PizzaBase();
        tomatoBox.setSelected(false);
        salamiBox.setSelected(false);
        mushroomBox.setSelected(false);
        oliveBox.setSelected(false);
        cornBox.setSelected(false);
        pizzaPanel.setPizza(currentPizza);
        updateLabels();
    }

    public static void main(String[] args) throws IOException {
        new PizzaFrame();
    }
}