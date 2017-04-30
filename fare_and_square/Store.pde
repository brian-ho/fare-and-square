class Store {
  
  // A store is:
  //     a place that has some quantity of items at a certain price
  
  PVector loc;
  PVector address;
  PVector block;
  color item;
  Boolean benefits;
  
  //// CONSTRUCTOR ////////////////////
  Store(PVector loc_, PVector address_, int blk_w, int blk_h){
    loc = loc_;
    address = address_;
    item = int(random(c_lim));
    benefits = false;
    block = new PVector(floor(loc.x/blk_w), floor(loc.y/blk_h));
  }
  
  //// OTHER METHODS ////////////////////
  PVector address(){
   return address; 
  }
  
  int item(){
   return item; 
  }
  
  Boolean benefits(){return benefits;}
  
  //// STYLING ////////////////////  
  void drawStore(){
      
    if (!benefits && blocks[int(block.y)][int(block.x)]) {;
       benefits = true;
       }
     else if (benefits && !blocks[int(block.y)][int(block.x)]) {;
       benefits = false;
       }
      
      fill(255);
      strokeWeight(3);
      stroke(swatch[item]);
      rectMode(CENTER);
      rect(loc.x, loc.y, 48, 48);
      //stroke(swatch[item]);
      //rectMode(CENTER);
      //rect(loc.x, loc.y, 2, 2);
      
      //ellipseMode(CENTER);
      //ellipse(address.x, address.y, 4, 4);
      //stroke(swatch[item]);
      strokeWeight(1);
      // line(loc.x, loc.y, address.x, address.y);
      tint(swatch[item]);
      if (benefits){ image(star_img, loc.x-18, loc.y-18, 36, 36); noFill(); ellipse(loc.x, loc.y, 4*benefits_r,4*benefits_r); }
      else{ image(store_img, loc.x-18, loc.y-18, 36, 36); }
      //noTint();
  }
}