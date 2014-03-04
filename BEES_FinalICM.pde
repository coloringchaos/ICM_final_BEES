//Arielle Hein

//arrow keys move the swarm
//w adds worker bees, s adds swarm bees

import java.util.*;

ArrayList<Bee> bees;
ArrayList<Bee> swarm;

void setup() {
  size(1400, 850, "processing.core.PGraphicsRetina2D");
  noStroke();
  bees = new ArrayList<Bee>();
  for (int i = 0; i < 200; i++) {
    bees.add(new Bee(random(width), random(height)));
  }

  swarm = new ArrayList<Bee>();
  for (int j = 0; j < 300; j++) {
    swarm.add(new Bee(random(width), random(height)));
  }
}

void draw() {
  //background(255);
  noCursor();
  for (Bee v : bees) {
    v.separate(bees); // Path following and separation are worked on in this function
    v.update();
    v.borders();
    v.workers();
    v.addnoise();
    v.scare();
  }

  for (Bee w : swarm) {
    w.applyBehaviors(swarm);
    w.update();
    w.swarm();
    //w.workers();
    w.moveQueen();
    w.scare();
  }
}

/*void mouseDragged() {
  bees.add(new Bee(mouseX, mouseY));
}*/

void keyPressed() {
  if (keyPressed == true) {
    if (key == 's') { //adds a swarm bee
      swarm.add(new Bee(random(0, width), random(0, height))); //a bee is added at a random location
    }
    if (key == 'w') { //adds a swarm bee
      bees.add(new Bee(random(0, width), random(0, height))); //a bee is added at a random location
    }
    if (key == 'b') {
      //swarm.add(new Bee(w.queenx, w.queeny));
    }
  }
}

