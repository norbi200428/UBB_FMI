import javax.swing.*;
import java.awt.*;
import java.awt.event.ActionEvent;
import java.awt.event.ActionListener;

public class NumberGuessingGamePanel extends JPanel {
    private final NumberGuessingGameFrame gameFrame;
    private JTextField guessField;
    private JLabel msgLabel;
    private JLabel attemptsLabel;
    private JLabel rangeLabel;
    private JButton submitButton;
    private JButton newGameButton;

    public NumberGuessingGamePanel(NumberGuessingGameFrame gameFrame) {
        this.gameFrame = gameFrame;
        setupComponents();
        setupLayout();
        setupListeners();
    }

    private void setupComponents() {
        guessField = new JTextField(10);
        msgLabel = new JLabel("Guess a number between: " + gameFrame.getMinRange() + " and " + gameFrame.getMaxRange());
        attemptsLabel = new JLabel("Attempts left: " + gameFrame.getAttemptsLeft() + "/" + gameFrame.getMaxAttempts());
        rangeLabel = new JLabel("Range: " + gameFrame.getMinRange() + "-" + gameFrame.getMaxRange());
        submitButton = new JButton("Submit");
        submitButton.setActionCommand("Submit");
        newGameButton = new JButton("Start new game");
        newGameButton.setActionCommand("New");
    }

    private void setupLayout() {
        setLayout(new GridBagLayout());
        GridBagConstraints gbc = new GridBagConstraints();
        gbc.insets = new Insets(5, 5, 5, 5);
        gbc.gridx = 0;
        gbc.gridy = 0;
        gbc.gridwidth = 2;
        add(msgLabel, gbc);

        gbc.gridy = 1;
        add(attemptsLabel, gbc);

        gbc.gridy = 2;
        add(rangeLabel, gbc);

        gbc.gridy = 3;
        gbc.gridwidth = 1;
        add(new JLabel("Your guess: "), gbc);

        gbc.gridx = 1;
        add(guessField, gbc);

        gbc.gridx = 0;
        gbc.gridy = 4;
        gbc.gridwidth = 2;
        add(submitButton, gbc);

        gbc.gridy = 5;
        add(newGameButton, gbc);
    }

    private void setupListeners() {
        ActionListener buttonListener = new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                if (e.getActionCommand().equals("Submit")) {
                    try {
                        int guess = Integer.parseInt(guessField.getText());
                        if (guess < gameFrame.getMinRange() || guess > gameFrame.getMaxRange()) {
                            JOptionPane.showMessageDialog(gameFrame, "Please enter a number in the given range.");
                            return;
                        }

                        String result = gameFrame.checkGuess(guess);
                        msgLabel.setText(result);
                        attemptsLabel.setText("Attempts left: " + gameFrame.getAttemptsLeft() + "/" + gameFrame.getMaxAttempts());
                        guessField.setText("");

                        if (result.contains("Congrats") || result.contains("Game over")) {
                            guessField.setEnabled(false);
                        }
                    } catch (NumberFormatException exception) {
                        JOptionPane.showMessageDialog(gameFrame, "Please enter a valid number in the given range.");
                    }
                } else if (e.getActionCommand().equals("New")) {
                    gameFrame.startNewGame();
                }
            }
        };

        for (Component component : getComponents()) {
            if (component instanceof JButton) {
                ((JButton) component).addActionListener(buttonListener);
            }
        }
    }
}