class Game {
  String[][] map; //this 2d array is for the map, contains the players positions, walls, and empty squares
  Item[][] items; //this 2d array is for the items in the map, contains the bombs and powerups
  PVector[][] squares; //this 2d array is for the x and y coordinates of each square in the map. allows for easy drawing of the map
  Player[] players; //this array contains the players. is passed from the game lobby class.
  int mapWidth = 16, mapHeight = 16;
  int gameWidth = height-100;
  //boolean[] keysPressed;
  int moveSpeed;
  GameLobby lobby;
  boolean gameRunning = false;
  int bombRefreshCounter = 0;

  public Game(GameLobby lobby) {    
    map = new String[mapWidth][mapHeight];
    //players = new Player[4];
    this.lobby = lobby;
    //keysPressed = new boolean[4]; //0=w, 1=a, 2=s, 3=d
    squares = new PVector[mapWidth][mapHeight]; //array for the x and y co-ordinates of the top left of each square of the grid
    moveSpeed = ((height/mapWidth)/10);
    items = new Item[mapWidth][mapHeight];
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
        if (randomNumber>8) {
          map[i][j] = "wall";
          //map[i][j] = "blank";
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
          map[x][y] = "player" + player.num;
          player.x = x;
          player.y = y;
          done = true;
        }
      }
    }
  }

  public void drawMap() {
    bombRefreshCounter++;
    if (bombRefreshCounter>300) {
      bombRefreshCounter = 0;
      for (Player player : players) {
        player.getBomb();
      }
    }
    rectMode(CORNER);

    fill(0);
    stroke(168);
    strokeWeight(5);
    rect(0, 0, width/6, height);
    rect(width-width/6, 0, width/6, height);    

    for (int i=0; i<mapWidth; i++) {
      for (int j=0; j<mapHeight; j++) {
        if (map[i][j].equals("wall")) {
          fill(168, 168, 168);
          stroke(168, 168, 168);
          strokeWeight(1);  
          rect(squares[i][j].x, squares[i][j].y, gameWidth/mapWidth+6, gameWidth/mapHeight+6);
        } 
        if (items[i][j]!=null && items[i][j].type.equals("bomb")) {
          int bombWidth = (int)(gameWidth/2)/mapWidth+6;
          int bombHeight = (int)(gameWidth/2)/mapHeight+6;
          int x = (int)squares[i][j].x+((gameWidth/2)/mapWidth+6)/2;
          int y = (int)squares[i][j].y+((gameWidth/2)/mapHeight+6)/2;
          items[i][j].drawImage(x, y, bombWidth, bombHeight);
          if (items[i][j].countdown()) {
            doExplosion(i, j, items[i][j].power);
          }
        }
      }
    }

    for (Player player : players) {
      player.drawScore();
      rectMode(CORNER);
      fill(player.red, player.green, player.blue);
      stroke(player.red, player.green, player.blue);
      strokeWeight(1);
      rect(squares[player.x][player.y].x, squares[player.x][player.y].y, gameWidth/mapWidth+6, gameWidth/mapHeight+6);
    }
  }

  public void doExplosion(int x, int y, int power) {
    int up = y-1, down = y+1;
    int left = x-1, right = x+1;
    items[x][y] = new Item("explosion1", 1, 0.3);
    int counter = 0;
    while (up>0 && counter<power) {
      items[x][up] = new Item("explosion1", 1, 0.3);
      up--;
      counter++;
    }
    counter = 0;
    while (down<mapHeight && counter<power) {
      items[x][down] = new Item("explosion1", 1, 0.3);
      down--;
      counter++;
    }
    counter = 0;
    while (left>0 && counter<power) {
      items[left][y] = new Item("explosion1", 1, 0.3);
      left--;
      counter++;
    }
    counter = 0;
    while (right<mapWidth && counter<power) {
      items[right][y] = new Item("explosion1", 1, 0.3);
      right++;
      counter++;
    }
  }

  public void keyPushed(char key) {
    if (gameRunning) {
      //player 1
      if (key == 'w' || key == 'W') {
        if (players[0].y-1>=0) {
          if (map[players[0].x][players[0].y-1].equals("blank") && (items[players[0].x][players[0].y-1]==null || 
            (items[players[0].x][players[0].y-1]!=null && !items[players[0].x][players[0].y-1].type.equals("bomb")))) {
            map[players[0].x][players[0].y-1] = "player1";
            map[players[0].x][players[0].y] = "blank";
            players[0].y--;
          }
        }
      } else if (key == 'a' || key == 'A') {
        if (players[0].x-1>=0) {
          if (map[players[0].x-1][players[0].y].equals("blank") && (items[players[0].x-1][players[0].y]==null || 
            (items[players[0].x-1][players[0].y]!=null && !items[players[0].x-1][players[0].y].type.equals("bomb")))) {
            map[players[0].x-1][players[0].y] = "player1";
            map[players[0].x][players[0].y] = "blank";
            players[0].x--;
          }
        }
      } else if (key == 's' || key == 'S') {
        if (players[0].y+1<mapHeight) {
          if (map[players[0].x][players[0].y+1].equals("blank") && (items[players[0].x][players[0].y+1]==null || 
            (items[players[0].x][players[0].y+1]!=null && !items[players[0].x][players[0].y+1].type.equals("bomb")))) {
            map[players[0].x][players[0].y+1] = "player1";
            map[players[0].x][players[0].y] = "blank";
            players[0].y++;
          }
        }
      } else if (key == 'd' || key == 'D') {
        if (players[0].x+1<mapWidth) {
          if (map[players[0].x+1][players[0].y].equals("blank") && (items[players[0].x+1][players[0].y]==null || 
            (items[players[0].x+1][players[0].y]!=null && !items[players[0].x+1][players[0].y].type.equals("bomb")))) {
            map[players[0].x+1][players[0].y] = "player1";
            map[players[0].x][players[0].y] = "blank";
            players[0].x++;
          }
        }
      } else if (key == 'q' || key == 'Q') {
        if (players[0].placeBomb() && items[players[1].x][players[1].y]==null) {
          items[players[0].x][players[0].y] = new Item("bomb", players[0].power, 3);
        }
      }
      //player 2
      else if (key == 'i' || key == 'I') {
        if (players[1].y-1>=0) {
          if (map[players[1].x][players[1].y-1].equals("blank") && (items[players[1].x][players[1].y-1]==null || 
            (items[players[1].x][players[1].y-1]!=null && !items[players[1].x][players[1].y-1].type.equals("bomb")))) {
            map[players[1].x][players[1].y-1] = "player2";
            map[players[1].x][players[1].y] = "blank";
            players[1].y--;
          }
        }
      } else if (key == 'j' || key == 'J') {
        if (players[1].x-1>=0) {
          if (map[players[1].x-1][players[1].y].equals("blank") && (items[players[1].x-1][players[1].y]==null || 
            (items[players[1].x-1][players[1].y]!=null && !items[players[1].x-1][players[1].y].type.equals("bomb")))) {
            map[players[1].x-1][players[1].y] = "player2";
            map[players[1].x][players[1].y] = "blank";
            players[1].x--;
          }
        }
      } else if (key == 'k' || key == 'K') {
        if (players[1].y+1<mapHeight) {
          if (map[players[1].x][players[1].y+1].equals("blank") && (items[players[1].x][players[1].y+1]==null || 
            (items[players[1].x][players[1].y-+1]!=null && !items[players[1].x][players[1].y+1].type.equals("bomb")))) {
            map[players[1].x][players[1].y+1] = "player2";
            map[players[1].x][players[1].y] = "blank";
            players[1].y++;
          }
        }
      } else if (key == 'l' || key == 'L') {      
        if (players[1].x+1<mapWidth) {
          if (map[players[1].x+1][players[1].y].equals("blank") && (items[players[1].x+1][players[1].y]==null || 
            (items[players[1].x+1][players[1].y]!=null && !items[players[1].x+1][players[1].y].type.equals("bomb")))) {
            map[players[1].x+1][players[1].y] = "player2";
            map[players[1].x][players[1].y] = "blank";
            players[1].x++;
          }
        }
      } else if (key == 'u' || key == 'U') {
        if (players[1].placeBomb() && items[players[1].x][players[1].y]==null) {
          items[players[1].x][players[1].y] = new Item("bomb", players[1].power, 3);
        }
      }
    }
  }
}