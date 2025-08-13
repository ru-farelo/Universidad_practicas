package e2;

import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

class GrafoTest {

    //GRAFO 1
    Grafo g = new Grafo();

    Tarea n1 = new Tarea('C');
    Tarea n2 = new Tarea('G');
    Tarea n3 = new Tarea('A');
    Tarea n4 = new Tarea('F');
    Tarea n5 = new Tarea('H');
    Tarea n6 = new Tarea('B');
    Tarea n7 = new Tarea('D');
    Tarea n8 = new Tarea('E');
    Tarea n9 = new Tarea('J');

    @Test
    public void ordenJerarquico(){

        g.setAlgoritmo("Orden Jerarquico");

        n1.setSig(n3);//C
        n1.setAnt(n4);
        n2.setSig(n4);//G
        n2.setAnt(n5);
        n3.setSig(n6);//A
        n3.setAnt(n7);
        n4.setSig(n8);//F
        n4.setAnt(n9);
        n5.setAnt(n9);//H
        n6.setAnt(n8);//B
        n7.setSig(n8);//D

        assertEquals("C G A F H B D E J ",g.getAlgoritmo().ordenar(n1,n2));
    }

    @Test
    public void dependenciaDebil(){

        g.setAlgoritmo("Dependencia Debil");

        n1.setSig(n3);//C
        n1.setAnt(n4);
        n2.setSig(n4);//G
        n2.setAnt(n5);
        n3.setSig(n6);//A
        n3.setAnt(n7);
        n4.setSig(n8);//F
        n4.setAnt(n9);
        n5.setAnt(n9);//H
        n6.setAnt(n8);//B
        n7.setSig(n8);//D

        assertEquals("C A B D E F G H J ",g.getAlgoritmo().ordenar(n1,n2));
    }

    @Test
    public void dependenciaFuerte(){

        g.setAlgoritmo("Dependencia Fuerte");

        //E
        List<Character> padresE = new ArrayList<>();
        padresE.add(n6.getDato());
        padresE.add(n7.getDato());
        padresE.add(n4.getDato());
        n8.setPadres(padresE);

        //J
        List<Character> padresJ = new ArrayList<>();
        padresJ.add(n4.getDato());
        padresJ.add(n5.getDato());
        n9.setPadres(padresJ);

        //C
        n1.setSig(n3);
        n1.setAnt(n4);

        //G
        n2.setSig(n4);
        n2.setAnt(n5);

        //A
        n3.setSig(n6);
        n3.setAnt(n7);
        List<Character> padresA = new ArrayList<>();
        padresA.add(n1.getDato());
        n3.setPadres(padresA);

        //F
        n4.setSig(n8);
        n4.setAnt(n9);
        List<Character> padresF = new ArrayList<>();
        padresF.add(n1.getDato());
        padresF.add(n2.getDato());
        n4.setPadres(padresF);

        //H
        n5.setAnt(n9);
        List<Character> padresH = new ArrayList<>();
        padresH.add(n2.getDato());
        n5.setPadres(padresH);

        //B
        n6.setAnt(n8);
        List<Character> padresB = new ArrayList<>();
        padresB.add(n3.getDato());
        n6.setPadres(padresB);

        //D
        n7.setSig(n8);
        List<Character> padresD = new ArrayList<>();
        padresD.add(n3.getDato());
        n7.setPadres(padresD);

        assertEquals("C A B D G F E H J ",g.getAlgoritmo().ordenar(n1,n2));
    }

    @Test
    public void inventado(){

        assertThrows(IllegalArgumentException.class, () ->  g.setAlgoritmo("Inventado"));

    }
}