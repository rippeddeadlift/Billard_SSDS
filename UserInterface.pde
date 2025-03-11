
class UserInterface{
  ControlP5 cp5;
  PeasyCam pc;
  MyCanvas cc;
  UserInterface(PApplet app, GameController gc){
    cp5 = new ControlP5(app);
    cc = new MyCanvas(gc);
    cc.post();
    cp5.addCanvas(cc);
    cp5.setAutoDraw(false);
    pc = new PeasyCam(app, 0);
  }
 
 void draw(){
   pc.beginHUD();
   cp5.draw();
   pc.endHUD();
 }
 
}
class MyCanvas extends Canvas {
  GameController gc;
  MyCanvas(GameController gc){
    this.gc = gc;
  }

  public void draw(PGraphics pg) {
    pg.fill(0);
      pg.rect(0, 0, width, height/15);
      pg.fill(255);
      pg.textAlign(TOP,TOP);
      pg.textSize(36);
    Player currentPlayer = gc.getCurrentPlayer();
    if(currentPlayer.ballType == BallType.NONE){
      pg.text(currentPlayer.name + "(Breakshot)", 10,10);
    }else{
      pg.text(currentPlayer.name + "(" + currentPlayer.ballType + ")", 10,10);
      pg.fill(255);
      drawPocketedBallsForPlayer(pg, currentPlayer);
    }
  }
  
  private void drawPocketedBallsForPlayer(PGraphics pg, Player currentPlayer){
    var scoredBalls = currentPlayer.getScoredBalls();
    var initialCircleXPosition = 250;
    if(scoredBalls.size() > 0){ 
      for(Ball b : scoredBalls){
        imageMode(CENTER);
        image(b.getIcon(), initialCircleXPosition += 30, 25, 30, 30);
      }
    }
  }
} //<>//
