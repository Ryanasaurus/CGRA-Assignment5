class Player {
  int num; 
  int red, green, blue;
  int x, y;
  int power = 1;
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
    sprite = loadImage("player" + num + "left.png");
  }

  public void drawScore() {
    rectMode(CENTER);
    stroke(red, green, blue);
    fill(red, green, blue);
    textSize(32);
    int heightCo = 4;
    text("Player " + num, 10, (height/heightCo)*num);
    textSize(30);
    text("Kills: " + score, 200, (height/heightCo)*num);
    //for (int i=0; i<bombsHeld; i++) {
    //  image(loadImage("bomb.png"), 20*i+10, height/3*num+20, 40, 40);
    //}
    text("Bombs: " + bombsHeld + "/" + maxBombs, 10, (height/heightCo)*num+height/22);
    text("Pierce: " + pierceHeld, 10, (height/heightCo)*num+height/12);
    text("Power: " + powerHeld, 10, (height/heightCo)*num+height/8);
    text("Radius: " + power, 10, (height/heightCo)*num+height/6);
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

  public int placeBomb() {
    if (powerHeld!=0) {
      powerHeld--;
      return 2;
    } else if (pierceHeld!=0) {
      pierceHeld--;
      return 1;
    } else if (bombsHeld!=0) {
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

  public void pickupItem(String type) {
    if (type.equals("blastBoost") && power<10) {
      power++;
    } else if (type.equals("heldBoost") && maxBombs<10) {
      maxBombs++;
    } else if (type.contains("pierceBomb")) {
      pierceHeld++;
    } else if (type.contains("powerBomb")) {
      powerHeld++;
    }
  }  

  public void drawSprite(int x, int y, int imageWidth, int imageHeight) {
    image(this.sprite, x, y, imageWidth, imageHeight);
  }
}