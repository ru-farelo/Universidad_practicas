package e2;

import java.util.Comparator;

public class PrecioBase implements Comparator<Apartamento> {

    @Override
    public int compare(Apartamento s1 , Apartamento s2){
        return Integer.compare(s1.getPbase(), s2.getPbase());
    }
}