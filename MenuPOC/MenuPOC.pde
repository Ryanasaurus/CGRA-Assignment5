PImage logo;
Button [] button;
String location;

void setup() {
  size(1000, 1000);
  background(0);
  logo = loadImage("logo.png");
  button = new Button[2];
  button[0] = new Button(width/2, height/2, width/4, height/10, "Play");
  button[1] = new Button(width/2, 2*(height/3), width/4, height/10, "Settings");
  location = "main-menu";
}

void draw() {
  if (location.equals("main-menu")) {
    background(0);
    for (Button button : button) {
      button.drawButton();
      button.checkHighlight();
    }
    image(logo, width/2-width/8, height/2-height/4);
  }
  else if(location.equals("game-lobby")){
    background(255);
    fill(0);
    textSize(64);
    text("work in progress", width/4, height/4);
  }
}

void mouseClicked(){
  boolean clickedButton = false;
  Button buttonClicked = null;
  for(Button button : button){
    if(button.highlighted){
      clickedButton = true;
      buttonClicked = button;
      break;
    }
  }
  if(!clickedButton){return;}
  if(clickedButton){
    if(buttonClicked.name.equals("Play")){
      location = "game-lobby";
    }
  }
}