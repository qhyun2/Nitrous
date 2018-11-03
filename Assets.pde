PImage[] roads;
PImage[] grass;
PShape car1, tree, building, clocktower;

void loadAssets() {
  roads = new PImage[5];  
  for (int i = 0; i < roads.length; i++) {
    roads[i] = loadImage("Assets/Sprites/Landscape/Road/RT" + (i+1) + ".png");
  }
  
  grass = new PImage[3];
  for (int i = 0; i < grass.length; i++) {
    grass[i] = loadImage("Assets/Sprites/Landscape/Field/Grass" + (i+1) + ".png");
  }
  
  car1 = loadShape("Assets/Models/testcar.obj");
  tree = loadShape("Assets/Models/AppleTree.obj");
  building = loadShape("Assets/Models/Building2.obj");
  clocktower = loadShape("Assets/Models/ClockTower.obj");
 
  
}
