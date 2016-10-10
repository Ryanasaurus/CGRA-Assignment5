class Game {
  String[][] map; //this 2d array is for the map, contains the players positions, walls, and empty squares
  Item[][] items; //this 2d array is for the items in the map, contains the bombs and powerups
  PVector[][] squares; //this 2d array is for the x and y coordinates of each square in the map. allows for easy drawing of the map
  Player[] players; //this array contains the players. is passed from the game lobby class.
  int mapWidth = 16, mapHeight = 16;
  int gameWidth = height-100;
  int moveSpeed;
  boolean gameRunning = false;
  int bombRefreshCounter = 0;
  int powerup1Count = 360, powerup2Count = 540, powerup3Count = 660, powerup4Count = 840;
  PImage wall = loadImage("wall.png"), bricks = loadImage("bricks.png");

  public Game() {    
    map = new String[mapWidth][mapHeight];
    players = new Player[2];
    players[0] = new Player(1, 50, 50, 255);//blue player 1
    players[1] = new Player(2, 255, 50, 50);//red player 2
    squares = new PVector[mapWidth][mapHeight]; //array for the x and y co-ordinates of the top left of each square of the grid
    moveSpeed = ((height/mapWidth)/10);
    items = new Item[mapWidth][mapHeight];
  }

  public void newMap() {
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

    int squareWidth = gameWidth/mapWidth+6;
    int squareHeight = gameWidth/mapHeight+6;
    int itemWidth = (int)(gameWidth/2)/mapHeight+6;
    int itemHeight = (int)(gameWidth/2)/mapHeight+6;
    for (int i=0; i<mapWidth; i++) {
      for (int j=0; j<mapHeight; j++) {
        int x = (int)squares[i][j].x;
        int y = (int)squares[i][j].y;
        int itemx = (int)x+itemWidth/2;
        int itemy = (int)y+itemHeight/2;
        //strokeWeight(1);  

        //drawing the map and players
        if (!map[i][j].equals("blank")) {
          if (map[i][j].equals("bricks")) {
            image(bricks, x, y, squareWidth, squareHeight);
          } else if (map[i][j].equals("wall")) {
            image(wall, x, y, squareWidth, squareHeight);
          } else if (map[i][j].equals("player1")) {            
            players[0].drawSprite(x, y, squareWidth, squareHeight);
          } else if (map[i][j].equals("player2")) {
            players[1].drawSprite(x, y, squareWidth, squareHeight);
          }
        }

        //drawing the items
        if (items[i][j]!=null) {
          if ((items[i][j].type.contains("bomb") || items[i][j].type.contains("Bomb")) && !items[i][j].type.contains("Item")) {
            items[i][j].drawSprite(itemx, itemy, itemWidth, itemHeight);
            if (items[i][j].countdown()) {
              doExplosion(i, j, items[i][j].power, false, false);
            }
          } else if (items[i][j].type.contains("explosion")) {
            items[i][j].drawSprite(itemx, itemy, itemWidth, itemHeight);   
            if (items[i][j].countdown()) {
              items[i][j]=null;
            }
          } else if (map[i][j].equals("blank")) {
            items[i][j].drawSprite(itemx, itemy, itemWidth, itemHeight);
          }
        }
      }
    }

    //checking player deaths
    if (items[players[0].x][players[0].y]!=null && items[players[0].x][players[0].y].type.contains("explosion")) {
      players[1].score++;
      restartGame();
      return;
    } else if (items[players[1].x][players[1].y]!=null && items[players[1].x][players[1].y].type.contains("explosion")) {
      players[0].score++;
      restartGame();
      return;
    }

    //drawing players score and checking item pickups
    for (Player player : players) {
      player.drawScore();
      if (items[player.x][player.y]!=null) {
        if (!items[player.x][player.y].type.equals("bomb") && !items[player.x][player.y].type.equals("explosion")
          && (items[player.x][player.y].num!=-2)) {
          player.pickupItem(items[player.x][player.y].type);
          items[player.x][player.y] = null;
        }
      }
    }
  }



  public void refreshBombs() {
    bombRefreshCounter++;
    if (bombRefreshCounter>3*frameRate) {
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
      powerup1Count = (int)random(300, 600);
      items[(int)random(mapWidth-1)][(int)random(mapHeight-1)] = new Item("heldBoost", -1, -1);
    }
    if (powerup2Count==0) {
      powerup2Count = (int)random(300, 600);
      items[(int)random(mapWidth-1)][(int)random(mapHeight-1)] = new Item("blastBoost", -1, -1);
    }
    if (powerup3Count==0) {
      powerup3Count = (int)random(500, 700);
      items[(int)random(mapWidth-1)][(int)random(mapHeight-1)] = new Item("pierceBombItem", -1, -1);
    }
    if (powerup4Count==0) {
      powerup4Count = (int)random(600, 800);
      items[(int)random(mapWidth-1)][(int)random(mapHeight-1)] = new Item("powerBombItem", -1, -1);
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
          if (items[players[0].x][players[0].y]==null) { 
            int bombType = players[0].placeBomb();
            if (bombType==-1) {
              return;
            } else if (bombType==0) {
              items[players[0].x][players[0].y] = new Item("bomb", players[0].power, -2);
            } else if (bombType==1) {              
              items[players[0].x][players[0].y] = new Item("pierceBomb", players[0].power, -2);
            } else if (bombType==2) {              
              items[players[0].x][players[0].y] = new Item("powerBomb", 999, -2);
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
      } else if (key == 'u' || key == 'U') {
        if (gameRunning) {
          if (items[players[1].x][players[1].y]==null) { 
            int bombType = players[1].placeBomb();
            if (bombType==-1) {
              return;
            } else if (bombType==0) {
              items[players[1].x][players[1].y] = new Item("bomb", players[1].power, -2);
            } else if (bombType==1) {              
              items[players[1].x][players[1].y] = new Item("pierceBomb", players[1].power, -2);
            } else if (bombType==2) {              
              items[players[1].x][players[1].y] = new Item("powerBomb", 999, -2);
            }
          }
        }
      }
    }
  }

  //creates the explosion
  public void doExplosion(int x, int y, int radius, boolean power, boolean pierce) {
    int up = y-1, down = y+1;
    int left = x-1, right = x+1;
    items[x][y] = new Item("explosion", 1, 1);
    int counter = 0;
    while (up>=0 && counter<radius) {
      if (map[x][up].equals("wall")) { 
        break;
      }
      //checks if there is another bomb in the square, if there is, it sets it off
      if (items[x][up]!=null) {
        if (items[x][up].type.equals("bomb")) {
          doExplosion(x, up, items[x][up].power, false, false);
        } else if (items[x][up].type.equals("powerBomb")) {
          doExplosion(x, up, mapHeight, true, false);
        } else if (items[x][up].type.equals("pierceBomb")) {
          doExplosion(x, up, items[x][up].power, false, true);
        }
      }
      items[x][up] = new Item("explosion", 1, 1);

      if (map[x][up].equals("bricks")) {
        map[x][up] = "blank";
        float itemGen = random(10);
        if (itemGen>7) {
          items[x][up].hidingItem = true;
        }
        if (!pierce) {
          break;
        }
      } 
      up--;
      counter++;
    }
    counter = 0;
    while (down<mapHeight && counter<radius) {
      if (map[x][down].equals("wall")) { 
        break;
      }
      if (items[x][down]!=null) {
        if (items[x][down].type.equals("bomb")) {
          doExplosion(x, down, items[x][down].power, false, false);
        } else if (items[x][down].type.equals("powerBomb")) {
          doExplosion(x, down, mapHeight, true, false);
        } else if (items[x][down].type.equals("pierceBomb")) {
          doExplosion(x, down, items[x][down].power, false, true);
        }
      }
      items[x][down] = new Item("explosion", 1, 1);
      if (map[x][down].equals("bricks")) {
        map[x][down] = "blank";
        float itemGen = random(10);
        if (itemGen>7) {
          items[x][down].hidingItem = true;
        }
        if (!pierce) {
          break;
        }
      }
      down++;
      counter++;
    }
    counter = 0;
    while (left>=0 && counter<radius) {
      if (map[left][y].equals("wall")) { 
        break;
      }
      if (items[left][y]!=null) {
        if (items[left][y].type.equals("bomb")) {
          doExplosion(left, y, items[left][y].power, false, false);
        } else if (items[left][y].type.equals("powerBomb")) {
          doExplosion(left, y, mapWidth, true, false);
        } else if (items[left][y].type.equals("pierceBomb")) {
          doExplosion(left, y, items[left][y].power, false, true);
        }
      }
      items[left][y] = new Item("explosion", 1, 1);
      if (map[left][y].equals("bricks")) {
        map[left][y] = "blank";
        float itemGen = random(10);
        if (itemGen>7) {
          items[left][y].hidingItem = true;
        }
        if (!pierce) {
          break;
        }
      }
      left--;
      counter++;
    }
    counter = 0;
    while (right<mapWidth && counter<radius) {
      if (map[right][y].equals("wall")) { 
        break;
      }
      if (items[right][y]!=null) {
        if (items[right][y].type.equals("bomb")) {
          doExplosion(right, y, items[right][y].power, false, false);
        } else if (items[right][y].type.equals("powerBomb")) {
          doExplosion(right, y, mapWidth, true, false);
        } else if (items[right][y].type.equals("pierceBomb")) {
          doExplosion(right, y, items[right][y].power, false, true);
        }
      }
      items[right][y] = new Item("explosion", 1, 1);
      if (map[right][y].equals("bricks")) {
        map[right][y] = "blank";
        float itemGen = random(10);
        if (itemGen>7) {
          items[right][y].hidingItem = true;
        }
        if (!pierce) {
          break;
        }
      }
      right++;
      counter++;
    }
  }
}