class Tileset {
  
  PImage[] tile;
  PImage tileset_image; 
  int width, height, number;
  PGraphics pg;
  
  color tint;
  PVector scale;
  float rotate;
  PVector origin;

  Tileset(
          String file, 
          int _width, 
          int _height, 
          int _number,
          PGraphics buffer
         ) 
  { 
    tileset_image = loadImage(file);
    width = _width;
    height = _height;
    number = _number;
    pg = buffer;
    
    tint = color(255);
    scale = new PVector(1, 1);
    rotate = 0;
    origin = new PVector(0, 0);
    
    tile = new PImage[number];
    int tiles_per_row = tileset_image.width / width;
    
    for (int i=0; i<number; i++) {
      tile[i] = tileset_image.get(
                                  (i % tiles_per_row) * width, 
                                  floor(i / tiles_per_row) * height, 
                                  width, 
                                  height
                                 );
    }
  }
  
  void draw(int index, float x, float y) {
    pg.pushMatrix();
      pg.translate(round(x), round(y));
      pg.tint(tint);
      pg.rotate(rotate);
      pg.scale(scale.x, scale.y);
      pg.translate(-origin.x, -origin.y);
      
      pg.image(tile[index], 0, 0);
    pg.popMatrix();
  }
  
}

///////////////////////////////////////////////////////

class Font extends Tileset {
  PVector spacing;
  PVector align;
  
  Font(
       String file, 
       int _width, 
       int _height, 
       int _number,
       PGraphics buffer
      ) 
  {
    super(file, _width, _height, _number, buffer);
    
    spacing = new PVector(0, 0);
    align = new PVector(CORNER, CORNER);
  }
  
  void text(String txt, int x, int y) {
    String[] lines = split(txt, '\n');
    
    pg.pushMatrix();
      pg.translate(x, y);
      pg.tint(tint);
      pg.rotate(rotate);
      pg.scale(scale.x, scale.y);
      if (align.y == CENTER) {
        origin.y = (lines.length * (height + spacing.y) / 2) + height/4;
        pg.translate(0, - origin.y);
      }
    
      for(int k=0; k<lines.length;k++) {
        if (align.x == CENTER) {
          origin.x = (lines[k].length() * (width +spacing.x) / 2) + width/4;
          pg.translate(- origin.x, 0);
        }
        
        for(int i=0; i<lines[k].length();i++) {
          int ch = lines[k].charAt(i) - 33;
          if (ch <= 94 && ch >= 0) {
            pg.image(tile[ch], i*(width +spacing.x), k * (height + spacing.y));
          } 
        }
        
        if (align.x == CENTER) pg.translate(origin.x, 0);
      }
    
    pg.popMatrix();
  }
  
}
 
/////////////////////////////////////////////////////// 

class Animation extends Tileset {
  float speed;
  float index;
  
  Animation(
            String file, 
            int _width, 
            int _height, 
            int _number,
            PGraphics buffer
           ) 
  {
    super(file, _width, _height, _number, buffer);
    
    speed = 1;
    index = 0;
  }
  
  void draw(float x, float y) {
    index += speed * delta;
    while (index >= number) index -= number;
    super.draw(floor(index), x, y);
  }
  
}
