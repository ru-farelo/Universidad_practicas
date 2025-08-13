package es.udc.ws.app.restservice.dto;

import es.udc.ws.app.model.Partido.Partido;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;

public class PartidoToRestPartidoDtoConversor {


    public static List<RestPartidoDto> toRestPartidoDtos(List<Partido> partidos) {
        List<RestPartidoDto> partidoDtos = new ArrayList<>(partidos.size());
        for (int i = 0; i < partidos.size(); i++) {
            Partido partido = partidos.get(i);
            partidoDtos.add(toRestPartidoDto(partido));
        }
        return partidoDtos;
    }

    public static RestPartidoDto toRestPartidoDto(Partido partido) {
        return new RestPartidoDto(partido.getPartidoId(),partido.getEquipo_Visitante(),partido.getFecha_Del_partido(),partido.getPrecio_Partido(),partido.getUnidades_disponibles(),partido.getEntradas_vendidas_del_partido());
    }

    public static Partido toPartido(RestPartidoDto restPartidoDto) {
        //return new Partido(restPartidoDto.getPartidoId(),restPartidoDto.getEquipo_Visitante(),restPartidoDto.getFecha_Del_partido(),restPartidoDto.getPrecio_Partido(),restPartidoDto.getUnidades_disponibles(),restPartidoDto.getEntradas_vendidas_del_partido());
        return new Partido(restPartidoDto.getPartidoId(),restPartidoDto.getEquipo_Visitante(),restPartidoDto.getFecha_Del_partido(),restPartidoDto.getPrecio_Partido(),restPartidoDto.getUnidades_disponibles(),LocalDateTime.now(),restPartidoDto.getEntradas_vendidas_del_partido());
    }


}
