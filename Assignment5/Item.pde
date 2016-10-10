class Item {
  String type;
  double timer;
  PImage sprite;
  int power;
  int count;
  int num;
  boolean hidingItem = false;

  public Item(String type, int power, int num) {
    timer = 0;
    this.type = type;
    if (num==-1) {
      this.sprite = loadImage(type + ".png");
    } else {
      this.sprite = loadImage(type + num + ".png");
    }
    this.power = power;

    //this.count = (int)timer*60; //timer is seconds, countdown converts this into a frame-by-frame countdown //this would never work, and i couldnt figure out why
    if (type.equals("bomb")) {
      //count = 60;
      count = (int)(2*frameRate);
    } else {
      //count = 18;
      count = (int)(0.3*frameRate);
    }
    this.num = num;
  }

  public void drawSprite(int x, int y, int iWidth, int iHeight) {    
    image(sprite, x, y, iWidth, iHeight);
  }

  public boolean countdown() {
    count-=1;
    text(count, 10, height-200);
    if (count>0) {
      return false;
    } else {
      if (type.equals("bomb")) {
        //type = "explosion"+num;
        //this.sprite = loadImage(type + ".png");
        return true;
      } else if(num<25){
        num++;
        type = "explosion"+num;        
        this.sprite = loadImage(type + ".png");
        return false;
      } else{
        return true;
      }
    }
  }
}