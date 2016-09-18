class Settings{
  Player editing;
  GameLobby lobby;
  ArrayList<Button> buttons;
  
  public Settings(GameLobby lobby){
    this.lobby = lobby;
    buttons = new ArrayList<Button>();
    buttons.add(new Button(width/5, 30, width/6, height/20, "Player 1 Keys", 168, 168, 168));
    buttons.add(new Button(2*width/5, 30, width/6, height/20, "Player 2 Keys", 168, 168, 168));
    buttons.add(new Button(3*width/5, 30, width/6, height/20, "Player 3 Keys", 168, 168, 168));
    buttons.add(new Button(4*width/5, 30, width/6, height/20, "Player 4 Keys", 168, 168, 168));
  }
  
  public void loadKeys(){}
  
  public void drawSettings(){
    for(Button button : buttons){
      button.checkHighlight();
      button.drawButton();
    }
  }
}