package e2;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;

public class ApartamentosList {

    ArrayList<Apartamento> apartamentosList = new ArrayList<>();
    private Comparator<Apartamento> criterio = null;

    public void add(Apartamento a){
        apartamentosList.add(a);
    }
    public void clear(){
        criterio = null;
        apartamentosList.clear();
    }

    public void sort() {
        if (criterio == null) {
            Collections.sort(apartamentosList);
        }
        if (criterio != null){
            Collections.sort(apartamentosList, criterio);
        }
    }

    public void set(String metodo){
        switch (metodo) {
            case "PrecioBase" -> criterio = new PrecioBase();
            case "CompPlanta" -> criterio = new CompPlanta();
            case "CompTotal" -> criterio = new CompTotal();
            case "CompNref" -> criterio = new CompNref();
            case "CompMetros" -> criterio = new CompMetros();
            case "CompHab" -> criterio = new CompHab();
            default -> throw new IllegalArgumentException("No es posible comparar con el metodo indicado");
        }
    }
}