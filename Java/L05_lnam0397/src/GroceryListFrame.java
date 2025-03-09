import java.awt.*;
import java.awt.event.ActionListener;
import java.awt.event.WindowAdapter;
import java.awt.event.WindowEvent;

public class GroceryListFrame extends Frame {
    private List fruitList;
    private List vegetableList;

    private void transferSelected(List fromList, List toList) {
        String[] selectedItems = fromList.getSelectedItems();

        for (String item : selectedItems) {
            toList.add(item);
            fromList.remove(item);
        }
    }

    public GroceryListFrame() {

        setBounds(100, 100, 450, 450);
        setTitle("GroceryListFrame");
        setLayout(new FlowLayout());

        fruitList = new List(5,true);
        fruitList.add("Alma");
        fruitList.add("Korte");
        fruitList.add("Banan");
        fruitList.add("Malna");
        fruitList.add("Barack");


        vegetableList = new List(5,true);
        vegetableList.add("Kaposzta");
        vegetableList.add("Hagyma");
        vegetableList.add("Salata");
        vegetableList.add("Repa");
        vegetableList.add("Uborka");


        Button toVegetable = new Button("<-");
        toVegetable.addActionListener(e -> transferSelected(fruitList, vegetableList));


        Button toFruit = new Button("->");
        toFruit.addActionListener(e -> transferSelected(vegetableList, fruitList));

        add(vegetableList);
        add(toFruit);
        add(toVegetable);
        add(fruitList);


        addWindowListener(new WindowAdapter() {
            @Override
            public void windowClosing(WindowEvent e) {
                dispose();
            }
        });

        setVisible(true);
    }

    public static void main(String[] args) {
        new GroceryListFrame();
    }
}
