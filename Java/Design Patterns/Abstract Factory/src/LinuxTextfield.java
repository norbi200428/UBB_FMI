public class LinuxTextfield implements Textfield {
    @Override
    public void render() {
        System.out.println("Rendering a Linux-style text field.");
    }

    @Override
    public void handleInput(String text) {
        System.out.println("Linux text field handling: " + text);
    }
}
