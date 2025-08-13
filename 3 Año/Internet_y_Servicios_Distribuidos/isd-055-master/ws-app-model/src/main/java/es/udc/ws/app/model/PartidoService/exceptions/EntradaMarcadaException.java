package es.udc.ws.app.model.PartidoService.exceptions;

public class EntradaMarcadaException extends Exception {

    public EntradaMarcadaException() {
        super("La entrada ya esta Marcada\n");
    }
}
