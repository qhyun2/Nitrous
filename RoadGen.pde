class RoadGen {

  int[] roadX;
  int[] roadY;

  RoadGen(int sizeX, int sizeY) {
  
    int roadPieces = 300;
    roadX = new int[roadPieces];
    roadY = new int[roadPieces];

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

        if (range(x, 0, sizeX) && range(y, 0, sizeY))
        {
          roadX[current] = x;
          roadY[current] = y;
        } else {
          break;
        }
        current++;
      }
      
      len = 10;
      dir = int(random(4));
      //generate new lenght of road and direction
    }
  }
  void updateTiles() {
    for(int i = 0; i < roadX.length; i++){
        ground[roadX[i]][roadY[i]].type = 1;
    }
  }
}

boolean range(int value, int min, int max) {
  return value > min && value < max;
}
