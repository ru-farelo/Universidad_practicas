package e2;


public class Grafo {

    private Algoritmo algoritmo = null;

    Grafo(){}

    public Algoritmo getAlgoritmo() {
        return algoritmo;
    }

    public void setAlgoritmo(String algoritmo){
        switch (algoritmo){
            case "Dependencia Fuerte" -> this.algoritmo = new DependenciaFuerte();
            case "Dependencia Debil" -> this.algoritmo = new DependenciaDebil();
            case "Orden Jerarquico" -> this.algoritmo = new OrdenJerarquico();
            default -> throw new IllegalArgumentException("No se indico un algoritmo valido");
        }
    }
}
