PImage[] roads;
PImage[] grass;
PShape car1, tree, building, clocktower;

void loadAssets() {
  roads = new PImage[11];
  roads[0] = loadImage("Assets/Sprites/Landscape/Road/ld.png");
  roads[1] = loadImage("Assets/Sprites/Landscape/Road/rd.png");
  roads[2] = loadImage("Assets/Sprites/Landscape/Road/rdl.png");
  roads[3] = loadImage("Assets/Sprites/Landscape/Road/rl.png");
  roads[4] = loadImage("Assets/Sprites/Landscape/Road/ur.png");
  roads[5] = loadImage("Assets/Sprites/Landscape/Road/ud.png");
  roads[6] = loadImage("Assets/Sprites/Landscape/Road/udl.png");
  roads[7] = loadImage("Assets/Sprites/Landscape/Road/uld.png");
  roads[8] = loadImage("Assets/Sprites/Landscape/Road/ulr.png");
  roads[9] = loadImage("Assets/Sprites/Landscape/Road/ul.png");
  roads[10] = loadImage("Assets/Sprites/Landscape/Road/urdl.png");

  grass = new PImage[3];
  for (int i = 0; i < grass.length; i++) {
    grass[i] = loadImage("Assets/Sprites/Landscape/Field/Grass" + (i+1) + ".png");
  }

  car1 = loadShape("Assets/Models/testcar.obj");
  tree = loadShape("Assets/Models/AppleTree.obj");
  building = loadShape("Assets/Models/Building2.obj");
  clocktower = loadShape("Assets/Models/ClockTower.obj");
}
