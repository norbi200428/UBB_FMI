import javax.naming.OperationNotSupportedException;

public class Main {
    public static void main(String[] args) throws OperationNotSupportedException {
        String myOS = System.getProperty("os.name").toLowerCase();
        UIFactory myFactory;
        
        if (myOS.contains("linux")) {
            myFactory = new LinuxUIFactory();
            System.out.println("Creating Linux UI components ...");
        } else if (myOS.contains("win")) {
            myFactory = new WindowsUIFactory();
            System.out.println("Creating Windows UI components ...");
        } else {
            throw new OperationNotSupportedException("OS not supported.");
        }

        DocumentEditor documentEditor = new DocumentEditor(myFactory);
        documentEditor.createUI();
        documentEditor.renderUI();
        documentEditor.simulateUI();
    }
}
