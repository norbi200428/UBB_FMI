public class WindowsTextfield implements Textfield {
    @Override
    public void render() {
        System.out.println("Rendering a Windows-style text field.");
    }

    @Override
    public void handleInput(String text) {
        System.out.println("Windows text field handling: " + text);
    }
}
