import java.util.Arrays;

int W = 32;
int H = 32;

Pixel pixeles[] = new Pixel[W*H];
ArrayList<Point> marcadores = new ArrayList<Point>();
Graph grafo_voronoi = new Graph();
ArrayList<ArrayList<Point>> orden = new ArrayList<ArrayList<Point>>();
int indice_o = 0;
ArrayList<Point> ruta_optima = new ArrayList<Point>();
float distancia_minima = Float.MAX_VALUE;
Timer temporizador = new Timer();
boolean circuto_abierto = false;

//PImage img;

void setup() {
  size(532, 532, P2D);
  
  //img = loadImage("map.png");
  
  for (int j = 0; j < H; j++)
    for (int i = 0; i < W; i++)
      pixeles[j*W+i] = new Pixel(i, j);
  
  for (int j = 0; j < H; j++) {
    for (int i = 0; i < W; i++) {
      ArrayList<Pixel> pixeles_adyacentes = new ArrayList<Pixel>();
      if(i-1 >= 0)
        pixeles_adyacentes.add(pixeles[j*W+(i-1)]);
      if(j-1 >= 0)
        pixeles_adyacentes.add(pixeles[(j-1)*W+i]);
      if(i+1 < W)
        pixeles_adyacentes.add(pixeles[j*W+(i+1)]);
      if(j+1 < H)
        pixeles_adyacentes.add(pixeles[(j+1)*W+i]);
      
      Pixel[] p_a = new Pixel[pixeles_adyacentes.size()];
      p_a = pixeles_adyacentes.toArray(p_a);
      
      pixeles[j*W+i].cargarPixelesAdyacentes(p_a);
    }
  }
  
  colorMode(HSB);
  textAlign(CENTER, CENTER);
}

void draw() {
  background(0);
  //image(img, 0, 0, width, height);
  noStroke();
  float w = width/(W+.0);
  float h = height/(H+.0);
  
  // Cuadricula
  noFill();
  stroke(255);
  for(int j = 0; j < H; j++) {
    for(int i = 0; i < W; i++) {
      rect(i*w, j*h, w, h);
    }
  }
  
  //Limites ciudades
  for(Point marcador : marcadores) {
    fill(map(marcador.y*W+marcador.x, 0, W*H, 0, 255), 255, 255, 3*255/4);
    for(Pixel pixel : marcador.limites)
      rect(pixel.x*w, pixel.y*h, w, h);
  }
  
  //Conexiones - Rutas totales
  stroke(255, 255/8);
  strokeWeight(10);
  for(Point marcador : marcadores) {
    for(Point m : marcador.vecinos) {
      line(marcador.x*w+w/2, marcador.y*h+h/2, m.x*w+w/2, m.y*h+h/2);
    }
  }
  
  //Ruta actual calculada
  stroke(255/2, 255/2);
  strokeWeight(7);
  float distancia_actual = 0;
  for(int i = 0; i < orden.size()-int(circuto_abierto); i++) {
    Point vertice_1 = orden.get(indice_o).get(i);
    Point vertice_2 = orden.get(indice_o).get((i+1)%orden.size());
    distancia_actual += dist(vertice_1.x, vertice_1.y, vertice_2.x, vertice_2.y);
    line(vertice_1.x*w+w/2, vertice_1.y*h+h/2, vertice_2.x*w+w/2, vertice_2.y*h+h/2);
  }
  if(orden.size() > 0) {
    surface.setTitle(mostrarOrden(orden.get(indice_o), marcadores));
    if(distancia_actual < distancia_minima) {
      distancia_minima = distancia_actual;
      ruta_optima = orden.get(indice_o);
    }
  }
  
  //Ruta optima
  stroke(0);
  strokeWeight(4);
  for(int i = 0; i < ruta_optima.size()-int(circuto_abierto); i++) {
    Point vertice_1 = ruta_optima.get(i);
    Point vertice_2 = ruta_optima.get((i+1)%ruta_optima.size());
    line(vertice_1.x*w+w/2, vertice_1.y*h+h/2, vertice_2.x*w+w/2, vertice_2.y*h+h/2);
  }
  
  //Ciudades
  strokeWeight(1);
  noStroke();
  for(Point marcador : marcadores) {
    fill(map(marcador.y*W+marcador.x, 0, W*H, 0, 255), 255, 255);
    rect(marcador.x*w, marcador.y*h, w, h);
    fill(0);
    text(marcadores.indexOf(marcador), marcador.x*w+w/2, marcador.y*h+h/2);
  }
  if(indice_o < orden.size()-1)
    indice_o++;
  else {
    if(marcadores.size() > 0) {
      temporizador.parar();
      String orden_indices = mostrarOrden(ruta_optima, marcadores);
      surface.setTitle(orden_indices);
      println("    Distancia: "+distancia_minima);
      println("        Orden: "+orden_indices);
      println("       Tiempo: "+temporizador.segundos());
    }
    noLoop();
  }
}

void mousePressed() {
  int x = max(min(floor(map(mouseX, 0, width, 0, W)), W-1), 0);
  int y = max(min(floor(map(mouseY, 0, height, 0, H)), H-1), 0);
  
  Point existe = null;
  for(Point marcador : marcadores)
    if(marcador.x == x && marcador.y == y) {
      existe = marcador;
      break;
    }

  if(existe != null) {
    for(Pixel pixel : pixeles)
      pixel.marcador_cercano = null;
    
    int indice = marcadores.indexOf(existe);
    marcadores.remove(indice);
    AgregarMarcadores(marcadores);
  } else {
    Point nuevo_marcador = new Point(x, y);
    marcadores.add(nuevo_marcador);
    AgregarMarcador(nuevo_marcador);
  }
  
  ActualizarCache();
  loop();
}

void keyPressed() {
  if (key == 'c' || key == 'C') {
    circuto_abierto = !circuto_abierto;
  }
  ActualizarCache();
  loop();
}

void AgregarMarcador(Point marcador) {
    int index = marcador.y*W+marcador.x;
    pixeles[index].obtenerMarcadorCercano(marcador);
}

void AgregarMarcadores(ArrayList<Point> nuevos_marcadores) {
  for(Point marcador : nuevos_marcadores) {
    int index = marcador.y*W+marcador.x;
    pixeles[index].obtenerMarcadorCercano(marcador);
  }
}

void ActualizarCache() {
  // Limpieza de datos
  grafo_voronoi.limpiarVertices();
  grafo_voronoi.generarMatrizAdyacenciaVacia(0);
  
  indice_o = 0;
  orden.clear();
  ruta_optima.clear();
  distancia_minima = Float.MAX_VALUE;

  for(Point marcador : marcadores)
    marcador.limpiarVecinos();
  
  temporizador.iniciar();
  
  // Carga de datos
  ArrayList<Pixel>[] cache = new ArrayList[marcadores.size()];
  
  for(int i = 0; i < cache.length; i++)
    cache[i] = new ArrayList<Pixel>();
  
  for(Pixel pixel : pixeles)
    if(pixel.es_limite)
      cache[marcadores.indexOf(pixel.marcador_cercano)].add(pixel);
  
  for(int i = 0; i < marcadores.size(); i++)
    marcadores.get(i).actualizarLimites(cache[i]);

  for(Point marcador : marcadores)
    marcador.obtenerVecinos();

  grafo_voronoi.generarMatrizAdyacenciaVacia(marcadores.size());
  for(int i = 0; i < marcadores.size(); i++) {
    Point marcador = marcadores.get(i);
    ArrayList<int[]> conexiones = new ArrayList<int[]>();
    conexiones.add(new int[] {i, marcador.x, marcador.y});
    for(int j = 0; j < marcadores.size(); j++) {
      Point m = marcadores.get(j);
      if(!marcador.vecinos.contains(m)) continue;
      conexiones.add(new int[] {j, m.x, m.y});
    }
    grafo_voronoi.AgregarVertices(conexiones);
  }
  
  orden = generarCombinaciones(marcadores);
  
  // Información
  //println("--------------");
  //println("   Marcadores: "+marcadores.size());
  //println("   Conexiones: "+grafo_voronoi.conexiones.size());
  //println("Combinaciones: "+orden.size());
  
  ////Para pruebas
  //String[] s = new String[orden.size()];
  //for(int i = 0; i < orden.size(); i++) {
  //  float d = 0;
  //  for(int j = 0; j < marcadores.size(); j++) {
  //    Point vertice_1 = orden.get(i).get(j);
  //    Point vertice_2 = orden.get(i).get((j+1)%marcadores.size());
  //    d += dist(vertice_1.x, vertice_1.y, vertice_2.x, vertice_2.y);
  //  }
  //  s[i] = mostrarOrden(orden.get(i), marcadores)+" : "+d;
  //}
  //saveStrings("combinaciones.txt", s);
}
