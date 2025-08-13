# Internet y Sistemas Distribuidos (ISD)
## Desarrollo de Sistemas Web Distribuidos con Arquitectura SOA

Este repositorio contiene el desarrollo completo de un **sistema de gestión de entradas de fútbol** implementado como servicio web distribuido, demostrando competencias avanzadas en arquitectura de software, servicios web y desarrollo empresarial.

## 🎯 Objetivos de Aprendizaje

- **Arquitectura de Servicios Web**: Implementación de sistemas distribuidos con protocolo REST y Apache Thrift
- **Desarrollo Empresarial**: Aplicación de patrones enterprise con Maven, Spring y tecnologías Java EE
- **Persistencia de Datos**: Gestión de bases de datos relacionales con MySQL y SQL
- **Protocolos de Comunicación**: Implementación dual REST/Thrift para máxima interoperabilidad

## ⚡ Sistema Desarrollado: Gestión de Entradas de Fútbol

### Arquitectura del Sistema
- **Arquitectura Multicapa**: Separación clara entre modelo, servicio y cliente
- **Dual Protocol Support**: Implementación simultánea REST y Apache Thrift
- **Gestión de Estado**: Transacciones distribuidas y control de concurrencia
- **Validación Robusta**: Manejo integral de excepciones y validación de datos

### Funcionalidades Principales

#### 🎫 Gestión de Partidos
- **Creación de partidos**: Alta de eventos deportivos con validación de datos
- **Búsqueda avanzada**: Filtrado por fechas y disponibilidad de entradas
- **Gestión de inventario**: Control en tiempo real de entradas disponibles
- **Eliminación controlada**: Borrado solo de partidos ya celebrados

#### 💳 Sistema de Ventas
- **Compra de entradas**: Procesamiento de transacciones con validación de tarjetas
- **Gestión de usuarios**: Historial completo de compras por usuario
- **Control de disponibilidad**: Verificación de stock en tiempo real
- **Marcado de entradas**: Sistema de validación para entrada al estadio

#### 🔍 Consultas Especializadas
- **Búsqueda por fechas**: Filtrado de partidos en rangos temporales
- **Partidos con pocas entradas**: Identificación de eventos con baja demanda
- **Historial de compras**: Consulta completa de transacciones por usuario

## 🛠️ Stack Tecnológico

### Backend y Servicios
| Tecnología | Propósito | Versión |
|------------|-----------|---------|
| **Java** | Lenguaje principal | 17 |
| **Maven** | Gestión de dependencias | 3.x |
| **Apache Thrift** | Protocolo RPC binario | 0.19.0 |
| **Jackson** | Serialización JSON | 2.15.2 |
| **Jakarta Servlet** | APIs web empresariales | 5.0.0 |

### Persistencia y Base de Datos
| Tecnología | Propósito | Versión |
|------------|-----------|---------|
| **MySQL** | Base de datos relacional | 8.0.33 |
| **JDBC** | Conectividad base de datos | MySQL Connector/J |
| **Apache Commons DBCP** | Pool de conexiones | 2.9.0 |

### Servidores y Despliegue
| Tecnología | Propósito | Versión |
|------------|-----------|---------|
| **Jetty** | Servidor de desarrollo | 11.0.15 |
| **Apache Tomcat** | Servidor de producción | Compatible |
| **WS-Util** | Utilidades web services | 3.7.0 |

## 📊 Arquitectura del Proyecto

```
isd-055-master/
├── ws-app-model/                   # Capa de Modelo
│   ├── src/main/java/             # Entidades y lógica de negocio
│   └── src/sql/                   # Scripts de base de datos
├── ws-app-service/                # Capa de Servicio
│   ├── restservice/               # Implementación REST API
│   │   ├── servlets/              # Controladores HTTP
│   │   ├── dto/                   # Objetos de transferencia
│   │   └── json/                  # Conversores JSON
│   └── thriftservice/             # Implementación Thrift
│       ├── ThriftPartidoService*  # Servicios Thrift
│       └── *Conversor.java        # Conversores de datos
├── ws-app-thrift/                 # Definiciones Thrift
│   └── src/main/thrift/          # Archivos .thrift IDL
├── ws-app-client/                 # Cliente de Aplicación
│   ├── service/                   # Abstracciones de servicio
│   │   ├── rest/                  # Cliente REST
│   │   └── thrift/                # Cliente Thrift
│   └── ui/                        # Interfaz de línea de comandos
└── pom.xml                        # Configuración Maven principal
```

## 🚀 Competencias Técnicas Demostradas

### Desarrollo de Sistemas Distribuidos
- **Servicios Web REST**: Implementación completa con operaciones CRUD
- **Apache Thrift**: Protocolo RPC de alto rendimiento para comunicación inter-servicios
- **Arquitectura SOA**: Diseño orientado a servicios con separación de responsabilidades
- **Gestión de Estado**: Transacciones distribuidas y control de concurrencia

### Tecnologías Empresariales
- **Java Enterprise**: Utilización de Jakarta Servlet, JDBC y patrones enterprise
- **Maven Multi-Module**: Gestión de proyectos complejos con múltiples módulos
- **Bases de Datos**: Diseño relacional, transacciones y optimización de consultas
- **Servidores de Aplicaciones**: Despliegue en Jetty y Tomcat

### Protocolo y Comunicación
- **RESTful API Design**: Implementación de principios REST con códigos HTTP apropiados
- **Thrift IDL**: Definición de interfaces con Interface Definition Language
- **Serialización de Datos**: JSON y protocolos binarios para máximo rendimiento
- **Manejo de Excepciones**: Sistema robusto de gestión de errores distribuidos

### Calidad y Mantenibilidad
- **Separación de Capas**: Arquitectura limpia con responsabilidades bien definidas
- **Patrones de Diseño**: Factory, DTO, Converter patterns
- **Testing**: Configuración de entornos de prueba con bases de datos dedicadas
- **Documentación**: Código autodocumentado y estructura clara

## 💼 Casos de Uso Implementados

### 1. Gestión de Eventos Deportivos
```bash
# Crear nuevo partido
PartidoServiceClient -addMatch "Real Madrid" "2024-03-15T20:00:00" 50.0 10000

# Buscar partidos por fecha
PartidoServiceClient -findMatches "2024-03-31T23:59:59"
```

### 2. Sistema de Ventas
```bash
# Comprar entradas
PartidoServiceClient -buy 1 "usuario@email.com" 2 "4916119711304546"

# Consultar compras de usuario
PartidoServiceClient -findPurchases "usuario@email.com"
```

### 3. Validación y Control
```bash
# Marcar entrada como usada
PartidoServiceClient -collect 1 "4916119711304546"

# Eliminar partido celebrado
PartidoServiceClient -removeMatch 1
```

## 📈 Características Avanzadas

- **Alta Disponibilidad**: Arquitectura preparada para balanceadores de carga
- **Escalabilidad**: Diseño que permite escalado horizontal
- **Interoperabilidad**: Soporte dual REST/Thrift para diferentes tipos de clientes
- **Robustez**: Manejo integral de errores y validaciones exhaustivas
- **Performance**: Optimización de consultas y gestión eficiente de recursos

## 🎖️ Logros Destacados

- **Arquitectura Empresarial**: Implementación de patrones enterprise estándar de la industria
- **Dual Protocol**: Capacidad única de servir tanto REST como Thrift desde la misma lógica de negocio
- **Gestión Transaccional**: Control de concurrencia y consistencia de datos en entorno distribuido
- **Código Production-Ready**: Estructura preparada para entornos de producción empresarial

Este proyecto demuestra competencias avanzadas en **desarrollo de sistemas distribuidos**, **arquitectura de software empresarial** y **tecnologías Java enterprise**, preparando para roles senior en desarrollo backend, arquitectura de sistemas y ingeniería de software.
