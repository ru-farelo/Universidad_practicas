# Concurrencia y Paralelismo - Sistemas Distribuidos en C

**Resumen:** Proyecto académico avanzado que demuestra competencias en programación concurrente, paralela y distribuida usando C/C++ con pthreads y MPI. Incluye implementaciones desde sincronización básica hasta arquitecturas distribuidas de alto rendimiento, optimizadas para entornos multiprocesador.

## Descripción del Proyecto

Conjunto de implementaciones avanzadas en **programación concurrente y paralela** utilizando C/C++ y tecnologías como **pthreads** y **MPI**. El proyecto abarca desde sincronización básica con mutex hasta sistemas distribuidos complejos, demostrando competencias en programación de sistemas de alto rendimiento.

## Características Principales

- **Programación multihilo**: Implementaciones con pthreads y sincronización avanzada
- **Sistemas distribuidos**: Comunicación inter-procesos con MPI (Message Passing Interface)
- **Estructuras de datos concurrentes**: Colas thread-safe y buffers circulares
- **Algoritmos paralelos**: Procesamiento distribuido de datos masivos
- **Análisis de rendimiento**: Benchmarking y optimización de algoritmos concurrentes
- **Gestión de memoria**: Manejo eficiente de recursos en entornos multihilo
- **Sincronización robusta**: Mutex, semáforos y variables de condición

##  Arquitectura del Proyecto

### Práctica 1 - Concurrencia con Pthreads
- **`arrayEj1.c`**: Acceso concurrente a arrays con mutex básicos
- **`arrayEj2.c`**: Optimizaciones de sincronización y granularidad de locks
- **`arrayEj3.c`**: Algoritmos avanzados de sincronización
- **`arrayEj4.c`**: Patrones de concurrencia complejos
- **`options.h/c`**: Framework de configuración y parsing de argumentos

### Práctica 2 - Sistemas Distribuidos y Hash MD5
- **`md5.c`**: Calculadora distribuida de hash MD5 con pool de threads
- **`queue.h/c`**: Implementación de cola thread-safe con productores/consumidores
- **Arquitectura productor-consumidor**: Pipeline de procesamiento de archivos
- **Gestión de directorios**: Exploración concurrente del sistema de archivos

### Práctica 3 - Paralelismo con MPI
- **`ejercicio1.c`**: Algoritmos distribuidos con comunicación punto a punto
- **`ejercicio21.c`**: Operaciones colectivas y reducción paralela
- **`ejercicio22.c`**: Patrones avanzados de comunicación MPI
- **`cuentaletras.c`**: Procesamiento paralelo de cadenas bioinformáticas

##  Stack Tecnológico

- **Lenguajes**: C/C++ (estándares C11/C++17)
- **Concurrencia**: POSIX Threads (pthreads), Mutex, Semáforos
- **Paralelismo**: MPI (Message Passing Interface), OpenMP
- **Herramientas**: GCC, Make, CMake, Valgrind
- **Bibliotecas**: OpenSSL (para MD5), LibC estándar
- **Sistemas**: Linux/Unix, sistemas multiprocesador
- **Debugging**: GDB, ThreadSanitizer, Helgrind

##  Configuración y Ejecución

### Requisitos Previos

- GCC 9.0+ con soporte POSIX
- OpenMPI o MPICH
- OpenSSL development libraries
- CMake 3.16+

### Compilación y Ejecución

```bash
# Práctica 1 - Concurrencia
cd p1-ruben-fernandez-farelo-roi-cabana-main/
make all
./arrayEj1 -t 4 -i 1000 -d 100

# Práctica 2 - Hash MD5 distribuido
cd p2-ruben-fernandez-farelo-roi-cabana-main/
make
./md5 -d /path/to/directory -t 8

# Práctica 3 - MPI Paralelismo
cd paralelismo-cp-main/
cmake .
make
mpirun -np 4 ./ejercicio1 1000000 A
```

## Implementaciones Destacadas

### Sincronización Avanzada con Pthreads
- **Mutex granular**: Optimización de locks por secciones críticas
- **Pool de threads**: Gestión eficiente de recursos de hilos
- **Patrones producer-consumer**: Implementación robusta con colas thread-safe
- **Análisis de race conditions**: Detección y prevención de condiciones de carrera

### Sistema de Hash MD5 Distribuido
- **Pipeline multietapa**: Arquitectura de procesamiento en flujo
- **Cola thread-safe**: Estructura de datos concurrente con sincronización
- **Exploración paralela**: Recorrido concurrente de directorios
- **Agregación de resultados**: Consolidación thread-safe de hashes

### Algoritmos Paralelos con MPI
- **Distribución de datos**: Particionamiento eficiente para procesamiento paralelo
- **Comunicación colectiva**: Uso de reduce, broadcast y gather
- **Balanceamiento de carga**: Distribución óptima de trabajo entre procesos
- **Análisis bioinformático**: Conteo paralelo de nucleótidos en secuencias ADN

### Estructuras de Datos Concurrentes
- **Cola circular thread-safe**: Implementación con mutex y variables de condición
- **Buffer compartido**: Gestión de memoria para productores múltiples
- **Gestión de estados**: Control de flujo y señalización entre threads

## Competencias Técnicas Demostradas

- **Programación de sistemas**: Desarrollo en C/C++ para sistemas de alto rendimiento
- **Concurrencia avanzada**: Diseño e implementación de algoritmos thread-safe
- **Sistemas distribuidos**: Arquitecturas paralelas con MPI y comunicación inter-proceso
- **Optimización de rendimiento**: Análisis y mejora de algoritmos concurrentes
- **Debugging concurrente**: Detección de deadlocks, race conditions y memory leaks
- **Arquitectura de software**: Diseño de sistemas escalables y robustos
- **Matemáticas aplicadas**: Análisis de complejidad paralela y teoría de colas

## Algoritmos y Patrones Implementados

### Patrones de Concurrencia
- **Producer-Consumer**: Pipeline de procesamiento con múltiples etapas
- **Reader-Writer**: Acceso concurrente con prioridad de lectores
- **Worker Pool**: Gestión eficiente de threads trabajadores
- **Fork-Join**: Paralelización con división y conquista

### Técnicas de Sincronización
- **Mutex exclusivos**: Protección de secciones críticas
- **Variables de condición**: Sincronización basada en eventos
- **Semáforos**: Control de acceso a recursos limitados
- **Barreras de sincronización**: Coordinación de fases paralelas

### Algoritmos Distribuidos
- **Map-Reduce**: Procesamiento distribuido de grandes volúmenes
- **Scatter-Gather**: Distribución y recolección de datos
- **Pipeline paralelo**: Procesamiento en cadena optimizado
- **Load Balancing**: Distribución dinámica de carga de trabajo

## Análisis de Rendimiento

### Métricas Implementadas
- **Speedup**: Análisis de aceleración con múltiples cores
- **Eficiencia paralela**: Utilización óptima de recursos computacionales
- **Escalabilidad**: Comportamiento con incremento de threads/procesos
- **Latencia vs Throughput**: Optimización de diferentes métricas de rendimiento

### Optimizaciones Aplicadas
- **Cache efficiency**: Localidad de datos y false sharing prevention
- **Memory management**: Reducción de fragmentación y overhead
- **Context switching**: Minimización de cambios de contexto
- **NUMA awareness**: Optimización para arquitecturas multi-socket

---

##  Contexto Académico

**Universidad de A Coruña (UDC)** | Facultad de Informática | Concurrencia y Paralelismo (2021-2022)

*Proyecto desarrollado aplicando técnicas avanzadas de programación paralela y sistemas distribuidos de alto rendimiento.*
