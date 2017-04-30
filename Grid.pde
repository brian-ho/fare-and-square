class Grid {

  // A grid is:
  //     a bunch of streets with set number of rows and columns
  //     a bunch of randomly distributed stores along those streets
  
  int[] rows;        // array of horz positions
  int[] columns;     // array of vert positions
  int blk_w;         // horz spacing
  int blk_h;         // vert spacing
  int road_width;    // road width
  int margin;      // setback for stores
  int n_stores;      // number of stores
  Store[] stores;    // array of stores

  //// CONSTRUCTOR ////////////////////
  Grid(int rws, int cols, int s) {
  
    println("CREATING ", rws, "x", cols, " GRID");
    road_width = 8;              // adjust road width here
    margin = 30;
    blk_w = (width-(2*road_width)+2)/cols;
    blk_h = (height-(2*road_width)+2)/rws;
    
    // create and fill arrays for street positions
    rows = new int[rws+1];
    columns = new int[cols+1];
    
    // first and last entries
    rows[0] = road_width-1; rows[rows.length-1]=height-road_width-1;
    columns[0] = road_width-1; columns[columns.length-1]=width-road_width-1;
    
    // loop for horizontal "row" streets
    for (int i = 1; i < rws; i++){
       rows[i] = rows[0]+int((i)*blk_h);
    }
     
    // loop for vertical "column" streets
     for (int i = 1; i < cols; i++){
       columns[i] = columns[0]+int((i)*blk_w);
    }
    
    // set up stores
    n_stores = s;
    stores = new Store[s];
    println("CREATING ", n_stores, " STORES");
    // generate store locations at random
    for (int i=0; i < n_stores; i++){
      // figure out which block first
      PVector[] store_locs = spotInBlock();
      stores[i] = new Store(store_locs[0], store_locs[1], blk_w, blk_h);
    }
  }
  
  //// OTHER METHODS ////////////////////
  // Wrapper functions that give access to various properties
  int[] rows(){
    return rows;
  }
  
  int[] columns(){
    return columns;
  }
  
  int block_width(){
  return blk_w;
  }
  
  int block_height(){
    return blk_h;
  }
  
  // Locator functions that position objects on (or off) the grid
  // Saves some time finding a spot within streets
  PVector spotInStreet() {
    // randomly pick adjacent street and nearby cross street
    PVector spot = new PVector(0,0);
    if (int(random(2))==0){
      spot.x = columns[int(random(1, columns.length-1))] + floor(random(0, blk_w))*randomSign();
      spot.y = rows[int(random(1, rows.length-1))];
    }
    else{
      spot.x = columns[int(random(1, columns.length-1))];
      spot.y = rows[int(random(1, rows.length-1))] + floor(random(0, blk_h))*randomSign();
    }
    return spot;
  }
  
  // Saves some time finding a spot on a block
  PVector[] spotInBlock() {
    // randomly pick adjacent street and nearby cross street
    PVector spot = new PVector(0,0);
    PVector access = new PVector(0,0);
    if (int(random(2))==0){
      access.x = columns[int(random(1, columns.length-1))] + floor(random(margin, blk_w-margin))*randomSign();
      access.y = rows[int(random(1, rows.length-1))];
      spot.x = access.x;
      spot.y = access.y + margin*randomSign();
    }
    else{
      access.x = columns[int(random(1, columns.length-1))];
      access.y = rows[int(random(1, rows.length-1))] + floor(random(margin, blk_h-margin))*randomSign();
      spot.x = access.x + margin*randomSign();
      spot.y = access.y;
    }
    return new PVector[]{spot, access};
  }
  
  //  Finds the two endpoints of the street segment, for a given location on a street segment
  PVector[] getEnds(PVector location) {
      PVector end1 = new PVector(0,0);
      PVector end2 = new PVector(0,0);
      
      // Search all vertical streets to find x position
      for (int i = 0; i < columns.length-1; i++) {
        // On a horizontal street excatly
        if (location.x == columns[i]){
          end1.x = columns[i]; end2.x = columns[i];
        }
        // Otherwise somewhere along
        else if (columns[i] < location.x && location.x < columns[i+1]) {
          end1.x = columns[i]; end2.x = columns[i+1];
        }
      }
      
      // Search all horizontal streets to find y position
      for (int i = 0; i < rows.length-1; i++) {
        // On a vertical street exactly
        if (location.y == rows[i]){
          end1.y = rows[i]; end2.y = rows[i];
        }
        // Otherwise somewhere along
        else if (rows[i] < location.y && location.y < rows[i+1]) {
          end1.y = rows[i]; end2.y = rows[i+1];
        }
      }
     return new PVector[]{end1, end2};
    }
    
  // Check all stores for distance to target, plus match
  Store checkStores(Walker p){
    int best = 9999;
    float min_dist = 9999;
    
    for(int i = 0; i < n_stores; i++){
      float check = 0;
      if( stores[i].benefits){check = PVector.dist(stores[i].address(), p.location())/2;}
      else{check = PVector.dist(stores[i].address(), p.location());}
      if ( check < min_dist && p.want()==stores[i].item() ) {
       min_dist = check;
       best = i;
      };
    }
      
    if (best != 9999 && min_dist < benefits_r){
       return stores[best];  
    }
    else return null;
  }
    
    
  //// STYLING ////////////////////  
  void drawStreets(){
     // styling
     stroke(255);
     strokeWeight(road_width*2);
     noFill();
     
     for (int i = 0; i < rows.length; i++){
      line(0, rows[i], width, rows[i]);
     }
     
     for (int i = 0; i < columns.length; i++){
      line(columns[i], 0, columns[i], height);
     }
  }
  
  // Draws the stores by calling method for each store
  void drawStores(){
    for (int i = 0; i < n_stores; i++){
      stores[i].drawStore();
    }
  }
  
  void drawBlocks(){
    for (int i=0; i < rows.length-1;i++){
      for (int j=0; j < columns.length-1;j++){
      /*
      if (blocks[i][j]) {
      rectMode(CORNER);
      fill(150);
      noStroke();
      rect(j*blk_w,i*blk_h,blk_w,blk_h);
       }
       */
      rectMode(CORNER);
      fill(shades[i][j]);
      noStroke();
      rect(j*blk_w,i*blk_h,blk_w,blk_h);
       
      }
    }
  }
}