package e2;

import java.util.Comparator;

public class CompHab implements Comparator<Apartamento> {

    @Override
    public int compare(Apartamento h1 , Apartamento h2){
        return Integer.compare(h1.getHab(), h2.getHab());
    }
}