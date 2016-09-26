class Game {
  String[][] map;
  boolean[][] powerups;
  PVector[][] squares;
  Player[] players;
  int mapWidth = 16, mapHeight = 16;
  int gameWidth = height-100;
  boolean[] keysPressed;
  int moveSpeed;
  GameLobby lobby;
  boolean gameRunning = false;

  public Game(GameLobby lobby) {    
    map = new String[mapWidth][mapHeight];
    //players = new Player[4];
    this.lobby = lobby;
    keysPressed = new boolean[4]; //0=w, 1=a, 2=s, 3=d
    squares = new PVector[mapWidth][mapHeight]; //array for the x and y co-ordinates of the top left of each square of the grid
    moveSpeed = ((height/mapWidth)/10);
  }

  public void newMap() {

    this.players = lobby.players;

    //    players[0].x = width/2;
    //    players[0].y = height/2;
    for (int i=0; i<mapWidth; i++) {
      for (int j=0; j<mapHeight; j++) {
        squares[i][j] = new PVector((width-height)/2+(height/mapWidth)*i, (height/mapHeight)*j);
        //squares[i][j].x = (width-height)/2+(height/mapWidth)*i;
        //squares[i][j].y = (height/mapHeight)*j;
        double randomNumber = random(10);
        if (randomNumber>7) {
          map[i][j] = "wall";
        } else {
          map[i][j] = "blank";
        }
      }
    }
    for (Player player : players) {
      boolean done = false;
      while (!done) {
        int x = (int)(random(mapWidth));
        int y = (int)(random(mapWidth));
        if (map[x][y].equals("blank")) {
          player.x = (int)squares[x][y].x;
          player.y = (int)squares[x][y].y;
          done = true;
        }
      }
    }
  }

  public void drawMap() {
    rectMode(CORNER);

    fill(0);
    stroke(168);
    strokeWeight(5);
    rect(0, 0, width/6, height);
    rect(width-width/6, 0, width/6, height);    
    fill(168, 168, 168);
    stroke(168, 168, 168);
    strokeWeight(1);
    for (int i=0; i<mapWidth; i++) {
      for (int j=0; j<mapHeight; j++) {
        if (map[i][j].equals("wall")) {
          rect(squares[i][j].x, squares[i][j].y, gameWidth/mapWidth+6, gameWidth/mapHeight+6);
        }
      }
    }
    rectMode(CENTER);
    for (Player player : players) {
      player.drawScore();
    }
    fill(players[0].red, players[0].green, players[0].blue);
    strokeWeight(1);
    stroke(players[0].red, players[0].green, players[0].blue);
    rectMode(CORNER);
    rect(players[0].x+(height/mapWidth)/4, players[0].y+(height/mapHeight)/4, (height/mapWidth)/2, (height/mapWidth)/2);
    if (keysPressed[0]) {
      players[0].y-=moveSpeed;
    }
    if (keysPressed[1]) {
      players[0].x-=moveSpeed;
    }
    if (keysPressed[2]) {
      players[0].y+=moveSpeed;
    }
    if (keysPressed[3]) {
      players[0].x+=moveSpeed;
    }
  }
}