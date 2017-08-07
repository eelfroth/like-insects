class Wall {
  PVector l, size;
  int image_index;
  
  Wall(float x, float y, float w, float h) {
    l = new PVector(x, y);
    size = new PVector(w, h);
    image_index = floor(random(2));
  }
  
  void display() {
    /*
    pg.noStroke();
    pg.fill(128);
    pg.rect(l.x, l.y, size.x, size.y);
    */
    //tWall.draw(image_index, l.x, l.y);
  }
  
}
