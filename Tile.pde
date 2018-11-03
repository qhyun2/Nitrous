class Collider {
  PShape obj;
  int type;
  float scale;

  PShape borders;

  Collider(int type, float w, float h) {
    this.type = type;
    switch (type) {
    case 0: //Tree, bitch
      scale = 20;
      break;
    case 1: //Those buildy things
      scale = 27.5;
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
      -w/2, 
      -h/2, 
      w, 
      h
      );
    borders.setFill(false);
    borders.setStroke(false);
  }

  void display() {
    //draw the obstacle itself (model, obj)
    pushMatrix();
    scale(scale);
    rotateX(HALF_PI);
    shape(obst[type], 0, 0);
    popMatrix();

    shape(borders);
    for (int i = 0; i < borders.getVertexCount(); i++) {
      PVector points = new PVector(borders.getVertex(i).x, borders.getVertex(i).y);
      points.rotate(0);
      strokeWeight(20);
      stroke(255, 255, 0);
      point(points.x, points.y, 1);
    }
  }
}

int BLANK = 0;
int ROAD = 1;
float noiseScale = 0.06;

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
    tileType = int(map(noiseVal, 0, 1, 0, 3)); //grass based on noise
  }

  void addCollider(int type)
  {
    obstacle = new Collider(type, w, h);
  }

  void update(PVector tracked) {
    /* tracked is the position (normally of the player) that
     * this object will move on-screen relative to
     */
    displaypos.x = -tracked.x + pos.x;
    displaypos.y = -tracked.y + pos.y;
  }

  void display() {
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
