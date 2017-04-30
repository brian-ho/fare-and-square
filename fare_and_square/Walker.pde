class Walker {
  
  // A walker is:
  //     a person hungry for some food

  PVector loc;      // updating location of person
  PVector target;   // current target
  PVector vel;      // vector of motion
  float maxSpeed;   // max speed of motion
  int opacity;      // for fade-out
  int wait;
  int want;       // desired food
  int alert;
  Boolean detour;   // flag for detour
  Boolean arrived;  // flag for arrived at destination
  Boolean food;
  int pc;           // counter for path progress
  PVector home;
  
  Path path;        // path of motion
  Path master;      // overall path of motion
  Place start;
  Place end;
  
  //// CONSTRUCTOR ////////////////////
  Walker(Grid grid){
    
    want = int(random(c_lim));
    maxSpeed = int(random(2, 3));
    opacity = 0;
    wait = 30;
    alert = 10;
    
    detour = false;
    arrived = false;
    food = false;
    
    PVector[] start_locs = grid.spotInBlock();
    PVector[] end_locs = grid.spotInBlock();

    // make sure destination is far enough away
    while (start_locs[1].dist(end_locs[1]) < 100){
        end_locs = grid.spotInBlock();
    }
    // leaving home
    if ( randomSign() > 0 ){
      start = new Place (start_locs[0], start_locs[1], 0);
      end = new Place (end_locs[0], end_locs[1]);
      home = start.location();
    }
    // going home
    else {
      start = new Place (start_locs[0], start_locs[1]);
      end = new Place (end_locs[0], end_locs[1], 0);
      home = end.location();
    }
    
    target = end.address();
    loc = start.address();
    master = new Path (start.address(), end.address(), grid);
    path = master;
    pc = 0;
  }
  
  //// OTHER METHODS ////////////////////
  // traverse the path
  void walk(){
     if ( arrived ){return;}
     
     // if we're at the end of a path segment
     if (loc.dist(path.getPoint(pc))==0){
       
        // if we're at the end of the path
       if (pc == path.getSize()-1){
         
         // if we've arrived at destination
         if ( PVector.dist(loc, end.address())<1 ){
         arrived = true;
         // remove some shade
         if (home == end.location()){
             shades[locToBlock(loc)[0]][locToBlock(loc)[1]] =
               (shades[locToBlock(loc)[0]][locToBlock(loc)[1]] < 210)
               ? shades[locToBlock(loc)[0]][locToBlock(loc)[1]] += 15 : 225;
           
         }
         
         return;
         }
         
         // if we've arrived at store
         else if (wait!=0) {
             food = true;
             wait -= 1;
         }
         
         else {
             target = end.address();
             pc = 0;
             path = new Path(loc, target, grid);
         }
         
       }
       // advance to next path segment
       else {pc++;}
     }
     // move along path
     vel = PVector.sub(path.getPoint(pc), loc);
     loc = PVector.add(loc, vel.limit(maxSpeed));
   }
   
  // fade in
   void appear(){
     if ( !arrived ){
       opacity = (opacity <= 245) ? opacity + 10 : 255;
       return;
     }
   }
   
   // fade out
   void fade(){
     if ( arrived ){
       opacity = (opacity > 10) ? opacity - 10 : 0;
       return;
     }
   }
   
  // test to see if done
  Boolean finished(){
    return (arrived && opacity == 0 );
  }
  
  // notify me!
  void notify(Store store){
   if ( detour==false ){
   // println("NOTIFICATION");
     target = store.address();
     pc = 0;
     path = new Path(loc, target, grid);
     detour = true;
   }
 }
  
  //// SOME WRAPPERS //////////////
  Boolean detoured(){return detour;}
  PVector location(){return loc;}
  int want(){return want;}
  
  
  //// STYLING ////////////////////  
  void drawWalker(){
      /*
      // draw the destination marker
      fill(255);
      strokeWeight(1);
      stroke(want);
      ellipseMode(CENTER);
      ellipse(dest.x, dest.y, 6, 6);
      */
      
      // draw the current position
      //strokeWeight(1)
      
      if (!arrived) {appear();}
      else {fade();}
      
      // draw the paths   
      //path.drawPath(c(want, opacity), 3);
      //master.drawPath(c(want, opacity), 1);
      //start.drawPlace(c(want, opacity));
      //end.drawPlace(c(want, opacity));
      
      noStroke();
      
      // if hungry
      if ( !food ){
        fill(255);
        ellipse(loc.x, loc.y, 34, 34);
        /*
        strokeWeight(3);
        stroke(c(want, opacity));
        ellipse(loc.x, loc.y, 27, 27);
        */
        fill(255,255,255,opacity);
        ellipse(loc.x, loc.y, 34, 34);
    
        tint(c(want, opacity));
        image(face_img, loc.x-16, loc.y-16, 32, 32);
      }
      
      // if got food!
      else{ 
        fill(255,255,255,opacity);
        ellipse(loc.x, loc.y, 34, 34);
        tint(c(want, opacity));
        image(smile_img, loc.x-18, loc.y-18, 36, 36);
      }
      
        // if notified, make a phone and flash
        if (detour && !food ){
          int flash = round(122.5*(1+sin(radians(frameCount%60*6))));
          stroke(c(want, flash));
          strokeWeight(1);
          noFill();
          ellipse(loc.x, loc.y, 48, 48);
          
          noStroke();
          fill(255);
          rectMode(CORNER);
          rect(loc.x + 13, loc.y-34, 14, 24);
          
          tint(c(want,255));
          image(phone_img, loc.x + 4, loc.y - 36, 32, 32);
          alert -= 1;
      }

      
      /*
      // display some text
      fill(0);
      String d = target.x+","+ target.y;
      String l = loc.x+","+ loc.y;
      text(d, target.x, target.y);
      text(l, loc.x, loc.y);
      */
      
  }
  
 void drawPaths(){path.drawPath(c(want, opacity), 3); master.drawPath(c(want, opacity), 1);}
 void drawPlaces(){start.drawPlace(c(want, opacity)); end.drawPlace(c(want, opacity));}
}