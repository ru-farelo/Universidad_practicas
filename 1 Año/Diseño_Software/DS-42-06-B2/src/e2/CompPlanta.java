package e2;

import java.util.Comparator;

public class CompPlanta implements Comparator<Apartamento> {

    @Override
    public int compare(Apartamento p1 , Apartamento p2){
        return Integer.compare(p1.getPlanta(), p2.getPlanta());
    }
}