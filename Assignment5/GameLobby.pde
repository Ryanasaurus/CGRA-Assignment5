class GameLobby {
  int playerCount;
  Button back;
  Player [] players;

  public GameLobby() {
    playerCount = 0;
    players = new Player[2];
    players[0] = new Player(1, 50, 50, 255);//blue player 1
    players[1] = new Player(2, 255, 50, 50);//red player 2
    //players[2] = new Player(3, 50, 255, 50);//green player 3
    //players[3] = new Player(4, 255, 255, 0);//yellow player 4
    back = new Button(width-width/7, height-height/15, width/8, height/20, "Back", 168, 168, 168); //button to go back to main menu
  }

  public void dropPlayer() {
    playerCount--;
  }
  public void addPlayer() {
    playerCount++;
  }

  public void drawLobby() {
    for (Player player : players) {
      player.drawLobbyButton();
    }
    back.checkHighlight();
    back.drawButton();
  }
}