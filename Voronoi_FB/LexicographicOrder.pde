// https://youtu.be/goUlyp4rwiU
// https://www.quora.com/How-would-you-explain-an-algorithm-that-generates-permutations-using-lexicographic-ordering
// https://stackoverflow.com/questions/2137755/how-do-i-reverse-an-int-array-in-java

ArrayList<int[]> generarCombinaciones(int longitud, boolean[][] m_a) {
  ArrayList<int[]> combinaciones = new ArrayList<int[]>();
  int[] indices = new int[longitud];
  for(int i = 0; i < longitud; i++)
    indices[i] = i;
  
  while (true) {
    //Paso 1
    int x = -1;
    for(int i = 0; i < longitud-1; i++)
      if(indices[i] < indices[i+1])
        x = i;
    
    
    int[] existe_1 = Arrays.copyOf(indices, indices.length);
    boolean posible = true;
    for(int i = 0; i < existe_1.length-1; i++) {
      if(!m_a[existe_1[i]][existe_1[i+1]]) {
        posible = false;
        break;
      }
    }
    if(posible) {
      int[] existe_2 = Arrays.copyOf(indices, indices.length);
      reverseArray(existe_2);
      if(!(existeEnLista(combinaciones, existe_1) || existeEnLista(combinaciones, existe_2)))
        combinaciones.add(existe_1);
    }
    
    if(x == -1) break;
    
    //Paso 2
    int y = -1;
    for(int i = 0; i < longitud; i++)
      if(indices[x] < indices[i])
        y = i;
    
    //Paso 3
    int t = indices[x];
    indices[x] = indices[y];
    indices[y] = t;
    
    //Paso 4
    int[] r = Arrays.copyOfRange(indices, x+1, indices.length);
    reverseArray(r);
    
    for(int i = 0; i < r.length; i++)
      indices[x+1+i] = r[i];
  }
  
  return combinaciones;
}

void reverseArray(int[] array) {
  int len = array.length;
  for (int i = 0; i < len/2; i++) {
    array[i] = array[i] ^ array[len-i-1];
    array[len-i-1] = array[i] ^ array[len-i-1];
    array[i] = array[i] ^ array[len-i-1];
  }
}

boolean existeEnLista(ArrayList<int[]> array, int[] valor) {
  for(int j = 0; j < valor.length; j++) {
    int[] val = new int[valor.length];
    for(int i = 0; i < valor.length; i++)
      val[i] = valor[(i+j)%valor.length];
    for(int[] a : array)
      if(Arrays.equals(a, val)) return true;
  }
  return false;
}
