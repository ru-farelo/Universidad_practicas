package es.udc.ws.app.model.PartidoService.exceptions;


public class  EntradaNotAvaliableException extends Exception {

    private Long EntradaId;

    public EntradaNotAvaliableException(Long EntradaId) {
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
