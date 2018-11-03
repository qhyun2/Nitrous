class RoadGen {

  RoadGen(int sizeX, int sizeY) {

    //amount of road generated based on map size
    int roadPieces = 50 * 50 / 4;

    int x = 25;
    int y = 25;

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
        } else if (dir == 1) {
          y++;
        } else if (dir == 2) {
          x--;
        } else if (dir == 3) {
          y--;
        }

        //place road if current tile is in range
        if (range(x, 0, sizeX) && range(y, 0, sizeY))
        { 
          boolean top = testIfRoad(x + 1,y);
          boolean top = testIfRoad(x,y + 1);
          boolean top = testIfRoad(x - 1,y);
          boolean top = testIfRoad(x + 1,y - 1);
        } else {
          break;
        }
        current++;
      }

      len = 4 + int(random(8));
      dir = int(random(4));
      //generate new lenght of road and direction
    }
  }
}

boolean testIfRoad(int x, int y)
{
  //make sure index is in range
  if (range(x, 0, xSize) && range(y, 0, ySize))
  {
    int type = ground[x][y].type;
    return type == 1||type == 2||type == 3||type == 4||type == 5;
  }
  return false;
}
