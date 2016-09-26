class Game {
  String[][] map;
  boolean[][] powerups;
  Player[] players;
  int mapWidth = 16, mapHeight = 16;
  int gameWidth = height-100;
  boolean[] keysPressed;
  int moveSpeed = 10;

  public Game() {    
    map = new String[mapWidth][mapHeight];
    players = new Player[4];
    players[0] = new Player(1, 50, 50, 255);//blue player 1
    players[1] = new Player(2, 255, 50, 50);//red player 2
    players[0].x = width/2;
    players[0].y = height/2;
    keysPressed = new boolean[4]; //0=w, 1=a, 2=s, 3=d
  }

  public void newMap() {
    for (int i=0; i<mapWidth; i++) {
      for (int j=0; j<mapHeight; j++) {
        double randomNumber = random(10);
        if (randomNumber>7) {
          map[i][j] = "wall";
        } else {
          map[i][j] = "blank";
        }
      }
    }
    map[mapWidth/2][mapHeight/2]="blank";
  }

  public void drawMap() {
    rectMode(CORNER);
    fill(168, 168, 168);
    stroke(168, 168, 168);
    rect(0, 0, width/6, height);
    rect(width-width/6, 0, width/6, height);
    for (int i=0; i<mapWidth; i++) {
      for (int j=0; j<mapHeight; j++) {
        if (map[i][j].equals("wall")) {
          rect(gameWidth/mapWidth*j+width/5, gameWidth/mapHeight*i+height/20, gameWidth/mapWidth, gameWidth/mapHeight);
        }
      }
    }
    rectMode(CENTER);
    fill(players[0].red, players[0].green, players[0].blue);
    strokeWeight(1);
    stroke(players[0].red, players[0].green, players[0].blue);
    rect(players[0].x, players[0].y, 50, 50);
    if(keysPressed[0]){
      players[0].y-=moveSpeed;
    }
    if(keysPressed[1]){
      players[0].x-=moveSpeed;
    }
    if(keysPressed[2]){
      players[0].y+=moveSpeed;
    }
    if(keysPressed[3]){
      players[0].x+=moveSpeed;
    }
  }

  
}