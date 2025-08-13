package es.udc.ws.app.model.Partido;
import es.udc.ws.util.exceptions.InstanceNotFoundException;

import java.sql.*;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

public abstract class AbstractSqlPartidoDao implements SqlPartidoDao {
    @Override
    public Partido BuscarPartidoPorId(Connection connection, Long partidoId) throws InstanceNotFoundException {
        String queryString =
                "SELECT Equipo_Visitante, Fecha_Del_partido, Precio_Partido, Unidades_disponibles," +
                        "Fecha_de_alta_del_partido, Entradas_vendidas_del_partido " +
                        "FROM Partido " +
                        "WHERE PartidoId = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
            int i = 1;
            preparedStatement.setLong(i++, partidoId.longValue());

            ResultSet resultSet = preparedStatement.executeQuery();


            if (!resultSet.next())
                throw new InstanceNotFoundException(partidoId, Partido.class.getName());

            i = 1;
            String Equipo_Visitante = resultSet.getString(i++);
            LocalDateTime Fecha_Del_partido = resultSet.getTimestamp(i++).toLocalDateTime();
            Float Precio_Partido = resultSet.getFloat(i++);
            int Unidades_disponibles = resultSet.getInt(i++);
            LocalDateTime Fecha_de_alta_del_partido = resultSet.getTimestamp(i++).toLocalDateTime();
            int Entradas_vendidas_del_partido = resultSet.getInt(i);

            return new Partido(partidoId, Equipo_Visitante, Fecha_Del_partido, Precio_Partido, Unidades_disponibles,
                    Fecha_de_alta_del_partido, Entradas_vendidas_del_partido);

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    @Override
    public List<Partido> BuscarPartidoPorFecha(Connection connection, LocalDateTime Fecha_Inicio, LocalDateTime Fecha_Fin) {
        String queryString = "SELECT PartidoId, Equipo_Visitante, Fecha_Del_partido, Precio_Partido, Unidades_disponibles, Fecha_de_alta_del_partido, Entradas_vendidas_del_partido FROM Partido WHERE Fecha_Del_partido BETWEEN ? AND ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
            int i = 1;
            preparedStatement.setTimestamp(i++, Timestamp.valueOf(Fecha_Inicio));
            preparedStatement.setTimestamp(i, Timestamp.valueOf(Fecha_Fin));

            ResultSet resultSet = preparedStatement.executeQuery();

            List<Partido> partidos = new ArrayList<>();

            while (resultSet.next()) {
                i = 1;
                Long PartidoId = resultSet.getLong(i++);
                String Equipo_Visitante = resultSet.getString(i++);
                LocalDateTime Fecha_Del_partido = resultSet.getTimestamp(i++).toLocalDateTime();
                Float Precio_Partido = resultSet.getFloat(i++);
                int Unidades_disponibles = resultSet.getInt(i++);
                LocalDateTime Fecha_de_alta_del_partido = resultSet.getTimestamp(i++).toLocalDateTime();
                int Entradas_vendidas_del_partido = resultSet.getInt(i);

                partidos.add(new Partido(PartidoId, Equipo_Visitante, Fecha_Del_partido, Precio_Partido, Unidades_disponibles, Fecha_de_alta_del_partido, Entradas_vendidas_del_partido));
            }


            return partidos;

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    @Override
    public void update(Connection connection, Partido partido) throws InstanceNotFoundException {

        String queryString = "UPDATE Partido SET " +
                "Equipo_Visitante = ? , Fecha_Del_partido = ? , Precio_Partido = ? , " +
                "Unidades_disponibles = ? , " +
                "Entradas_vendidas_del_partido = ?  " +
                " WHERE PartidoId = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
            int i = 1;
            preparedStatement.setString(i++, partido.getEquipo_Visitante());
            preparedStatement.setDate(i++,
                    Date.valueOf(partido.getFecha_Del_partido().toLocalDate()));
            preparedStatement.setFloat(i++, partido.getPrecio_Partido());
            preparedStatement.setInt(i++, partido.getUnidades_disponibles());
            preparedStatement.setInt(i++, partido.getEntradas_vendidas_del_partido());
            preparedStatement.setLong(i++, partido.getPartidoId());

            int updatedRows = preparedStatement.executeUpdate();

            if (updatedRows == 0) {
                throw new InstanceNotFoundException(partido.getPartidoId(),
                        Partido.class.getName());
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


    }

    @Override
    public void remove(Connection connection, Long PartidoId) throws InstanceNotFoundException {
        String queryString =
                "DELETE FROM Partido WHERE PartidoId = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
            int i = 1;
            preparedStatement.setLong(i++, PartidoId);

            int removedRows = preparedStatement.executeUpdate();

            if (removedRows == 0) {
                throw new InstanceNotFoundException(PartidoId, Partido.class.getName());
            }
        }
        catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<Partido> BuscarPartidoPorEntradas(Connection connection, Long Numero_Entradas, LocalDateTime Fecha_Inicio, LocalDateTime Fecha_Fin) {
        String queryString = "SELECT PartidoId, Equipo_Visitante, Fecha_Del_partido, Precio_Partido, Unidades_disponibles, Fecha_de_alta_del_partido, Entradas_vendidas_del_partido FROM Partido WHERE Unidades_Disponibles < ? AND Fecha_Del_partido BETWEEN ? AND ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
            int i = 1;
            preparedStatement.setLong(i++, Numero_Entradas);
            preparedStatement.setTimestamp(i++, Timestamp.valueOf(Fecha_Inicio));
            preparedStatement.setTimestamp(i, Timestamp.valueOf(Fecha_Fin));

            ResultSet resultSet = preparedStatement.executeQuery();

            List<Partido> partidos = new ArrayList<>();

            while (resultSet.next()) {
                i = 1;
                Long PartidoId = resultSet.getLong(i++);
                String Equipo_Visitante = resultSet.getString(i++);
                LocalDateTime Fecha_Del_partido = resultSet.getTimestamp(i++).toLocalDateTime();
                Float Precio_Partido = resultSet.getFloat(i++);
                int Unidades_disponibles = resultSet.getInt(i++);
                LocalDateTime Fecha_de_alta_del_partido = resultSet.getTimestamp(i++).toLocalDateTime();
                int Entradas_vendidas_del_partido = resultSet.getInt(i);

                partidos.add(new Partido(PartidoId, Equipo_Visitante, Fecha_Del_partido, Precio_Partido, Unidades_disponibles, Fecha_de_alta_del_partido, Entradas_vendidas_del_partido));
            }


            return partidos;

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<Partido> BuscarPartidoPorEntradas(Connection connection, Long Numero_Entradas) {
        String queryString = "SELECT PartidoId, Equipo_Visitante, Fecha_Del_partido, Precio_Partido, Unidades_disponibles, Fecha_de_alta_del_partido, Entradas_vendidas_del_partido FROM Partido WHERE Unidades_Disponibles < ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
            int i = 1;
            preparedStatement.setLong(i++, Numero_Entradas);

            ResultSet resultSet = preparedStatement.executeQuery();

            List<Partido> partidos = new ArrayList<>();

            while (resultSet.next()) {
                i = 1;
                Long PartidoId = resultSet.getLong(i++);
                String Equipo_Visitante = resultSet.getString(i++);
                LocalDateTime Fecha_Del_partido = resultSet.getTimestamp(i++).toLocalDateTime();
                Float Precio_Partido = resultSet.getFloat(i++);
                int Unidades_disponibles = resultSet.getInt(i++);
                LocalDateTime Fecha_de_alta_del_partido = resultSet.getTimestamp(i++).toLocalDateTime();
                int Entradas_vendidas_del_partido = resultSet.getInt(i);

                partidos.add(new Partido(PartidoId, Equipo_Visitante, Fecha_Del_partido, Precio_Partido, Unidades_disponibles, Fecha_de_alta_del_partido, Entradas_vendidas_del_partido));
            }


            return partidos;

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
