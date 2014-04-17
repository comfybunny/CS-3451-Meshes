// Sample code for starting the meshes project

import processing.opengl.*;

float time = 0;  // keep track of passing of time (for automatic rotation)
boolean rotate_flag = true;       // automatic rotation of model?
MeshObj currMesh;
boolean keyPressedYet;
// initialize stuff
void setup() {
  size(400, 400, OPENGL);  // must use OPENGL here !!!
  noStroke();     // do not draw the edges of polygons
}

// Draw the scene
void draw() {
  
  resetMatrix();  // set the transformation matrix to the identity (important!)

  background(0);  // clear the screen to black
  
  // set up for perspective projection
  perspective (PI * 0.333, 1.0, 0.01, 1000.0);
  
  // place the camera in the scene (just like gluLookAt())
  camera (0.0, 0.0, 5.0, 0.0, 0.0, -1.0, 0.0, 1.0, 0.0);
  
  scale (1.0, -1.0, 1.0);  // change to right-handed coordinate system
  
  // create an ambient light source
  ambientLight(102, 102, 102);
  
  // create two directional light sources
  lightSpecular(204, 204, 204);
  directionalLight(102, 102, 102, -0.7, -0.7, -1);
  directionalLight(152, 152, 152, 0, 0, -1);
  
  pushMatrix();

  fill(50, 50, 200);            // set polygon color to blue
  ambient (200, 200, 200);
  specular(0, 0, 0);
  shininess(1.0);
  
  rotate (time, 1.0, 0.0, 0.0);
  
  // THIS IS WHERE YOU SHOULD DRAW THE MESH
  
  
  if(!keyPressedYet){
    beginShape();
    normal (0.0, 0.0, 1.0);
    vertex (-1.0, -1.0, 0.0);
    vertex ( 1.0, -1.0, 0.0);
    vertex ( 1.0,  1.0, 0.0);
    vertex (-1.0,  1.0, 0.0);
    endShape(CLOSE);
  }
  else{
    Vertex currFace1, currFace2, currFace3;
    for(int numFace=0; numFace<(currMesh.geometry.length)/3; numFace++){
      beginShape();
//      println("numFace: " + numFace*3);
//      println("faces: " + currMesh.geometry[numFace*3] + " " + currMesh.geometry[numFace*3+1] + " " + currMesh.geometry[numFace*3+2]);
      currFace1 = currMesh.verticies.get(currMesh.geometry[numFace*3]);
      currFace2 = currMesh.verticies.get(currMesh.geometry[numFace*3+1]);
      currFace3 = currMesh.verticies.get(currMesh.geometry[numFace*3+2]);
//      println("vertex1: " + currFace1.x + " " + currFace1.y + " " + currFace1.z);
//      println("vertex2: " + currFace2.x + " " + currFace2.y + " " + currFace2.z);
//      println("vertex3: " + currFace3.x + " " + currFace3.y + " " + currFace3.z);
      vertex (currFace1.x,  currFace1.y, currFace1.z);
      vertex (currFace2.x,  currFace2.y, currFace2.z);
      vertex (currFace3.x,  currFace3.y, currFace3.z);
      endShape(CLOSE);
    }
  }
  
  
  popMatrix();
 
  // maybe step forward in time (for object rotation)
  if (rotate_flag )
    time += 0.02;
}

// handle keyboard input
void keyPressed() {
  if (key == '1') {
    read_mesh ("tetra.ply");
    keyPressedYet = true;
  }
  else if (key == '2') {
    read_mesh ("octa.ply");
    keyPressedYet = true;
  }
  else if (key == '3') {
    read_mesh ("icos.ply");
    keyPressedYet = true;
  }
  else if (key == '4') {
    read_mesh ("star.ply");
    keyPressedYet = true;
  }
  else if (key == '5') {
    read_mesh ("torus.ply");
    keyPressedYet = true;
  }
  else if (key == '6') {
    create_sphere();                     // create a sphere
  }
  else if (key == ' ') {
    rotate_flag = !rotate_flag;          // rotate the model?
  }
  else if (key == 'q' || key == 'Q') {
    exit();                               // quit the program
  }
  else if (key == 'd') {
    rotate_flag = !rotate_flag;          // triangulated dual
  }
  else if (key == 'n') {
    rotate_flag = !rotate_flag;          // toggle per face and per vertex normal
  }
  else if (key == 'w') {
    rotate_flag = !rotate_flag;          // change color
  }
}

// Read polygon mesh from .ply file
//
// You should modify this routine to store all of the mesh data
// into a mesh data structure instead of printing it to the screen.
void read_mesh (String filename)
{
  int i;
  String[] words;
  
  String lines[] = loadStrings(filename);
  
  words = split (lines[0], " ");
  int num_vertices = int(words[1]);
  // println ("number of vertices = " + num_vertices);
  
  words = split (lines[1], " ");
  int num_faces = int(words[1]);
  // println ("number of faces = " + num_faces);
  
  currMesh = new MeshObj(num_vertices,num_faces);
  
  // read in the vertices
  Vertex currVertex;
  for (i = 0; i < num_vertices; i++) {
    words = split (lines[i+2], " ");
    currVertex = new Vertex(float(words[0]),float(words[1]),float(words[2]));
    currMesh.verticies.add(currVertex);
    // float x = float(words[0]);
    // float y = float(words[1]);
    // float z = float(words[2]);
    // println ("vertex = " + x + " " + y + " " + z);
  }
  
  // read in the faces
  for (i = 0; i < num_faces; i++) {
    
    int j = i + num_vertices + 2;
    words = split (lines[j], " ");
    
    int nverts = int(words[0]);
    if (nverts != 3) {
      println ("error: this face is not a triangle.");
      exit();
    }
    currMesh.geometry[i*3] = int(words[1]); 
    currMesh.geometry[i*3+1] = int(words[2]); 
    currMesh.geometry[i*3+2] = int(words[3]); 
//    int index1 = int(words[1]);
//    int index2 = int(words[2]);
//    int index3 = int(words[3]);
//    println ("face = " + currMesh.geometry[i*3] + " " + currMesh.geometry[i*3+1] + " " + currMesh.geometry[i*3+2]);
  }
  
  
  // fill in corners table
  Vertex aNextVert, bPrevVert, aPrevVert, bNextVert;
  for(int a=0; a<currMesh.geometry.length; a++){
    for(int b=0; b<currMesh.geometry.length; b++){
      aNextVert = currMesh.verticies.get(currMesh.geometry[nextCorner(a)]);
      bPrevVert = currMesh.verticies.get(currMesh.geometry[prevCorner(b)]);
      aPrevVert = currMesh.verticies.get(currMesh.geometry[prevCorner(a)]);
      bNextVert = currMesh.verticies.get(currMesh.geometry[nextCorner(b)]);
      if((aNextVert.equalTo(bPrevVert))&&(aPrevVert.equalTo(bNextVert))){
        currMesh.opposite[a] = b;
        currMesh.opposite[b] = a;
      }
    }
  }
  
  
}

void create_sphere() {}

int nextCorner(int currCorner){
  int triangleCorner = currCorner/3;
  return triangleCorner*3 + ((currCorner+1)%3);
}

int prevCorner(int currCorner){
  int nextC = nextCorner(currCorner);
  return nextCorner(nextC);
}

private class MeshObj{
  ArrayList<Vertex> verticies;
  int[] opposite;
  int[] geometry;
  MeshObj(int numVert, int numFace){
    geometry = new int[3*numFace];
    opposite = new int[3*numFace];
    verticies = new ArrayList<Vertex>();
  }
}

private class Vertex{
  float x;
  float y;
  float z;
  Vertex(float vertX, float vertY, float vertZ){
    x = vertX;
    y = vertY;
    z = vertZ;
  }
  public boolean equalTo(Vertex otherVert){
    if(otherVert.x==x && otherVert.y==y && otherVert.z==z){
      return true;
    }
    return false;
  }
}
