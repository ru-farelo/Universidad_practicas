package es.udc.ws.app.restservice.servlets;

import es.udc.ws.app.model.ComprarEntradas.Comprar;
import es.udc.ws.app.model.PartidoService.PartidoServiceFactory;
import es.udc.ws.app.model.PartidoService.exceptions.EntradaMarcadaException;
import es.udc.ws.app.restservice.dto.VentasToRestVentasDtoConversor;
import es.udc.ws.app.restservice.dto.RestVentasDto;
import es.udc.ws.app.restservice.json.JsonToRestVentasDtoConversor;
import es.udc.ws.util.exceptions.InputValidationException;
import es.udc.ws.util.exceptions.InstanceNotFoundException;
import es.udc.ws.util.servlet.RestHttpServletTemplate;
import es.udc.ws.util.servlet.ServletUtils;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import es.udc.ws.app.model.PartidoService.exceptions.EntradaNotAvaliableException;
import es.udc.ws.app.model.PartidoService.exceptions.IncorrectTarjetaCreditoException;
import es.udc.ws.app.model.PartidoService.exceptions.NotEnoughUnidadesException;


import es.udc.ws.app.restservice.json.PartidosExceptionToJsonConversor;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class VentasServlet extends RestHttpServletTemplate {

    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, InputValidationException , InstanceNotFoundException{

        String requestPath = req.getRequestURI();

        if (requestPath.endsWith("/Ventas") ) {
            try {
                //ServletUtils.checkEmptyPath(req);
                String correo = ServletUtils.getMandatoryParameter(req, "Correo");
                String tarjeta_de_credito = ServletUtils.getMandatoryParameter(req, "Tarjeta_de_credito");
                int unidades_a_comprar = Integer.parseInt(ServletUtils.getMandatoryParameter(req, "Unidades_a_comprar"));
                Long partidoId = ServletUtils.getMandatoryParameterAsLong(req, "partidoID");

                Comprar compra = PartidoServiceFactory.getService().ComprarEntradas(correo, tarjeta_de_credito, unidades_a_comprar, LocalDateTime.now(), partidoId, false);

                RestVentasDto compraDto = VentasToRestVentasDtoConversor.toRestComprarEntradaDto(compra);
                String compraURL = ServletUtils.normalizePath(req.getRequestURL().toString()) + "/" + compra.getEntradaId().toString();
                Map<String, String> headers = new HashMap<>(1);
                headers.put("Location", compraURL);
                ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_CREATED,
                        JsonToRestVentasDtoConversor.toObjectNode(compraDto), headers);
            } catch (IncorrectTarjetaCreditoException e) {
                ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_FORBIDDEN,
                        PartidosExceptionToJsonConversor.toIncorrectTarjetaCreditoException(e), null);
            } catch (NotEnoughUnidadesException e) {
                ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_FORBIDDEN,
                        PartidosExceptionToJsonConversor.toNotEnoughUnidadesException(e), null);
            } catch (EntradaNotAvaliableException e) {
                ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_GONE,
                        PartidosExceptionToJsonConversor.toEntradaNotAvaliableException(e), null);
            }
        }else if (requestPath.endsWith("/Ventas/marcar")){
            try { //En la propia URL PASO LA FUNCION DE Marcar_entrada
                long entradaId = ServletUtils.getMandatoryParameterAsLong(req, "idEntrada");
                String tarjeta_de_credito = ServletUtils.getMandatoryParameter(req, "Tarjeta_de_credito");
                Comprar compra = PartidoServiceFactory.getService().Marcar_Entrada(entradaId, tarjeta_de_credito);

                RestVentasDto compraDto = VentasToRestVentasDtoConversor.toRestComprarEntradaDto(compra);
                ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_OK,//MIRAR SI HAY QUE CAMBIAR EL SC
                        JsonToRestVentasDtoConversor.toObjectNode(compraDto), null);

            } catch (IncorrectTarjetaCreditoException  e) {
                ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_FORBIDDEN,
                        PartidosExceptionToJsonConversor.toIncorrectTarjetaCreditoException(e), null);
            } catch (EntradaMarcadaException e) {
                ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_FORBIDDEN,
                        PartidosExceptionToJsonConversor.toEntradaMarcadaException(e), null);
            }

        }


    }


    @Override
    protected void processGet(HttpServletRequest req, HttpServletResponse resp)
            throws IOException, InputValidationException {

            ServletUtils.checkEmptyPath(req);
            String correo =  req.getParameter( "correo");
            List<Comprar> compras = PartidoServiceFactory.getService().Buscar_Todas_las_Compras_Usuario(correo);

            // Convertir las compras encontradas a RestComprarEntradaDto
            List<RestVentasDto> comprasDtos = VentasToRestVentasDtoConversor.toRestComprarEntradaDtos(compras);

            // Escribe la respuesta JSON en el HttpServletResponse
            ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_OK,
                    JsonToRestVentasDtoConversor.toArrayNode(comprasDtos), null);

    }


}
