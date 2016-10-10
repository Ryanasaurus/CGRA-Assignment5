class Player {
  int num; 
  int red, green, blue;
  int x, y;
  int power = 1;
  boolean inGame;
  Button lobbyButton;
  HashMap<String, String> keyMap;
  int bombsHeld = 3;
  int powerHeld = 0;
  int pierceHeld = 0;
  int maxBombs = 3;
  int score = 0;
  PImage sprite;

  public Player(int num, int red, int green, int blue) {
    this.num = num;
    this.red = red;
    this.green = green;
    this.blue = blue;
    inGame = false;
    lobbyButton = new Button(num * width/5, height/2, width/8, height/20, "Player " + num, 168, 168, 168);
    lobbyButton.num=this.num-1;
    keyMap = new HashMap<String, String>(); //maps key to action
    sprite = loadImage("player" + num + "left.png");
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

  public void drawScore() {
    rectMode(CENTER);
    stroke(red, green, blue);
    fill(red, green, blue);
    textSize(32);
    text("Player " + num, 10, height/6*num);
    textSize(30);
    text("Kills: " + score, 200, height/6*num);
    //for (int i=0; i<bombsHeld; i++) {
    //  image(loadImage("bomb.png"), 20*i+10, height/3*num+20, 40, 40);
    //}
    text("Bombs: " + bombsHeld, 10, height/6*num+height/20);
    text("Pierce: " + pierceHeld, 10, height/6*num+height/10);
    text("Power: " + powerHeld, 10, height/6*num+height/5);
  }

  public void getBomb() {
    if (bombsHeld<maxBombs) {
      bombsHeld++;
    }
  }

  public void updateSprite(String dir) {
    if (dir.equals("up")) {
    sprite = loadImage("player" + num + "up.png");
    } else if (dir.equals("down")) {
    sprite = loadImage("player" + num + "down.png");
    } else if (dir.equals("left")) {
    sprite = loadImage("player" + num + "left.png");
    } else {
    sprite = loadImage("player" + num + "right.png");
    }
  }

  public void addKeyBinding(String function, String key1) {
    //keyMap.put(function, key1
  }

  public void updateKeyBinding(String function, String key1) {
    if (keyMap.containsKey(function)) {
      keyMap.remove(function);
      keyMap.put(function, key1);
    }
  }
  
  public int placeBomb() {
    if(powerHeld!=0){
      powerHeld--;
      return 2;
    } else if(pierceHeld!=0){
      pierceHeld--;
      return 1;
    } else if(bombsHeld!=0){
      bombsHeld--;
      return 0;
    } else {
      return -1;
    }
    //if (bombsHeld==0) {
    //  return 0;
    //} else {
    //  bombsHeld--; 
    //  return -1;
    //}
  }
  
  public void pickupItem(String type){
    if(type.equals("blastBoost")){power++;}
    else if(type.equals("heldBoost")){maxBombs++;}
    else if(type.equals("pierceBomb")){pierceHeld++;}
    else if(type.equals("powerBomb")){powerHeld++;}
  }  
  
  public void drawSprite(int x, int y, int imageWidth, int imageHeight){
    image(this.sprite, x, y, imageWidth, imageHeight);
  }
}