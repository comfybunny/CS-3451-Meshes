// Sample code for starting the meshes project

import processing.opengl.*;

float time = 0;  // keep track of passing of time (for automatic rotation)
boolean rotate_flag = true;       // automatic rotation of model?
MeshObj currMesh;
boolean keyPressedYet,normalShade,randColor,dual;
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
    Vertex currFace1, currFace2, currFace3, normFace, normVert1, normVert2, normVert3;
    for(int numFace=0; numFace<(currMesh.geometry.length)/3; numFace++){
//      println("numFace: " + numFace*3);
//      println("faces: " + currMesh.geometry[numFace*3] + " " + currMesh.geometry[numFace*3+1] + " " + currMesh.geometry[numFace*3+2]);
      currFace1 = currMesh.verticies.get(currMesh.geometry[numFace*3]);
      currFace2 = currMesh.verticies.get(currMesh.geometry[numFace*3+1]);
      currFace3 = currMesh.verticies.get(currMesh.geometry[numFace*3+2]);
      // shading per face; normal of the triangle
      if(!normalShade){
        normFace = currMesh.faceNormals.get(numFace);
        //fill(255,0,0);
        beginShape();
        normal(normFace.x, normFace.y, normFace.z);
        vertex (currFace1.x,  currFace1.y, currFace1.z);
        vertex (currFace2.x,  currFace2.y, currFace2.z);
        vertex (currFace3.x,  currFace3.y, currFace3.z);
        endShape(CLOSE);
        //fill(0,255,0);
        //drawNormal(currFace1, currFace2, currFace3, normFace);
      }
      // shading per vertex of object for smooth shading
      // TODO average the normals for all faces that share the vertex
      // TODO add all the adjacent face normals and normalize result
      else{
       //currMesh.vertexNormals
        beginShape();
        normVert1 = currMesh.vertexNormals.get(indexGeoTable(currFace1));
        normal(normVert1.x, normVert1.y, normVert1.z);
        vertex (currFace1.x,  currFace1.y, currFace1.z);
        
        normVert2 = currMesh.vertexNormals.get(indexGeoTable(currFace2));
        normal(normVert2.x, normVert2.y, normVert2.z);
        vertex (currFace2.x,  currFace2.y, currFace2.z);
        
        normVert3 = currMesh.vertexNormals.get(indexGeoTable(currFace3));
        normal(normVert3.x, normVert3.y, normVert3.z);
        vertex (currFace3.x,  currFace3.y, currFace3.z);
        endShape(CLOSE);
      }      
//      println("vertex1: " + currFace1.x + " " + currFace1.y + " " + currFace1.z);
//      println("vertex2: " + currFace2.x + " " + currFace2.y + " " + currFace2.z);
//      println("vertex3: " + currFace3.x + " " + currFace3.y + " " + currFace3.z);
     
    }
  }
  
  
  popMatrix();
 
  // maybe step forward in time (for object rotation)
  if (rotate_flag )
    time += 0.02;
}

void drawNormal(Vertex A, Vertex B, Vertex C, Vertex norm11){
  Vertex point1 = centroidTriangle(A,B,C);
  float a = .25;
  float b = .25;
  float c = .5;
  A = new Vertex(A.x, A.y, A.z);
  B = new Vertex(B.x, B.y, B.z);
  C = new Vertex(C.x, C.y, C.z);
  norm11 = new Vertex(norm11.x, norm11.y, norm11.z);
  A.x *= a;
  A.y *= a;
  A.z *= a;
  B.x *= b;
  B.y *= b;
  B.z *= b;
  C.x *= c;
  C.y *= c;
  C.z *= c;
  Vertex point2 = new Vertex(A.x+B.x+C.x, A.y+B.y+C.y, A.z+B.z+C.z);
  Vertex point3 = point1.adding(point2);
  point3.x *= .5;
  point3.y *= .5;
  point3.z *= .5;
  norm11.x *= 30;
  norm11.y *= 30;
  norm11.z *= 30;
  point3 = point3.adding(norm11);
  beginShape();
    vertex(point1.x, point1.y, point1.z);
    vertex(point2.x, point2.y, point2.z);
    vertex(point3.x, point3.y, point3.z);
  endShape();
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
    dual = !dual;                        // triangulated dual
  }
  else if (key == 'n') {
    normalShade = !normalShade;          // toggle per face and per vertex normal
  }
  else if (key == 'w') {
    randColor = !randColor;          // change color
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
  
  // make a face normal table which will be number of faces
  Vertex point1, point2, point3,calcFaceNorm, tempVertNormal;
  for(int x=0; x<currMesh.geometry.length/3; x++){
    point1 = currMesh.verticies.get(currMesh.geometry[x*3]);
    point2 = currMesh.verticies.get(currMesh.geometry[x*3+1]);
    point3 = currMesh.verticies.get(currMesh.geometry[x*3+2]);
    calcFaceNorm = triangleNormal(point1,point2,point3);
    currMesh.faceNormals.add(calcFaceNorm.normalizeVert());
    //print("facetable");
  }
  
  // make a vertex table while will be size of geometry :X
//  for(int unusedVar=0; unusedVar<currMesh.verticies.size(); unusedVar++){
//    tempVertNormal = getVertexNormal(currMesh.verticies.get(unusedVar));
//    currMesh.vertexNormals.add(tempVertNormal.normalizeVert());
//  }
  
  // iterate through corners table and find all the ones that have a vertex of a certain number
  ArrayList<Vertex> runTwo;
  Vertex testAdd;
  for(int tryAgain=0; tryAgain<currMesh.verticies.size(); tryAgain++){
    runTwo = new ArrayList<Vertex>();
    for(int iterateThrough=0; iterateThrough<currMesh.geometry.length; iterateThrough++){
      if(currMesh.geometry[iterateThrough]==tryAgain){
        // triangle the vertex is apart of
        int triGle = iterateThrough/3;
//        runTwo.add(triangleNormal(currMesh.verticies.get(currMesh.geometry[triGle]), 
//                                  currMesh.verticies.get(currMesh.geometry[triGle+1]), 
//                                  currMesh.verticies.get(currMesh.geometry[triGle+2])));
      runTwo.add(currMesh.faceNormals.get(triGle));
      }
    }
    testAdd = runTwo.get(0);
    for(int raand=1; raand<runTwo.size(); raand++){
      testAdd = testAdd.adding(runTwo.get(raand));
    }
    currMesh.vertexNormals.add(testAdd.normalizeVert());
  }

  // print opposites table
//  for(int cornI=0; cornI<currMesh.opposite.length; cornI++){
//    print(currMesh.opposite[cornI] + "\n");
//  }

  // iterate through corners table and find all the ones that have a vertex of a certain number
  
//  for(int try2=0; try2<currMesh.verticies.size(); try2++){
//    ArrayList<Vertex> temp4 = new ArrayList<Vertex>();
//    if(temp4.size()!=0){
//      print("fail1");
//    }
//    for(int try3=0; try3<currMesh.geometry.length; try3++){
//      if(currMesh.geometry[try3]==try2){
//        int triangleNumber = (try3)/3;
//        Vertex anotherTemp1 = currMesh.verticies.get(currMesh.geometry[triangleNumber]);
//        Vertex anotherTemp2 = currMesh.verticies.get(currMesh.geometry[triangleNumber+1]);
//        Vertex anotherTemp3 = currMesh.verticies.get(currMesh.geometry[triangleNumber+2]);
//        Vertex calcFaceNorm2 = triangleNormal(anotherTemp1,anotherTemp2,anotherTemp3);
//        temp4.add(calcFaceNorm2);
//      }
//    }
//    Vertex reAdd = temp4.get(0);
//    for(int xyz=1; xyz<temp4.size(); xyz++){
//      reAdd=reAdd.adding(temp4.get(xyz));
//    }
//    currMesh.vertexNormals.add(reAdd.normalizeVert());
//  }
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

int swing(int currCorner){
  int swingVal = nextCorner(currCorner);
  swingVal = currMesh.opposite[swingVal];
  return nextCorner(swingVal);
}

int indexGeoTable(Vertex currVert){
  for(int i=0; i<currMesh.verticies.size(); i++){
    if(currVert.equalTo(currMesh.verticies.get(i))){
      return i;
    }
  }
  return -1;
}

int indexCornersTable(int currI){
  for(int unIter=0; unIter<currMesh.geometry.length; unIter++){
    if(currMesh.geometry[unIter]==currI){
      return unIter;
    }
  }
  return -1;
}
// shading per vertex of object for smooth shading
// TODO average the normals for all faces that share the vertex
// TODO add all the adjacent face normals and normalize result
Vertex getVertexNormal(Vertex currVert){
  // vertexTableIndex is a index for a corner
  ArrayList<Vertex> tempHolder = new ArrayList<Vertex>();
  int vertexTableIndex = indexCornersTable(indexGeoTable(currVert));
  // need to loop through geometry table and find the index of vertexTableIndex
  tempHolder.add(currMesh.verticies.get(currMesh.geometry[(vertexTableIndex/3)*3]));
  tempHolder.add(currMesh.verticies.get(currMesh.geometry[(vertexTableIndex/3)*3+1]));
  tempHolder.add(currMesh.verticies.get(currMesh.geometry[(vertexTableIndex/3)*3+2]));
  int nextSwingIndex = swing(vertexTableIndex);
  while(vertexTableIndex!=nextSwingIndex){
    print(nextSwingIndex);
    tempHolder.add(currMesh.verticies.get(currMesh.geometry[(nextSwingIndex/3)*3]));
    tempHolder.add(currMesh.verticies.get(currMesh.geometry[(nextSwingIndex/3)*3+1]));
    tempHolder.add(currMesh.verticies.get(currMesh.geometry[(nextSwingIndex/3)*3+2]));
    nextSwingIndex = swing(vertexTableIndex);
  }
  print("added all the things for triangles touching and didnt break?" + tempHolder.size());
  Vertex tempNormalFace;
  ArrayList<Vertex> freljord = new ArrayList<Vertex>();
  for(int it=0; it<tempHolder.size()/3; it++){
    tempNormalFace = triangleNormal(tempHolder.get(it*3),tempHolder.get(it*3+1),tempHolder.get(it*3+2));
    freljord.add(tempNormalFace);
  }
  Vertex snacks = freljord.get(0);
  for(int poro=1; poro<freljord.size(); poro++){
    snacks = snacks.adding(freljord.get(poro));
  }
  return snacks.normalizeVert();
}


Vertex centroidTriangle(Vertex v1, Vertex v2, Vertex v3){
  float xMean = (v1.x+v2.x+v3.x)/3;
  float yMean = (v1.y+v2.y+v3.y)/3;
  float zMean = (v1.z+v2.z+v3.z)/3;
  Vertex centroid = new Vertex(xMean, yMean, zMean);
  return centroid;
}

Vertex triangleNormal(Vertex v1, Vertex v2, Vertex v3){
  Vertex U = v2.subtracts(v1);
  Vertex V = v3.subtracts(v1);
  return U.crossProd(V).normalizeVert();
}

private class MeshObj{
  ArrayList<Vertex> verticies;
  ArrayList<Vertex> faceNormals;
  ArrayList<Vertex> vertexNormals;
  int[] opposite;
  int[] geometry;
  MeshObj(int numVert, int numFace){
    geometry = new int[3*numFace];
    opposite = new int[3*numFace];
    verticies = new ArrayList<Vertex>();
    faceNormals = new ArrayList<Vertex>();
    vertexNormals = new ArrayList<Vertex>();
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
  // currentVertex - two
  public Vertex subtracts(Vertex two){
    Vertex returnSub = new Vertex(x-two.x, y-two.y, z-two.z);
    return returnSub;
  }

  public Vertex adding(Vertex two){
    Vertex returnSub = new Vertex(x+two.x, y+two.y, z+two.z);
    return returnSub;
  }
  
  // currentVertex cross product vVertex
  public Vertex crossProd(Vertex vVertex){
    Vertex returnCProd = new Vertex(y*vVertex.z-z*vVertex.y,z*vVertex.x-x*vVertex.z,x*vVertex.y-y*vVertex.x);
    return returnCProd;
  }
  public Vertex normalizeVert(){
    float sumSides = sqrt(x*x+y*y+z*z);
    Vertex returnNormal = new Vertex(x/sumSides,y/sumSides,z/sumSides);
    return returnNormal;
  }
}
