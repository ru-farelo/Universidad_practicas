package es.udc.ws.app.thriftservice;
import es.udc.ws.app.model.Partido.Partido;
import es.udc.ws.app.model.PartidoService.PartidoServiceFactory;
import es.udc.ws.app.thrift.ThriftInputValidationException;
import es.udc.ws.app.thrift.ThriftInstanceNotFoundException;
import es.udc.ws.app.thrift.ThriftPartidoDto;
import es.udc.ws.app.thrift.ThriftPartidoService;
import es.udc.ws.util.exceptions.InputValidationException;
import es.udc.ws.util.exceptions.InstanceNotFoundException;
import org.apache.thrift.TException;

import java.time.LocalDate;
import java.time.LocalDateTime;

//import es.udc.ws.app.thrift.*;
public class ThriftPartidoServiceImpl implements ThriftPartidoService.Iface {

    @Override
    public ThriftPartidoDto CrearPartido(ThriftPartidoDto partidoDto) throws ThriftInputValidationException, TException {

        Partido partido = PartidoToThriftPartidoDtoConversor.toPartido(partidoDto);
        try {
            Partido addedPartido = PartidoServiceFactory.getService().CrearPartido(partido);
            return PartidoToThriftPartidoDtoConversor.toThriftPartidoDto(addedPartido);
        } catch (InputValidationException e) {
            throw new ThriftInputValidationException(e.getMessage());
        }
    }


    @Override
    public ThriftPartidoDto BuscarPartidoPorId(long idPartido) throws ThriftInstanceNotFoundException {
        try {
            Partido partido = PartidoServiceFactory.getService().BuscarPartidoPorId(idPartido);
            return PartidoToThriftPartidoDtoConversor.toThriftPartidoDto(partido);
        } catch (InstanceNotFoundException e) {
            throw new ThriftInstanceNotFoundException(e.getInstanceId().toString(),
                    e.getInstanceType().substring(e.getInstanceType().lastIndexOf('.') + 1));
        }
    }
}
