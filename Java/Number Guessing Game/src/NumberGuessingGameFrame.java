import javax.swing.*;
import java.util.Random;

public class NumberGuessingGameFrame extends JFrame {
    private int targetNum;
    private int attemptsLeft;
    private final int maxAttempts = 7;
    private final int minRange = 1;
    private final int maxRange = 100;

    public NumberGuessingGameFrame() {
        initGame();
    }

    private void initGameLogic() {
        Random random = new Random();
        targetNum = random.nextInt(minRange, maxRange + 1);
        attemptsLeft = maxAttempts;
    }

    private void initGame() {
        initGameLogic();
        createUI();

        setTitle("Number Guessing Game");
        setResizable(false);
        setBounds(250, 250, 500, 500);
        setDefaultCloseOperation(EXIT_ON_CLOSE);
        setVisible(true);
    }

    public String checkGuess(int guess) {
        attemptsLeft--;

        if (guess == targetNum) {
            return "Congrats! You guessed the number in " + (maxAttempts - attemptsLeft) + " attempts";
        } else if (attemptsLeft <= 0) {
            return "Game over! The number was " + targetNum + ".";
        } else if (guess > targetNum) {
            return "Too high! Attempts left: " + attemptsLeft;
        } else {
            return "Too low! Attempts left: " + attemptsLeft;
        }
    }

    private void createUI() {
        add(new NumberGuessingGamePanel(this));
    }

    public void startNewGame() {
        initGameLogic();
        getContentPane().removeAll();
        createUI();
        revalidate();
        repaint();
    }

    public int getMinRange() {
        return minRange;
    }

    public int getMaxRange() {
        return maxRange;
    }

    public int getAttemptsLeft() {
        return attemptsLeft;
    }

    public int getMaxAttempts() {
        return maxAttempts;
    }
}