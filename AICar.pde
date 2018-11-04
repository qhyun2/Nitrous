class AICar extends Vehicle {
  PVector displaypos;
  AICar(float x, float y, PShape iCarShape) {
    super(x, y, iCarShape);
    displaypos = new PVector(x, y);
  }

  void update(PVector tracked) {
    //to make sure that dir is always inbetween +1 Pi and -1 Pi
    dir %= TWO_PI;
    if (dir > PI) dir = dir - TWO_PI;
    if (dir < -PI) dir = TWO_PI + dir;

    //left and right turns

    PVector toPlayer = playerCar.pos.copy().sub(pos);

    //if (toPlayer.heading() > dir) dir += turningSpeed;
    //else dir -= turningSpeed;

    //gas and break
    acc += 0.03;

    //acceleration linear decay
    acc -= 0.01;
    //constraints on acceleration
    acc = constrain(acc, 0, 0.85);
    //velocity exponetial decay
    vel *= 0.9;

    vel += acc;
    if (vel < 0.01) vel = 0;

    pos.add(PVector.fromAngle(toPlayer.heading()).mult(vel));
    dir = toPlayer.heading();

    displaypos.x = -tracked.x + pos.x;
    displaypos.y = -tracked.y + pos.y;

    collider.translate(pos.x, pos.y, 10);
    collider.rotate(dir);

    if (collidePolyPoly(getPoints(), playerCar.getPoints()));
    {
      //playerCar.health--;
    }
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

  void display() {
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
