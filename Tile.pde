class Tile {
  PVector pos, displaypos;
  float w, h;
  
  Tile(float x, float y, float z) {
    pos = new PVector(x, y, z);
    displaypos = new PVector(x, y, z);
    this.w = 50;
    this.h = 50;
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
      fill(200);
      stroke(10);
      strokeWeight(1);
      rect(0, 0, w, h);
    }
    popMatrix();
  }
  
}
