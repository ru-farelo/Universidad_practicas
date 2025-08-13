package es.udc.ws.app.client.service.dto;

import java.time.LocalDateTime;

public class ClientPartidoDto {
    private Long PartidoId;
    private String Equipo_Visitante;
    private LocalDateTime Fecha_Del_partido;
    private float Precio_Partido;
    private int Unidades_disponibles;

    public ClientPartidoDto() {
    }
    public ClientPartidoDto(Long partidoId, String equipo_Visitante, LocalDateTime fecha_Del_partido, float precio_Partido, int unidades_disponibles) {
        PartidoId = partidoId;
        Equipo_Visitante = equipo_Visitante;
        Fecha_Del_partido = fecha_Del_partido;
        Precio_Partido = precio_Partido;
        Unidades_disponibles = unidades_disponibles;

    }




    public Long getPartidoId() {
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

    @Override
    public String toString() {
        return "RestPartidoDto{" +
                "PartidoId=" + PartidoId +
                ", Equipo_Visitante='" + Equipo_Visitante + '\'' +
                ", Fecha_Del_partido=" + Fecha_Del_partido +
                ", Precio_Partido=" + Precio_Partido +
                ", Unidades_disponibles=" + Unidades_disponibles +
                '}';
    }

}
