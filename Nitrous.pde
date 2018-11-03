//KeyPress booleans
boolean keyW, keyA, keyS, keyD;

int y = 100;

Tile[][] ground;
PVector testPos;
int distAway = 350;
StarterCar vehicle;
RoadGen roadGen;

void setup() {
  size(1600, 900, P3D);
  stroke(255);
  frameRate(60);
  smooth(2);

  loadAssets();

  ground = new Tile[50][50];
  float ts = 100; //TileSize
  for (int i = 0; i < ground.length; i++) {
    for (int j = 0; j < ground[i].length; j++) {
      ground[i][j] = new Tile(-ts*ground.length/2 + ts * i, -ts*ground[i].length/2 + ts * j, 0, ts, ts);
    }
  }

  testPos = new PVector(0, 0, 0);
  keyW = keyA = keyS = keyD = false;

  vehicle = new StarterCar(0, 0, car1);
  roadGen = new RoadGen(50, 50);
  roadGen.updateTiles();
}

void draw() {
  background(135, 206, 235);
  translate(width/2, height/2);
  camera(distAway, distAway, distAway*1.6, /*Position of the camera itself*/
    0, 0, 0, /*Point the camera looks towards*/
    0, 0, -1.0); /*Axis control*/

  lights();
  directionalLight(100, 100, 100, -1, -1, -1.6);
  
  for (int i = 0; i <ground.length; i++) {
    for (int j = 0; j < ground[i].length; j++) {
      ground[i][j].update(vehicle.pos);
      ground[i][j].display();
    }
  }
  translate(0, 0, 1);
  noFill();
  strokeWeight(10);

  vehicle.update();
  vehicle.display();
}

//Moved this out here since it's a general function
boolean range(int value, int min, int max) {
  return value > min && value < max;
}

void keyPressed() {

  if (key == 'w' || key == 'W' || keyCode == 38) keyW = true;
  if (key == 's' || key == 'S' || keyCode == 40) keyS = true;
  if (key == 'a' || key == 'A' || keyCode == 37) keyA = true;
  if (key == 'd' || key == 'D' || keyCode == 39) keyD = true;
}

void keyReleased() {
  if (key == 'w' || key == 'W' || keyCode == 38) keyW = false;
  if (key == 's' || key == 'S' || keyCode == 40) keyS = false;
  if (key == 'a' || key == 'A' || keyCode == 37) keyA = false;
  if (key == 'd' || key == 'D' || keyCode == 39) keyD = false;
}
