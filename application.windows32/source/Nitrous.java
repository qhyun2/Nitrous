import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class Nitrous extends PApplet {

//KeyPress booleans
boolean keyW, keyA, keyS, keyD;
int score = 0; 

Tile[][] ground;
int distAway = 500;
int xSize = 50, ySize = 50;

StarterCar playerCar;
AICar[] aiCar;
float ts = 120; //TileSize

int delta = 0;
int lastUpdate;


public void setup() {
  
  stroke(255);
  frameRate(60);
  

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
  aiCar = new AICar[8];

  for (int i = 0; i < aiCar.length; i++)
  {
    aiCar[i] = new AICar(ts * random(-3, 3), ts * random(-4, 4), car1);
  }

  for (int i = 0; i < ground.length; i++) {
    for (int j = 0; j < ground[i].length; j++) {

      boolean nearRoad = testIfRoad(i + 1, j)||testIfRoad(i, j + 1)||testIfRoad(i - 1, j)||testIfRoad(i, j - 1);

      if (nearRoad && random(1) > 0.8f) ground[i][j].addCollider(1);
      if (random(1) > 0.9f) ground[i][j].addCollider(0);
      if (ground[i][j].type == ROAD) ground[i][j].obstacle = null;
    }
  }
}

public void draw() {
  ///update timing functions///
  delta = millis() - lastUpdate;
  lastUpdate = millis();
  update();
}

public void drawSplash() {
  image(splash, 0, 0, 1600, 900);
}

public void drawGame() {
  //println(delta);
  drawScore();

  pushMatrix();
  {
    background(135, 206, 235);
    translate(width/2, height/2);
    camera(distAway, distAway, distAway*1.6f, /*Position of the camera itself*/
      0, 0, 0, /*Point the camera looks towards*/
      0, 0, -1.0f); /*Axis control*/

    //camera(0, 0, 6000, /*Position of the camera itself*/
    //  0, 0, 0, /*Point the camera looks towards*/
    //  1.0, 0, 0); /*Axis control*/


    lights();
    directionalLight(100, 100, 100, -1, -1, -1.6f);

    for (int i = 0; i <ground.length; i++) {
      for (int j = 0; j < ground[i].length; j++) {
        ground[i][j].update(playerCar.pos);
        ground[i][j].display();
        if (ground[i][j].obstacle != null) {
          PVector[] obs = ground[i][j].obstacle.getPoints();
          for (int k = 0; k < obs.length; k++) obs[k].add(ground[i][j].pos);
          if (collidePolyPoly(obs, playerCar.getPoints())) {
            //playerCar.health -= 10;
            playerCar.vel = 0;
            playerCar.acc = 0;
            ground[i][j].obstacle = null;
            score += 50;
          }
        }
      }
    }

    for (int i = 0; i < aiCar.length; i++) {
      if (aiCar[i] != null) {
        if (collidePolyPoly(aiCar[i].getPoints(), playerCar.getPoints())) {
          playerCar.health -= playerCar.fullHealth / aiCar.length;
          aiCar[i] = null;
        }
      }
    }

    if (playerCar.health <= 0) {
      state = 2;
    }

    translate(0, 0, 1);

    playerCar.update();
    playerCar.display();
    for (AICar car : aiCar)
    {
      if (car != null) {
        car.update(playerCar.pos);
        car.display();
      }
    }
  }
  popMatrix();
  playerCar.drawHealth(20, 20, 500, 50);
}

//Moved this out here since it's a general function
public boolean range(int value, int min, int max) {
  return value > min && value < max;
}

public void keyPressed() {

  if (key == 'w' || key == 'W' || keyCode == 38) keyW = true;
  if (key == 's' || key == 'S' || keyCode == 40) keyS = true;
  if (key == 'a' || key == 'A' || keyCode == 37) keyA = true;
  if (key == 'd' || key == 'D' || keyCode == 39) keyD = true;
  if (state == 0) state = 1;
}

public void keyReleased() {
  if (key == 'w' || key == 'W' || keyCode == 38) keyW = false;
  if (key == 's' || key == 'S' || keyCode == 40) keyS = false;
  if (key == 'a' || key == 'A' || keyCode == 37) keyA = false;
  if (key == 'd' || key == 'D' || keyCode == 39) keyD = false;
}



//needed features
// player health DONE
// framerate based updates DONE
// ai collision with player
// ai collision with each other
// score system
// ai wrap around
// faster on roads DONE
class AICar extends Vehicle {
  PVector displaypos;
  AICar(float x, float y, PShape iCarShape) {
    super(x, y, iCarShape);
    displaypos = new PVector(x, y);
  }

  public void update(PVector tracked) {
    //to make sure that dir is always inbetween +1 Pi and -1 Pi
    dir %= TWO_PI;
    if (dir > PI) dir = dir - TWO_PI;
    if (dir < -PI) dir = TWO_PI + dir;

    //left and right turns

    PVector toPlayer = playerCar.pos.copy().sub(pos);

    //if (toPlayer.heading() > dir) dir += turningSpeed;
    //else dir -= turningSpeed;

    //gas and break
    acc += 0.03f;

    //acceleration linear decay
    acc -= 0.01f;
    //constraints on acceleration
    acc = constrain(acc, 0, 0.85f);
    //velocity exponetial decay
    vel *= 0.9f;

    vel += acc;
    if (vel < 0.01f) vel = 0;

    pos.add(PVector.fromAngle(toPlayer.heading()).mult(vel));
    dir = toPlayer.heading();

    displaypos.x = -tracked.x + pos.x;
    displaypos.y = -tracked.y + pos.y;

    collider.translate(pos.x, pos.y, 10);
    collider.rotate(dir);
  }
  
  public PVector[] getPoints() {
    shape(collider);
    int a = collider.getVertexCount();
    PVector[] pts = new PVector[a];
    for (int i = 0; i < a; i++) {
      PVector point = new PVector(collider.getVertex(i).x, collider.getVertex(i).y);
      pts[i] = point.rotate(dir).add(this.pos);

    }
    return pts;
  }

  public void display() {
    pushMatrix();
    {
      translate(displaypos.x, displaypos.y);
      scale(carScale);
      rotate(HALF_PI + dir);
      rotateX(HALF_PI);
      rectMode(CENTER);
      fill(225, 128, 0);
      stroke(10);
      strokeWeight(1);
      shape(carShape);
    }
    popMatrix();
  }
}
PImage[] roads;
PImage[] grass;
PImage splash, healthIcon;
PShape car1;
PShape[] obst = new PShape[3];

int TREE = 0;
int BUILDING = 1;
int CLOCKTOWER = 2;

public void loadAssets() {
  roads = new PImage[11];
  roads[0] = loadImage("Assets/Sprites/Landscape/Road/ld.png");
  roads[1] = loadImage("Assets/Sprites/Landscape/Road/rd.png");
  roads[2] = loadImage("Assets/Sprites/Landscape/Road/rdl.png");
  roads[3] = loadImage("Assets/Sprites/Landscape/Road/rl.png");
  roads[4] = loadImage("Assets/Sprites/Landscape/Road/ur.png");
  roads[5] = loadImage("Assets/Sprites/Landscape/Road/ud.png");
  roads[6] = loadImage("Assets/Sprites/Landscape/Road/udl.png");
  roads[7] = loadImage("Assets/Sprites/Landscape/Road/uld.png");
  roads[8] = loadImage("Assets/Sprites/Landscape/Road/ulr.png");
  roads[9] = loadImage("Assets/Sprites/Landscape/Road/ul.png");
  roads[10] = loadImage("Assets/Sprites/Landscape/Road/urdl.png");

  grass = new PImage[3];
  for (int i = 0; i < grass.length; i++) {
    grass[i] = loadImage("Assets/Sprites/Landscape/Field/Grass" + (i+1) + ".png");
  }

  car1 = loadShape("Assets/Models/testcar.obj");
  splash = loadImage("Assets/splashscreen.jpg");
  healthIcon = loadImage("Assets/Sprites/health.png");
  obst[TREE] = loadShape("Assets/Models/AppleTree.obj");
  obst[BUILDING] = loadShape("Assets/Models/Building2.obj");
  obst[CLOCKTOWER] = loadShape("Assets/Models/ClockTower.obj");
}
//collideLineLine(start1.x, start1.y, end1.x, end1.y, start2.x, start2.y, end2.x, end2.y)
public boolean collideLineLine(PVector start1, PVector end1, PVector start2, PVector end2) {
  /* Shamelessly stolen from p5.collide2d.js */
  /* Albeit, I did tweak it to work with processing, plus simplify it slightly */

  // calculate the distance to intersection point
  float uA = ((end2.x-start2.x)*(start1.y-start2.y) - (end2.y-start2.y)*(start1.x-start2.x)) / ((end2.y-start2.y)*(end1.x-start1.x) - (end2.x-start2.x)*(end1.y-start1.y));
  float uB = ((end1.x-start1.x)*(start1.y-start2.y) - (end1.y-start1.y)*(start1.x-start2.x)) / ((end2.y-start2.y)*(end1.x-start1.x) - (end2.x-start2.x)*(end1.y-start1.y));

  // if uA and uB are between 0-1, lines are colliding
  if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
    return true;
  } else return false;
}

public boolean collidePolyPoly(PVector[] p, PVector[] e) {
  for (int i = 0; i < p.length; i++) {
    for (int j = 0; j < e.length; j++) {
      int i2 = (i + 1 >= p.length) ? 0 : i + 1;
      //If the next index after i is past p's length, then set it to zero (last links to first)
      int j2 = (j + 1 >= e.length) ? 0 : j + 1;
      //Same goes for j and e.
      if (collideLineLine(p[i], p[i2], e[j], e[j2])) return true;
    }
  }
  return false;
}
class Obstacle {
  PShape collider;
  int type;
  float scale;
  Obstacle(int type) {
    this.type = type;
    switch (type) {
      case 0: //Tree, bitch
        collider = createShape(RECT, 0, 0, 10, 10);
        scale = 20;
        break;
      case 1: //Those buildy things
        collider = createShape(RECT, 0, 0, 10, 10);        
        scale = 27.5f;
        break;
      case 2: //Ding Dong the clunk has sung
      collider = createShape(RECT, 0, 0, 10, 10);
        scale = 100;
        break;
      default: //If u were dumm and didn't pass the write thing
      collider = createShape(RECT, 0, 0, 10, 10);
        scale = 20;
        break;
    }
    //collider.rotateX(HALF_PI);
    collider.setStroke(color(255));
    collider.setStrokeWeight(4);
    collider.setFill(color(127));
  }
  
  public void display() {
    scale(scale);
    rotateX(HALF_PI);
    shape(obst[type], 0, 0);
    shape(collider, 0, 0);
  }
  
}
public void roadGen(int sizeX, int sizeY) {

  //amount of road generated based on map size
  int roadPieces = (sizeX * sizeY) / 5;
  //roadPieces = 100;

  int x = floor(random(0, sizeX));
  int y = floor(random(0, sizeY));

  int current = 0;
  int dir = 1;
  int len = 10;

  //loop until enough road placed
  while (current < roadPieces) {
    //loop until determined lenght of road used or enough road placed
    while (len > 0 && current < roadPieces)
    {
      len--;
      //update position based on direction
      if (dir == 0) {
        x++;
        //place road if current tile is in range
      if (range(x, 0, sizeX / 2) && range(y, 0, sizeY / 2))
      {
        ground[x * 2 - 1][y * 2].type = ROAD;
        ground[x * 2][y * 2].type = ROAD;
      }
      } else if (dir == 1) {
        y++;
        //place road if current tile is in range
      if (range(x, 0, sizeX / 2) && range(y, 0, sizeY / 2))
      {
        ground[x * 2][y * 2 - 1].type = ROAD;
        ground[x * 2][y * 2].type = ROAD;
      }
      } else if (dir == 2) {
        x--;
        //place road if current tile is in range
      if (range(x, 0, sizeX / 2) && range(y, 0, sizeY / 2))
      {
        ground[x * 2 + 1][y * 2].type = ROAD;
        ground[x * 2][y * 2].type = ROAD;
      }
      } else if (dir == 3) {
        y--;
        //place road if current tile is in range
      if (range(x, 0, sizeX / 2) && range(y, 0, sizeY / 2))
      {
        ground[x * 2][y * 2 + 1].type = ROAD;
        ground[x * 2][y * 2].type = ROAD;
      }
      }

      //place road if current tile is in range
      if (range(x, 0, sizeX / 2) && range(y, 0, sizeY / 2))
      {
        ground[x * 2][y * 2].type = ROAD;
      } else {
        len = 0;
        break;
      }
      current++;
    }
    
    
    
    //generate new lenght of road and direction
    len = (20 + PApplet.parseInt(random(15))) / 2;
    int newdir = dir;
    do {
      newdir = PApplet.parseInt(random(4));
    } while (newdir == dir);
    dir = newdir;
  }
  connectRoads();
}

public void connectRoads() {
  //update roads to look connected
  for (int i = 0; i <ground.length; i++) {
    for (int j = 0; j < ground[i].length; j++) {
      if (ground[i][j].type == ROAD) {

        boolean up = testIfRoad(i + 1, j);
        boolean right = testIfRoad(i, j + 1);
        boolean down = testIfRoad(i - 1, j);
        boolean left = testIfRoad(i, j - 1);

        int tileType = 0;
        if (right || left) tileType = 5;
        if (up || down) tileType = 3;

        if (up && right) tileType = 1;
        if (right && down) tileType = 0;
        if (down && left) tileType = 9;
        if (left && up) tileType = 4;

        if (up && right && down) tileType = 2;
        if (right && down && left) tileType = 6;
        if (down && left && up) tileType = 8;
        if (left && up && right) tileType = 7;

        if (right && left && up && down) tileType = 10;

        ground[i][j].tileType = tileType;
      }
    }
  }
}

public boolean testIfRoad(int x, int y)
{
  //make sure index is in range
  if (range(x, 0, xSize) && range(y, 0, ySize))
  {
    return ground[x][y].type == ROAD;
  }
  return false;
}
public void drawScore(){
 
  
}
int state = 0;
int SPLASH = 0;
int PLAY = 1;
int GAMEOVER = 2;
boolean dead = false;

public void update(){
   switch(state){
      case 0:
        drawSplash();
        break;
      case 1:
        drawGame();
        break;
      case 2:
        background(0,0,0);
        textAlign(CENTER, CENTER);
        textSize(40);
        text("Game Over!", width/2, height/2);
        break;
   }
}
class Collider {
  PShape obj;
  int type;
  float scale;

  PShape borders;

  Collider(int type, float w, float h) {
    this.type = type;
    switch (type) {
    case 0: //Tree, bitch
      scale = 16;
      break;
    case 1: //Those buildy things
      scale = 50;
      break;
    case 2: //Ding Dong the clunk has sung
      scale = 100;
      break;
    default: //If u were dumm and didn't pass the write thing
      scale = 20;
      break;
    }

    borders = createShape(
      RECT, 
      -w/4, 
      -h/4, 
      w/2, 
      h/2
      );
    borders.setFill(false);
    borders.setStroke(false);
  }

  public void display() {
    //draw the obstacle itself (model, obj)
    pushMatrix();
    scale(scale);
    rotateX(HALF_PI);
    shape(obst[type], 0, 0);
    popMatrix();

    
  }

  public PVector[] getPoints() {
    shape(borders);
    int a = borders.getVertexCount();
    PVector[] pts = new PVector[a];
    for (int i = 0; i < a; i++) {
      pts[i] = new PVector(borders.getVertex(i).x, borders.getVertex(i).y);
    }
    return pts;
  }
}

int BLANK = 0;
int ROAD = 1;
float noiseScale = 0.06f;

class Tile {
  PVector pos, displaypos;
  float w, h;
  int type = 0;
  Collider obstacle;
  //type of grass or road (replaces grassType)
  int tileType;

  //probably temporary
  boolean hastree = false;

  Tile(float x, float y, float z, float w, float h) {
    pos = new PVector(x, y, z);
    displaypos = new PVector(x, y, z);
    this.w = w;
    this.h = h;
    //generate grass patches using perlin noise
    float noiseVal = noise(x*noiseScale, y*noiseScale);
    tileType = PApplet.parseInt(map(noiseVal, 0, 1, 0, 3)); //grass based on noise
  }

  public void addCollider(int type)
  {
    obstacle = new Collider(type, w, h);
  }

  public void update(PVector tracked) {
    /* tracked is the position (normally of the player) that
     * this object will move on-screen relative to
     */
    displaypos.x = -tracked.x + pos.x;
    displaypos.y = -tracked.y + pos.y;
  }

  public void display() {
    pushMatrix();
    {
      translate(this.displaypos.x, this.displaypos.y, this.displaypos.z);
      rectMode(CENTER);
      imageMode(CENTER);
      fill(200);
      stroke(10);
      strokeWeight(1);

      //Draw ground sprite
      if (type == ROAD) {
        image(roads[tileType], 0, 0, this.w, this.h);
      } else {
        image(grass[tileType], 0, 0, this.w, this.h);
      }
      if (this.obstacle != null) {
        obstacle.display();
      }

      popMatrix();
    }
  }
}
class Vehicle {

  //physics
  PVector pos;
  float vel = 0, acc = 0;

  //direction car is facing in radians
  float dir;
  float fullHealth = 100;
  float health = fullHealth;

  //collision
  float carWidth = 2.5f;
  float carLength = 5.5f;
  float carScale = 15;

  PShape carShape;
  PShape collider;

  //handling
  float turningSpeed = 0.01f;
  float accelerationRate = 0.05f;

  Vehicle(float x, float y, PShape iCarShape) {
    pos = new PVector(x, y);
    carShape = iCarShape;
    collider = createShape(
      RECT, 
      -carLength*carScale/2, 
      -carWidth*carScale/2, 
      carLength*carScale, 
      carWidth*carScale
      );
    collider.setFill(false);
    collider.setStroke(false);
  }

  public PVector[] getPoints() {
    shape(collider);
    int a = collider.getVertexCount();
    PVector[] pts = new PVector[a];
    for (int i = 0; i < a; i++) {
      PVector point = new PVector(collider.getVertex(i).x, collider.getVertex(i).y);
      pts[i] = point.rotate(dir).add(this.pos);
    }
    return pts;
  }

  public void update() {
    //collisions:
    for (int i = 0; i < collider.getVertexCount(); i++) {
      PVector points = new PVector(collider.getVertex(i).x, collider.getVertex(i).y);
      points.rotate(dir);
      //points are invisible
      strokeWeight(0);
      stroke(255, 255, 0);
      point(points.x, points.y, 1);
    }

    //acceleration linear decay

    int carTileX = constrain(PApplet.parseInt((pos.x + (ts / 2)) / ts + 25), 0, 49);
    int carTileY = constrain(PApplet.parseInt((pos.y + (ts / 2)) / ts + 25), 0, 49);
    acc -= (ground[carTileX][carTileY].type == ROAD) ? 0.005f : 0.03f;

    //constraints on acceleration

    float maxSpeed = ground[carTileX][carTileY].type == ROAD ? 1.4f:0.9f;

    acc = constrain(acc, 0, maxSpeed);
    //velocity exponetial decay
    vel *= 0.9f;
    vel += acc;
    if (vel < 0.01f) vel = 0;

    pos.add(PVector.fromAngle(dir).mult(vel));

    //xSize & ySize are the values for the width and height of the ground array
    float start = -ts * ground.length/2;
    float end = -ts * ground.length/2 + ts * ground.length;

    if (pos.x > end) pos.x = start;
    if (pos.x < start) pos.x = end;
    if (pos.y > end) pos.y = start;
    if (pos.y < start) pos.y = end;
  }
}

class StarterCar extends Vehicle {
  StarterCar(float x, float y, PShape iCarShape) {
    super(x, y, iCarShape);
  }

  public void update() {
    //left and right turns
    if (keyA) {
      dir -= turningSpeed * vel * 0.02f * delta;
      collider.rotate(-turningSpeed * 0.02f * delta);
    }
    if (keyD) {
      dir += turningSpeed * vel * 0.02f * delta;
      collider.rotate(turningSpeed * 0.02f * delta);
    }

    //gas and break
    if (keyW) acc += accelerationRate;
    if (keyS) acc -= accelerationRate * 2;
    super.update();
  }

  public void display() {
    if (health < 0)
    {
      state = 2;
    }
    pushMatrix();
    scale(carScale);

    rotate(HALF_PI + dir);
    rotateX(HALF_PI);
    rectMode(CENTER);
    fill(225, 128, 0);

    stroke(10);
    strokeWeight(1);
    shape(carShape, 0, 0);

    popMatrix();
  }

  public void drawHealth(float x, float y, float w, float h) {
    pushMatrix();
    {
      translate(x + w/2, y + h/2);
      scale(1);
      rectMode(CENTER);
      fill(0);
      stroke(0);
      strokeWeight(2);
      rect(0, 0, w, h, h/2);
      fill(/*#FFC400*/0xffFF0D0D);
      rectMode(CORNER);
      imageMode(CORNER);
      rect(-w/2 + h/8, -h/2 + h/8, map(constrain(health, 0, fullHealth), fullHealth, 0, w - h/4, 0), h - h/4, h/2);
      image(healthIcon, -250, -24, 50, 50);
    }
    popMatrix();
    textSize(32);

    textAlign(RIGHT, CENTER);

    String text = "Time alive: " + frameCount/30 + " seconds";
    fill(0);
    text(text, width - 22, 22);
    fill(255);
    text(text, width - 20, 20);

    text = "Score: " + score;
    fill(0);
    text(text, width - 22, 52);
    fill(255);
    text(text, width - 20, 50);
  }
}
  public void settings() {  size(1600, 900, P3D);  smooth(2); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "Nitrous" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
