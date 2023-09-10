ArrayList<ArrayList<Point>> generarCombinaciones(ArrayList<Point> marcadores) {
  ArrayList<ArrayList<Point>> combinaciones_totales = new ArrayList<ArrayList<Point>>();
  for(int i = 0; i < marcadores.size(); i++) {
    Point marcador = marcadores.get(i);
    ArrayList<Point> combinaciones = new ArrayList<Point>();
    combinaciones.add(marcador);
    Point combinacion_desde = marcador;
    while(combinaciones.size() != marcadores.size()) {
      float distancia_minima = Float.MAX_VALUE;
      Point combinacion_minima = combinacion_desde;
      for(Point m : combinacion_desde.vecinos) {
        if(combinaciones.contains(m)) continue;
        float distancia_actual = dist(combinacion_desde.x, combinacion_desde.y, m.x, m.y);
        if(distancia_actual < distancia_minima) {
          distancia_minima = distancia_actual;
          combinacion_minima = m;
        }
      }
      combinacion_desde = combinacion_minima;
      combinaciones.add(combinacion_desde);
    }
    boolean repite = false;
    for(int j = 0; j < combinaciones.size(); j++)
      for(int k = j+1; k < combinaciones.size(); k++)
        if(combinaciones.get(j) == combinaciones.get(k)) {
          j = combinaciones.size();
          k = combinaciones.size();
          repite = true;
          break;
        }
    if(!repite)
      combinaciones_totales.add(combinaciones);
  }
  return combinaciones_totales;
}

String mostrarOrden(ArrayList<Point> orden, ArrayList<Point> marcadores) {
  int[] indices_orden = new int[orden.size()];
  for(int i = 0; i < indices_orden.length; i++)
    indices_orden[i] = marcadores.indexOf(orden.get(i));
  return Arrays.toString(indices_orden);
}
