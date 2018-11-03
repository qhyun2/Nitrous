class Vehicle {
  PVector pos;
  float vel = 0, acc = 0;
  float dir;

  Vehicle(float x, float y) {
    pos = new PVector(x, y);
  }

  void update() {
    
    float turningSpeed = 0.01;
  
    //left and right turns
    if (keyA) {
    dir -= turningSpeed * vel;
    }
    if (keyD) {
    dir += turningSpeed * vel;
    }
    
    
    //gas and break
    if (keyW) {
    acc += 0.03;
    }
    
    if (keyS) {
    acc -= 0.06;
    }
    
    //acceleration linear decay
    acc -= 0.01;
    
    //constraints on acceleration
    if(acc < 0)
      acc = 0;
    else if(acc > 0.5)
      acc = 0.5;
    
    vel += acc;
    
    //velocity exponetial decay
    vel *= 0.9;
    
    if(vel < 0.01)
      vel = 0;
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
