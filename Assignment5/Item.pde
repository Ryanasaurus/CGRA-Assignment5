class Item {
  String type;
  double timer;
  PImage sprite;
  int power;
  int countdown;
  boolean exploded;

  public Item(String type, int power, double timer) {
    timer = 0;
    this.type = type;
    this.sprite = loadImage(type + ".png");
    this.power = power;
    this.countdown = (int)timer*60; //timer is seconds, countdown converts this into a frame-by-frame countdown
  }

  public void drawImage(int x, int y, int iWidth, int iHeight) {    
    image(sprite, x, y, iWidth, iHeight);
  }

  public boolean countdown() {
    if (!exploded) {    
      if (countdown>0) {
        countdown--;
        return false;
      }
      else if (countdown==0) {
        exploded = true;
        return true;
      }
    } 
    return false;
  }
}