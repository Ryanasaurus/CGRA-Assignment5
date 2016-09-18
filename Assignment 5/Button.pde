class Button {
  int x, y;
  int buttonWidth, buttonHeight;
  public String name;
  public int num; //for use with clicking the buttons, and game lobby
  boolean highlighted = false;   
  int red, green, blue; //fill values

  public Button(int x, int y, int buttonWidth, int buttonHeight, String name, int red, int green, int blue) {
    this.x = x;
    this.y = y;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.name = name;
    this.red = red;
    this.green = green;
    this.blue = blue;
  }

  public void drawButton() {
    if (!highlighted) {
      rectMode(CENTER);
      fill(red, green, blue);
      stroke(255, 127, 127);
      strokeWeight(5);
      rect(x, y, buttonWidth, buttonHeight);
      textSize(32);
      fill(127);
      text(name, x-7*name.length(), y+10);
    } else {
      rectMode(CENTER);
      fill(red, green, blue);
      stroke(50, 50, 255);
      strokeWeight(6);
      rect(x, y, buttonWidth, buttonHeight);
      textSize(32);
      fill(0);
      text(name, x-7*name.length(), y+10);
    }
  }

  public void checkHighlight() {
    if (mouseX>x-buttonWidth/2 && mouseX<x+buttonWidth/2 && mouseY> y-buttonHeight/2 && mouseY<y+buttonHeight/2) {
      this.highlighted = true;
    } else {
      this.highlighted = false;
    }
  }

  public void updateColor(int red, int green, int blue) {
    this.red = red;
    this.green = green;
    this.blue = blue;
  }
}