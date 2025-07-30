// === PARAMETERS ===
int cols = 40;
int rows = 30;
color gridColor = #ed7818;
color textColor = #ff0000;
float changeRate = 0.02;

// === CONSTANTS ===
final int STATE_APPEARING = 0;
final int STATE_HOLDING = 1;
final int STATE_DISAPPEARING = 2;

// === STRUCTURES ===
char[][] grid;
PFont sciFiFont;
PFont normalFont;
String charset = "abcdefghijklmnopqrstuvwxyz0123456789";
ArrayList<AnimatedText> animatedTexts;

void setup() {
  size(2000, 1600);
  frameRate(30);
  
  sciFiFont = createFont("MarsVoyager Travelers.ttf", 32);
  normalFont = createFont("Arial", 32);

  textAlign(CENTER, CENTER);
  noStroke();
  
  // Init grid
  grid = new char[cols][rows];
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      grid[x][y] = randomChar();
    }
  }

  animatedTexts = new ArrayList<AnimatedText>();

  // Example usage
  //WriteText(2, 5, "Traveler", 10, 0.1);
  //WriteText(4, 6, "3326", 5, 0.15);
  //WriteText(4, 8, "Incoming Message", 6, 0.05);
}

void draw() {
  background(0);
  float cellW = width / (float)cols;
  float cellH = height / (float)rows;
  float fontSize = min(cellW, cellH) * 0.8;
  textSize(fontSize);

  // Draw random grid
  for (int x = 0; x < cols; x++) {
    for (int y = 0; y < rows; y++) {
      boolean isBlocked = false;
      for (AnimatedText t : animatedTexts) {
        if (t.blocks(x, y)) {
          isBlocked = true;
          break;
        }
      }
      if (!isBlocked) {
        if (random(1) < changeRate) {
          grid[x][y] = randomChar();
        }
        fill(gridColor);
        textFont(sciFiFont);
        float px = x * cellW + cellW / 2;
        float py = y * cellH + cellH / 2;
        text(grid[x][y], px, py);
      }
    }
  }

  // Draw animated text overlays
  for (int i = animatedTexts.size() - 1; i >= 0; i--) {
    AnimatedText t = animatedTexts.get(i);
    t.update();
    t.render(cellW, cellH, fontSize);
    if (t.isFinished()) {
      animatedTexts.remove(i);
    }
  }
}

char randomChar() {
  return charset.charAt((int)random(charset.length()));
}

// === USER FUNCTION ===
void WriteText(int x, int y, String msg, float durationSeconds, float speedSeconds) {
  animatedTexts.add(new AnimatedText(x, y, msg, durationSeconds, speedSeconds));
}

// === ANIMATED TEXT CLASS ===
class AnimatedText {
  int x, y;
  String msg;
  float duration;
  float speed;
  int state;
  int visibleChars;
  int totalChars;
  float stateTimer;
  float lastUpdate;
  
  AnimatedText(int x, int y, String msg, float duration, float speed) {
    this.x = x;
    this.y = y;
    this.msg = msg;
    this.duration = duration;
    this.speed = speed;
    this.state = STATE_APPEARING;
    this.visibleChars = 0;
    this.totalChars = msg.length();
    this.stateTimer = 0;
    this.lastUpdate = millis() / 1000.0;
  }

  void update() {
    float now = millis() / 1000.0;
    float delta = now - lastUpdate;
    lastUpdate = now;
    stateTimer += delta;

    if (state == STATE_APPEARING) {
      if (stateTimer >= speed && visibleChars < totalChars) {
        visibleChars++;
        stateTimer = 0;
        if (visibleChars == totalChars) {
          state = STATE_HOLDING;
          stateTimer = 0;
        }
      }
    } else if (state == STATE_HOLDING) {
      if (stateTimer >= duration) {
        state = STATE_DISAPPEARING;
        stateTimer = 0;
      }
    } else if (state == STATE_DISAPPEARING) {
      if (stateTimer >= speed && visibleChars > 0) {
        visibleChars--;
        stateTimer = 0;
      }
    }
  }

  void render(float cw, float ch, float fs) {
    textFont(normalFont);
    textSize(fs);
    fill(textColor);
    for (int i = 0; i < visibleChars; i++) {
      int cx = x + i;
      if (cx >= cols || y >= rows) continue;
      float px = cx * cw + cw / 2;
      float py = y * ch + ch / 2;
      text(msg.charAt(i), px, py);
    }
  }

  boolean blocks(int cx, int cy) {
    return (cy == y && cx >= x && cx < x + visibleChars);
  }

  boolean isFinished() {
    return (state == STATE_DISAPPEARING && visibleChars == 0);
  }
}



void keyPressed() {
  switch (key) {
    case 'q': case 'Q':
      WriteText(2, 4, "PROTOCOL 5", 10, 0.05);
      break;
    case 'w': case 'W':
      WriteText(3, 6, "NEW MESSAGE FROM DIRECTOR", 10, 0.05);
      break;
    case 'e': case 'E':
      WriteText(1, 8, "HISTORIAN READY", 10, 0.05);
      break;
    case 'r': case 'R':
      WriteText(7, 10, "TRANSFER COMPLETE", 10, 0.05);
      break;
    case 't': case 'T':
      WriteText(8, 12, "ASSIGNMENT RECEIVED", 10, 0.05);
      break;
    case 'y': case 'Y':
      WriteText(8, 14, "SHELTER 41", 10, 0.05);
      break;
    case 'u': case 'U':
      WriteText(20, 16, "PRIMARY MISSION", 10, 0.05);
      break;
    case 'i': case 'I':
      WriteText(22, 20, "DONOVAN REPORTING", 10, 0.05);
      break;
    case 'o': case 'O':
      WriteText(20, 22, "TEMPORAL SHIFT", 10, 0.05);
      break;
    case 'p': case 'P':
      WriteText(22, 24, "REBOOT SEQUENCE", 10, 0.05);
      break;
  }
}
