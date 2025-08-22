# Recuperación de la Información (RI)

 Desarrollo de motor de búsqueda web y servidor HTTP multihilo en Java, con Apache Lucene y crawling masivo.

## Sistemas de Indexación y Búsqueda con Apache Lucene

Este repositorio contiene el desarrollo de **dos proyectos principales** en la asignatura de Recuperación de la Información, demostrando competencias avanzadas en sistemas de búsqueda, indexación de documentos y procesamiento de contenido web.

## Objetivos de Aprendizaje

- **Motores de Búsqueda**: Implementación de sistemas de indexación y recuperación con Apache Lucene
- **Procesamiento Web**: Crawling, parsing y almacenamiento de contenido HTML
- **Análisis de Texto**: Aplicación de algoritmos TF-IDF y vectores de términos
- **Programación de Redes**: Desarrollo de servidores web y protocolos HTTP

## Proyectos Desarrollados

### 1. Web Indexer - Motor de Búsqueda con Lucene
**Sistema completo de indexación web multihilo**

#### Funcionalidades Principales
- **Crawling Web Multihilo**: Descarga paralela de contenido desde URLs
- **Indexación Lucene**: Creación de índices optimizados con múltiples campos
- **Análisis de Texto**: Soporte para analizadores Standard, English y Spanish
- **Almacenamiento Dual**: Archivos `.loc` (contenido completo) y `.loc.notags` (texto limpio)
- **Métricas Avanzadas**: Cálculo de TF-IDF, term vectors y estadísticas de documentos

#### Arquitectura del Sistema
```java
// Procesamiento multihilo con ExecutorService
ExecutorService executor = Executors.newFixedThreadPool(numThreads);
// Indexación con diferentes analizadores
Analyzer analyzer = new StandardAnalyzer() | EnglishAnalyzer() | SpanishAnalyzer()
// Campos especializados con term vectors opcionales
FieldType titleType/bodyType con storeTermVectors configurable
```

#### Tecnologías Clave
- **Apache Lucene 9.8.0**: Motor de búsqueda de alto rendimiento
- **JSoup 1.14.3**: Parser HTML robusto para extracción de contenido
- **Java HTTP Client**: Cliente HTTP moderno con manejo de redirecciones
- **Concurrencia Java**: ExecutorService para procesamiento paralelo

### 2. Analizadores de Términos
**Herramientas de análisis estadístico de corpus indexados**

#### TopTermsInDoc - Análisis de Documentos Específicos
- **Cálculo TF-IDF**: Implementación completa del algoritmo Term Frequency × Inverse Document Frequency
- **Ranking de Términos**: Ordenación por relevancia estadística
- **Búsqueda por URL**: Localización automática de documentos por URL
- **Export de Resultados**: Salida formateada a archivos de texto

#### TopTermsInField - Análisis de Campos Globales
- **Document Frequency**: Cálculo de frecuencia de términos en toda la colección
- **Análisis de Vocabulario**: Identificación de términos más comunes por campo
- **Estadísticas de Corpus**: Métricas agregadas de la colección completa

### 3. Servidor Web HTTP
**Implementación completa de servidor web multihilo**

#### Características del Servidor
- **Protocolo HTTP/1.1**: Implementación completa con códigos de estado estándar
- **Multithreading**: Manejo concurrente de múltiples conexiones
- **Cabeceras HTTP**: Soporte completo para Date, Last-Modified, Content-Type, etc.
- **Conditional Requests**: Implementación de If-Modified-Since para caching
- **Content Negotiation**: Detección automática de tipos MIME

#### Funcionalidades Avanzadas
- **Timeout Management**: Control de timeouts de conexión y socket
- **Error Handling**: Páginas de error personalizadas (400, 403, 404)
- **Static File Serving**: Servicio de archivos estáticos con múltiples tipos
- **Configuration Driven**: Configuración externa mediante properties

##  Stack Tecnológico Completo

### Motor de Búsqueda y Análisis
| Tecnología | Propósito | Versión |
|------------|-----------|---------|
| **Apache Lucene** | Motor de búsqueda e indexación | 9.8.0 |
| **JSoup** | Parser y manipulación HTML | 1.14.3 |
| **Apache Commons Math** | Cálculos estadísticos | 3.6 |
| **Google Guice** | Inyección de dependencias | 5.1.0 |

### Desarrollo y Testing
| Tecnología | Propósito | Versión |
|------------|-----------|---------|
| **Java** | Lenguaje principal | 11+ |
| **Maven** | Gestión de dependencias | 3.x |
| **JUnit Jupiter** | Framework de testing | 5.4.2 |

### Servidor Web
| Tecnología | Propósito |
|------------|-----------|
| **Java Socket API** | Comunicación de red |
| **Java NIO** | I/O no bloqueante |
| **Properties** | Configuración externa |

## Arquitectura de Proyectos

```
Recuperación_de_la_Informacion/
├── mri-webindexer-fernandez-santos-main/    # Motor de Búsqueda
│   ├── src/main/java/
│   │   ├── WebIndexer.java                  # Indexador principal multihilo
│   │   ├── TopTermsInDoc.java               # Análisis TF-IDF por documento
│   │   └── TopTermsInField.java             # Análisis DF por campo
│   ├── src/main/resources/
│   │   └── config.properties                # Configuración de dominios
│   └── src/test/resources/urls/             # URLs para indexación
└── java-labs-ruben-fernandez-farelo-main/   # Servidor Web
    ├── src/es/udc/redes/webserver/
    │   ├── WebServer.java                   # Servidor principal
    │   └── ServerThread.java                # Hilo de manejo de conexiones
    └── p1-files/
        └── server.properties                # Configuración del servidor
```

## Competencias Técnicas Demostradas

### Sistemas de Información y Búsqueda
- **Apache Lucene**: Dominio completo del framework de búsqueda más utilizado en la industria
- **Indexación Avanzada**: Creación de índices optimizados con múltiples campos y term vectors
- **Algoritmos de Ranking**: Implementación de TF-IDF y métricas de relevancia
- **Análisis de Texto**: Procesamiento con analizadores especializados por idioma

### Programación de Redes y Web
- **Protocolo HTTP**: Implementación completa de servidor web conforme a estándares
- **Programación Concurrente**: Manejo eficiente de múltiples conexiones simultáneas
- **Web Crawling**: Descarga y procesamiento de contenido web a gran escala
- **Parsing HTML**: Extracción robusta de contenido con JSoup

### Arquitectura de Software
- **Multithreading**: Diseño de sistemas paralelos eficientes
- **Manejo de Recursos**: Gestión correcta de conexiones y memoria
- **Configuración Externa**: Sistemas configurables y mantenibles
- **Manejo de Errores**: Implementación robusta con recovery automático

## Casos de Uso Implementados

### 1. Indexación Web Masiva
```bash
# Indexar sitios web con configuración personalizada
WebIndexer -index ./mi_indice -docs ./documentos -numThreads 8 
          -analyzer Spanish -titleTermVectors -bodyTermVectors
```

### 2. Análisis de Relevancia
```bash
# Encontrar términos más relevantes en un documento
TopTermsInDoc -index ./mi_indice -field body -top 20 
             -url "https://example.com" -outfile resultados.txt

# Analizar vocabulario global
TopTermsInField -index ./mi_indice -field title -top 50 
               -outfile vocabulario.txt
```

### 3. Servidor Web de Producción
```bash
# Configurar y ejecutar servidor web
java WebServer  # Lee configuración de server.properties
# Soporte para archivos estáticos, error handling y caching HTTP
```

## Características Avanzadas

### Sistema de Indexación
- **Escalabilidad**: Procesamiento multihilo para grandes volúmenes de datos
- **Flexibilidad**: Configuración de analizadores según idioma y dominio
- **Eficiencia**: Optimización de memoria y almacenamiento
- **Robustez**: Manejo de errores de red y timeouts

### Análisis Estadístico
- **Algoritmos Estándar**: Implementación fiel de TF-IDF y Document Frequency
- **Métricas Avanzadas**: Cálculo de term vectors y estadísticas de corpus
- **Visualización**: Export formateado para análisis posterior
- **Performance**: Optimización para análisis de grandes colecciones

### Servidor Web
- **HTTP/1.1 Compliant**: Implementación estándar del protocolo
- **Production Ready**: Manejo robusto de conexiones y errores
- **Caching**: Soporte para conditional requests y ETag
- **Configurabilidad**: Adaptable a diferentes entornos de despliegue

## 🎖Logros Destacados

- **Motor de Búsqueda Completo**: Implementación desde cero de sistema de indexación y recuperación
- **Algoritmos de RI**: Dominio de técnicas fundamentales de recuperación de información
- **Servidor HTTP Robusto**: Desarrollo de servidor web conforme a estándares industriales
- **Programación Concurrente**: Diseño eficiente de sistemas multihilo de alto rendimiento
- **Análisis de Big Data**: Procesamiento y análisis de grandes volúmenes de contenido web

Este conjunto de proyectos demuestra competencias avanzadas en **sistemas de búsqueda**, **procesamiento de datos a gran escala**, **programación de redes** y **algoritmos de recuperación de información**, preparando para roles especializados en search engineering, data engineering y backend development de sistemas de información.
