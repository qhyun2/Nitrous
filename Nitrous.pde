//KeyPress booleans
boolean keyW, keyA, keyS, keyD;

int y = 100;

Tile[][] ground;
PVector testPos;
int distAway = 250;
StarterCar vehicle;

void setup() {
  size(1600, 900, P3D);
  stroke(255);
  frameRate(60);
  smooth(2);

  ground = new Tile[25][25];
  for (int i = 0; i < ground.length; i++) {
    for (int j = 0; j < ground[i].length; j++) {
      ground[i][j] = new Tile(-50*ground.length/2 + 50 * i, -50*ground[i].length/2 + 50 * j, 0);
    }
  }

  testPos = new PVector(0, 0, 0);
  keyW = keyA = keyS = keyD = false;

  vehicle = new StarterCar(0, 0);
}

void draw() {
  background(0);
  translate(width/2, height/2);
  camera(distAway, distAway, distAway, /*Position of the camera itself*/
    0, 0, 0, /*Point the camera looks towards*/
    0, 0, -1.0); /*Axis control*/

  for (int i = 0; i <ground.length; i++) {
    for (int j = 0; j < ground[i].length; j++) {
      ground[i][j].update(vehicle.pos);
      ground[i][j].display();
    }
  }

  //if (keyW) testPos.y -= 10;
  //if (keyS) testPos.y += 10;
  //if (keyA) testPos.x -= 10;
  //if (keyD) testPos.x += 10;

  translate(0, 0, 1);
  noFill();
  strokeWeight(10);
  
   vehicle.update();
   vehicle.display();
}

void keyPressed() {

  if (key == 'w' || key == 'W' || keyCode == 38) keyW = true;
  if (key == 's' || key == 'S' || keyCode == 40) keyS = true;
  if (key == 'a' || key == 'A' || keyCode == 37) keyA = true;
  if (key == 'd' || key == 'D' || keyCode == 39) keyD = true;
  //if (keyCode == 32) spacebar = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W' || keyCode == 38) keyW = false;
  if (key == 's' || key == 'S' || keyCode == 40) keyS = false;
  if (key == 'a' || key == 'A' || keyCode == 37) keyA = false;
  if (key == 'd' || key == 'D' || keyCode == 39) keyD = false;
}
