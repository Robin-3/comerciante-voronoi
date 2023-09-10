int[] generarOrdenAleatorio(int longitud) {
  int[] orden = new int[longitud];
  ArrayList<Integer> opciones = new ArrayList<Integer>();
  for(int i = 0; i < longitud; i++)
    opciones.add(i);
  while(opciones.size() > 0) {
    int i = floor(random(opciones.size()));
    orden[longitud-opciones.size()] = opciones.get(i);
    opciones.remove(i);
  }
  return orden;
}
