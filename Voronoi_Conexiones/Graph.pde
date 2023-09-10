class Graph {
  boolean[][] matriz_adyacencia;
  ArrayList<int[]> conexiones;
  
  Graph() {
    this.conexiones = new ArrayList<int[]>();
    this.matriz_adyacencia = null;
  }
  
  void generarMatrizAdyacenciaVacia(int longitud) {
    boolean[][] matriz = new boolean[longitud][longitud];
    for(int j = 0; j < longitud; j++) {
      for(int i = 0; i < longitud; i++)
        matriz[i][j] = false;
    }
    this.matriz_adyacencia = matriz;
  }
  
  void AgregarVertices(ArrayList<int[]> vertices) {
    if(this.matriz_adyacencia == null || vertices == null) return;
    if(this.matriz_adyacencia.length == 0 || vertices.size() == 0) return;
    //index, x, y
    int[] nodo_1 = vertices.get(0);
    for(int i = 1; i < vertices.size(); i++) {
      int[] nodo_2 = vertices.get(i);
      boolean existe = nodo_1[0] == nodo_2[0] || this.matriz_adyacencia[nodo_1[0]][nodo_2[0]];
      if(!existe) {
        //x1, y1, x2, y2
        int[] conexion = new int[4];
        conexion[0] = nodo_1[1];
        conexion[1] = nodo_1[2];
        conexion[2] = nodo_2[1];
        conexion[3] = nodo_2[2];
        this.conexiones.add(conexion);
        this.matriz_adyacencia[nodo_1[0]][nodo_2[0]] = true;
        this.matriz_adyacencia[nodo_2[0]][nodo_1[0]] = true;
      }
    }
  }
  
  void limpiarVertices() {
    this.conexiones.clear();
  }
}
