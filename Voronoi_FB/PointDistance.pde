/**
 * La clase PointDistance representa un marcador con su distancia asociada a otro punto de referencia.
 */
class PointDistance implements Comparable<PointDistance> {
  private final Point marker; // El punto que al cual representa
  private int distance;       // La distancia al punto de referencia
  
  /**
   * Constructor de la clase PointDistance.
   *
   * @param marker   El punto al que se le calcula la distancia.
   * @param distance La distancia entre el punto de referencia y el marcador.
   * @throws NullPointerException     Si el marcador es nulo.
   * @throws IllegalArgumentException Si la distancia es negativa.
   */
  public PointDistance(Point marker, int distance) {
    Objects.requireNonNull(marker, "El marcador no puede ser nulo.");
    if (distance < 0) {
      throw new IllegalArgumentException("La distancia no puede ser negativa.");
    }
    this.marker = marker;
    this.distance = distance;
  }
  
  /**
   * Constructor de la clase PointDistance que asigna la distancia al valor máximo de un entero.
   *
   * @param marker El punto al que se le calcula la distancia.
   * @throws NullPointerException Si el marcador es nulo.
   */
  public PointDistance(Point marker) {
    this(marker, Integer.MAX_VALUE);
  }

  /**
   * Establece la distancia entre el punto de referencia y el marcador.
   *
   * @param distance La distancia a establecer.
   * @throws IllegalArgumentException Si la distancia es negativa.
   */
  public void setDistance(int distance) {
    if (distance < 0) {
      throw new IllegalArgumentException("La distancia no puede ser negativa.");
    }
    this.distance = distance;
  }

  /**
   * Obtiene la distancia entre el punto de referencia y el marcador.
   *
   * @return La distancia entre los puntos.
   */
  public int getDistance() {
    return this.distance;
  }

  /**
   * Obtiene el marcador asociado a este objeto PointDistance.
   *
   * @return El punto vecino.
   */
  public Point getMarker() {
    return this.marker;
  }

  /**
   * Compara este objeto PointDistance con otro objeto para determinar el orden relativo
   * basado en las distancias.
   *
   * @param other El otro objeto PointDistance a comparar.
   * @return Un valor negativo si este objeto tiene una distancia menor, un valor positivo si
   *         este objeto tiene una distancia mayor, y cero si las distancias son iguales.
   */
  @Override
  public int compareTo(PointDistance other) {
    return Integer.compare(this.distance, other.distance);
  }

  /**
   * Compara este objeto PointDistance con otro objeto para determinar si son iguales.
   *
   * @param obj El otro objeto a comparar.
   * @return true si los objetos son iguales (tienen el mismo punto vecino), false en caso contrario.
   */
  @Override
  public boolean equals(Object obj) {
    if (this == obj) return true;
    if (obj == null || this.getClass() != obj.getClass()) return false;
    PointDistance other = (PointDistance) obj;
    return Objects.equals(this.marker, other.marker);
  }

  /**
   * Genera un código hash basado en el marcador y la distancia.
   *
   * @return El código hash generado.
   */
  @Override
  public int hashCode() {
    return Objects.hash(this.marker, this.distance);
  }
}
