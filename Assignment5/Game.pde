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
  int powerup1Count = 360, powerup2Count = 540, powerup3Count = 660, powerup4Count = 840;
  PImage wall = loadImage("wall.png"), bricks = loadImage("bricks.png"), background = loadImage("background.png");

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
    for (int i=0; i<mapWidth; i++) {
      for (int j=0; j<mapHeight; j++) {
        squares[i][j] = new PVector((width-height)/2+(height/mapWidth)*i, (height/mapHeight)*j);
        double randomNumber = random(10);
        if (randomNumber>7) {
          map[i][j] = "bricks";
        } else {
          map[i][j] = "blank";
        }
        if (((i%3)==0) && ((j%3)==0)) {
          map[i][j] = "wall";
        }
        if (items[i][j]!=null) {
          items[i][j] = null;
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
    refreshBombs(); //method to countdown time until new bombs are given to players
    rectMode(CORNER);
    fill(0);
    stroke(168);
    strokeWeight(5);
    rect(0, 0, squares[0][0].x, height);
    int boxX = (int)squares[mapWidth-1][mapHeight-1].x + (gameWidth)/mapHeight+6;
    rect(boxX, 0, width-boxX, height);
    doPowerup();

    for (int i=0; i<mapWidth; i++) {
      for (int j=0; j<mapHeight; j++) {
        //int x = (int)squares[i][j].x;
        //int y = (int)squares[i][j].y;
        if (items[i][j]!=null && map[i][j].equals("blank") && (!items[i][j].type.equals("bomb") || !items[i][j].type.contains("explosion"))) {
          int itemWidth = (int)(gameWidth/2)/mapWidth+6;
          int itemHeight = (int)(gameWidth/2)/mapHeight+6;
          int x = (int)squares[i][j].x+((gameWidth/2)/mapWidth+6)/2;
          int y = (int)squares[i][j].y+((gameWidth/2)/mapHeight+6)/2;
          //rect(x, y, itemWidth, itemHeight);
          items[i][j].drawSprite(x, y, itemWidth, itemHeight);
        }
        if (map[i][j].equals("bricks")) {
          fill(168);
          stroke(168);
          strokeWeight(1);  
          //rect(squares[i][j].x, squares[i][j].y, gameWidth/mapWidth+6, gameWidth/mapHeight+6);
          image(bricks, squares[i][j].x, squares[i][j].y, gameWidth/mapWidth+6, gameWidth/mapHeight+6);
        } else if (map[i][j].equals("wall")) {
          image(wall, squares[i][j].x, squares[i][j].y, gameWidth/mapWidth+6, gameWidth/mapHeight+6);
          fill(100);
          stroke(100);
          strokeWeight(1);  
          //rect(squares[i][j].x, squares[i][j].y, gameWidth/mapWidth+6, gameWidth/mapHeight+6);
        } else if (map[i][j].equals("blank")) {          
          //image(background, squares[i][j].x, squares[i][j].y, gameWidth/mapWidth+6, gameWidth/mapHeight+6);
        }
        if (items[i][j]!=null && items[i][j].type.equals("bomb")) {
          int bombWidth = (int)(gameWidth/2)/mapWidth+6;
          int bombHeight = (int)(gameWidth/2)/mapHeight+6;
          int x = (int)squares[i][j].x+((gameWidth/2)/mapWidth+6)/2;
          int y = (int)squares[i][j].y+((gameWidth/2)/mapHeight+6)/2;
          items[i][j].drawSprite(x, y, bombWidth, bombHeight);
          if (items[i][j].countdown()) {
            doExplosion(i, j, items[i][j].power);
          }
        } else if (items[i][j]!=null && items[i][j].type.contains("explosion")) {
          int explosionWidth = (int)(gameWidth/2)/mapWidth+6;
          int explosionHeight = (int)(gameWidth/2)/mapHeight+6;
          int x = (int)squares[i][j].x+((gameWidth/2)/mapWidth+6)/2;
          int y = (int)squares[i][j].y+((gameWidth/2)/mapHeight+6)/2;
          items[i][j].drawSprite(x, y, explosionWidth, explosionHeight);          
          if (items[i][j].countdown()) {
            items[i][j]=null;
          }
        }
      }
    }
    if (items[players[0].x][players[0].y]!=null && items[players[0].x][players[0].y].type.contains("explosion")) {
      players[1].score++;
      restartGame();
      return;
    } else if (items[players[1].x][players[1].y]!=null && items[players[1].x][players[1].y].type.contains("explosion")) {
      players[0].score++;
      restartGame();
      return;
    }


    for (Player player : players) {
      player.drawScore();
      //rectMode(CORNER);
      //fill(player.red, player.green, player.blue);
      //stroke(player.red, player.green, player.blue);
      int imageWidth = (int)(gameWidth)/mapWidth+6;
      int imageHeight = (int)(gameWidth)/mapHeight+6;
      int x = (int)squares[player.x][player.y].x;//+((gameWidth)/mapWidth+6)/2;
      int y = (int)squares[player.x][player.y].y;//+((gameWidth)/mapHeight+6)/2;
      player.drawSprite(x, y, imageWidth, imageHeight);
      strokeWeight(1);
      //rect(squares[player.x][player.y].x, squares[player.x][player.y].y, gameWidth/mapWidth+6, gameWidth/mapHeight+6);
      if (items[player.x][player.y]!=null && !items[player.x][player.y].type.equals("bomb") && !items[player.x][player.y].type.equals("explosion")) {
        player.pickupItem(items[player.x][player.y].type);
        items[player.x][player.y] = null;
      }
    }
  }

  public void doExplosion(int x, int y, int power) {
    int up = y-1, down = y+1;
    int left = x-1, right = x+1;
    items[x][y] = new Item("explosion", 1, 1);
    int counter = 0;
    while (up>=0 && counter<power) {
      if (map[x][up].equals("wall")) { 
        break;
      }
      if (items[x][up]!=null && items[x][up].type.equals("bomb")) {
        doExplosion(x, up, items[x][up].power);
      }
      items[x][up] = new Item("explosion", 1, 1);

      if (map[x][up].equals("bricks")) {
        map[x][up] = "blank";
        float itemGen = random(10);
        if (itemGen>8) {
          items[x][up].hidingItem = true;
        }
        break;
      }
      up--;
      counter++;
    }
    counter = 0;
    while (down<mapHeight && counter<power) {
      if (map[x][down].equals("wall")) { 
        break;
      }
      if (items[x][down]!=null && items[x][down].type.equals("bomb")) {
        doExplosion(x, down, items[x][down].power);
      }
      items[x][down] = new Item("explosion", 1, 1);
      if (map[x][down].equals("bricks")) {
        map[x][down] = "blank";
        float itemGen = random(10);
        if (itemGen>8) {
          items[x][down].hidingItem = true;
        }
        break;
      }
      down--;
      counter++;
    }
    counter = 0;
    while (left>=0 && counter<power) {
      if (map[left][y].equals("wall")) { 
        break;
      }
      if (items[left][y]!=null && items[left][y].type.equals("bomb")) {
        doExplosion(left, y, items[left][y].power);
      }
      items[left][y] = new Item("explosion", 1, 1);
      if (map[left][y].equals("bricks")) {
        map[left][y] = "blank";
        float itemGen = random(10);
        if (itemGen>8) {
          items[left][y].hidingItem = true;
        }
        break;
      }
      left--;
      counter++;
    }
    counter = 0;
    while (right<mapWidth && counter<power) {
      if (map[right][y].equals("wall")) { 
        break;
      }
      if (items[right][y]!=null && items[right][y].type.equals("bomb")) {
        doExplosion(right, y, items[right][y].power);
      }
      items[right][y] = new Item("explosion", 1, 1);
      if (map[right][y].equals("bricks")) {
        map[right][y] = "blank";
        float itemGen = random(10);
        if (itemGen>8) {
          items[right][y].hidingItem = true;
        }
        break;
      }
      right++;
      counter++;
    }
  }

  public void doPowerExplosion() {
  }
  public void doPierceExplosion() {
  }

  public void refreshBombs() {
    bombRefreshCounter++;
    if (bombRefreshCounter>180) {
      bombRefreshCounter = 0;
      for (Player player : players) {
        player.getBomb();
      }
    }
  }

  public void restartGame() {
    newMap();
    for (Player player : players) {
      player.maxBombs = 3;
      player.bombsHeld = 3;
    }
  }

  public void doPowerup() {
    powerup1Count--;
    powerup2Count--;
    powerup3Count--;
    powerup4Count--;
    if (powerup1Count==0) {
      powerup1Count = 360;
      items[(int)random(mapWidth)][(int)random(mapHeight)] = new Item("heldBoost", -1, -1);
    }
    if (powerup2Count==0) {
      powerup2Count = 540;
      items[(int)random(mapWidth)][(int)random(mapHeight)] = new Item("blastBoost", -1, -1);
    }
    if (powerup3Count==0) {
      powerup3Count = 660;
      items[(int)random(mapWidth)][(int)random(mapHeight)] = new Item("pierceBomb", -1, -1);
    }
    if (powerup4Count==0) {
      powerup4Count = 840;
      items[(int)random(mapWidth)][(int)random(mapHeight)] = new Item("powerBomb", -1, -1);
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
            players[0].updateSprite("up");
            players[0].y--;
          }
        }
      } else if (key == 'a' || key == 'A') {
        if (players[0].x-1>=0) {
          if (map[players[0].x-1][players[0].y].equals("blank") && (items[players[0].x-1][players[0].y]==null || 
            (items[players[0].x-1][players[0].y]!=null && !items[players[0].x-1][players[0].y].type.equals("bomb")))) {
            map[players[0].x-1][players[0].y] = "player1";
            map[players[0].x][players[0].y] = "blank";
            players[0].updateSprite("left");
            players[0].x--;
          }
        }
      } else if (key == 's' || key == 'S') {
        if (players[0].y+1<mapHeight) {
          if (map[players[0].x][players[0].y+1].equals("blank") && (items[players[0].x][players[0].y+1]==null || 
            (items[players[0].x][players[0].y+1]!=null && !items[players[0].x][players[0].y+1].type.equals("bomb")))) {
            map[players[0].x][players[0].y+1] = "player1";
            map[players[0].x][players[0].y] = "blank";
            players[0].updateSprite("down");
            players[0].y++;
          }
        }
      } else if (key == 'd' || key == 'D') {
        if (players[0].x+1<mapWidth) {
          if (map[players[0].x+1][players[0].y].equals("blank") && (items[players[0].x+1][players[0].y]==null || 
            (items[players[0].x+1][players[0].y]!=null && !items[players[0].x+1][players[0].y].type.equals("bomb")))) {
            map[players[0].x+1][players[0].y] = "player1";
            map[players[0].x][players[0].y] = "blank";
            players[0].updateSprite("right");
            players[0].x++;
          }
        }
      } else if (key == 'q' || key == 'Q') {
        if (gameRunning) {
          if (items[players[1].x][players[1].y]==null) { 
            int bombType = players[0].placeBomb();
            if (bombType==-1) {
              return;
            } else if (bombType==0) {
              items[players[0].x][players[0].y] = new Item("bomb", players[0].power, -1);
            } else if (bombType==1) {              
              items[players[0].x][players[0].y] = new Item("pierceBomb", players[0].power, -1);
            } else if (bombType==2) {              
              items[players[0].x][players[0].y] = new Item("powerBomb", players[0].power, -1);
            }
          }
        }
      }
      //player 2
      else if (key == 'i' || key == 'I') {
        if (players[1].y-1>=0) {
          if (map[players[1].x][players[1].y-1].equals("blank") && (items[players[1].x][players[1].y-1]==null || 
            (items[players[1].x][players[1].y-1]!=null && !items[players[1].x][players[1].y-1].type.equals("bomb")))) {
            map[players[1].x][players[1].y-1] = "player2";
            map[players[1].x][players[1].y] = "blank";
            players[1].updateSprite("up");
            players[1].y--;
          }
        }
      } else if (key == 'j' || key == 'J') {
        if (players[1].x-1>=0) {
          if (map[players[1].x-1][players[1].y].equals("blank") && (items[players[1].x-1][players[1].y]==null || 
            (items[players[1].x-1][players[1].y]!=null && !items[players[1].x-1][players[1].y].type.equals("bomb")))) {
            map[players[1].x-1][players[1].y] = "player2";
            map[players[1].x][players[1].y] = "blank";
            players[1].updateSprite("left");
            players[1].x--;
          }
        }
      } else if (key == 'k' || key == 'K') {
        if (players[1].y+1<mapHeight) {
          if (map[players[1].x][players[1].y+1].equals("blank") && (items[players[1].x][players[1].y+1]==null || 
            (items[players[1].x][players[1].y-+1]!=null && !items[players[1].x][players[1].y+1].type.equals("bomb")))) {
            map[players[1].x][players[1].y+1] = "player2";
            map[players[1].x][players[1].y] = "blank";
            players[1].updateSprite("down");
            players[1].y++;
          }
        }
      } else if (key == 'l' || key == 'L') {      
        if (players[1].x+1<mapWidth) {
          if (map[players[1].x+1][players[1].y].equals("blank") && (items[players[1].x+1][players[1].y]==null || 
            (items[players[1].x+1][players[1].y]!=null && !items[players[1].x+1][players[1].y].type.equals("bomb")))) {
            map[players[1].x+1][players[1].y] = "player2";
            map[players[1].x][players[1].y] = "blank";
            players[1].updateSprite("right");
            players[1].x++;
          }
        }
      } 
      //else if (key == 'u' || key == 'U') {
      //  if (items[players[1].x][players[1].y]==null && players[1].placeBomb()) {
      //    items[players[1].x][players[1].y] = new Item("bomb", players[1].power, -1);
      //  }
      //}
    }
  }
}