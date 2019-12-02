import ddf.minim.*;

String version = "1.1.69";

///////////////////////////////////////////////////
// Environment settings
int     buffer_width = 426;
int     buffer_height = 240;
float   scaling_x = 4;
float   scaling_y = 4;
boolean fullscreen = false;
boolean interpolation = false;
float   frames_per_second = 60;
boolean full_frame_rate = false;
float   motion_blur = 0;
boolean display_cursor = false;
///////////////////////////////////////////////////

//Global variables
PGraphics pg;
int last_millis=0;
float delta, graphics_width, graphics_height, offset_x, offset_y;
HashMap pressed_keys;

void setup(){
  //Set window and graphics size
  fullScreen(P2D);

  set_graphics_size();

  //Set frame rate cap
  if (full_frame_rate) frameRate(9999);
  else frameRate(frames_per_second);
  //frameRate(30);

  //Set sampling-mode
  if (interpolation) ((PGraphicsOpenGL)g).textureSampling(5);
  else ((PGraphicsOpenGL)g).textureSampling(2);
  
  //Set color outside the drawing-area
  background(0);
  
  //Initialize main surface
  pg = createGraphics(buffer_width, buffer_height, P2D);
  
  pg.noSmooth();

  //Set cursor visibility  
  if (!display_cursor) noCursor();
  
  pressed_keys = new HashMap();
  
  load_assets();
  initialize();
}

void set_graphics_size() {
  if (fullscreen) {
    //Convert to float
    float _width = float(buffer_width);
    float _height = float(buffer_height);
    
    //Fit graphics size into window
    float aspect_ratio;
    if (float(width)/float(height) >= _width / _height) {
      aspect_ratio = _width / _height;
      graphics_height = height;
      graphics_width = height * aspect_ratio;
    }
    else {
      aspect_ratio = _height / _width;
      graphics_width = width;
      graphics_height = width * aspect_ratio;
    }
  }
  else {
    graphics_width = width;
    graphics_height = height;
  }
  scaling_x = graphics_width / buffer_width;
  scaling_y = graphics_height / buffer_height;
  offset_x = (width - graphics_width);
  offset_y = (height - graphics_height);
}
///////////////////////////////////////////////////

void draw(){
  noCursor();
  
  //Calculate scaling factor for time based operations
  delta = (millis() - last_millis) / (1000 / frames_per_second);
  last_millis = millis();
  if (delta > 3) delta = 3;
  
  //Execute logical operations
  update();
  
  //Execute drawing operations
  pg.beginDraw();
  colorMode(HSB, 255);
  pg.colorMode(HSB, 255);
  display();
  pg.loadPixels();
  for(int i=0; i<100; i++) {
    int pos = floor(random(1, pg.pixels.length - 1001));
    arrayCopy(pg.pixels, pos, pg.pixels, pos + floor(random(-1, 2)), floor(random(1000)));
  }
  pg.updatePixels();
  pg.endDraw();
  
  
  
  //Draw off-screen buffer to window
  ((PGraphicsOpenGL)g).textureSampling(5);
  //pushMatrix();
  //translate(0, height);
  //scale(1, -1);
  tint(255, 255 - motion_blur);
  
  image(
        pg, 
        width/2 - graphics_width/2, 
        height/2 - graphics_height/2, 
        graphics_width, 
        graphics_height
       );
  
  
  //popMatrix();
  
  //Keep an eye on the framerate
  //println(frameRate + "\t\t" + delta);
}
///////////////////////////////////////////////////

void keyPressed() {
  if (key == CODED) {
    pressed_keys.put(str(keyCode), true);
  }
  else {
    if (key == ESC){
      if (startscreen) exit();
      else {
        bg1.close();
        minim.stop();
        startscreen = true;
        initialize();
      }
      key = 0;
    }
    pressed_keys.put(str(key).toLowerCase(), true);
  }
}

void keyReleased() {
  if (key == CODED) {
    pressed_keys.remove(str(keyCode));
  }
  else {
    pressed_keys.remove(str(key).toLowerCase());
  }
}

boolean check_key(char k) {
  if(pressed_keys.containsKey(str(k))) return true;
  return false;
}

boolean check_key(int k) {
  if(pressed_keys.containsKey(str(k))) return true;
  return false;
}

boolean check_key(String k) {
  if(pressed_keys.containsKey(k)) return true;
  return false;
}

//////////////////////////////////////////////////////
