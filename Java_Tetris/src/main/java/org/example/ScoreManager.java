package org.example;

public class ScoreManager {
    private int score;
    private int level;
    private long gameStartTime;
    private static final int[] SCORE_MULTIPLIERS = {0, 40, 100, 300, 1200};
    private static final int INITIAL_SPEED = 800;
    private static final int MIN_SPEED = 50;

    public ScoreManager() {
        resetScore();
    }

    public void resetScore() {
        score = 0;
        level = 1;
        gameStartTime = System.currentTimeMillis();
    }

    public void updateScore(int linesCleared) {
        if (linesCleared > 0) {
            score += SCORE_MULTIPLIERS[linesCleared];
            int newLevel = (score / 500) + 1;
            level = newLevel;
            updateGameSpeed();
        }
    }

    public int getGameSpeed() {
        int speed = (int)(INITIAL_SPEED * Math.pow(0.75, level - 1));
        return Math.max(speed, MIN_SPEED);
    }

    private void updateGameSpeed() {
        System.out.println("Speed updated to: " + getGameSpeed() + "ms (Level " + level + ")");
    }

    public int getScore() {
        return score;
    }

    public int getLevel() {
        return level;
    }

    public void setScore(int score) {
        this.score = score;
    }

    public void setLevel(int level) {
        this.level = level;
    }
}