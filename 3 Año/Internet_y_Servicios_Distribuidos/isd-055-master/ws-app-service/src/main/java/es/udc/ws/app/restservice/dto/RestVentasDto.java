package es.udc.ws.app.restservice.dto;

import java.time.LocalDateTime;

public class RestVentasDto {
    private Long idEntrada;
    private String correoUsuario;
    private String tarjetaCredito4digitos;
    private int unidadesAComprar;
    private LocalDateTime Fecha_de_compra;
    private Long partidoId;
    private boolean Entrada_Marcada;


    public RestVentasDto() {
    }

    public RestVentasDto(Long idEntrada ,String correoUsuario, String tarjetaCredito4digitos, int unidadesAComprar, LocalDateTime Fecha_de_compra, Long partidoId, boolean Entrada_Marcada) {
        this.idEntrada = idEntrada;
        this.correoUsuario = correoUsuario;
        this.tarjetaCredito4digitos = tarjetaCredito4digitos;
        this.unidadesAComprar = unidadesAComprar;
        this.Fecha_de_compra = Fecha_de_compra;
        this.partidoId = partidoId;
        this.Entrada_Marcada = Entrada_Marcada;
    }



    public Long getIdEntrada() {
        return idEntrada;
    }

    public void setIdEntrada(Long idEntrada) {
        this.idEntrada = idEntrada;
    }

    public String getCorreoUsuario() {
        return correoUsuario;
    }

    public void setCorreoUsuario(String correoUsuario) {
        this.correoUsuario = correoUsuario;
    }


    public String getTarjetaCredito4digitos() {
        String tarjetaCredito4digitosOculto = "";
        tarjetaCredito4digitosOculto += tarjetaCredito4digitos.substring(tarjetaCredito4digitos.length()-4);
        return tarjetaCredito4digitosOculto;
    }

    public void setTarjetaCredito4digitos(String tarjetaCredito4digitos) {
        this.tarjetaCredito4digitos = tarjetaCredito4digitos;
    }

    public int getUnidadesAComprar() {
        return unidadesAComprar;
    }

    public void setUnidadesAComprar(int unidadesAComprar) {
        this.unidadesAComprar = unidadesAComprar;
    }

    public LocalDateTime getFecha_de_compra() {
        return Fecha_de_compra;
    }

    public void setFecha_de_compra(LocalDateTime fecha_de_compra) {
        Fecha_de_compra = fecha_de_compra;
    }

    public Long getPartidoId() {
        return partidoId;
    }

    public void setPartidoId(Long partidoId) {
        this.partidoId = partidoId;
    }

    public boolean isEntrada_Marcada() {
        return Entrada_Marcada;
    }

    public void setEntrada_Marcada(boolean entrada_Marcada) {
        Entrada_Marcada = entrada_Marcada;
    }

    @Override
    public String toString() {
        return "RestComprarEntradaDto{" +
                "idEntrada=" + idEntrada +
                ", correoUsuario='" + correoUsuario + '\'' +
                ", tarjetaCredito4digitos='" + tarjetaCredito4digitos + '\'' +
                ", unidadesAComprar=" + unidadesAComprar +
                ", Fecha_de_compra=" + Fecha_de_compra +
                ", partidoId=" + partidoId +
                ", Entrada_Marcada=" + Entrada_Marcada +
                '}';
    }
}
