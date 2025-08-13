package es.udc.ws.app.client.service.exceptions;

public class ClientIncorrectTarjetaCreditoException extends Exception{
    private String tarjetaCredito;
    private Long partidoId;

    public ClientIncorrectTarjetaCreditoException(String tarjetaCredito, Long partidoId) {
        super("Tarjeta de credito: " + tarjetaCredito + " partidoID: " + partidoId);
        this.tarjetaCredito = tarjetaCredito;
        this.partidoId = partidoId;
    }


    public String getTarjetaCredito() {
        return tarjetaCredito;
    }

    public Long getPartidoId() {
        return partidoId;
    }
}
