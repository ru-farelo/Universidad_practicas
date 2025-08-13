package es.udc.ws.app.client.service.rest.json;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.JsonNodeType;
import com.fasterxml.jackson.databind.node.ObjectNode;
import es.udc.ws.app.client.service.dto.ClientVentaDto;
import es.udc.ws.util.json.ObjectMapperFactory;
import es.udc.ws.util.json.exceptions.ParsingException;

import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class JsonToClientVentaDtoConversor {

    public static ClientVentaDto toClientSaleDto(InputStream jsonSale) throws ParsingException {
        try {

            ObjectMapper objectMapper = ObjectMapperFactory.instance();
            JsonNode rootNode = objectMapper.readTree(jsonSale);
            if (rootNode.getNodeType() != JsonNodeType.OBJECT) {
                throw new ParsingException("Unrecognized JSON (object expected)");
            } else {
                ObjectNode movieObject = (ObjectNode) rootNode;

                JsonNode idEntradaNode = movieObject.get("idEntrada");
                Long idEntrada = (idEntradaNode != null) ? idEntradaNode.longValue() : null;

                String correoUsuario = movieObject.get("Correo").textValue().trim();
                String tarjetaCredito4digitos = movieObject.get("Tarjeta_de_credito").textValue().trim();
                int unidadesAComprar = movieObject.get("Unidades_a_comprar").intValue();
                LocalDateTime Fecha_de_compra = LocalDateTime.parse(movieObject.get("Fecha_de_compra").textValue().trim());
                Long partidoId = movieObject.get("partidoID").longValue();
                //boolean Entrada_Marcada = movieObject.get("Entrada_Marcada").booleanValue();

                return new ClientVentaDto(idEntrada, correoUsuario, tarjetaCredito4digitos,Fecha_de_compra ,unidadesAComprar, partidoId);

            }
        } catch (ParsingException ex) {
            throw ex;
        } catch (Exception e) {
            throw new ParsingException(e);
        }
    }


    public static List<ClientVentaDto> toClientSaleDtos(InputStream jsonSale) throws ParsingException {
        try {

            ObjectMapper objectMapper = ObjectMapperFactory.instance();
            JsonNode rootNode = objectMapper.readTree(jsonSale);
            if (rootNode.getNodeType() != JsonNodeType.ARRAY) {
                throw new ParsingException("Unrecognized JSON (array expected)");
            } else {
                ArrayNode saleArray = (ArrayNode) rootNode;
                List<ClientVentaDto> saleDtos = new ArrayList<>(saleArray.size());
                for (JsonNode saleNode : saleArray) {
                    saleDtos.add(toClientSaleDto(saleNode));
                }

                return saleDtos;
            }
        } catch (ParsingException ex) {
            throw ex;
        } catch (Exception e) {
            throw new ParsingException(e);
        }
    }
    private static ClientVentaDto toClientSaleDto(JsonNode buyingNode) throws ParsingException {

        if (buyingNode.getNodeType() != JsonNodeType.OBJECT) {
            throw new ParsingException("Unrecognized JSON (object expected)");
        } else {
            ObjectNode buyingObject = (ObjectNode) buyingNode;

            JsonNode idEntradaNode = buyingObject.get("idEntrada");
            Long idEntrada = (idEntradaNode != null) ? idEntradaNode.longValue() : null;

            String correoUsuario = buyingObject.get("Correo").textValue().trim();
            String tarjetaCredito4digitos = buyingObject.get("Tarjeta_de_credito").textValue().trim();
            int unidadesAComprar = buyingObject.get("Unidades_a_comprar").intValue();
            LocalDateTime Fecha_de_compra = LocalDateTime.parse(buyingObject.get("Fecha_de_compra").textValue().trim());
            Long partidoId = buyingObject.get("partidoID").longValue();
            //boolean Entrada_Marcada = buyingObject.get("Entrada_Marcada").booleanValue();

            return new ClientVentaDto(idEntrada, correoUsuario, tarjetaCredito4digitos,Fecha_de_compra ,unidadesAComprar, partidoId);

        }
    }


}
