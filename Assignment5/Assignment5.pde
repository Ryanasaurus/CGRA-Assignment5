PImage logo;
Button [] button;
String location;
GameLobby lobby;
Settings settings;
Game game;
int countDown = 5;


public void setup() {

  //size(1000, 1000);
  fullScreen();
  background(0);
  logo = loadImage("logo.png");
  button = new Button[2];
  button[0] = new Button(width/2, height/2, width/4, height/10, "Play", 255, 255, 255); //main menu play button
  button[1] = new Button(width/2, 2*(height/3), width/4, height/10, "Settings", 255, 255, 255); //main menu settings button
  location = "main-menu"; //setting the location to main menu
  lobby = new GameLobby(); //creating the game lobby
  settings = new Settings(lobby);
  settings.loadKeys();
  game = new Game(this.lobby);
}

public void draw() {

  //draws the main menu
  if (location.equals("main-menu")) {
    background(0);
    for (Button button : button) {
      button.drawButton();
      button.checkHighlight();
    }
    image(logo, width/2-width/8, height/2-height/4);
  } 

  //draws the settings menu. allows for the changing of keys for different players
  else if (location.equals("settings")) {
    background(0);
    settings.drawSettings();
  }

  //draws the game lobby
  else if (location.equals("game-lobby")) {
    background(0);
    lobby.drawLobby();
  }

  //draws the game
  else if (location.equals("game")) {
    if (game.gameRunning) {
      frameRate(60);
      background(0);    
      game.drawMap();
    } else {
      background(0);
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
  } else if (location.equals("game-lobby")) {
    for (Player player : lobby.players) {
      if (player.lobbyButton.highlighted) {
        clickedButton = true;
        buttonClicked=player.lobbyButton;
        break;
      }
    }
    if (lobby.back.highlighted) {
      clickedButton = true;
      buttonClicked = lobby.back;
    }
  }
  if (!clickedButton) {
    return;
  }
  if (clickedButton && buttonClicked!=null) {
    if (location.equals("game-lobby")) {

      //player 1's button was clicked. drops the player in or out of the game
      if (buttonClicked.name.contains("1")) {
        if (lobby.players[0].inGame) {
          lobby.players[0].dropOut();
          lobby.dropPlayer();
        } else {
          lobby.players[0].dropIn();
          lobby.addPlayer();
        }
      } 

      //player 2's button was clicked. drops the player in or out of the game
      else if (buttonClicked.name.contains("2")) {
        if (lobby.players[1].inGame) {
          lobby.players[1].dropOut();
          lobby.dropPlayer();
        } else {
          lobby.players[1].dropIn();
          lobby.addPlayer();
        }
      } 

      //player 3's button was clicked. drops the player in or out of the game
      else if (buttonClicked.name.contains("3")) {
        if (lobby.players[2].inGame) {
          lobby.players[2].dropOut();
          lobby.dropPlayer();
        } else {
          lobby.players[2].dropIn();
          lobby.addPlayer();
        }
      } 

      //player 4's button was clicked. drops the player in or out of the game
      else if (buttonClicked.name.contains("4")) {
        if (lobby.players[3].inGame) {
          lobby.players[3].dropOut();
          lobby.dropPlayer();
        } else {
          lobby.players[3].dropIn();
          lobby.addPlayer();
        }
      } else if (buttonClicked.name.equals("Back")) {
        location = "main-menu";
      }
    }
    if (buttonClicked.name.equals("Play")) {
      //location = "game-lobby";
      location = "game";
      game.newMap();
      frameRate(1);
    } else if (buttonClicked.name.equals("Settings")) {
      location = "settings";
    }
  }
}

public void keyPressed(){
  if(location.equals("game")){
    game.keyPushed(key);
  }
}