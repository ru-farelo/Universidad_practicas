package es.udc.ws.app.model.ComprarEntradas;

import es.udc.ws.app.model.PartidoService.exceptions.IncorrectTarjetaCreditoException;
import es.udc.ws.util.exceptions.InstanceNotFoundException;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.time.LocalDateTime;

public abstract class AbstractSqlComprarDao implements SqlComprarDao{
    @Override
    public Comprar Buscar_entrada_id(Connection connection, Long entradaId) throws InstanceNotFoundException {
        String queryString =
                "SELECT Correo, Tarjeta_de_credito, Unidades_a_comprar, Fecha_de_compra, partidoId, Entrada_Marcada " +
                        "FROM comprar_entradas " +
                        "WHERE EntradaId = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
            int i = 1;
            preparedStatement.setLong(i++, entradaId);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (!resultSet.next())
                throw new InstanceNotFoundException(entradaId, Comprar.class.getName());

            i = 1;
            String correo = resultSet.getString(i++);
            String tarjetaCredito = resultSet.getString(i++);
            int unidadesComprar = resultSet.getInt(i++);
            Timestamp fechaCompraAsTimeStamp = resultSet.getTimestamp(i++);
            LocalDateTime fechaCompra = fechaCompraAsTimeStamp.toLocalDateTime();
            Long partidoId = resultSet.getLong(i++);
            boolean entradaMarcada = resultSet.getBoolean(i++);

            return new Comprar(entradaId,correo, tarjetaCredito, unidadesComprar, fechaCompra, partidoId, entradaMarcada);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
        @Override
        public void remove (Connection connection, Long entradaId) throws InstanceNotFoundException {
            String queryString = "DELETE FROM comprar_entradas WHERE EntradaId = ?";
            try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
                int i = 1;
                preparedStatement.setLong(i++, entradaId);

                int removedRows = preparedStatement.executeUpdate();

                if (removedRows == 0) {
                    throw new InstanceNotFoundException(entradaId, Comprar.class.getName());
                }
            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }

        @Override
        public List<Comprar> Buscar_Todas_las_Compras_Usuario (Connection connection, String Correo){
            String queryString = "SELECT entradaID, Correo, Tarjeta_de_credito, Unidades_a_comprar, Fecha_de_compra, partidoID, Entrada_Marcada FROM comprar_entradas WHERE Correo = ?";
            try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
                int i = 1;
                preparedStatement.setString(i, Correo);

                ResultSet resultSet = preparedStatement.executeQuery();

                List<Comprar> comprar = new ArrayList<>();

                while (resultSet.next()) {
                    i = 1;
                    Long entradaID = resultSet.getLong(i++);
                    String correo = resultSet.getString(i++);
                    String Tarjeta_de_credito = resultSet.getString(i++);
                    int Unidades_a_comprar = resultSet.getInt(i++);
                    LocalDateTime Fecha_de_compra = resultSet.getTimestamp(i++).toLocalDateTime();
                    Long partidoID = resultSet.getLong(i++);
                    Boolean Entrada_Marcada =resultSet.getBoolean(i++);

                    comprar.add(new Comprar(entradaID, correo, Tarjeta_de_credito, Unidades_a_comprar, Fecha_de_compra, partidoID, Entrada_Marcada));
                }

                return comprar;

            } catch (SQLException e) {
                throw new RuntimeException(e);
            }
        }
// Cambiar como se gestiona la tarjeta de credito
    @Override
    public Comprar Marcar_Entrada(Connection connection, Long EntradaId, String Tarjeta_de_credito) throws IncorrectTarjetaCreditoException {
        String queryString = "SELECT entradaID, Correo, Tarjeta_de_credito, Unidades_a_comprar, Fecha_de_compra, partidoID, Entrada_Marcada  FROM comprar_entradas WHERE Entradaid = ?";

        try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
            int i = 1;
            preparedStatement.setLong(i++, EntradaId);

            ResultSet resultSet = preparedStatement.executeQuery();

            if (!resultSet.next()) {
                throw new SQLException("Error obteniendo el número de entradas para el partido con id " + EntradaId);
            }
            i = 1;
            Long entradaID = resultSet.getLong(i++);
            String correo = resultSet.getString(i++);
            String Tarjeta_de_credito2 = resultSet.getString(i++);
            int Unidades_a_comprar = resultSet.getInt(i++);
            LocalDateTime Fecha_de_compra = resultSet.getTimestamp(i++).toLocalDateTime();
            Long partidoID = resultSet.getLong(i++);
            Boolean Entrada_Marcada =resultSet.getBoolean(i++);
            if (!Entrada_Marcada) entregadoupdate(connection,EntradaId,Tarjeta_de_credito2);
            return new Comprar(entradaID, correo, Tarjeta_de_credito2, Unidades_a_comprar, Fecha_de_compra, partidoID, true);
        }
        catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void entregadoupdate(Connection connection, Long EntradaId, String Tarjeta_de_credito){
        String queryString = "UPDATE comprar_entradas SET " +
                "Entrada_Marcada= ? " +
                " WHERE Entradaid = ? AND Tarjeta_de_credito = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
            int i = 1;
            preparedStatement.setBoolean(i++, true);
            preparedStatement.setLong(i++, EntradaId);
            preparedStatement.setString(i++, Tarjeta_de_credito);

            int updatedRows = preparedStatement.executeUpdate();

            if (updatedRows == 0) {
                throw new InstanceNotFoundException((EntradaId),
                        Comprar.class.getName());
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        } catch (InstanceNotFoundException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public void update(Connection connection, Comprar compra) throws InstanceNotFoundException {

        String queryString = "UPDATE comprar_entradas SET " +
                "Correo = ? , Tarjeta_de_credito = ? , Unidades_a_comprar = ?, " +
                "Fecha_de_compra = ? , partidoId = ? , Entrada_Marcada= ? " +
                " WHERE entradaID = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
            int i = 1;
            preparedStatement.setString(i++, compra.getCorreo());
            preparedStatement.setString(i++, compra.getTarjeta_de_credito());
            preparedStatement.setInt(i++, compra.getUnidades_a_comprar());
            preparedStatement.setDate(i++,
                    Date.valueOf(compra.getFecha_de_compra().toLocalDate()));
            preparedStatement.setLong(i++, compra.getPartidoId());
            preparedStatement.setBoolean(i++, compra.isEntrada_Marcada());

            int updatedRows = preparedStatement.executeUpdate();

            if (updatedRows == 0) {
                throw new InstanceNotFoundException((compra.getEntradaId()),
                        Comprar.class.getName());
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }


    }

    @Override
    public void remove_From_Partido(Connection connection, Long partido) throws InstanceNotFoundException {
        String queryString = "DELETE FROM comprar_entradas WHERE PartidoId = ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
            int i = 1;
            preparedStatement.setLong(i++, partido);

            int removedRows = preparedStatement.executeUpdate();

            if (removedRows == 0) {
                throw new InstanceNotFoundException(partido, Comprar.class.getName());
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}