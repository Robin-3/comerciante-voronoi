import java.util.Arrays;

int W = 32;
int H = 32;

Pixel pixeles[] = new Pixel[W*H];
ArrayList<Point> marcadores = new ArrayList<Point>();

PImage img;

void setup() {
  size(532, 532, P2D);
  
  img = loadImage("map.png");
  
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
  image(img, 0, 0, width, height);
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
  for(Pixel pixel : pixeles) {
    Point marcador = pixel.marcador_cercano;
    if(marcador == null) continue;
    int c = floor(map(marcador.y*W+marcador.x, 0, W*H, 0, 255));
    int a = pixel.es_limite? floor(3*255/4) : floor(255/4);
    fill(c, 255, 255, a);
    rect(pixel.x*w, pixel.y*h, w, h);
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
}

void keyPressed() {
  if (key == 's' || key == 'S') {
    saveFrame("#######.png");
  }
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

float distTaxicap(float x1, float y1, float x2, float y2) {
  return abs(x1-x2)+abs(y1-y2);
}
