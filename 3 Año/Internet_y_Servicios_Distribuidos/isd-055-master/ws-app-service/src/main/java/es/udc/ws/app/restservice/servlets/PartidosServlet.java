package es.udc.ws.app.restservice.servlets;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.List;//
import java.util.Map;


//import es.udc.ws.app.model.PartidoService.PartidoServiceFactory;
import es.udc.ws.app.model.PartidoService.PartidoServiceFactory;
import es.udc.ws.app.model.PartidoService.exceptions.FechaIncorrecta;
import es.udc.ws.app.restservice.json.PartidosExceptionToJsonConversor;
import es.udc.ws.util.exceptions.InstanceNotFoundException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import es.udc.ws.app.model.Partido.Partido;
import es.udc.ws.app.restservice.dto.PartidoToRestPartidoDtoConversor;
import es.udc.ws.app.restservice.dto.RestPartidoDto;
import es.udc.ws.app.restservice.json.JsonToRestPartidoDtoConversor;
import es.udc.ws.util.exceptions.InputValidationException;
import es.udc.ws.util.servlet.ServletUtils;


//import es.udc.ws.movies.model.movieservice.exceptions.MovieNotRemovableException;
//import es.udc.ws.movies.model.movieservice.exceptions.SaleExpirationException;
//import es.udc.ws.movies.restservice.dto.RestMovieDto;
//import es.udc.ws.movies.model.movieservice.MovieServiceFactory;
//import es.udc.ws.movies.restservice.json.JsonToRestMovieDtoConversor;
//import es.udc.ws.movies.restservice.dto.MovieToRestMovieDtoConversor;
//import es.udc.ws.movies.restservice.json.MoviesExceptionToJsonConversor;
//import es.udc.ws.util.exceptions.InputValidationException;
//import es.udc.ws.util.exceptions.InstanceNotFoundException;
import es.udc.ws.util.servlet.RestHttpServletTemplate;
import jakarta.servlet.http.Part;


public class PartidosServlet extends RestHttpServletTemplate {


    @Override
    protected void processPost(HttpServletRequest req, HttpServletResponse resp) throws IOException,
            InputValidationException, InstanceNotFoundException {

        if (req.getPathInfo()==null || req.getPathInfo().equals("/")) {
            RestPartidoDto partidoDto = JsonToRestPartidoDtoConversor.toRestPartidoDto(req.getInputStream());
            Partido partido = PartidoToRestPartidoDtoConversor.toPartido(partidoDto);

            partido = PartidoServiceFactory.getService().CrearPartido(partido);

            partidoDto = PartidoToRestPartidoDtoConversor.toRestPartidoDto(partido);
            String partidoURL = ServletUtils.normalizePath(req.getRequestURL().toString()) + "/" + partido.getPartidoId();
            Map<String, String> headers = new HashMap<>(1);
            headers.put("Location", partidoURL);
            ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_CREATED,
                    JsonToRestPartidoDtoConversor.toObjectNode(partidoDto), headers);

        }
        else {
            //long partidoId = ServletUtils.getMandatoryParameterAsLong(req, "idPartido");
            //PartidoServiceFactory.getService().EliminarPartidoCelebrado(partidoId);

        }
    }


    @Override
    protected void processGet (HttpServletRequest req, HttpServletResponse resp) throws IOException,
            InputValidationException, InstanceNotFoundException {

        if (req.getPathInfo()==null || req.getPathInfo().equals("/")) {


            // Corrige la obtención del parámetro 'fecha_from' en req.getParameter()
            String fecha_to= req.getParameter("fecha_to");
            //DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
            //LocalDateTime fecha_to = LocalDateTime.parse(ex, formatter);
            LocalDateTime fecha_fromDate = LocalDateTime.parse(fecha_to);

            List<Partido> partidos = PartidoServiceFactory.getService().BuscarPartidoPorFecha(LocalDateTime.now(),fecha_fromDate);

            // Convierte los partidos encontrados en Dtos
            List<RestPartidoDto> partidoDtos = PartidoToRestPartidoDtoConversor.toRestPartidoDtos(partidos);

            // Escribe la respuesta JSON en el HttpServletResponse
            ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_OK,
                    JsonToRestPartidoDtoConversor.toArrayNode(partidoDtos), null);
        } else if (req.getPathInfo().equals("/Oportunidad")) {
            // Corrige la obtención del parámetro 'fecha_from' en req.getParameter()

            //DateTimeFormatter formatter = DateTimeFormatter.ISO_LOCAL_DATE_TIME;
            //LocalDateTime fecha_to = LocalDateTime.parse(ex, formatter);
            String fecha_to= req.getParameter("fecha_to");

            // TODO Check Date is null if it does not exists
            LocalDateTime fecha_fromDate = LocalDateTime.now();
            LocalDateTime fecha_toDate = LocalDateTime.parse(fecha_to);

                if (fecha_toDate.isBefore(fecha_fromDate)) {
                    //throw new InputValidationException("Fecha incorrecta, anterior a la actual");
                    ServletUtils.writeServiceResponse(
                            resp,
                            HttpServletResponse.SC_BAD_REQUEST,
                            PartidosExceptionToJsonConversor.toInputValidation(new FechaIncorrecta(fecha_toDate,fecha_fromDate)),
                            null
                    );

                }




            long numero_entradas = ServletUtils.getMandatoryParameterAsLong(req, "numero_entradas");
            List<Partido> partidos = PartidoServiceFactory.getService().BuscarPartidosNoCelebrados(numero_entradas, fecha_toDate);

            if (numero_entradas<0) {
                ServletUtils.writeServiceResponse(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        PartidosExceptionToJsonConversor.toInputValidation(new InputValidationException("")),
                        null
                );
            }
            // Convierte los partidos encontrados en Dtos
            List<RestPartidoDto> partidoDtos = PartidoToRestPartidoDtoConversor.toRestPartidoDtos(partidos);

            // Escribe la respuesta JSON en el HttpServletResponse
            ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_OK,
                    JsonToRestPartidoDtoConversor.toArrayNode(partidoDtos), null);
        } else {
            Long partidoId = ServletUtils.getIdFromPath(req, "Partidos");
            Partido partido = PartidoServiceFactory.getService().BuscarPartidoPorId(partidoId);

            RestPartidoDto partidoDto = PartidoToRestPartidoDtoConversor.toRestPartidoDto(partido);
            ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_OK,
                    JsonToRestPartidoDtoConversor.toObjectNode(partidoDto), null);
        }

    }

    @Override
    protected void processDelete(HttpServletRequest req, HttpServletResponse resp) throws IOException, InstanceNotFoundException, InputValidationException {

        String path = ServletUtils.normalizePath(req.getPathInfo());
        System.out.println("Enter processDelete");


        if (req.getPathInfo()==null || req.getPathInfo().equals("/")) {
            //Long partidoId = ServletUtils.getIdFromPath(req, "Partidos");
            String partidoId = req.getParameter("partidoId");
            Partido partido = PartidoServiceFactory.getService().BuscarPartidoPorId(Long.parseLong(partidoId));
            LocalDateTime now= LocalDateTime.now();
            System.out.println("before 1");
            if (partido.getFecha_Del_partido().isAfter(now))
                ServletUtils.writeServiceResponse(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        PartidosExceptionToJsonConversor.toInputValidation(new InputValidationException("Fecha Incorrecta, Partido aun vigente")),
                        null
                );
            System.out.println("after 1");

            try {
                PartidoServiceFactory.getService().EliminarPartidoCelebrado(Long.parseLong(partidoId));
                ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_NO_CONTENT, null, null);
            } catch (InstanceNotFoundException | InputValidationException e) {
                ServletUtils.writeServiceResponse(
                        resp,
                        HttpServletResponse.SC_BAD_REQUEST,
                        PartidosExceptionToJsonConversor.toInputValidation(new InputValidationException("No se puede borrar este partido")),
                        null
                );
            }
            System.out.println("after 2");
        }
        else ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_METHOD_NOT_ALLOWED, null, null);


    }
  /*              Long id;

            // Obtenemos el ID de partido de la solicitud
            try {
                id = ServletUtils.getMandatoryParameterAsLong(req, "partidoID");
            } catch (NullPointerException e) {
                throw new InputValidationException("Numero de entradas invalido");
            }

            // Buscamos el partido en la base de datos por ID
            Partido partido = PartidoServiceFactory.getService().findPartido(id);

            // Comprobamos que la fecha del partido no sea posterior a la actual


            // Eliminamos el partido de la base de datos
            PartidoServiceFactory.getService().removePartidoFromId(id);

            // Retornamos un código de estado exitoso
            ServletUtils.writeServiceResponse(resp, HttpServletResponse.SC_NO_CONTENT, null, null);

        // No se permiten subrutas dentro de la consulta delete
        } else
            ServletUtils.writeServiceResponse(
                    resp,
                    HttpServletResponse.SC_BAD_REQUEST,
                    AppExceptionToJsonConversor.toInputValidationException(
                            new InputValidationException("Invalid Request: invalid path " + path)
                    ),
                    null
            );
    }*/


}

