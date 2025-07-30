// === PARAMETERS ===
int cols = 40;
int rows = 30;
int canvasWidth = 800;
int canvasHeight = 600;
color gridColor = #ed7818;      // sci-fi character color
color textColor = #ff0000;      // normal written text color
float changeRate = 0.02;

// === VARIABLES ===
char[][] grid;
TextCell[][] fixedText;
PFont sciFiFont;
PFont normalFont;
String charset = "abcdefghijklmnopqrstuvwxyz0123456789";

void setup() {
  size(2000, 1600);
  frameRate(30);
  
  // Load fonts
  sciFiFont = createFont("MarsVoyager Travelers.ttf", 32);
  normalFont = createFont("Arial", 32); // any regular readable font
  
  textAlign(CENTER, CENTER);
  noStroke();
  
  // Init
  grid = new char[cols][rows];
  fixedText = new TextCell[cols][rows];
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      grid[x][y] = randomChar();
      fixedText[x][y] = null;
    }
  }
  
  // Example text overlay
  WriteText(2, 5, "Traveler");
  WriteText(4, 6, "3326");
  WriteText(4, 8, "Incoming Message");
}

void draw() {
  background(0);
  float cellW = width / (float)cols;
  float cellH = height / (float)rows;
  float fontSize = min(cellW, cellH) * 0.8;
  textSize(fontSize);

  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      float px = x * cellW + cellW / 2;
      float py = y * cellH + cellH / 2;

      if (fixedText[x][y] != null) {
        fill(textColor);
        textFont(normalFont);
        text(fixedText[x][y].ch, px, py);
      } else {
        if (random(1) < changeRate) {
          grid[x][y] = randomChar();
        }
        fill(gridColor);
        textFont(sciFiFont);
        text(grid[x][y], px, py);
      }
    }
  }
}

char randomChar() {
  return charset.charAt((int)random(charset.length()));
}

// === WriteText Function ===
void WriteText(int startX, int startY, String msg) {
  for (int i = 0; i < msg.length(); i++) {
    int x = startX + i;
    if (x >= cols || startY >= rows) break;
    fixedText[x][startY] = new TextCell(msg.charAt(i));
  }
}

class TextCell {
  char ch;
  TextCell(char ch) {
    this.ch = ch;
  }
}
