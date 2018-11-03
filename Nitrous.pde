//KeyPress booleans
boolean keyW, keyA, keyS, keyD;

int y = 100;

Tile[][] ground;
PVector testPos;

// The statements in the setup() function 
// execute once when the program begins
void setup() {
  size(1600, 900, P3D);  // Size must be the first statement
  stroke(255);     // Set line drawing color to white
  frameRate(30);
  
  ground = new Tile[25][25];
  for (int i = 0; i < ground.length; i++) {
    for (int j = 0; j < ground[i].length; j++) {
      ground[i][j] = new Tile(-50*ground.length/2 + 50 * i, -50*ground[i].length/2 + 50 * j, 0);
    }
  }
  
  testPos = new PVector(0, 0, 0);
  keyW = keyA = keyS = keyD = false;
  
}

void draw() { 
  background(0);
  translate(width/2, height/2);
  
  for (int i = 0; i <ground.length; i++) {
    for (int j = 0; j < ground[i].length; j++) {
      ground[i][j].update(testPos);
      ground[i][j].display();
    }
  }
  
  if (keyW) testPos.y -= 10;
  if (keyS) testPos.y += 10;
  if (keyA) testPos.x -= 10;
  if (keyD) testPos.x += 10;
  
  fill(255);
  noStroke();
  ellipse(0, 0, 20, 20); 
}

void keyPressed() {
  if (key == 'w' || key == 'W') keyW = true;
  if (key == 's' || key == 'S') keyS = true;
  if (key == 'a' || key == 'A') keyA = true;
  if (key == 'd' || key == 'D') keyD = true;
  //if (keyCode == 32) spacebar = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W') keyW = false;
  if (key == 's' || key == 'S') keyS = false;
  if (key == 'a' || key == 'A') keyA = false;
  if (key == 'd' || key == 'D') keyD = false;
}
