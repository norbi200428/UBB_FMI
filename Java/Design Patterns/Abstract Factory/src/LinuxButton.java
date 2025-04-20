public class LinuxButton implements Button {

    @Override
    public void render() {
        System.out.println("Rendering a Linux-style button.");
    }

    @Override
    public void onClick() {
        System.out.println("Linux button clicked.");
    }
}
