package es.udc.ws.app.model.Partido;

import java.time.LocalDateTime;
import java.util.Objects;

public class Partido {
    private Long PartidoId;
    private String Equipo_Visitante;
    private LocalDateTime Fecha_Del_partido;
    private float Precio_Partido;
    private int Unidades_disponibles;
    private LocalDateTime Fecha_de_alta_del_partido;
    private int Entradas_vendidas_del_partido;
    public Partido(Long partidoId, String equipoVisitante, LocalDateTime fechaDelPartido, float precioPartido, int unidadesDisponibles, int entradasVendidasDelPartido) {
        PartidoId = partidoId;
        Equipo_Visitante = equipoVisitante;
        Fecha_Del_partido = fechaDelPartido;
        Precio_Partido = precioPartido;
        Unidades_disponibles = unidadesDisponibles;
        Entradas_vendidas_del_partido = entradasVendidasDelPartido;
    }
    public Partido(Long partidoId, String equipo_Visitante, LocalDateTime fecha_Del_partido, float precio_Partido, int unidades_disponibles, LocalDateTime fecha_de_alta_del_partido, int entradas_vendidas_del_partido) {
        PartidoId = partidoId;
        Equipo_Visitante = equipo_Visitante;
        Fecha_Del_partido = fecha_Del_partido;
        Precio_Partido = precio_Partido;
        Unidades_disponibles = unidades_disponibles;
        Fecha_de_alta_del_partido = fecha_de_alta_del_partido;
        Entradas_vendidas_del_partido = entradas_vendidas_del_partido;
    }

    public Partido(Long partidoId, String equipoVisitante, LocalDateTime fechaDelPartido, float precioPartido, int unidadesDisponibles) {
        PartidoId = partidoId;
        Equipo_Visitante = equipoVisitante;
        Fecha_Del_partido = fechaDelPartido;
        Precio_Partido = precioPartido;
        Unidades_disponibles = unidadesDisponibles;

    }



    public Long getPartidoId()  {
        return PartidoId;
    }
    public void setPartidoId(Long partidoId) {
        PartidoId = partidoId;
    }

    public String getEquipo_Visitante() {
        return Equipo_Visitante;
    }

    public void setEquipo_Visitante(String equipo_Visitante) {
        Equipo_Visitante = equipo_Visitante;
    }

    public LocalDateTime getFecha_Del_partido() {
        return Fecha_Del_partido;
    }

    public void setFecha_Del_partido(LocalDateTime fecha_Del_partido) {
        Fecha_Del_partido = fecha_Del_partido;
    }

    public float getPrecio_Partido() {
        return Precio_Partido;
    }

    public void setPrecio_Partido(float precio_Partido) {
        Precio_Partido = precio_Partido;
    }

    public int getUnidades_disponibles() {
        return Unidades_disponibles;
    }

    public void setUnidades_disponibles(int unidades_disponibles) {
        Unidades_disponibles = unidades_disponibles;
    }

    public LocalDateTime getFecha_de_alta_del_partido() {
        return Fecha_de_alta_del_partido;
    }

    public void setFecha_de_alta_del_partido(LocalDateTime fecha_de_alta_del_partido) {
        Fecha_de_alta_del_partido = fecha_de_alta_del_partido;
    }

    public int getEntradas_vendidas_del_partido() {
        return Entradas_vendidas_del_partido;
    }

    public void setEntradas_vendidas_del_partido(int entradas_vendidas_del_partido) {
        Entradas_vendidas_del_partido = entradas_vendidas_del_partido;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        Partido partido = (Partido) o;
        return Float.compare(Precio_Partido, partido.Precio_Partido) == 0 && Unidades_disponibles == partido.Unidades_disponibles && Entradas_vendidas_del_partido == partido.Entradas_vendidas_del_partido && Objects.equals(PartidoId, partido.PartidoId) && Objects.equals(Equipo_Visitante, partido.Equipo_Visitante) && Objects.equals(Fecha_Del_partido, partido.Fecha_Del_partido) && Objects.equals(Fecha_de_alta_del_partido, partido.Fecha_de_alta_del_partido);
    }

    @Override
    public int hashCode() {
        return Objects.hash(PartidoId, Equipo_Visitante, Fecha_Del_partido, Precio_Partido, Unidades_disponibles, Fecha_de_alta_del_partido, Entradas_vendidas_del_partido);
    }

    @Override
    public String toString() {
        return "Partido{" +
                "PartidoId=" + PartidoId +
                ", Equipo_Visitante='" + Equipo_Visitante + '\'' +
                ", Fecha_Del_partido=" + Fecha_Del_partido +
                ", Precio_Partido=" + Precio_Partido +
                ", Unidades_disponibles=" + Unidades_disponibles +
                ", Fecha_de_alta_del_partido=" + Fecha_de_alta_del_partido +
                ", Entradas_vendidas_del_partido=" + Entradas_vendidas_del_partido +
                '}';
    }
}

