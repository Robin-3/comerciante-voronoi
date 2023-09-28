import java.util.Collections;
import java.util.Objects;
import java.util.HashSet;
import java.util.Arrays;
import java.util.Stack;
import java.util.List;
import java.util.Set;

int W = 32;
int H = 32;

Pixel pixels[] = new Pixel[W*H];
List<Point> markers = new ArrayList<>();
int orderIndex = 0;
int[][] paths = new int[][] {};
int[] optimalPathIndices = new int[0];
int minDistance = Integer.MAX_VALUE;
Timer timer = new Timer();
boolean openCircuit = false;

//PImage img;

void setup() {
  size(532, 532, P2D);
  
  //img = loadImage("map.png");
  
  for (int j = 0; j < H; j++)
    for (int i = 0; i < W; i++)
      pixels[j*W+i] = new Pixel(i, j);
  
  for (int j = 0; j < H; j++) {
    for (int i = 0; i < W; i++) {
      Set<Pixel> adjacentPixels = new HashSet<>();
      if(i-1 >= 0) //izquierda
        adjacentPixels.add(pixels[j*W+(i-1)]);
      if(j-1 >= 0) //arriba
        adjacentPixels.add(pixels[(j-1)*W+i]);
      if(i+1 < W && j+1 < H) //abajo-derecha
        adjacentPixels.add(pixels[(j+1)*W+(i+1)]);
      
      Pixel[] adjacentArray = new Pixel[adjacentPixels.size()];
      adjacentArray = adjacentPixels.toArray(adjacentArray);
      
      pixels[j*W+i].setAdjacentPixels(adjacentArray);
    }
  }
  
  colorMode(HSB);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(0);
  //image(img, 0, 0, width, height);
  noStroke();
  float w = width/(W+0.0);
  float h = height/(H+0.0);
  
  // Cuadricula
  noFill();
  stroke(255);
  for(int j = 0; j < H; j++)
    for(int i = 0; i < W; i++)
      rect(i*w, j*h, w, h);
  
  //Limites ciudades
  for(Point marker : markers) {
    fill(map(marker.y*W+marker.x, 0, W*H, 0, 255), 255, 255, 3*255/4);
    for(Pixel pixel : marker.boundaries)
      rect(pixel.x*w, pixel.y*h, w, h);
  }
  
  //Conexiones - Rutas totales
  stroke(255, 255/8);
  strokeWeight(10);
  for(Point marker : markers)
    for(Point m : marker.getNeighbors())
      line(marker.x*w+w/2, marker.y*h+h/2, m.x*w+w/2, m.y*h+h/2);
  
  //Ruta actual calculada
  stroke(255/2, 255/2);
  strokeWeight(7);
  int currentDistance = 0;
  for(int i = 0; i < markers.size()-int(openCircuit); i++) {
    int order1 = paths[orderIndex][i];
    int order2 = paths[orderIndex][(i+1)%markers.size()];
    Point vertice_1 = markers.get(order1);
    Point vertice_2 = markers.get(order2);
    currentDistance += vertice_1.neighborDistance(vertice_2);
    line(vertice_1.x*w+w/2, vertice_1.y*h+h/2, vertice_2.x*w+w/2, vertice_2.y*h+h/2);
  }
  
  if(optimalPathIndices.length > 0) {
    surface.setTitle(Arrays.toString(paths[orderIndex]));
    if(currentDistance < minDistance) {
      minDistance = currentDistance;
      optimalPathIndices = paths[orderIndex];
    }
  }
  
  //Ruta optima
  stroke(0);
  strokeWeight(4);
  for(int i = 0; i < optimalPathIndices.length-int(openCircuit); i++) {
    Point vertex1 = markers.get(optimalPathIndices[i]);
    Point vertex2 = markers.get(optimalPathIndices[(i+1)%optimalPathIndices.length]);
    line(vertex1.x*w+w/2, vertex1.y*h+h/2, vertex2.x*w+w/2, vertex2.y*h+h/2);
  }
  
  //Ciudades
  strokeWeight(1);
  noStroke();
  for(Point marker : markers) {
    fill(map(marker.y*W+marker.x, 0, W*H, 0, 255), 255, 255);
    rect(marker.x*w, marker.y*h, w, h);
    fill(0);
    text(markers.indexOf(marker), marker.x*w+w/2, marker.y*h+h/2);
  }
  if(orderIndex < paths.length-1)
    orderIndex++;
  else {
    if(markers.size() > 0) {
      timer.stop();
      surface.setTitle(Arrays.toString(optimalPathIndices));
      println("    Distancia: "+minDistance);
      println("        Orden: "+Arrays.toString(optimalPathIndices));
      println("       Tiempo: "+timer.seconds());
    }
    noLoop();
  }
}

void mousePressed() {
  int x = max(min(floor(map(mouseX, 0, width, 0, W)), W-1), 0);
  int y = max(min(floor(map(mouseY, 0, height, 0, H)), H-1), 0);
  
  Point exists = null;
  for(Point marker : markers)
    if(marker.x == x && marker.y == y) {
      exists = marker;
      break;
    }

  if(exists != null)
    markers.remove(exists);
  else
    markers.add(new Point(x, y));
  
  updateCache();
  loop();
}

void keyPressed() {
  if (key == 'c' || key == 'C')
    openCircuit = !openCircuit;
  
  updateCache();
  loop();
}

void addMarkers(List<Point> newMarkers) {
  for(Point marker : newMarkers) {
    int index = marker.y*W+marker.x;
    pixels[index].assignClosestMarker(marker);
  }
}

void updateCache() {
  // Limpieza de datos
  orderIndex = 0;
  optimalPathIndices = new int[0];
  minDistance = Integer.MAX_VALUE;

  for(Pixel pixel : pixels)
    pixel.reset();
  
  for(Point marker : markers)
    marker.neighborPaths.clear();
  
  timer.start();
  
  // Carga de datos
  addMarkers(markers);
  
  List<Pixel>[] cache = new ArrayList[markers.size()];
  
  for(int i = 0; i < cache.length; i++)
    cache[i] = new ArrayList<Pixel>();
  
  for(Pixel pixel : pixels)
    if(pixel.isBoundary)
      cache[markers.indexOf(pixel.marker.getMarker())].add(pixel);
  
  for(int i = 0; i < markers.size(); i++)
    markers.get(i).setBoundaryPixels(cache[i]);

  for(Point marker : markers)
    marker.calculateNeighbors();

  List<Tree> pseudoGraph = new ArrayList<>();
  for(Point marker : markers)
    pseudoGraph.add(new Tree(marker));
  
  for(Tree pGraph : pseudoGraph)
    pGraph.calculateBranches();
    
  List<List<Point>> foundPaths = new ArrayList<List<Point>>();
  for(Tree node : pseudoGraph) {
    node.buscarRutas(markers.size(), foundPaths);
  }
  paths = new int[foundPaths.size()][markers.size()];
  for(int i = 0; i < foundPaths.size(); i++)
    for(int j = 0; j < markers.size(); j++)
      paths[i][j] = markers.indexOf(foundPaths.get(i).get(j));
  
  if(paths.length != 0)
    optimalPathIndices = paths[0];
  
  // Información
  println("--------------");
  println("   Marcadores: "+markers.size());
  println("Combinaciones: "+paths.length);
}
