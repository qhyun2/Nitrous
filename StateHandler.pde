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
        background(0,0,0);
        textAlign(CENTER, CENTER);
        textSize(40);
        text("Game Over!", width/2, height/2);
        break;
   }
}
