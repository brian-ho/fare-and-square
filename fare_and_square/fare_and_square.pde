//// FARE+SQUARE   THE SIMULATION ////////////////////
// A test for pedestrian walking
// with and without F+S
// indicate budget
// metrics

Grid grid;
Pop pop;
int pop_size = 10;
int store_num = 10;
int rows = 12;
int cols = 8;
Boolean[][] blocks;
int[][] shades;
int block_num;
int benefits_r;

//// SYMBOLS ////////////////////
PImage store_img;
// PImage person_img;
// PImage person2_img;
PImage home_img;
PImage bldg_img;
PImage bank_img;
PImage conv_img;
PImage phone_img;
PImage smile_img;
PImage face_img;;
PImage star_img;

PImage[] places;

//// COLORS AND SWATCH CODES ////////////////////
final int VG = 0;
final int FR = 1;
final int LC = 2;
final int FI = 3;  
final int GR = 4;
final int AX = 4;

color[] swatch;
int c_lim = 6;
      
//// SETUP ////////////////////
void setup() {
  
  // load images
  store_img=loadImage("Images/store_w.png");
  // person_img=loadImage("Images/person_marker.png");
  // person2_img=loadImage("Images/person_marker_inv.png");
  home_img=loadImage("Images/home.png");
  phone_img=loadImage("Images/phone.png");
  bldg_img=loadImage("Images/bank.png");
  bank_img=loadImage("Images/bldg.png");
  conv_img=loadImage("Images/convenience.png");
  face_img=loadImage("Images/face.png");
  smile_img=loadImage("Images/smile.png");
  star_img=loadImage("Images/benefit.png");
  
  places = new PImage[] {home_img, bldg_img, bank_img, conv_img};
  
  // create colors
  swatch = new color[6];

  swatch[VG] = color(68,219,94);
  swatch[FR] = color(254,40,81);
  swatch[LC] = color(40,229,253);
  swatch[FI] = color(254,56,36);
  swatch[GR] = color(126,211,33);
  swatch[AX] = color(189,16,224);
  
  // canvas size
  size(800, 800);

  grid = new Grid(rows, cols, store_num);
  blocks = new Boolean[rows][cols];
  shades = new int[rows][cols];
  
  for (int i=0; i<rows; i++){
    for (int j=0; j<cols; j++){
     blocks[i][j] = false;   
     shades[i][j] = 225;
    }
  }
  
  block_num = rows*cols;
  benefits_r = grid.block_width() > grid.block_height() ? int(grid.block_width()) : int(grid.block_height());

  // get some people in there
  pop = new Pop();
  for (int i=0; i<pop_size; i++){
    Walker p = new Walker(grid);
    pop.addWalker(p);
  }
  
  radial_dist(1,2);
  radial_dist(4,8);
  radial_dist(3,9);
}

//// DRAW ////////////////////
void draw() {
  // background grid and stores, order for clean represnetaiton
  background(225);
  grid.drawBlocks();
  grid.drawStreets();
  pop.drawPlaces();
  grid.drawStores();
  
  // are any people close to stores?
  pop.checkStores(grid);
  
  // animate the people
  pop.walk();
  pop.clean();
  
  // make sure we have enough people
  for (int i=0;i<pop.need(); i++){
    Walker p = new Walker(grid);
    pop.addWalker(p);
  }
}  

//// OTHER FUNCTIONS ////////////////////
int randomSign() {
  return (int) random(2) * 2 - 1;
}

// set benefits when you click
void mouseClicked() {
  println("CLICK");
  
  int blk_col=floor(pmouseX/grid.block_width());
  int blk_row=floor(pmouseY/grid.block_height());
  
  blocks[blk_row][blk_col] =! blocks[blk_row][blk_col];
  
  //println(blocks.get(blocks.size()-1));
  /*
  Walker p = new Walker(grid);
  pop.addWalker(p);
  return;
  */
}

void radial_dist(int px, int py){
    for (int i=0; i<rows; i++){
      for (int j=0; j<cols; j++){
        float dist = PVector.dist(new PVector(px, py), new PVector(j, i));
        if ( dist < 4 ){
           shades[i][j] -= round(100*(4-dist))/4;
           shades[i][j] = ( shades[i][j] <= 50 ) ? 25 : shades[i][j];
           shades[i][j] = ( shades[i][j] >= 200 ) ? 225 : shades[i][j];
        }
      }
    }
  }

int[] locToBlock (PVector loc){
  
    int blk_col=floor(loc.x/grid.block_width());
    int blk_row=floor(loc.y/grid.block_height());
    
    return new int[] {blk_row, blk_col};
  };

// color converter for swatch with opacity
color c(int i, int opacity){
  color c = swatch[i];
  return color(red(c),green(c),blue(c), opacity);
}