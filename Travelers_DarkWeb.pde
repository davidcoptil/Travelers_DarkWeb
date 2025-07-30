// === PARAMETERS ===
int cols = 20;
int rows = 20;
final int canvasWidth = 800;
final int canvasHeight = 600;
color fontColor = #ed7818; // neon green
float changeRate = 0.02; // probability of character change per frame

// === VARIABLES ===
char[][] grid;
PFont font;
String charset = "abcdefghijklmnopqrstuvwxyz0123456789";

void setup() {
  //size(canvasWidth, canvasHeight);
  size(2000, 1600);
  frameRate(30);
  
  // Load your custom font here
  font = createFont("MarsVoyager Travelers.ttf", 32);
  textFont(font);
  textAlign(CENTER, CENTER);
  fill(fontColor);
  noStroke();
  
  // Initialize grid
  grid = new char[cols][rows];
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      grid[x][y] = randomChar();
    }
  }
}

void draw() {
  background(0);
  float cellW = width / (float)cols;
  float cellH = height / (float)rows;
  textSize(min(cellW, cellH) * 0.8);  // scale font size to fit
  
  // Display and update grid
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      if (random(1) < changeRate) {
        grid[x][y] = randomChar();
      }
      float px = x * cellW + cellW / 2;
      float py = y * cellH + cellH / 2;
      text(grid[x][y], px, py);
    }
  }
}

char randomChar() {
  return charset.charAt((int)random(charset.length()));
}
