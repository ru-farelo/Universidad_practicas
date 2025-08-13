package es.udc.ws.app.restservice.json;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.JsonNodeFactory;
import com.fasterxml.jackson.databind.node.ObjectNode;
import es.udc.ws.app.model.PartidoService.exceptions.IncorrectTarjetaCreditoException;
import es.udc.ws.app.restservice.dto.RestVentasDto;

import java.time.LocalDateTime;
import java.util.List;

public class JsonToRestVentasDtoConversor {
    public static ObjectNode toObjectNode(RestVentasDto comprar) {

        ObjectNode comprarObject = JsonNodeFactory.instance.objectNode();
        comprarObject.put("idEntrada", comprar.getIdEntrada());
        comprarObject.put("Correo", comprar.getCorreoUsuario());
        comprarObject.put("Tarjeta_de_credito", comprar.getTarjetaCredito4digitos());
        comprarObject.put("Unidades_a_comprar", comprar.getUnidadesAComprar());
        comprarObject.put("Fecha_de_compra", comprar.getFecha_de_compra().toString());
        comprarObject.put("partidoID", comprar.getPartidoId());
        comprarObject.put("Entrada_Marcada", comprar.isEntrada_Marcada());

        return comprarObject;
    }

    public static ArrayNode toArrayNode(List<RestVentasDto> comprar) {

        ArrayNode comprarNode = JsonNodeFactory.instance.arrayNode();

        for (int i = 0; i < comprar.size(); i++) {
            ObjectNode comprarObject = toObjectNode(comprar.get(i));
            comprarNode.add(comprarObject);
        }

        return comprarNode;
    }

//public static RestVentasDto toRestComprarEntradaDto(ObjectNode jsonNode) {
//
//        Long entradaID = jsonNode.get("entradaId").longValue();
//        String correoUsuario = jsonNode.get("correoUsuario").textValue().trim();
//        String tarjetaCredito4digitos = jsonNode.get("tarjetaCredito4digitos").textValue().trim();
//        int unidadesAComprar = jsonNode.get("unidadesAComprar").intValue();
//        LocalDateTime Fecha_de_compra = LocalDateTime.parse(jsonNode.get("Fecha_de_compra").textValue().trim());
//        Long partidoId = jsonNode.get("partidoId").longValue();
//        boolean Entrada_Marcada = jsonNode.get("Entrada_Marcada").booleanValue();
//
//
//        return new RestVentasDto(entradaID,correoUsuario, tarjetaCredito4digitos, unidadesAComprar, Fecha_de_compra, partidoId, Entrada_Marcada);
//    }


}//
