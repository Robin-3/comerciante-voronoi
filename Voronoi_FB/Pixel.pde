/**
 * Clase para representar un píxel en un diagrama de Voronoi.
 */
class Pixel {
  final int x, y;         // Coordenadas del píxel en la matriz
  Pixel[] adjacentPixels; // Píxeles adyacentes a este píxel en la matriz
  boolean wasVisited;     // Indica si el píxel ha sido visitado durante la asignación del marcador
  boolean isBoundary;     // Indica si el píxel está en el límite de una región de Voronoi
  PointDistance marker;   // El marcador más cercano a este píxel junto a su distancia
  
  /**
   * Constructor de la clase Pixel.
   *
   * @param x La coordenada X del píxel.
   * @param y La coordenada Y del píxel.
   */
  Pixel(int x, int y) {
    this.x = x;
    this.y = y;
  }
  
  /**
   * Establece los píxeles adyacentes a este píxel.
   *
   * @param pixels Los píxeles adyacentes.
   */
  void setAdjacentPixels(Pixel[] pixels) {
    this.adjacentPixels = pixels;
  }
  
  /**
   * Limpia los datos del píxel para su reutilización.
   */
  void reset() {
    this.wasVisited = false;
    this.isBoundary = false;
    this.marker = null;
  }
  
  /**
   * Asigna el marcador más cercano a este píxel.
   *
   * @param newMarker El nuevo marcador a asignar.
   */
  void assignClosestMarker(Point newMarker) {
    if (this.marker == null)
      this.marker = new PointDistance(newMarker);
    
    Stack<Pixel> neighborsToVisit = new Stack<>();
    Stack<Pixel[]> updateBoundaries = new Stack<>();
    neighborsToVisit.push(this);
    
    while (!neighborsToVisit.isEmpty()) {
      Pixel currentPixel = neighborsToVisit.pop();
      int currentDistance = currentPixel.marker.getDistance();
      int newDistance = distance(newMarker.x, newMarker.y, currentPixel.x, currentPixel.y);
      
      if (newDistance < currentDistance) {
        PointDistance markerDistance = new PointDistance(newMarker, newDistance);
        if(currentPixel.marker.equals(markerDistance))
          currentPixel.marker.setDistance(newDistance);
        else
          currentPixel.marker = markerDistance;
        
        currentPixel.wasVisited = true;
        
        for (Pixel neighbor : currentPixel.adjacentPixels) {
          if (!neighbor.wasVisited) {
            if (neighbor.marker == null)
              neighbor.marker = new PointDistance(newMarker);
            
            neighborsToVisit.push(neighbor);
            neighbor.isBoundary = false;
            updateBoundaries.push(new Pixel[] {currentPixel, neighbor});
          }
        }
      }
    }
    
    while (!updateBoundaries.isEmpty()) {
      Pixel[] pixels = updateBoundaries.pop();
      Pixel currentPixel = pixels[0];
      Pixel neighborPixel = pixels[1];
      neighborPixel.wasVisited = false;
      if (!currentPixel.marker.equals(neighborPixel.marker)) {
        currentPixel.isBoundary = true;
        neighborPixel.isBoundary = true;
      }
    }
  }
}
