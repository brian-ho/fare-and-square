class Pop{

  ArrayList<Walker> pop; // An ArrayList for all the Walkers
  
  Pop() {
  pop = new ArrayList<Walker>(); // Initialize the ArrayList
  }

  // update all persons
  void walk() {
    for (Walker p : pop) {
      p.walk();              // Passing the entire list of boids to each boid individually
      p.drawPaths();
    }
    for (Walker p : pop){
      p.drawWalker();
    }
  }
  
  // draw places (associated with person)
  void drawPlaces() {
    for (Walker p : pop) {
      p.drawPlaces(); 
    }
  }
  
  // add a new person (wrapper)
  void addWalker(Walker p) {
    pop.add(p);
  }
  
  // search for nearby stores
  void checkStores(Grid grid){
    for ( Walker p : pop ) {
     if ( p.detoured()==false ){
     Store store = grid.checkStores(p);
     if ( store != null ){
         p.notify(store);
       }
     }
    }
  }
  
  void clean() {
  // you should loop through it backwards, as shown here:
   for (int i = pop.size() - 1; i >= 0; i--) {
    Walker p = pop.get(i);
    if (p.finished()) {
      pop.remove(i);
    }
   }
  }
  
  int need(){ return pop_size - pop.size();}      

}