package es.udc.ws.app.model.ComprarEntradas;

import java.sql.*;
import java.time.LocalDateTime;

public class Jdbc3CcSqlComprarDao extends AbstractSqlComprarDao {
    @Override
    public Comprar Create(Connection connection, Comprar comprar)  {
        String queryString = "INSERT INTO comprar_entradas" +
                "(Correo,Tarjeta_de_credito,Unidades_a_comprar,Fecha_de_compra,partidoId,Entrada_Marcada)" +
                " VALUES (?, ?, ?, ?, ?, ?)";
        try (PreparedStatement preparedStatement = connection.prepareStatement(queryString,
                Statement.RETURN_GENERATED_KEYS)) {
            int i = 1;

            preparedStatement.setString(i++, comprar.getCorreo());
            preparedStatement.setString(i++, comprar.getTarjeta_de_credito());
            preparedStatement.setInt(i++, comprar.getUnidades_a_comprar());
            preparedStatement.setTimestamp(i++, Timestamp.valueOf(LocalDateTime.now()));
            preparedStatement.setLong(i++, comprar.getPartidoId());
            preparedStatement.setBoolean(i++, comprar.isEntrada_Marcada());
            preparedStatement.executeUpdate();

            ResultSet resultSet = preparedStatement.getGeneratedKeys();

            if (!resultSet.next()) {
                throw new SQLException(
                        "JDBC driver did not return generated key.");
            }
            Long EntradaId = resultSet.getLong(1);

            return new Comprar(EntradaId,
                    comprar.getCorreo(), comprar.getTarjeta_de_credito(),
                    comprar.getUnidades_a_comprar(), comprar.getFecha_de_compra(),
                    comprar.getPartidoId(),comprar.isEntrada_Marcada());

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }



}
