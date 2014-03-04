class Bee {
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce; //max steering force
  float maxspeed; //maximum speed
  float queenx; //xlocation of queen
  float queeny; //ylocation of queen
  float scare;

  Bee(float x, float y) {
    location = new PVector(x, y);
    r = 8;
    queenx = width/3;
    queeny = height/3;
    maxspeed = 6;
    maxforce = 0.2;
    acceleration = new PVector(0, 0);
    velocity = new PVector(0, 0);
    scare = 3;
  }

  void applyForce(PVector force) {
    acceleration.add(force);
  }

  void applyBehaviors(ArrayList<Bee> drones) {
    PVector separateForce = separate(drones);
    PVector seekForce = seek(new PVector(queenx, queeny));
    separateForce.mult(2);
    seekForce.mult(1);
    applyForce(separateForce);
    applyForce(seekForce);
  }

  // STEER = DESIRED MINUS VELOCITY (a method that calculates a steering force toward a target)
  PVector seek(PVector target) {
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target
    desired.normalize(); // Normalize desired and scale to maximum speed
    desired.mult(maxspeed);
    PVector steer = PVector.sub(desired, velocity);  // Steering = Desired minus velocity
    steer.limit(maxforce);  // Limit to maximum steering force
    return steer;
  }

  // Separation (method checks for nearby objects and steers away)
  PVector separate (ArrayList<Bee> bees) {
    float desiredseparation = r*2;
    PVector sum = new PVector();
    int count = 0;
    for (Bee other : bees) {// For every bee in the system, check if it's too close
      float d = PVector.dist(location, other.location); // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)

      if ((d > 0) && (d < desiredseparation)) { // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(location, other.location);
        diff.normalize();
        diff.div(d); //weight by distance
        sum.add(diff);
        count++; //keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      sum.div(count);
      sum.normalize(); // Our desired vector is the average scaled to maximum speed
      sum.mult(maxspeed);
      // Implement Reynolds: Steering = Desired - Velocity
      PVector steer = PVector.sub(sum, velocity);
      steer.limit(maxforce);
      applyForce(steer);
      sum.sub(velocity);
      sum.limit(maxforce);
    }
    return sum;
  }

  // Method to update location **used for both workers & drones
  void update() {
    velocity.add(acceleration); // Update velocity
    velocity.limit(maxspeed); // Limit speed
    location.add(velocity);
    acceleration.mult(0); // Reset accelertion to 0 each cycle
  }

  void addnoise() { 
    //if (mousePressed == true) {//used for worker bees
    velocity.x += random(-.2, .2);
    velocity.y += random(-.2, .2);
    //}
  }

  void workers() {
    //stroke(0);
    fill(255, 215, 0, 75);
    pushMatrix();
    translate(location.x, location.y);
    ellipse(0, 0, r, r);
    popMatrix();
  }
  
    void swarm() {
    //stroke(0);
    fill(255, 0, 0, 75);
    pushMatrix();
    translate(location.x, location.y);
    ellipse(0, 0, r, r);
    popMatrix();
  }

  void moveQueen() {
    if (keyPressed == true) {
      if (key == CODED) {
        if (keyCode == UP) { 
          queeny = queeny -2;
        }
        if (keyCode == DOWN) {
          queeny = queeny + 2;
        }
        if (keyCode == LEFT) { 
          queenx = queenx -3;
        }
        if (keyCode == RIGHT) {
          queenx = queenx + 3;
        }
      }
    }
  }

  void scare() { //NOT SURE IF THIS IS WORKING??????
    if (keyPressed == true) {
      if (key == CODED) {
        if (keyCode == TAB) {
          velocity.x += velocity.x*scare;
          velocity.y += velocity.y*scare;
          acceleration.x = acceleration.x*scare;
          acceleration.y = acceleration.y*scare;
        }
      }
    }
  }

  void borders() { //wraparound
    if (location.x < -r) location.x = width+r;
    if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    if (location.y > height+r) location.y = -r;
  }
}

