PImage logo;
Button [] button;
String location;
Game game;
int countDown = 5;


public void setup() {

  size(1920, 1080);
  //fullScreen();
  background(0);
  logo = loadImage("logo.png");
  button = new Button[2];
  button[0] = new Button(width/2, height/2, width/4, height/10, "Play", 255, 255, 255); //main menu play button
  button[1] = new Button(width/2, 2*(height/3), width/4, height/10, "Settings", 255, 255, 255); //main menu settings button
  location = "main-menu"; //setting the location to main menu
  game = new Game();
}

public void draw() {

  //draws the main menu
  if (location.equals("main-menu")) {
    frameRate(60);
    background(0);
    for (Button button : button) {
      button.drawButton();
      button.checkHighlight();
    }
    image(logo, width/2-(width/8)/2, height/5, width/8, height/5);
    textSize(100);
    fill(255);
    text("Chicken Bomber", width/2-420, height/8);
  } 

  //draws the game
  else if (location.equals("game")) {
    if (game.gameRunning) {
      frameRate(60);
      background(60);    
      game.drawMap();

    } else {
      frameRate(1);
      background(60);
      game.drawMap();
      fill(255);
      textSize(100);
      text(countDown, width/2-(height/game.mapWidth)/4, height/4);
      countDown--;
      if (countDown==0) {
        countDown = 5;
        game.gameRunning = true;
      }
    }
  }
} 

public void mouseClicked() {
  boolean clickedButton = false;
  Button buttonClicked = null;
  if (location.equals("main-menu")) {
    for (Button button : button) {
      if (button.highlighted) {
        clickedButton = true;
        buttonClicked = button;
        break;
      }
    }
  } 
  if (!clickedButton) {
    return;
  }
  if (clickedButton && buttonClicked!=null) {    
    if (buttonClicked.name.equals("Play")) {
      location = "game";
      game.newMap();
      frameRate(1);
    } 
  }
}

public void keyPressed() {
  if (location.equals("game") && game.gameRunning) {

    game.keyPushed(key);
  }
}