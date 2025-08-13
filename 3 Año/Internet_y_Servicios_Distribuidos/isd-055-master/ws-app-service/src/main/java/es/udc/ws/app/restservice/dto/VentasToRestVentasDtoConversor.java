package es.udc.ws.app.restservice.dto;

import es.udc.ws.app.model.ComprarEntradas.Comprar;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public class VentasToRestVentasDtoConversor {


    public static List<RestVentasDto> toRestComprarEntradaDtos(List<Comprar> compras) {
        List<RestVentasDto> comprarEntradaDtos = new ArrayList<>(compras.size());
        for (int i = 0; i < compras.size(); i++) {
            Comprar compra = compras.get(i);
            comprarEntradaDtos.add(toRestComprarEntradaDto(compra));
        }
        return comprarEntradaDtos;
    }


    public static RestVentasDto toRestComprarEntradaDto(Comprar compra) {
       // return new RestVentasDto(compra.getEntradaId(),compra.getCorreo(),compra.getTarjeta_de_credito(),compra.getUnidades_a_comprar(),compra.getFecha_de_compra(),compra.getPartidoId(),compra.isEntrada_Marcada());
        return new RestVentasDto(compra.getEntradaId(),compra.getCorreo(),compra.getTarjeta_de_credito(),compra.getUnidades_a_comprar(),compra.getFecha_de_compra(),compra.getPartidoId(),compra.isEntrada_Marcada());
    }

//    public static Comprar toComprar(RestVentasDto restComprarEntradaDto) {
//        //return new Comprar(restComprarEntradaDto.getIdEntrada(),restComprarEntradaDto.getCorreoUsuario(),restComprarEntradaDto.getTarjetaCredito4digitos(),restComprarEntradaDto.getUnidadesAComprar(),restComprarEntradaDto.getFecha_de_compra(),restComprarEntradaDto.getPartidoId(),restComprarEntradaDto.isEntrada_Marcada());
//        return new Comprar(restComprarEntradaDto.getCorreoUsuario(),restComprarEntradaDto.getTarjetaCredito4digitos(),restComprarEntradaDto.getUnidadesAComprar(),LocalDateTime.now(),restComprarEntradaDto.getPartidoId(),restComprarEntradaDto.isEntrada_Marcada());
//    }

}