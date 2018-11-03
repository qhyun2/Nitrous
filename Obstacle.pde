class Obstacle {
  PShape collider;
  int type;
  float scale;
  Obstacle(int type) {
    this.type = type;
    switch (type) {
      case 0: //Tree, bitch
        collider = createShape(RECT, 0, 0, 10, 10);
        scale = 20;
        break;
      case 1: //Those buildy things
        collider = createShape(RECT, 0, 0, 10, 10);        
        scale = 27.5;
        break;
      case 2: //Ding Dong the clunk has sung
      collider = createShape(RECT, 0, 0, 10, 10);
        scale = 100;
        break;
      default: //If u were dumm and didn't pass the write thing
      collider = createShape(RECT, 0, 0, 10, 10);
        scale = 20;
        break;
    }
    //collider.rotateX(HALF_PI);
    collider.setStroke(color(255));
    collider.setStrokeWeight(4);
    collider.setFill(color(127));
  }
  
  void display() {
    scale(scale);
    rotateX(HALF_PI);
    shape(obst[type], 0, 0);
    shape(collider, 0, 0);
  }
  
}
