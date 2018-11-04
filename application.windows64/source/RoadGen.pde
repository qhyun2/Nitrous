void roadGen(int sizeX, int sizeY) {

  //amount of road generated based on map size
  int roadPieces = (sizeX * sizeY) / 5;
  //roadPieces = 100;

  int x = floor(random(0, sizeX));
  int y = floor(random(0, sizeY));

  int current = 0;
  int dir = 1;
  int len = 10;

  //loop until enough road placed
  while (current < roadPieces) {
    //loop until determined lenght of road used or enough road placed
    while (len > 0 && current < roadPieces)
    {
      len--;
      //update position based on direction
      if (dir == 0) {
        x++;
        //place road if current tile is in range
      if (range(x, 0, sizeX / 2) && range(y, 0, sizeY / 2))
      {
        ground[x * 2 - 1][y * 2].type = ROAD;
        ground[x * 2][y * 2].type = ROAD;
      }
      } else if (dir == 1) {
        y++;
        //place road if current tile is in range
      if (range(x, 0, sizeX / 2) && range(y, 0, sizeY / 2))
      {
        ground[x * 2][y * 2 - 1].type = ROAD;
        ground[x * 2][y * 2].type = ROAD;
      }
      } else if (dir == 2) {
        x--;
        //place road if current tile is in range
      if (range(x, 0, sizeX / 2) && range(y, 0, sizeY / 2))
      {
        ground[x * 2 + 1][y * 2].type = ROAD;
        ground[x * 2][y * 2].type = ROAD;
      }
      } else if (dir == 3) {
        y--;
        //place road if current tile is in range
      if (range(x, 0, sizeX / 2) && range(y, 0, sizeY / 2))
      {
        ground[x * 2][y * 2 + 1].type = ROAD;
        ground[x * 2][y * 2].type = ROAD;
      }
      }

      //place road if current tile is in range
      if (range(x, 0, sizeX / 2) && range(y, 0, sizeY / 2))
      {
        ground[x * 2][y * 2].type = ROAD;
      } else {
        len = 0;
        break;
      }
      current++;
    }
    
    
    
    //generate new lenght of road and direction
    len = (20 + int(random(15))) / 2;
    int newdir = dir;
    do {
      newdir = int(random(4));
    } while (newdir == dir);
    dir = newdir;
  }
  connectRoads();
}

void connectRoads() {
  //update roads to look connected
  for (int i = 0; i <ground.length; i++) {
    for (int j = 0; j < ground[i].length; j++) {
      if (ground[i][j].type == ROAD) {

        boolean up = testIfRoad(i + 1, j);
        boolean right = testIfRoad(i, j + 1);
        boolean down = testIfRoad(i - 1, j);
        boolean left = testIfRoad(i, j - 1);

        int tileType = 0;
        if (right || left) tileType = 5;
        if (up || down) tileType = 3;

        if (up && right) tileType = 1;
        if (right && down) tileType = 0;
        if (down && left) tileType = 9;
        if (left && up) tileType = 4;

        if (up && right && down) tileType = 2;
        if (right && down && left) tileType = 6;
        if (down && left && up) tileType = 8;
        if (left && up && right) tileType = 7;

        if (right && left && up && down) tileType = 10;

        ground[i][j].tileType = tileType;
      }
    }
  }
}

boolean testIfRoad(int x, int y)
{
  //make sure index is in range
  if (range(x, 0, xSize) && range(y, 0, ySize))
  {
    return ground[x][y].type == ROAD;
  }
  return false;
}
