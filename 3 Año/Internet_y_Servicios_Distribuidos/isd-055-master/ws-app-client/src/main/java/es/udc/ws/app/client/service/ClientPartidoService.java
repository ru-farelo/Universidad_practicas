package es.udc.ws.app.client.service;

import es.udc.ws.app.client.service.dto.ClientPartidoDto;
import es.udc.ws.app.client.service.dto.ClientVentaDto;
import es.udc.ws.app.client.service.exceptions.ClientEntradaMarcadaException;
import es.udc.ws.app.client.service.exceptions.ClientEntradaNotAvaliableException;
import es.udc.ws.app.client.service.exceptions.ClientIncorrectTarjetaCreditoException;
import es.udc.ws.app.client.service.exceptions.ClientNotEnoughUnidadesException;
import es.udc.ws.app.model.PartidoService.exceptions.IncorrectTarjetaCreditoException;
import es.udc.ws.app.model.PartidoService.exceptions.NotEnoughUnidadesException;
import es.udc.ws.util.exceptions.InputValidationException;
import es.udc.ws.util.exceptions.InstanceNotFoundException;

import java.time.LocalDateTime;
import java.util.List;

public interface ClientPartidoService {
    //Mirar el tipo de la funcion si es Partido O lONG
    public  Long CrearPartido(ClientPartidoDto partido) throws InputValidationException, InstanceNotFoundException;

    // BuscarPartidoPorId
    public ClientPartidoDto BuscarPartidoPorId(Long PartidoId) throws InstanceNotFoundException;
    // BuscarPartidoPorFecha
     public List<ClientPartidoDto> BuscarPartidoPorFecha(LocalDateTime Fecha_Fin) throws InputValidationException;
    // ComprarEntradas
    public Long ComprarEntradas(  String correo , String tarjeta_de_credito, int unidades_a_comprar,Long partidoId) throws
            InstanceNotFoundException, InputValidationException, ClientNotEnoughUnidadesException, ClientEntradaNotAvaliableException ,ClientIncorrectTarjetaCreditoException, NotEnoughUnidadesException; //Poner las dos excepciones que quedan

    // Buscar_Todas_las_Compras_Usuario
    public List<ClientVentaDto> Buscar_Todas_las_Compras_Usuario(String Correo) throws InputValidationException;
    // Marcar_Entrada
    public ClientVentaDto Marcar_Entrada(long EntradaId, String Tarjeta_de_credito) throws ClientEntradaMarcadaException, InstanceNotFoundException, IncorrectTarjetaCreditoException, ClientIncorrectTarjetaCreditoException;
    public List<ClientPartidoDto> BuscarPartidoPocasEntradas(long Numero_entradas, LocalDateTime Fecha_Fin) throws InputValidationException;
    public void EliminarPartidoCelebrado(long PartidoId) throws InstanceNotFoundException, InputValidationException;

}
