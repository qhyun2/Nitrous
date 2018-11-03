class Vehicle {
  PVector pos;
  float vel = 0, acc = 0;
  float dir;

  Vehicle(float x, float y) {
    pos = new PVector(x, y);
  }

  void update() {
    
    float turningSpeed = 0.05;

    if (keyA) {
    dir -= turningSpeed;
    }
    if (keyD) {
    dir += turningSpeed;
    }
    
    if (keyW) {
    acc += 0.04;
    }
    
    if (keyW) {
    acc -= 0.05;
    }
    
    acc -= 0.01;
    
    if(acc < 0)
    {
      acc = 0;
    }
    if(acc > 0.5)
    {
      acc = 0.5;
    }
    
    
    vel += acc;
    vel *= 0.9;
    
    if(vel < 0.01)
    {
      vel = 0;
    }
    
    println(vel, acc);
    
    pos.add(PVector.fromAngle(dir).mult(vel));
  }
}

class StarterCar extends Vehicle {
  StarterCar(float x, float y) {
    super(x, y);
  }

  void display() {
    pushMatrix();
    {
      translate(pos.x, pos.y);
      rotate(dir);
      rectMode(CENTER);
      fill(200);
      stroke(10);
      strokeWeight(1);
      rect(0, 0, 100, 60);
    }
    popMatrix();
  }
}
