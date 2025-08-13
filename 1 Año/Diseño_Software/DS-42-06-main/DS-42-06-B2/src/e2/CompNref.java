package e2;

import java.util.Comparator;

public class CompNref implements Comparator<Apartamento> {

    @Override
    public int compare(Apartamento n1 , Apartamento n2){
        return Integer.compare(n1.getNref(), n2.getNref());
    }
}