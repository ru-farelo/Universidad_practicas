package e1;

import java.time.LocalDate;

public class ComprobarBilletes extends InfoBillete{

    public ComprobarBilletes(String origen, String destino, int precio, LocalDate fecha){
        super(origen, destino, precio, fecha);
    }

    @Override
    public String getOrigen() {
        if(origen.equals("")){
            origen = "";
        }
        return origen;
    }

    @Override
    public String getDestino() {
        if(destino.equals("")){
            destino = "";
        }
        return destino;
    }

    @Override
    public int getPrecio() {
        if(precio < 0){
            precio = 0;
        }
        return precio;
    }

    @Override
    public LocalDate getFecha() {
        if(fecha.isBefore(LocalDate.now())){
            fecha = LocalDate.of(2000,1,1);
        }
        return fecha;
    }
}