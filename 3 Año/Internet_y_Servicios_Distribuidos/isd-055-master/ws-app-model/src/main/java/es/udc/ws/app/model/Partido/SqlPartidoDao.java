package es.udc.ws.app.model.Partido;


import es.udc.ws.util.exceptions.InstanceNotFoundException;

import java.sql.Connection;
import java.time.LocalDateTime;
import java.util.List;
public interface SqlPartidoDao {
    public Partido Create (Connection connection, Partido partido);

    public void update (Connection connection, Partido partido) throws InstanceNotFoundException;

    public Partido BuscarPartidoPorId  (Connection connection, Long PartidoId ) throws InstanceNotFoundException;

    public List<Partido> BuscarPartidoPorFecha  (Connection connection, LocalDateTime Fecha_Inicio, LocalDateTime Fecha_Fin);

//
    public void remove(Connection connection, Long PartidoId) throws InstanceNotFoundException;

    public List<Partido> BuscarPartidoPorEntradas(Connection connection, Long Numero_Entradas, LocalDateTime Fecha_Inicio, LocalDateTime Fecha_Fin);
    public List<Partido> BuscarPartidoPorEntradas(Connection connection, Long Numero_Entradas);
//

}
