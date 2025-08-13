package es.udc.ws.app.model.PartidoService;
import es.udc.ws.app.model.Partido.*;
import es.udc.ws.app.model.ComprarEntradas.*;
import es.udc.ws.app.model.PartidoService.exceptions.EntradaMarcadaException;
import es.udc.ws.app.model.PartidoService.exceptions.EntradaNotAvaliableException;
import es.udc.ws.app.model.PartidoService.exceptions.IncorrectTarjetaCreditoException;
import es.udc.ws.app.model.PartidoService.exceptions.NotEnoughUnidadesException;
import es.udc.ws.util.exceptions.InputValidationException;
import es.udc.ws.util.exceptions.InstanceNotFoundException;

import java.time.LocalDateTime;
import java.util.List;


public interface PartidoService {
    Partido CrearPartido (Partido partido) throws InputValidationException;

    Partido BuscarPartidoPorId (long PartidoId) throws InstanceNotFoundException;

    List<Partido> BuscarPartidoPorFecha (LocalDateTime Fecha_Inicio,LocalDateTime Fecha_Fin) throws InputValidationException;
    List<Partido> BuscarPartidosNoCelebrados(Long Unidades, LocalDateTime Fecha_Fin) throws InputValidationException;
    Comprar ComprarEntradas ( String correo, String tarjeta_de_credito, int unidades_a_comprar, LocalDateTime fecha_de_compra, Long partidoId, boolean entrada_Marcada ) throws
            InstanceNotFoundException,InputValidationException, IncorrectTarjetaCreditoException, NotEnoughUnidadesException, EntradaNotAvaliableException; //Poner las dos excepciones que quedan
   public List <Comprar> Buscar_Todas_las_Compras_Usuario (String Correo) throws InputValidationException;

   public Comprar Marcar_Entrada (long EntradaId,String Tarjeta_de_credito) throws IncorrectTarjetaCreditoException, InstanceNotFoundException, EntradaMarcadaException;
    void EliminarPartidoCelebrado (Long partido) throws InputValidationException, InstanceNotFoundException;

    // TODO Error management
    
    //public boolean Majete(String PartidoId) throws InstanceNotFoundException;
    //List<Partido> BuscarPartidoPorFechaUnica(LocalDateTime fechaFrom);
}
