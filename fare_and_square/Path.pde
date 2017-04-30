class Path{
  
  ArrayList<PVector> points;      // Mutable array to hold path verticies
  PVector temp;                   // Marker for path
  PVector dest;                   // Destination
  PVector origin;
  Grid grid;
  
  //// CONSTRUCTOR ////////////////////
  Path(PVector origin_, PVector dest_, Grid grid_){
    dest = dest_;
    origin = origin_;
    grid = grid_;
    
    points = new ArrayList<PVector>();
    points.add(origin);
    //println("origin ", origin);
    //println("dest ", dest);
    
    // Start to create path by finding closest intersection
    PVector[] ends = grid.getEnds(origin);
    if (dest.dist(ends[0]) <= dest.dist(ends[1])){
       temp = ends[0];
      }  
    else if (dest.dist(ends[0]) > dest.dist(ends[1])){
       temp = ends[1];
     }
     points.add(temp);
     
     // Search street grid until path resolved    
     int j = 0;
     while (temp!=dest){
       // println("... FINDING PATH ", j);
       if( j > grid.columns().length + grid.rows().length+1 ){
          break;}
       else{journey();j++;}
     }
     // println("... DONE LOOKING FOR PATH");
  }
  
  //// OTHER FUNCTIONS ////////////////////
  // function to create path   
  void journey(){
    
     // how far away?
     PVector dif = PVector.sub(dest, temp);
     // are we close?
     if ( dif.x == 0 && abs(dif.y) < grid.block_height() || dif.y == 0 && abs(dif.x) < grid.block_width() ){
       temp = dest;
       // println("path ARRIVED ", temp);
      }
      // if neither end is closer, must be at an intersection, pick longer direction toward destination
      else {
         if (abs(dif.x) > abs(dif.y)){
            temp = PVector.add(temp, new PVector(dif.x, 0).setMag(grid.block_width())); 
            // println("path HORZ ", temp);
         }
         else {
            temp = PVector.add(temp, new PVector(0, dif.y).setMag(grid.block_height())); 
            // println("path VERT ", temp);
         }
      }
    points.add(temp);
  }
  
  // Some wrappers  
  int getSize(){
    return points.size();
  }
  
  PVector getPoint(int i){
    return points.get(i);
  }
  
  //// STYLING ////////////////////
  void drawPath(color c, int lw){
    strokeWeight(lw);
    stroke(c);
    noFill();
    beginShape();
    for (int i=0; i<points.size(); i++){
      vertex(points.get(i).x, points.get(i).y);
    }
    endShape();
  }
}