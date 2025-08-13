package es.udc.ws.app.restservice.json;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.JsonNodeType;
import com.fasterxml.jackson.databind.node.ObjectNode;
import es.udc.ws.app.restservice.dto.RestPartidoDto;
import es.udc.ws.util.json.ObjectMapperFactory;
import es.udc.ws.util.json.exceptions.ParsingException;

import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.List;

public class JsonToRestPartidoDtoConversor {

    public static ObjectNode toObjectNode(RestPartidoDto partido) {

            ObjectNode partidoObject = JsonNodeFactory.instance.objectNode();

            partidoObject.put("partidoId", partido.getPartidoId()).
                    put("Equipo_Visitante", partido.getEquipo_Visitante()).
                    put("Fecha_Del_partido", partido.getFecha_Del_partido().toString()).
                    put("Precio_Partido", partido.getPrecio_Partido()).
                    put("Unidades_Disponibles", partido.getUnidades_disponibles()).
                    put("Entradas_Vendidas_del_Partido", partido.getEntradas_vendidas_del_partido());

            return partidoObject;
    }

    public static ArrayNode toArrayNode(List<RestPartidoDto> partidos) {

        ArrayNode partidosNode = JsonNodeFactory.instance.arrayNode();

        for (int i = 0; i < partidos.size(); i++) {
            RestPartidoDto partidoDto = partidos.get(i);
            ObjectNode partidoObject = toObjectNode(partidoDto);
            partidosNode.add(partidoObject);
        }

        return partidosNode;
    }

    public static RestPartidoDto toRestPartidoDto (InputStream jsonPartido) throws ParsingException {
        try {
            ObjectMapper objectMapper = ObjectMapperFactory.instance();
            JsonNode rootNode = objectMapper.readTree(jsonPartido);

            if (rootNode.getNodeType() != JsonNodeType.OBJECT) {
                throw new ParsingException("Unrecognized JSON (object expected)");
            } else {
                ObjectNode partidoObject = (ObjectNode) rootNode;

                JsonNode partidoIdNode = partidoObject.get("partidoId");
                Long partidoId = (partidoIdNode != null) ? partidoIdNode.longValue() : null;

                String equipo_Visitante = partidoObject.get("Equipo_Visitante").textValue().trim();
                //Comprobar que equipo_Visitante no sea por ejemplo espacio en blanco
                if (equipo_Visitante.isEmpty()) {// Falla (visitante inválido)
                    throw new ParsingException("Invalid value for 'Equipo_Visitante' field: '" + equipo_Visitante + "'");
                }
                LocalDateTime Fecha_Del_partido = LocalDateTime.parse(partidoObject.get("Fecha_Del_partido").textValue().trim());
                float Precio_Partido =  partidoObject.get("Precio_Partido").floatValue();
                int Unidades_Disponibles = partidoObject.get("Unidades_Disponibles").intValue();
                //int Entradas_Vendidas_del_Partido = partidoObject.get("Entradas_Vendidas_del_Partido").intValue();

                return new RestPartidoDto(partidoId, equipo_Visitante, Fecha_Del_partido, Precio_Partido, Unidades_Disponibles,0);
            }
        } catch (ParsingException ex) {
            throw ex;
        } catch (Exception e) {
            throw new ParsingException(e);
        }
    }
}
