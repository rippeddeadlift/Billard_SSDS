class GameController {
    Player player1;
    Player player2;
    Player currentPlayer;  
    boolean playerSwitched = false;
    CBalls cBalls;
    boolean foulOccurred = false;
    boolean shouldSwitchPlayer = false;  
    ArrayList<Ball> pocketedBalls ;
    boolean firstTurn = true;

    GameController(Player player1, Player player2) {
        this.player1 = player1;
        this.player2 = player2;
        this.currentPlayer = player1;
    }
        void setBalls(CBalls cBalls){
        this.cBalls = cBalls;
    }
    
    void switchPlayer() {
        if (currentPlayer == player1) {
            player1.endTurn();
            currentPlayer = player2;
            player2.startTurn();
        } else {
            player2.endTurn();            
            currentPlayer = player1;
            player1.startTurn();
        }
    }
void manage(ArrayList<Ball> pocketedBalls) {
    if (pocketedBalls.isEmpty() && currentGameState == GameState.READY && !firstTurn) {
        if (!playerSwitched) {
            switchPlayer();
            playerSwitched = true;
        }
        return;
    }
    for (Ball b : pocketedBalls) {
        if (b.isWhiteBall) {
            currentGameState = GameState.FOUL;
            foulOccurred = true; 
            continue;
        }
        assignBallTypeToPlayer(b);          
        int currentOpponentScore = currentOpponent().score;
        currentPlayer.addPoint(b, cBalls, currentOpponent());
        if (currentOpponentScore < currentOpponent().score) {
            shouldSwitchPlayer = true; 
        }
    }
    if (foulOccurred || shouldSwitchPlayer) {
        switchPlayer(); 
        foulOccurred = false; 
        shouldSwitchPlayer = false; 
    }
    else{        
        playerSwitched = false;
    }
    firstTurn = false;
}


    void assignBallTypeToPlayer(Ball b){
            if (currentPlayer.ballType == BallType.NONE && (b.ballType == BallType.SOLID || b.ballType == BallType.STRIPE)) {
                currentPlayer.assignBallType(b.ballType, currentOpponent());
            }
    }


     Player currentOpponent() {
        return (currentPlayer == player1) ? player2 : player1;
    }
    Player getCurrentPlayer(){
      return this.currentPlayer;
    }
}
