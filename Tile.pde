class Collider {
  PShape obj;
  int type;
  float scale;
  Collider(int type) {
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
  }
  
  void display() {
    scale(scale);
    rotateX(HALF_PI);
    shape(obst[type], 0, 0);
  }
  
}

int BLANK = 0;
int ROAD = 1;
float noiseScale = 0.02;

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
    tileType = int(map(noiseVal,0,1,0,3)); //grass based on noise
  }
  
  Tile(float x, float y, float z, float w, float h, int collideType) {
    pos = new PVector(x, y, z);
    displaypos = new PVector(x, y, z);
    obstacle = new Collider(collideType);
    this.w = w;
    this.h = h;
    if (random(1) < 0.95) {
      type = BLANK;
    } else {
      type = floor(random(2, 5));
    }
    grassType = floor(random(3)); //random int between 0 & 2
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
