package e2;

import java.util.ArrayList;
import java.util.Comparator;
import java.util.List;

public class Tarea {

    private final char dato;
    private Tarea sig;
    private Tarea ant;
    private List<Character> padres = new ArrayList<>();

    public Tarea(char dato){
        this.dato = dato;
    }

    public Character getDato(){return dato;}

    public Tarea getSig() {
        return sig;
    }

    public void setSig(Tarea sig) {
        this.sig = sig;
    }

    public Tarea getAnt() {
        return ant;
    }

    public void setAnt(Tarea ant) {
        this.ant = ant;
    }

    public List<Character> getPadres() {
        return padres;
    }

    public void setPadres(List<Character> padres) {
        this.padres = padres;
    }

    public void ordenaList(List<Tarea> tareaList){
        tareaList.sort(Comparator.comparing(Tarea::getDato));
    }
}
