class Place {
  
  // A Place is:
  //     a place that has some quantity of items at a certain price
  
  PVector loc;
  PVector address;
  int type;
  
  //// CONSTRUCTOR ////////////////////
  Place(PVector loc_, PVector address_){
    loc = loc_;
    address = address_;
    type = int(random(1, places.length));
  }
  
  Place(PVector loc_, PVector address_, int type_){
    loc = loc_;
    address = address_;
    type = type_;
  }
  
  //// OTHER METHODS ////////////////////
  PVector address(){
   return address; 
  }
  
  PVector location(){
    return loc;
}
  
  //// STYLING ////////////////////  
  void drawPlace(color c){
      // actual location on block
      noStroke();
      fill(c);
      //rectMode(CENTER);
      //rect(loc.x, loc.y, 10, 10);
      
      // draw the street address
      ellipseMode(CENTER);
      //ellipse(address.x, address.y, 4, 4);
      stroke(c);
      //strokeWeight(1);
      //line(loc.x, loc.y, address.x, address.y);
      
      tint(c);
      image(places[type], loc.x-18, loc.y-18, 36, 36);
  }
}