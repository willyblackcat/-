package org.example;

import java.awt.*;
import java.awt.event.*;
import javax.swing.*;
import javax.swing.border.TitledBorder;
import java.util.Random;

public class TetrisGame extends JFrame {
    private static final int BOARD_WIDTH = 10;
    private static final int BOARD_HEIGHT = 20;
    private static final int BLOCK_SIZE = 35;
    private static final int PREVIEW_SIZE = 6;

    private TetrisBoard board;
    private Timer gameTimer;
    private Tetromino currentTetromino;
    private int score;
    private JLabel scoreLabel;
    private Tetromino nextTetromino;
    private int level = 1;
    private Tetromino ghostPiece;
    private TetrominoType[] tetrominoBag;
    private int currentBagIndex;
    private Tetromino savedTetromino; // 儲存的方塊
    private boolean hasSavedTetromino = false; // 標記是否已經儲存過方塊
    private boolean hasSwapped = true;
    private ScoreManager scoreManager;  // 新增這行

    public TetrisGame() {
        initializeGame();
        setupGameUI();
        setupGameLogic();
    }

    private void initializeGame() {
        setTitle("Tetris Game");
        setDefaultCloseOperation(JFrame.EXIT_ON_CLOSE);
        setResizable(false);
        board = new TetrisBoard(BOARD_WIDTH, BOARD_HEIGHT);
        scoreManager = new ScoreManager();  // 初始化 ScoreManager
        scoreLabel = new JLabel("Score: 0");
        scoreLabel.setFont(new Font("Arial", Font.BOLD, 24));
        scoreLabel.setForeground(Color.WHITE);
        level = 1;
        initializeTetrominoBag();
        currentBagIndex = 0;
    }

    private void initializeTetrominoBag() {
        tetrominoBag = new TetrominoType[7];
        TetrominoType[] types = TetrominoType.values();
        System.arraycopy(types, 0, tetrominoBag, 0, types.length);
        shuffleBag();
    }

    private void shuffleBag() {
        Random random = new Random();
        for (int i = tetrominoBag.length - 1; i > 0; i--) {
            int index = random.nextInt(i + 1);
            TetrominoType temp = tetrominoBag[index];
            tetrominoBag[index] = tetrominoBag[i];
            tetrominoBag[i] = temp;
        }
    }

    private Tetromino createRandomTetromino() {
        TetrominoType nextType = tetrominoBag[currentBagIndex];
        currentBagIndex++;

        if (currentBagIndex >= tetrominoBag.length) {
            shuffleBag();
            currentBagIndex = 0;
        }

        return new Tetromino(nextType, BOARD_WIDTH / 2 - 1, 0);
    }

    private void setupGameUI() {
        setLayout(new BorderLayout(10, 10));

        JPanel sidePanel = new JPanel(new BorderLayout(0, 20));
        sidePanel.setPreferredSize(new Dimension(PREVIEW_SIZE * BLOCK_SIZE + 20, BOARD_HEIGHT * BLOCK_SIZE));
        sidePanel.setBackground(Color.BLACK);

        JPanel previewPanel = new PreviewPanel();
        sidePanel.add(previewPanel, BorderLayout.NORTH);

        JPanel savedPanel = new JPanel();
        savedPanel.setPreferredSize(new Dimension(BLOCK_SIZE * 4, BLOCK_SIZE * 4));
        savedPanel.setBackground(Color.GRAY);
        sidePanel.add(savedPanel, BorderLayout.CENTER);

        JPanel scorePanel = new JPanel();
        scorePanel.setBackground(Color.BLACK);
        scorePanel.add(scoreLabel);
        sidePanel.add(scorePanel, BorderLayout.SOUTH);

        JPanel gamePanel = new JPanel(new BorderLayout());
        gamePanel.setBorder(BorderFactory.createEmptyBorder(10, 10, 10, 10));
        gamePanel.add(board, BorderLayout.CENTER);

        add(gamePanel, BorderLayout.CENTER);
        add(sidePanel, BorderLayout.EAST);

        ((JPanel) getContentPane()).setBorder(
                BorderFactory.createEmptyBorder(20, 20, 20, 20)
        );

        pack();
        setLocationRelativeTo(null);
    }

    private void setupGameLogic() {
        gameTimer = new Timer(scoreManager.getGameSpeed(), new ActionListener() {
            @Override
            public void actionPerformed(ActionEvent e) {
                moveTetrominoDown();
            }
        });

        addKeyListener(new KeyAdapter() {
            @Override
            public void keyPressed(KeyEvent e) {
                handleKeyPress(e);
            }
        });

        startNewGame();
    }

    private void startNewGame() {
        board.clearBoard();
        score = 0;
        updateScoreDisplay();
        nextTetromino = createRandomTetromino();
        spawnNewTetromino();
        gameTimer.setDelay(scoreManager.getGameSpeed());
        gameTimer.start();
        requestFocusInWindow();
    }

    private void spawnNewTetromino() {
        currentTetromino = nextTetromino;
        nextTetromino = createRandomTetromino();
        hasSwapped = false;

        // 檢查當前方塊的 Y 坐標是否超過可容納的最高處
        if (currentTetromino.getY() < 0) { // 如果 Y 坐標小於 0，則遊戲結束
            gameOver();
        } else if (!board.canPlaceTetromino(currentTetromino)) {
            gameOver();
        }
        repaint();
    }

    private void moveTetrominoDown() {
        Tetromino newPosition = new Tetromino(currentTetromino);
        newPosition.moveDown();

        if (board.canPlaceTetromino(newPosition)) {
            currentTetromino = newPosition;
        } else {
            board.placeTetromino(currentTetromino);
            int linesCleared = board.checkAndClearLines();
            updateScore(linesCleared);
            spawnNewTetromino();
            gameTimer.setDelay(scoreManager.getGameSpeed());
        }

        board.repaint();
    }

    private void updateGhostPiece() {
        if (currentTetromino == null) return;

        ghostPiece = new Tetromino(currentTetromino);
        while (isValidMove(ghostPiece.getX(), ghostPiece.getY() + 1, ghostPiece.getCurrentShape())) {
            ghostPiece.moveDown();
        }
    }

    private boolean isValidMove(int newX, int newY, int[][] shape) {
        for (int row = 0; row < shape.length; row++) {
            for (int col = 0; col < shape[row].length; col++) {
                if (shape[row][col] == 1) {
                    int x = newX + col;
                    int y = newY + row;

                    if (x < 0 || x >= BOARD_WIDTH || y >= BOARD_HEIGHT) {
                        return false;
                    }

                    if (y >= 0 && board.boardState[y][x] == 1) {
                        return false;
                    }
                }
            }
        }
        return true;
    }

    private void handleKeyPress(KeyEvent e) {
        Tetromino newPosition = new Tetromino(currentTetromino);

        switch (e.getKeyCode()) {
            case KeyEvent.VK_LEFT:
                newPosition.moveLeft();
                break;
            case KeyEvent.VK_RIGHT:
                newPosition.moveRight();
                break;
            case KeyEvent.VK_DOWN:
                newPosition.moveDown();
                break;
            case KeyEvent.VK_UP:
                if (board.canRotateTetromino(currentTetromino)) {
                    newPosition.rotate();
                }
                break;
            case KeyEvent.VK_Z:  // 添加 Z 鍵進行反向旋轉
                if (board.canRotateTetromino(currentTetromino)) {
                    newPosition.rotateReverse();
                }
                break;
            case KeyEvent.VK_SPACE:
                hardDrop();
                return;
            case KeyEvent.VK_C:  // 按下 C 鍵儲存或交換方塊
                if (!hasSavedTetromino) {
                    savedTetromino = new Tetromino(currentTetromino); // 儲存當前方塊
                    hasSavedTetromino = true; // 標記為已儲存
                    System.out.println("Tetromino saved!");
                    spawnNewTetromino(); // 生成下一個方塊
                    hasSwapped = true;
                } else if (!hasSwapped){
                    Tetromino temp = currentTetromino; // 交換當前方塊和儲存的方塊
                    currentTetromino = savedTetromino;
                    savedTetromino = temp;
                    currentTetromino.setX(BOARD_WIDTH / 2 - 1); // 設置為預設 X 坐標
                    currentTetromino.setY(0); // 設置為預設 Y 坐標
                    hasSwapped = true;
                    System.out.println("Swapped with saved tetromino!");
                }
                return;
        }

        if (board.canPlaceTetromino(newPosition)) {
            currentTetromino = newPosition;
            updateGhostPiece();
            board.repaint();
        }
    }

    private void hardDrop() {
        while (board.canPlaceTetromino(new Tetromino(currentTetromino).moveDown())) {
            currentTetromino.moveDown();
        }

        board.placeTetromino(currentTetromino);
        int linesCleared = board.checkAndClearLines();
        updateScore(linesCleared);
        spawnNewTetromino();
        board.repaint();
    }

    private void updateScore(int linesCleared) {
        int oldLevel = scoreManager.getLevel();
        scoreManager.updateScore(linesCleared);

        // 如果等級改變，立即更新遊戲速度
        if (oldLevel != scoreManager.getLevel()) {
            gameTimer.setDelay(scoreManager.getGameSpeed());
        }

        updateScoreDisplay();
    }

    private void updateScoreDisplay() {
        scoreLabel.setText(String.format("Score: %d | Level: %d",
                scoreManager.getScore(),
                scoreManager.getLevel()));
    }

    private void gameOver() {
        gameTimer.stop();
        UIManager.put("OptionPane.messageFont", new Font("Arial", Font.BOLD, 20));
        UIManager.put("OptionPane.buttonFont", new Font("Arial", Font.BOLD, 16));

        int choice = JOptionPane.showConfirmDialog(
                this,
                "Game Over!\nYour score: " + scoreManager.getScore() + "\nDo you want to restart?",
                "Game Over",
                JOptionPane.YES_NO_OPTION
        );

        if (choice == JOptionPane.YES_OPTION) {
            scoreManager.setScore(0);
            scoreManager.setLevel(1);
            startNewGame();
        } else {
            System.exit(0);
        }
    }

    public static void main(String[] args) {
        SwingUtilities.invokeLater(() -> {
            new TetrisGame().setVisible(true);
        });
    }

    // Tetromino Type Enum
    private enum TetrominoType {
        I(new int[][][]{
                {{1, 1, 1, 1}},
                {{1}, {1}, {1}, {1}}
        }),
        O(new int[][][]{
                {{1, 1}, {1, 1}}
        }),
        T(new int[][][]{
                {{0, 1, 0}, {1, 1, 1}},
                {{1, 0}, {1, 1}, {1, 0}},
                {{1, 1, 1}, {0, 1, 0}},
                {{0, 1}, {1, 1}, {0, 1}}
        }),
        L(new int[][][]{
                {{1, 0}, {1, 0}, {1, 1}},
                {{1, 1, 1}, {1, 0, 0}},
                {{1, 1}, {0, 1}, {0, 1}},
                {{0, 0, 1}, {1, 1, 1}}
        }),
        J(new int[][][]{
                {{0, 1}, {0, 1}, {1, 1}},
                {{1, 0, 0}, {1, 1, 1}},
                {{1, 1}, {1, 0}, {1, 0}},
                {{1, 1, 1}, {0, 0, 1}}
        }),
        S(new int[][][]{
                {{0, 1, 1}, {1, 1, 0}},
                {{1, 0}, {1, 1}, {0, 1}}
        }),
        Z(new int[][][]{
                {{1, 1, 0}, {0, 1, 1}},
                {{0, 1}, {1, 1}, {1, 0}}
        });

        private final int[][][] shapes;

        TetrominoType(int[][][] shapes) {
            this.shapes = shapes;
        }

        public int[][][] getShapes() {
            return shapes;
        }
    }

    // Tetromino Class
    private class Tetromino {
        private int x, y;
        private TetrominoType type;
        private int currentRotation;

        public Tetromino(TetrominoType type, int startX, int startY) {
            this.type = type;
            this.x = startX;
            this.y = startY;
            this.currentRotation = 0;
        }

        public Tetromino(Tetromino other) {
            this.x = other.x;
            this.y = other.y;
            this.type = other.type;
            this.currentRotation = other.currentRotation;
        }

        public Tetromino moveLeft() {
            x--;
            return this;
        }

        public Tetromino moveRight() {
            x++;
            return this;
        }

        public Tetromino moveDown() {
            y++;
            return this;
        }

        public Tetromino rotate() {
            currentRotation = (currentRotation + 1) % type.getShapes().length;
            return this;
        }

        public Tetromino rotateReverse() {
            currentRotation = (currentRotation - 1 + type.getShapes().length) % type.getShapes().length;
            return this;
        }

        public int[][] getCurrentShape() {
            return type.getShapes()[currentRotation];
        }

        public int getX() {
            return x;
        }

        public int getY() {
            return y;
        }

        public void setX(int newX) {
            this.x = newX;
        }

        public void setY(int newY) {
            this.y = newY;
        }
    }

    // TetrisBoard Class
    private class TetrisBoard extends JPanel {
        private int width, height;
        private int[][] boardState;

        public TetrisBoard(int width, int height) {
            this.width = width;
            this.height = height;
            this.boardState = new int[height][width];
            setPreferredSize(new Dimension(width * BLOCK_SIZE, height * BLOCK_SIZE));
            setBackground(Color.BLACK);
        }

        public void clearBoard() {
            boardState = new int[height][width];
        }

        public boolean canPlaceTetromino(Tetromino tetromino) {
            return isValidMove(tetromino.getX(), tetromino.getY(), tetromino.getCurrentShape());
        }

        public boolean canRotateTetromino(Tetromino tetromino) {
            Tetromino rotatedTetromino = new Tetromino(tetromino);
            rotatedTetromino.rotate(); // 嘗試旋轉

            //檢查旋轉後的位置是否有效
            if (isValidMove(rotatedTetromino.getX(), rotatedTetromino.getY(), rotatedTetromino.getCurrentShape())) {
                return true;
            }

            if (rotatedTetromino.getX() < 0) {
                rotatedTetromino.setX(0);
                return true;
            }

            return false; // 如果所有嘗試都失敗，返回 false
        }

        public void placeTetromino(Tetromino tetromino) {
            int[][] shape = tetromino.getCurrentShape();
            int startX = tetromino.getX();
            int startY = tetromino.getY();

            for (int row = 0; row < shape.length; row++) {
                for (int col = 0; col < shape[row].length; col++) {
                    if (shape[row][col] == 1) {
                        int boardY = startY + row;
                        int boardX = startX + col;

                        // 確保不會超出邊界
                        if (boardY >= 0 && boardY < BOARD_HEIGHT &&
                                boardX >= 0 && boardX < BOARD_WIDTH) {
                            boardState[boardY][boardX] = 1; // 更新狀態
                        }
                    }
                }
            }
        }

        public int checkAndClearLines() {
            int linesCleared = 0;
            for (int y = height - 1; y >= 0; y--) {
                boolean lineIsFull = true;
                for (int x = 0; x < width; x++) {
                    if (boardState[y][x] == 0) {
                        lineIsFull = false;
                        break;
                    }
                }

                if (lineIsFull) {
                    linesCleared++;
                    removeLine(y);
                    y++; // Recheck the same row after removing a line
                }
            }
            return linesCleared;
        }

        private void removeLine(int lineToRemove) {
            for (int y = lineToRemove; y > 0; y--) {
                System.arraycopy(boardState[y - 1], 0, boardState[y], 0, width);
            }
            // Clear the top line
            boardState[0] = new int[width];
        }

        @Override
        protected void paintComponent(Graphics g) {
            super.paintComponent(g);

            // 繪製網格
            g.setColor(Color.DARK_GRAY);
            for (int x = 0; x < width; x++) {
                for (int y = 0; y < height; y++) {
                    g.drawRect(x * BLOCK_SIZE, y * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE);
                }
            }

            // 繪製已置的方塊
            g.setColor(Color.CYAN);
            for (int y = 0; y < height; y++) {
                for (int x = 0; x < width; x++) {
                    if (boardState[y][x] == 1) {
                        g.fillRect(x * BLOCK_SIZE, y * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE);
                    }
                }
            }

            // 繪製預測方塊（ghost piece）
            if (ghostPiece != null) {
                g.setColor(new Color(255, 255, 255, 30));  // 更透明
                int[][] ghostShape = ghostPiece.getCurrentShape();
                int ghostX = ghostPiece.getX();
                int ghostY = ghostPiece.getY();

                for (int row = 0; row < ghostShape.length; row++) {
                    for (int col = 0; col < ghostShape[row].length; col++) {
                        if (ghostShape[row][col] == 1) {
                            g.fillRect(
                                    (ghostX + col) * BLOCK_SIZE,
                                    (ghostY + row) * BLOCK_SIZE,
                                    BLOCK_SIZE,
                                    BLOCK_SIZE
                            );
                        }
                    }
                }
            }

            // 繪製當前方塊
            if (currentTetromino != null) {
                g.setColor(Color.GREEN);
                int[][] shape = currentTetromino.getCurrentShape();
                int startX = currentTetromino.getX();
                int startY = currentTetromino.getY();

                for (int row = 0; row < shape.length; row++) {
                    for (int col = 0; col < shape[row].length; col++) {
                        if (shape[row][col] == 1) {
                            g.fillRect(
                                    (startX + col) * BLOCK_SIZE,
                                    (startY + row) * BLOCK_SIZE,
                                    BLOCK_SIZE,
                                    BLOCK_SIZE
                            );
                        }
                    }
                }
            }

            // 繪製儲存的方塊
            paintSavedTetromino(g);
        }
    }

    // PreviewPanel Class
    private class PreviewPanel extends JPanel {
        public PreviewPanel() {
            setPreferredSize(new Dimension(PREVIEW_SIZE * BLOCK_SIZE, PREVIEW_SIZE * BLOCK_SIZE));
            setBackground(Color.BLACK);
            setBorder(BorderFactory.createTitledBorder(
                    BorderFactory.createLineBorder(Color.GRAY, 2),
                    "Next",
                    TitledBorder.CENTER,
                    TitledBorder.TOP,
                    new Font("Arial", Font.BOLD, 20),
                    Color.WHITE
            ));
        }

        @Override
        protected void paintComponent(Graphics g) {
            super.paintComponent(g);
            if (nextTetromino != null) {
                g.setColor(Color.GREEN);
                int[][] shape = nextTetromino.getCurrentShape();

                // Calculate center position
                int centerX = (PREVIEW_SIZE - shape[0].length) * BLOCK_SIZE / 2;
                int centerY = (PREVIEW_SIZE - shape.length) * BLOCK_SIZE / 2;

                for (int row = 0; row < shape.length; row++) {
                    for (int col = 0; col < shape[row].length; col++) {
                        if (shape[row][col] == 1) {
                            g.fillRect(
                                    centerX + col * BLOCK_SIZE,
                                    centerY + row * BLOCK_SIZE,
                                    BLOCK_SIZE,
                                    BLOCK_SIZE
                            );
                        }
                    }
                }
            }
        }
    }

    // 修改 paintComponent 方法以顯示儲存的方塊
    private void paintSavedTetromino(Graphics g) {
        if (savedTetromino != null) {
            g.setColor(Color.YELLOW); // 儲存方塊的顏色
            int[][] shape = savedTetromino.getCurrentShape();
            int startX = 10; // 儲存區的 X 坐標
            int startY = 5;  // 儲存區的 Y 坐標，調整為預覽區域下方

            for (int row = 0; row < shape.length; row++) {
                for (int col = 0; col < shape[row].length; col++) {
                    if (shape[row][col] == 1) {
                        g.fillRect(
                                (startX + col) * BLOCK_SIZE,
                                (startY + row) * BLOCK_SIZE,
                                BLOCK_SIZE,
                                BLOCK_SIZE
                        );
                    }
                }
            }
        }
    }
}