class Player {
  String name;
  int score;
  boolean isTurn;
  BallType ballType = BallType.NONE;  
  int shots;
  Player winner ;
    ArrayList<Ball> scoredBalls  = new ArrayList<>();
  
  Player(String name) {
    this.name = name;
    this.score = 0;
    this.isTurn = false;
  }
  void draw(){
    if (currentGameState == GameState.FINISHED){
        winGame();
    }
  }
  
  void startTurn() {
    isTurn = true;
  }
  
  void endTurn() {
    isTurn = false;
  }
  
void addPoint(Ball b, CBalls cballs, Player currentOpponent) {
if (!scoredBalls.contains(b)) {
        if (b.bn == 10) {
            handleBlackBall(cballs, currentOpponent);  
        } else {
            handleRegularBall(b, currentOpponent);
        }
        
        scoredBalls.add(b);
    }
}

private void handleBlackBall(CBalls cballs, Player currentOpponent) {
    if (ballType == BallType.NONE ) {
        awardPoints(currentOpponent, 8); 
        }
    if (ballType == BallType.SOLID && cballs.solidBallsRemaining()) {
        awardPoints(currentOpponent, 8); 
    } else if (ballType == BallType.STRIPE && cballs.stripeBallsRemaining()) {
        awardPoints(currentOpponent, 8);   //<>//
    } else if (ballType == BallType.SOLID && !cballs.solidBallsRemaining()) {
        awardPoints(this, 8); 
    } else if (ballType == BallType.STRIPE && !cballs.stripeBallsRemaining()) {
        awardPoints(this, 8);  
    }
}

private void handleRegularBall(Ball b, Player currentOpponent) {
    if (ballType == b.ballType) {
        score++;  
    } else {
        currentOpponent.score++;  
    }
}

private void awardPoints(Player p, int points) {
    if (this.winner == null) {
        this.winner = p;   
        p.winner = p; 
        p.score += points;               
        currentGameState = GameState.FINISHED; 
        return;
    }
}

void winGame() {
    showGameOverScreen(); //<>//
    }

void showGameOverScreen() {
    fill(0, 0, 0, 150);  
    rect(0, 0, width, height);  
    
    fill(255);
    textSize(50);
    
    text("Game Over!", width / 3, height / 2);
    
    text(this.winner.name + " won the game!", width / 8, height / 2 + 100);  
    text("Score: "+ this.winner.score , width / 3, height / 2 + 200);
}

 //<>//

void assignBallType(BallType bType, Player currentOpponent) {
        ballType = bType; //<>//
        if (bType == BallType.SOLID) { //<>//
            currentOpponent.ballType = BallType.STRIPE;
        } else if (bType == BallType.STRIPE) {
            currentOpponent.ballType = BallType.SOLID;
        }

        println(name + " is assigned " + ballType);
        println(currentOpponent.name + " is assigned " + currentOpponent.ballType);
}


String getStatus() {
    return name + " | Score: " + score + " | " + (isTurn ? "Your turn" : "Waiting") + " | " + "BallType: " + ballType;
}

}
