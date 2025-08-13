package es.udc.ws.app.model.Partido;

import java.sql.*;
public class Jdbc3CcSqlPartidoDao extends AbstractSqlPartidoDao {
    @Override
    public Partido Create(Connection connection, Partido partido)  {
        /* Create "queryString". */
        String queryString = "INSERT INTO Partido"
                + " (Equipo_Visitante, Fecha_Del_partido, Precio_Partido, Unidades_disponibles, "
                + " Fecha_de_alta_del_partido, Entradas_vendidas_del_partido)"
                + " VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement preparedStatement =
                     connection.prepareStatement(queryString, Statement.RETURN_GENERATED_KEYS)
        ) {

            /* Fill "preparedStatement". */
            int i = 1;
           // preparedStatement.setLong(i++, partido.getPartidoId());
            preparedStatement.setString(i++, partido.getEquipo_Visitante());
            preparedStatement.setTimestamp(i++, Timestamp.valueOf(partido.getFecha_Del_partido()));
            preparedStatement.setFloat(i++, partido.getPrecio_Partido());
            preparedStatement.setInt(i++, partido.getUnidades_disponibles());
            preparedStatement.setTimestamp(i++, Timestamp.valueOf(partido.getFecha_de_alta_del_partido()));
            preparedStatement.setInt(i++, partido.getEntradas_vendidas_del_partido());


            /* Execute query. */
            preparedStatement.executeUpdate();

            /* Get generated identifier. */
            ResultSet resultSet = preparedStatement.getGeneratedKeys();

            if (!resultSet.next()) {
                throw new SQLException(
                        "JDBC driver did not return generated key.");
            }
            Long partidoId = resultSet.getLong(1);

            /* Return movie. */
            return new Partido(partidoId, partido.getEquipo_Visitante(),
                    partido.getFecha_Del_partido(), partido.getPrecio_Partido(),partido.getUnidades_disponibles(),
                    partido.getFecha_de_alta_del_partido(), partido.getEntradas_vendidas_del_partido());

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

}
