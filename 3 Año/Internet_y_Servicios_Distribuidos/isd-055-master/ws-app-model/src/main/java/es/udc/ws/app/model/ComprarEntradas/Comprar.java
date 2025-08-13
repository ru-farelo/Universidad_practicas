package es.udc.ws.app.model.ComprarEntradas;

import java.time.LocalDateTime;
import java.util.Objects;

public class Comprar {
   private Long EntradaId;
   private String Correo;
   private String Tarjeta_de_credito;
   private int Unidades_a_comprar;
   private LocalDateTime Fecha_de_compra;
   private Long partidoId;
   private boolean Entrada_Marcada;

    public Comprar(Long entradaId, String correo, String tarjeta_de_credito, int unidades_a_comprar, LocalDateTime fecha_de_compra, Long partidoId, boolean entrada_Marcada) {
        EntradaId = entradaId;
        Correo = correo;
        Tarjeta_de_credito = tarjeta_de_credito;
        Unidades_a_comprar = unidades_a_comprar;
        Fecha_de_compra = fecha_de_compra;
        this.partidoId = partidoId;
        Entrada_Marcada = entrada_Marcada;
    }

    public Comprar(String correo, String tarjeta_de_credito, int unidades_a_comprar, LocalDateTime fecha_de_compra, Long partidoId, boolean entrada_Marcada) {
        Correo = correo;
        Tarjeta_de_credito = tarjeta_de_credito;
        Unidades_a_comprar = unidades_a_comprar;
        Fecha_de_compra = fecha_de_compra;
        this.partidoId = partidoId;
        Entrada_Marcada = entrada_Marcada;
    }




    public Long getEntradaId() {
        return EntradaId;
    }

    public void setEntradaId(Long entradaId) {
        EntradaId = entradaId;
    }

    public String getCorreo() {
        return Correo;
    }

    public void setCorreo(String correo) {
        Correo = correo;
    }

    public String getTarjeta_de_credito() {
        return Tarjeta_de_credito;
    }

    public void setTarjeta_de_credito(String tarjeta_de_credito) {
        Tarjeta_de_credito = tarjeta_de_credito;
    }

    public int getUnidades_a_comprar() {
        return Unidades_a_comprar;
    }

    public void setUnidades_a_comprar(int unidades_a_comprar) {
        Unidades_a_comprar = unidades_a_comprar;
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
        this.Entrada_Marcada = entrada_Marcada;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Comprar comprar = (Comprar) o;
        return Unidades_a_comprar == comprar.Unidades_a_comprar && Entrada_Marcada == comprar.Entrada_Marcada && Objects.equals(EntradaId, comprar.EntradaId) && Objects.equals(Correo, comprar.Correo) && Objects.equals(Tarjeta_de_credito, comprar.Tarjeta_de_credito) && Objects.equals(Fecha_de_compra, comprar.Fecha_de_compra) && Objects.equals(partidoId, comprar.partidoId);
    }

    @Override
    public int hashCode() {
        return Objects.hash(EntradaId, Correo, Tarjeta_de_credito, Unidades_a_comprar, Fecha_de_compra, partidoId, Entrada_Marcada);
    }

    @Override
    public String toString() {
        return "Comprar{" +
                "EntradaId=" + EntradaId +
                ", Correo='" + Correo + '\'' +
                ", Tarjeta_de_credito='" + Tarjeta_de_credito + '\'' +
                ", Unidades_a_comprar=" + Unidades_a_comprar +
                ", Fecha_de_compra=" + Fecha_de_compra +
                ", partidoId=" + partidoId +
                ", Entrada_Marcada=" + Entrada_Marcada +
                '}';
    }
}
