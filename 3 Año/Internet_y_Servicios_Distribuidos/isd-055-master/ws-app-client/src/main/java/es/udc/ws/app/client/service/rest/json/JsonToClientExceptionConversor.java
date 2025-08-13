package es.udc.ws.app.client.service.rest.json;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.JsonNodeType;
import es.udc.ws.app.client.service.exceptions.ClientEntradaMarcadaException;
import es.udc.ws.app.client.service.exceptions.ClientEntradaNotAvaliableException;
import es.udc.ws.app.client.service.exceptions.ClientIncorrectTarjetaCreditoException;
import es.udc.ws.app.client.service.exceptions.ClientNotEnoughUnidadesException;
import es.udc.ws.util.exceptions.InputValidationException;
import es.udc.ws.util.exceptions.InstanceNotFoundException;
import es.udc.ws.util.json.ObjectMapperFactory;
import es.udc.ws.util.json.exceptions.ParsingException;

import java.io.InputStream;

public class JsonToClientExceptionConversor {
//Aqui-fallo
    public static Exception fromBadRequestErrorCode(InputStream ex) throws ParsingException {
        try {
            ObjectMapper objectMapper = ObjectMapperFactory.instance();
            JsonNode rootNode = objectMapper.readTree(ex);
            if (rootNode.getNodeType() != JsonNodeType.OBJECT) {
                throw new ParsingException("Unrecognized JSON (object expected)");
            } else {
                String errorType = rootNode.get("errorType").textValue();
                if (errorType.equals("InputValidation")) {
                    return toInputValidationException(rootNode);
                } else {
                    throw new ParsingException("Unrecognized error type: " + errorType);
                }
            }
        } catch (ParsingException e) {
            throw e;
        } catch (Exception e) {
            throw new ParsingException(e);
        }
    }


    private static InputValidationException toInputValidationException(JsonNode rootNode) {
        String message = rootNode.get("message").textValue();
        return new InputValidationException(message);
    }

    public static Exception fromNotFoundErrorCode(InputStream ex) throws ParsingException {
        try {
            ObjectMapper objectMapper = ObjectMapperFactory.instance();
            JsonNode rootNode = objectMapper.readTree(ex);
            if (rootNode.getNodeType() != JsonNodeType.OBJECT) {
                throw new ParsingException("Unrecognized JSON (object expected)");
            } else {
                String errorType = rootNode.get("errorType").textValue();
                if (errorType.equals("InstanceNotFound")) {
                    return toInstanceNotFoundException(rootNode);
                } else {
                    throw new ParsingException("Unrecognized error type: " + errorType);
                }
            }
        } catch (ParsingException e) {
            throw e;
        } catch (Exception e) {
            throw new ParsingException(e);
        }
    }

    private static InstanceNotFoundException toInstanceNotFoundException(JsonNode rootNode) {
        String instanceId = rootNode.get("instanceId").textValue();
        String instanceType = rootNode.get("instanceType").textValue();
        return new InstanceNotFoundException(instanceId, instanceType);
    }

    private static ClientEntradaMarcadaException toEntradaMarcadaException(JsonNode rootNode) {
        //Le paso un booleano al marcar entrada
        Boolean entradaMarcada = rootNode.get("EntradaMarcada").booleanValue();
        return new ClientEntradaMarcadaException(entradaMarcada);
    }

    private static ClientIncorrectTarjetaCreditoException toIncorrectTarjetaCreditoException(JsonNode rootNode) {
        String tarjetaCredito4digitos = rootNode.get("tarjetaCredito").textValue();
        Long partidoId = rootNode.get("partidoId").longValue();
        return new ClientIncorrectTarjetaCreditoException(tarjetaCredito4digitos, partidoId);
    }

    private static ClientNotEnoughUnidadesException toNotEnoughUnidadesException(JsonNode rootNode) {
        int unidadesAComprar = rootNode.get("unidadesAComprar").intValue();
        int unidadesDisponibles = rootNode.get("unidadesDisponibles").intValue();
        return new ClientNotEnoughUnidadesException( unidadesDisponibles, unidadesAComprar );
    }

    public static Exception fromForbiddenErrorCode(InputStream ex) throws ParsingException {
        try {
            ObjectMapper objectMapper = ObjectMapperFactory.instance();
            JsonNode rootNode = objectMapper.readTree(ex);
            if (rootNode.getNodeType() != JsonNodeType.OBJECT) {
                throw new ParsingException("Unrecognized JSON (object expected)");
            } else {
                String errorType = rootNode.get("errorType").textValue();
                if (errorType.equals("EntradaMarcada")) {
                    return toEntradaMarcadaException(rootNode);
                } else if (errorType.equals("IncorrectTarjetaCredito")) {
                    return toIncorrectTarjetaCreditoException(rootNode);
                } else if (errorType.equals("NotEnoughUnidades")) {
                    return toNotEnoughUnidadesException(rootNode);
                } else {
                    throw new ParsingException("Unrecognized error type: " + errorType);
                }
            }
        } catch (ParsingException e) {
            throw e;
        } catch (Exception e) {
            throw new ParsingException(e);
        }
    }



    private static ClientEntradaNotAvaliableException toEntradadaNotAvaliableExpection(JsonNode rootNode) {
        Long idEntrada = rootNode.get("partidoId").longValue();
        return new ClientEntradaNotAvaliableException(idEntrada);
    }

    public static Exception fromGoneErrorCode(InputStream ex) throws ParsingException {
        try {
            ObjectMapper objectMapper = ObjectMapperFactory.instance();
            JsonNode rootNode = objectMapper.readTree(ex);
            if (rootNode.getNodeType() != JsonNodeType.OBJECT) {
                throw new ParsingException("Unrecognized JSON (object expected)");
            } else {
                String errorType = rootNode.get("errorType").textValue();
                if (errorType.equals("EntradaNotAvaliable")) {
                    return toEntradadaNotAvaliableExpection(rootNode);
                } else {
                    throw new ParsingException("Unrecognized error type: " + errorType);
                }
            }
        } catch (ParsingException e) {
            throw e;
        } catch (Exception e) {
            throw new ParsingException(e);
        }
    }

}
