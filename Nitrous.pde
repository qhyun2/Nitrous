//KeyPress booleans
boolean keyW, keyA, keyS, keyD;

Tile[][] ground;
int distAway = 500;
int xSize = 50, ySize = 50;

StarterCar playerCar;
AICar[] aiCar;
float ts = 120; //TileSize

int delta = 0;
int lastUpdate;


void setup() {
  size(1600, 900, P3D);
  stroke(255);
  frameRate(60);
  smooth(2);

  loadAssets();
  lastUpdate = millis();

  ground = new Tile[xSize][ySize];
  for (int i = 0; i < ground.length; i++) {
    for (int j = 0; j < ground[i].length; j++) {
      float Xpos = -ts * ground.length/2 + ts * i;
      float Ypos = -ts * ground[i].length/2 + ts * j;
      ground[i][j] = new Tile(Xpos, Ypos, 0, ts, ts);
    }
  }

  keyW = keyA = keyS = keyD = false;

  playerCar = new StarterCar(0, 0, car1);
  roadGen(xSize, ySize);
  aiCar = new AICar[2];

  for (int i = 0; i < aiCar.length; i++)
  {
    aiCar[i] = new AICar(i * 100, 80, car1);
  }

  for (int i = 0; i < ground.length; i++) {
    for (int j = 0; j < ground[i].length; j++) {

      boolean nearRoad = testIfRoad(i + 1, j)||testIfRoad(i, j + 1)||testIfRoad(i - 1, j)||testIfRoad(i, j - 1);

      if (nearRoad && random(1) > 0.8) ground[i][j].addCollider(1);
      if (random(1) > 0.9) ground[i][j].addCollider(0);
      if (ground[i][j].type == ROAD) ground[i][j].obstacle = null;
    }
  }
  
  ground[49][49].type = 1;
  ground[49][49].tileType = 8;
}

void draw() {
  ///update timing functions///
  delta = millis() - lastUpdate;
  lastUpdate = millis();
  update();
}

void drawSplash() {
  image(splash, 0, 0, 1600, 900);
}

void drawGame() {
  //println(delta);


  pushMatrix();
  {
    background(135, 206, 235);
    translate(width/2, height/2);
    camera(distAway, distAway, distAway*1.6, /*Position of the camera itself*/
      0, 0, 0, /*Point the camera looks towards*/
      0, 0, -1.0); /*Axis control*/

    //camera(0, 0, 6000, /*Position of the camera itself*/
    //  0, 0, 0, /*Point the camera looks towards*/
    //  1.0, 0, 0); /*Axis control*/


    lights();
    directionalLight(100, 100, 100, -1, -1, -1.6);

    for (int i = 0; i <ground.length; i++) {
      for (int j = 0; j < ground[i].length; j++) {
        ground[i][j].update(playerCar.pos);
        ground[i][j].display();
        if (ground[i][j].obstacle != null) {
          PVector[] obs = ground[i][j].obstacle.getPoints();
          for (int k = 0; k < obs.length; k++) obs[k].add(ground[i][j].pos);
          if (collidePolyPoly(obs, playerCar.getPoints())) {
            playerCar.vel = 0;
            playerCar.acc = 0;
            ground[i][j].obstacle = null;
          }
        }
      }
    }

    translate(0, 0, 1);

    playerCar.update();
    playerCar.display();
    for (AICar car : aiCar)
    {
      car.update(playerCar.pos);
      car.display();
    }
  }
  popMatrix();
  playerCar.drawHealth(20, 20, 500, 50);
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

  if (key == 't' || key == 'T') state = 1;
}

void keyReleased() {
  if (key == 'w' || key == 'W' || keyCode == 38) keyW = false;
  if (key == 's' || key == 'S' || keyCode == 40) keyS = false;
  if (key == 'a' || key == 'A' || keyCode == 37) keyA = false;
  if (key == 'd' || key == 'D' || keyCode == 39) keyD = false;
}



//needed features
// player health DONE
// framerate based updates
// ai collision with player
// ai collision with each other
// score system
// ai wrap around
// faster on roads
