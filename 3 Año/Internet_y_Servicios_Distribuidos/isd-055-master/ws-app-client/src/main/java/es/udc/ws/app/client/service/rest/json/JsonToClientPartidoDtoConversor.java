package es.udc.ws.app.client.service.rest.json;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.JsonNodeType;
import com.fasterxml.jackson.databind.node.ObjectNode;
import es.udc.ws.app.client.service.dto.ClientPartidoDto;
import es.udc.ws.util.json.ObjectMapperFactory;
import es.udc.ws.util.json.exceptions.ParsingException;

import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class JsonToClientPartidoDtoConversor {

    public static ObjectNode toObjectNode(ClientPartidoDto partido) throws IOException {

        ObjectNode partidoObject = JsonNodeFactory.instance.objectNode();

        if (partido.getPartidoId() != null) {
            partidoObject.put("partidoId", partido.getPartidoId());
        }
        partidoObject.put("Equipo_Visitante", partido.getEquipo_Visitante()).
                put("Fecha_Del_partido", partido.getFecha_Del_partido().toString()).
                put("Precio_Partido", partido.getPrecio_Partido()).
                put("Unidades_Disponibles", partido.getUnidades_disponibles());
               // put("Entradas_vendidas_del_partido", partido.getEntradas_vendidas_del_partido());

        return partidoObject;
    }

    public static ClientPartidoDto toClientPartidoDto(InputStream jsonPartido) throws ParsingException {
        try {

            ObjectMapper objectMapper = ObjectMapperFactory.instance();
            JsonNode rootNode = objectMapper.readTree(jsonPartido);
            if (rootNode.getNodeType() != JsonNodeType.OBJECT) {
                throw new ParsingException("Unrecognized JSON (object expected)");
            } else {
                return toClientPartidoDto(rootNode);
            }
        } catch (ParsingException ex) {
            throw ex;
        } catch (Exception e) {
            throw new ParsingException(e);
        }
    }

    public static List<ClientPartidoDto> toClientPartidoDtos(InputStream jsonPartidos) throws ParsingException {
        try {

            ObjectMapper objectMapper = ObjectMapperFactory.instance();
            JsonNode rootNode = objectMapper.readTree(jsonPartidos);
            if (rootNode.getNodeType() != JsonNodeType.ARRAY) {
                throw new ParsingException("Unrecognized JSON (array expected)");
            } else {
                ArrayNode partidosArray = (ArrayNode) rootNode;
                List<ClientPartidoDto> partidoDtos = new ArrayList<>(partidosArray.size());
                for (JsonNode partidoNode : partidosArray) {
                    partidoDtos.add(toClientPartidoDto(partidoNode));
                }

                return partidoDtos;
            }
        } catch (ParsingException ex) {
            throw ex;
        } catch (Exception e) {
            throw new ParsingException(e);
        }
    }

    private static ClientPartidoDto toClientPartidoDto(JsonNode partidoNode) throws ParsingException {
        if (partidoNode.getNodeType() != JsonNodeType.OBJECT) {
            throw new ParsingException("Unrecognized JSON (object expected)");
        } else {
            ObjectNode partidoObject = (ObjectNode) partidoNode;

            JsonNode partidoIdNode = partidoObject.get("partidoId");
            Long partidoId = (partidoIdNode != null) ? partidoIdNode.longValue() : null;

            String Equipo_Visitante = partidoObject.get("Equipo_Visitante").textValue().trim();
            LocalDateTime Fecha_Del_partido = LocalDateTime.parse(partidoObject.get("Fecha_Del_partido").textValue().trim());
            float Precio_Partido = partidoObject.get("Precio_Partido").floatValue();
            int Unidades_disponibles = partidoObject.get("Unidades_Disponibles").intValue();
           // int Entradas_vendidas_del_partido = partidoObject.get("Entradas_vendidas_del_partido").intValue();

            return new ClientPartidoDto(partidoId, Equipo_Visitante, Fecha_Del_partido, Precio_Partido, Unidades_disponibles);
        }

    }
}
