class Button {
  int x, y;
  int buttonWidth, buttonHeight;
  public String name;
  boolean highlighted = false;

  public Button(int x, int y, int buttonWidth, int buttonHeight, String name) {
    this.x = x;
    this.y = y;
    this.buttonWidth = buttonWidth;
    this.buttonHeight = buttonHeight;
    this.name = name;
  }

  public void drawButton() {
    if (!highlighted) {
      rectMode(CENTER);
      fill(255);
      stroke(255, 127, 127);
      strokeWeight(5);
      rect(x, y, buttonWidth, buttonHeight);
      textSize(32);
      fill(127);
      text(name, x-7*name.length(), y+10);
    } else {
      rectMode(CENTER);
      fill(255);
      stroke(255, 50, 50);
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
}