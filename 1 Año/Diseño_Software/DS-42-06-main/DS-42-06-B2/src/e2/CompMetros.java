package e2;

import java.util.Comparator;

public class CompMetros implements Comparator<Apartamento> {

    @Override
    public int compare(Apartamento m1 , Apartamento m2){
        return Integer.compare(m1.getTam(), m2.getTam());
    }
}