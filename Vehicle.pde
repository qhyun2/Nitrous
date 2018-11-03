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
