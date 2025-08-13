package es.udc.ws.app.model.PartidoService.exceptions;

public class NotEnoughUnidadesException extends Exception{
    private long unidadesDisponibles;
    private long unidadesAComprar;

    public NotEnoughUnidadesException(long unidadesDisponibles, long unidadesAComprar) {
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
