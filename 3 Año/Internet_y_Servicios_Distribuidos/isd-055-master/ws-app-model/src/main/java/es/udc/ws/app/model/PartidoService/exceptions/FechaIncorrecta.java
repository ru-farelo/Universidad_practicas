package es.udc.ws.app.model.PartidoService.exceptions;

import es.udc.ws.util.exceptions.InputValidationException;

import java.time.LocalDateTime;

public class FechaIncorrecta extends InputValidationException {
    LocalDateTime fechaIncorrecta;
    LocalDateTime fechaactual;
    public FechaIncorrecta(LocalDateTime fechaIncorrecta, LocalDateTime fechaActual){
        super("Fecha incorrecta: " + fechaIncorrecta + ", es anterior a " + fechaActual);
        this.fechaIncorrecta = fechaIncorrecta;
        this.fechaactual = fechaActual;
    }

    public LocalDateTime getFechaIncorrecta() {
        return fechaIncorrecta;
    }

    public LocalDateTime getFechaactual() {
        return fechaactual;
    }
}
