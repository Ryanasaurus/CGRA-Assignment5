class Item {
  String type;
  double timer;
  PImage sprite;
  int power;
  int countdown;
  //boolean exploded = false;

  public Item(String type, int power, double timer) {
    timer = 0;
    this.type = type;
    this.sprite = loadImage(type + ".png");
    this.power = power;

    this.countdown = (int)timer*60+1; //timer is seconds, countdown converts this into a frame-by-frame countdown
  }

  public void drawImage(int x, int y, int iWidth, int iHeight) {    
    image(sprite, x, y, iWidth, iHeight);
  }

  public boolean countdown() {
    countdown--;
    //if (!exploded) {    
    if (countdown>0) {
      return false;
    } else {
      type = "bomb";
      this.sprite = loadImage(type + ".png");
      return true;
    }
    //} 
  }
}