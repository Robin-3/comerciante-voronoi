class Pixel {
  int x, y;
  Pixel[] pixeles_adyacentes;
  boolean fue_visitada, es_limite;
  Point marcador_cercano;
  
  Pixel(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  void cargarPixelesAdyacentes(Pixel[] pixeles) {
    this.pixeles_adyacentes = pixeles;
  }
  
  void obtenerMarcadorCercano(Point nuevo_marcador) {
    if (this.fue_visitada) return;
    float distancia_actual = Float.MAX_VALUE;
    if(this.marcador_cercano != null)
      distancia_actual = dist(this.marcador_cercano.x, this.marcador_cercano.y, this.x, this.y);
    float distancia_nueva = dist(nuevo_marcador.x, nuevo_marcador.y, this.x, this.y);
    if(distancia_nueva < distancia_actual) {
      this.marcador_cercano = nuevo_marcador;
      this.fue_visitada = true;
      this.es_limite = false;
      for(Pixel vecino : this.pixeles_adyacentes) {
        vecino.obtenerMarcadorCercano(nuevo_marcador);
        vecino.fue_visitada = false;
        if(vecino.marcador_cercano != this.marcador_cercano) {
          this.es_limite = true;
          vecino.es_limite = true;
        }
      }
    }
  }
}
