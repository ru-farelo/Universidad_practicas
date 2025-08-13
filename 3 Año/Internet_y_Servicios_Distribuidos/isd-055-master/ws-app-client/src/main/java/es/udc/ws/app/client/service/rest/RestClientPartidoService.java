package es.udc.ws.app.client.service.rest;

import com.fasterxml.jackson.core.util.DefaultPrettyPrinter;
import com.fasterxml.jackson.databind.ObjectMapper;
import es.udc.ws.app.client.service.ClientPartidoService;
import es.udc.ws.app.client.service.dto.ClientPartidoDto;
import es.udc.ws.app.client.service.dto.ClientVentaDto;
import es.udc.ws.app.client.service.exceptions.ClientEntradaMarcadaException;
import es.udc.ws.app.client.service.exceptions.ClientEntradaNotAvaliableException;
import es.udc.ws.app.client.service.exceptions.ClientIncorrectTarjetaCreditoException;
import es.udc.ws.app.client.service.exceptions.ClientNotEnoughUnidadesException;
import es.udc.ws.app.client.service.rest.json.JsonToClientExceptionConversor;
import es.udc.ws.app.client.service.rest.json.JsonToClientPartidoDtoConversor;
import es.udc.ws.app.client.service.rest.json.JsonToClientVentaDtoConversor;
import es.udc.ws.app.model.PartidoService.exceptions.FechaIncorrecta;
import es.udc.ws.app.model.PartidoService.exceptions.IncorrectTarjetaCreditoException;
import es.udc.ws.app.model.PartidoService.exceptions.NotEnoughUnidadesException;
import es.udc.ws.util.configuration.ConfigurationParametersManager;
import es.udc.ws.util.exceptions.InputValidationException;
import es.udc.ws.util.exceptions.InstanceNotFoundException;
import es.udc.ws.util.json.ObjectMapperFactory;
import org.apache.hc.client5.http.fluent.Form;
import org.apache.hc.client5.http.fluent.Request;
import org.apache.hc.core5.http.ClassicHttpResponse;
import org.apache.hc.core5.http.ContentType;
import org.apache.hc.core5.http.HttpStatus;


import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.time.LocalDateTime;
import java.util.List;


public class RestClientPartidoService  implements ClientPartidoService {

    private final static String ENDPOINT_ADDRESS_PARAMETER = "RestClientPartidoService.endpointAddress";
    private String endpointAddress;

    @Override
    public Long CrearPartido(ClientPartidoDto partido) throws InputValidationException, InstanceNotFoundException {

        try {
            ClassicHttpResponse response = (ClassicHttpResponse) Request.post(getEndpointAddress() + "Partidos").
                    bodyStream(toInputStream(partido), ContentType.create("application/json")).
                    execute().returnResponse();

            validateStatusCode(HttpStatus.SC_CREATED, response);

            return JsonToClientPartidoDtoConversor.toClientPartidoDto(response.getEntity().getContent()).getPartidoId();

        } catch (InputValidationException | InstanceNotFoundException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }

    }


    @Override
    public ClientPartidoDto BuscarPartidoPorId(Long PartidoId) throws InstanceNotFoundException {
        try {
            ClassicHttpResponse response = (ClassicHttpResponse) Request.get(getEndpointAddress() + "Partidos/" + PartidoId).
                    execute().returnResponse();

            validateStatusCode(HttpStatus.SC_OK, response);

            return JsonToClientPartidoDtoConversor.toClientPartidoDto(response.getEntity().getContent());

        } catch (InstanceNotFoundException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<ClientPartidoDto> BuscarPartidoPorFecha(LocalDateTime Fecha_Fin) throws InputValidationException {
        LocalDateTime Fecha_Inicio = LocalDateTime.now().withNano(0);
        try {
            ClassicHttpResponse response = (ClassicHttpResponse) Request.get(getEndpointAddress() + "Partidos?fecha_from=" + Fecha_Inicio + "&fecha_to=" + Fecha_Fin).
                    execute().returnResponse();

            validateStatusCode(HttpStatus.SC_OK, response);

            return JsonToClientPartidoDtoConversor.toClientPartidoDtos(response.getEntity().getContent());

        } catch (InputValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
    @Override
    public List<ClientPartidoDto> BuscarPartidoPocasEntradas(long Numero_entradas, LocalDateTime Fecha_Fin) throws InputValidationException {
        LocalDateTime Fecha_Inicio = LocalDateTime.now().withNano(0);
        try {
            // CHeck correct path
            ClassicHttpResponse response = (ClassicHttpResponse) Request.get(getEndpointAddress() + "Partidos/Oportunidad?fecha_to=" + Fecha_Fin+ "&numero_entradas=" + Numero_entradas ).
                    execute().returnResponse();

            validateStatusCode(HttpStatus.SC_OK, response);

            return JsonToClientPartidoDtoConversor.toClientPartidoDtos(response.getEntity().getContent());

        } catch (InputValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Long ComprarEntradas( String correo , String tarjeta_de_credito, int unidades_a_comprar,Long partidoId ) throws InstanceNotFoundException, InputValidationException, ClientNotEnoughUnidadesException, ClientEntradaNotAvaliableException, ClientIncorrectTarjetaCreditoException, NotEnoughUnidadesException {



        try {
            ClassicHttpResponse response = (ClassicHttpResponse) Request.post(getEndpointAddress() + "Ventas").
                    bodyForm(
                            Form.form().
                                    add("Correo", correo).
                                    add("Tarjeta_de_credito", tarjeta_de_credito).
                                    add("Unidades_a_comprar", String.valueOf(unidades_a_comprar)).
                                    add("partidoID", String.valueOf(partidoId)).
                                    build()).
                    execute().returnResponse();

            validateStatusCode(HttpStatus.SC_CREATED, response);

            return JsonToClientVentaDtoConversor.toClientSaleDto(response.getEntity().getContent()).getIdEntrada();

        } catch (InstanceNotFoundException | InputValidationException | NotEnoughUnidadesException  e ) {
            throw e;
        }  catch (ClientNotEnoughUnidadesException e ) {
            throw new ClientNotEnoughUnidadesException(e.getUnidadesDisponibles(), e.getUnidadesAComprar());
        } catch (ClientEntradaNotAvaliableException e) {
            throw new ClientEntradaNotAvaliableException(e.getEntradaId());
        } catch (ClientIncorrectTarjetaCreditoException e) {
            throw new ClientIncorrectTarjetaCreditoException(e.getTarjetaCredito(), e.getPartidoId());
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<ClientVentaDto> Buscar_Todas_las_Compras_Usuario(String Correo) throws InputValidationException {

        try {
            ClassicHttpResponse response = (ClassicHttpResponse) Request.get(getEndpointAddress() + "Ventas?correo=" + Correo).
                    execute().returnResponse();

            validateStatusCode(HttpStatus.SC_OK, response);

            return JsonToClientVentaDtoConversor.toClientSaleDtos(response.getEntity().getContent());

        } catch (InputValidationException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }



    @Override
    public ClientVentaDto Marcar_Entrada(long EntradaId, String Tarjeta_de_credito) throws ClientEntradaMarcadaException, InstanceNotFoundException, IncorrectTarjetaCreditoException, ClientIncorrectTarjetaCreditoException {

        try {
            ClassicHttpResponse response = (ClassicHttpResponse) Request.post(getEndpointAddress() + "Ventas/marcar").
                    bodyForm(
                            Form.form().
                                    add("idEntrada", String.valueOf(EntradaId)).
                                    add("Tarjeta_de_credito", Tarjeta_de_credito).
                                    build()).
                    execute().returnResponse();

            validateStatusCode(HttpStatus.SC_OK, response);

            return JsonToClientVentaDtoConversor.toClientSaleDto(response.getEntity().getContent());

        } catch (ClientEntradaMarcadaException | InstanceNotFoundException |IncorrectTarjetaCreditoException | ClientIncorrectTarjetaCreditoException e) {
            throw e;
        }
        catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void EliminarPartidoCelebrado(long PartidoId) throws InstanceNotFoundException,InputValidationException {
        try {
            System.out.println("Enter RestClient");
            ClassicHttpResponse response = (ClassicHttpResponse) Request.delete(getEndpointAddress()+ "Partidos?partidoId=" + PartidoId).
                    execute().returnResponse();
            System.out.println("This is response delete"+response);
            validateStatusCode(HttpStatus.SC_NO_CONTENT, response);
            System.out.println("Going out Restclient");
        }
        catch (InstanceNotFoundException | InputValidationException e){
            throw e;
        }
        catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    private synchronized String getEndpointAddress() {
        if (endpointAddress == null) {
            endpointAddress = ConfigurationParametersManager
                    .getParameter(ENDPOINT_ADDRESS_PARAMETER);
        }
        return endpointAddress;
    }

    private InputStream toInputStream(ClientPartidoDto partido) {

        try {

            ByteArrayOutputStream outputStream = new ByteArrayOutputStream();
            ObjectMapper objectMapper = ObjectMapperFactory.instance();
            objectMapper.writer(new DefaultPrettyPrinter()).writeValue(outputStream,
                    JsonToClientPartidoDtoConversor.toObjectNode(partido));

            return new ByteArrayInputStream(outputStream.toByteArray());

        } catch (IOException e) {
            throw new RuntimeException(e);
        }
    }

    private void validateStatusCode(int successCode, ClassicHttpResponse response) throws Exception {

        try {

            int statusCode = response.getCode();

            /* Success? */
            if (statusCode == successCode) {
                return;
            }

            /* Handler error. */
            switch (statusCode) {
                case HttpStatus.SC_NOT_FOUND -> throw JsonToClientExceptionConversor.fromNotFoundErrorCode(
                        response.getEntity().getContent());
                case HttpStatus.SC_BAD_REQUEST -> throw JsonToClientExceptionConversor.fromBadRequestErrorCode(
                        response.getEntity().getContent());
                case HttpStatus.SC_FORBIDDEN -> throw JsonToClientExceptionConversor.fromForbiddenErrorCode(
                        response.getEntity().getContent());
                case HttpStatus.SC_GONE -> throw JsonToClientExceptionConversor.fromGoneErrorCode(
                        response.getEntity().getContent());
                default -> throw new RuntimeException("HTTP error; status code = "
                        + statusCode);
            }

        } catch (IOException e) {
            throw new RuntimeException(e);
        }

    }
}
