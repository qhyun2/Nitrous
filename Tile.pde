class Tile {
  PVector pos, displaypos;
  float w, h;
  int type;

  Tile(float x, float y, float z) {
    pos = new PVector(x, y, z);
    displaypos = new PVector(x, y, z);
    this.w = 50;
    this.h = 50;
    type = 0;
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
      if (type != 0)
      {
        image(roads[type], 0, 0, 100, 100);
      } else {
        rect(0, 0, 100, 100);
      }
    }
    popMatrix();
  }
}
