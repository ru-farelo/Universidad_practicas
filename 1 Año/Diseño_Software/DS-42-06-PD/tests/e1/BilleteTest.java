package e1;

import org.junit.jupiter.api.Test;

import java.time.LocalDate;
import java.util.ArrayList;
import java.util.List;
import java.util.function.Predicate;

import static org.junit.jupiter.api.Assertions.*;

class BilleteTest {

    List<Billete> billeteList = new ArrayList<>();
    boolean existe;

    Billete billete1 = new Billete("Coruña", "Ourense", 15, LocalDate.of(2022,2,14));
    Billete billete2 = new Billete("Santiago", "Ourense", 10, LocalDate.of(2022,1,28));
    Billete billete3 = new Billete("Pontevedra", "Ourense", 20, LocalDate.of(2022,2,2));

    @Test
    void unOrigen(){

        Predicate<Billete> predicate1 = b->b.origen.equals("Coruña");
        billeteList.clear();

        existe = predicate1.test(billete1);
        assertTrue(existe);
        billeteList.add(billete1);

        existe = predicate1.test(billete2);
        assertFalse(existe);

        existe = predicate1.test(billete3);
        assertFalse(existe);

        assertEquals("""
                Informacion del billete 1:
                Ciudad de origen: Coruña
                Ciudad de destino: Ourense
                Precio del viaje: 15
                Fecha del viaje: 2022-02-14""", billete1.info(billeteList));
    }

    @Test
    void variosOrigenes(){

        Predicate<Billete> predicate1 = b->b.origen.equals("Coruña");
        Predicate<Billete> predicate2 = b->b.origen.equals("Santiago");
        Predicate<Billete> predicate3 = predicate1.or(predicate2);
        billeteList.clear();

        existe = predicate3.test(billete1);
        assertTrue(existe);
        billeteList.add(billete1);

        existe = predicate3.test(billete2);
        assertTrue(existe);
        billeteList.add(billete2);

        existe = predicate3.test(billete3);
        assertFalse(existe);

        assertEquals("""
                Informacion del billete 1:
                Ciudad de origen: Coruña
                Ciudad de destino: Ourense
                Precio del viaje: 15
                Fecha del viaje: 2022-02-14
                
                Informacion del billete 2:
                Ciudad de origen: Santiago
                Ciudad de destino: Ourense
                Precio del viaje: 10
                Fecha del viaje: 2022-01-28""", billete1.info(billeteList));
    }

    @Test
    void origenMal(){

        Predicate<Billete> predicate1 = b->b.origen.equals("Ribeira");
        Predicate<Billete> predicate2 = b->b.origen.equals("Muros");
        Predicate<Billete> predicate3 = predicate1.or(predicate2);
        billeteList.clear();

        existe = predicate3.test(billete1);
        assertFalse(existe);

        existe = predicate3.test(billete2);
        assertFalse(existe);

        existe = predicate3.test(billete3);
        assertFalse(existe);

        assertEquals("No existen billetes en la Base de Datos", billete1.info(billeteList));
    }

    @Test
    void sinOrigen(){
        Billete billete = new Billete("", "Vigo", 5, LocalDate.of(2022,3,15));
        billeteList.clear();

        Predicate<Billete> predicate1 = b->b.destino.equals("Vigo");

        existe = predicate1.test(billete);
        assertTrue(existe);
        billeteList.add(billete);

        assertThrows(IllegalArgumentException.class, () -> billete.info(billeteList));
    }

    @Test
    void destinoBien(){

        Predicate<Billete> predicate1 = b->b.destino.equals("Ourense");
        billeteList.clear();

        existe = predicate1.test(billete1);
        assertTrue(existe);
        billeteList.add(billete1);

        existe = predicate1.test(billete2);
        assertTrue(existe);
        billeteList.add(billete2);

        existe = predicate1.test(billete3);
        assertTrue(existe);
        billeteList.add(billete3);

        assertEquals("""
                Informacion del billete 1:
                Ciudad de origen: Coruña
                Ciudad de destino: Ourense
                Precio del viaje: 15
                Fecha del viaje: 2022-02-14
                
                Informacion del billete 2:
                Ciudad de origen: Santiago
                Ciudad de destino: Ourense
                Precio del viaje: 10
                Fecha del viaje: 2022-01-28
                
                Informacion del billete 3:
                Ciudad de origen: Pontevedra
                Ciudad de destino: Ourense
                Precio del viaje: 20
                Fecha del viaje: 2022-02-02""", billete1.info(billeteList));
    }

    @Test
    void destinoMal(){

        Predicate<Billete> predicate1 = b->b.destino.equals("Lugo");
        billeteList.clear();

        existe = predicate1.test(billete1);
        assertFalse(existe);

        existe = predicate1.test(billete2);
        assertFalse(existe);

        existe = predicate1.test(billete3);
        assertFalse(existe);

        assertEquals("No existen billetes en la Base de Datos", billete1.info(billeteList));
    }

    @Test
    void sinDestino(){

        Billete billete = new Billete("Vigo", "", 5, LocalDate.of(2022,3,15));
        billeteList.clear();

        Predicate<Billete> predicate1 = b->b.origen.equals("Vigo");
        Predicate<Billete> predicate2 = b->b.origen.equals("Santiago");
        Predicate<Billete> predicate3 = predicate1.or(predicate2);

        existe = predicate3.test(billete);
        assertTrue(existe);
        billeteList.add(billete);

        assertThrows(IllegalArgumentException.class, () -> billete.info(billeteList));
    }

    @Test
    void precioBien(){

        Predicate<Billete> predicate1 = b->b.precio<=15;
        billeteList.clear();

        existe = predicate1.test(billete1);
        assertTrue(existe);
        billeteList.add(billete1);

        existe = predicate1.test(billete2);
        assertTrue(existe);
        billeteList.add(billete2);

        existe = predicate1.test(billete3);
        assertFalse(existe);

        assertEquals("""
                Informacion del billete 1:
                Ciudad de origen: Coruña
                Ciudad de destino: Ourense
                Precio del viaje: 15
                Fecha del viaje: 2022-02-14
                
                Informacion del billete 2:
                Ciudad de origen: Santiago
                Ciudad de destino: Ourense
                Precio del viaje: 10
                Fecha del viaje: 2022-01-28""", billete1.info(billeteList));
    }

    @Test
    void precioMal(){

        Predicate<Billete> predicate1 = b->b.precio>=25;
        billeteList.clear();

        existe = predicate1.test(billete1);
        assertFalse(existe);

        existe = predicate1.test(billete2);
        assertFalse(existe);

        existe = predicate1.test(billete3);
        assertFalse(existe);

        assertEquals("No existen billetes en la Base de Datos", billete1.info(billeteList));
    }

    @Test
    void precioImposible(){

        Billete billete = new Billete("Vigo", "Pontevedra", -2, LocalDate.of(2022,5,3));
        billeteList.clear();

        Predicate<Billete> predicate1 = b->b.origen.equals("Vigo");
        Predicate<Billete> predicate2 = b->b.destino.equals("Pontevedra");
        Predicate<Billete> predicate3 = predicate1.and(predicate2);

        existe = predicate3.test(billete);
        assertTrue(existe);
        billeteList.add(billete);

        assertThrows(IllegalArgumentException.class, () -> billete.info(billeteList));
    }

    @Test
    void unaFecha(){

        Predicate<Billete> predicate1 = b->b.fecha.equals(LocalDate.of(2022,1,28));
        billeteList.clear();

        existe = predicate1.test(billete1);
        assertFalse(existe);

        existe = predicate1.test(billete2);
        assertTrue(existe);
        billeteList.add(billete2);

        existe = predicate1.test(billete3);
        assertFalse(existe);

        assertEquals("""
                Informacion del billete 1:
                Ciudad de origen: Santiago
                Ciudad de destino: Ourense
                Precio del viaje: 10
                Fecha del viaje: 2022-01-28""", billete2.info(billeteList));
    }

    @Test
    void variasFechas(){

        Predicate<Billete> predicate1 = b->b.fecha.equals(LocalDate.of(2022,1,28));
        Predicate<Billete> predicate2 = b->b.fecha.equals(LocalDate.of(2022,2,14));
        Predicate<Billete> predicate3 = predicate1.or(predicate2);
        billeteList.clear();

        existe = predicate3.test(billete1);
        assertTrue(existe);
        billeteList.add(billete1);

        existe = predicate3.test(billete2);
        assertTrue(existe);
        billeteList.add(billete2);

        existe = predicate3.test(billete3);
        assertFalse(existe);

        assertEquals("""
                Informacion del billete 1:
                Ciudad de origen: Coruña
                Ciudad de destino: Ourense
                Precio del viaje: 15
                Fecha del viaje: 2022-02-14
                
                Informacion del billete 2:
                Ciudad de origen: Santiago
                Ciudad de destino: Ourense
                Precio del viaje: 10
                Fecha del viaje: 2022-01-28""", billete1.info(billeteList));
    }

    @Test
    void fechaMal(){
        Predicate<Billete> predicate1 = b->b.fecha.equals(LocalDate.of(2021, 5, 8));
        billeteList.clear();

        existe = predicate1.test(billete1);
        assertFalse(existe);

        existe = predicate1.test(billete2);
        assertFalse(existe);

        existe = predicate1.test(billete3);
        assertFalse(existe);

        assertEquals("No existen billetes en la Base de Datos", billete1.info(billeteList));
    }

    @Test
    void fechaImposible(){

        Billete billete = new Billete("Coruña", "Pontevedra", 15, LocalDate.of(2021, 10, 12));
        billeteList.clear();

        Predicate<Billete> predicate1 = b->b.origen.equals("Coruña");
        Predicate<Billete> predicate2 = b->b.destino.equals("Pontevedra");
        Predicate<Billete> predicate3 = predicate1.and(predicate2);
        Predicate<Billete> predicate4 = b->b.precio<=17;
        Predicate<Billete> predicate5 = predicate3.and(predicate4);

        existe = predicate5.test(billete);
        assertTrue(existe);
        billeteList.add(billete);

        assertThrows(IllegalArgumentException.class, () -> billete.info(billeteList));
    }

    @Test
    void malFormulacion(){

        Predicate<Billete> predicate1 = b->b.origen.equals("Coruña");
        Predicate<Billete> predicate2 = b->b.origen.equals("Santiago");
        Predicate<Billete> predicate3 = predicate1.and(predicate2);
        billeteList.clear();

        existe = predicate3.test(billete1);
        assertFalse(existe);

        existe = predicate3.test(billete2);
        assertFalse(existe);

        existe = predicate3.test(billete3);
        assertFalse(existe);

    }

    @Test
    void comprobacionCompleta(){

        Predicate<Billete> predicate1 = b->b.origen.equals("Coruña");
        Predicate<Billete> predicate2 = b->b.origen.equals("Santiago");
        Predicate<Billete> predicate3 = predicate1.or(predicate2);
        billeteList.clear();

        Predicate<Billete> predicate4 = b->b.destino.equals("Ourense");
        Predicate<Billete> predicate5 = predicate3.and(predicate4);

        Predicate<Billete> predicate6 = b->b.precio<=15;
        Predicate<Billete> predicate7 = predicate5.and(predicate6);

        Predicate<Billete> predicate8 = b->b.fecha.equals(LocalDate.of(2022,2,14));
        Predicate<Billete> predicate9 = b->b.fecha.equals(LocalDate.of(2022,1,28));
        Predicate<Billete> predicate10 = predicate8.or(predicate9);
        Predicate<Billete> predicate11 = predicate7.and(predicate10);

        existe = predicate11.test(billete1);
        assertTrue(existe);
        billeteList.add(billete1);

        existe = predicate11.test(billete2);
        assertTrue(existe);
        billeteList.add(billete2);

        existe = predicate11.test(billete3);
        assertFalse(existe);

        assertEquals("""
                Informacion del billete 1:
                Ciudad de origen: Coruña
                Ciudad de destino: Ourense
                Precio del viaje: 15
                Fecha del viaje: 2022-02-14
                
                Informacion del billete 2:
                Ciudad de origen: Santiago
                Ciudad de destino: Ourense
                Precio del viaje: 10
                Fecha del viaje: 2022-01-28""", billete1.info(billeteList));
    }
}