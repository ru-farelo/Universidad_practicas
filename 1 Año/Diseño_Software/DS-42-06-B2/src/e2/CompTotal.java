package e2;

import java.util.Comparator;

public class CompTotal implements Comparator<Apartamento> {

    @Override
    public int compare(Apartamento t1, Apartamento t2) {
        int suma1 = t1.getPbase() + (t1.getPplaza() * t1.getPlazas());
        int suma2 = t2.getPbase() + (t2.getPplaza() * t2.getPlazas());
        return Integer.compare(suma1, suma2);
    }
}