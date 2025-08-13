package e1;

public class Integrantes {

    public String nombre;
    public final String apellido;
    public final int edad;
    public Float recompensa;
    public int horrocruxes;

    public Integrantes(String nombre, String apellido, int edad, Float recompensa, int horrocruxes){
        this.nombre = nombre;
        this.apellido = apellido;
        this.edad = edad;
        this.recompensa =  recompensa;
        this.horrocruxes = horrocruxes;

        if(horrocruxes < 0){
            throw new IllegalArgumentException();
        }
    }
}