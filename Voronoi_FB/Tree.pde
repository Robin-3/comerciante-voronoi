/**
 * Clase para representar un árbol utilizado en la generación de diagramas de Voronoi.
 */
class Tree {
  Point node;
  List<Point> rootPath; // Lista de marcadores en la ruta hacia la raíz del árbol
  Set<Tree> childTrees; // Subárboles
  
  /**
   * Constructor de la clase Tree.
   *
   * @param node El nodo del árbol.
   * @param rootPath La lista de puntos en la ruta raíz del árbol.
   * @throws NullPointerException     Si el marcador es nulo.
   */
  Tree(Point node, List<Point> rootPath) {
    Objects.requireNonNull(node, "El marcador no puede ser nulo.");
    this.node = node;
    this.rootPath = rootPath;
    this.childTrees = new HashSet<>();
  }
    
  /**
   * Constructor de la clase Tree que asigna la ruta hacia la raíz como una lista vacia.
   *
   * @param node El nodo del árbol.
   */
  Tree(Point node) {
    this(node, new ArrayList<>());
  }
  
  /**
   * Calcula las ramas del árbol a partir del nodo actual.
   */
  void calculateBranches() {
    List<Point> extendedPath = new ArrayList<> (this.rootPath);
    extendedPath.add(this.node);
    for(Point neighbor : this.node.getNeighbors())
      if(!(this.rootPath.contains(neighbor))) {
        Tree child = new Tree(neighbor, extendedPath);
        child.calculateBranches();
        this.childTrees.add(child);
      }
  }
  
  /**
   * Busca rutas de una longitud específica en el árbol y las agrega a la lista de rutas encontradas.
   *
   * @param longitud La longitud deseada de las rutas.
   * @param rutasEncontradas Lista de rutas encontradas.
   */
  void buscarRutas(int length, List<List<Point>> foundPaths) {
    if(this.childTrees.isEmpty() && this.rootPath.size() == length-1) {
      List<Point> path = new ArrayList<> (this.rootPath);
      path.add(this.node);
      
      if(!existsInList(foundPaths, path))
        foundPaths.add(path);
      return;
    }
    
    for(Tree child : this.childTrees) {
      child.buscarRutas(length, foundPaths);
    }
  }
}

/**
 * Verifica si una lista cíclica existe en la lista de listas.
 *
 * @param listList    Lista de listas.
 * @param targetList  Lista que se busca.
 * @return true si la lista existe en la lista de listas, false en caso contrario.
 */
boolean existsInList(List<List<Point>> listList, List<Point> targetList) {
  int size = targetList.size();
  for (int i = 0; i < size; i++) {
    List<Point> val = new ArrayList<> (targetList.subList(i, size));
    val.addAll(targetList.subList(0, i));
    List<Point> reversed = new ArrayList<> (val);
    Collections.reverse(reversed);
    
    if (listList.contains(val) || listList.contains(reversed))
      return true;
  }
  return false;
}
