/**
 * Clase para representar un marcador en el contexto de la generación de diagramas de Voronoi.
 */
class Point {
  final int x, y;                    // Coordenadas del marcador en la matriz de píxeles
  Set<Pixel> boundaries;             // Píxeles límite relacionados con este punto
  List<PointDistance> neighborPaths; // Distancia para llegar a cada vecino, ruta más corta
  
  /**
   * Constructor de la clase Point.
   *
   * @param x La coordenada X del punto.
   * @param y La coordenada Y del punto.
   */
  Point(int x, int y) {
    this.x = x;
    this.y = y;
    this.boundaries = new HashSet<>();
    this.neighborPaths = new ArrayList<>();
  }
  
  /**
   * Establece los píxeles límite relacionados con este punto.
   *
   * @param pixels La lista de píxeles límite.
   */
  void setBoundaryPixels(List<Pixel> pixels) {
    this.boundaries = new HashSet<> (pixels);
  }
  
  /**
   * Obtiene las conexiones de vecinos relacionados con este punto.
   */
  void calculateNeighbors() {
    for(Pixel pixel : this.boundaries) {
      for(Pixel p : pixel.adjacentPixels) {
        Point marker = p.marker.getMarker();
        if(marker == this) continue;
        int minDistance = distance(this.x, this.y, marker.x, marker.y);
        PointDistance neighborPath = new PointDistance(marker, minDistance);
        int index = neighborPaths.indexOf(neighborPath);
        if(index != -1) {
          PointDistance currentPath = this.neighborPaths.get(index);
          float currentDistance = currentPath.getDistance();
          if(currentDistance < minDistance)
            currentPath.setDistance(minDistance);
        } else
          this.neighborPaths.add(neighborPath);
      }
    }
    Collections.sort(this.neighborPaths);
  }
  
  /**
   * Calcula y devuelve la distancia entre este punto y un punto vecino especificado.
   *
   * @param neighbor El punto vecino para el que se calculará la distancia.
   * @return La distancia entre este punto y el punto vecino.
   */
  int neighborDistance(Point neighbor) {
    for (PointDistance neighborPath : this.neighborPaths)
      if (neighborPath.getMarker().equals(neighbor))
        return neighborPath.getDistance();
    
    return distance(this.x, this.y, neighbor.x, neighbor.y);
  }
  
  /**
   * Obtiene y devuelve un arreglo de puntos vecinos ordenados por distancia ascendente.
   *
   * @return Un arreglo de puntos vecinos cercanos a este punto, ordenados por distancia.
   */
  Point[] getNeighbors() {
    Point[] neighbors = new Point[this.neighborPaths.size()];
    for(int i = 0; i < neighbors.length; i++)
      neighbors[i] = this.neighborPaths.get(i).getMarker();
    
    return neighbors;
  }
}
