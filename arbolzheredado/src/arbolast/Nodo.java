package arbolast;


import java.util.ArrayList;
import java.util.List;

/**
 *
 * @author herman
 */
public class Nodo {

    public String valor;
    public List<Nodo> hijos;

    public Nodo(String valor) {
        this.valor = valor;
        hijos = new ArrayList<Nodo>();
    }
}
