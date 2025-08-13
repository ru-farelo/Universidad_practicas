package e1;

import java.time.LocalDate;

public abstract class InfoBillete {

    public String origen;
    public String destino;
    public int precio;
    public LocalDate fecha;

    public InfoBillete(String origen, String destino, int precio, LocalDate fecha){
        this.origen = origen;
        this.destino = destino;
        this.precio = precio;
        this.fecha = fecha;
    }

    public abstract String getOrigen();

    public abstract String getDestino();

    public abstract int getPrecio();

    public abstract LocalDate getFecha();
}
