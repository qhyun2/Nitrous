class Vehicle {
  PVector pos, vel, acc;
  Vehicle(float x, float y) {
    pos = new PVector(x, y);
  }

  void update() {
    vel.add(acc);
    pos.add(vel);
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
      rotate(vel.heading());
    }
    popMatrix();
  }
}
