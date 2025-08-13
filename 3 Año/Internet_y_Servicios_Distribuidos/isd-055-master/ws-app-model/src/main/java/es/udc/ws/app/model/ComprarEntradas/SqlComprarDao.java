package es.udc.ws.app.model.ComprarEntradas;
import es.udc.ws.app.model.PartidoService.exceptions.IncorrectTarjetaCreditoException;
import es.udc.ws.util.exceptions.InputValidationException;
import es.udc.ws.util.exceptions.InstanceNotFoundException;
import java.sql.Connection;
import java.util.List;
public interface SqlComprarDao {

    public Comprar Create (Connection connection, Comprar comprar) ;

    public Comprar Buscar_entrada_id (Connection connection, Long entradaid)
            throws InstanceNotFoundException;

    public void remove(Connection connection, Long entradaId)
            throws InstanceNotFoundException;

    public List<Comprar>  Buscar_Todas_las_Compras_Usuario (Connection connection, String Correo);
    public void remove_From_Partido(Connection connection, Long partido) throws InstanceNotFoundException;

    public Comprar Marcar_Entrada(Connection connection, Long EntradaId, String Tarjeta_de_credito) throws IncorrectTarjetaCreditoException;


    void update(Connection connection, Comprar compra) throws InstanceNotFoundException;
}
