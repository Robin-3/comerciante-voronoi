class Pixel {
  int x, y;
  Pixel[] pixeles_adyacentes;
  
  Pixel(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  void cargarPixelesAdyacentes(Pixel[] pixeles) {
    this.pixeles_adyacentes = pixeles;
  }
}
