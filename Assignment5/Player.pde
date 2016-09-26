class Player {
  int num; 
  int red, green, blue;
  int x, y;
  boolean inGame;
  Button lobbyButton;
  HashMap<String, String> keyMap;
  int bombsHeld, kills;
  public Player(int num, int red, int green, int blue) {
    this.num = num;
    this.red = red;
    this.green = green;
    this.blue = blue;
    inGame = false;
    lobbyButton = new Button(num * width/5, height/2, width/8, height/20, "Player " + num, 168, 168, 168);
    lobbyButton.num=this.num-1;
    keyMap = new HashMap<String, String>(); //maps key to action
    bombsHeld = 3;
    kills = 0;
  }

  public void dropIn() {
    inGame = true;
    lobbyButton.updateColor(red, green, blue);
  }

  public void dropOut() {
    inGame = false;
    lobbyButton.updateColor(168, 168, 168);
  }

  public void drawLobbyButton() {
    lobbyButton.checkHighlight();
    lobbyButton.drawButton();
  }
  
  public void drawScore(){
    stroke(red, green, blue);
    fill(red, green, blue);
    textSize(32);
    text("Player " + num, 10, height/8*num);
  }
  
  public void addKeyBinding(String function, String key1){
    keyMap.put(function, key1);
  }
  
  public void updateKeyBinding(String function, String key1){
    if(keyMap.containsKey(function)){
      keyMap.remove(function);
      keyMap.put(function, key1);
    }
  }
}