package es.udc.ws.app.restservice.json;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;
import es.udc.ws.app.model.PartidoService.exceptions.*;
import es.udc.ws.util.exceptions.InputValidationException;
import es.udc.ws.util.exceptions.InstanceNotFoundException;


public class PartidosExceptionToJsonConversor {


    public static ObjectNode toIncorrectTarjetaCreditoException(IncorrectTarjetaCreditoException ex) {

        ObjectNode exceptionObject = JsonNodeFactory.instance.objectNode();

        exceptionObject.put("errorType", "IncorrectTarjetaCredito");
        exceptionObject.put("tarjetaCredito", ( ex.getTarjetaCredito() != null) ? ex.getTarjetaCredito() : null);
        exceptionObject.put("partidoId", (ex.getPartidoId() != null) ? ex.getPartidoId() : null);

        return exceptionObject;
    }

    public static ObjectNode toNotEnoughUnidadesException(NotEnoughUnidadesException ex) {
        ObjectNode exceptionObject = JsonNodeFactory.instance.objectNode();
        exceptionObject.put("errorType", "NotEnoughUnidades");
        exceptionObject.put("unidadesDisponibles", (ex.getUnidadesDisponibles() != 0) ? ex.getUnidadesDisponibles() : null);
        exceptionObject.put("unidadesAComprar", (ex.getUnidadesAComprar() != 0) ? ex.getUnidadesAComprar() : null);
        return exceptionObject;
    }


    public static ObjectNode toEntradaNotAvaliableException(EntradaNotAvaliableException ex) {
        ObjectNode exceptionObject = JsonNodeFactory.instance.objectNode();
        exceptionObject.put("errorType", "EntradaNotAvaliable");
        exceptionObject.put("partidoId", (ex.getEntradaId() != null) ? ex.getEntradaId() : null);
        return exceptionObject;
    }

    public static ObjectNode toEntradaMarcadaException(EntradaMarcadaException ex) {
        ObjectNode exceptionObject = JsonNodeFactory.instance.objectNode();
        exceptionObject.put("errorType", "EntradaMarcada");
        exceptionObject.put("EntradaMarcada", true);
        return exceptionObject;
    }

//Aqui-fallo

    public static JsonNode toFechaIncorrecta(FechaIncorrecta fechaIncorrecta) {
        ObjectNode exceptionObject = JsonNodeFactory.instance.objectNode();
        exceptionObject.put("errorType", "InputValidation");
        exceptionObject.put("message", "Fecha actual: "+fechaIncorrecta.getFechaactual().toString()+ "  Fecha Incorrecta:" + fechaIncorrecta.getFechaIncorrecta().toString());
        return exceptionObject;
    }
    //Aqui-fallo

    public static JsonNode toInputValidation(InputValidationException input) {
        ObjectNode exceptionObject = JsonNodeFactory.instance.objectNode();
        exceptionObject.put("errorType", "InputValidation");
        exceptionObject.put("message", input.getMessage());
        return exceptionObject;
    }
}
