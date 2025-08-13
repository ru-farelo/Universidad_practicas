package es.udc.ws.app.model.PartidoService.exceptions;

public class IncorrectTarjetaCreditoException extends Exception{
    private String tarjetaCredito;
    private Long partidoId;

    public IncorrectTarjetaCreditoException(String tarjetaCredito, Long partidoId) {
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
