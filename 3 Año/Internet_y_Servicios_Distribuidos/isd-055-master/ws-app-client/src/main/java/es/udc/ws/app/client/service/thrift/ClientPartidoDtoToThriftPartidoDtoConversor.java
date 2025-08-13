package es.udc.ws.app.client.service.thrift;

import es.udc.ws.app.client.service.dto.ClientPartidoDto;
import es.udc.ws.app.thrift.ThriftPartidoDto;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class ClientPartidoDtoToThriftPartidoDtoConversor {

    public static ThriftPartidoDto toThriftPartidoDto(
            ClientPartidoDto clientPartidoDto) {

        Long partidoId = clientPartidoDto.getPartidoId();

        return new ThriftPartidoDto(
                partidoId == null ? -1 : partidoId.longValue(),
                clientPartidoDto.getEquipo_Visitante(),
                clientPartidoDto.getFecha_Del_partido().toString(),
                clientPartidoDto.getPrecio_Partido(),
                clientPartidoDto.getUnidades_disponibles());
    }

    public static List<ClientPartidoDto> toClientPartidoDtos(List<ThriftPartidoDto> partidos) {

        List<ClientPartidoDto> clientPartidoDtos = new ArrayList<>(partidos.size());

        for (ThriftPartidoDto partido : partidos) {
            clientPartidoDtos.add(toClientPartidoDto(partido));
        }
        return clientPartidoDtos;

    }

    static ClientPartidoDto toClientPartidoDto(ThriftPartidoDto partido) {

        return new ClientPartidoDto(
                partido.getPartidoId(),
                partido.getEquipo_Visitante(),
                LocalDateTime.parse(partido.getFecha_Partido()),
                Double.valueOf(partido.getPrecio_Partido()).floatValue(),
                partido.getUnidades_disponibles()
                );

    }

}
