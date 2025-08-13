package e1;

abstract class Residentes extends Integrantes{

    enum Casas{
        Gryffindor,
        Hufflepuff,
        Ravenclaw,
        Slytherin
    }
    Casas casa;

    public Residentes(String nombre, String apellido, int edad, Float recompensa,int horrocruxes, Casas c){
        super(nombre, apellido, edad, recompensa,horrocruxes);
        this.casa = c;
    }

    public String getCasa(){
        String casaAsoc = null;

        if(casa.equals(Casas.Gryffindor)){
            casaAsoc = "Gryffindor";
        }
        else if(casa.equals(Casas.Hufflepuff)){
            casaAsoc = "Hufflepuff";
        }
        else if(casa.equals(Casas.Ravenclaw)){
            casaAsoc = "Ravenclaw";
        }
        else if(casa.equals(Casas.Slytherin)){
            casaAsoc = "Slytherin";
        }
        return casaAsoc;
    }
}