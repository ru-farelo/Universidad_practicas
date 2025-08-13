package es.udc.ws.app.client.service.thrift;

import es.udc.ws.app.client.service.ClientPartidoService;
import es.udc.ws.app.client.service.dto.ClientPartidoDto;
import es.udc.ws.app.client.service.dto.ClientVentaDto;
import es.udc.ws.app.client.service.exceptions.ClientEntradaMarcadaException;
import es.udc.ws.app.client.service.exceptions.ClientEntradaNotAvaliableException;
import es.udc.ws.app.client.service.exceptions.ClientIncorrectTarjetaCreditoException;
import es.udc.ws.app.client.service.exceptions.ClientNotEnoughUnidadesException;
import es.udc.ws.app.thrift.ThriftInputValidationException;
import es.udc.ws.app.thrift.ThriftInstanceNotFoundException;
import es.udc.ws.app.thrift.ThriftPartidoService;
import es.udc.ws.util.configuration.ConfigurationParametersManager;
import es.udc.ws.util.exceptions.InputValidationException;
import es.udc.ws.util.exceptions.InstanceNotFoundException;
import org.apache.thrift.protocol.TBinaryProtocol;
import org.apache.thrift.protocol.TProtocol;
import org.apache.thrift.transport.THttpClient;
import org.apache.thrift.transport.TTransport;
import org.apache.thrift.transport.TTransportException;

import java.time.LocalDateTime;
import java.util.List;

public class ThriftClientPartidoService implements ClientPartidoService {
    private final static String ENDPOINT_ADDRESS_PARAMETER =
            "ThriftClientPartidoService.endpointAddress";

    private final static String endpointAddress =
            ConfigurationParametersManager.getParameter(ENDPOINT_ADDRESS_PARAMETER);

    @Override
    public Long CrearPartido(ClientPartidoDto partido) throws InputValidationException {

        ThriftPartidoService.Client client = getClient();

        try (TTransport transport = client.getInputProtocol().getTransport()) {
            transport.open();
            return client.CrearPartido(ClientPartidoDtoToThriftPartidoDtoConversor.toThriftPartidoDto(partido)).getPartidoId();
        }
        catch (ThriftInputValidationException e) {
            throw new InputValidationException(e.getMessage());
        }
        catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public ClientPartidoDto BuscarPartidoPorId(Long PartidoId) throws InstanceNotFoundException {
        ThriftPartidoService.Client client = getClient();

        try (TTransport transport = client.getInputProtocol().getTransport()) {
            transport.open();
            return ClientPartidoDtoToThriftPartidoDtoConversor.toClientPartidoDto(client.BuscarPartidoPorId(PartidoId));
        } catch (ThriftInstanceNotFoundException e) {
            throw new InstanceNotFoundException(e.getInstanceId().toString(),
                    e.getInstanceType().substring(e.getInstanceType().lastIndexOf('.') + 1));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }

    @Override
    public List<ClientPartidoDto> BuscarPartidoPorFecha(LocalDateTime Fecha_Fin) throws InputValidationException {
        return null;
    }

    @Override
    public Long ComprarEntradas(String correo, String tarjeta_de_credito, int unidades_a_comprar, Long partidoId) throws InstanceNotFoundException, InputValidationException, ClientNotEnoughUnidadesException, ClientEntradaNotAvaliableException, ClientIncorrectTarjetaCreditoException {
        return null;
    }

    @Override
    public List<ClientVentaDto> Buscar_Todas_las_Compras_Usuario(String Correo) throws InputValidationException {
        return null;
    }

    @Override
    public ClientVentaDto Marcar_Entrada(long EntradaId, String Tarjeta_de_credito) throws ClientEntradaMarcadaException, InstanceNotFoundException {
        return null;
    }

    private ThriftPartidoService.Client getClient() {

            try {

                TTransport transport = new THttpClient(endpointAddress);

                TProtocol protocol = new TBinaryProtocol(transport);

                return new ThriftPartidoService.Client(protocol);

            } catch (TTransportException e) {

                throw new RuntimeException(e);

            }

        }

    @Override
    public List<ClientPartidoDto> BuscarPartidoPocasEntradas(long Numero_entradas, LocalDateTime Fecha_Fin) throws InputValidationException {
        return List.of();
    }

    @Override
    public void EliminarPartidoCelebrado(long PartidoId) throws InstanceNotFoundException {
        return;
    }
}
