package es.udc.ws.app.model.PartidoService;

import es.udc.ws.app.model.ComprarEntradas.Comprar;
import es.udc.ws.app.model.ComprarEntradas.SqlComprarDao;
import es.udc.ws.app.model.ComprarEntradas.SqlComprarDaoFactory;
import es.udc.ws.app.model.Partido.Partido;
import es.udc.ws.app.model.Partido.SqlPartidoDao;
import es.udc.ws.app.model.Partido.SqlPartidoDaoFactory;
import es.udc.ws.app.model.PartidoService.exceptions.*;
import es.udc.ws.util.exceptions.InputValidationException;
import es.udc.ws.util.exceptions.InstanceNotFoundException;
import es.udc.ws.util.sql.DataSourceLocator;
import es.udc.ws.util.validation.PropertyValidator;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;

import static es.udc.ws.app.model.util.ModelConstants.APP_DATA_SOURCE;

public class PartidoServiceImpl implements PartidoService {
    private final DataSource dataSource;
    private SqlPartidoDao sqlPartidoDao = null;
    private SqlComprarDao sqlComprarDao = null;

    public PartidoServiceImpl() {
        dataSource = DataSourceLocator.getDataSource(APP_DATA_SOURCE);
        sqlPartidoDao = SqlPartidoDaoFactory.getDao();
        sqlComprarDao = SqlComprarDaoFactory.getDao();
    }

    private void validateId(Long id) throws InputValidationException {
        if (id == null) {
            throw new InputValidationException("Invalid id value (must be a number greater than 0)");
        }
        if (id == 0) {
            throw new InputValidationException("Invalid id value (must be greater than 0)");
        }
        PropertyValidator.validateNotNegativeLong("id", id);
    }

    private void validateAddPartido(Partido e)
            throws InputValidationException {
        PropertyValidator.validateMandatoryString(
                "Equipo_Visitante", e.getEquipo_Visitante());

        LocalDateTime fechapartido = e.getFecha_Del_partido();
        LocalDateTime regDate = e.getFecha_de_alta_del_partido();

        if (regDate.isAfter(fechapartido)) {
            throw new InputValidationException(
                    "Fechas inválidas: initCelebrationDate > registerDate , the date has already passed\n");
        }
        if (fechapartido.isBefore(regDate)) {
            throw new InputValidationException("Fechas inválidas:  Init date cant be before register date");
        }
        if (e.getPrecio_Partido()<=0) throw new InputValidationException("No se puede añadir un precio negativo.");
        // Comprobar que no añada un numero de entradas disponible 0 o menor
        if (e.getUnidades_disponibles()<=0) throw new InputValidationException("No se puede añadir un numero de entradas disponible 0 o menor.");

    }

    @Override
    public Partido CrearPartido(Partido partido) throws InputValidationException {
        validateAddPartido(partido);

        try (Connection connection = dataSource.getConnection()) {
            try {
                connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
                connection.setAutoCommit(false);
                Partido createdEvent = sqlPartidoDao.Create(connection, partido);
                connection.commit();
                return createdEvent;

            } catch (SQLException e) {
                connection.rollback();
                throw new RuntimeException(e);
            } catch (RuntimeException | Error e) {
                connection.rollback();
                throw e;
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Partido BuscarPartidoPorId(long PartidoId) throws InstanceNotFoundException {
        //Para obtener el partido por id necesitamos el metodo de sqlPartidoDao
        try (Connection connection = dataSource.getConnection()) {
            try {
                return sqlPartidoDao.BuscarPartidoPorId(connection, PartidoId);
            } catch (InstanceNotFoundException e) {
                throw new InstanceNotFoundException((Object) sqlPartidoDao, Partido.class.getName());
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public List<Partido> BuscarPartidoPorFecha(LocalDateTime Fecha_Inicio, LocalDateTime Fecha_Fin) throws InputValidationException {
        try (Connection connection = dataSource.getConnection()) {
                return sqlPartidoDao.BuscarPartidoPorFecha(connection, Fecha_Inicio, Fecha_Fin);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    @Override
    public List<Partido> BuscarPartidosNoCelebrados(Long Unidades, LocalDateTime Fecha_Fin) throws InputValidationException {
        LocalDateTime now = LocalDateTime.now();
        try (Connection connection = dataSource.getConnection()) {
            if (Fecha_Fin == null) {
                return sqlPartidoDao.BuscarPartidoPorEntradas(connection,Unidades);
            }
            //if (Fecha_Inicio.isBefore(now)) throw new FechaIncorrecta(Fecha_Inicio,now);
            if (Fecha_Fin.isBefore(now)) throw new FechaIncorrecta(Fecha_Fin,now);
            if (Unidades<0) throw new InputValidationException("Unidades entradas negativas");
            return sqlPartidoDao.BuscarPartidoPorEntradas(connection, Unidades, LocalDateTime.now(), Fecha_Fin);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }


    @Override
    public Comprar ComprarEntradas(  String correo, String tarjeta_de_credito, int unidades_a_comprar, LocalDateTime fecha_de_compra, Long partidoId, boolean entrada_Marcada) throws InputValidationException, NotEnoughUnidadesException, EntradaNotAvaliableException, IncorrectTarjetaCreditoException , InstanceNotFoundException{
        try (Connection connection = dataSource.getConnection()) {
            try {
                connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
                connection.setAutoCommit(false);
                Partido partido = sqlPartidoDao.BuscarPartidoPorId(connection, partidoId);
                if (partido.getUnidades_disponibles() < unidades_a_comprar){
                    System.out.println("Unidades disp" + partido.getUnidades_disponibles());
                    System.out.println("Unidades a comprar" + unidades_a_comprar);

                    throw new NotEnoughUnidadesException(partido.getUnidades_disponibles(), unidades_a_comprar);
                }


                if (partido.getFecha_Del_partido().isBefore(LocalDateTime.now()))
                    throw new EntradaNotAvaliableException(partidoId);

                // Valida que la tarjeta tenga 16 digitos
                if (tarjeta_de_credito.length() != 16) throw new IncorrectTarjetaCreditoException(tarjeta_de_credito, partidoId);

                //Valida que el numero de entradas a comprar sea mayor que 0
                if (unidades_a_comprar <= 0) throw new InputValidationException("El numero de entradas a comprar debe ser mayor que 0.");
                //Valida el Correo
                if (!correo.matches("^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\\.([a-zA-Z]{2,4})+$"))
                    throw new InputValidationException("Introduce un correo válido.");

                Comprar entrada = new Comprar( correo, tarjeta_de_credito, unidades_a_comprar, fecha_de_compra, partidoId, entrada_Marcada);
                Comprar Entrada = sqlComprarDao.Create(connection, entrada);
                partido.setUnidades_disponibles(partido.getUnidades_disponibles() - unidades_a_comprar);
                partido.setEntradas_vendidas_del_partido(partido.getEntradas_vendidas_del_partido() + unidades_a_comprar);
                sqlPartidoDao.update(connection, partido);
                connection.commit();
                return Entrada;
            } catch (InstanceNotFoundException | RuntimeException | Error e) {
                connection.rollback();
                throw e;
            }
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    @Override
    public List<Comprar> Buscar_Todas_las_Compras_Usuario(String Correo) throws InputValidationException{
        if(!Correo.contains("@")) throw new InputValidationException("Introduce un correo válido.");
        try (Connection connection = dataSource.getConnection()) {
            return sqlComprarDao.Buscar_Todas_las_Compras_Usuario(connection, Correo);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    @Override
    public Comprar Marcar_Entrada(long EntradaId, String Tarjeta_de_credito) throws
             InstanceNotFoundException, EntradaMarcadaException, IncorrectTarjetaCreditoException{
        try (Connection connection = dataSource.getConnection()) {
            Comprar entrada = sqlComprarDao.Buscar_entrada_id(connection, EntradaId);
            if (!entrada.getTarjeta_de_credito().equals(Tarjeta_de_credito))
                throw new IncorrectTarjetaCreditoException(Tarjeta_de_credito, EntradaId);
            // Excepcion si la entrada ya esta marcada
            if (entrada.isEntrada_Marcada()) throw new EntradaMarcadaException();

            try {
                sqlComprarDao.Buscar_entrada_id(connection, EntradaId);
            } catch (InstanceNotFoundException e) {
                throw new InstanceNotFoundException(EntradaId, Comprar.class.getName());
            }
            return sqlComprarDao.Marcar_Entrada(connection, EntradaId, Tarjeta_de_credito);
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    // TODO Error management // thrnow error_not_removable
    // Duda, como gestion de dependencias / fecha? preguntar profesorq
    @Override
    public void EliminarPartidoCelebrado(Long partido) throws InputValidationException, InstanceNotFoundException{
        System.out.println("Enter eliminate partido");
        if (partido== null|| partido<0) throw new InputValidationException("Unidades entrada <1");
        try (Connection connection = dataSource.getConnection()) {
            try {

                connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
                connection.setAutoCommit(false);
                Partido removed = sqlPartidoDao.BuscarPartidoPorId(connection,partido);
                //System.out.println(removed.getPartidoId());
                LocalDateTime now =LocalDateTime.now();
                if (removed!=null && removed.getFecha_Del_partido().isBefore(now)){
                    sqlComprarDao.remove_From_Partido(connection,partido);
                    sqlPartidoDao.remove(connection, partido);
                }
                else {
                    assert removed != null;
                    throw new FechaIncorrecta(removed.getFecha_Del_partido(),now);
                }
                connection.commit();
            } catch (SQLException e) {
                connection.rollback();
                throw new RuntimeException(e);
            } catch (RuntimeException | Error e) {
                connection.rollback();
                throw e;
            } catch (InstanceNotFoundException e) {
                // TODO Correct runtime
                throw new InstanceNotFoundException(e, "No existe este partido");
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }


/*
*

    @Override
    public void remove_Celebrados(Connection connection) {
        String queryString =
                "DELETE FROM Partido WHERE Fecha_del_partido < ?";
        try (PreparedStatement preparedStatement = connection.prepareStatement(queryString)) {
            int i = 1;
            preparedStatement.setTimestamp(i,Timestamp.valueOf(LocalDateTime.now()));

            int removedRows = preparedStatement.executeUpdate();

        }
        catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
* */
}