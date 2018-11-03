class AICar extends Vehicle {
  AICar(float x, float y, PShape iCarShape){
    super(x, y, iCarShape);
  }
  
  void update() {
    
    float turningSpeed = 0.01;

    //to make sure that dir is always inbetween +1 Pi and -1 Pi
    dir %= TWO_PI;
    dir = map(dir, -TWO_PI, TWO_PI, -PI, PI);

    //left and right turns
    float slopeBetweenCars = (pos.y-playerCar.pos.y)/(pos.x-playerCar.pos.x);
    float angleToPlayer = -atan(slopeBetweenCars);
    
    float deltaTheta = angleToPlayer - dir;
    if(deltaTheta <= PI) {
      //turning right
      if(deltaTheta > 0) {
        dir += turningSpeed * vel * 0.65;
        collider.rotate(turningSpeed * vel * 0.65);
      }
      //turning left
      if(deltaTheta < 0) {
        dir -= turningSpeed * vel * 0.65;
        collider.rotate(-turningSpeed * vel * 0.65);
      }
    }
    
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
    

    
    pos.add(PVector.fromAngle(dir).mult(vel));
  }
  
  void display() {
    pushMatrix();
    {
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
