class Point {
  int x, y;
  ArrayList<Pixel> limites;
  ArrayList<Point> vecinos;
  
  Point(int x, int y) {
    this.x = x;
    this.y = y;
    this.limites = null;
    this.vecinos = new ArrayList<Point>();
  }
  
  void actualizarLimites(ArrayList<Pixel> pixeles) {
    this.limites = pixeles;
  }
  
  ArrayList<Point> conexionesVecinos() {
    if(this.vecinos == null || this.vecinos.size() == 0)
      this.obtenerVecinos();
    return this.vecinos;
  }
  
  void obtenerVecinos() {
    this.limpiarVecinos();
    for(Pixel pixel : limites) {
      for(Pixel p : pixel.pixeles_adyacentes) {
        if(p.marcador_cercano == this || this.vecinos.contains(p.marcador_cercano)) continue;
          this.vecinos.add(p.marcador_cercano);
      }
    }
  }
  
  void limpiarVecinos() {
    this.vecinos.clear();
  }
}
