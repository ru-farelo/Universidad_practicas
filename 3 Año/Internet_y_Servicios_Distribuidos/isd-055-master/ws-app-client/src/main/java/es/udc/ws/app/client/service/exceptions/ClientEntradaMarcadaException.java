package es.udc.ws.app.client.service.exceptions;

public class ClientEntradaMarcadaException extends Exception {

    private Boolean Marcada;

    public ClientEntradaMarcadaException(Boolean Marcada) {
        super("La entrada ya esta Marcada=\"" + Marcada + "\n ");
        this.Marcada = Marcada;
    }

    public Boolean getMarcada() {
        return Marcada;
    }

    public void setMarcada(Boolean Marcada) {
        this.Marcada = Marcada;
    }
}
