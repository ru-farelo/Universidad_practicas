#  Sistemas Operativos – Shell en C  

## Descripción  
Implementación de un **shell interactivo en C** que replica funcionalidades de Unix/Linux (memoria, procesos, sistema de archivos).  
Proyecto académico de la UDC orientado a demostrar dominio en **programación de sistemas y conceptos de SO**.  

## Funcionalidades Clave  
- Intérprete de comandos con **prompt interactivo**  
- **Gestión de memoria** (malloc, mmap, memoria compartida)  
- **Procesos y señales** (fork, exec, control de jobs)  
- **Sistema de archivos**: crear, listar, borrar y consultar metadatos  
- Historial de comandos persistente y autocompletado básico  

##  Stack Tecnológico  
- **Lenguaje**: C (C99/C11)  
- **APIs**: POSIX, System V IPC  
- **Herramientas**: GCC, GDB, Valgrind, Make/CMake  
- **Entorno**: Linux/Unix  

## Competencias Demostradas  
- Programación de bajo nivel en C y POSIX  
- Manejo de procesos, concurrencia y memoria  
- Diseño modular y depuración avanzada (Valgrind, GDB)  
- Desarrollo de **software de sistemas robusto**  

## 📂 Estructura del Repo

```plaintext
ShellSO/                         # Proyecto principal
├── src/                         # Código fuente
│   ├── main.c                   # Núcleo del shell (bucle principal)
│   ├── commands.h               # Definiciones de comandos
│   ├── commands.c               # Implementación de comandos
│   ├── list.h                   # Estructuras de datos dinámicas
│   ├── list.c                   # Implementación de listas enlazadas
│   └── utils.c                  # Funciones auxiliares (parsing, helpers)
│
├── include/                     # Headers organizados (si quieres modularidad)
│   └── *.h
│
├── tests/                       # Casos de prueba
│   └── test_commands.c
│
├── docs/                        # Documentación
│   ├── README_TECNICO.md        # Explicación completa (detallada)
│   ├── infoP2.txt               # Especificaciones de memoria/proyecto
│   └── ejemplos/                # Archivos de prueba para comandos
│
├── Makefile                     # Compilación tradicional
├── CMakeLists.txt               # Opción alternativa con CMake
├── README.md                    # Versión corta (para recruiters)
└── .gitignore                   # Ignorar binarios, temporales, etc.



## 🔗 Documentación Técnica  
Detalles completos de arquitectura, comandos y algoritmos en el [README_TECNICO.md](README_TECNICO.md).  

## 🔗 Documentación Técnica  
Detalles completos de arquitectura, comandos y algoritmos en el [README_TECNICO.md](README_TECNICO.md).  


