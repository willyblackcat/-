package org.example;

import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;
import static org.junit.jupiter.api.Assertions.assertEquals;

public class ScoreManagerTest {
    private ScoreManager scoreManager;

    @BeforeEach
    void setUp() {
        // Ensure scoreManager is always initialized
        scoreManager = new ScoreManager();
    }

    @Test
    void testInitialScoreAndLevel() {
        assertEquals(0, scoreManager.getScore(), "Initial score should be 0");
        assertEquals(1, scoreManager.getLevel(), "Initial level should be 1");
    }

    @Test
    void testUpdateScoreWithNoLinesCleared() {
        scoreManager.updateScore(0);
        assertEquals(0, scoreManager.getScore(), "Score should remain 0 when no lines are cleared");
    }

    @Test
    void testUpdateScoreWithSingleLineCleared() {
        scoreManager.updateScore(1);
        assertEquals(40, scoreManager.getScore(), "Score should be 40 for a single line clear");
    }

    @Test
    void testUpdateScoreWithMultipleLinesCleared() {
        scoreManager.updateScore(2);
        assertEquals(100, scoreManager.getScore(), "Score should be 100 for two lines cleared");
        scoreManager.updateScore(3);
        assertEquals(400, scoreManager.getScore(), "Score should be 400 for three lines cleared");
        scoreManager.updateScore(4);
        assertEquals(1600, scoreManager.getScore(), "Score should be 1600 for four lines cleared");
    }

    @Test
    void testLevelProgression() {
        for (int i = 0; i < 10; i++) {
            scoreManager.updateScore(4); // Each update adds 1200 points
        }
        assertEquals(25, scoreManager.getLevel(), "Level should progress correctly");
    }

    @Test
    void testUpdateScoreIncreasesScore() {
        scoreManager.updateScore(1); // Clear one line
        assertEquals(40, scoreManager.getScore(), "Score should be 40 for a single line clear");
        scoreManager.updateScore(2); // Clear two lines
        assertEquals(140, scoreManager.getScore(), "Score should be 140 for two lines cleared");
        scoreManager.updateScore(3); // Clear three lines
        assertEquals(440, scoreManager.getScore(), "Score should be 440 for three lines cleared");
        scoreManager.updateScore(4); // Clear four lines
        assertEquals(1640, scoreManager.getScore(), "Score should be 1640 for four lines cleared");
    }

    @Test
    void testUpdateGameSpeed() {
        // Initial speed should be 500
        assertEquals(800, scoreManager.getGameSpeed(), "Initial game speed should be 500ms");

        // Clear 4 lines to level up
        scoreManager.updateScore(4);
        assertEquals(450, scoreManager.getGameSpeed(), "Game speed should be updated after leveling up");

        // Clear 4 lines again to level up
        scoreManager.updateScore(4);
        assertEquals(253, scoreManager.getGameSpeed(), "Game speed should be updated after leveling up");

        // Continue clearing lines to reach higher levels
        for (int i = 0; i < 10; i++) {
            scoreManager.updateScore(4); // Each update adds 1200 points
        }
        assertEquals(50, scoreManager.getGameSpeed(), "Game speed should be updated after leveling up");
    }

    @Test
    void testSetScore() {
        scoreManager.setScore(100);
        assertEquals(100, scoreManager.getScore());
    }

    @Test
    void testSetLevel() {
        scoreManager.setLevel(2);
        assertEquals(2, scoreManager.getLevel());
    }
}