package es.udc.ws.app.thriftservice;

import es.udc.ws.app.model.Partido.Partido;
import es.udc.ws.app.thrift.ThriftPartidoDto;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class PartidoToThriftPartidoDtoConversor {


    public static List<ThriftPartidoDto> toThriftPartidoDtos(List<Partido> partidos) {

        List<ThriftPartidoDto> dtos = new ArrayList<>(partidos.size());

        for (Partido partido : partidos) {
            dtos.add(toThriftPartidoDto(partido));
        }
        return dtos;

    }

    public static ThriftPartidoDto toThriftPartidoDto(Partido partido) {

        return new ThriftPartidoDto(partido.getPartidoId(),partido.getEquipo_Visitante(),
                partido.getFecha_Del_partido().toString(), partido.getPrecio_Partido(), partido.getUnidades_disponibles());
    }

    public static Partido toPartido(ThriftPartidoDto partido) {
        return new Partido(partido.getPartidoId(),partido.getEquipo_Visitante(),
                LocalDateTime.parse(partido.getFecha_Partido()), Double.valueOf(partido.getPrecio_Partido()).floatValue(), partido.getUnidades_disponibles(),LocalDateTime.now(),0);
    }
}
