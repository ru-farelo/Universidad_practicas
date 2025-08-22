package e1;

abstract class Personal extends Integrantes{
    int salario;

    public Personal(String nombre, String apellido, int edad, Float recompensa,int horrocruxes, int salario){
        super(nombre, apellido, edad, recompensa,horrocruxes);
        this.salario = salario;
    }
}