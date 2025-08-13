namespace java es.udc.ws.app.thrift

struct ThriftPartidoDto {
    1: i64 PartidoId,
    2: string Equipo_Visitante,
    3: string Fecha_Partido,
    4: double Precio_Partido,
    5: i32 Unidades_disponibles,
}

exception ThriftInputValidationException {
    1: string message
}

exception ThriftInstanceNotFoundException {
     1: string instanceId
     2: string instanceType
}


service ThriftPartidoService {
    ThriftPartidoDto CrearPartido(1: ThriftPartidoDto partidoDto) throws (1: ThriftInputValidationException ex),
    ThriftPartidoDto BuscarPartidoPorId(1: i64 PartidoId) throws (1: ThriftInstanceNotFoundException ex),

}
