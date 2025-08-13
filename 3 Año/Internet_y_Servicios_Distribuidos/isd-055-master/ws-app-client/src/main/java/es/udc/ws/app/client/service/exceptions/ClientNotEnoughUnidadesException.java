package es.udc.ws.app.client.service.exceptions;

public class ClientNotEnoughUnidadesException extends Exception{
    private long unidadesDisponibles;
    private long unidadesAComprar;

    public ClientNotEnoughUnidadesException(long unidadesDisponibles, long unidadesAComprar) {
        super("Unidades disponibles: " + unidadesDisponibles + " Unidades a comprar: " + unidadesAComprar);
        this.unidadesDisponibles = unidadesDisponibles;
        this.unidadesAComprar = unidadesAComprar;
    }

    public long getUnidadesDisponibles() {
        return unidadesDisponibles;
    }

    public long getUnidadesAComprar() {
        return unidadesAComprar;
    }
}
