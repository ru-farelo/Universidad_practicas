package e1;

public class Docentes extends Personal{

    enum Asignaturas{
        Defensa,
        Transformaciones,
        Pociones,
        Herbologia,
        Historia;
    }
    Asignaturas asig;

    public Docentes(String nombre, String apellido, int edad, Float recompensa,int horrocruxes, int salario, Asignaturas asignatura){
        super(nombre, apellido, edad, recompensa,horrocruxes, salario);
        this.asig = asignatura;
    }

    public String getAsignatura(){
        String asignaturaAsoc = null;

        if(asig.equals(Asignaturas.Defensa)){
            asignaturaAsoc = "Defensa";
        }
        else if(asig.equals(Asignaturas.Transformaciones)){
            asignaturaAsoc = "Transformaciones";
        }
        else if(asig.equals(Asignaturas.Pociones)){
            asignaturaAsoc = "Pociones";
        }
        else if(asig.equals(Asignaturas.Historia)){
            asignaturaAsoc = "Historia";
        }
        else if(asig.equals(Asignaturas.Herbologia)){
            asignaturaAsoc = "Herbologia";
        }
        return asignaturaAsoc;
    }
}