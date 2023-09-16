import java.util.Arrays;

int W = 32;
int H = 32;

Pixel pixeles[] = new Pixel[W*H];
ArrayList<Point> marcadores = new ArrayList<Point>();
int indice_lo = 0;
int[][] rutas = new int[][] {};
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
  for(int i = 0; i < marcadores.size()-int(circuto_abierto); i++) {
    int orden_1 = rutas[indice_lo][i];
    int orden_2 = rutas[indice_lo][(i+1)%marcadores.size()];
    Point vertice_1 = marcadores.get(orden_1);
    Point vertice_2 = marcadores.get(orden_2);
    distancia_actual += dist(vertice_1.x, vertice_1.y, vertice_2.x, vertice_2.y);
    line(vertice_1.x*w+w/2, vertice_1.y*h+h/2, vertice_2.x*w+w/2, vertice_2.y*h+h/2);
  }
  if(ruta_optima_indices.length > 0) {
    surface.setTitle(Arrays.toString(rutas[indice_lo]));
    if(distancia_actual < distancia_minima) {
      distancia_minima = distancia_actual;
      ruta_optima_indices = rutas[indice_lo];
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
  if(indice_lo < rutas.length-1)
    indice_lo++;
  else {
    if(marcadores.size() > 0) {
      temporizador.parar();
      surface.setTitle(Arrays.toString(ruta_optima_indices));
      println("    Distancia: "+distancia_minima);
      println("        Orden: "+Arrays.toString(ruta_optima_indices));
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
  indice_lo = 0;
  ruta_optima_indices = new int[0];
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

  ArrayList<Tree> pseudo_grafo = new ArrayList<Tree>();
  for(Point marcador : marcadores)
    pseudo_grafo.add(new Tree(marcador, new ArrayList<Point>()));
  
  ArrayList<ArrayList<Point>> rutas_encontradas = new ArrayList<ArrayList<Point>>();
  for(Tree nodo : pseudo_grafo) {
    nodo.buscarRutas(marcadores.size(), rutas_encontradas);
  }
  rutas = new int[rutas_encontradas.size()][marcadores.size()];
  for(int i = 0; i < rutas_encontradas.size(); i++) {
    for(int j = 0; j < marcadores.size(); j++) {
      rutas[i][j] = marcadores.indexOf(rutas_encontradas.get(i).get(j));
    }
  }
  
  ruta_optima_indices = new int[marcadores.size()];
  
  // Información
  println("--------------");
  println("   Marcadores: "+marcadores.size());
  println("Combinaciones: "+rutas.length);
  
  //Para pruebas
  //String[] s = new String[lo.size()];
  //for(int i = 0; i < lo.size(); i++) {
  //  float d = 0;
  //  for(int j = 0; j < marcadores.size(); j++) {
  //    int orden_1 = lo.get(i)[j];
  //    int orden_2 = lo.get(i)[(j+1)%marcadores.size()];
  //    Point vertice_1 = marcadores.get(orden_1);
  //    Point vertice_2 = marcadores.get(orden_2);
  //    d += dist(vertice_1.x, vertice_1.y, vertice_2.x, vertice_2.y);
  //  }
  //  s[i] = Arrays.toString(lo.get(i))+" : "+d;
  //}
  //saveStrings("combinaciones.txt", s);
}
