# Servidor Web HTTP - Prácticas de Redes

## Descripción del Proyecto

Este proyecto implementa un **servidor web HTTP multihilo** desarrollado en Java como parte de las prácticas de la asignatura de Redes de la Universidad de A Coruña (UDC). El servidor es capaz de procesar peticiones HTTP concurrentemente y servir contenido estático y dinámico.

## Características Principales

- **Servidor HTTP multihilo**: Manejo concurrente de múltiples peticiones de clientes
- **Arquitectura orientada a objetos**: Implementación modular con separación clara de responsabilidades
- **Gestión de contenido estático**: Servir archivos HTML, imágenes y otros recursos
- **Servlets dinámicos**: Implementación de servlets personalizados para contenido dinámico
- **Configuración flexible**: Sistema de configuración basado en archivos properties
- **Gestión de errores HTTP**: Páginas de error personalizadas (400, 403, 404)
- **Sistema de logging**: Registro de accesos y errores del servidor

##  Arquitectura del Sistema

### Componentes Principales

- **`WebServer.java`**: Clase principal que gestiona el socket servidor y acepta conexiones
- **`ServerThread.java`**: Hilo de trabajo que procesa cada petición HTTP individualmente
- **`ServerUtils.java`**: Utilidades comunes para el procesamiento de peticiones
- **`MiniServlet.java`**: Interfaz base para servlets dinámicos
- **Servlets personalizados**: Implementaciones específicas para diferentes funcionalidades

### Estructura de Directorios

```
src/
└── es/udc/redes/webserver/     # Código fuente del servidor
p0-files/                       # Recursos de la práctica 0
p1-files/                       # Recursos de la práctica 1
├── error/                      # Páginas de error HTTP
├── log/                        # Archivos de registro
└── javadoc/                    # Documentación generada
```

##  Stack Tecnológico

- **Lenguajes**: Java SE 8+
- **Redes**: Sockets TCP/IP, Protocolo HTTP/1.1
- **Concurrencia**: Java Threading API, Programación multihilo
- **Patrones de Diseño**: Singleton, Observer, Template Method
- **Herramientas**: IntelliJ IDEA, Maven/Gradle compatible
- **Control de Versiones**: Git, GitHub
- **Testing**: JUnit (framework preparado)
- **Documentación**: JavaDoc

##  Configuración y Ejecución

### Requisitos Previos

- Java JDK 8 o superior
- IntelliJ IDEA (recomendado)
- Git

### Configuración del Servidor

El servidor se configura mediante el archivo `p1-files/server.properties`:

```properties
PORT=1111
DIRECTORY_INDEX=index.html
ALLOW=.html .gif .jpeg .jpg .png .txt
TIMEOUT=300
```

### Compilación y Ejecución

```bash
# Compilar el proyecto
javac -d out src/es/udc/redes/webserver/*.java

# Ejecutar el servidor
java -cp out es.udc.redes.webserver.WebServer
```

## Funcionalidades Implementadas

### Práctica 0 (P0)
- Configuración del entorno de desarrollo Java
- Familiarización con Git y GitHub
- Estructura básica del proyecto

### Práctica 1 (P1) - Servidor HTTP Completo
- **Servidor HTTP multihilo**: Pool de threads para manejo concurrente de peticiones
- **Parser HTTP**: Análisis y procesamiento de headers y métodos HTTP
- **Gestión de recursos**: Servicio de archivos estáticos con MIME types
- **Manejo de errores**: Implementación completa de códigos de estado HTTP (200, 400, 403, 404)
- **Sistema de logging**: Registro detallado de accesos y errores con timestamps
- **Servlets dinámicos**: Arquitectura extensible para contenido generado dinámicamente
- **Configuración externa**: Sistema de propiedades para parámetros del servidor

## Competencias Técnicas Demostradas

- **Programación de sistemas**: Implementación de servidor de red de alto rendimiento
- **Programación concurrente**: Gestión avanzada de threads, sincronización y pool de hilos
- **Arquitectura de software**: Diseño modular con principios SOLID y patrones de diseño
- **Protocolos de red**: Implementación completa del protocolo HTTP/1.1 desde cero
- **Java avanzado**: APIs de red (java.net), I/O streams, manejo de excepciones
- **DevOps básico**: Configuración de entornos, gestión de dependencias
- **Metodologías**: Desarrollo incremental, testing, documentación técnica

## Logros Técnicos Alcanzados

Este proyecto demuestra la capacidad de:
- **Arquitectura de sistemas**: Diseñar e implementar un servidor web completo desde cero
- **Programación concurrente**: Aplicar patrones de concurrencia en aplicaciones de producción
- **Protocolos de comunicación**: Dominar la implementación de estándares de Internet
- **Código mantenible**: Desarrollar software escalable siguiendo buenas prácticas
- **Herramientas profesionales**: Gestionar proyectos con Git y IDEs especializados
- **Resolución de problemas**: Implementar soluciones robustas para sistemas distribuidos

---

##  Contexto Académico

**Universidad de A Coruña (UDC)** | Facultad de Informática | Redes (2020-2021)

*Proyecto desarrollado aplicando metodologías de ingeniería de software y estándares industriales.*
