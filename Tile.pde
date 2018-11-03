int BLANK = 0;
int ROAD = 1;
int TREE = 2;
int BUILDING = 3;
int CLOCKTOWER = 4;

class Tile {
  PVector pos, displaypos;
  float w, h;
  int type;
  int grassType;

  //probably temporary
  boolean hastree = false;

  Tile(float x, float y, float z, float w, float h) {
    pos = new PVector(x, y, z);
    displaypos = new PVector(x, y, z);
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
        image(roads[type], 0, 0, this.w, this.h);
      } else {
        image(grass[grassType], 0, 0, this.w, this.h);
      }

      //Draw Extra embellishments
      if (type == TREE) {
        scale(20);
        rotateX(HALF_PI);
        shape(tree, 0, 0);
      } else if (type == BUILDING) {
        scale(27.5);
        rotateX(HALF_PI);
        shape(building, 0, 0);
      } else if (type == CLOCKTOWER) {
        scale (40);
        rotateX(HALF_PI);
        shape(clocktower, 0, 0);
      }
      popMatrix();
    }
  }
}
