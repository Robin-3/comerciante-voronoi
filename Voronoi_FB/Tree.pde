class Tree {
  Point nodo;
  ArrayList<Point> ruta_raiz;
  ArrayList<Tree> arbol_hijo;
  
  Tree(Point nodo, ArrayList<Point> ruta_raiz) {
    this.nodo = nodo;
    this.ruta_raiz = ruta_raiz;
    this.arbol_hijo = new ArrayList<Tree>();
    this.calcular_ramas();
  }
  
  void calcular_ramas() {
    ArrayList<Point> r_r = copiarArrayList(this.ruta_raiz);
    r_r.add(this.nodo);
    for(Point vecino : this.nodo.vecinos) {
      if(!(ruta_raiz.contains(vecino) || vecino == nodo)) {
        this.arbol_hijo.add(new Tree(vecino, r_r));
      }
    }
  }
  
  void buscarRutas(int longitud, ArrayList<ArrayList<Point>> rutas_encontradas) {
    if(this.arbol_hijo.size() == 0 && this.ruta_raiz.size() == longitud-1) {
      ArrayList<Point> ruta = copiarArrayList(this.ruta_raiz);
      ruta.add(this.nodo);
      
      ArrayList<Point> ruta_reversa = invertirArrayList(ruta);
      if(!(existeEnLista(rutas_encontradas, ruta) || existeEnLista(rutas_encontradas, ruta_reversa)))
        rutas_encontradas.add(ruta);
      return;
    }
    
    for(Tree hijo : this.arbol_hijo) {
      hijo.buscarRutas(longitud, rutas_encontradas);
    }
  }
  
  void imprimirArbol(int nivel) {
    println("\t".repeat(nivel)+""+this.nodo);
    for(Tree hijo : this.arbol_hijo) {
      hijo.imprimirArbol(nivel+1);
    }
  }
}

ArrayList<Point> copiarArrayList(ArrayList<Point> original) {
  ArrayList<Point> copia = new ArrayList<Point>();
  for(Point o : original) {
    copia.add(o);
  }
  return copia;
}

ArrayList<Point> invertirArrayList(ArrayList<Point> original) {
  ArrayList<Point> copia = new ArrayList<Point>();
  for (int i = original.size()-1; i >= 0 ; i--)
    copia.add(original.get(i));
  return copia;
}

boolean existeEnLista(ArrayList<ArrayList<Point>> array, ArrayList<Point> valor) {
  for(int j = 0; j < valor.size(); j++) {
    ArrayList<Point> val = new ArrayList<Point>();
    for(int i = 0; i < valor.size(); i++)
      val.add(valor.get((i+j)%valor.size()));
    for(ArrayList<Point> a : array) {
      if(igualArrayList(a, val)) return true;
    }
  }
  return false;
}

boolean igualArrayList(ArrayList<Point> a, ArrayList<Point> b) {
  if(a.size() != b.size()) return false;
  for(int i = 0; i < a.size(); i++)
    if(a.get(i) != b.get(i)) return false;
  return true;
}
