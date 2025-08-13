package es.udc.ws.app.client.service.exceptions;

public class ClientEntradaNotAvaliableException extends Exception{
    private Long EntradaId;

    public ClientEntradaNotAvaliableException(Long EntradaId) {
        super("La entrada con id=\"" + EntradaId + "\" no esta disponible\n ");
        this.EntradaId = EntradaId;
    }

    public Long getEntradaId() {
        return EntradaId;
    }

    public void setEntradaId(Long EntradaId) {
        this.EntradaId = EntradaId;
    }

}
