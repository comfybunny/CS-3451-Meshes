// Sample code for starting the meshes project
import processing.opengl.*;
float time = 0;  // keep track of passing of time (for automatic rotation)
boolean rotate_flag = true;       // automatic rotation of model?
MeshObj currMesh;
boolean keyPressedYet,normalShade,randColor,strobe;
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
//        fill(currMesh.randomNumbers[numFace%500],currMesh.randomNumbers[(numFace+1)%500],currMesh.randomNumbers[(numFace+1)%500]);
        if(strobe){
          fill((int)random(255),(int)random(255),(int)random(255));
        }
        else if(randColor){
          fill(currMesh.randomNumbers[numFace%500],currMesh.randomNumbers[(numFace+1)%500],currMesh.randomNumbers[(numFace+2)%500]);
        }
        beginShape();
        normal(normFace.x, normFace.y, normFace.z);
        vertex (currFace1.x,  currFace1.y, currFace1.z);
        vertex (currFace2.x,  currFace2.y, currFace2.z);
        vertex (currFace3.x,  currFace3.y, currFace3.z);
        endShape(CLOSE);
        //fill(0,255,0);
        //drawNormal(currFace1, currFace2, currFace3, normFace);
      }
      else{
       //currMesh.vertexNormals
//        fill(currMesh.randomNumbers[numFace%500],currMesh.randomNumbers[(numFace+1)%500],currMesh.randomNumbers[(numFace+1)%500]);
        if(strobe){
          fill((int)random(255),(int)random(255),(int)random(255));
        }
        else if(randColor){
          fill(currMesh.randomNumbers[numFace%500],currMesh.randomNumbers[(numFace+1)%500],currMesh.randomNumbers[(numFace+2)%500]);
        }
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
  else if (key == ' ') {
    rotate_flag = !rotate_flag;          // rotate the model?
  }
  else if (key == 'q' || key == 'Q') {
    exit();                               // quit the program
  }
  else if (key == 'd') {
    dual();
  }
  else if (key == 'n') {
    normalShade = !normalShade;          // toggle per face and per vertex normal
  }
  else if (key == 'w') {
    randColor = !randColor;          // change color
  }  
  else if (key == 's') {
    strobe = !strobe;          // strobe color
  }
}

// void dualTRY(){
//   ArrayList<Vertex> newVerticies = new ArrayList<Vertex>();
//   ArrayList<Integer> newCornersTable = new ArrayList<Integer>();
//   // Iterate through all the verticies and get the faces it touches
//   for(int unseen=0; unseen<currMesh.verticies.size(); unseen++){
//     ArrayList<Vertex> centroidsList = new ArrayList<Vertex>();
//     // newFace is the index of the current corner
//     for(int newFace=0; newFace<currMesh.geometry.length; newFace++){
//       // Here the face will be part of the current examining vertex
//       if(currMesh.geometry[newFace]==unseen){
//         int currTriangle = newFace/3;
//         // This find the centroid of the current triangle
//         Vertex averageCentroid = 
//           centroidTriangle(currMesh.verticies.get(currMesh.geometry[currTriangle]), 
//                           currMesh.verticies.get(currMesh.geometry[currTriangle+1]), 
//                           currMesh.verticies.get(currMesh.geometry[currTriangle+2]));
//         centroidsList.add(averageCentroid);
//         int nextCornerIndex = swing(newFace);
//         while(nextCornerIndex!=newFace){
//           //println("nextCornerIndex: " + nextCornerIndex);
//           averageCentroid = 
//           centroidTriangle(currMesh.verticies.get(currMesh.geometry[(nextCornerIndex/3)*3]), 
//                           currMesh.verticies.get(currMesh.geometry[(nextCornerIndex/3)*3+1]), 
//                           currMesh.verticies.get(currMesh.geometry[(nextCornerIndex/3)*3+2]));
//           centroidsList.add(averageCentroid);
//           nextCornerIndex = swing(nextCornerIndex);
//         }
//         // By now I should have all of the centroid of the current vertex
//         // averageCentroid /= centroidsList.size
//         Vertex avgCentroid = centroidsList.get(0);
//         // THE CURRENT SIZE OF NEWVERTICIES WILL BE INDEX NEXT ONE IS ADDED TO
//         int firstIndex = newVerticies.size();
//         newVerticies.add(centroidsList.get(0));
//         for(int tempIng=1; tempIng<centroidsList.size(); tempIng++){
//           avgCentroid = avgCentroid.adding(centroidsList.get(tempIng));
//           newVerticies.add(centroidsList.get(tempIng));
//         }
//         avgCentroid.x = avgCentroid.x/centroidsList.size();
//         avgCentroid.y = avgCentroid.y/centroidsList.size();
//         avgCentroid.z = avgCentroid.z/centroidsList.size();
//         int indexCenter = newVerticies.size();
//         newVerticies.add(avgCentroid);
//         for(int tempIng=0; tempIng<centroidsList.size(); tempIng++){
//           // create triangle
//           newCornersTable.add(indexCenter);
//           newCornersTable.add(firstIndex+tempIng);
//           if(tempIng==centroidsList.size()-1){
//             newCornersTable.add(firstIndex);
//           }
//           else{
//             newCornersTable.add(firstIndex+tempIng+1);
//           }
//         }
//         break;
//       }
//       print("Got OUT OF WHILE LOOP PLS");
//     }
//   }
//   currMesh.verticies = newVerticies;
//   int[] newGeometry = new int[newCornersTable.size()];
//   for(int newCorner=0; newCorner<newCornersTable.size(); newCorner++){
//     newGeometry[newCorner] = newCornersTable.get(newCorner);
//   }
//   currMesh.geometry = newGeometry;
//   currMesh.opposite = makeCorners(newGeometry);
//   currMesh.faceNormals = faceNormals();
//   currMesh.vertexNormals = vertexNormalFill();
// }

void dual(){
  ArrayList<Vertex> newVerticies = new ArrayList<Vertex>();
  // for(int imperfections=0; imperfections<currMesh.geometry.length/3; imperfections++){
  //   Vertex lose =  centroidTriangle(currMesh.verticies.get(currMesh.geometry[imperfections]),
  //                                         currMesh.verticies.get(currMesh.geometry[imperfections+1]),
  //                                         currMesh.verticies.get(currMesh.geometry[imperfections+2]));
  //   newVerticies.add(lose);
  // }
  ArrayList<Integer> newCornersTable = new ArrayList<Integer>();
  // Iterate through all the verticies and get the faces it touches
  for(int unseen=0; unseen<currMesh.verticies.size(); unseen++){
    int newFace;
    for(newFace=0; newFace<currMesh.geometry.length; newFace++){
      // Here the face will be part of the current examining vertex
      if(currMesh.geometry[newFace]==unseen){
        break;
      }
    }
    //Here this will be the first corner touching V
    ArrayList<Vertex> centroidsList = new ArrayList<Vertex>();
    // Average centroid = (c.v+c.n.v+c.p.v)/3 
    Vertex cornerVertex = currMesh.verticies.get(currMesh.geometry[newFace]);
    Vertex cornerNextVertex = currMesh.verticies.get(currMesh.geometry[nextCorner(newFace)]);
    Vertex cornerPrevVertex = currMesh.verticies.get(currMesh.geometry[prevCorner(newFace)]);
    Vertex avgCentroid =  centroidTriangle(cornerVertex,cornerNextVertex,cornerPrevVertex);
    centroidsList.add(avgCentroid);


    if(findVertexIndex(newVerticies,avgCentroid)==-1){
      newVerticies.add(avgCentroid);
    }


    int nextTest = swing(newFace);
    // start adding all the faces
    Vertex avgofAverage = centroidsList.get(0);
    while(nextTest!=newFace){
      //println("New Face: " + newFace + "             Next test: "+nextTest);
      cornerVertex = currMesh.verticies.get(currMesh.geometry[nextTest]);
      cornerNextVertex = currMesh.verticies.get(currMesh.geometry[nextCorner(nextTest)]);
      cornerPrevVertex = currMesh.verticies.get(currMesh.geometry[prevCorner(nextTest)]);
      avgCentroid =  centroidTriangle(cornerVertex,cornerNextVertex,cornerPrevVertex);
      centroidsList.add(avgCentroid);
      if(findVertexIndex(newVerticies,avgCentroid)==-1){
        newVerticies.add(avgCentroid);
      }
      avgofAverage = avgofAverage.adding(avgCentroid);
      nextTest = swing(nextTest);
    }
    avgofAverage.x/=centroidsList.size();
    avgofAverage.y/=centroidsList.size();
    avgofAverage.z/=centroidsList.size();

    int indexOfVertCentroid = newVerticies.size();
    newVerticies.add(avgofAverage);

    int[] finder = new int[centroidsList.size()];
    for(int allOfMe=0; allOfMe<centroidsList.size(); allOfMe++){
      finder[allOfMe] = findVertexIndex(newVerticies, centroidsList.get(allOfMe));
    }
    for(int allOfMe=0; allOfMe<centroidsList.size(); allOfMe++){
      newCornersTable.add(indexOfVertCentroid);
      newCornersTable.add(finder[allOfMe]);
      if(allOfMe==centroidsList.size()-1){
        newCornersTable.add(finder[0]);
      }
      else{
        newCornersTable.add(finder[allOfMe+1]);
      }
    }
  }
  currMesh.verticies = newVerticies;
  //println("GOT HERE 1");
  int[] replaceCorners = new int[newCornersTable.size()];
  //println("GOT HERE 2");
  for(int giveMe=0; giveMe<newCornersTable.size(); giveMe++){
    replaceCorners[giveMe] = newCornersTable.get(giveMe);
    //println("INDEX: " + giveMe + "   VALUE: " + replaceCorners[giveMe]);
  }
  //println("GOT HERE 3");
  currMesh.geometry = replaceCorners;
  //println("GOT HERE 4");
  currMesh.opposite = makeCorners(replaceCorners);
  currMesh.faceNormals = faceNormals();
  currMesh.vertexNormals = vertexNormalFill();

}

//This will find the index a vertex is in a given ArrayList
int findVertexIndex(ArrayList<Vertex> haystack, Vertex needle){
  for(int endBeg=0; endBeg<haystack.size(); endBeg++){
    if(haystack.get(endBeg).equalTo(needle)){
      return endBeg;
    }
  }
  return -1;
}

void printCorners(){
  for(int cornI=0; cornI<currMesh.opposite.length; cornI++){
    print(currMesh.opposite[cornI] + "\n");
  }
} 
// Read polygon mesh from .ply file
void read_mesh (String filename){
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
  }
  
  
  // fill in OPPOSITES table
  currMesh.opposite = makeCorners(currMesh.geometry);
  // make a face normal table which will be number of faces
  currMesh.faceNormals = faceNormals();
  currMesh.vertexNormals = vertexNormalFill();
}
int[] makeCorners(int[] temp){
  Vertex aNextVert, bPrevVert, aPrevVert, bNextVert;
  println(temp.length);
  int[] tempRet = new int[temp.length];
  for(int a=0; a<temp.length; a++){
    for(int b=0; b<temp.length; b++){
      aNextVert = currMesh.verticies.get(temp[nextCorner(a)]);
      bPrevVert = currMesh.verticies.get(temp[prevCorner(b)]);
      aPrevVert = currMesh.verticies.get(temp[prevCorner(a)]);
      bNextVert = currMesh.verticies.get(temp[nextCorner(b)]);
      if((aNextVert.equalTo(bPrevVert))&&(aPrevVert.equalTo(bNextVert))){
        tempRet[a] = b;
        tempRet[b] = a;
      }
    }
  }
  // for(int qwerty=0; qwerty<temp.length; qwerty++){
  //   println("corners index " + qwerty + " :  " + tempRet[qwerty]);
  // }
  return tempRet;
}
ArrayList<Vertex> faceNormals(){
  Vertex point1, point2, point3,calcFaceNorm, tempVertNormal;
  ArrayList<Vertex> tempFaceRet = new ArrayList<Vertex>();
  for(int x=0; x<currMesh.geometry.length/3; x++){
    point1 = currMesh.verticies.get(currMesh.geometry[x*3]);
    point2 = currMesh.verticies.get(currMesh.geometry[x*3+1]);
    point3 = currMesh.verticies.get(currMesh.geometry[x*3+2]);
    calcFaceNorm = triangleNormal(point1,point2,point3);
    tempFaceRet.add(calcFaceNorm.normalizeVert());
    //print("facetable");
  }
  return tempFaceRet;
}
ArrayList<Vertex> vertexNormalFill(){
  ArrayList<Vertex> tempVertRet = new ArrayList<Vertex>();
  ArrayList<Vertex> runTwo;
  Vertex testAdd;
  for(int tryAgain=0; tryAgain<currMesh.verticies.size(); tryAgain++){
    runTwo = new ArrayList<Vertex>();
    for(int iterateThrough=0; iterateThrough<currMesh.geometry.length; iterateThrough++){
      if(currMesh.geometry[iterateThrough]==tryAgain){
        // triangle the vertex is apart of
        int triGle = iterateThrough/3;
      runTwo.add(currMesh.faceNormals.get(triGle));
      }
    }
    testAdd = runTwo.get(0);
    for(int raand=1; raand<runTwo.size(); raand++){
      testAdd = testAdd.adding(runTwo.get(raand));
    }
    tempVertRet.add(testAdd.normalizeVert());
  }
  return tempVertRet;
}
int nextCorner(int currCorner){
  //print("sizeOfCorners: " + currMesh.opposite.length);
  //println("curr corner:" + currCorner);
  int triangleCorner = currCorner/3;
  //println("next corner:" + (triangleCorner*3 + ((currCorner+1)%3)));
  return triangleCorner*3 + ((currCorner+1)%3);
}
int swing(int currCorner){
  //println("swing: " +nextCorner(currMesh.opposite[nextCorner(currCorner)]));
  return nextCorner(currMesh.opposite[nextCorner(currCorner)]);
}
int prevCorner(int currCorner){
  int nextC = nextCorner(currCorner);
  return nextCorner(nextC);
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
  int[] randomNumbers;
  MeshObj(int numVert, int numFace){
    geometry = new int[3*numFace];
    opposite = new int[3*numFace];
    verticies = new ArrayList<Vertex>();
    faceNormals = new ArrayList<Vertex>();
    vertexNormals = new ArrayList<Vertex>();
    randomNumbers = new int[500];
    for(int winWhenLose=0; winWhenLose<500; winWhenLose++){
      randomNumbers[winWhenLose] = (int)random(255);
    }
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
    if(abs(otherVert.x-x)<0.001 && abs(otherVert.y-y)<0.001 && abs(otherVert.z-z)<0.001){
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



