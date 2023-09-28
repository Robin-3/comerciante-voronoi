/**
 * Interfaz funcional que representa una métrica de distancia entre dos puntos en un espacio bidimensional.
 */
@FunctionalInterface
interface Distance {
  /**
   * Calcula la distancia entre dos puntos en el espacio bidimensional.
   *
   * @param x1 Coordenada X del primer punto.
   * @param y1 Coordenada Y del primer punto.
   * @param x2 Coordenada X del segundo punto.
   * @param y2 Coordenada Y del segundo punto.
   * @return La distancia entre los dos puntos.
   */
  int calculateDistance(int x1, int y1, int x2, int y2);
}

/**
 * Implementación de la métrica de distancia Chebyshev.
 */
class Chebyshev implements Distance {
  @Override
  public int calculateDistance(int x1, int y1, int x2, int y2) {
    return Math.max(Math.abs(x1 - x2), Math.abs(y1 - y2));
  }
}

/**
 * Implementación de la métrica de distancia Manhattan.
 */
class Manhattan implements Distance {
  @Override
  public int calculateDistance(int x1, int y1, int x2, int y2) {
    return Math.abs(x1 - x2) + Math.abs(y1 - y2);
  }
}

/**
 * Implementación de la métrica de distancia Euclidiana al cuadrado.
 */
class Euclidean implements Distance {
  @Override
  public int calculateDistance(int x1, int y1, int x2, int y2) {
    int dx = x1 - x2;
    int dy = y1 - y2;
    return dx*dx + dy*dy;
  }
}

/*---*/

int distance(int x1, int y1, int x2, int y2) {
  return new Euclidean().calculateDistance(x1, y1, x2, y2);
}
