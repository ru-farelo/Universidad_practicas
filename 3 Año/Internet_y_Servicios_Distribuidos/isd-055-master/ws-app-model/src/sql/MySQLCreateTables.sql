DROP TABLE comprar_entradas;
DROP TABLE Partido;


CREATE TABLE Partido (
                         PartidoID BIGINT NOT NULL AUTO_INCREMENT,
                         Equipo_visitante VARCHAR(30) COLLATE latin1_bin NOT NULL,
                         Fecha_del_partido DATETIME NOT NULL,
                         Precio_Partido REAL NOT NULL,
                         Unidades_disponibles INTEGER NOT NULL,
                         Fecha_de_alta_del_partido DATETIME NOT NULL,
                         Entradas_vendidas_del_partido INTEGER NOT NULL,
                         CONSTRAINT PartidoPK PRIMARY KEY(PartidoID));


CREATE TABLE comprar_entradas (
                            entradaID BIGINT NOT NULL AUTO_INCREMENT,
                            Correo VARCHAR(50) COLLATE latin1_bin NOT NULL,
                            Tarjeta_de_credito VARCHAR(16) NOT NULL,
                            Unidades_a_comprar INTEGER NOT NULL,
                            Fecha_de_compra DATETIME NOT NULL,
                            partidoID BIGINT NOT NULL,
                            Entrada_Marcada  BOOLEAN NOT NULL,
                            CONSTRAINT comprar_entradasPK PRIMARY KEY(entradaID),
                            CONSTRAINT EventoAlQueResponde FOREIGN KEY(partidoID)
                                REFERENCES Partido(PartidoID) ON DELETE CASCADE ) ENGINE = InnoDB;