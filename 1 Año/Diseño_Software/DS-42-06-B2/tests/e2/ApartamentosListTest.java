package e2;

import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class ApartamentosListTest {

    PrecioBase comparatorSin = new PrecioBase();
    CompTotal comparatorCon = new CompTotal();
    CompHab comparatorHab = new CompHab();
    CompMetros comparatorMetros = new CompMetros();
    CompPlanta comparatorPlanta = new CompPlanta();
    CompNref compNref = new CompNref();

    Apartamento ap1 = new Apartamento(3023, 600, 1, 50, 2, 77, 3);
    Apartamento ap2 = new Apartamento(4054, 500, 2, 40, 2, 70, 1);
    Apartamento ap3 = new Apartamento(2231, 800, 0, 0, 3, 100, 4);
    Apartamento ap4 = new Apartamento(2351, 400, 1, 60, 1, 80, 2);
    Apartamento ap5 = new Apartamento(1221, 600, 0, 0, 2, 60, 1);
    Apartamento ap6 = new Apartamento(4432, 500, 0, 0, 2, 75, 3);
    Apartamento ap1copia = new Apartamento(3023, 600, 1, 50, 2, 77, 3);

    ApartamentosList apList = new ApartamentosList();

    @Test
    public void testNatural(){
        apList.add(ap1);
        apList.add(ap2);
        apList.add(ap3);
        apList.add(ap4);
        apList.add(ap5);
        apList.add(ap6);
        apList.add(ap1copia);

        apList.sort();

        assertEquals(0, ap1.compareTo(ap1copia) );
        assertEquals(-1,ap1.compareTo(ap2));
        assertEquals(1, ap1.compareTo(ap3) );
        assertEquals(1, ap1.compareTo(ap4) );
        assertEquals(1, ap1.compareTo(ap5) );
        assertEquals(-1, ap1.compareTo(ap6) );

        assertEquals(1,ap2.compareTo(ap3));
        assertEquals(1, ap2.compareTo(ap4) );
        assertEquals(1, ap2.compareTo(ap5) );
        assertEquals(-1, ap2.compareTo(ap6) );

        assertEquals(-1,ap3.compareTo(ap4));
        assertEquals(1, ap3.compareTo(ap5) );
        assertEquals(-1, ap3.compareTo(ap6) );

        assertEquals(1, ap4.compareTo(ap5) );
        assertEquals(-1, ap4.compareTo(ap6) );

        assertEquals(-1,ap5.compareTo(ap6));

        apList.clear();
    }

    @Test
    public void testCompareHab() {
        apList.add(ap1);
        apList.add(ap2);
        apList.add(ap3);
        apList.add(ap4);
        apList.add(ap5);
        apList.add(ap6);
        apList.add(ap1copia);

        apList.set("CompHab");
        apList.sort();

        assertEquals(0, comparatorHab.compare(ap1,ap1copia) );
        assertEquals(0, comparatorHab.compare(ap1,ap2) );
        assertEquals(-1, comparatorHab.compare(ap1,ap3) );
        assertEquals(1, comparatorHab.compare(ap1,ap4) );
        assertEquals(0, comparatorHab.compare(ap1,ap5) );
        assertEquals(0, comparatorHab.compare(ap1,ap6) );

        assertEquals(-1, comparatorHab.compare(ap2,ap3) );
        assertEquals(1, comparatorHab.compare(ap2,ap4) );
        assertEquals(0, comparatorHab.compare(ap2,ap5) );
        assertEquals(0, comparatorHab.compare(ap2,ap6) );

        assertEquals(1, comparatorHab.compare(ap3,ap4) );
        assertEquals(1, comparatorHab.compare(ap3,ap5) );
        assertEquals(1, comparatorHab.compare(ap3,ap6) );


        assertEquals(-1, comparatorHab.compare(ap4,ap5) );
        assertEquals(-1, comparatorHab.compare(ap4,ap6) );

        assertEquals(0, comparatorHab.compare(ap5,ap6) );

        apList.clear();
    }

    @Test
    public void testCompareMetros() {
        apList.add(ap1);
        apList.add(ap2);
        apList.add(ap3);
        apList.add(ap4);
        apList.add(ap5);
        apList.add(ap6);
        apList.add(ap1copia);

        apList.set("CompMetros");
        apList.sort();

        assertEquals(0, comparatorMetros.compare(ap1,ap1copia) );
        assertEquals(1, comparatorMetros.compare(ap1,ap2) );
        assertEquals(-1, comparatorMetros.compare(ap1,ap3) );
        assertEquals(-1, comparatorMetros.compare(ap1,ap4) );
        assertEquals(1, comparatorMetros.compare(ap1,ap5) );
        assertEquals(1, comparatorMetros.compare(ap1,ap6) );

        assertEquals(-1, comparatorMetros.compare(ap2,ap3) );
        assertEquals(-1, comparatorMetros.compare(ap2,ap4) );
        assertEquals(1, comparatorMetros.compare(ap2,ap5) );
        assertEquals(-1, comparatorMetros.compare(ap2,ap6) );

        assertEquals(1, comparatorMetros.compare(ap3,ap4) );
        assertEquals(1, comparatorMetros.compare(ap3,ap5) );
        assertEquals(1, comparatorMetros.compare(ap3,ap6) );

        assertEquals(1, comparatorMetros.compare(ap4,ap5) );
        assertEquals(1, comparatorMetros.compare(ap4,ap6) );

        assertEquals(-1, comparatorMetros.compare(ap5,ap6) );

        apList.clear();
    }

    @Test
    public void testCompareNref() {
        apList.add(ap1);
        apList.add(ap2);
        apList.add(ap3);
        apList.add(ap4);
        apList.add(ap5);
        apList.add(ap6);
        apList.add(ap1copia);

        apList.set("CompNref");
        apList.sort();

        assertEquals(0, compNref.compare(ap1,ap1copia) );
        assertEquals(-1, compNref.compare(ap1,ap2) );
        assertEquals(1, compNref.compare(ap1,ap3) );
        assertEquals(1, compNref.compare(ap1,ap4) );
        assertEquals(1, compNref.compare(ap1,ap5) );
        assertEquals(-1, compNref.compare(ap1,ap6) );

        assertEquals(1, compNref.compare(ap2,ap3) );
        assertEquals(1, compNref.compare(ap2,ap4) );
        assertEquals(1, compNref.compare(ap2,ap5) );
        assertEquals(-1, compNref.compare(ap2,ap6) );

        assertEquals(-1, compNref.compare(ap3,ap4) );
        assertEquals(1, compNref.compare(ap3,ap5) );
        assertEquals(-1, compNref.compare(ap3,ap6) );

        assertEquals(1, compNref.compare(ap4,ap5) );
        assertEquals(-1, compNref.compare(ap4,ap6) );

        assertEquals(-1, compNref.compare(ap5,ap6) );

        apList.clear();
    }

    @Test
    public void testComparePlanta() {
        apList.add(ap1);
        apList.add(ap2);
        apList.add(ap3);
        apList.add(ap4);
        apList.add(ap5);
        apList.add(ap6);
        apList.add(ap1copia);

        apList.set("CompPlanta");
        apList.sort();

        assertEquals(0, comparatorPlanta.compare(ap1,ap1copia) );
        assertEquals(1, comparatorPlanta.compare(ap1,ap2) );
        assertEquals(-1, comparatorPlanta.compare(ap1,ap3) );
        assertEquals(1, comparatorPlanta.compare(ap1,ap4) );
        assertEquals(1, comparatorPlanta.compare(ap1,ap5) );
        assertEquals(0, comparatorPlanta.compare(ap1,ap6) );

        assertEquals(-1, comparatorPlanta.compare(ap2,ap3) );
        assertEquals(-1, comparatorPlanta.compare(ap2,ap4) );
        assertEquals(0, comparatorPlanta.compare(ap2,ap5) );
        assertEquals(-1, comparatorPlanta.compare(ap2,ap6) );

        assertEquals(1, comparatorPlanta.compare(ap3,ap4) );
        assertEquals(1, comparatorPlanta.compare(ap3,ap5) );
        assertEquals(1, comparatorPlanta.compare(ap3,ap6) );

        assertEquals(1, comparatorPlanta.compare(ap4,ap5) );
        assertEquals(-1, comparatorPlanta.compare(ap4,ap6) );

        assertEquals(-1, comparatorPlanta.compare(ap5,ap6) );

        apList.clear();
    }

    @Test
    public void testCompareTotal() {
        apList.add(ap1);
        apList.add(ap2);
        apList.add(ap3);
        apList.add(ap4);
        apList.add(ap5);
        apList.add(ap6);
        apList.add(ap1copia);

        apList.set("CompTotal");
        apList.sort();

        assertEquals(0, comparatorCon.compare(ap1,ap1copia) );
        assertEquals(1, comparatorCon.compare(ap1,ap2) );
        assertEquals(-1, comparatorCon.compare(ap1,ap3) );
        assertEquals(1, comparatorCon.compare(ap1,ap4) );
        assertEquals(1, comparatorCon.compare(ap1,ap5) );
        assertEquals(1, comparatorCon.compare(ap1,ap6) );

        assertEquals(-1, comparatorCon.compare(ap2,ap3) );
        assertEquals(1, comparatorCon.compare(ap2,ap4) );
        assertEquals(-1, comparatorCon.compare(ap2,ap5) );
        assertEquals(1, comparatorCon.compare(ap2,ap6) );

        assertEquals(1, comparatorCon.compare(ap3,ap4) );
        assertEquals(1, comparatorCon.compare(ap3,ap5) );
        assertEquals(1, comparatorCon.compare(ap3,ap6) );

        assertEquals(-1, comparatorCon.compare(ap4,ap5) );
        assertEquals(-1, comparatorCon.compare(ap4,ap6) );

        assertEquals(1, comparatorCon.compare(ap5,ap6) );

        apList.clear();
    }

    @Test
    public void testCompareBase() {
        apList.add(ap1);
        apList.add(ap2);
        apList.add(ap3);
        apList.add(ap4);
        apList.add(ap5);
        apList.add(ap6);
        apList.add(ap1copia);

        apList.set("PrecioBase");
        apList.sort();

        assertEquals(0, comparatorSin.compare(ap1,ap1copia) );
        assertEquals(1, comparatorSin.compare(ap1,ap2) );
        assertEquals(-1, comparatorSin.compare(ap1,ap3) );
        assertEquals(1, comparatorSin.compare(ap1,ap4) );
        assertEquals(0, comparatorSin.compare(ap1,ap5) );
        assertEquals(1, comparatorSin.compare(ap1,ap6) );

        assertEquals(-1, comparatorSin.compare(ap2,ap3) );
        assertEquals(1, comparatorSin.compare(ap2,ap4) );
        assertEquals(-1, comparatorSin.compare(ap2,ap5) );
        assertEquals(0, comparatorSin.compare(ap2,ap6) );

        assertEquals(1, comparatorSin.compare(ap3,ap4) );
        assertEquals(1, comparatorSin.compare(ap3,ap5) );
        assertEquals(1, comparatorSin.compare(ap3,ap6) );

        assertEquals(-1, comparatorSin.compare(ap4,ap5) );
        assertEquals(-1, comparatorSin.compare(ap4,ap6) );

        assertEquals(1, comparatorSin.compare(ap5,ap6) );

        apList.clear();
    }

    @Test
    void testEquals() {
        assertNotEquals(ap1, ap2);
        assertNotEquals(ap1, ap3);
        assertNotEquals(ap1, ap4);
        assertNotEquals(ap1, ap5);
        assertNotEquals(ap1, ap6);
        assertEquals(ap1, ap1copia);

        assertNotEquals(ap1.hashCode(), ap2.hashCode());
        assertNotEquals(ap1.hashCode(), ap3.hashCode());
        assertNotEquals(ap1.hashCode(), ap4.hashCode());
        assertNotEquals(ap1.hashCode(), ap5.hashCode());
        assertNotEquals(ap1.hashCode(), ap6.hashCode());
        assertEquals(ap1.hashCode(), ap1copia.hashCode());
    }

    @Test
    void testExcetions() {

        assertThrows(IllegalArgumentException.class, () -> apList.set("Método Inventado"));
        assertThrows(IllegalArgumentException.class, () -> new Apartamento(-1,500,1,40,3,56,3));
        assertThrows(IllegalArgumentException.class, () -> new Apartamento(1,-500,1,40,3,56,3));
        assertThrows(IllegalArgumentException.class, () -> new Apartamento(1,500,-1,40,3,56,3));
        assertThrows(IllegalArgumentException.class, () -> new Apartamento(1,500,1,-40,3,56,3));
        assertThrows(IllegalArgumentException.class, () -> new Apartamento(1,500,1,40,-3,56,3));
        assertThrows(IllegalArgumentException.class, () -> new Apartamento(1,500,1,40,3,-56,3));
    }
}