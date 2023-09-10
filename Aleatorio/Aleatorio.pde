import java.util.Arrays;

int W = 32;
int H = 32;

Pixel pixeles[] = new Pixel[W*H];
ArrayList<Point> marcadores = new ArrayList<Point>();
Graph grafo_completo = new Graph();
int contador_lanzamientos = 1;
int[] ruta_optima_indices = new int[0];
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
  
  //Conexiones - Rutas totales
  stroke(255, 255/8);
  strokeWeight(10);
  for(int[] vertices : grafo_completo.conexiones) {
    line(vertices[0]*w+w/2, vertices[1]*h+h/2, vertices[2]*w+w/2, vertices[3]*h+h/2);
  }
  
  //Ruta actual calculada
  stroke(255/2, 255/2);
  strokeWeight(7);
  float distancia_actual = 0;
  int[] indexOrden = generarOrdenAleatorio(marcadores.size());
  for(int i = 0; i < marcadores.size()-int(circuto_abierto); i++) {
    Point vertice_1 = marcadores.get(indexOrden[i]);
    Point vertice_2 = marcadores.get(indexOrden[(i+1)%marcadores.size()]);
    distancia_actual += dist(vertice_1.x, vertice_1.y, vertice_2.x, vertice_2.y);
    line(vertice_1.x*w+w/2, vertice_1.y*h+h/2, vertice_2.x*w+w/2, vertice_2.y*h+h/2);
  }
  if(ruta_optima_indices.length > 0) {
    surface.setTitle(Arrays.toString(indexOrden));
    if(distancia_actual < distancia_minima) {
      distancia_minima = distancia_actual;
      ruta_optima_indices = indexOrden;
      surface.setTitle(Arrays.toString(ruta_optima_indices));
      println("-            - ");
      println("    Distancia: "+distancia_minima);
      println("        Orden: "+Arrays.toString(ruta_optima_indices));
      println("       Tiempo: "+temporizador.segundos());
      println("      Intento: "+contador_lanzamientos);
    }
  }
  
  //Ruta optima
  stroke(0);
  strokeWeight(4);
  for(int i = 0; i < ruta_optima_indices.length-int(circuto_abierto); i++) {
    Point vertice_1 = marcadores.get(ruta_optima_indices[i]);
    Point vertice_2 = marcadores.get(ruta_optima_indices[(i+1)%ruta_optima_indices.length]);
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
  contador_lanzamientos++;
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
    int indice = marcadores.indexOf(existe);
    marcadores.remove(indice);
  } else {
    Point nuevo_marcador = new Point(x, y);
    marcadores.add(nuevo_marcador);
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

void ActualizarCache() {
  // Limpieza de datos
  temporizador.parar();
  grafo_completo.limpiarVertices();
  grafo_completo.generarMatrizAdyacenciaVacia(0);
  
  contador_lanzamientos = 0;
  ruta_optima_indices = new int[0];
  distancia_minima = Float.MAX_VALUE;
  
  temporizador.iniciar();
  
  // Carga de datos
  
  grafo_completo.generarMatrizAdyacenciaVacia(marcadores.size());
  for(int i = 0; i < marcadores.size(); i++) {
    Point marcador = marcadores.get(i);
    ArrayList<int[]> conexiones = new ArrayList<int[]>();
    conexiones.add(new int[] {i, marcador.x, marcador.y});
    for(int j = 0; j < marcadores.size(); j++) {
      Point m = marcadores.get(j);
      conexiones.add(new int[] {j, m.x, m.y});
    }
    grafo_completo.AgregarVertices(conexiones);
  }
  
  ruta_optima_indices = new int[marcadores.size()];
  
  // Información
  println("--------------");
  println("   Marcadores: "+marcadores.size());
  println("   Conexiones: "+grafo_completo.conexiones.size());
}
