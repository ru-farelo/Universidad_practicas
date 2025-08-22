package e1;

import org.junit.Test;

import java.util.ArrayList;
import static org.junit.jupiter.api.Assertions.*;

public class ColegioTest {

    ArrayList<Integrantes> integrantesList = new ArrayList<>();
    ArrayList<Residentes> residentesList = new ArrayList<>();

    //ITERACION 1
        //PERSONAJES 1
        Estudiantes Estudiante1 = new Estudiantes("Hermione", "Granger", 20, 90f, 3, Residentes.Casas.Gryffindor);
        Fantasmas Fantasma1 = new Fantasmas("Barón", "Sanguinario", 1000, 80f, 1, Residentes.Casas.Slytherin);
        Guardabosques Guardabosques1 = new Guardabosques("Rubeus", "Hagrid", 55, 75f, 2, 170);
        Docentes Docente1 = new Docentes("Minerva", "McGonagall", 70, 50f, 1, 400, Docentes.Asignaturas.Transformaciones);
        Docentes Docente2 = new Docentes("Severus", "Snape", 45, 50f, 2, 500, Docentes.Asignaturas.Defensa);
        Conserjes Conserje1 = new Conserjes("Argus", "Filch", 75, 65f, 0, 150);

        //COLEGIO 1
        Colegio c = new Colegio(integrantesList,residentesList);

    //ITERACION 2
        //PERSONAJES 2
        Estudiantes Estudiante2 = new Estudiantes("Hermione", "Granger", 20, 90f, 3, Residentes.Casas.Slytherin);
        Fantasmas Fantasma2 = new Fantasmas("Barón", "Sanguinario", 1000, 80f, 1, Residentes.Casas.Ravenclaw);
        Fantasmas Fantasma3 = new Fantasmas("Barón", "Huesudo", 1000, 80f, 1, Residentes.Casas.Hufflepuff);
        Docentes Docente3 = new Docentes("Minerva", "McGonagall", 70, 50f, 1, 350, Docentes.Asignaturas.Pociones);
        Docentes Docente4 = new Docentes("Severus", "Snape", 45, 50f, 2, 200, Docentes.Asignaturas.Historia);
        Docentes Docente5 = new Docentes("Pomona", "Sprout", 45, 50f, 2, 250, Docentes.Asignaturas.Herbologia);

        //COLEGIO 2
        Colegio k = new Colegio(integrantesList, residentesList);

    //ITERACION 3 -> COMPROBAR ILLEGALIDADES

    @Test
    public void iteracion1(){

        //ITERACION 1
        integrantesList.add(Estudiante1);
        residentesList.add(Estudiante1);
        integrantesList.add(Fantasma1);
        residentesList.add(Fantasma1);
        integrantesList.add(Guardabosques1);
        integrantesList.add(Docente1);
        integrantesList.add(Docente2);
        integrantesList.add(Conserje1);

        //RECOMPENSA DEL COLEGIO
        assertEquals("""
                Hermione Granger(Estudiante de Gryffindor ,3 horrocruxes ): 270.0 galeones
                Barón Sanguinario(Fantasma de Slytherin ,1 horrocruxes ): 160.0 galeones
                Rubeus Hagrid(Guardabosques ,2 horrocruxes ): 150.0 galeones
                Minerva McGonagall(Docente de Transformaciones ,1 horrocruxes ): 50.0 galeones
                Severus Snape(Docente de Defensa ,2 horrocruxes ): 75.0 galeones
                Argus Filch(Conserje ,0 horrocruxes ): 0.0 galeones
                La recompensa total del Colegio Hogwarts es de 705.0 galeones""", c.imprimirRecompensa());

        //SALARIOS DEL COLEGIO
        assertEquals("""
                Rubeus Hagrid(Guardabosques ): 180 galeones
                Minerva McGonagall(Docente de Transformaciones ): 400 galeones
                Severus Snape(Docente de Defensa ): 500 galeones
                Argus Filch(Conserje ): 160 galeones
                El gasto de Hogwarts en personal es de 1240 galeones""", c.imprimirSalarios());
    }

    @Test
    public void iteracion2(){

        integrantesList.clear();
        residentesList.clear();

        integrantesList.add(Estudiante2);
        residentesList.add(Estudiante2);
        integrantesList.add(Fantasma2);
        residentesList.add((Fantasma2));
        integrantesList.add(Fantasma3);
        residentesList.add(Fantasma3);
        integrantesList.add(Docente3);
        integrantesList.add(Docente4);
        integrantesList.add(Docente5);

        //RECOMPENSA DEL COLEGIO
        assertEquals("""
                Hermione Granger(Estudiante de Slytherin ,3 horrocruxes ): 540.0 galeones
                Barón Sanguinario(Fantasma de Ravenclaw ,1 horrocruxes ): 80.0 galeones
                Barón Huesudo(Fantasma de Hufflepuff ,1 horrocruxes ): 80.0 galeones
                Minerva McGonagall(Docente de Pociones ,1 horrocruxes ): 50.0 galeones
                Severus Snape(Docente de Historia ,2 horrocruxes ): 100.0 galeones
                Pomona Sprout(Docente de Herbologia ,2 horrocruxes ): 100.0 galeones
                La recompensa total del Colegio Hogwarts es de 950.0 galeones""", k.imprimirRecompensa());

        //SALARIO DEL COLEGIO
        assertEquals("""
                Minerva McGonagall(Docente de Pociones ): 350 galeones
                Severus Snape(Docente de Historia ): 200 galeones
                Pomona Sprout(Docente de Herbologia ): 250 galeones
                El gasto de Hogwarts en personal es de 800 galeones""", k.imprimirSalarios());
    }

    @Test
    public void iteracion3(){

        integrantesList.clear();
        residentesList.clear();

        Colegio q = new Colegio(integrantesList, residentesList);

        //RECOMPENSA DEL COLEGIO
        assertThrows(IllegalArgumentException.class, () -> new Estudiantes("Hermione", "Granger", 20, 90f, -1, Residentes.Casas.Gryffindor));
        assertThrows(IllegalArgumentException.class, () -> new Fantasmas("Barón", "Sanguinario", 1000, 80f, -2, Residentes.Casas.Slytherin));
        assertThrows(IllegalArgumentException.class, () -> new Docentes("Minerva", "McGonagall", 70, 50f, -3, 400, Docentes.Asignaturas.Transformaciones));
        assertThrows(IllegalArgumentException.class, () -> new Guardabosques("Rubeus", "Hagrid", 55, 75f, -2, 170));
        assertThrows(IllegalArgumentException.class, () -> new Conserjes("Argus", "Filch", 75, 65f, -1, 150));

        //SALARIO DEL COLEGIO
        assertEquals("El gasto de Hogwarts en personal es de 0 galeones", q.imprimirSalarios());
    }
}