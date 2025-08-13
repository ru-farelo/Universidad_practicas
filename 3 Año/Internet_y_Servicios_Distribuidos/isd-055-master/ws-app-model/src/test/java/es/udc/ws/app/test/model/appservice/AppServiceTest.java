package es.udc.ws.app.test.model.appservice;

import static es.udc.ws.app.model.util.ModelConstants.APP_DATA_SOURCE;
import static org.junit.jupiter.api.Assertions.*;

import es.udc.ws.app.model.ComprarEntradas.Comprar;
import es.udc.ws.app.model.ComprarEntradas.SqlComprarDao;
import es.udc.ws.app.model.ComprarEntradas.SqlComprarDaoFactory;
import es.udc.ws.app.model.Partido.*;
import es.udc.ws.app.model.PartidoService.PartidoService;
import es.udc.ws.app.model.PartidoService.PartidoServiceImpl;
import es.udc.ws.app.model.PartidoService.exceptions.EntradaMarcadaException;
import es.udc.ws.app.model.PartidoService.exceptions.EntradaNotAvaliableException;
import es.udc.ws.app.model.PartidoService.exceptions.IncorrectTarjetaCreditoException;
import es.udc.ws.app.model.PartidoService.exceptions.NotEnoughUnidadesException;
import es.udc.ws.util.exceptions.InputValidationException;
import es.udc.ws.util.exceptions.InstanceNotFoundException;
import es.udc.ws.util.sql.DataSourceLocator;
import es.udc.ws.util.sql.SimpleDataSource;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.Test;

import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.util.List;



public class AppServiceTest {
    private static PartidoService partidoService;
    private static SqlPartidoDao partidoDao;
    private static SqlComprarDao comprarDao;

    @BeforeAll
    public static void init() {
        DataSource dataSource = new SimpleDataSource();
        DataSourceLocator.addDataSource(APP_DATA_SOURCE, dataSource);
        partidoDao = SqlPartidoDaoFactory.getDao();
        comprarDao = SqlComprarDaoFactory.getDao();
        partidoService = new PartidoServiceImpl();
    }


    private void removePartido(Long partidoId) {
        DataSource dataSource = DataSourceLocator.getDataSource("ws-javaexamples-ds");
        try(Connection connection = dataSource.getConnection()) {
            try {
                connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
                connection.setAutoCommit(false);

                partidoDao.remove(connection, partidoId);

                connection.commit();

            } catch (InstanceNotFoundException e) {
                connection.commit();
                throw new RuntimeException(e);
            } catch (SQLException e) {
                connection.rollback();
                throw new RuntimeException(e);
            } catch (RuntimeException | Error e) {
                connection.rollback();
                throw e;
            }
        }catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void editarPartido(Partido partido){
        DataSource dataSource = DataSourceLocator.getDataSource("ws-javaexamples-ds");
        try(Connection connection = dataSource.getConnection()) {
            try {
                connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
                connection.setAutoCommit(false);

                partidoDao.update(connection, partido);

                connection.commit();

            } catch (InstanceNotFoundException e) {
                connection.commit();
                throw new RuntimeException(e);
            } catch (SQLException e) {
                connection.rollback();
                throw new RuntimeException(e);
            } catch (RuntimeException | Error e) {
                connection.rollback();
                throw e;
            }
        }catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    private void removeEntrada(Long EntradaId) {
        DataSource dataSource = DataSourceLocator.getDataSource("ws-javaexamples-ds");
        try(Connection connection = dataSource.getConnection()) {
            try {
                connection.setTransactionIsolation(Connection.TRANSACTION_SERIALIZABLE);
                connection.setAutoCommit(false);

                comprarDao.remove(connection, EntradaId);

                connection.commit();

            } catch (InstanceNotFoundException e) {
                connection.commit();
                throw new RuntimeException(e);
            } catch (SQLException e) {
                connection.rollback();
                throw new RuntimeException(e);
            } catch (RuntimeException | Error e) {
                connection.rollback();
                throw e;
            }
        }catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
    //FUNCIONALIDAD 1
    @Test
    public void testCrearPartido() throws InputValidationException {
        //Creacion de un partido
        Partido partido = new Partido(null, "Racing de Ferrol", LocalDateTime.parse("2024-12-03T10:15:30"), 20, 50, LocalDateTime.now(), 0);
        Partido createdPartido = null;

        //Creacion del partido en la base de datos
        createdPartido = partidoService.CrearPartido(partido);
        //Comprobacion de que el partido se ha creado
        assertNotNull(createdPartido.getPartidoId());

        //Comprobacion de que los datos del partido son correctos
        assertEquals(partido.getEquipo_Visitante(), createdPartido.getEquipo_Visitante());
        assertEquals(partido.getFecha_Del_partido(), createdPartido.getFecha_Del_partido());
        assertEquals(partido.getPrecio_Partido(), createdPartido.getPrecio_Partido());
        assertEquals(partido.getUnidades_disponibles(), createdPartido.getUnidades_disponibles());
        assertEquals(partido.getFecha_de_alta_del_partido(), createdPartido.getFecha_de_alta_del_partido());

        //Borrado del partido creado
        removePartido(createdPartido.getPartidoId());
    }
    @Test
    public void testCrearPartidoInvalido() {
        //Excepcion si la fecha del partido es anterior a la fecha de alta del partido
        Partido partidoInvalido = new Partido(null, "Racing de Ferrol",
                LocalDateTime.parse("2022-01-01T10:15:30"), 20, 50,
                LocalDateTime.now(), 0);
        try {
            assertThrows(InputValidationException.class,() -> partidoService.CrearPartido(partidoInvalido));
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }

    //FUNCIONALIDAD 2
    @Test
    public void testBuscarPartidoPorFecha() throws InputValidationException{
        //Creacion de fechas
        LocalDateTime now = LocalDateTime.now().plusDays(1);
        LocalDateTime future = now.plusDays(10);
        LocalDateTime future2 = now.plusDays(20);
        LocalDateTime future3 = now.plusDays(30);

        //Creacion de partidos
        Partido partido1 = new Partido(null, "Barcelona", now, 60, 75, LocalDateTime.now(), 0);
        Partido partido2 = new Partido(null, "Real Madrid", future, 70, 50, LocalDateTime.now(), 0);
        Partido partido3 = new Partido(null, "Atletico Madrid", future2, 50, 60, LocalDateTime.now(), 0);
        Partido partido4 = new Partido(null, "Betis", future3, 14, 60, LocalDateTime.now(), 0);

        //Creacion de partidos check(los que se van a buscar)
        Partido particdo1check = null;
        Partido particdo2check = null;
        Partido particdo3check = null;
        Partido particdo4check = null;

        //Creacion de partidos en la base de datos
        particdo1check = partidoService.CrearPartido(partido1);
        particdo2check = partidoService.CrearPartido(partido2);
        particdo3check = partidoService.CrearPartido(partido3);
        particdo4check = partidoService.CrearPartido(partido4);

        //Crea una lista con los partidos encontrados
        List<Partido> foundPartidos = partidoService.BuscarPartidoPorFecha(LocalDateTime.now(), future3.plusDays(1));
        List<Partido> foundPartidos2 = partidoService.BuscarPartidoPorFecha(LocalDateTime.now().plusYears(3), future3.plusYears(5));

        //Comprobacion de que los partidos encontrados son los que se han creado
        assertEquals(partido1.getEquipo_Visitante(),particdo1check.getEquipo_Visitante());
        assertEquals(partido2.getEquipo_Visitante(),particdo2check.getEquipo_Visitante());
        assertEquals(partido3.getEquipo_Visitante(),particdo3check.getEquipo_Visitante());
        assertEquals(partido4.getEquipo_Visitante(),particdo4check.getEquipo_Visitante());
        assertEquals(4, foundPartidos.size());

        //Borrado de los partidos creados
        removePartido(particdo1check.getPartidoId());
        removePartido(particdo2check.getPartidoId());
        removePartido(particdo3check.getPartidoId());
        removePartido(particdo4check.getPartidoId());
    }
    @Test
    public void testBuscarPartidoPorFechaInvalido(){
        LocalDateTime passed = LocalDateTime.now().minusDays(1);
        Partido partidoPasado = new Partido(null, "Barcelona", passed, 60, 75, LocalDateTime.now(), 0);
        //Excepcion con la fecha pasada
        assertThrows(InputValidationException.class,() -> partidoService.CrearPartido(partidoPasado));

        //Excepcion si equipo visitante es null
        Partido partidoNull = new Partido(null, null, LocalDateTime.now(), 60, 75, LocalDateTime.now(), 0);
        assertThrows(InputValidationException.class,() -> partidoService.CrearPartido(partidoNull));

        //Excepcion si precio partido es negativo
        Partido partidoNegativo = new Partido(null, "Barcelona", LocalDateTime.now(), -60, 75, LocalDateTime.now(), 0);
        assertThrows(InputValidationException.class,() -> partidoService.CrearPartido(partidoNegativo));
    }

    //FUNCIONALIDAD 3
    @Test
    public void testBuscarPartidoPorId() throws InputValidationException, InstanceNotFoundException {
        //Creacion de un partido
        Partido partido = new Partido(null, "Real Madrid", LocalDateTime.now().plusDays(7), 50, 100, LocalDateTime.now(), 0);
        Partido createdPartido = null;

        //Creacion del partido en la base de datos
        createdPartido = partidoService.CrearPartido(partido);

        //Comprobacion de que el partido se ha creado
        assertNotNull(createdPartido.getPartidoId());

        //Comprobacion del partido encontrado en la base de datos
        Partido foundPartido = partidoService.BuscarPartidoPorId(createdPartido.getPartidoId());

        //Comprobacion de que los datos del partido son correctos
        assertEquals(createdPartido.getEquipo_Visitante(), foundPartido.getEquipo_Visitante());
        assertEquals(createdPartido.getFecha_Del_partido().withSecond(0).withNano(0), foundPartido.getFecha_Del_partido().withSecond(0));
        assertEquals(createdPartido.getPrecio_Partido(), foundPartido.getPrecio_Partido());
        assertEquals(createdPartido.getUnidades_disponibles(), foundPartido.getUnidades_disponibles());
        assertEquals(createdPartido.getFecha_de_alta_del_partido().withSecond(0).withNano(0), foundPartido.getFecha_de_alta_del_partido().withSecond(0));

        //Borrado del partido creado
        removePartido(createdPartido.getPartidoId());
    }

    @Test
    public void testBuscarPartidoPorIdInvalido() {
        //Excepcion si el id es 0, negativo o no existe
        assertThrows(InstanceNotFoundException.class,() -> partidoService.BuscarPartidoPorId(51251L));
        assertThrows(InstanceNotFoundException.class,() -> partidoService.BuscarPartidoPorId(0L));
        assertThrows(InstanceNotFoundException.class,() -> partidoService.BuscarPartidoPorId(-1L));
    }


    //FUNCIONALIDAD 4
    @Test
    public void testComprarEntradas() throws
            InputValidationException, InstanceNotFoundException, NotEnoughUnidadesException, IncorrectTarjetaCreditoException, EntradaNotAvaliableException {

        //Creacion de un partido
        Partido partido = new Partido(null, "Sevilla FC", LocalDateTime.now().plusDays(5), 40, 80, LocalDateTime.now(), 0);
        Partido createdPartido = null;
        Comprar compra = null;

        //Creacion del partido en la base de datos
        createdPartido = partidoService.CrearPartido(partido);

        //Comprobacion de que el partido se ha creado
        assertNotNull(createdPartido.getPartidoId());

        //Creacion de una compra
        compra = partidoService.ComprarEntradas("user@example.com", "1234567898765432", 3, LocalDateTime.now(), createdPartido.getPartidoId(), false);

        //Comprobacion de que la compra se ha creado
        assertNotNull(compra.getEntradaId());
        assertEquals("user@example.com", compra.getCorreo());
        assertEquals(3, compra.getUnidades_a_comprar());
        assertFalse(compra.isEntrada_Marcada());

        //Borrado de la compra creada y del partido creado
        removeEntrada(compra.getEntradaId());
        removePartido(createdPartido.getPartidoId());
    }
    //Falta actualizar en base datos el numero de entradas disponibles

    @Test
    public void testComprarEntradasInputInvalido() throws InputValidationException{
        //Creacion de un partido
        Partido partido = new Partido(null, "Sevilla FC", LocalDateTime.now().plusDays(5), 40, 80, LocalDateTime.now(), 0);
        //Creacion del partido en la base de datos
        Partido createdPartido = partidoService.CrearPartido(partido);

        //Excepcion si el correo es null
        assertThrows(NullPointerException.class,() -> partidoService.ComprarEntradas(null, "1234567898765432", 3, LocalDateTime.now(), createdPartido.getPartidoId(), false));

        //Excepcion si el correo es vacio
        assertThrows(InputValidationException.class,() -> partidoService.ComprarEntradas("", "1234567898765432", 3, LocalDateTime.now(), createdPartido.getPartidoId(), false));

        //Excepcion si el correo no es valido
        assertThrows(InputValidationException.class,() -> partidoService.ComprarEntradas("userexample.com", "1234567898765432", 3, LocalDateTime.now(), createdPartido.getPartidoId(), false));
        //Eliminamo partido
        removePartido(createdPartido.getPartidoId());
    }

    @Test
    public void testComprarEntradasIncorrectTarjetaCredito() throws InputValidationException {
        //Creacion de un partido
        Partido partido = new Partido(null, "Sevilla FC", LocalDateTime.now().plusDays(5), 40, 80, LocalDateTime.now(), 0);
        //Creacion del partido en la base de datos
        Partido createdPartido = partidoService.CrearPartido(partido);

        //Excepcion si la tarjeta de credito es 0, negativa o tiene mas de 16 digitos
        assertThrows(IncorrectTarjetaCreditoException.class,() -> partidoService.ComprarEntradas("user@example.com", "0", 3, LocalDateTime.now(),createdPartido.getPartidoId(),false));
        assertThrows(IncorrectTarjetaCreditoException.class,() -> partidoService.ComprarEntradas("user@example.com", "-1", 3,LocalDateTime.now() ,createdPartido.getPartidoId(),false));
        assertThrows(IncorrectTarjetaCreditoException.class,() -> partidoService.ComprarEntradas("user@example.com", "4124124", 3,LocalDateTime.now() , createdPartido.getPartidoId(),false));

        //Por ultimo eliminamos el partido creado
        removePartido(createdPartido.getPartidoId());
    }

    @Test
    public void testComprarEntradasNotAvaliable() throws InputValidationException{
        //Creacion de un partido
        Partido partido = new Partido(null, "Sevilla FC", LocalDateTime.now().plusHours(1), 40, 80, LocalDateTime.now(), 0);
        //Creacion del partido en la base de datos
        Partido createdPartido = partidoService.CrearPartido(partido);
        //Actualizamos la fecha del partido a un dia que ya transcurrio
        createdPartido.setFecha_Del_partido(LocalDateTime.now().minusDays(1));
        //Actualizamos la base con el nuevo partido
        editarPartido(createdPartido);

        //Excepcion si el partido ya ha pasado
        assertThrows(EntradaNotAvaliableException.class,() -> partidoService.ComprarEntradas("user@example.com", "1234567898765432", 3,LocalDateTime.now(), createdPartido.getPartidoId(),false));
        //Eliminamos de la base de datos el partido
        removePartido(createdPartido.getPartidoId());
    }

    @Test
    public void testComprarEntradasUnidadesInsuficientes() throws InputValidationException {
        //Creacion de un partido
        Partido partido = new Partido(null, "Sevilla FC", LocalDateTime.now().plusDays(5), 40, 1, LocalDateTime.now(), 0);
        //Creacion del partido en la base de datos
        Partido createdPartido = partidoService.CrearPartido(partido);

        //Excepcion si las unidades a comprar son 0, negativas o superan las unidades disponibles
        assertThrows(NotEnoughUnidadesException.class, () -> partidoService.ComprarEntradas("user@example.com", "1234567898765432", 10,LocalDateTime.now(), createdPartido.getPartidoId(),false));
        assertThrows(InputValidationException.class, () -> partidoService.ComprarEntradas("user@example.com", "1234567898765432", -1, LocalDateTime.now(),createdPartido.getPartidoId(),false));
        //Eliminamos partido de la base de datos
        removePartido(createdPartido.getPartidoId());
    }

    //FUNCIONALIDAD 5
    @Test
    public void testBuscarTodasLasComprasUsuario()
            throws InputValidationException, InstanceNotFoundException, EntradaNotAvaliableException, NotEnoughUnidadesException, IncorrectTarjetaCreditoException {
        //Creamos partido y declaramos las compras
        Partido partido = new Partido(null, "Valencia CF", LocalDateTime.now().plusDays(8), 45, 90, LocalDateTime.now(), 0);
        Partido createdPartido=null;
        Comprar compra1 = null;
        Comprar compra2 = null;

        //Creamos el partido dentro de la base de datos
        createdPartido = partidoService.CrearPartido(partido);
        assertNotNull(createdPartido.getPartidoId());

        //Metemos en la base de entradas las 2 compras
        compra1 = partidoService.ComprarEntradas("user@example.com", "1234567898765432", 4, LocalDateTime.now(), createdPartido.getPartidoId(), false);
        compra2 = partidoService.ComprarEntradas("user@example.com", "1234567898765432", 2, LocalDateTime.now(), createdPartido.getPartidoId(), false);

        //Creamos una lista de compras
        List<Comprar> compras = partidoService.Buscar_Todas_las_Compras_Usuario("user@example.com");
        //Comprobamos que el numero total de compras es 2
        assertEquals(2, compras.size());

        //Eliminamos las entradas y el partido de las bases de datos
        removeEntrada(compra1.getEntradaId());
        removeEntrada(compra2.getEntradaId());
        removePartido(createdPartido.getPartidoId());
    }

    @Test
    public void testBuscarComprasInvalidas() throws InstanceNotFoundException,InputValidationException,IncorrectTarjetaCreditoException,NotEnoughUnidadesException,EntradaNotAvaliableException{
        Partido partido = new Partido(null, "Valencia CF", LocalDateTime.now().plusDays(8), 45, 90, LocalDateTime.now(), 0);
        Partido createdPartido=null;
        Comprar compra1 = null;
        Comprar compra2 = null;

        //Creamos el partido dentro de la base de datos
        createdPartido = partidoService.CrearPartido(partido);
        assertNotNull(createdPartido.getPartidoId());

        //Metemos en la base de entradas las 2 compras
        compra1 = partidoService.ComprarEntradas("user@example.com", "1234567898765432", 4,LocalDateTime.now() ,createdPartido.getPartidoId(),false);
        compra2 = partidoService.ComprarEntradas("user@example.com", "1234567898765432", 2, LocalDateTime.now(),createdPartido.getPartidoId(),false);

        //No se pasa el correo
        assertThrows(InputValidationException.class,() -> partidoService.Buscar_Todas_las_Compras_Usuario(""));

        //Correo no se corresponde con el formato standar , le falta el @
        assertThrows(InputValidationException.class,() -> partidoService.Buscar_Todas_las_Compras_Usuario("wafaogin"));

        //Eliminamo partido
        removePartido(createdPartido.getPartidoId());
    }

    //FUNCIONALIDAD 6
    @Test
    public void testMarcarEntrada() throws InputValidationException, InstanceNotFoundException,
            NotEnoughUnidadesException, IncorrectTarjetaCreditoException,EntradaNotAvaliableException, EntradaMarcadaException {
        //Crea partido
        Partido partido = new Partido(null, "Valencia CF", LocalDateTime.now().plusDays(8), 45, 90, LocalDateTime.now(), 0);
        //Se añade partido a la base de datos
        Partido createdPartido = null;
        createdPartido = partidoService.CrearPartido(partido);
        //Se comprueba que se ha creado correctamente
        assertNotNull(createdPartido.getPartidoId());

        //Crea una entrada y la añade a la base de datos
        Comprar compra = partidoService.ComprarEntradas("user@example.com", "1234567898765432", 1, LocalDateTime.now(), createdPartido.getPartidoId(), false);

        // Marca la entrada como usada
        Comprar marcado=partidoService.Marcar_Entrada(compra.getEntradaId(), "1234567898765432");
        assertTrue(marcado.isEntrada_Marcada());
        //Elimina el partido y la entrada
        removeEntrada(marcado.getEntradaId());
        removePartido(createdPartido.getPartidoId());
    }

    @Test
    public void testMarcarEntradaInvalidCard() throws InputValidationException, InstanceNotFoundException, EntradaNotAvaliableException,NotEnoughUnidadesException,IncorrectTarjetaCreditoException {
        //Se crea el partido
        Partido partido = new Partido(null, "Valencia CF", LocalDateTime.now().plusDays(8), 45, 90, LocalDateTime.now(), 0);

        //Se añade a la base de datos
        Partido createdPartido = null;
        createdPartido = partidoService.CrearPartido(partido);

        //Se verifica que el id no es null
        assertNotNull(createdPartido.getPartidoId());

        //Se crea una entrada y se añade a la base de datos
        Comprar compra = partidoService.ComprarEntradas("user@example.com", "1234567898765432", 1, LocalDateTime.now(),createdPartido.getPartidoId(),false);

        // Comprobamos si la tarjeta de credito no se corresponde con un formato valido
        assertThrows(IncorrectTarjetaCreditoException.class, () -> partidoService.Marcar_Entrada(compra.getEntradaId(), "0000000000"));

        //Eliminamos el partido creado
        removePartido(createdPartido.getPartidoId());
    }
}


