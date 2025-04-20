public class DocumentEditor {
    private UIFactory uiFactory;
    private Button saveButton;
    private Checkbox checkBox;
    private Textfield textField;

    public DocumentEditor(UIFactory uiFactory) {
        this.uiFactory = uiFactory;
    }

    public void createUI() {
        saveButton = uiFactory.createButton();
        checkBox = uiFactory.createCheckbox();
        textField = uiFactory.createTextfield();
    }

    public void renderUI() {
        System.out.println("\nRendering Document Editor UI:");
        saveButton.render();
        checkBox.render();
        textField.render();
    }

    public void simulateUI() {
        System.out.println("\nSimulating Document Editor UI:");
        saveButton.onClick();
        checkBox.toggle();
        textField.handleInput("New Document created.");
    }
}