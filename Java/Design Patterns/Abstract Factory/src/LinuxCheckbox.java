public class LinuxCheckbox implements Checkbox {
    @Override
    public void render() {
        System.out.println("Rendering a Linux-style checkbox.");
    }

    @Override
    public void toggle() {
        System.out.println("Linux checkbox toggled.");
    }
}
