# Sistemas Operativos - Shell Personalizado en C

## Descripción del Proyecto

Implementación completa de un **shell interactivo** en C que replica las funcionalidades de shells Unix/Linux modernos. El proyecto incluye gestión de memoria avanzada, manejo de procesos, sistema de archivos y comandos internos, demostrando un dominio profundo de los conceptos fundamentales de sistemas operativos.

## Características Principales

- **Shell interactivo completo**: Intérprete de comandos con prompt personalizado
- **Gestión de memoria**: Allocación dinámica con malloc, mmap y memoria compartida
- **Sistema de archivos**: Navegación, creación, modificación y eliminación de archivos
- **Gestión de procesos**: Control de procesos hijo y manejo de señales
- **Historial de comandos**: Sistema persistente de comandos ejecutados
- **Estructuras de datos**: Listas enlazadas dinámicas para gestión interna
- **Interfaz de usuario**: Colores ANSI y feedback visual mejorado

##  Arquitectura del Sistema

### Núcleo del Shell
- **`main.c`**: Motor principal del shell con bucle de interpretación
- **`commands.h`**: Definiciones y documentación de todos los comandos
- **`list.h/c`**: Implementación de estructuras de datos dinámicas
- **ShellData**: Estructura central que mantiene el estado del shell

### Módulos Funcionales

#### Comandos de Sistema
- **`autores`**: Información de desarrolladores y créditos
- **`pid`**: Gestión de identificadores de proceso
- **`infosis`**: Información detallada del sistema
- **`fecha`**: Manejo de fecha y hora del sistema

#### Gestión de Archivos
- **`carpeta`**: Navegación por directorios (equivalente a cd)
- **`list`**: Listado de contenido con múltiples opciones
- **`create`**: Creación de archivos y directorios
- **`stat`**: Información detallada de archivos
- **`delete/deltree`**: Eliminación de archivos y directorios

#### Gestión de Memoria
- **`allocate`**: Reserva de memoria (malloc, mmap, shared memory)
- **`deallocate`**: Liberación de memoria y limpieza
- **`memory`**: Visualización del mapa de memoria
- **`memdump`**: Volcado hexadecimal de memoria
- **`memfill`**: Relleno de regiones de memoria

#### Gestión de Procesos
- **`execute`**: Ejecución de programas externos
- **`recurse`**: Función recursiva para testing de stack
- **Control de señales**: Manejo de SIGINT, SIGTERM, etc.

##  Stack Tecnológico

- **Lenguaje**: C estándar (C99/C11)
- **Compilación**: GCC, CMake, Makefile tradicional
- **APIs del Sistema**: POSIX, System V IPC, GNU/Linux
- **Bibliotecas**: libc, sys/mman.h, sys/shm.h, unistd.h
- **Memoria**: malloc, mmap, shared memory (shmget/shmat)
- **Herramientas**: Valgrind, GDB, strace para debugging
- **Control de versiones**: Git con .gitignore configurado

##  Configuración y Ejecución

### Requisitos Previos

- GCC 9.0+ con soporte POSIX completo
- Sistema Unix/Linux (Ubuntu, CentOS, macOS)
- CMake 3.20+ o Make tradicional
- Privilegios para memory mapping y shared memory

### Compilación y Ejecución

```bash
# Compilación con CMake
mkdir build && cd build
cmake ..
make

# Compilación tradicional con Make
make clean && make

# Ejecución del shell
./ShellSO

# Comandos de ejemplo
Shell$ autores
Shell$ list -long /home/user
Shell$ allocate -malloc 1024
Shell$ memory -blocks
Shell$ create -f archivo.txt
```

### Estructura del Proyecto

```
ShellSO/
├── main.c                     # Motor principal del shell
├── commands.h                 # Definiciones de comandos
├── list.c/list.h             # Estructuras de datos dinámicas
├── p2help.c/p2help.h         # Sistema de ayuda avanzado
├── CMakeLists.txt            # Configuración de construcción
├── Makefile                  # Compilación tradicional
└── docs/                     # Documentación técnica
    ├── infoP2.txt           # Especificaciones de memoria
    └── ejemplos/            # Archivos de prueba
```

## Implementaciones Destacadas

### Shell Interactivo Avanzado
- **Parser de comandos**: Análisis sintáctico robusto con tokenización
- **Autocompletado**: Sugerencias de comandos y rutas
- **Historial persistente**: Navegación con flechas arriba/abajo
- **Prompt dinámico**: Información contextual del estado actual

### Gestión de Memoria Profesional
- **Múltiples allocadores**: malloc, mmap, shared memory
- **Tracking de memoria**: Lista de asignaciones activas
- **Detección de leaks**: Verificación de liberación completa
- **Visualización hexadecimal**: Dump de contenido de memoria

### Sistema de Archivos Completo
- **Navegación robusta**: Soporte para rutas absolutas y relativas
- **Listado avanzado**: Opciones recursivas, archivos ocultos, formato largo
- **Metadatos completos**: Permisos, propietarios, timestamps
- **Enlaces simbólicos**: Detección y seguimiento de links

### Control de Procesos
- **Fork y exec**: Creación de procesos hijo
- **Manejo de señales**: Interceptación y procesamiento
- **Control de jobs**: Procesos en background y foreground
- **Recursión controlada**: Testing de límites del stack

## Competencias Técnicas Demostradas

- **Programación de sistemas**: Desarrollo de bajo nivel en C con APIs del SO
- **Gestión de memoria**: Implementación de allocadores y debugging de leaks
- **Sistemas de archivos**: Manipulación avanzada del filesystem Unix
- **Programación concurrent**: Manejo de procesos y comunicación inter-proceso
- **Debugging de sistemas**: Uso de herramientas profesionales (GDB, Valgrind)
- **Arquitectura de software**: Diseño modular de sistemas complejos
- **Optimización de rendimiento**: Algoritmos eficientes para operaciones críticas

## Algoritmos y Técnicas del Sistema

### Gestión de Memoria
- **Allocación dinámica**: Estrategias de malloc con fragmentación mínima
- **Memory mapping**: Archivos mapeados en memoria para E/O eficiente
- **Shared memory**: Comunicación inter-proceso con segmentos compartidos
- **Garbage collection**: Limpieza automática de recursos no utilizados

### Estructuras de Datos
- **Listas enlazadas**: Implementación genérica con void* para cualquier tipo
- **Hash tables**: Búsqueda rápida de comandos y variables
- **Árboles de directorios**: Representación eficiente del filesystem
- **Buffers circulares**: Gestión del historial de comandos

### Algoritmos de Sistema
- **Parsing de comandos**: Análisis léxico y sintáctico
- **Resolución de rutas**: Algoritmo de navegación de directorios
- **Scheduling**: Gestión de orden de ejecución de comandos
- **Signal handling**: Procesamiento asíncrono de eventos

## Características Avanzadas del Sistema

### Robustez y Seguridad
- **Validación de entrada**: Sanitización de comandos maliciosos
- **Control de errores**: Manejo exhaustivo de condiciones de error
- **Límites de recursos**: Prevención de agotamiento de memoria/CPU
- **Permisos de archivos**: Verificación de acceso antes de operaciones

### Usabilidad y UX
- **Colores ANSI**: Interfaz visual mejorada con código de colores
- **Mensajes informativos**: Feedback claro sobre operaciones
- **Sistema de ayuda**: Documentación integrada de comandos
- **Compatibilidad**: Comportamiento similar a bash/zsh

---

##  Contexto Académico

**Universidad de A Coruña (UDC)** | Facultad de Informática | Sistemas Operativos (2021-2022)

*Proyecto desarrollado aplicando conceptos fundamentales de sistemas operativos y programación de sistemas en entorno Unix/Linux.*
