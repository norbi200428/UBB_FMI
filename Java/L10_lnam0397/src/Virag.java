public class Virag {
    private int height;
    private final int maxHeight;
    private final int xPosition;

    public Virag(int xPosition, int maxHeight) {
        this.height = 0;
        this.maxHeight = maxHeight;
        this.xPosition = xPosition;
    }

    public int getHeight() {
        return height;
    }

    public void grow(int amount) {
        if (height + amount < maxHeight) {
            height += amount;
        } else {
            height = maxHeight;
        }
    }

    public int getMaxHeight() {
        return maxHeight;
    }

    public int getXPosition() {
        return xPosition;
    }
}