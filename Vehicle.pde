class Vehicle {

  //physics
  PVector pos;
  float vel = 0, acc = 0;

  //direction car is facing in radians
  float dir;
  float fullHealth = 100;
  float health = fullHealth;

  //collision
  float carWidth = 2.5;
  float carLength = 5.5;
  float carScale = 15;

  PShape carShape;
  PShape collider;

  //handling
  float turningSpeed = 0.01;
  float accelerationRate = 0.05;

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

  PVector[] getPoints() {
    shape(collider);
    int a = collider.getVertexCount();
    PVector[] pts = new PVector[a];
    for (int i = 0; i < a; i++) {
      PVector point = new PVector(collider.getVertex(i).x, collider.getVertex(i).y);
      pts[i] = point.rotate(dir).add(this.pos);
    }
    return pts;
  }

  void update() {

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

    int carTileX = constrain(int((pos.x + (ts / 2)) / ts + 25), 0, 49);
    int carTileY = constrain(int((pos.y + (ts / 2)) / ts + 25), 0, 49);
    
    acc -= ground[carTileX][carTileY].type == ROAD ? 0.005:0.03;
    //constraints on acceleration
    
    float maxSpeed = ground[carTileX][carTileY].type == ROAD ? 1.4:0.9;

    acc = constrain(acc, 0, maxSpeed);
    //velocity exponetial decay
    vel *= 0.9;
    vel += acc;
    if (vel < 0.01) vel = 0;

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

  void update() {
    //left and right turns
    if (keyA) {
      dir -= turningSpeed * vel * 0.02 * delta;
      collider.rotate(-turningSpeed * 0.02 * delta);
    }
    if (keyD) {
      dir += turningSpeed * vel * 0.02 * delta;
      collider.rotate(turningSpeed * 0.02 * delta);
    }

    //gas and break
    if (keyW) acc += accelerationRate;
    if (keyS) acc -= accelerationRate * 2;
    super.update();
  }

  void display() {
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

  void drawHealth(float x, float y, float w, float h) {
    pushMatrix();
    {
      translate(x + w/2, y + h/2);
      scale(1);
      rectMode(CENTER);
      fill(0);
      stroke(0);
      strokeWeight(2);
      rect(0, 0, w, h, h/2);
      fill(/*#FFC400*/#FF0D0D);
      rectMode(CORNER);
      imageMode(CORNER);
      rect(-w/2 + h/8, -h/2 + h/8, map(constrain(health, 0, fullHealth), fullHealth, 0, w - h/4, 0), h - h/4, h/2);
      image(healthIcon, -250, -24, 50, 50);
      textSize(32);
      fill(0,255,20);
      text("Time alive: " + frameCount/30 + " seconds", 900, 20);
    }
    popMatrix();
  }
}
