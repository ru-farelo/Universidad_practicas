package e1;

import java.time.LocalDate;
import java.util.List;

public class Billete extends InfoBillete {

    private final ComprobarBilletes billete;

    public Billete(String origen, String destino, int precio, LocalDate fecha){
        super(origen, destino, precio, fecha);
        billete = new ComprobarBilletes(origen, destino, precio, fecha);
    }

    @Override
    public String getOrigen() {
        return origen;
    }

    @Override
    public String getDestino() {
        return destino;
    }

    @Override
    public int getPrecio() {
        return precio;
    }

    @Override
    public LocalDate getFecha() {
        return fecha;
    }

    public String info(List<Billete> listaBillete){
        StringBuilder aux = new StringBuilder();
        int i;

        if(listaBillete.size() == 0){
            aux.append(" ");//Lista vacia
        }
        else{
            if(!billete.getOrigen().equals("") && !billete.getDestino().equals("") && billete.getPrecio() > 0 && !billete.getFecha().isBefore(LocalDate.now())){
                for(i = 0; i < listaBillete.size(); i++){
                    aux.append("Informacion del billete ").append(i+1).append(":\n");
                    aux.append("Ciudad de origen: ").append(listaBillete.get(i).getOrigen()).append("\n");
                    aux.append("Ciudad de destino: ").append(listaBillete.get(i).getDestino()).append("\n");
                    aux.append("Precio del viaje: ").append(listaBillete.get(i).getPrecio()).append("\n");
                    aux.append("Fecha del viaje: ").append(listaBillete.get(i).getFecha());
                    if(!(i==listaBillete.size()-1)){
                        aux.append("\n\n");
                    }
                }
            }
            else{
                aux.append(" ");
            }
        }
        return aux.toString();
    }
}