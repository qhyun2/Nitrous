int state = 1;
int SPLASH = 0;
int PLAY = 1;
int GAMEOVER = 2;
boolean dead = false;

void update(){
   switch(state){
      case 0:
      drawSplash();
      break;
      case 1:
      drawGame();
      break;
      case 2:
      dead = true;
      break;
   }
}
