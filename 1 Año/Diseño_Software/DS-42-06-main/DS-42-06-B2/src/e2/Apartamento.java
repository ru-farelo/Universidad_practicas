package e2;

import java.util.Objects;

public class Apartamento implements Comparable<Apartamento>{

    private final int nref;
    private final int pbase;
    private final int plazas;
    private final int pplaza;
    private final int hab;
    private final int tam;
    private final int planta;

    public Apartamento(int nref, int pbase, int plazas, int pplaza, int hab, int tam, int planta) {
        this.nref = nref;
        this.pbase = pbase;
        this.plazas = plazas;
        this.pplaza = pplaza;
        this.hab = hab;
        this.tam = tam;
        this.planta = planta;

        if (nref < 0 || pbase < 0 || plazas < 0 || pplaza < 0 || hab < 0 || tam < 0) {
               throw new IllegalArgumentException();
        }
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Apartamento that = (Apartamento) o;
        return pbase == that.pbase && plazas == that.plazas && pplaza == that.pplaza &&
                hab == that.hab && tam == that.tam && planta == that.planta;
    }

    @Override
    public int hashCode() {
        return Objects.hash(pbase, plazas, pplaza, hab, tam, planta);
    }

    public int getNref() {return nref;}
    public int getPbase() {return pbase;}
    public int getPlazas() {return plazas;}
    public int getPplaza() {return pplaza;}
    public int getHab() {return hab;}
    public int getTam() {return tam;}
    public int getPlanta() {return planta;}

    @Override
    public int compareTo(Apartamento a) {
        if (getNref() - a.nref != 0) {
            if (getNref() - a.nref > 0) {
                return 1;
            }
            else return -1;
        }
        return 0;
    }
}